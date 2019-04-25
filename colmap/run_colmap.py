#! /usr/bin/python3
import argparse
import os
import os.path as osp
import re
import csv
import multiprocessing as mp
import tempfile
from glob import glob
import queue
import time
import shutil
import subprocess
import logging
import sys


def parse_args():
    parser = argparse.ArgumentParser(description='Run colmap reconstruction.')
    parser.add_argument('img_dir', type=str,
                        help='Path to images')
    parser.add_argument('--logfile', type=str, default=None,
                        help='Print to terminal if not specified')
    parser.add_argument('--res-dir', type=str, default=osp.join('..','colmap'),
                        help='Result dir, relative to image folder. Default: %(default)s ')
    parser.add_argument('--nbr-proc', type=int, default=4,
                        help='Number of processes')
    parser.add_argument('--skip-dense', dest='dense', action='store_false', default = True,
                        help='Skip dense reconstruction')
    parser.add_argument('--folder-pattern', type=str, default=None,
                        help='Used to batch process multiple folders. Pattern will be appended to img_dir')

    args = parser.parse_args()

    return args

class StreamToLogger(object):
   """
   Fake file-like stream object that redirects writes to a logger instance.
   """
   def __init__(self, logger, log_level=logging.INFO):
      self.logger = logger
      self.log_level = log_level
      self.linebuf = ''

   def write(self, buf):
      for line in buf.rstrip().splitlines():
         self.logger.log(self.log_level, line.rstrip())

   def flush(self):
       pass

def setup_mp_logger(logfile = None):
    logger = mp.get_logger()
    logger.setLevel(logging.INFO)
    if logfile:
        file_h = logging.FileHandler(logfile, mode='w')
        file_h.setFormatter( logging.Formatter('[%(asctime)s][%(levelname)s/%(processName)s] %(message)s'))
        logger.addHandler(file_h)
        sys.stdout = StreamToLogger(logger, logging.INFO)
        sys.stderr = StreamToLogger(logger, logging.ERROR)
    else:
        stream_h = logging.StreamHandler(sys.stdout)
        stream_h.setFormatter( logging.Formatter('[%(asctime)s][%(levelname)s/%(processName)s] %(message)s'))
        logger.addHandler(stream_h)

    return logger


class Colmap(mp.Process):
    def __init__(self, img_queue, relative_resdir, logger, dense = True):
        mp.Process.__init__(self)
        self.img_queue = img_queue
        self.relative_resdir = relative_resdir
        self.logger = logger
        self.dense = dense

    def auto_reconstruct(self, imgdir, resdir):
        # Abort if resdir exists
        if osp.exists(resdir):
            self.logger.error('{} exists, abort reconstruction'.format(resdir))
            return False

        # Use local temp dir as workspace for speed (assuming resdir is network folder)
        with tempfile.TemporaryDirectory() as tmpdir:
            s = self.auto_reconstruct_cmd(imgdir, tmpdir)

            shutil.copytree(tmpdir, resdir)

        return s

    def run_cmd(self, cmd):
        proc = subprocess.Popen(cmd, shell = True)

        try:
            while proc.poll() is None:
                time.sleep(0.1)
        except KeyboardInterrupt:
            proc.terminate()
            raise

        return proc.poll() == 0

    def auto_reconstruct_cmd(self, imgdir, resdir):
        col_cmd = """colmap automatic_reconstructor \
        --image_path {imgdir} \
        --workspace_path {resdir} \
        --single_camera=1 \
        --dense={dense}
        """.format(imgdir = imgdir, resdir = resdir, dense=self.dense)
        return self.run_cmd(col_cmd)


    def run(self):
        while True:
            try:
                img_dir = self.img_queue.get_nowait()
            except queue.Empty:
                return
            res_dir = osp.join(img_dir, self.relative_resdir)

            success = self.auto_reconstruct(img_dir, res_dir)

            if success:
                self.logger.info('Finished reconstructing {}'.format(img_dir))
            else:
                self.logger.error('Error reconstructing {}'.format(img_dir))


if __name__ == '__main__':
    args = parse_args()
    logger = setup_mp_logger(args.logfile)

    if args.folder_pattern:
        img_dir_list = glob(osp.join(args.img_dir, args.folder_pattern))
    else:
        img_dir_list = [args.img_dir]

    work_queue = mp.Queue()
    for img_dir in img_dir_list:
        work_queue.put(img_dir)

    procs = []
    time.sleep(0.1) #Give queue time to write
    while not work_queue.empty():
        # Create new process list
        alive_p = [p for p in procs if p.is_alive()]
        # Fill up with missing
        for new_i in range(args.nbr_proc - len(alive_p)):
            p = Colmap(work_queue, args.res_dir, logger, dense = args.dense)
            alive_p.append(p)
            p.start()
            time.sleep(0.2) # spread out spawning to ease GPU allocation
        procs = alive_p
        time.sleep(1)

    #Wait for processes to terminate
    for p in procs:
        p.join()

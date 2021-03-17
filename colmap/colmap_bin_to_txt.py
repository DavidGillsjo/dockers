#! /usr/bin/python3
import argparse
from run_colmap import Colmap, setup_mp_logger
import subprocess
import time
import os


def parse_args():
    parser = argparse.ArgumentParser(description='Convert all bin files recursively to txt')
    parser.add_argument('start_dir', type=str,
                        help='Path to start at')


    args = parser.parse_args()

    return args



def run_cmd(cmd):
    proc = subprocess.Popen(cmd, shell = True)

    try:
        while proc.poll() is None:
            time.sleep(0.1)
    except KeyboardInterrupt:
        proc.terminate()
        raise

    return proc.poll() == 0


def convert_to_txt(res_dir):
    for root, dirnames, filenames in os.walk(res_dir):
        if 'cameras.bin' in filenames:
            convert_to_txt_cmd(root)

def convert_to_txt_cmd(bin_dir):
    col_cmd = """colmap model_converter \
    --input_path {bin_dir} \
    --output_path {bin_dir} \
    --output_type TXT
    """.format(bin_dir = bin_dir)

    return run_cmd(col_cmd)


if __name__ == '__main__':
    args = parse_args()
    convert_to_txt(args.start_dir)

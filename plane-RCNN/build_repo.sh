#Supply repo path as argument

cd "$1"

cd nms/src/cuda/
nvcc -c -o nms_kernel.cu.o nms_kernel.cu -x cu -Xcompiler -fPIC -arch="$GPU_ARCH"
cd ../../
python3 build.py
cd ../


cd roialign/roi_align/src/cuda/
nvcc -c -o crop_and_resize_kernel.cu.o crop_and_resize_kernel.cu -x cu -Xcompiler -fPIC -arch="$GPU_ARCH"
cd ../../
python3 build.py
cd ../../

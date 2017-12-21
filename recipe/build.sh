mkdir build
cd build

if [ "$(uname)" == "Darwin" ]; then
  OPENCL_LIBRARIES=""
  HAVE_CLOCK_GETTIME=0
  INSTALL_OPENCL_HEADERS=ON
  EXTRA_HOST_LD_FLAGS="-dead_strip_dylibs"
else  # linux for now
  OPENCL_LIBRARIES="-L${PREFIX}/lib;OpenCL"
  HAVE_CLOCK_GETTIME=1
  INSTALL_OPENCL_HEADERS=OFF
  EXTRA_HOST_LD_FLAGS="--as-needed"
fi

cmake \
  -D CMAKE_INSTALL_PREFIX="${PREFIX}" \
  -D LINK_COMMAND="${PREFIX}/bin/ld" \
  -D POCL_INSTALL_ICD_VENDORDIR="${PREFIX}/etc/OpenCL/vendors" \
  -D LLVM_CONFIG="${PREFIX}/bin/llvm-config" \
  -D HAVE_CLOCK_GETTIME="${HAVE_CLOCK_GETTIME}" \
  -D INSTALL_OPENCL_HEADERS="${INSTALL_OPENCL_HEADERS}" \
  -D KERNELLIB_HOST_CPU_VARIANTS=distro \
  -D OPENCL_LIBRARIES="${OPENCL_LIBRARIES}" \
  -D EXTRA_HOST_LD_FLAGS="${EXTRA_HOST_LD_FLAGS}" \
  ..

make -j 8
make install

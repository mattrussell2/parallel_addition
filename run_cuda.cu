#include <iostream>
#include <time.h>
#include <cuda_runtime_api.h>
#include <cuda.h>
#include "cu_header.h"
#include "cu_helper.h"

__global__ void sum_arrays(int *d_array_a, int *d_array_b,
			   int *d_array_c, int array_length){    
  int index = blockIdx.x * blockDim.x + threadIdx.x;
  if (index >= array_length) return;
  d_array_c[index] = d_array_a[index] + d_array_b[index];
}

int* run_cuda(int *h_first_array, int *h_second_array, int array_length){
  checkCudaErrors(cudaSetDevice(0));
  checkCudaErrors(cudaDeviceReset());

  int threads_per_block = 32;

  int ary_byte_size = sizeof(int) * array_length;
  int *d_first_array, *d_second_array, *d_summed_array;
  checkCudaErrors(cudaMallocManaged((void**)&d_first_array, ary_byte_size));
  checkCudaErrors(cudaMallocManaged((void**)&d_second_array, ary_byte_size));
  checkCudaErrors(cudaMallocManaged((void**)&d_summed_array, ary_byte_size));

  checkCudaErrors(cudaMemcpy(d_first_array, h_first_array, ary_byte_size,
			     cudaMemcpyHostToDevice));
  checkCudaErrors(cudaMemcpy(d_second_array, h_second_array, ary_byte_size,
			     cudaMemcpyHostToDevice));

  dim3 blocks(array_length / threads_per_block + 1); //round up just in case
  dim3 threads(threads_per_block);

  clock_t start, stop;
  start = clock();
  
  sum_arrays <<< blocks, threads >>> (d_first_array, d_second_array,
				      d_summed_array, array_length);
  checkCudaErrors(cudaDeviceSynchronize());          // synchronize threads
  
  stop = clock();
  double timer_seconds = ((double)(stop - start)) / CLOCKS_PER_SEC;
  printf("cuda took %f seconds\n", (float)timer_seconds);

  int *h_summed_array = (int *)malloc(sizeof(int) * array_length);
  checkCudaErrors(cudaMemcpy(h_summed_array, d_summed_array, ary_byte_size,
			     cudaMemcpyDeviceToHost));
		
  checkCudaErrors(cudaFree(d_first_array));
  checkCudaErrors(cudaFree(d_second_array));
  checkCudaErrors(cudaFree(d_summed_array));
  return h_summed_array;
}

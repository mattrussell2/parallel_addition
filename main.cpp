#include<iostream>
#include<time.h>
#include<bits/stdc++.h>
#include "cu_header.h"

int main(){
  int array_length = INT_MAX / 10;
  int *first_array = new int[array_length];
  int *second_array = new int[array_length];

  std::fill_n(first_array, array_length, 2);
  std::fill_n(second_array, array_length, 3);
  
  int *summed_array = run_cuda(first_array, second_array, array_length);
  
  /* 
     // print the result to make sure it works
     for (int i = 0; i < array_length; i++){
         std::cout << summed_array[i] << std::endl;
     }
  */
  
  std::fill_n(summed_array, array_length, 0);
 
  clock_t start, stop;
  start = clock();

  for (int i = 0; i < array_length; i++){
    summed_array[i] = first_array[i] + second_array[i];
  }
  stop = clock();
  double timer_seconds = ((double)(stop - start)) / CLOCKS_PER_SEC;
  printf("normal took %f seconds\n", (float)timer_seconds);


  delete [] first_array;
  delete [] second_array;
  delete [] summed_array;
}

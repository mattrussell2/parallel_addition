.DEFAULT_GOAL=parallel_addition

main:
	g++ -std=c++11 -c main.cpp

run_cuda:
	nvcc -c run_cuda.cu

parallel_addition: main run_cuda
	nvcc -o parallel_addition main.o run_cuda.o

clean:
	rm *.o a.out

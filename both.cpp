#include <iostream>
#include <fstream>
#include <chrono>
#include <cstdlib>
#include <vector>
#include <unistd.h>
#include <thread>
#include <sys/wait.h>

int binary_search(const std::vector<int>& array, int target) {
    int left = 0;
    int right = array.size() - 1;

    while (left <= right) {
        int mid = left + (right - left) / 2;

        if (array[mid] == target) {
            return mid; 
        }

        if (array[mid] < target) {
            left = mid + 1;
        } else {
            right = mid - 1;
        }
    }

    return -1; 
}

void run_binary_search(int iterations) {
    const int size = 1000000;
    const int target = 1;

    std::vector<int> array(size);
    for (int i = 0; i < size; ++i) {
        array[i] = i + 1;
    }

    for (int i = 0; i < iterations; i++) {
        binary_search(array, target);  
    }
}

void io_latency_read(const char* filename, int iterations) {
    const int block_size = 512; 
    char buffer[block_size];  

    for (int i = 0; i < iterations; ++i) {
        std::ifstream file(filename, std::ios::in | std::ios::binary);

        if (!file) {
            std::cerr << "Error opening file: " << filename << std::endl;
            exit(1);
        }

        while (file.read(buffer, block_size) || file.gcount() > 0) {

        }

        file.close();  
    }
}

int main(int argc, char* argv[]) {
    if (argc != 4) {
        std::cerr << "Usage: " << argv[0] << " <filename> <io-lat-read iterations> <bin-search iterations>" << std::endl;
        return 1;
    }

    const char* filename = argv[1];
    const int io_read_iterations = std::atoi(argv[2]);  
    const int bin_search_iterations = std::atoi(argv[3]);  

    std::thread bin_search_thread(run_binary_search, bin_search_iterations);
    std::thread io_read_thread(io_latency_read, filename, io_read_iterations);
    
    bin_search_thread.join();
    io_read_thread.join();

    return 0;
}

#include <iostream>
#include <vector>
#include <chrono>
#include <cstdlib>
#include <unistd.h>
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

int main(int argc, char* argv[]) {
    if (argc != 2) {
        std::cerr << "Usage: " << argv[0] << " <iterations>" << std::endl;
        return 1;
    }

    int iterations = std::atoi(argv[1]);  

    run_binary_search(iterations);

    return 0;
}

#include <iostream>
#include <fstream>
#include <chrono>
#include <cstdlib>

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
    if (argc != 3) {
        std::cerr << "Usage: " << argv[0] << " <filename> <iterations>" << std::endl;
        return 1;
    }

    const char* filename = argv[1];
    int iterations = std::atoi(argv[2]);

    io_latency_read(filename, iterations);

    return 0;
}

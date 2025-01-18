#include <iostream>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <chrono>
#include <cstring>

void executeCommand(char *args[]) {
     if (args[0] == nullptr) {
        return; 
    }
    
    pid_t pid = vfork();
    
    if (pid < 0) {
        std::cerr << "Fork failed" << std::endl;
        exit(1);
    } else if (pid == 0) {
        if (execvp(args[0], args) < 0) {
            std::cerr << "Execution failed" << std::endl;
            exit(1);
        }
    } else {
        int status;

        auto start = std::chrono::high_resolution_clock::now(); 
        
        waitpid(pid, &status, 0);
        
        auto end = std::chrono::high_resolution_clock::now(); 
        std::chrono::duration<double> elapsed = end - start;
        std::cout << "Execution time = " << elapsed.count() << " seconds" << std::endl;
    }
}

int main() {
    char input[1024];

    while (true) {
        std::cout << "shell> ";
        std::cin.getline(input, 1024);

        if (strcmp(input, "exit") == 0) {
            break;
        }

        char *args[64];
        char *token = strtok(input, " ");
        int i = 0;
        while (token != nullptr) {
            args[i++] = token;
            token = strtok(nullptr, " ");
        }
        args[i] = nullptr;
        
        executeCommand(args);
    }

    return 0;
}

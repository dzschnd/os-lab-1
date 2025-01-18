#!/bin/bash

./runBench.sh logs/double/binSearch ./../exec/binSearch 50000000
wait
./runBench.sh logs/double/ioLatRead ./../exec/ioLatRead ./../shell.cpp 50000
wait
./runBench.sh logs/double/both ./../exec/both ./../shell.cpp 50000 50000000
wait
./runBench.sh logs/double/both_opt ./../exec/bothOptimized ./../shell.cpp 50000 50000000
wait
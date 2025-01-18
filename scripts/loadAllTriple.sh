#!/bin/bash

./runBench.sh logs/triple/binSearch ./../exec/binSearch 75000000
wait
./runBench.sh logs/triple/ioLatRead ./../exec/ioLatRead ./../shell.cpp 75000
wait
./runBench.sh logs/triple/both ./../exec/both ./../shell.cpp 75000 75000000
wait
./runBench.sh logs/triple/both_opt ./../exec/bothOptimized ./../shell.cpp 75000 75000000
wait
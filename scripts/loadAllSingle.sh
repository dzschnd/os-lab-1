#!/bin/bash

./runBench.sh logs/single/binSearch ./../exec/binSearch 25000000
wait
./runBench.sh logs/single/ioLatRead ./../exec/ioLatRead ./../shell.cpp 25000
wait
./runBench.sh logs/single/both ./../exec/both ./../shell.cpp 25000 25000000
wait
./runBench.sh logs/single/both_opt ./../exec/bothOptimized ./../shell.cpp 25000 25000000
wait
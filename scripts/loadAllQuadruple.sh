#!/bin/bash

./runBench.sh logs/quad/binSearch ./../exec/binSearch 100000000
wait
./runBench.sh logs/quad/ioLatRead ./../exec/ioLatRead ./../shell.cpp 100000
wait
./runBench.sh logs/quad/both ./../exec/both ./../shell.cpp 100000 100000000
wait
./runBench.sh logs/quad/both_opt ./../exec/bothOptimized ./../shell.cpp 100000 100000000
wait
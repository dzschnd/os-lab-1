#!/bin/bash

log_dir="/home/junayd/Desktop/study-projects/os-lab-1/logs/double"
exec_dir="/home/junayd/Desktop/study-projects/os-lab-1/exec"
script_dir="/home/junayd/Desktop/study-projects/os-lab-1/scripts"
src_file="/home/junayd/Desktop/study-projects/os-lab-1/shell.cpp"

binSearch_cmd="$exec_dir/binSearch 100000000"
ioLatRead_cmd="$exec_dir/ioLatRead $src_file 100000"
both_cmd="$exec_dir/both $src_file 100000 100000000"
both_opt_cmd="$exec_dir/bothOptimized $src_file 100000 100000000"

run_benchmark() {
    local log_file=$1
    local command=$2

    $script_dir/runBench.sh "$log_file" $command

    if [ $? -ne 0 ]; then
        echo "Error running benchmark for $log_file" >&2
        exit 1
    fi
}

run_benchmark "$log_dir/binSearch" "$binSearch_cmd"
run_benchmark "$log_dir/ioLatRead" "$ioLatRead_cmd"
run_benchmark "$log_dir/both" "$both_cmd"
run_benchmark "$log_dir/both_opt" "$both_opt_cmd"

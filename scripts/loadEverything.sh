#!/bin/bash

script_dir="/home/junayd/Desktop/study-projects/os-lab-1/scripts"

run_script() {
    local script_name=$1

    $script_dir/$script_name

    if [ $? -ne 0 ]; then
        echo "Error running $script_name" >&2
        exit 1
    fi
}

run_script "loadAllSingle.sh"
run_script "loadAllDouble.sh"
run_script "loadAllTriple.sh"
run_script "loadAllQuadruple.sh"

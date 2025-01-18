#!/bin/bash

if [ $# -lt 3 ]; then
    echo "Usage: $0 <output_log_directory> <benchmark_program> [additional_arguments...]"
    exit 1
fi

OUTPUT_DIR=$1
BENCHMARK_PROGRAM=$2
shift 2  # Shift to get the rest of the arguments after the first two

# Create the output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Check if the benchmark program exists
if [ ! -f "$BENCHMARK_PROGRAM" ]; then
    echo "Error: Benchmark program $BENCHMARK_PROGRAM not found."
    exit 1
fi

# Check if the benchmark program is executable
if [ ! -x "$BENCHMARK_PROGRAM" ]; then
    echo "Error: Benchmark program $BENCHMARK_PROGRAM is not executable."
    exit 1
fi

USER=junayd 

# Get the number of CPU cores
NUM_CORES=$(nproc)

echo "Running $BENCHMARK_PROGRAM with arguments '$@'"
echo "Collecting performance metrics with perf stat, ltrace, strace, top, and FlameGraph"
echo "Output will be saved in $OUTPUT_DIR directory"

# 1. Run perf stat and save output to perf.log in the output directory
echo "Running perf stat..."
perf stat -d -d -d "$BENCHMARK_PROGRAM" "$@" 2>&1 | tee "$OUTPUT_DIR/perf.log"

# 2. Run ltrace and save output to ltrace.log in the output directory
echo "Running ltrace..."
ltrace -c "$BENCHMARK_PROGRAM" "$@" 2>&1 | tee "$OUTPUT_DIR/ltrace.log"

# 3. Run strace and save output to strace.log in the output directory
echo "Running strace..."
strace -c "$BENCHMARK_PROGRAM" "$@" 2>&1 | tee "$OUTPUT_DIR/strace.log"

# 4. Start top in the background to capture system performance
# Use stdbuf to flush output line by line and limit to 60 iterations, capturing every 1 second.
echo "Starting top logging..."
stdbuf -oL top -b -d 1 -n 60 > "$OUTPUT_DIR/top.log" &
TOP_PID=$!

# Array to hold PIDs of benchmark instances
PIDS=()

# Start all instances of the benchmark program, each assigned to a different core
for ((core=0; core<NUM_CORES; core++)); do
    taskset -c $core "$BENCHMARK_PROGRAM" "$@" &  
    PIDS+=($!)  
done

# Wait for all benchmark processes to finish
echo "Waiting for all benchmark processes to complete..."
for pid in "${PIDS[@]}"; do
    wait "$pid"
done

# Wait an additional few seconds to ensure top captures the final state
sleep 5

# Once benchmarks are done, kill the top process
kill $TOP_PID
echo "Top profiling completed."

# Define paths to FlameGraph scripts
FLAMEGRAPH_SCRIPT="/home/$USER/FlameGraph/flamegraph.pl"
FLAMEGRAPH_COLLAPSE="/home/$USER/FlameGraph/stackcollapse-perf.pl"

# 5. Generate FlameGraph
echo "Generating FlameGraph..."
perf record -F 2048 -g "$BENCHMARK_PROGRAM" "$@"
perf script | "$FLAMEGRAPH_COLLAPSE" > "$OUTPUT_DIR/perf-folded.out"

# Check if flamegraph.pl is available and generate SVG
if [ -x "$FLAMEGRAPH_SCRIPT" ]; then
    "$FLAMEGRAPH_SCRIPT" "$OUTPUT_DIR/perf-folded.out" > "$OUTPUT_DIR/flamegraph.svg"
    echo "FlameGraph saved to $OUTPUT_DIR/flamegraph.svg"
else
    echo "FlameGraph script not found."
fi

# Clean up temporary files
rm -f perf.data "$OUTPUT_DIR/perf-folded.out" perf.data.old

echo "All performance logs saved to $OUTPUT_DIR"

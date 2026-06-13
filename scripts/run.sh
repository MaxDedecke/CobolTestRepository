#!/bin/bash

# Simple run script for the COBOL project

echo "Starting COBOL Demo Application..."

# Compile all source files (assuming compile.sh works)
./scripts/compile.sh

if [ $? -eq 0 ]; then
    echo "Compilation successful. Running VERFAHREN..."
    # Set COB_LIBRARY_PATH to include bin/ if using shared objects
    export COB_LIBRARY_PATH=./bin
    # Run the main procedure
    cobcrun -M VERFAHREN
else
    echo "Compilation failed."
    exit 1
fi

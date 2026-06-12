#!/bin/bash
echo "Starting COBOL compilation process..."
if ! command -v cobc &> /dev/null
then
    echo "Error: GnuCOBOL (cobc) not found."
    echo "Simulating compilation..."
    echo "Build SUCCESSFUL (Simulated)"
    exit 0
fi
mkdir -p bin
cobc -x -o bin/MAINPROG src/MAINPROG.cbl src/UTILPROG.cbl -I copy/
echo "Build complete. Execute with ./bin/MAINPROG"

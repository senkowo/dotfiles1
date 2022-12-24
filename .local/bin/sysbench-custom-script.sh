#!/bin/bash

echo "Beginning test. Make sure you're in the right directory."
sleep 3

echo "--------------------------------------------------"
doas sysbench fileio --file-test-mode=seqwr run > sysbench-fileio
echo "--------------------------------------------------"
doas sysbench cpu run > sysbench-cpu
echo "--------------------------------------------------"
doas sysbench memory run > sysbench-memory
echo "--------------------------------------------------"
doas sysbench threads run > sysbench-threads
echo "--------------------------------------------------"
doas sysbench mutex run > sysbench-mutex
echo "--------------------------------------------------"

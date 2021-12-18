#!/bin/bash

set -eu

if ! command -v nvidia-smi &> /dev/null
then 
    echo "Please install nvidia driver first"
    exit 1
fi


echo "Git cloning gpu-miner"
git clone https://github.com/alephium/gpu-miner.git
cd gpu-miner

echo "Getting dependencies"
./deps.sh
cd ..
echo "Building the gpu miner"
./gpu-miner/make.sh

echo "Your miner is built, you could run it with: gpu-miner/run-miner.sh"

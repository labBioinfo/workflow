#!/usr/bin/env bash

git clone https://github.com/labBioinfo/kraken2.git

mkdir -p ~/metagenomics_LAB
mkdir -p ~/metagenomics_LAB/kraken_DB
cd kraken2
./install_kraken2.sh ~/metagenomics_LAB/kraken_DB
cd ~/metagenomics_LAB/kraken_DB
./kraken2-build --db GreenGenes --special greengenes

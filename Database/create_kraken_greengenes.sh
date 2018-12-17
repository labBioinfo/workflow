#!/usr/bin/env bash

wget http://github.com/DerrickWood/kraken2/archive/v2.0.7-beta.tar.gz 
tar xvzf v2.0.7-beta.tar.gz  

mkdir -p ~/metagenomics_LAB/kraken_DB
cd kraken2-2.0.7-beta
./install_kraken2.sh ~/metagenomics_LAB/kraken_DB
cd ~/metagenomics_LAB/kraken_DB
./kraken2-build --db GreenGenes --special greengenes


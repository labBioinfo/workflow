#!/usr/bin/env bash

if [ ! -d "~/metagenomics_LAB/" ]
	then
		mkdir -p ~/metagenomics_LAB/AG/fastq
		mkdir -p ~/metagenomics_LAB/AG/metadata
		mkdir -p ~/metagenomics_LAB/IBD/fastq
		mkdir -p ~/metagenomics_LAB/IBD/metadata
		mkdir -p ~/metagenomics_LAB/T2D/fastq
		mkdir -p ~/metagenomics_LAB/T2D/metadata
		mkdir -p ~/metagenomics_LAB/DB
	else
		echo "You already have the project folders, dumb-dumb!"

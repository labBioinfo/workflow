#!/usr/bin/env bash

PROJECT_FOLDER=~/metagenomics_LAB

if [ ! -d "$PROJECT_FOLDER" ]
	then
		echo "Creating project folders..."
			mkdir -p ~/metagenomics_LAB/AG/fastq
			mkdir -p ~/metagenomics_LAB/AG/metadata
			mkdir -p ~/metagenomics_LAB/IBD/fastq
			mkdir -p ~/metagenomics_LAB/IBD/metadata
			mkdir -p ~/metagenomics_LAB/T2D/fastq
			mkdir -p ~/metagenomics_LAB/T2D/metadata
			mkdir -p ~/metagenomics_LAB/DB
	else
		echo "The folders have already been created!"
fi



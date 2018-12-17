# coding: utf-8

import os
import pandas as pd
import shutil
import argparse

def copy_files(input,output,format,dataset, sep):
    """
    function to copy files from one location to another using a list with its names.
    Take 3 args, input folder, output folder and dataset file
    """

    data = pd.read_csv(dataset, sep=sep)

    for i in data:
        source = input + i + format
        destination = output + i + format
        shutil.copy(source, destination, follow_symlinks=True)

def Main():

    parser = argparse.ArgumentParser(description='Download')
    parser.add_argument("input_folder", help="A string with the location of the input folder")
    parser.add_argument("output_folder", help="A string with the location of the output folder")
    parser.add_argument("file_format", help="A string with the format of the type of file to be copied")
    parser.add_argument("dataset", help="A string with the location of the dataset and its name")
    parser.add_argument("dataset_separator", help="A string with the dataset data separator")

    args = parser.parse_args()
    input = args.input_folder
    output = args.output_folder
    file_format = args.file_format
    dataset = args.dataset
    dataset_separator = args.dataset_separator

    copy_files(input,output,file_format,dataset, dataset_separator)

if __name__ == '__main__':
    Main()

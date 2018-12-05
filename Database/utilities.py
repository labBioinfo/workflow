import os
from pathlib import Path
import requests
import pandas as pd

def create_dir(proj_file, db_name):
    """
    function to create files & folders for database download
    Takes 2 args (strings), project file (proj_file) and project database name (db_name)
    Returns a tuple with 4 paths (dataset file (dataset_file), log file (log_file), download folder for fastq (in_fastq), download folder for metadata (in_metadata))
    """
    home = str(Path.home())
    project_folder = os.path.join(home, 'metagenomics_LAB/')
    dataset_file = os.path.join(project_folder, proj_file)
    log_file = project_folder + 'log_' + db_name + '.txt'
    download_log_file = os.path.join(project_folder, log_file)
    proj_folder = db_name + '/'
    in_folder = os.path.join(project_folder, proj_folder)
    in_fastq = os.path.join(in_folder, 'fastq/')
    in_xml = os.path.join(in_folder, 'metadata/')
    metadata_file = os.path.join(in_xml, 'metadata.csv')

    return (dataset_file, log_file, in_fastq, in_xml, metadata_file)


def download_master_file(download_url, dataset_file):
    """
    function to download and store master dataset file
    Takes 2 args (strings), url for txt download (download_url) and dataset file path created by create_dir function (dataset_file)
    Returns nothing
    """
    study_download = requests.get(download_url, allow_redirects=True)
    open(dataset_file, 'wb').write(study_download.content)


def read_master_file(dataset_file, sep):
    """
    function to read masterfile in pandas and get relevant lists to download fastq files and metadata files
    Takes 1 args , path for dataset file available in tuple returned from create_dir function (dataset_file)
    Returns 3 pandas series, fastq_ftp_locations and accession_IDs (primary and secondary)
    """
    dataset = pd.read_csv(dataset_file, sep=sep)
    return (dataset['fastq_ftp'], dataset['sample_accession'], dataset['secondary_sample_accession'])


def is_number(s):
    """
    function to check if string can be changed to float and if so return it as float
    Takes 1 args, string
    Returns True if string as float is possible otherwise returns False.
    """
    try:
        float(s)
        return True
    except ValueError:
        return False

def save_error_file(errors, xml_folder):
    """
    function to save error info when saving xml and csv info to database collections
    Takes 2 args, error file (errors), folder dataset location (xml_folder)
    """
    flawed_dataset = pd.DataFrame(errors)
    flawed_file = xml_folder + 'flawed_files.csv'
    flawed_dataset.to_csv(path_or_buf=flawed_file, sep=';', header=False,index=False)

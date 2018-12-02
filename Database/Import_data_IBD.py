

import pandas as pd
import requests
import os
from pathlib import Path

# files & folders
home = str(Path.home())
project_folder = os.path.join(home, 'metagenomics_LAB/')
dataset_file = os.path.join(project_folder, 'PRJNA389280.txt')
download_log_file = os.path.join(project_folder, 'download_IBD_log.txt')
in_IBD_folder = os.path.join(project_folder, 'IBD/')
in_IBD_fastq = os.path.join(in_IBD_folder, 'fastq/')
in_IBD_xml = os.path.join(in_IBD_folder, 'metadata/')


# download study file
IBD_study = 'https://www.ebi.ac.uk/ena/data/warehouse/filereport?accession=PRJNA422434&result=read_run&fields=sample_accession,secondary_sample_accession,tax_id,scientific_name,fastq_ftp&download=txt'
IBD_study_download = requests.get(IBD_study, allow_redirects=True)
open(dataset_file, 'wb').write(IBD_study_download.content)

# read study file
dataset = pd.read_csv(dataset_file, sep='\t')
fastq_ftp_locations = dataset['fastq_ftp']
accession_IDs = dataset['secondary_sample_accession']
http = 'http://'
gz = '.fastq.gz'
xml = '.xml'

#download fastq and metadata
for i in range (len(accession_IDs)):

    fastq_ftp_str = ''
    fastq_ftp_list = []
    fastq_ftp_str = fastq_ftp_locations[i]
    fastq_ftp_list = fastq_ftp_str.split(';')
    total_link = http + str(fastq_ftp_list[0])
    fastq_download = requests.get(total_link, allow_redirects=True)
    fastq_file_name = in_IBD_fastq + str(accession_IDs[i]) + gz
    open(fastq_file_name, 'wb').write(fastq_download.content)

    xml_location = 'https://www.ebi.ac.uk/ena/data/view/{}&display=xml'.format(accession_IDs[i])
    xml_download = requests.get(xml_location, allow_redirects=True)
    xml_file_name = in_IBD_xml + str(accession_IDs[i]) + xml
    open(xml_file_name, 'wb').write(xml_download.content)
    with open(download_log_file, "a") as f:
        f.write("Download do fastq {} e do xml da amostra {} feita com sucesso \n".format(fastq_file_name,xml_file_name))

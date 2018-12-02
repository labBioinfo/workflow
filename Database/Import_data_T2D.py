

import pandas as pd
import requests
import os
from pathlib import Path

# files & folders
home = str(Path.home())
project_folder = os.path.join(home, 'metagenomics_LAB/')
dataset_file = os.path.join(project_folder, 'PRJNA422434.txt')
download_log_file = os.path.join(project_folder, 'download_T2D_log.txt')
in_T2D_folder = os.path.join(project_folder, 'T2D/')
in_T2D_fastq = os.path.join(in_T2D_folder, 'fastq/')
in_T2D_xml = os.path.join(in_T2D_folder, 'metadata/')


# download study file
T2D_study = 'https://www.ebi.ac.uk/ena/data/warehouse/filereport?accession=PRJNA389280&result=read_run&fields=sample_accession,secondary_sample_accession,tax_id,scientific_name,fastq_ftp&download=txt'
T2D_study_download = requests.get(T2D_study, allow_redirects=True)
open(dataset_file, 'wb').write(T2D_study_download.content)

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
    total_link_1 = http + str(fastq_ftp_list[0])
    total_link_2 = http + str(fastq_ftp_list[1])
    fastq_1_download = requests.get(total_link_1, allow_redirects=True)
    fastq_file_name_1 = in_T2D_fastq + str(accession_IDs[i]) + '_1' + gz
    open(fastq_file_name_1, 'wb').write(fastq_1_download.content)
    fastq_2_download = requests.get(total_link_2, allow_redirects=True)
    fastq_file_name_2 = in_T2D_fastq + str(accession_IDs[i]) + '_2' + gz
    open(fastq_file_name_2, 'wb').write(fastq_2_download.content)

    xml_location = 'https://www.ebi.ac.uk/ena/data/view/{}&display=xml'.format(accession_IDs[i])
    xml_download = requests.get(xml_location, allow_redirects=True)
    xml_file_name = in_T2D_xml + str(accession_IDs[i]) + xml
    open(xml_file_name, 'wb').write(xml_download.content)
    with open(download_log_file, "a") as f:
        f.write("Download dos fastq {}, {} e do xml da amostra {} feita com sucesso \n".format(fastq_file_name_1,fastq_file_name_2,xml_file_name))

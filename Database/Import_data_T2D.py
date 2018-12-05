from utilities import create_dir
from utilities import download_master_file
from utilities import read_master_file
import pandas as pd
import requests

http = 'http://'
gz = '.fastq.gz'
xml = '.xml'

folders = create_dir('PRJNA422434.txt', 'T2D')
download_master_file('https://www.ebi.ac.uk/ena/data/warehouse/filereport?accession=PRJNA389280&result=read_run&fields=sample_accession,secondary_sample_accession,tax_id,scientific_name,fastq_ftp&download=txt', folders[0])
download_lists = read_master_file(folders[0], '\t')

#download fastq and metadata
for i in range (len(download_lists[1])):

    fastq_ftp_str = ''
    fastq_ftp_list = []
    fastq_ftp_str = download_lists[0][i]
    fastq_ftp_list = fastq_ftp_str.split(';')
    total_link_1 = http + str(fastq_ftp_list[0])
    total_link_2 = http + str(fastq_ftp_list[1])
    fastq_1_download = requests.get(total_link_1, allow_redirects=True)
    fastq_file_name_1 = folders[2] + str(download_lists[1][i]) + '_1' + gz
    open(fastq_file_name_1, 'wb').write(fastq_1_download.content)
    fastq_2_download = requests.get(total_link_2, allow_redirects=True)
    fastq_file_name_2 = folders[2] + str(download_lists[1][i]) + '_2' + gz
    open(fastq_file_name_2, 'wb').write(fastq_2_download.content)

    xml_location = 'https://www.ebi.ac.uk/ena/data/view/{}&display=xml'.format(download_lists[2][i])
    xml_download = requests.get(xml_location, allow_redirects=True)
    xml_file_name = folders[3] + str(download_lists[1][i]) + xml
    open(xml_file_name, 'wb').write(xml_download.content)
    with open(folders[1], "a") as f:
        f.write("Download dos fastq {}, {} e do xml da amostra {} feita com sucesso \n".format(fastq_file_name_1,fastq_file_name_2,xml_file_name))

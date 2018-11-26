import pandas as pd
import requests


dataset = pd.read_csv('PRJEB11419.txt', sep='\t')

fastq_ftp_locations = dataset['fastq_ftp']
accession_IDs = dataset['sample_accession']
http = 'http://'
gz = '.fastq.gz'
xml = '.xml'


for i in range (len(accession_IDs)):

    total_link = http + str(fastq_ftp_locations[i])
    f_download = requests.get(total_link, allow_redirects=True)
    file_name = str(accession_IDs[i]) + gz
    open(file_name, 'wb').write(f_download.content)

    xml_location = 'https://www.ebi.ac.uk/ena/data/view/{}&display=xml'.format(accession_IDs[i])
    f_xml = requests.get(xml_location, allow_redirects=True)
    file_name2 = str(accession_IDs[i]) + xml
    open(file_name2, 'wb').write(f_xml.content)
    with open("log.txt", "a") as f:
        f.write("Download do fastq {} e do xml da amostra {} feita com sucesso \n".format(file_name,file_name2))

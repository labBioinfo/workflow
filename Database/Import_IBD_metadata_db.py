import pymongo
import os
import pandas as pd
from pymongo import MongoClient
from bs4 import BeautifulSoup as Soup
from utilities import create_dir
from utilities import is_number
from utilities import download_master_file
from utilities import save_error_file

conn = MongoClient()
collection = conn["labbioinfo"]["IBD"]
folders = create_dir('PRJNA389280.txt', 'IBD')
download_master_file('https://ibdmdb.org/tunnel/products/HMP2/Metadata/hmp2_metadata.csv', folders[4])
metadata_set = read_master_file(folders[4], ',')


for filename in os.listdir(folders[3]):
    fullname = os.path.join(folders[3], filename)
    infile = open(fullname,"r")
    contents = infile.read()
    soup = Soup(contents,'xml')
    sample_ID = soup.find('SUBMITTER_ID')
    if sample_ID is not None:
        sampleid = sample_ID.get_text()
        sample_set = metadata_set.loc[metadata_set['Project'] == sampleid]
        sample_set = sample_set.to_dict('index')
        key_loc = list(sample_set.keys())
        sampledict = sample_set[key_loc[0]]
        primary_ID = soup.find('PRIMARY_ID')
        taxon_ID = soup.find('TAXON_ID')
        science_name = soup.find('SCIENTIFIC_NAME')
        tags = soup.findAll('TAG')
        values = soup.findAll('VALUE')
        infile.close()
        tags = [i.get_text() for i in tags]
        loc1 = tags.index("geo_loc_name")
        tags[loc1] = "country"
        values = [i.get_text() for i in values]
        values_corrected = []
        for i in values:
            if is_number(i) == True:
                values_corrected.append(float(i))
            else:
                values_corrected.append(i)
        sample_attr = dict(zip(tags,values_corrected))
        doc = {}
        doc['primary_ID'] = primary_ID.get_text()
        doc['sample_ID']  = sample_ID.get_text()
        doc['external_ID']  = external_ID.get_text()
        doc['taxon_ID']  = taxon_ID.get_text()
        doc['sample_location'] = science_name.get_text()
        doc.update(sample_attr)
        doc.update(sampledict)
        collection.insert_one(doc)
    else:
        infile.close()
        errors.append(filename)

save_error_file(errors, folders[3])

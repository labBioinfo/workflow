import pymongo
import os
import pandas as pd
from pymongo import MongoClient
from bs4 import BeautifulSoup as Soup
from utilities import create_dir
from utilities import is_number

conn = MongoClient()
collection = conn["labbioinfo"]["T2D"]
folders = create_dir('PRJNA422434.txt', 'T2D')


for filename in os.listdir(folders[3]):
    fullname = os.path.join(folders[3], filename)
    infile = open(fullname,"r")
    contents = infile.read()
    soup = Soup(contents,'xml')
    primary_ID = soup.find('PRIMARY_ID')
    external_ID = soup.find('EXTERNAL_ID')
    taxon_ID = soup.find('TAXON_ID')
    science_name = soup.find('SCIENTIFIC_NAME')
    tags = soup.findAll('TAG')
    values = soup.findAll('VALUE')
    infile.close()
    tags = [i.get_text() for i in tags]
    loc1, loc2, loc3 = tags.index("NATION"), tags.index("GENDER"), tags.index("AGE")
    tags[loc1], tags[loc2], tags[loc3]  = "country", "sex", "age_years"
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
    doc['external_ID']  = external_ID.get_text()
    doc['taxon_ID']  = taxon_ID.get_text()
    doc['sample_location'] = science_name.get_text()
    doc.update(sample_attr)
    collection.insert_one(doc)

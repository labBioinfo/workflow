import pymongo
from pymongo import MongoClient
import os
from bs4 import BeautifulSoup as Soup
import pandas as pd

conn = MongoClient()
collection = conn["labbioinfo"]["AG"]

# change XML value from string to float if possible

def is_number(s):
    try:
        float(s)
        return True
    except ValueError:
        return False

# XML tags without values
notoktags = ['alcohol_types','allergic_to', 'mental_illness_type','non_food_allergies','specialized_diet','vioscreen_activity_level'
     ,'vioscreen_age','vioscreen_bcodeid','vioscreen_bmi','vioscreen_dob','vioscreen_eer','vioscreen_email','vioscreen_finished'
      ,'vioscreen_gender','vioscreen_height','vioscreen_nutrient_recommendation','vioscreen_procdate','vioscreen_protocol'
      ,'vioscreen_recno','vioscreen_scf','vioscreen_scfv','vioscreen_srvid','vioscreen_started','vioscreen_subject_id'
      ,'vioscreen_time','vioscreen_user_id','vioscreen_visit','vioscreen_weight']
home = str(Path.home())
directory = home + '/metagenomics_LAB/AG/metadata/'
errors = []


for filename in os.listdir(directory):
    fullname = os.path.join(directory, filename)
    infile = open(fullname,"r")
    contents = infile.read()
    soup = Soup(contents,'xml')
    title = soup.find('TITLE')
    if title is not None:
        primary_ID = soup.find('PRIMARY_ID')
        external_ID = soup.find('EXTERNAL_ID')
        sample_ID = title
        taxon_ID = soup.find('TAXON_ID')
        science_name = soup.find('SCIENTIFIC_NAME')
        tags = soup.findAll('TAG')
        values = soup.findAll('VALUE')
        infile.close()
        tags = [i.get_text() for i in tags]
        tags = [x for x in tags if x not in notoktags]
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
        collection.insert_one(doc)
    else:
        errors.append(filename)

flawed_files = pd.DataFrame(errors)
flawed_file_dir = directory + 'flawed_files.csv'
flawed_files.to_csv(path_or_buf=flawed_file_dir, sep=';', header=False,index=False)

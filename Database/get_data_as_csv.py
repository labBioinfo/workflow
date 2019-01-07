#!/usr/bin/env python
'''
This script grabs data from a mongo db and saves it in a csv file
Will later be updated to be more dynamic, but its hardcoded for now
'''

import csv
import os
from pymongo import MongoClient

# create a localhost connection
client = MongoClient()

# select the database
db = client.labbioinfo

# select the table -- we'll be using AG for now
AG = db.AG

# list of fields to grab
fields = ['external_ID', 'sample_location', 'autoimmune', 'country', 'mental_illness', 'bmi_cat']

projection = { key: 1 for key in fields }
# remove the _id field
projection["_id"] = 0

# make an output dir
os.makedirs('data', exist_ok=True)

# write selected fields to a csv file
with open('data/gut.csv', 'w') as fs:
	print('Writing to {}...'.format('data/gut.csv'))
	cursor = AG.find({}, projection)
    # write head
    writer = csv.DictWriter(fs, fields)
    writer.writeheader()
    print('Wrote header')
	for doc in cursor:
		writer.writerow(doc)
	print('Wrote {} documents.'.format(cursor.count()))

print('Done')

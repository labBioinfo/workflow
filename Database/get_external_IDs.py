#!/usr/bin/env python

import os
import pymongo
from pymongo import MongoClient

# create a localhost connection
client = pymongo.MongoClient()

# select the database
db = client.labbioinfo

# select the table -- we'll be using AG for now
AG = db.AG

# get our list of tags
tags = AG.distinct('sample_location')

# make an output dir
os.makedirs('external_ids', exist_ok=True)

# make a file for each tag and write all documents
for tag in tags:
	with open('external_ids/' + tag + '.txt', 'w') as fs:
		print('Writing to {}...'.format(tag + '.txt'))
		cursor = AG.find({"sample_location": tag}, {"external_ID": 1})
		for doc in cursor:
			fs.write(doc['external_ID'] + '\n')
		print('{} IDs.'.format(cursor.count()))

print('Done')

#!/usr/bin/env python
'''
Grabs data from a mongo db and saves it in a csv file
'''

import argparse
import csv
import os
import sys
from pymongo import MongoClient

def main():
	# define the argument parser
	parser = argparse.ArgumentParser(description='Extracts data from mongo to csv.')
	parser.add_argument('fields', nargs='*', help='fields to include in the csv (default: all)')
	parser.add_argument('--db', default='labbioinfo', help='the database name to extract data from (default: labbioinfo)')
	parser.add_argument('--table', default='AG', help='the table name to extract data from (default: AG)')
	parser.add_argument('--no_header', action='store_true', help='skips writing the header with the column names')
	parser.add_argument('-x', '--filter', help='only grabs documents with matching field values (ex: --filter name=alex would only grab documents where the name field equals alex)')
	parser.add_argument('-o', '--output_file', metavar='FILE', default='out.csv', help='where to store the output (default: out.csv)')

	args = parser.parse_args()

	# create a localhost connection
	client = MongoClient()

	# select the database
	db = client[args.db]

	# select the collection
	table = db[args.table]

	# test the connection
	try:
		print('Looking for a mongo connection...')
		client.server_info()
		print('Connected')
	except:
		print('Cannot connect to a mongo database with the given parameters!')
		sys.exit(1)

	# list of fields to grab -- default to all
	fields = args.fields

	if fields:
		projection = { key: 1 for key in fields }
	else:
		projection = {}

	# remove the _id field
	projection["_id"] = 0

	# make dirs as needed to match the output path
	dir_path = os.path.dirname(args.output_file)
	if dir_path:
		os.makedirs(dir_path, exist_ok=True)

	query = {}
	# figure out the query based on the filter
	if args.filter:
		kvp = args.filter.split('=')
		if len(kvp) > 1:
			query[kvp[0]] = kvp[1]

	# write selected fields to a csv file
	with open(args.output_file, 'w') as fs:
		print('Writing to {}...'.format(args.output_file))
		cursor = table.find(query, projection)
		# write head - if no fields were selected, this is determinted by
		# the first document's properties
		firstDoc = cursor.next()
		if fields:
			writer = csv.DictWriter(fs, fields)
		else:
			writer = csv.DictWriter(fs, firstDoc.keys())
		if not args.no_header:
			writer.writeheader()
			print('Wrote header')

		# write the first document
		writer.writerow(firstDoc)

		for doc in cursor:
			writer.writerow(doc)
		print('Wrote {} documents'.format(cursor.count()))
		print('Done')

if __name__ == '__main__':
	main()

import numpy as np
import pandas as pd

#read kraken report and create dataframe using pandas

filereport = pd.read_csv('outputreport.txt', sep='\t', header = 0)

fileframe = pd.DataFrame(filereport)

# column of taxonomic ids

colid = fileframe.iloc[:,4]

# column of population

colpop = fileframe.iloc[:,1]

# make ids and population a list 

list(colpop)

list(colid)

# make ids and pupulation a string

idtaxa = ",".join(str(e) for e in colid)

population = ",".join(str(e) for e in colpop)

# create two outputs file 

with open("colunasfinal", 'w') as t:
	print(idtaxa, file = t)
	

with open("population", 'w') as f:
	print(population, file = f)
	

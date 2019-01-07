from ete3 import NCBITaxa
ncbi = NCBITaxa()
ncbi.update_taxonomy_database()
built = False

#format=1 aparecer nomes dos nodes interiores
infile2 = open("colunasfinal", 'r')
for lines in infile2:
	idtaxa = lines.strip().split(",")
	idtaxa = list(map(int,idtaxa))

infile2.close()

while not built:
	try:
		t = ncbi.get_topology(idtaxa, intermediate_nodes=True)

		treefinal = t.get_ascii(attributes=["rank", "sci_name"])
		built= True
	except KeyError as e:
		taxid_not_found = int(e.args[0])
		idtaxa.remove(taxid_not_found)
		print("the following IDs were not found in NCBI taxonomy database:" + str(taxid_not_found))
		pass

		
with open("ete3tree", 'w') as tree:
	print(treefinal, file = tree)

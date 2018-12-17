from ete3 import NCBITaxa
ncbi = NCBITaxa()
ncbi.update_taxonomy_database()

#format=1 aparecer nomes dos nodes interiores
infile2 = open("colunasfinal", 'r')
for lines in infile2:
	idtaxa = lines.strip().split(",")
	idtaxa = list(map(int,idtaxa))

infile2.close()

t = ncbi.get_topology(idtaxa, intermediate_nodes=True)

treefinal = t.get_ascii(attributes=["sci_name"])
#print( t.get_cached_content(store_attr="name"))
#print(t.children[0].children[1])

		
with open("ete3tree", 'w') as tree:
	print(treefinal, file = tree)
	









	



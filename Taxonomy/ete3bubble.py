from ete3 import NCBITaxa
ncbi = NCBITaxa()
from ete3 import Tree, TreeStyle, NodeStyle, faces, AttrFace, CircleFace


infile = open("population.txt", 'r')
for lines in infile:
	weighs = lines.strip().split(",")
	weighs = list(map(int,weighs))

infile.close()

infile2 = open("colunasfinal.txt", 'r')
for lines in infile2:
	idtaxa = lines.strip().split(",")
	idtaxa = list(map(int,idtaxa))

infile2.close()


def layout(node):
    if node.is_leaf():
        # Add node name to laef nodes
        N = AttrFace("sci_name", fsize=14, fgcolor="black")
        faces.add_face_to_node(N, node, 0)
    if "weight" in node.features:
        # Creates a sphere face whose size is proportional to node's
        # feature "weight"
        C = CircleFace(radius=(node.weight/100), color="RoyalBlue", style="sphere")
        # Let's make the sphere transparent
        C.opacity = 0.3
        # And place as a float face over the tree
        faces.add_face_to_node(C, node, 0, position="float")


def buble_tree():
	built = False
	while not built:
		try:
    
			# Random tree
			t = ncbi.get_topology(idtaxa, intermediate_nodes=True)

			# Some random features in all nodes 
			for node,weigh in zip(t,weighs):

				node.add_features(weight=weigh)

			# Create an empty TreeStyle
			ts = TreeStyle()

			# Set our custom layout function
			ts.layout_fn = layout

			# Draw a tree
			ts.mode = "c"

			# We will add node names manually
			ts.show_leaf_name = True
			# Show branch data
			ts.show_branch_length = True
			ts.show_branch_support = True
				
			return t, ts
			built = True
		except KeyError as e:
			taxid_not_found = int(e.args[0])
			idtaxa.remove(taxid_not_found)
			print("the following IDs were not found in NCBI taxonomy database:" + str(taxid_not_found))
			pass
			


if __name__ == "__main__":
	t, ts = buble_tree()

	t.render("bubble_map.png", w=3000, dpi=2000, tree_style=ts)
	

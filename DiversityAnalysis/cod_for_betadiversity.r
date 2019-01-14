install.packages("biomformat")
install.packages("vegan")
library(biomformat)
library(vegan)

#Path for your biom table

path <- "~/pathfile/otu_table.biom"
table <- read_biom(path)

#Extract data matrix from biom table
otus <- as.matrix(biom_data(table))

#Transpose so that rows are samples and columns are OTUs
otus <- t(otus)

#Load mapping file
#Mapping file for differences in the samples from eye, gut, nasopharynx, oral, skin, and vagine
map <- read.table('map.txt', sep='\t', comment='', head=T, row.names=1)

#See rownames of map and otus
rownames(map)
rownames(otus)

#Intersect mapfile and otustable
common.ids <- intersect(rownames(map), rownames(otus))

otus <- otus[common.ids,]
map <- map[common.ids,]

#Distance euclidean for beta diversity
d.euc <- dist(otus)

# Distance Bray-curtis for beta diversity
d.bray <- vegdist(otus

#Make plot
makes a gradient from red to blue
my.colors <- colorRampPalette(c('pink','blue'))(10)

#Euclidean plot with PCoA coordinates 
# based on layer (1...10)
layer <- map[,'LAYER']
plot(pc.euc[,1], pc.euc[,2], col=my.colors[layer], cex=3, pch=16)

#Bray-Curtis plot with PCoA coordinates
plot(pc.bray[,1], pc.bray[,2], col=my.colors[layer], cex=3, pch=16)



library("biomformat")
library("phyloseq")
library("ggplot2")

path <- 'C:/Users/Stella/Desktop/merged_table.biom'

# Read biom table from path
table <- read_biom(path)
names(table)

# Import biom table in phyloseq
physeq <- import_biom(table, parseFunction = parse_taxonomy_greengenes)
tax_table <- tax_table(physeq)[, 1:7]
rank_names(physeq)
sample_names(physeq)

#Import map file 
mapfile <- read.table('C:/Users/Stella/Desktop/labbio/mapfile.txt', sep=',', comment='', head=T, row.names=1, strip.white = TRUE)
rownames(mapfile)

#Check if the sample names are the same as the file file
all(rownames(mapfile) %in% sample_names(physeq))

#Import map file for phyloseq
sample_data <- sample_data(mapfile)

#Merged biom table and map file
physeq2 <- merge_phyloseq(sample_data, physeq)
sample_variables(physeq2)


samplesum <- data.frame(sum= sample_sums(physeq2))
> ggplot(samplesum, aes(x=sum)) + geom_histogram(color="black", fill="indianred", binwidth = 2500) 
+ ggtitle("Distribution of sample depth") + xlab("Read counts") + theme(axis.title.y = element_blank())

#Set the variables of the samples to use in the colors of the plots
Sample_location <- factor(sample_data(physeq2)$Sample_location,levels = c("eye", "nasopharyngeal", "oral", "skin", "vaginal"))

#Rarefation samples(optional)
ps.rarefied = rarefy_even_depth(physeq2, rngseed=1, sample.size=0.9*min(sample_sums(physeq2)), replace=F)

#Plot abundance for genus or species
top_otus <- names(sort(taxa_sums(physeq2), TRUE)[1:20]) 
otus_20 <- prune_taxa(top_otus,physeq2)
plot_bar(otus_20, fill = "Genus") + facet_wrap(~Sample_location, scales = "free_x", nrow = 1)

# Calculate bray-curtis distance for beta diversity
distbc <- distance(physeq2, method = "bray")
ordBC <- ordinate(physeq2, method = "PCoA", distance = distbc)

#Plot for beta diversity (with Bray-Curtis distance)
plot_ordination(physeq = physeq2,ordination = ordBC,color = Sample_location) + geom_point(aes(color = Sample_location), alpha = 0.7, size = 4)

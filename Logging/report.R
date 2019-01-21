# Import Packages
library("biomformat")
library("phyloseq")
library("ggplot2")
library("hrbrthemes")
library("microbiome")
library("RColorBrewer")


#Import Dataset | All Samples | Used for plot the general tree

tree_path <- "/home/ray2g/kraken_biom.txt"
tree_biom <- read_biom(tree_path)
samples <- import_biom(tree_biom, parseFunction = parse_taxonomy_greengenes)

# Import Dataset | Sample Location | 50 samples
path <- "/home/ray2g/merged_table.biom"

# Read biom table from path
table <- read_biom(path)
names(table)

# Import biom table in phyloseq
physeq <- import_biom(table, parseFunction = parse_taxonomy_greengenes)
tax_table <- tax_table(physeq)[, 1:7]
rank_names(physeq)
sample_names(physeq)

# Import map file 
mapfile <- read.table('/home/ray2g/mapfile.txt', sep=',', comment='', head=T, row.names=1, strip.white = TRUE)
rownames(mapfile)

# Check if the sample names are the same as the file file
all(rownames(mapfile) %in% sample_names(physeq))

# Import map file for phyloseq
sample_data <- sample_data(mapfile)

# Merged biom table and map file
physeq2 <- merge_phyloseq(sample_data, physeq, tree_random )
#sample_variables(physeq2)

physeq2

# Permutacion
pseq <- physeq2

#Sumarization

summarize_phyloseq(pseq)
nsamples(pseq)
ntaxa(pseq)
#top_taxa(pseq, n = 10)
meta <- meta(pseq)

# Tree code | All samples

OTU <- otu_table(samples)           
TAX <- tax_table(samples)

tree2 <- (phyloseq(OTU,TAX))

random_tree = rtree(ntaxa(tree2), rooted=TRUE, tip.label=taxa_names(tree2))
#plot(random_tree)

tree3 <- merge_phyloseq(tree2, random_tree) # merge phyloseq objects

treetop50 <- names(sort(taxa_sums(tree3), decreasing = TRUE))[1:50]
tree_top50 <- transform_sample_counts(tree3, function(OTU) OTU/sum(OTU))
tree.top50 <- prune_taxa(treetop50, tree_top50)

# Plot tree | All Samples
plot_tree_all <- plot_tree(tree.top50, label.tips="taxa_names", ladderize="left", plot.margin=0.3)

# Random Tree | Samples Location
tree_random <- rtree(ntaxa(physeq), rooted=TRUE, tip.label=taxa_names(physeq))

# Plot tree for sample location
plot_tree_sl <- plot_tree(pseq.top20, color="Genus", shape="Sample_location", label.tips="taxa_names", ladderize="right", plot.margin=0.3)

# Count
samplesum <- data.frame(sum= sample_sums(physeq2))

# Distribution
distribution_sample <- ggplot(samplesum, aes(x=sum)) + geom_histogram(color="black", fill="indianred", binwidth = 2500) +
ggtitle("Distribution of sample depth") + xlab("Read counts") + theme(axis.title.y = element_blank())

#Set the variables of the samples to use in the colors of the plots
Sample_location <- factor(sample_data(physeq2)$Sample_location,levels = c("eye", "nasopharyngeal", "oral", "skin", "vaginal"))
ordBC <- ordinate(physeq = physeq2, method = "PCoA", distance = distbc)

# Rarefation samples(optional)
ps.rarefied = rarefy_even_depth(physeq2, rngseed=1, sample.size=0.9*min(sample_sums(physeq2)), replace=F)

# Plot abundance for genus or species(use physeq2 or ps.rarefied)

#plot_bar(physeq2, fill = "Genus") + facet_wrap(~Sample_location, scales = "free_x", nrow = 1)
#plot_bar(physeq2, fill= "Species") + facet_wrap(~Sample_location, scales = "free_x", nrow = 1)

#plot_bar(ps.rarefied, fill = "Genus") + facet_wrap(~Sample_location, scales = "free_x", nrow = 1)
#plot_bar(ps.rarefied, fill= "Species") + facet_wrap(~Sample_location, scales = "free_x", nrow = 1)

# Calculate bray-curtis distance for beta diversity
distbc <- distance(physeq2, method = "bray")
ordBC <- ordinate(physeq2, method = "PCoA", distance = distbc)

#Plot for beta diversity (with Bray-Curtis distance)
#plot_ordination(physeq = physeq2,ordination = ordBC,color = Sample_location) + geom_point(aes(color = Sample_location), alpha = 0.7, size = 4)

# Head Taxa

head(get_taxa_unique(pseq, "Kingdom"))
head(get_taxa_unique(pseq, "Phylum"))
head(get_taxa_unique(pseq, "Class"))
head(get_taxa_unique(pseq, "Order"))
head(get_taxa_unique(pseq, "Family"))
head(get_taxa_unique(pseq, "Genus"))
head(get_taxa_unique(pseq, "Species"))

# Relative abundances
otu.relative <- head(data.frame(abundances(pseq, "compositional")))

# Tops

top20 <- names(sort(taxa_sums(pseq), decreasing = TRUE))[1:20]
pseq_top20 <- transform_sample_counts(pseq, function(OTU) OTU/sum(OTU))
pseq.top20 <- prune_taxa(top20, pseq_top20)

top30<- names(sort(taxa_sums(pseq), decreasing = TRUE))[1:30]
pseq_top30 <- transform_sample_counts(pseq, function(OTU) OTU/sum(OTU))
pseq.top30 <- prune_taxa(top30, pseq_top30)

top50<- names(sort(taxa_sums(pseq), decreasing = TRUE))[1:50]
pseq_top50 <- transform_sample_counts(pseq, function(OTU) OTU/sum(OTU))
pseq.top50 <- prune_taxa(top50, pseq_top50)

top100<- names(sort(taxa_sums(pseq), decreasing = TRUE))[1:100]
pseq_top100 <- transform_sample_counts(pseq, function(OTU) OTU/sum(OTU))
pseq.top100 <- prune_taxa(top100, pseq_top100)

# Core
'
seq.rel <- microbiome::transform(pseq, "compositional")
ore.taxa.standard <- core_members(pseq.rel, detection = 0, prevalence = 50/100)
seq.core <- core(pseq.rel, detection = 0, prevalence = .5)
ore.taxa <- taxa(pseq.core)

revalences <- seq(.05, 1, .05)
detections <- 10^seq(log10(1e-3), log10(.2), length = 10)


# Plot Core

plot_core <- plot_core(pseq, plot.type = "heatmap", 
                       prevalences = prevalences,
                       detections = detections,
                       colours = rev(brewer.pal(5, "Spectral")),
                       min.prevalence = .2, horizontal = TRUE)
'
# Violin Plot

df_pseq <- psmelt(pseq.top20)
violin_plot <- ggplot(df_pseq, aes(x="Sample Location", y="Abundance")) + geom_violin(aes(fill=Sample_location)) 

# Plot Composition for sample location

psl_composition_Kingdom <- plot_composition(pseq.top20, taxonomic.level = "Kingdom", average_by = "Sample_location", transform = "compositional") +
  labs(x = "Sample Location", y = "Relative abundance (%)", title = "Relative abundance data", subtitle = "Kingdom") +
  geom_point(color="black", position="jitter", size=1) + theme_classic()

psl_composition_Phylum <- plot_composition(pseq.top20, taxonomic.level = "Phylum", average_by = "Sample_location", transform = "compositional") +
  labs(x = "Sample Location", y = "Relative abundance (%)", title = "Relative abundance data", subtitle = "Phylum") +
  geom_point(color="black", position="jitter", size=1) + theme_classic()

psl_composition_Class <- plot_composition(pseq.top20, taxonomic.level = "Class", average_by = "Sample_location", transform = "compositional") +
  labs(x = "Sample Location", y = "Relative abundance (%)", title = "Relative abundance data", subtitle = "Class") +
  geom_point(color="black", position="jitter", size=1) + theme_classic()

psl_composition_Order <- plot_composition(pseq.top20, taxonomic.level = "Order", average_by = "Sample_location", transform = "compositional") +
  labs(x = "Sample Location", y = "Relative abundance (%)", title = "Relative abundance data", subtitle = "Order") +
  geom_point(color="black", position="jitter", size=1) + theme_classic()

psl_composition_Family <- plot_composition(pseq.top20, taxonomic.level = "Family", average_by = "Sample_location", transform = "compositional") +
     labs(x = "Sample Location", y = "Relative abundance (%)", title = "Relative abundance data", subtitle = "Family") +
     geom_point(color="black", position="jitter", size=1) + theme_classic()

psl_composition_Genus <- plot_composition(pseq.top20, taxonomic.level = "genus", average_by = "Sample_location", transform = "compositional") +
  labs(x = "Sample Location", y = "Relative abundance (%)", title = "Relative abundance data", subtitle = "Genus") +
  geom_point(color="black", position="jitter", size=1) + theme_classic()

psl_composition_Species <- plot_composition(pseq.top20, taxonomic.level = "genus", average_by = "Sample_location", transform = "compositional") +
  labs(x = "Sample Location", y = "Relative abundance (%)", title = "Relative abundance data", subtitle = "Species") +
  geom_point(color="black", position="jitter", size=1) + theme_classic()

# BarPlot

bp_Kingdom <-plot_composition(pseq.top20,
                             taxonomic.level = "Kigdom", plot.type = "barplot") + 
  labs(x = "Samples", y = "Relative abundance (%)", title = "Relative abundance data", subtitle = "Kingdom") + 
  theme_ipsum(grid="Y")+ theme_grey() + theme(axis.text.x = element_text(angle = 90, hjust = 1))


bp_Phylum <-plot_composition(pseq.top20,
                             taxonomic.level = "Phylum", plot.type = "barplot") +
  labs(x = "Samples", y = "Relative abundance (%)", title = "Relative abundance data", subtitle = "Phylum") + 
  theme_ipsum(grid="Y") + theme_grey() + theme(axis.text.x = element_text(angle = 90, hjust = 1))


bp_Class <-plot_composition(pseq.top20,
                             taxonomic.level = "Class", plot.type = "barplot") +
  labs(x = "Samples", y = "Relative abundance (%)", title = "Relative abundance data", subtitle = "Class") + 
  theme_ipsum(grid="Y") + theme_grey() + theme(axis.text.x = element_text(angle = 90, hjust = 1))

bp_Order <-plot_composition(pseq.top20,
                             taxonomic.level = "Order", plot.type = "barplot") +
  labs(x = "Samples", y = "Relative abundance (%)", title = "Relative abundance data", subtitle = "Order") + 
  theme_ipsum(grid="Y")+ theme_grey() + theme(axis.text.x = element_text(angle = 90, hjust = 1))


bp_Family <-plot_composition(pseq.top20,
                             taxonomic.level = "Family", plot.type = "barplot") + 
                             labs(x = "Samples", y = "Relative abundance (%)", title = "Relative abundance data", subtitle = "Family") + 
                             theme_ipsum(grid="Y")+ theme_grey() + theme(axis.text.x = element_text(angle = 90, hjust = 1))



bp_Genus <- plot_composition(pseq.top20,
                      taxonomic.level = "Genus", plot.type = "barplot") +
                      labs(x = "Samples", y = "Relative abundance (%)", title = "Relative abundance data", subtitle = "Genus") + 
                      theme_ipsum(grid="Y")+ theme_grey() + theme(axis.text.x = element_text(angle = 90, hjust = 1))


bp_Species <- plot_composition(pseq.top20,
                                taxonomic.level = "Species", plot.type = "barplot") + 
                                labs(x = "Samples", y = "Relative abundance (%)", title = "Relative abundance data", subtitle = "Species") + 
                                theme_ipsum(grid="Y")+ theme_grey() + theme(axis.text.x = element_text(angle = 90, hjust = 1))

# BarPlot for each location

sl_kingdom <- plot_bar(pseq.top20, "Family", fill="Kingdom", facet_grid=~Sample_location)
sl_phylum <- plot_bar(pseq.top20, "Family", fill="Phylum", facet_grid=~Sample_location)
sl_class <- plot_bar(pseq.top20, "Family", fill="Class", facet_grid=~Sample_location)
sl_order <- plot_bar(pseq.top20, "Family", fill="Order", facet_grid=~Sample_location)
sl_family <- plot_bar(pseq.top20, "Family", fill="Family", facet_grid=~Sample_location)
sl_genus <- plot_bar(pseq.top20, "Family", fill="Genus", facet_grid=~Sample_location)
sl_species <- plot_bar(pseq.top20, "Family", fill="Species", facet_grid=~Sample_location)


# Heatmap

k_bacteria <- subset_taxa(pseq2, Kingdom =="Bacteria")
hm_k_bacteria <- heatmap(otu_table(a), scale="column", col = terrain.colors(256), main="Heatmap | Kingdom |Bacteria")

# Agregate by Domain

pseq_kingdom <- aggregate_taxa(pseq, "Kingdom")
pseq_phylum <- aggregate_taxa(pseq, "Phylum")
pseq_class <- aggregate_taxa(pseq, "Class")
pseq_order <- aggregate_taxa(pseq, "Order")
pseq_family <- aggregate_taxa(pseq, "Family") 
pseq_genus <- aggregate_taxa(pseq, "Genus")
pseq_Species <- aggregate_taxa(pseq, "Species")

# Heatmap by domain

#plot_heatmap(pseq_kingdom, taxa.label="Kingdom", title = " HeatMap | Kingdom")
#plot_heatmap(pseq_phylo, taxa.label="Phylum", title = " HeatMap | Phylum")
#plot_heatmap(pseq_class, taxa.label="Class", title = " HeatMap | Class")
#plot_heatmap(pseq_order, taxa.label="Order", title = " HeatMap | Order")
#plot_heatmap(pseq_family, taxa.label="Family", title = " HeatMap | Family")
#plot_heatmap(pseq_genus, taxa.label="Genus", title = " HeatMap | Genus")
#plot_heatmap(pseq_Species, taxa.label="Species", title = " HeatMap | Species")

# Taxa Prevalence
#p6 <- plot_taxa_prevalence(pseq, "Phylum", detection = 10) 



#Output

# 1. Open jpeg file
pdf("report_analysis_2.pdf", width = "1000", height = "600")
# 2. Create the plot

#Distribution Samples
distribution_sample

# Plot abundance for genus or species(use physeq2 or ps.rarefied)

#plot_bar(physeq2, fill = "Genus") + facet_wrap(~Sample_location, scales = "free_x", nrow = 1)
#plot_bar(physeq2, fill= "Species") + facet_wrap(~Sample_location, scales = "free_x", nrow = 1)

#plot_bar(ps.rarefied, fill = "Genus") + facet_wrap(~Sample_location, scales = "free_x", nrow = 1)
#plot_bar(ps.rarefied, fill= "Species") + facet_wrap(~Sample_location, scales = "free_x", nrow = 1)

#Plot for beta diversity (with Bray-Curtis distance)
plot_ordination(physeq = physeq2,ordination = ordBC,color = Sample_location) +
  geom_point(aes(color = Sample_location), alpha = 0.7, size = 4)

# Plot Tree
plot_tree_all
plot_tree_sp

# Plot Composition for sample location
psl_composition_Kingdom
psl_composition_Phylum
psl_composition_Class
psl_composition_Order
psl_composition_Family
psl_composition_Genus
psl_composition_Species

# BarPlot
bp_Kigdom
bp_Phylum
bp_Class
bp_Order
bp_Family
bp_Genus
bp_Species

# BarPlot for each location
sl_kingdom
sl_phylum
sl_class
sl_order
sl_family
sl_genus 
sl_species 

# Heatmap
hm_k_bacteria

plot_heatmap(pseq_kingdom, taxa.label="Kingdom", title = " HeatMap | Kingdom")
plot_heatmap(pseq_phylo, taxa.label="Phylum", title = " HeatMap | Phylum")
plot_heatmap(pseq_class, taxa.label="Class", title = " HeatMap | Class")
plot_heatmap(pseq_order, taxa.label="Order", title = " HeatMap | Order")
plot_heatmap(pseq_family, taxa.label="Family", title = " HeatMap | Family")
plot_heatmap(pseq_genus, taxa.label="Genus", title = " HeatMap | Genus")
plot_heatmap(pseq_Species, taxa.label="Species", title = " HeatMap | Species")


# 3. Close the file
dev.off()




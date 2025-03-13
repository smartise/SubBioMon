library(phyloseq)
library(tidyverse)

load("PHYL.Rdata")

data <- psmelt(ALB)

DETECT_SPECIES <- data %>%
  as_tibble()%>%
  mutate(pident = as.numeric(pident))%>%
  filter(pident > 99 & Superkingdom == 'Eukaryota' & length > 500 & Abundance != 0)%>%
  group_by(sample_Sample, Genus, Species)%>%
  summarise(Abundance = sum(Abundance))

save(DETECT_SPECIES, file = "DETECT_SPECIES.RDATA")

estimate_richness(LOCO, split = T)

plot_bar(LOCO, fill = "Kingdom")

rank_names(LOCO)
plot_heatmap(LOCO, method = "NMDS", distance = "bray", taxa.label="Order", sample.label = "Sample")

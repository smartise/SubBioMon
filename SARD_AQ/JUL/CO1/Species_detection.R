library(phyloseq)
library(tidyverse)
library(rstudioapi)

#this.dir <- dirname(getActiveDocumentContext()$path)
this.dir <- dirname(getActiveDocumentContext()$path)

setwd(this.dir)

load("PHYL_JUL.Rdata")

data <- psmelt(AQJUL)

DETECT_SPECIES <- data %>%
  as_tibble()%>%
  mutate(pident = as.numeric(pident))%>%
  filter(pident > 99 & length > 500 & Abundance != 0)%>%
  group_by(sample_Sample, Superkingdom, Genus, Species)%>%
  summarise(Abundance = sum(Abundance))

save(DETECT_SPECIES, file = "DETECT_SPECIES.RDATA")


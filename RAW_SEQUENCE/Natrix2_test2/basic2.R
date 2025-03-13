
library(tidyverse)

this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)
#data <- load("/Users/oliviercollard/Library/CloudStorage/OneDrive-Personal/OBSIDIAN/Project_Panama/Data/SEQUENCE/eDNA/RAW_SEQUENCE/Natrix2_test2/Cleaned/OTU.RData")

data <- load("Cleaned/OTU.RData")

sampling_coverage <- OTU %>%
  pivot_longer(-sample)%>%
  group_by(sample)%>%
  summarise(n_seqs = sum(value))

moy <- sampling_coverage%>%
  summarise(n_seqs = sum(n_seqs)/48)


a <-sampling_coverage %>%
  ggplot(aes(x=n_seqs))+
  geom_histogram()

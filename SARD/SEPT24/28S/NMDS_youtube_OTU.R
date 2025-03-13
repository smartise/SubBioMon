library(vegan)
library(tidyverse)
library(ggrepel)
library(broom)
library(phyloseq)

#this.dir <- dirname(getActiveDocumentContext()$path)
this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)

load("PHYL.Rdata")
source("~/OneDrive/OBSIDIAN/Project_Panama/Data/SEQUENCE/eDNA/theme_plot.R")

plot_bar(LOCO, x="sample_Sample")

OTU <- as.data.frame(otu_table(LOCO))

sample_names <- sample_data(LOCO)$Sample
replicate <- sample_data(LOCO)$Replicate
sample_names <- data.frame(sample_names, replicate)
sample_names <- sample_names %>%
  unite("sample", sample_names, replicate, sep = "_")

colnames(OTU) <- sample_names$sample

OTU <- t(OTU)%>%
  as.data.frame()%>%
  rownames_to_column(var = "sample")%>%
  filter(!str_detect(sample, "P3R1"), 
         !str_detect(sample, "P3_"))
  

dist <- OTU %>%
  column_to_rownames("sample")%>%
  avgdist(sample = 10000)

nmds_meta <- OTU %>% 
  select(sample)

set.seed(1)
nmds <- metaMDS(dist) %>%
  scores() %>%
  as_tibble(rownames="sample")

nmds_meta_num <- nmds %>%
  separate(sample, into = c("sample", "replicate"), sep = "_(?=[^_]+$)", remove = FALSE)

subsample <- OTU %>%
  pivot_longer(-sample)%>%
  group_by(name)%>%
  uncount(value)%>%
  slice_sample(n = 20000)%>%
  count(sample, name)%>%
  pivot_wider(names_from = "name", values_from = "n", values_fill = 0)%>%
  pivot_longer(-sample)

nmds_shared <- inner_join(subsample, nmds)

cor_x <- nmds_shared %>%
  nest(data = -name)%>%
  mutate(cor_x = purrr::map(data, ~cor.test(.x$value, .x$NMDS1, method = "spearman", exact = F) %>%   tidy()))%>%
  unnest(cor_x)%>%
  select(name, estimate, p.value)

cor_y <- nmds_shared %>%
  nest(data = -name)%>%
  mutate(cor_y = purrr::map(data, ~cor.test(.x$value, .x$NMDS2, method = "spearman", exact = F) %>%   tidy()))%>%
  unnest(cor_y)%>%
  select(name, estimate, p.value)

correlation <- inner_join(cor_x, cor_y, by = "name")

correlation %>%
  filter(p.value.x < 0.0000000000001 | p.value.y < 0.0000000000001)
high_corr <- correlation
high_corr <- correlation %>%
  filter(estimate.x > 0.78 | estimate.x < -0.92 | abs(estimate.y) > 0.85 )


### the plot 

centroid <- nmds_meta_num %>%
  group_by(sample) %>%
  summarize(NMDS1=mean(NMDS1), NMDS2=mean(NMDS2))

a <-ggplot(nmds_meta_num, aes(x=NMDS1, y=NMDS2, color=sample)) + 
  stat_ellipse(aes(fill = sample, color = sample), geom = "polygon", alpha = 0.2) +
  geom_point(data= centroid, size = 5, shape = 21, color = "black", 
             aes(fill = sample))+
  #scale_fill_manual(values=c("#4B0055", "#00588B", "#009B95"))+
  #scale_color_manual(values=c("#4B0055", "#00588B", "#009B95"))+
  geom_point(alpha = 0.4)
#geom_segment(data = high_corr, 
             #aes(x = 0, y = 0, xend = estimate.x, yend = estimate.y),
             #arrow = arrow(length = unit(0.1, "cm")), 
             #color = "black", linewidth = 1, inherit.aes = FALSE, alpha = 0.5) +  # Use linewidth instead of size
  #geom_text_repel(data = high_corr, 
                  #aes(x = estimate.x, y = estimate.y, label = name), 
                  #hjust = 1.5, vjust = 1.5, size = 5, inherit.aes = FALSE, 
                  #min.segment.length = 0.001) + 
  #geom_hline(yintercept = 0, linetype="dotted", color="grey") + 
  #geom_vline(xintercept = 0, linetype="dotted", color="grey") +
  #labs(color = "Species", fill = "Species")  +
  #facet_grid(. ~ Locality)+

save(a, file = "NMDS.RData")


# Embed the image in an HTML file (using RMarkdown or HTML directly)


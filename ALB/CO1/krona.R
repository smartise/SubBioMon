library(phyloseq)
library(tidyverse)
library(tibble)
source('https://raw.githubusercontent.com/markschl/embed_krona/master/embed_krona.R')
library(rstudioapi)
data(GlobalPatterns)
this.dir <- dirname(getActiveDocumentContext()$path)

setwd(this.dir)

load("PHYL.Rdata")

TAX_TABLE <- as.data.frame(tax_table(ALB)) %>% 
  select(-c(1:10))

tax_table(ALB) <- tax_table(as.matrix(TAX_TABLE))

plot_krona(ALB, group_vars = 'Sample', output = 'krona_plot.html')

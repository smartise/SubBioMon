library(phyloseq)
library(tidyverse)
library(tibble)
source('https://raw.githubusercontent.com/markschl/embed_krona/master/embed_krona.R')
library(rstudioapi)

this.dir <- dirname(getActiveDocumentContext()$path)

setwd(this.dir)

load("PHYL_JUL.Rdata")

TAX_TABLE <- as.data.frame(tax_table(AQJUL)) %>% 
  select(-c(1:10))

tax_table(AQJUL) <- tax_table(as.matrix(TAX_TABLE))

plot_krona(AQJUL, group_vars = 'Sample', output = 'krona_plot.html')

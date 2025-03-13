library(phyloseq)
library(tibble)
source('https://raw.githubusercontent.com/markschl/embed_krona/master/embed_krona.R')

data(GlobalPatterns)
this.dir <- dirname(getActiveDocumentContext()$path)

setwd(this.dir)

load("PHYL.Rdata")

TAX_TABLE <- as.data.frame(tax_table(LOCO)) %>% 
  select(-c(1:10))

tax_table(LOCO) <- tax_table(as.matrix(TAX_TABLE))

plot_krona(LOCO, group_vars = 'Sample', output = 'krona_plot.html')

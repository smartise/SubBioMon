library(tidyverse)
library(readxl)
library(rstudioapi)
library(phyloseq)

this.dir <- dirname(getActiveDocumentContext()$path)

setwd(this.dir)

data <- read.csv("blast_ncbi/OTU_table.csv", stringsAsFactors = FALSE) 
metadata <- read_tsv("blast/blast_taxonomy_all.tsv")
taxonomy <- read_tsv("blast/lineage.tsv")
barcoding <- read_excel("barcode.xlsx")
  
taxonomy <- taxonomy %>%
  filter(!is.na(Query))%>%
  select(-c(1,3, 4:9, 12, 14, 16, 18, 20, 22, 24, 26, 27))%>%
  setNames(c("taxonomy", "Group", "Superkingdom", "Kingdom", "Phylum", "Class", "Order", "Family", "Genus", "Species"))%>%
  mutate(taxonomy = as.numeric(taxonomy))

META_TABLE <- barcoding %>%
  filter(Marker == "28S")%>%
  column_to_rownames("Barcode")

TAX_TABLE <- metadata %>%
  separate(seqid, into = c("seqid", "size"), sep = ";", remove = T)%>%
  select(-c(2, 14:18))%>%
  group_by(seqid)%>%
  slice_max(order_by = pident, n = 1)%>%
  slice_head(n=1)%>%
  left_join(taxonomy, by ="taxonomy")%>%
  select(-c(12:13))%>%
  unique()%>%
  column_to_rownames("seqid")%>%
  mutate(across(everything(), ~ replace_na(.x, "Unknown")))
  

OTU_TABLE <- data %>%
  as_tibble()%>%
  filter(!is.na(seqid))%>%
  filter(str_detect(seqid, ">")) %>%
  mutate(seqid = str_extract(seqid, "(?<=^>)\\d+"))%>%
  pivot_longer(-1)%>%
  mutate(barcode = as.numeric(str_extract(name, "\\d{2}")))%>%
  select(-name)%>%
  pivot_wider(names_from = "seqid", values_from = "value")%>%
  pivot_longer(-barcode)%>%
  pivot_wider(names_from = "barcode", values_from = "value")%>%
  column_to_rownames("name")

physeq <- phyloseq(
  otu_table(as.matrix(OTU_TABLE), taxa_are_rows = TRUE),
  tax_table(as.matrix(TAX_TABLE)),
  sample_data(META_TABLE)
)
ALB <- subset_samples(physeq, (Country == "ALBANIA"))
PAL <- subset_samples(physeq, (Site == "PALINURO"))
LOCO <- subset_samples(physeq, (Site == "LOCOLI" & Habitat !="AQUEDUCT" ))
AQJUL <- subset_samples(physeq, (Habitat == "AQUEDUCT"& Month == "JULY"))
AQAUG <- subset_samples(physeq, (Habitat == "AQUEDUCT"& Month == "AUG"))
  
save(ALB, file = "/Users/oliviercollard/Library/CloudStorage/OneDrive-Personal/OBSIDIAN/Project_Panama/Data/SEQUENCE/eDNA/ALB/28S/PHYL.Rdata")
save(PAL, file = "/Users/oliviercollard/Library/CloudStorage/OneDrive-Personal/OBSIDIAN/Project_Panama/Data/SEQUENCE/eDNA/PAL/28S/PHYL.Rdata")
save(LOCO, file = "/Users/oliviercollard/Library/CloudStorage/OneDrive-Personal/OBSIDIAN/Project_Panama/Data/SEQUENCE/eDNA/SARD/SEPT24/28S/PHYL.Rdata")
save(AQJUL, file = "/Users/oliviercollard/Library/CloudStorage/OneDrive-Personal/OBSIDIAN/Project_Panama/Data/SEQUENCE/eDNA/SARD_AQ/JUL/28S/PHYL_JUL.Rdata")
save(AQAUG, file = "/Users/oliviercollard/Library/CloudStorage/OneDrive-Personal/OBSIDIAN/Project_Panama/Data/SEQUENCE/eDNA/SARD_AQ/AUG/28S/PHYL_AUG.Rdata")


library(tidyverse)

srcs <- list.files("R", pattern = "\\.R$", full.names = TRUE)
walk(srcs, source)

lmat <- read_tsv("data/lmat_example.tsv")
samp <- tbl_df(data.frame(
  sample = unique(lmat$sample),
  treatment = sample(c("A", "B", "C"), size = length(unique(lmat$sample)), replace = TRUE)
))

lmat_microbes <- keep_lmat_microbes(lmat)

lmat_genus <- sum_lmat_at_rank(lmat_microbes, genus)
lmat_species <- sum_lmat_at_rank(lmat_microbes, species)
lmat_clr <- list(genus = lmat_genus, species = lmat_species) %>%
  imap(~{
   clrtransform_lmat(
     lmat = .x, samp = samp, treatment, tax_rank = !!sym(.y),
     denom = 'zero', useMC = TRUE
   )
  })

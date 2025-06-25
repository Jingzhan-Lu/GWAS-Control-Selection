# ------------------------------
# Random Control Selection Script
# ------------------------------
# Selects 1:4 random controls for binary phenotype
# Author: [Jingzhan Lu]
# Date: [25 Jun. 2025]
# ------------------------------
# Usage:
#   Rscript random_controls.R input_pheno.gz output_file.gz [ratio]
# ------------------------------

# Load phenotype data
pheno <- read.table("your_pheno_file.gz", header = TRUE, sep = "\t")

# Subset and sample
case_group <- subset(pheno, pheno == 1)
control_group <- subset(pheno, pheno == 0)
set.seed(42)
random_selection <- control_group[sample(nrow(control_group), nrow(case_group) * 4), ]

# Combine and write output
combined_data <- rbind(case_group, random_selection)
write.table(combined_data, gzfile("random_output.gz"), sep = "\t", quote = FALSE, row.names = FALSE)

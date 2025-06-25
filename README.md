# GWAS Case-Control Matching Scripts (Random & Matched Controls)

This repository contains R scripts used in the analysis for our manuscript submitted to Bioinformatics Journal. The primary aim of this codebase is to perform genome-wide association studies (GWAS) using two different control selection strategies:
Matched Controls: Cases are matched to controls based on predefined criteria (e.g. age, genetoping chips, recruitment centre, genetics PCs, etc.)
Random Selection: Controls are randomly selected from the general population without matching.

Getting Started
Prerequisites
R version ≥ 4.0

Required packages:
MatchIt (for propensity score matching)
dplyr
ggplot2

You can install required packages via:
install.packages(c("dplyr", "data.table", "ggplot2"))
# For matching:
install.packages("MatchIt")

Default matching case-control ratio is 1 : 4

Customizable: you can adjust the matching ratio by modifying the ratio parameter in the script (e.g., matchit(..., ratio = 2) for 1:2 matching).

# Usage
1. Matched Control Selection
source("matched_controls.R")
This will generate a matched case-control dataset using nearest neighbor or propensity score matching.
2. Random Control Selection
source("random_controls.R")
This will randomly select controls from a specified eligible population.

3. Downstream GWAS
Both scripts output .csv file that can be used in downstream GWAS analysis with tools such as plink, or REGENIEE.

Output
Matched or random control dataset (data.frame)
Summary tables (case/control counts, demographics)
eQQ plots (e.g., distribution of covariates before/after matching)

📄 Citation
If you use this code, please cite our article (upon acceptance):
Lu et al. (2025). Impact of control selection strategies on GWAS results: a study of prostate cancer in the UK Biobank. Bioinformatics Journal, 2025.

📬 Contact
For questions or collaboration requests, please contact:
Jingzhan Lu – 106316153@gms.tcu.edu.tw


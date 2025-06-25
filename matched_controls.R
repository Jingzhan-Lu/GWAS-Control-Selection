# ------------------------------
# Matched Control Selection
# ------------------------------
# Selects 1:4 matched controls for binary phenotype
# Author: [Jingzhan Lu]
# Date: [25 Jun. 2025]

# Prepare the essential files
setwd("//…/Desktop/Working_space") # Set working dir and load library
# Install and load MatchIt if not already installed
if (!requireNamespace("MatchIt", quietly = TRUE)) 
install.packages("MatchIt")
library("MatchIt") #install and import the library

# Load covariate + phenotype data
pheno <- read.table("your_pheno_file.gz", header = TRUE, sep = "\t")
covar <- read.csv("your_covar_file.csv", header = TRUE, sep = ",") #loading the covariates file for your phenotype
data <- merge(pheno, covar, by = "eid")
head(data) # read in data
table(data$pheno)   # Check data case and control numbers

# Run the Matching process
model_match <- matchit(pheno~PC1 + PC2 + PC3 + … + PC39 +PC40
       +age+centre+sequencing_centre,
                       data = data,
                       ratio = 4,
                       method = "nearest")

match_summary <- summary(model_match)
plot(model_match, type = "qq", interactive = FALSE, which.xs = ~age+centre+sequencing_centre)
plot(model_match, type = "histogram")
plot(model_match, type = "jitter", interactive = FALSE)

# Get matched IDs
matched <- match.data(model_match)
head(matched)
table(matched$pheno)

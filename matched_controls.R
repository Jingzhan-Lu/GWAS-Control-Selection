# Prepare the essential files
setwd("//…/Desktop/Working_space") # Set working dir and load library
install.packages('MatchIt')
library("MatchIt") #install and import the library
pc_covar <- read.csv("pc_covar.csv", header = TRUE, sep = ",") #loading the covariates file for your phenotype
data <- pc_covar
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

# Integration of Rob’s GWAS pipeline (REGENIE) with visualization 'topr' tools (Manhattan and QQ plots), along with Alok’s Chr:POS to rsID (SNP) conversion pipeline on Slade.
#Notice: This code is used for visulise the GWAS results on DNAnexus only (Exeter GOCT groups) :)
#https://github.com/totajuliusd/topr
#https://kscott-1.github.io/topr/articles/topr.html

#dx ls
#dx download -r ratio_RINT_burden_wgs/imputed

file_list <- list.files(path = "/home/rstudio-server/imputed", pattern = "*_chr.*\\.regenie$", full.names = TRUE)#any beginning name, contained the chr and ends by .regeneie file
data_list <- lapply(file_list, function(file) {
  read.csv(file, header = TRUE, sep = ' ')
})
combined_data <- do.call(rbind, data_list)
assoc1 <- combined_data[order(combined_data[,"LOG10P"], decreasing = TRUE), ]
assoc1 <- assoc1[, c("CHROM", "GENPOS", "ALLELE0", "ALLELE1", "LOG10P",'BETA', 'SE')]


install.packages('topr')  
library(topr)
library(dplyr)
tg_gwas_man <- assoc1 %>%  #Required columns are CHROM, POS and P
  mutate(
    POS = as.integer(GENPOS), #rename the column name
    P = 10^(-LOG10P)
  )

tg_gwas_man_filt <- tg_gwas_man[tg_gwas_man$P < 1e-4, ] #cut down some non-meaningful signal to speed up

png('TG_HDL_ratio_man.png', width = 7, height = 4, units = "in", res = 300)
manhattan(tg_gwas_man_filt, annotate = 5e-9)
dev.off()

png('TG_HDL_ratio_QQ.png', width = 7, height = 6, units = "in", res = 300)
qqtopr(tg_gwas_man_filt)
dev.off()

#LocusZoom with specific gene
png('CETP_regionplot.png', width = 8, height = 6, units = "in", res = 300)
regionplot(tg_gwas_man_filt, gene = "CETP")
dev.off()


##### How to transfer the CHR:GENOPOS to RSID (SNP) on Slade #########
#module load Anaconda3
#module load dxpy
#pip install polars
#python /slade/projects/Public_Ref_Datasets/dbsnp/scripts/rsid_assign_script.py
cd /slade/projects/Public_Ref_Datasets/dbsnp/scripts
python rsid_assign_script /slade/home/jl1426/TG_HDL_ratio.gz
#Enter pathway to file (supports .csv, .tsv, .parquet, .gz): /slade/home/jl***/0323_GWAS.csv
#Enter genomic build (hg37 or hg38): hg37
#Enter the name of the chromosome column (e.g., CHROM): CHROM
#Enter the name of the position column (e.g., GENPOS):GENPOS
#Enter the name of the effect allele column (e.g., ALLELE1): ALLELE1
#Enter the name of the other allele column (e.g., ALLELE0): ALLELE0

##### How to prepare the GWAS Phenotype file fro Rob's pipeline (df to .gz file format)#########
# creat a temporary dataframe file to save your phenotypes, which only required three columns: FID, IID and pheno
df_out <- data.frame(
  FID = df$eid,
  IID = df$eid,
  pheno = df$pheno  #0 for controls, 1 for cases. change for any column name you like, but this will be your REGENIE output files name!!!
)
# write to .gz file
gz_con <- gzfile(output_file, "w")
write.table(df_out, gz_con, quote = FALSE, row.names = FALSE, col.names = TRUE, sep = "\t")
close(gz_con)

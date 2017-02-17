# Fix STACKS STRUCTURE output to go into bi-winning_allele.py
rm(list = ls())

# Install function for packages    
packages<-function(x){
  x<-as.character(match.call()[[2]])
  if (!require(x,character.only=TRUE)){
    install.packages(pkgs=x,repos="http://cran.r-project.org")
    require(x,character.only=TRUE)
  }
}
packages(dplyr)

metadata <- read.csv("../Metadata/SigSelection.pop", sep = "\t", header = F)

stacksgenotypes <- data.table::fread("../output/batch_20170205.structure.tsv", header = F, sep="\t")
stacksmarkers <- read.table("../output/batch_20170205.structure.tsv", nrows = 1, skip = 1)

stacksmarkers <- as.data.frame(c("SSR", stacksmarkers))
write.table(stacksmarkers, "../output/batch_20170205_for_biallele.csv", sep = ",", col.names = F, row.names = F, quote = F)
write.table(select(stacksgenotypes, -V2), "../output/batch_20170205_for_biallele.csv", col.names = F, sep = ",", row.names = F, , append = T, quote = F)

system("python bi-winning_allele.py ../output/batch_20170205_for_biallele.csv -o ../output/batch_20170205_biallele.csv", intern = TRUE,
       ignore.stdout = FALSE, ignore.stderr = FALSE,
       wait = TRUE, input = NULL)

biallele <- read.table("../output/batch_20170205_biallele.csv", sep = ",", header = T)

geno <- as.data.frame(t(select(biallele, -SSR)))
write.table(geno, "../SS_Analysis/SmartPCA/20170205.geno", sep = "", col.names = F, row.names = F, quote = F)

ind <- select(stacksgenotypes, V1, V2) %>% unique()
ind$V1 <- as.factor(ind$V1)
ind <- left_join(ind, metadata, by=c("V1"="V1"))
ind$U <- "U"
ind <- select(ind, V1, U, V2.y)

write.table(ind, "../SS_Analysis/SmartPCA/20170205.ind", sep = "\t", col.names = F, row.names = F, quote = F)

snp <- colnames(biallele)
snp <- as.data.frame(snp[2:length(snp)])
snp$FakeChromo <- rep(1:(length(snp$`snp[2:length(snp)]`)/2), each=2)
snp$zero1 <- 0
snp$zero2 <- 0

write.table(snp, "../SS_Analysis/SmartPCA/20170205.snp", sep = "\t", col.names = F, row.names = F, quote = F)


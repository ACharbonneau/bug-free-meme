
stacksgenotypes <- data.table::fread("../output/batch_20170214.structure.tsv", header = F, sep="\t")
stacksmarkers <- read.table("../output/batch_20170214.structure.tsv", nrows = 1, skip = 1)
stacksmarkers <- as.data.frame(c("SSR", stacksmarkers))

write.table(stacksmarkers, "../output/batch_20170214_for_biallele.csv", sep = ",", col.names = F, row.names = F, quote = F)

write.table(select(stacksgenotypes, -V2), "../output/batch_20170214_for_biallele.csv", col.names = F, sep = ",", row.names = F, append = T, quote = F)

system("python bi-winning_allele.py ../output/batch_20170214_for_biallele.csv -o ../output/batch_20170214_biallele.csv", intern = TRUE,
       ignore.stdout = FALSE, ignore.stderr = FALSE,
       wait = TRUE, input = NULL)


geno <- as.data.frame(t(select(biallele, -SSR)))
write.table(geno, "../SS_Analysis/SmartPCA/20170214.geno", sep = "", col.names = F, row.names = F, quote = F)

ind <- select(biallele, SSR)
ind$SSR <- as.factor(ind$SSR)
ind <- left_join(ind, SSmeta, by=c("SSR"="V1"))
ind$U <- "U"
ind <- select(ind, SSR, U, V2)

write.table(ind, "../SS_Analysis/SmartPCA/20170214.ind", sep = "\t", col.names = F, row.names = F, quote = F)

snp <- colnames(biallele)
snp <- as.data.frame(snp[2:length(snp)])
#snp$FakeChromo <- rep(1:(length(snp$`snp[2:length(snp)]`)/104), each=104)
snp$FakeChromo <- rep(c(1:21), 104)
snp$zero1 <- 0
snp$zero2 <- 0

write.table(snp, "../SS_Analysis/SmartPCA/20170214rep.snp", sep = "\t", col.names = F, row.names = F, quote = F)


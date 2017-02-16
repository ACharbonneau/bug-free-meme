rm( list=ls())

source('/Volumes/Storage/RadishData/Scripts/Misc_scripts/AmandaSource.R', chdir = TRUE)
require(RColorBrewer)
require(dplyr)

##Get all the files from this directory to put into a single PDF
ALLTHEFILES <- dir("../STRUCTURE/parsed_data/")

File_Num <- length(ALLTHEFILES) #+1


for(krun in 1:File_Num){
  
krun <- krun + 2

str.data <- read.csv( paste("../STRUCTURE/parsed_data/STRUCTURE-", krun, "_f.parsed", sep=""), header=F)

pdf(file=paste("../figures/STRUCTURE_", krun,".pdf", sep=""), height=8, width=8)


K <- length(str.data[,c(5:ncol(str.data-3))]) # Find out what K is
str.data <- str.data[,c(2,3,5:ncol(str.data-3))] # Get only useful columns from STRUCTURE
colnames(str.data) <- c( "Individual", "%missing",1:K)
JustID <- regexpr("[0-9]+", str.data$Individual)
str.data$Individual <- as.factor(regmatches(str.data$Individual, JustID))


#Get the label/metadata about each individual from a seperate file. Join to remove all the "RA" and "NZIL" individuals

labels <- read.csv("../Metadata/SigSelectionMeta.csv", colClasses = "factor")

all.data <- left_join(str.data, labels, by=c("Individual" = "ID"))

all.data <- droplevels(all.data)


#For prettier plotting, lump all of the different species together. Later you'll plot each
#species seperately in a divided plotting screen
crop.data <- all.data[all.data$Species=="sativus",]
weed.data <- all.data[all.data$locals=="raphNN",]
native.data <- all.data[all.data$locals=="landra",]
raphNatW.data <- all.data[all.data$locals=="raphNatW",]
pugi.data <- all.data[all.data$locals=="pugiformis",]
daikon.data <- all.data[all.data$Taxon=="daikon",]
european.data <- all.data[all.data$Taxon=="european",]
oilrat.data <- all.data[all.data$Taxon=="caudatus" | all.data$Taxon=="oleifera",]

crop.table <- t(crop.data[3:(2+K)][order(crop.data$Order),])
daikon.table <- t(daikon.data[3:(2+K)][order(daikon.data$Order),])
weed.table <- t(weed.data[3:(2+K)][order(weed.data$Order),])
native.table <- t(native.data[3:(2+K)][order(native.data$Order),])
raphNatW.table <- t(raphNatW.data[3:(2+K)][order(raphNatW.data$Order),])
pugi.table <- t(pugi.data[3:(2+K)][order(pugi.data$Order),])
european.table <- t(european.data[3:(2+K)][order(european.data$Order),])
oilrat.table <- t(oilrat.data[3:(2+K)][order(oilrat.data$Order),])

colnames(crop.table) <- crop.data$Pop[order(crop.data$Order)]
colnames(native.table) <- native.data$Pop[order(native.data$Order)]
colnames(weed.table) <- weed.data$Pop[order(weed.data$Order)]
colnames(raphNatW.table) <- raphNatW.data$Pop[order(raphNatW.data$Order)]
colnames(pugi.table) <- pugi.data$Pop[order(pugi.data$Order)]
colnames(daikon.table) <- daikon.data$Pop[order(daikon.data$Order)]
colnames(european.table) <- european.data$Pop[order(european.data$Order)]
colnames(oilrat.table) <- oilrat.data$Pop[order(oilrat.data$Order)]


col_pal1 = brewer.pal(12, "Set3")
col_pal2 = brewer.pal(8, "Dark2")
col_pal3 = brewer.pal(12, "Paired")
col_pal_no_alpha = c(col_pal1, col_pal2, col_pal3)
col_pal = c(col_pal1, col_pal2, col_pal3)


#col_pal_no_alpha <- c(brewer.pal(9, "Set1"))
#col6 <- brewer.pal(6, "Set2")
#col_pal_no_alpha <- c(col6[6], col_pal_no_alpha[c(2:5)], col_pal_no_alpha[1], col_pal_no_alpha[8])

## Add an alpha value to a colour
add.alpha <- function(col, alpha=.7){
  if(missing(col))
    stop("Please provide a vector of colours.")
  apply(sapply(col, col2rgb)/255, 2, 
        function(x) 
          rgb(x[1], x[2], x[3], alpha=alpha))  
}

#col_pal <- add.alpha(col_pal_no_alpha)

K_text <- paste("STRUCTURE Plot K=", K, sep="")

par(mfrow=c(1,1), mar=c(0,0,0,0))
par(fig=c(0,1,.8,.9)) #new=TRUE)
barplot(native.table, col=col_pal[1:K], xaxt="n", yaxt="n", 
        space=c(rep(0,16),1, rep(0,15), 1, rep(0,15), 1,rep(0,15), 1,rep(0,15), 1,rep(0,15)))
axis(side=3, at=50, labels=c(K_text), cex=5, tick=F, line=.8)
axis(side=3, at=50, labels=expression(italic("R.r. landra")), cex=2, tick=F, line=-1)
axis(side=1, at=c(8,25,42,59,76,93), labels=c("France (PBFR)",
                                        "Spain (SAES)",
                                        "Algeria (RA226)", 
                                        "Italy (RA444)",
                                        "Turkey (RA761)",
                                        "Turkey (RA808)"), tick=F, line=-1, cex.axis=.9)


par(fig=c(0,.6,.63,.73), new=TRUE)
barplot(raphNatW.table, col=col_pal[1:K],  xaxt="n", yaxt="n", 
        space=c(rep(0,16), 1, rep(0,15), 1, rep(0,15)))
axis(side=3, at=25, labels=expression(paste(italic("R.r. raphanistrum")," inside native range")), cex=1.2, tick=F, line=-1)
axis(side=1, at=c(8,25,42), tick=F, labels=c("France (AFFR)", "Spain (DEES)", "Spain (MAES)"), line=-1, cex.axis=.9)


par(fig=c(.6,1,.63,.73), new=TRUE)
barplot(weed.table, col=col_pal[1:K],  xaxt="n", yaxt="n", 
        space=c(rep(0,16), 1, rep(0,15)))
axis(side=3, at=17, labels=expression(paste(italic("R.r. raphanistrum")," outside native range")), cex=1.2, tick=F, line=-1)
axis(side=1, at=c(8, 25), tick=F, labels=c("New York (BINY)","Australia (NAAU)"), line=-1, cex.axis=.9)



par(fig=c(.3,.7,.46,.56), new=TRUE)
barplot(pugi.table, col=col_pal[1:K],  xaxt="n", yaxt="n", 
        space=c(rep(0,16), 1, rep(0,15)))
axis(side=3, at=16.5, labels=expression(italic("R. pugiformis")), cex=1.2, tick=F, line=-1)
axis(side=1, at=c(8, 25), tick=F, labels=c("Israel (GMIL)","Israel (YEIL_CLNC)"), line=-1, cex.axis=.9)



par(fig=c(0.1,.5,.29,.39), new=TRUE)
barplot(daikon.table, col=col_pal[1:K], xaxt="n", yaxt="n",
        space=c(rep(0,7), 1, rep(0,5)))
axis(side=3, at=7.5, labels="Daikon Crops", cex=1.2, tick=F, line=-1)
axis(side=1, at=c(3.5,11), tick=F, labels=c("New Crown (NEJS)", #SPEU is now SPNK; NELO now NEJS; RACA now RAJS. -JKC 
                                                "Tokinashi (TOBG)"), line=-1, cex.axis=.9)


par(fig=c(.5,.9,.29,.39), new=TRUE)
barplot(european.table, col=col_pal[1:K], xaxt="n", yaxt="n", 
        space=c(rep(0,7),1, rep(0,6)) )
axis(side=3, at=7.5, labels="European Crops", cex=1.2, tick=F, line=-1)
axis(side=1, at=c(4,11.5), tick=F, labels=c("Early S.G. (ESNK)", 
                                                "Sparkler (SPNK)" ), line=-1, cex.axis=.9)

par(fig=c(.1,.9,.12,.22), new=TRUE)
barplot(oilrat.table, col=col_pal[1:K],  xaxt="n", yaxt="n", 
        space=c(rep(0,6),1, rep(0,5), 3, rep(0,5), 1,rep(0,4)) )
axis(side=3, at=c(6.5,22.5), labels=c("Rattail Crops", "Oilseed Crops" ), cex=1.2, tick=F, line=-1)
axis(side=1, at=c(3,10,19,25.5), tick=F, labels=c("Rattail (RABG)", "Rattail (RAJS)", 
                                                      "Arena (AROL)", "GRA (OIBG)" ), line=-1, cex.axis=.9)
dev.off()
}


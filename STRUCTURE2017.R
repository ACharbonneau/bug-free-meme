source('/Volumes/Storage/RadishData/Scripts/Misc_scripts/AmandaSource.R', chdir = TRUE)
require(ggplot2)
require(dplyr)
require(RColorBrewer)

########################################################



pdf(file="../figures/SigSelSTRUCTURE_ALL.pdf", height=8, width=8)

ghost_count <- c(0,0,0) #c("K", "Run", "Ghosts")
pop_ghost_count <- c(0,0,0)

########################################################


##Get all the files from this directory to put into a single PDF
#Sort the filelist into numerical order by K instead of order from filesystem

ALLTHEFILES <- dir("../STRUCTURE/parsed_data/")

File_Num <- length(ALLTHEFILES)

File_list <- data.frame(matrix(unlist(strsplit(ALLTHEFILES, "\\_|\\-")), ncol = 4, byrow = T))
File_list$runname <- ALLTHEFILES
colnames(File_list) <- c("randomization", "structure", "K", "f.parsed", "runname")
File_list$K <- as.numeric(levels(File_list$K))[File_list$K]
File_list$randomization <- as.numeric(levels(File_list$randomization))[File_list$randomization]
File_list <- select(File_list, K, randomization, runname)
File_list <- arrange(File_list, randomization, K)


#Sort each STRUCTURE file and metadata file by the plant ID number then combine them. This gets rid
#of the random order of indivduals needed to run STRUCTURE


for( strrun in c(1:length(File_list$K))){
#strrun <- 1
    dataset <- File_list[strrun, 3]
    str.data <- 0
    str.data <- read.csv(paste("../STRUCTURE/parsed_data/",dataset, sep=""), header=F)
    K <- File_list[strrun, 1] # Find out what K is
    str.data <- str.data[,c(2,3,5:ncol(str.data))] # Get only useful columns from STRUCTURE
    colnames(str.data) <- c( "Individual", "%missing",1:K)
    str.data$ID <- unlist(strsplit(as.character(str.data$Individual), "_QTL.+"))
    
    #Get the label/metadata about each individual from a seperate file. Join to remove all the "RA" and "NZIL" individuals
    
    labels <- read.csv("../../Metadata/SigSelectionMeta.csv" )
    labels$ID <- as.character(labels$ID)

    all.data <- left_join(str.data, labels)
    

#    if (File_list[strrun, 1] > 1) {ghosts <- apply(all.data[,3:(2+K)], 2, max)
#                newghost <- c(File_list[strrun, 1], File_list[strrun, 2], sum(ghosts < .5))
#                ghost_count <- rbind(ghost_count, newghost)}
#    
#    if (File_list[strrun, 1] > 1) { popghosts <- aggregate(all.data, by=list(all.data$Pop), FUN=mean)[4:(3+K)]
#                 popghosts <- apply(popghosts, 2, max)
#                 newpopghost <- c(File_list[strrun, 1], File_list[strrun, 2], sum(popghosts < .5))
#                 pop_ghost_count <- rbind(pop_ghost_count, newpopghost)}
#    
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
    col_pal = c(col_pal1, col_pal2, col_pal3)
    
    K_text <- paste("STRUCTURE Plot K=", K, sep="")
    #SPEU is now SPNK; NELO now NEJS; RACA now RAJS. -JKC 
    par(mfrow=c(1,1), mar=c(0,0,0,0))
    par(fig=c(0,1,.8,.9))
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
    axis(side=3, at=16, labels=expression(italic("R. pugionformis")), cex=1.2, tick=F, line=-1)
    axis(side=1, at=c(8, 25), tick=F, labels=c("Israel (GMIL)","Israel (YEIL_CLNC)"), line=-1, cex.axis=.9)
  
    
    par(fig=c(0.1,.5,.29,.39), new=TRUE)
    barplot(daikon.table, col=col_pal[1:K], xaxt="n", yaxt="n",
            space=c(rep(0,7), 1, rep(0,5)))
    axis(side=3, at=22, labels="Daikon Crops", cex=1.2, tick=F, line=-1)
    axis(side=1, at=c(3.5,11), tick=F, labels=c("New Crown (NEJS)", #SPEU is now SPNK; NELO now NEJS; RACA now RAJS. -JKC 
                                                "Tokinashi (TOBG)"), line=-1, cex.axis=.9)
    
    
    par(fig=c(.5,.9,.29,.39), new=TRUE)
    barplot(european.table, col=col_pal[1:K], xaxt="n", yaxt="n", 
            space=c(rep(0,7),1, rep(0,6)) )
    axis(side=3, at=22, labels="European Crops", cex=1.2, tick=F, line=-1)
    axis(side=1, at=c(4,11.5), tick=F, labels=c("Early S.G. (ESNK)", 
                                                "Sparkler (SPNK)" ), line=-1, cex.axis=.9)
    
    par(fig=c(.1,.9,.12,.22), new=TRUE)
    barplot(oilrat.table, col=col_pal[1:K],  xaxt="n", yaxt="n", 
            space=c(rep(0,6),1, rep(0,5), 3, rep(0,5), 1,rep(0,4)) )
    axis(side=3, at=c(7,22), labels=c("Rattail Crops", "Oilseed Crops" ), cex=1.2, tick=F, line=-1)
    axis(side=1, at=c(3,10,19,25.5), tick=F, labels=c("Rattail (RABG)", "Rattail (RAJS)", 
                                                      "Arena (AROL)", "GRA (OIBG)" ), line=-1, cex.axis=.9)
    
      
}

dev.off()

#ghost_count <- data.frame(ghost_count)
#colnames(ghost_count) <- c("K", "Run", "Ghosts")
#ghost_count <- ghost_count[2:nrow(ghost_count), ]
#
#pdf(file="../figures/GhostInd.pdf", height=9.3, width=15.3)
#
#arrange( ghost_count, K) %>% ggplot( aes(K, Ghosts)) + geom_point() + geom_jitter(height = 0)
#
#dev.off()
#
#write.csv(ghost_count, "../output/ghosts.csv")
#
#pop_ghost_count <- data.frame(pop_ghost_count)
#
#colnames(pop_ghost_count) <- c("K", "Run", "Ghosts")
#pop_ghost_count <- pop_ghost_count[2:nrow(pop_ghost_count), ]
#
#pdf(file="../figures/GhostPops.pdf", height=9.3, width=15.3)
#
#arrange( pop_ghost_count, K) %>% ggplot( aes(K, Ghosts)) + geom_point() + geom_jitter(height = 0)
#
#dev.off()
#
#write.csv(pop_ghost_count, "../output/PopGhosts.csv")
#
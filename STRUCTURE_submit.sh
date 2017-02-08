#! /bin/bash

#Launches 20 different randomizations of the dataset (seq 1 20) with a K of ( -t <number range>)		

#Randomize Input files
for i in `seq 1 20`; do head -2 batch_20170205.structure.tsv | tail -1 > R${i}_batch_20170205.structure.tsv; done
for i in `seq 1 20`; do tail -n +3 batch_20170205.structure.tsv | shuf >> R${i}_batch_20170205.structure.tsv; done


for i in `seq 1 20`
    do less ../bug-free-meme/Random_STRUCTURE.qsub | sed s/RUNNUMBER/R${i}_batch_20170205.structure.tsv/ > withtemp.qsub
    
    qsub withtemp.qsub -N ${i}_STRUCTURE -t 3-22
    
    less withtemp.qsub | sed s/36/144/ > withtempLong.qsub
    
    qsub withtempLong.qsub -N ${i}_STRUCTURE -t 3-22

done

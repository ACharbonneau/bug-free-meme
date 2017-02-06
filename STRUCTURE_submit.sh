#! /bin/bash

#Launches 20 different randomizations of the dataset (seq 1 20) with a K of ( -t <number range>)		

# Files were randomized by:
#   for i in `seq 1 20`; do shuf -o R${i}_batch_20170205.structure.tsv batch_20170205.structure.tsv; done

for i in `seq 1 22`
    do less Random_STRUCTURE.qsub | sed s/RUNNUMBER/R${i}_batch_20170205.structure.tsv/ > withtemp.qsub
    
    qsub withtemp.qsub -N ${i}_STRUCTURE -t 1-22

done

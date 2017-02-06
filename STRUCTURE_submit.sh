#! /bin/bash

#Launches 20 different randomizations of the dataset (seq 1 20) with a K of ( -t <number range>)		

for i in `seq 1 20`
    do less Random_STRUCTURE.qsub | sed s/RUNNUMBER/${i}rand.txt/ > withtemp.qsub
    
    qsub withtemp.qsub -N ${i}_STRUCTURE -t 1-22

done

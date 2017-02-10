#! /bin/bash

#Launches 20 different randomizations of the dataset (seq 1 20) with a K of ( -t <number range>)		

#Randomize Input files
tail -n +2 batch_20170205.structure.tsv > nohead_batch_20170205.structure.tsv 

    
    qsub ../bug-free-meme/Random_STRUCTURE.qsub -N STRUCTURE -t 3-10
        
    qsub ../bug-free-meme/Random_STRUCTURE_Long.qsub -N STRUCTURE_Long -t 12-22

done

#! /bin/bash

#Launches 20 different randomizations of the dataset (seq 1 20) with a K of ( -t <number range>)		

#Randomize Input files
tail -n +2 batch_20170214.structure.tsv > nohead_batch_20170214.structure.tsv 

for rep in `seq 1 20`
do seq 2 2 517 | shuf > ${rep}_random.txt
head -1 nohead_batch_20170214.structure.tsv > ${rep}_batch_20170214.structure.tsv

	for i in `cat ${rep}_random.txt`
	
		do sed "${i}q;d" nohead_batch_20170214.structure.tsv >> ${rep}_batch_20170214.structure.tsv
		
		next=$(( ${i}+1 ))

		sed "${next}q;d" nohead_batch_20170214.structure.tsv >> ${rep}_batch_20170214.structure.tsv
    

	done
    qsub ../bug-free-meme/Random_STRUCTURE.qsub -N ${rep}_STRUCTURE -t 3-7 -v thisfile=${rep}_batch_20170214.structure.tsv
        
    qsub ../bug-free-meme/Random_STRUCTURE_Long.qsub -N ${rep}_STRUCTURE -t 8-22 -v thisfile=${rep}_batch_20170214.structure.tsv

done
    


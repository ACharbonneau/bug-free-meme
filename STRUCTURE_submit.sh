#! /bin/bash

#Launches 20 different randomizations of the dataset (seq 1 20) with a K of ( -t <number range>)

BATCH="batch_20170329.structure.tsv"


#Randomize Input files
tail -n +2 ${BATCH} > nohead_${BATCH}

INDIVIDS=$(cat nohead_${BATCH} | wc -l )

MARKERS=$(head -2 ${BATCH} | tail -1 | wc -w)

sed -i s/INDIVIDUALSGOHERE/${INDIVIDS}/ ../bug-free-meme/mainparams4h
sed -i s/MARKERSGOHERE/${INDIVIDS}/ ../bug-free-meme/mainparams4h


for rep in `seq 1 20`
do seq 2 2 ${INDIVIDS} | shuf > ${rep}_random.txt
head -1 nohead_${BATCH} > ${rep}_${BATCH}

	for i in `cat ${rep}_random.txt`

		do sed "${i}q;d" nohead_${BATCH} >> ${rep}_${BATCH}

		next=$(( ${i}+1 ))

		sed "${next}q;d" nohead_${BATCH} >> ${rep}_${BATCH}


	done
    qsub ../bug-free-meme/Random_STRUCTURE.qsub -N ${rep}_STRUCTURE -t 3-5 -v thisfile=${rep}_${BATCH}

    qsub ../bug-free-meme/Random_STRUCTURE_Long.qsub -N ${rep}_STRUCTURE -t 6-22 -v thisfile=${rep}_${BATCH}

done

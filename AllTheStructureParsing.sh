#! /bin/bash

## Just change number in line 11 to number of samples +1

for i in `ls *_f`
	do echo $i
	grep -A 2 "Estimated Ln Prob of Data" $i
	done > AlltheProbabilities.txt

for i in `ls *_f`
	do grep -A 259 "Inferred ancestry of individuals" $i > $i.forparse
done

for i in `ls *forparse`
	do python ../bug-free-meme/structureparse.py $i
done

mkdir parsed_data
mkdir forparse
mkdir raw_output
mkdir error_output


mv *_f.parsed parsed_data/
mv *_f.forparse forparse
mv *_f raw_output
mv *.[eo]* error_output

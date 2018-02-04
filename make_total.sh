#!/bin/bash

rm -f data.csv total.csv
touch data.csv

for file in `ls 収入・支出詳細_20*-*.csv | sort -V`
do
	cat $file | awk 'NR>=2 {print}' >> data.csv
done

cat header.txt data.csv > total.csv


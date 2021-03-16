#!/bin/bash

ls -1 *.json | 
while read jsonfile; 
do 
	mongoimport -d stars -c star_files --file $jsonfile  --type json; 
done

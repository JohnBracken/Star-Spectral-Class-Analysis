#!/bin/bash

mongoimport -d stars -c star_files --file stars.json --jsonArray; 

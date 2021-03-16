import json
import os

with open("stars.json") as g:
    stars = json.load(g)

path =os.getcwd() + '/star_files/'

for i in range(len(stars)):
   with open(path + 'star_'+ str(i) + '.json', 'w') as h:
       json.dump(stars[i], h, indent=4)

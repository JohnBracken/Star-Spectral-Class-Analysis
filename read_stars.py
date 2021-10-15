import csv
import json
import re

ranks = [];
proper_name = [];
greek_name = [];
star_class = [];
distance = [];
app_mag = [];
abs_mag = [];
rad_vel = [];
vel = [];
remarks = [];
row_list = [];
with open('star_data.csv', newline = '') as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        ranks.append(row['RANK'])
        proper_name.append(row['PROPER NAME'])
        greek_name.append(row['GREEK LETTER NAME'])
        star_class.append(row['CLASS'])
        distance.append(row['DIST (LY)'])
        app_mag.append(row['APP MAG'])
        abs_mag.append(row['ABS MAG'])
        rad_vel.append(row['RAD VEL (km/s)'])
        vel.append(row['VEL (km/s)'])
        row['REMARKS'] = row['REMARKS'].replace(u'\xa0',u' ')
        remarks.append(row['REMARKS'])
        row_list.append(row)

for j in range(len(ranks)):
    ranks[j] = int(ranks[j])
    try:
        distance[j]= float(distance[j])
    except:
        print("value can't be converted to float, assigning value to none")
        distance[j] = None
    try:
        app_mag[j]= float(app_mag[j])
    except:
        print("value can't be converted to float, assigning value to none")
        app_mag[j] = None
    try:
        abs_mag[j]= float(abs_mag[j])
    except ValueError as e:
        print(e, ',value assigned none')
        abs_mag[j] = None
    try:
        rad_vel[j]= float(rad_vel[j])
    except:
        print("value can't be converted to float, assigning value to none")
        rad_vel[j] = None
    try:
        vel[j]= float(vel[j])
    except:
        print("value can't be converted to float, assigning value to none")
        vel[j] = None


for j in range(len(row_list)):
    row_list[j]['RANK'] = int(row_list[j]['RANK'])
    try:
        row_list[j]['DIST (LY)']= float(row_list[j]['DIST (LY)'])
    except:
        print("value can't be converted to float, assigning value to none")
        row_list[j]['DIST (LY)'] = None
    try:
        row_list[j]['APP MAG']= float(row_list[j]['APP MAG'])
    except:
        print("value can't be converted to float, assigning value to none")
        row_list[j]['APP MAG'] = None
    try:
        row_list[j]['ABS MAG']= float(row_list[j]['ABS MAG'])
    except ValueError as e:
        print(e, ',value assigned none')
        row_list[j]['ABS MAG'] = None
    try:
        row_list[j]['RAD VEL (km/s)']= float(row_list[j]['RAD VEL (km/s)'])
    except:
        print("value can't be converted to float, assigning value to none")
        row_list[j]['RAD VEL (km/s)'] = None
    try:
        row_list[j]['VEL (km/s)']= float(row_list[j]['VEL (km/s)'])
    except:
        print("value can't be converted to float, assigning value to none")
        row_list[j]['VEL (km/s)'] = None

with open('stars.json', 'w') as star_out:
    json.dump(row_list, star_out, indent=4)

k_stars = []
for a in range(len(row_list)):
    if row_list[a]['CLASS'].startswith("K"):
        k_stars.append(row_list[a])

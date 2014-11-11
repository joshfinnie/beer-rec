#!/usr/local/bin/python
import json
import os

import requests

URL = "http://api.brewerydb.com/v2/beers/?withBreweries=Y&key={}&p={}"

for i in range(0, 683):
    r = requests.get(URL.format(os.environ['BREWERYDB_API_KEY'], i+1))
    file_name = "beer_dump/{}_beer_dump.json".format(i+1)
    data = r.json()
    if data['status'] == u'success':
        with open(file_name, 'w') as outfile:
            json.dump(data, outfile)
            print "Page {}".format(i+1)
    else:
        print "{} page failed.".format(i+1)

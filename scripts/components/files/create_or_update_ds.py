#!/usr/bin/env python

import json
import sys
import requests

# pylint: disable=line-too-long
if len(sys.argv) != 5:
    print "Usage: {} user password uri datasource_json".format(sys.argv[0])
    print """{} pnda pnda http://localhost:3000 '{{ "name": "PNDA OpenTSDB", "type": "opentsdb", "url": "http://localhost:4243", "access": "proxy", "basicAuth": false, "isDefault": true }}'""".format(sys.argv[0])
    sys.exit(1)

HEADERS = {'content-type': 'application/json'}

# pylint: disable=invalid-name
g_user = sys.argv[1]
g_password = sys.argv[2]
g_url = sys.argv[3]
g_ds = json.loads(sys.argv[4])

session = requests.Session()
login_post = session.post(
    requests.compat.urljoin(g_url, 'login'),
    data=json.dumps({
        'user': g_user,
        'email': '',
        'password': g_password}),
    headers=HEADERS)

create_ds = session.post(requests.compat.urljoin(g_url, 'api/datasources'),
                         data=json.dumps(g_ds),
                         headers=HEADERS)

if create_ds.ok:
    print "Datasource '{}' created".format(g_ds['name'])
    sys.exit(0)
else:
    # Get list of datasources
    datasources = session.get(requests.compat.urljoin(g_url, 'api/datasources'), headers=HEADERS)
    datasources.raise_for_status()

    existing_ds = next((x['id'] for x in datasources.json() if x['name'] == g_ds['name']), None)
    print "Datasource '{}' already exists (id: {}), overwriting it ...".format(g_ds['name'], existing_ds)
    create_ds = session.put(
        requests.compat.urljoin(g_url, 'api/datasources/{}'.format(existing_ds)),
        data=json.dumps(g_ds),
        headers=HEADERS)
    create_ds.raise_for_status()

#/bin/sh
j2 /dm-config.json.tpl > /deployment-manager/dm-config.json
cd /deployment-manager/
python app.py

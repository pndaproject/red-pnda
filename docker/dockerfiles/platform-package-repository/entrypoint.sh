#/bin/sh
j2 /pr-config.json.tpl > /package-repository/pr-config.json
cd /package-repository/
python package_repository_rest_server.py

#/bin/sh
j2 /entrypoint.sh.tpl > /entrypoint.sh
chmod +x /entrypoint.sh
/entrypoint.sh

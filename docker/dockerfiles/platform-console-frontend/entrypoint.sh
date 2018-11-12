#/bin/sh
j2 /PNDA.json.tpl > /usr/share/nginx/html/conf/PNDA.json
j2 /nginx.conf.tpl > /etc/nginx/conf.d/default.conf
nginx -g 'daemon off;'

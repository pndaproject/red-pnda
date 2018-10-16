server {
    listen       {{CONSOLE_FRONTEND_PORT | default('80') }};
    server_name  {{CONSOLE_FRONTEND_HOST | default('localhost') }};
    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }
    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }
}


#! /bin/sh

: ${BACKEND:=app:80}
: ${PORT:=80}

cat <<EOF
upstream app {
  server ${BACKEND} fail_timeout=0;
}

server {

  listen ${PORT};

  client_header_timeout 15s;
  client_body_timeout 30s;
  client_max_body_size 4G;

  root /container/data;

  location / {
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header X-Request-Start "t=\${msec}";
    proxy_set_header Host \$http_host;
    proxy_redirect off;
    proxy_pass http://app;
  }

}

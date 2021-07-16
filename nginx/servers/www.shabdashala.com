server {
  server_name www.shabdashala.com;
  listen [::]:443 ssl;
  listen 443 ssl http2;
  ssl_certificate /etc/letsencrypt/live/www.shabdashala.com/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/www.shabdashala.com/privkey.pem;

  include /etc/letsencrypt/options-ssl-nginx.conf;
  ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

  access_log /var/log/nginx/www-shabdashala-com.access.log;
  error_log /var/log/nginx/www-shabdashala-com.error.log;

  location = /favicon.ico { access_log off; log_not_found off; }
  location /static {
    alias /home/ubuntu/shabdashala-backend/backend/static_files;
  }

  location /media {
    alias /home/ubuntu/shabdashala-backend/backend/media_files;
  }

  location / {
    uwsgi_pass              unix:/run/uwsgi/www-shabdashala-com.sock;
    include uwsgi_params;

    uwsgi_read_timeout 1200s;
    uwsgi_send_timeout 1200s;

    proxy_redirect          off;
    proxy_read_timeout       1200s;
    proxy_connect_timeout    1200s;

    proxy_set_header Host $http_host;
    proxy_set_header X-Forwarded-Proto https;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  }
}

server {
  if ($host = www.shabdashala.com) {
    return 301 https://$host$request_uri;
  }

	listen 80 ;
	listen [::]:80 ;

  server_name www.shabdashala.com;
  return 404;
}

server {
  if ($host = shabdashala.com) {
    return 301 https://www.$host$request_uri;
  }

	listen 80 ;
	listen [::]:80 ;

  server_name shabdashala.com;
  return 404;
}
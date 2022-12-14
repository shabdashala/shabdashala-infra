server {
  listen       443 ssl;
	server_name  local.shabdashala.com;

	ssl_certificate     certificates/wild.shabdashala.com.crt;
	ssl_certificate_key certificates/wild.shabdashala.com.key;

  ssl_session_cache    shared:SSL:1m;
  ssl_session_timeout  5m;

  ssl_ciphers  HIGH:!aNULL:!MD5;
  ssl_prefer_server_ciphers  on;

  location / {
    proxy_set_header   X-Forwarded-For $remote_addr;
    proxy_set_header   Host $http_host;
    proxy_pass         "http://127.0.0.1:8000";

    proxy_read_timeout      1200s;
    proxy_connect_timeout   1200s;
    proxy_send_timeout      1200s;
  }
}

server {
  if ($host = local.shabdashala.com) {
    return 301 https://$host$request_uri;
  }

	listen 80 ;
	listen [::]:80 ;

  server_name local.shabdashala.com;
  return 404;
}
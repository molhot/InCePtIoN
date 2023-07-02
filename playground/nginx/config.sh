mkdir /etc/nginx/ssl
openssl genrsa -out /etc/nginx/ssl/server.key 3072

openssl req -new -key /etc/nginx/ssl/server.key -out /etc/nginx/ssl/server.csr -subj "/CN=example.com"

openssl x509 -req -signkey /etc/nginx/ssl/server.key -in /etc/nginx/ssl/server.csr -out /etc/nginx/ssl/server.crt
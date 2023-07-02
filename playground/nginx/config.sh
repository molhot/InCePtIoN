mkdir /etc/nginx/ssl
openssl genrsa -out /etc/nginx/ssl/server.key 3072

#Create the request (CSR)
openssl req -new -key /etc/nginx/ssl/server.key -out /etc/nginx/ssl/server.csr -subj "/CN=example.com"

# CRT (SSLサーバー証明書)の作成
openssl x509 -req -signkey /etc/nginx/ssl/server.key -in /etc/nginx/ssl/server.csr -out /etc/nginx/ssl/server.crt
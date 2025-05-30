server {
     listen [::]:80;
     listen 80;

     server_name ualfsp323jenkins.northeurope.cloudapp.azure.com;

     return 301 https://ualfsp323jenkins.northeurope.cloudapp.azure.com$request_uri;
 }

 server {
     listen [::]:443 ssl;
     listen 443 ssl;

     server_name ualfsp323jenkins.northeurope.cloudapp.azure.com;

     ssl_certificate /etc/letsencrypt/live/ualfsp323jenkins.northeurope.cloudapp.azure.com/fullchain.pem;
     ssl_certificate_key /etc/letsencrypt/live/ualfsp323jenkins.northeurope.cloudapp.azure.com/privkey.pem;

     location / {
         proxy_set_header        Host $host:$server_port;
         proxy_set_header        X-Real-IP $remote_addr;
         proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
         proxy_set_header        X-Forwarded-Proto $scheme;
         proxy_pass          http://127.0.0.1:8080;
         proxy_read_timeout  90;
         proxy_redirect      http://127.0.0.1:8080 https://ualfsp323jenkins.northeurope.cloudapp.azure.com;

         proxy_http_version 1.1;
         proxy_request_buffering off;
         add_header 'X-SSH-Endpoint' 'ualfsp323jenkins.northeurope.cloudapp.azure.com:50022' always;
     }
 }
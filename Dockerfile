FROM nginx:alpine
COPY artifact/dist/ /usr/share/nginx/html/
COPY artifact/nginx/default.conf /etc/nginx/conf.d/default.conf


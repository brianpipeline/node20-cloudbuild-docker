FROM nginx:alpine

COPY dist/ /usr/share/nginx/html

RUN sed -i -e 's/80/3000/g' /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]

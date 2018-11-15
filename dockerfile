FROM openresty:alpine

WORKDIR /app
COPY ./ .

RUN ln -sf /dev/stdout /app/logs/access.log \
    && ln -sf /dev/stderr /app/logs/error.log

EXPOSE 8085
CMD ["nginx", "-g", "daemon off;", "-p", "/app/", "-c", "conf/nginx.conf"]
FROM nginx:1.21.6-alpine

RUN apk --no-cache add tini bash
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY ./failover.conf.template /etc/nginx/conf.d/failover.conf.template
COPY ./non-failover.conf.template /etc/nginx/conf.d/non-failover.conf.template
COPY ./server.conf.template /etc/nginx/conf.d/server.conf.template

COPY ./nginx.conf.template /etc/nginx/nginx.conf.template

RUN ln -sf /dev/stdout /var/log/nginx/access.log && ln -sf /dev/stderr /var/log/nginx/error.log

ENTRYPOINT ["tini", "--", "/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]

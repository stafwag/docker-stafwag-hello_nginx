ARG BASE_IMAGE=debian:bookworm
ARG DEBIAN_FRONTEND=noninteractive
FROM $BASE_IMAGE
LABEL maintainer "staf wagemakers <staf@wagemakers.be>"

RUN mkdir -p /home/www
RUN mkdir -p /home/www/{etc,html}
RUN useradd www -u 10080 -d /home/www -s /usr/sbin/nologin -g 0 

RUN apt-get -y update
RUN apt-get -y upgrade

RUN apt-get -y install apt-file
RUN apt-file update
RUN apt-get -y install procps nvi
RUN apt-get -y install telnet

RUN apt-get -y update
RUN apt-get -y install nginx
RUN chown www:0 /var/lib/nginx/

COPY etc/nginx.conf /home/www/etc/
COPY www/index.html /home/www/html/

RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

USER www

ENTRYPOINT ["/usr/sbin/nginx","-c","/home/www/etc/nginx.conf"]

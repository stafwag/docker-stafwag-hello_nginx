ARG BASE_IMAGE=debian:buster
FROM $BASE_IMAGE
LABEL maintainer "staf wagemakers <staf@wagemakers.be>"

RUN groupadd www -g 1000080
RUN mkdir -p /home/www
RUN mkdir -p /home/www/{etc,html}
RUN useradd www -u 1000080 -d /home/www -s /usr/sbin/nologin -g www 

RUN apt-get -y update
RUN apt-get -y upgrade

RUN apt-get -y install apt-file
RUN apt-file update
RUN apt-get -y install procps nvi
RUN apt-get -y install telnet

RUN apt-get -y update
RUN apt-get -y install nginx
RUN chown www:www /var/lib/nginx/

COPY etc/nginx.conf /home/www/etc/
COPY www/index.html /home/www/html/

RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

USER www

ENTRYPOINT ["/usr/sbin/nginx","-c","/home/www/etc/nginx.conf"]

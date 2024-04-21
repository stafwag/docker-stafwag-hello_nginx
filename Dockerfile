ARG BASE_IMAGE=debian:bookworm
ARG DEBIAN_FRONTEND=noninteractive
FROM $BASE_IMAGE
LABEL maintainer "staf wagemakers <staf@wagemakers.be>"

RUN mkdir -p /home/www
RUN mkdir -p /home/www/{etc,html}
RUN useradd www -u 10080 -d /home/www -s /usr/sbin/nologin -g 0 

RUN apt-get -y update
RUN apt-get -y upgrade

# Install some debug tools
# Not recommend for a production envronment, but this is just a test image
RUN apt-get -y install apt-file
RUN apt-file update
RUN apt-get -y install procps nvi telnet wget curl

RUN apt-get -y update
RUN apt-get -y install nginx
RUN chown www:0 /var/lib/nginx/
RUN chmod -R 770 /var/lib/nginx/

COPY etc/nginx.conf /home/www/etc/
COPY www/index.html /home/www/html/

RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

USER www

ENTRYPOINT ["/usr/sbin/nginx","-c","/home/www/etc/nginx.conf"]

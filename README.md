# docker-stafwag-hello_nginx

```Dockerfile``` to run the nginx webserver and display a simple webpage.

Might be useful to test container deployments.

The webserver runs on port 8080.

## Installation

### clone the git repo

```
$ git clone https://github.com/stafwag/docker-stafwag-hello_nginx.git
$ cd docker-stafwag-hello_nginx
```

### Build the image

```
$ docker build -t stafwag/hello_nginx:$(git rev-parse --short HEAD) .
```

## Run

Run

```
$ docker run -d --rm --name myhello -p 127.0.0.1:8080:8080 stafwag/hello_nginx:$(git rev-parse --short HEAD)
```

Test

```
$ curl http://127.0.0.1:8080
```


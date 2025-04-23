# docker-stafwag-hello_nginx

```Dockerfile``` to run a nginx web server and display a simple webpage.

Might be useful to test container deployments.

I use this container to demo a container build and how to deploy it with helm on a Kubernetes cluster.
Some test tools (```ping```, ```DNS```, ```curl```, ```wget```) are included to execute some tests on the deployed pod.


The webserver runs on port ```8080```.

## Installation

### clone the git repo

```
$ git clone https://github.com/stafwag/docker-stafwag-hello_nginx.git
$ cd docker-stafwag-hello_nginx
```

## Docker

### Build the image

```
$ docker build -t stafwag/hello_nginx:$(git rev-parse --short HEAD) .
```

### Run

Execute

```
$ docker run -d --rm --name myhello -p 127.0.0.1:8080:8080 stafwag/hello_nginx:$(git rev-parse --short HEAD)
```

Test

```
$ curl http://127.0.0.1:8080
```

## Makefile (Podman)

A ```Makefile``` is included to build the image with [https://podman.io/](https://podman.io/) 

To build the image with ```podman```, execute ```make```

```
$ make
```

## OpenShift deployment local 

### Deploy

To deploy the container with the included helm charts to OpenShift local (Code Ready Containers), execute ```make crc_deploy```.

This will:

1. Build the container image
2. Login to the internal OpenShift registry
3. Push the image to the internal OpenShift register
4. Deploy the helm chart in the ```tsthelm``` namespace, the helm chart will also create a route for the application.

```
$ make crc_deploy
<snip>
nabled="true" -n tsthelm hello helm/hello-nginx
NAME: hello
LAST DEPLOYED: Wed Apr 23 19:33:22 2025
NAMESPACE: tsthelm
STATUS: deployed
REVISION: 1
TEST SUITE: None
```

### Test

Go to the ```tsthelm``` project.

```
[staf@vicky docker-stafwag-hello_nginx]$ oc project tsthelm
Already on project "tsthelm" on server "https://api.crc.testing:6443".
[staf@vicky docker-stafwag-hello_nginx]$ 
```

#### Verify pod

Ensure that the ```pod``` is in the running state.

```
[staf@vicky docker-stafwag-hello_nginx]$ oc get po
NAME                                      READY   STATUS    RESTARTS   AGE
nginx-hello-deployment-7c78675dd4-c4hz4   1/1     Running   0          13m
[staf@vicky docker-stafwag-hello_nginx]$ 
```

Login to the pod.

```
[staf@vicky docker-stafwag-hello_nginx]$ oc rsh nginx-hello-deployment-7c78675dd4-c4hz4
$ id
uid=1000650000(1000650000) gid=0(root) groups=0(root),1000650000
$ 
```

Verify the running processes.

```
$ ps aux   
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
1000650+       1  0.0  0.0  10460  6912 ?        Ss   17:33   0:00 /usr/sbin/nginx -c /home/www/etc/nginx.conf
1000650+       2  0.0  0.0   2580  1536 pts/0    Ss   17:48   0:00 /bin/sh -c TERM="xterm-256color" /bin/sh
1000650+       3  0.0  0.0   2580  1536 pts/0    S    17:48   0:00 /bin/sh
1000650+       6  0.0  0.0   8092  4096 pts/0    R+   17:49   0:00 ps aux
$ 
```

### Check the route

Get the ```route``` for the deployed apllication.

```
[staf@vicky docker-stafwag-hello_nginx]$ oc get route
NAME                HOST/PORT                                    PATH   SERVICES              PORT   TERMINATION     WILDCARD
nginx-hello-route   nginx-hello-route-tsthelm.apps-crc.testing          nginx-hello-service   8080   edge/Redirect   None
[staf@vicky docker-stafwag-hello_nginx]$ 
```

Test the application.

```
[staf@vicky docker-stafwag-hello_nginx]$ curl -k https://nginx-hello-route-tsthelm.apps-crc.testing
<html>
<head>
<title>
Hello from Nginx on Debian GNU/Linux!
</title>
</head>
<body>
<h1>Hello from Nginx on Debian GNU/Linux!</h1>
</body>
</html>
[staf@vicky docker-stafwag-hello_nginx]$ 
```

***Have fun!***


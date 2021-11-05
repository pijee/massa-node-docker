# Massa
### What is massa ?
Massa is an open source cryptocurrency based on proof of stack concept. Nodes are used to validate transactions and secure blockchain.

### Where can i found project ?
Go to their [gitlab repository](https://gitlab.com/massalabs/massa).
<br /><br />

# Massa-node
### About Dockerfile
This Dockerfile was made to run easyly a new updated massa-node. It create a full compilation environment with multi-staging support, compile massa-node with static libs, extract binary to make a smallsize image from scratch (at least 18mo for now).

***Why using multiple RUN ?***
Because sometimes, build can failed and using multiple RUN on build compilation create temporary zones to handle errors and don't wast time. In any case, it's not impact final image size, thanks to multi staging ;)
<br /><br />

### Build from Dockerfile
```
$ docker build -t [yourname/imagename]:[rev] .
```
While compilation, Dockerfile copy some configurations directories and files into the new image. It mades for purpose only, run image quickly. But keep in mind datas aren't persistent and you'll lost all each time you stop container. Use **volume** command args to avoid this.
```
$ docker run -it -d --name [name] -p [local-port:container-port] -v [local_base_config:/massa/base_config] -v [local_config:/massa/config] -v [local_storage:/massa/storage] [yourname/imagename]:[rev]
```
<br />

### Use docker-compose
A directory with docker-compose.yaml file is made for peoples who wants to run massa-node quickly. It use **volumes** to share configuration files from host to container.

```
$ cd docker-compose
$ docker-compose up -d
```
<br />

### Use docker-hub
To use docker-hub built images
```
$ docker run -it -d --name [name] -p [local-port:container-port] -v [local_base_config:/massa/base_config] -v [local_config:/massa/config] -v [local_storage:/massa/storage] pijee/massa-node:latest
```

Images was build with date revision. Instead of latest, you can find specific build version using **pijee/massa-node:YEARMONTHDAY** format.
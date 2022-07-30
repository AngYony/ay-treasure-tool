# docker container（容器）

- container 是 ”一个运行中的docker image“
- 实质是复制 image 并在 image 最上层加一层 read-write 的层（称之为 container layer，容器层）
- 基于一个 image 可以创建多个 container

容器是镜像的运行时实例，容器会共享其所在主机的操作系统的内核。

容器会随着其中运行应用的退出而终止。

容器如果不运行任何进程则无法存在，如果容器内的进程或者主进程都被杀死，那么这个容器也将被杀死。

按下【Ctrl+P+Q】组合键会退出当前容器，但不会终止容器运行，将会切回到Docker主机的Shell，并保持容器在后台运行。

容器中的全部配置和内容不会随着容器的停止而消失，他们仍然保存在Docker主机的文件系统之中，只要不删除容器，仍然可以随时重新启动并恢复。停止容器运行并不会损毁容器或者其中的数据。虽然如此，但必须指出的是：卷（volume）才是在容器中存储持久化数据的首选方式，如果将容器数据存储在卷中，数据也会被保存下来。

## 容器的重启策略

- always：使用该策略运行的容器，除非显式使用`docker container stop`命令将容器明确停止，否则该策略会一直尝试重启处于停止状态的容器。示例：

  ```shell
  $ docker container run --name neversaydie -it --restart always alpine sh
  / # exit
  $ docker container ls -a
  CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
  5036699a89d3        alpine              "sh"                33 seconds ago      Up 9 seconds                            neversaydie
  ```

  上述示例使用restart always策略启动了一个新的交互式容器，同时在命令中指定运行Shell进程，当间隔一段时间输入“exit”退出Shell时，该容器会自动被杀死。但是由于指定了--restart为always策略，该容器会在被杀死后又再次自动被重启，因此通过`docker container ls -a`命令，可以看到容器的启动时间远小于创建时间。

  只有在执行`docker container stop`命令显式的停止该容器时，容器才处于Stopped（Exited）状态。虽然如此，但是当整个Docker daemon重启时，该策略的容器仍会重新启动。

- unless-stopped：与always的最大区别是，指定了--restart为unless-stopped策略的并处于Stopped（Exited）状态的容器，不会在Docker daemon重启的时候被重启。

  下面分别创建两个容器，其中一个策略指定为always，另一个指定为unless-stopped，将这两个容器通过`docker container stop`命令同时停止，接着重启Docker。

  创建两个容器，并在启动时指定不同的策略：

  ```shell
  $ docker container run -d --name myalways --restart always alpine sleep ld
  16c666d1d33da3f5defbdfa015c9ff063cbdb53482e8e723b84ae8974a5e3e56
  $ docker container run -d --name myunlessstopped \
  --restart unless-stopped alpine sleep ld
  3c8da19b9a8354a9fa3318c504c2509f401e38f78ec48ab7675647e669be6982
  ```

  同时停止两个容器：

  ```shell
  $ docker container stop myalways myunlessstopped
  ```

  重启Docker：

  ```shell
  $ sudo systemctl restart docker
  ```

  检测状态：

  ```shell
  $ docker container ls -a
  STATUS                        PORTS               NAMES
  Exited (1) 2 minutes ago                          myunlessstopped
  Restarting (1) 1 second ago                       myalways
  ```

  结果：启动时指定了--restart always策略的容器已经重启，但unless-stopped容器没有重启。

- on-failed：指定了该策略的容器，会在退出容器并且返回值不是0的时候，重启容器。就算容器处于Stopped状态，在Docker daemon重启的时候，容器也会被重启。



## docker container 命令

### docker container ls

列出所有在运行（UP）状态的容器。旧的版本也可以使用`docker container ps`命令，效果相同。

```shell
$ docker container ls
CONTAINER ID  IMAGE         COMMAND         CREATED        STATUS       PORTS NAMES
77b2dc01fe0f  ubuntu:18.04  /bin/sh -c 'while tr  2 minutes ago  Up 1 minute        agitated_wright
```

#### 选项描述

- 可以指定`-a`参数，让Docker列出所有容器，包括那些处于停止（Exited）状态的。

  ```shell
  $ docker container ls -a
  ```

- -q：仅列出容器的id。

  ```shell
  $ docker container ls -aq
  ```

  

### docker container run

docker container run命令用于启动新的指定镜像的容器，它告诉Docker daemon启动新的容器。

当执行这个命令时，Docker daemon会先搜索Docker本地缓存，观察是否有命令所请求的镜像，如果本地没有该镜像，Docker会在Docker Hub中检查是否存在对应镜像，有的话就拉取到本地，并存储在本地缓存中，然后创建容器，并在其中运行指定的应用。

容器的运行模式有两种：attached（前台模式）和 detached（后台模式）。

#### 命令格式

```
docker container run [options] <iamge> <app>
```

#### 命令说明

- image：表示启动所需的镜像，指定的格式和镜像拉取时相同，通常是仓库名[:标签]的形式。
- app：启动容器后将要运行的应用。

#### 选项描述

- -it：这是两个参数，一个是 `-i`：交互式操作，一个是 `-t` 终端。其中，`-t` 选项让Docker分配一个伪终端（pseudo-tty）并绑定到容器的标准输入上， `-i` 则让容器的标准输入保持打开。-it表示将当前终端连接到容器的Shell终端之上。

  ```shell
  docker container run -it ubuntu sh
  ```

  执行上述命令，将会进入到Ubuntu的shell交互界面，一旦在shell中使用了“exit”执行退出操作，对应的container也会停止。如果不想退出，需要执行`docker container exec`相关命令（见下文）。

- `--rm`：这个参数是说容器退出后随之将其删除。默认情况下，为了排障需求，退出的容器并不会立即删除，除非手动 `docker rm`。

- --name：指定新建的容器的名称。

- ==-d（--detach）==：表示后台模式，告知容器在后台运行。即：指定启动的容器在后台运行，这种后台启动的方式不会将当前终端连接到容器当中。

  如果想要从detach模式切换回attached模式，可以使用`docker container attach 103ef`命令。

- --restart：指定容器启动时采用哪种重启策略。

- -P（--publish）：将主机的端口与容器内的端口进行映射。

#### 综合示例

示例一，启动ubuntu:18.04镜像容器，并通过bash进行交互式操作，由于使用了--rm，因此退出容器后将会立即删除该容器（这里只是随便执行个命令，看看结果，不需要排障和保留结果，因此使用 `--rm` 可以避免浪费空间）：

```shell
$ docker run -it --rm \
    ubuntu:18.04 \
    bash
```

示例二，直接从镜像来启动容器，并使用-it参数将shell切换到容器终端，该操作会直接进入到容器内部。其中-it参数告诉Docker开启容器的交互模式并将用户当前的Shell连接到容器终端。

```shell
$ docker container run -it ubuntu:latest /bin/bash
```

如果要退出容器终端，可以使用快捷键：【Ctrl+P,Q】，该组合键可以在退出容器的同时还保持容器运行（在容器内部使用该操作可以退出当前容器，但不会杀死容器进程）。这样Shell就会返回到Docker主机终端。

示例三，创建一个名称为percy的容器：

```shell
$ docker container run --name percy -it ubuntu:latest /bin/bash
```

示例四，创建一个Web服务器镜像容器，并将Docker主机的端口映射到容器内：

```shell
$ docker container run -d --name webserver -p 80:8080 \
nigelpoulton/pluralsight-docker-ci
```

上述示例中的-p参数将Docker主机的80端口映射到容器内的8080端口，这意味着当有流量访问主机80端口的时候，流量会直接映射到容器内的8080端口。（原因是该镜像的容器在启动的时候会运行一个Web服务，监听的是容器内的8080端口，因此可以通过Docker主机的浏览器来访问该容器，只需要在浏览器中指定Docker主机的IP地址和默认的80端口即可）。

示例五，使用busybox容器的工具，进行常见操作：

```shell
$ docker container run -it busybox sh
# ip a
# ping www.baidu.com
```



### docker container attach

将容器由后台运行模式切换到前台运行模式。

#### 命令格式

```
docker container attach <container-name or container-id> 
```

#### 综合示例

重新启动名称为percy的容器：

```shell
$ docker container attach ff8
```



### docker container exec

用于在一个已经运行的容器里执行一个额外的命令。

该命令允许用户在运行状态的容器中，启动一个新进程，通常用于将Shell连接到一个运行中的容器终端。==该命令会创建新的Bash或者PowerShell进程并且连接到容器，这意味着在当前Shell输入exit并不会导致容器终止，因为原Bash或者PowerShell进程还在运行当中==。

#### 命令格式

```
docker container exec <options> <container-name or container-id> <command/app>
```

#### 命令说明

options：选项参数

container-name和container-id：这两个值都可以通过`docker container ls`命令，得到。

command/app：指定进入到容器后需要运行的终端程序。

#### 选项描述

- -it：这是两个参数，一个是 `-i`：交互式操作，一个是 `-t` 终端。其中，`-t` 选项让Docker分配一个伪终端（pseudo-tty）并绑定到容器的标准输入上， `-i` 则让容器的标准输入保持打开。-it表示将当前终端连接到容器的Shell终端之上。

  ```shell
  [root@localhost ~]# docker container ls -a
  CONTAINER ID   IMAGE     COMMAND                  CREATED        STATUS       PORTS                               NAMES
  ff84e2008a4e   nginx     "/docker-entrypoint.…"   21 hours ago   Up 2 hours   0.0.0.0:80->80/tcp, :::80->80/tcp   zealous_chebyshev
  [root@localhost ~]# docker container exec -it ff8 sh
  #
  ```

  注意：使用`docker container exec`进入到终端之后，执行“exit”退出终端，对应的container不会停止运行。

#### 综合示例

示例一，将Shell连接到当前运行的容器名词为gracious_faraday的容器：

```shell
$ docker container ls
CONTAINER ID  IMAGE	        COMMAND		CREATED		   STATUS		NAMES
9721c0028dca  ubuntu:latest "/bin/bash" 8 minutes ago  Up 8 minutes gracious_faraday
angyony@ubuntu:~$ docker container exec -it gracious_faraday bash
```

在示例中，将本地Shell连接到容器是通过-it参数实现的。若要退出容器，使用组合键：【Ctrl+P,Q】

示例二，连接到指定名称的容器：

```shell
$ docker container exec -it percy bash
```

示例三，进入到nginx：

```shell
$ docker container exec -it dc3 sh
```



### docker container start

该命令会重启处于停止（Exited）状态的容器。（用于容器的重写启动，将一个已经停止的容器重新启动。）

#### 命令格式

```
docker container start <container-name or container-id> 
```

#### 综合示例

重新启动名称为percy的容器：

```shell
$ docker container start percy
```



### docker container logs

获取容器的输出信息。

#### 命令格式

```
docker container logs [container ID or NAMES]
```

#### 选项描述

- -f：不加该选项，只会显示已经存在的信息，加了-f选项，将会追踪显示新的输出信息。

  ```shell
  $ docker container logs -f ff8
  ```

  



### docker container stop

该命令会停止运行中的容器，并将状态置为Exited（0）。

#### 命令格式

```
docker container stop <container-name or container-id> 
```

#### 综合示例

示例一，终止一个运行中的容器：

```shell
$ docker container stop gracious_faraday
或
$ docker container stop 302e2f
```

示例二，批量停止运行的容器：

```shell
$ docker container stop 20fe53 22yd202  # 可以同时指定多个id
或
$ docker container stop $(docker container ls -aq) # 通过获取所有容器的id列表传递给stop，再进行停止
```



### docker container rm

杀死并删除容器。该命令不能直接删除正在运行的容器，需要先停止再删除。强烈建议在使用该命令前，先使用`docker container stop`停止容器。而不是使用`docker container rm <container> -f`的方式暴力的销毁容器。

#### 命令格式

```
docker container rm <container-name or container-id> [options]
```

#### 选项描述

- ==-f==：表示强制执行，即使处于运行状态的容器也会被删除，通常不建议这么做，而是采用先停止再删除。这样可以给容器中运行的应用或进程一个停止运行并清理残留数据的机会。

#### 综合示例

示例一，删除指定名称的容器：

```shell
$ docker container rm gracious_faraday
```

可以通过运行`docker container ls -a`命令来确认容器是否已经被成功删除。

**示例二，在Docker主机上删除全部容器，无论容器是否运行或停止，都将被删除并从系统中移除：**

```shell
$ docker container rm $(docker container ls -aq) -f
```

将`$(docker container ls -aq)`作为参数传递给`docker container rm`命令，等价于将系统中每个容器的ID传给该命令。

注意：虽然该命令高效，但是一定不能在生产环境系统或者运行着重要容器的系统上执行。

### docker container inspect

该命令会显示容器的配置细节和运行时信息。该命令接收容器名称和容器ID作为主要参数。

```shell
$ docker container inspect 7ab70
或
$ docker container inspect wy
```



### docker container top

用于显示当前容器运行了哪些进程。这些进程位于docker engine上。

#### 命令格式

```
docker container top <container-name or container-id> 
```

#### 综合示例

```shell
$ docker container top ff8
```




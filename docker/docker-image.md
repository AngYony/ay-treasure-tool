# docker image（镜像）



- docker image 是一个read-only 文件，这个文件包含文件系统，源码，库文件，依赖，工具等一些运行application所需要的文件。

- Docker镜像可以简单理解为未运行的容器。
- 容器的目的就是运行应用或服务，因此容器的镜像中必须包含应用/服务运行所必需的操作系统和应用文件。
- 每个镜像的内部是一个精简的仅包含必要的操作系统（OS），同时还包含应用运行所必须的文件和依赖包。Docker镜像就像停止运行的容器。通过docker命令可以从某个镜像启动一个或多个容器。
- 容器从镜像启动后，在容器未全部停止之前，镜像是无法被删除的。
- Linux Docker主机本地镜像仓库通常位于`/var/lib/docker/<storage-driver>`
- 每个Docker镜像仓库服务（Image Registry）可以包含多个镜像仓库（Image Repository），而每个镜像仓库中又可以包含多个不同标签的镜像。因此镜像是存储在镜像仓库服务中的镜像仓库中的。Docker客户端的镜像仓库服务是可配置的，默认使用Docker Hub。
- 同一个镜像可以根据用户需要设置多个标签。例如同时设置标签为latest和edge。在拉取镜像时，如果没有显式指定标签，默认拉取标签为latest的镜像。注意：latest是一个非强制标签，不保证指向仓库中最新的镜像。
- 一个Docker镜像由多个松耦合的只读镜像层组成。
- 当构建Docker镜像时，可以通过嵌入指令来列出希望容器运行时启动的默认应用。



## 镜像的获取

获取镜像的方式有三种：

- 通过命令从公有仓库或私有仓库拉取，`pull from `
- 通过dockerfile构建镜像
- 离线方式，通过文件加载镜像，`load from`，先导出再加载进来。

### 镜像仓库（registry）

- dockerhub（推荐）
- Quay



## 镜像与分层

Docker镜像由一些松耦合的只读镜像层组成，Docker负责堆叠这些镜像层，并且将它们表示为单个统一的对象。

所有的Docker镜像都起始于一个基础镜像层，当进行修改或增加新的内容时，就会在当前镜像层之上，创建新的镜像层。

在添加额外的镜像层的同时，镜像始终保持是当前所有镜像层的组合。如果要添加的上层镜像层中的文件，覆盖了底层镜像层中的文件，那么这个要添加的上层镜像层就是一个更新版本，它将会作为一个新镜像层添加到镜像当中。Docker通过存储引擎（新版本采用快照机制）的方式来实现镜像层堆栈，并保证多镜像层对外展示为统一的文件系统。（所有镜像层堆叠并合并，对外提供统一的视图）。

当多个镜像层堆叠在一起，就构成了一个完整镜像。

在拉取镜像的时候，Docker可以识别出要拉取的镜像中，哪几层已经在本地存在，多个镜像之间会共享镜像层，这样可以有效节省空间并提升性能。

可以使用以下方式查看和检查构成某个镜像的分层。

方式一：使用docker image pull命令。

```shell
$ docker image pull mongo
Using default tag: latest
latest: Pulling from library/mongo
a1125296b23d: Pull complete
3c742a4a0f38: Pull complete
4c5ea3b32996: Pull complete
1b4be91ead68: Pull complete
af8504826779: Pull complete
8faaabd5f8b2: Pull complete
...
```

上述一Pull complete结尾的每一行都代表了镜像中某个被拉取的镜像层，最前面的为镜像层ID。

方式二：通过`docker image inspect`命令查看。

```shell
$ docker image inspect mongo
...
 "Layers": [
 "sha256:88cc1a200eb9be206c4261e79d642c392d97980236a066f23434f4452f8212a7",
 "sha256:bf509d6bc5ecd3b1a3660fb5f167ce2e320f5cc532574217cd8ba179ca06bae9",             "sha256:2af0e1f1e531af9c95e30c3f908f6431d635a173b866e39b5f480e9ff3a180b9",
  ...
  ]
...
```

上述输出的内容中使用了镜像的SHA256散列值来标识镜像层。

## 虚悬镜像

```shell
$ docker image ls -f dangling=true
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
<none>              <none>              00285df0df87        5 days ago          342 MB
```

上面列表中显示的的镜像是一类特殊的镜像，这些镜像既没有仓库名，也没有标签，均为 `<none>`。这类无标签镜像被称为 ==虚悬镜像(==dangling image) ，在列表中展示为`<none>:<none>`。

通常出现这种情况，是因为构建了一个新镜像，然后为该镜像打了一个已经存在的标签。当次情况出现，Docker会构建新的镜像，然后发现已经有镜像包含相同的标签，接着Docker会移除旧镜像上面的标签，并将该标签标在新的镜像之上。同时移除了旧镜像上面对应的标签，旧镜像就变成了悬虚镜像。

可以用下面的命令专门显示这类镜像：

```shell
$ docker image ls -f dangling=true
```

一般来说，虚悬镜像已经失去了存在的价值，是可以随意删除的，可以用下面的命令删除。

```shell
$ docker image prune
```

如果添加了`-a`参数，Docker会额外移除没有被任何容器使用的镜像。

## 中间层镜像

为了加速镜像构建、重复利用资源，Docker 会利用 **中间层镜像**。中间层镜像，是其它镜像所依赖的镜像。

默认的 `docker image ls` 列表中只会显示顶层镜像，如果希望显示包括中间层镜像在内的所有镜像的话，需要加 `-a` 参数。

```shell
$ docker image ls -a
```

## 镜像摘要

对于标签相同的多个镜像，如果需要区分正在使用的镜像版本是修复前还是修复后的，可以通过镜像摘要来区分。

镜像摘要是镜像内容的一个散列值（内容散列），镜像内容的变更一定会导致散列值的改变。因此，如果镜像没有发生变化，它的摘要也是不可变的。

可以通过`docker image ls`命令添加`--digests`参数来查看镜像摘要：

```sh
$ docker image ls --digests alpine
REPOSITORY          TAG                 DIGEST                                                                    IMAGE ID            CREATED             SIZE
alpine              latest              sha256:185518070891758909c9f839cf4ca393ee977ac378609f700f60a771a2dfe321   a24bb4013296        5 weeks ago         5.57MB

```

上述镜像的签名值即为摘要信息，如下：

`sha256:185518070891758909c9f839cf4ca393ee977ac378609f700f60a771a2dfe321`

目前，已经没有原生的Docker命令支持从远端镜像仓库服务（如Docker Hub）中直接获取镜像签名了，因此必须先要通过标签方式拉取镜像到本地，然后自己维护镜像的摘要列表。

通过摘要拉取镜像的命令：

```
docker image pull alpine@<sha256散列值>
```

例如：先删除alpine:latest镜像，然后通过摘要再次拉取该镜像：

```shell
$ docker image rm alpine:latest
Untagged: alpine:latest
Untagged: alpine@sha256:185518070891758909c9f839cf4ca393ee977ac378609f700f60a771a2dfe321
Deleted: sha256:a24bb4013296f61e89ba57005a7b3e52274d8edd3ae2077d04395f806b63d83e
...
$ docker image pull alpine@sha256:185518070891758909c9f839cf4ca393ee977ac378609f700f60a771a2dfe321
sha256:185518070891758909c9f839cf4ca393ee977ac378609f700f60a771a2dfe321: Pulling from library/alpine
df20fa9351a1: Pull complete
...
```

## docker image 命令

### docker image ls

列出已经下载下来的镜像。

#### 命令格式

```
docker image ls [options]
```

#### 命令说明

使用该命令可以列出已经下载下来的镜像列表，包含仓库名、标签、镜像ID、创建时间以及所占用的空间。

`docker image ls` 列表中的镜像体积总和并非是所有镜像实际硬盘消耗。由于 Docker 镜像是多层存储结构，并且可以继承、复用，因此不同镜像可能会因为使用相同的基础镜像，从而拥有共同的层。由于 Docker 使用 Union FS，相同的层只需要保存一份即可，因此实际镜像硬盘占用空间很可能要比这个列表镜像大小的总和要小的多。

同时，也可以使用该命令显示虚悬镜像。（具体见示例二说明）

#### 参数描述

- --filter ( -f )：过滤`docker image ls`命令返回的镜像列表内容。支持如下过滤器：
  - dangling：可以指定true或false，仅返回悬虚镜像（true），或者非悬虚镜像（false）。
  - before：返回在之前被创建的全部镜像，需要镜像名称或者ID作为参数。
  - since：返回指定镜像之后创建的全部镜像。与before用法类似。
  - label：根据标注（label）的名称或值，对镜像镜像过滤。
  - reference：用于其他过滤方式
- -a：显示全部镜像，包括顶层镜像和中间层镜像。
- --format：对输出的内容进行格式化。
- --digests：查看镜像的摘要信息（SHA256签名）。
- -q：返回镜像的ID列表。

#### 综合示例

示例一：列出当前本地Docker主机上已拉取的镜像。

```shell
$ docker image ls
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
redis               latest              5f515359c7f8        5 days ago          183 MB
ubuntu              18.04               f753707788c5        4 weeks ago         127 MB
ubuntu              latest              f753707788c5        4 weeks ago         127 MB
```

上述列出的镜像列表说明如下：

列表包含了 `仓库名`、`标签`、`镜像 ID`、`创建时间` 以及 `所占用的空间`。

**镜像 ID** 则是镜像的唯一标识，一个镜像可以对应多个 **标签**。例如上面的`ubuntu:18.04` 和 `ubuntu:latest` 拥有相同的 ID，因为它们对应的是同一个镜像。

示例二：根据仓库名列出镜像

```shell
$ docker image ls ubuntu
```

示例三：列出特定的某个镜像，也就是说指定仓库名和标签

```shell
$ docker image ls ubuntu:18.04
```

示例四：查看在 `mongo:3.2` 之后建立的镜像：

```shell
$ docker image ls -f since=mongo:3.2
```

想查看某个位置之前的镜像也可以，只需要把 `since` 换成 `before` 即可。

示例五：如果镜像构建时，定义了 `LABEL`，还可以通过 `LABEL` 来过滤。

```shell
$ docker image ls -f label=com.example.version=0.1
```

示例六：使用reference完成过滤并且仅显示标签为latest的镜像。

```shell
$ docker image ls --filter=reference="*:latest"
```

示例七：显示本地拉取的全部镜像的ID列表。

```shell
$ docker image ls -q
5f515359c7f8
05a60462f8ba
```

示例八：只返回Docker主机上镜像的大小属性。

```shell
$ docker image ls --format "{{.Size}}"
73.9MB
5.57MB
13.3kB
425MB
```

示例九：按照指定的格式显示镜像ID、仓库名称、标签信息。

```shell
$ docker image ls --format "table {{.ID}}\t{{.Repository}}\t{{.Tag}}"
IMAGE ID            REPOSITORY          TAG
5f515359c7f8        redis               latest
05a60462f8ba        nginx               latest
```

### docker image pull

将镜像取到Docker主机本地的操作是拉取。该命令用于将镜像拉取到本地。只需要给出镜像的仓库名字和标签，就能在官方仓库中定位一个镜像（采用 “:” 分隔）。

docker image pull 可以简写为 docker pull，这两个命令的作用相同，都用于从 Docker 镜像仓库获取镜像。

注意：标签为latest的镜像只是一种普通的镜像，并不保证标有latest标签的镜像是仓库中最新的镜像。（有些仓库中最新的镜像通常标签是edge）

#### 命令格式

```
docker image pull [options] [DockerRegistry地址[:端口号]/]repository[:tag]
```

#### 命令说明

- DockerRegistry地址：地址的格式一般是 <域名/IP>[:端口号]。默认地址是 Docker Hub。
- repository：这里的仓库名是两段式名称，即 <用户名>/<软件名>。对于 Docker Hub，如果不给出用户名，则默认为 library，也就是官方镜像。
- 如果没有在仓库名称后指定具体的镜像标签，则Docker默认拉取标签为latest的镜像。
- 如果是从第三方镜像仓库服务（非Docker Hub）获取镜像，需要在镜像仓库名称前加上第三方镜像仓库服务的DNS名称。

#### 选项描述

- -a：拉取仓库中的所有标签的全部镜像。

#### 综合示例

示例一：从Ubuntu仓库中拉取标签为“latest” 的镜像。

```shell
$ docker image pull ubuntu:latest
```

示例二：从官方Mongo库拉取标签为3.3.11的镜像。

```shell
$ docker image pull mongo:3.3.11
```

示例三：从官方Alpine库拉取标签为latest的镜像。

```shell
$ docker image pull alpine
```

示例四：从Microsoft/powershell仓库中拉取标签为nanoserver的镜像

```shell
$ docker image pull microsoft/powershell:nanoserver
```

示例五：从第三方镜像仓库服务GCR获取镜像。

```shell
$ docker image pull gcr.io/nigelpoulton/tu-demo:v2
$ docker pull gcr.azk8s.cn/google_containers/hyperkube-amd64:v1.9.2
```

上述中的“nigelpoulton”表示用户名。

### docker image build

根据Dockerfile中的指令来创建新的镜像。

#### 命令格式

```
docker image build [选项] <镜像> <path>
```

#### 命令说明

需要进入到Dockerfile文件所在的目录后，执行该命令。

#### 参数描述

- -t：为镜像打标签
- -f：指定Dockerfile的路径和名称，使用-f参数可以指定位于任意路径下的任意名称的Dockerfile。构建上下文是指应用文件存放的位置，可能是本地Docker主机上的一个目录或一个远程Git库。
- --nocache=true：可以强制忽略对缓存的使用。
- --squash：创建一个合并的镜像。

#### 综合示例

示例：创建镜像名为test:latest的Docker镜像。

```shell
$ docker image build -t test:latest .
```

上述命令会构建并生成一个名为test:latest的镜像，注意：命令最后的点（.）表示Docker在进行构建的时候，使用当前目录作为构建上下文。

### docker image import



### docker image inspect

用于查看镜像的详细信息，包括镜像层数据和元数据。

示例：查看mongo镜像的详细信息。

```shell
$ docker image inspect mongo
```

该命令同时可以查看容器启动时将要运行的应用列表。

```shell
$ docker image inspect nigelpoulton/pluralsight-docker-ci:latest
...
 "Cmd": [
                "/bin/sh",
                "-c",
                "#(nop) ",
                "CMD [\"/bin/sh\" \"-c\" \"cd /src && node ./app.js\"]"
            ],
...
```

上述结果中的Cmd一项展示了容器启动后将会执行的命令或应用。除此之外，也可以在启动的时候，人为手动的指定其他的应用。

在构建镜像时指定默认命令是一种很普遍的做法，这样可以简化容器的启动，也为镜像指定了默认的行为，从侧面阐述了镜像的用途。

### docker image load

将物理镜像文件还原成镜像。

```shell
$ docker image load -i .\nginx.image
```

镜像导出成文件，参见`docker image save`命令。

### docker image rm

用于删除镜像，删除操作会在当前主机上删除该镜像以及相关的镜像层。但是如果某个镜像层被多个镜像共享，那么只有当全部依赖该镜像层的镜像都被删除后，该镜像层才会被删除。

由于容器是根据镜像创建的，当镜像存在关联的容器，并且容器处于运行（Up）或者停止（Exited）状态时，不允许删除该镜像（见示例五），必须先删除容器只能执行删除镜像的操作。

#### 命令格式

```
$ docker image rm [选项] <镜像1> [<镜像2> ...]
```

#### 命令说明

命令中的<镜像>可以是`镜像短 ID`、`镜像长 ID`、`镜像名` 或者 `镜像摘要`。

可以通过`docker image ls`查看镜像的ID，然后摘取ID的前几位可以区分不同镜像的字符即可。

#### 综合示例

```shell
$ docker image ls
REPOSITORY             TAG           IMAGE ID            CREATED             SIZE
centos                 latest        0584b3d2cf6d        3 weeks ago         196.5 MB
redis                  alpine        501ad78535f0        3 weeks ago         21.03 MB
```

示例一，通过ID删除 `redis:alpine` 镜像，可以执行：

```shell
$ docker image rm 501
Untagged: redis:alpine
...
```

示例二，使用`镜像名`，也就是 `<仓库名>:<标签>`，来删除镜像。

```shell
$ docker image rm centos
Untagged: centos:latest
```

示例三，更精确的是使用 `镜像摘要` 删除镜像。

```shell
$ docker image ls --digests
REPOSITORY                  TAG                 DIGEST                                                                    IMAGE ID            CREATED             SIZE
node                        slim                sha256:b4f0e0bdeb578043c1ea6862f0d40cc4afe32a4a582f3be235a3b164422be228   6e0c4c8e3913        3 weeks ago         214 MB

$ docker image rm node@sha256:b4f0e0bdeb578043c1ea6862f0d40cc4afe32a4a582f3be235a3b164422be228
Untagged: node@sha256:b4f0e0bdeb578043c1ea6862f0d40cc4afe32a4a582f3be235a3b164422be228
```

**示例四，删除Docker主机上的全部镜像**：

```shell
$ docker image ls -q
340bd30ab40hf30f
ed03f530fh0q202j
$ docker image rm $(docker image ls -q) -f
```

上述操作，先通过`docker image ls -q`命令获取全部镜像ID，然后将其传给`docker image rm`命令执行删除镜像的操作。

示例五，删除存在关联容器的镜像：

需先删除容器，再删除镜像。

```shell
$ docker container ls -a
CONTAINER ID   IMAGE     COMMAND   CREATED       STATUS                     PORTS     NAMES
500b748b7bdb   ubuntu    "sh"      2 weeks ago   Exited (127) 2 weeks ago             intelligent_snyder
$ docker container rm 500
$ docker image ls
REPOSITORY   TAG       IMAGE ID       CREATED       SIZE
ubuntu       latest    27941809078c   8 weeks ago   77.8MB
$ docker image rm 279
Untagged: ubuntu:latest
Untagged: ubuntu@sha256:b6b83d3c331794420340093eb706a6f152d9c1fa51b262d9bf34594887c2c7ac
Deleted: sha256:27941809078cc9b2802deb2b0bb6feed6c236cde01e487f200e24653533701ee
Deleted: sha256:a790f937a6aea2600982de54a5fb995c681dd74f26968d6b74286e06839e4fb3
```



### docker image save

将镜像保存成一个文件，以便其他地方进行导入。

将文件还原成镜像文件，参见`docker image load`命令。

#### 命令格式

```shell
docker image save <镜像> -o <文件名>
```

#### 命令说明

-o：指定要保存的文件的位置。

示例一，将版本为1.20.0的nginx镜像，保存为nginx.image文件。

```shell
cd /home/iamgefile
$ docker image save nginx:1.20.0 -o nginx.image
```

### docker image tag

用于为指定的镜像添加一个额外的标签。

#### 命令格式

```
docker image tag <current-tag> <new-tag>
```

#### 命令说明

current-tag：使用`docker image build`命令构建镜像时指定的标签。

该命令不需要覆盖已经存在的标签。

#### 综合示例

```shell
$ docker image tag web:latest smallz/web:latest
```

### docker image push

用于将镜像推送到Docker Hub中。

```shell
$ docker image push smallz/web:latest
```

### docker image prune



### docker image history

显示在构建镜像的过程中，都执行了哪些指令。

```shell
$ docker image history web:latest
IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
dab74052193a        15 hours ago        /bin/sh -c #(nop)  ENTRYPOINT ["node" "./app…   0B
224a3531a754        15 hours ago        /bin/sh -c #(nop)  EXPOSE 8080                  0B
c3ec0a945100        15 hours ago        /bin/sh -c npm install                          20.9MB
97bbd9fb9a28        15 hours ago        /bin/sh -c #(nop) WORKDIR /src                  0B
27359f55024b        15 hours ago        /bin/sh -c #(nop) COPY dir:8abfedb4af4f697c8…   2.29kB
0e580c769e09        15 hours ago        /bin/sh -c apk add --update nodejs nodejs-npm   51MB
0fb275ef5c63        15 hours ago        /bin/sh -c #(nop)  LABEL maintainer=nigelpou…   0B
a24bb4013296        7 weeks ago         /bin/sh -c #(nop)  CMD ["/bin/sh"]              0B
<missing>           7 weeks ago         /bin/sh -c #(nop) ADD file:c92c248239f8c7b9b…   5.57MB
```

通过该命令输出的内容，每一行都对应了Dockerfile中的一条指令，顺序是从下到上。

其中SIZE列对应的数值不为零的指令，都会新建镜像层。



## docker image 命令的配合使用

示例一，删除所有仓库名为 `redis` 的镜像：

```shell
$ docker image rm $(docker image ls -q redis)
```

示例二，删除所有在 `mongo:3.2` 之前的镜像：

```shell
$ docker image rm $(docker image ls -q -f before=mongo:3.2)
```


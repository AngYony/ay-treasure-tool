# Docker核心知识与常用命令

登录上Docker所在的主机之后，第一件事就是检查Docker是否正在运行。

```shell
$ docker version
Client: Docker Engine - Community
 Version:           19.03.12
...

Server: Docker Engine - Community
 Engine:
  Version:          19.03.12
  API version:      1.40 (minimum version 1.12)
...
```

如果上述内容包括Client和Server的内容，则说明Docker运行正常。可以通过如下命令，检查Docker daemon的状态：

```shell
$ service docker status
或
$ systemctl is-active docker
```





## docker system

### docker system df

用于查看镜像、容器、数据卷所占用的空间。

#### 命令格式

```shell
docker system df
```

#### 示例

```shell
$ docker system df

TYPE			TOTAL		ACTIVE		SIZE			RECLAIMABLE
Images      	24      	0           1.992GB     	1.992GB (100%)
Containers      1           0           62.82MB         62.82MB (100%)
Local Volumes   9           0           652.2MB         652.2MB (100%)
Build Cache                             0B              0B
```

上面列表中显示的最后一条镜像为虚悬镜像（见上文说明）。



## docker ps 

docker ps：列出container



## docker service 

### docker service create



## docker search

### docker search

docker search命令允许通过CLI的方式搜索Docker Hub。

#### 命令格式

```
docker search <searchvalue> [options]
```

#### 命令说明

searchvalue：表示将要搜索的内容，该命令会搜索所有“NAME”字段中包含特定字符串的仓库。“NAME”字段是仓库名称，包含了DockerID，或者非官方仓库的组织名称。

##### 参数描述

- --filter
  - is-official：是否只显示官方镜像。
  - is-automated：是否只显示自动创建的仓库。
- --limit：默认情况下，Docker只返回25行结果。可以指定--limit参数来增加返回内容行数，最多为100行。

#### 综合示例

示例一：在默认的镜像仓库服务Docker Hub中，搜索NAME”字段中包含“nigelpoulton”的所有仓库。

```shell
$ docker search nigelpoulton
NAME                                 DESCRIPTION     STARS    OFFICIAL    AUTOMATED
nigelpoulton/pluralsight-docker-ci   Simple …   	 23                   [OK]
nigelpoulton/tu-demo                 Voting…   		 12
nigelpoulton/ctr-demo                Web service…    3
...
```

注意：上面返回的镜像中既有官方的也有非官方的。如果需要只显示官方镜像，需要使用`--filter`选项。

示例二：列出所有仓库名称中包含“alpine”的官方镜像：

```shell
$ docker search alpine --filter "is-official=true"
```

示例三：只显示自动创建的仓库，并且仓库名称中包含“nigelpoulton”的镜像：

```shell
$ docker search nigelpoulton --filter "is-automated=true"
```



## docker network



### docker network ls

查看网络列表。

```shell
$ docker network ls
NETWORK ID          NAME                      DRIVER              SCOPE
cc246b1076cd        bridge                    bridge              local
953f3bd3dcb4        wyapp_wy-net   			  bridge              local
...
```



## docker volume



### docker volume ls

查看卷列表。

```shell
$ docker volume ls
DRIVER              VOLUME NAME
local               7f26bd74922581b42b224b44a81fb642dfd2684106a7909b148fee4bebee3875
local               wyapp_wy-vol
```



## docker-compose

执行docker-compose相关的命令时，必须先进入到YAML文件（docker-compose.yml）所在的目录中。

### docker-compose ps

查看Docker Compose应用的状态，该命令会列出Compose应用中的各个容器。

```shell
$ docker-compose ps
     Name                   Command               State           Ports
--------------------------------------------------------------------------------
wyapp_redis_1    docker-entrypoint.sh redis ...   Up      6379/tcp
wyapp_web-fe_1   python app.py                    Up      0.0.0.0:5000->5000/tcp
```

输出那个会显示容器名称、其中运行的Command、当前状态以及其监听的网络端口。

### docker-compose up

使用`docker-compose up`命令用于部署一个Compose应用，它会启动一个Compose应用，该命令会构建所需的镜像，并创建网络和卷，并启动容器。

默认情况下，该命令会读取名为 docker-compose.yml或docker-compose.yaml的文件。

#### 命令格式

```
docker-compose [选项][YAML文件名] up [选项]
```

#### 命令说明

通常在YAML文件所在的目录中执行该命令，默认情况下，该命令会查找所在目录中名为docker-compose.yml或docker-compose.yaml的Compose文件。如果Compose文件是其他文件名，则需要通过`-f`参数来指定。

#### 选项描述

- -d：指定在后台启动应用。
- -f：指定其他Compose文件名。
- &：使用 & 将终端窗口返回，因此它运行在前台。

#### 综合示例

示例一，基于名为prod-equus-bass.yml的Compose文件部署应用：

```shell
$ docker-compose -f prod-equus-bass.yml up
```

示例二，在后台启动Compose应用：

```shell
$ docker-compose up -d
$ docker-compose -f prod-equus-bass.yml up -d
```

### docker-compose down

停止和关闭Docker Compose应用。该命令会停止并且也会删除运行中的Compose应用，它会删除容器和网络，但是不会删除卷和镜像。

```shell
$ docker-compose down
```

注意：使用`docker-compose down`停止应用时，vol卷并没有被删除。写到卷上的所有数据都会保存下来。

### docker-compose top

该命令会列出各个服务（容器）内运行的进程。

```shell
$ docker-compose top
wyapp_redis_1
  UID      PID    PPID   C   STIME   TTY     TIME         CMD
------------------------------------------------------------------
systemd+   4165   4131   0   04:29   ?     00:00:00   redis-server

wyapp_web-fe_1
UID    PID    PPID   C   STIME   TTY     TIME                    CMD
------------------------------------------------------------------------------------
root   4179   4141   0   04:29   ?     00:00:00   python app.py
root   4284   4179   0   04:29   ?     00:00:01   /usr/local/bin/python /code/app.py
```

上述结果中，PID编号是在Docker主机上（而不是容器内）的进程ID。

### docker-compose stop

该命令会停止Docker Compose应用相关的所有容器，但不会删除它们及资源。被停止的应用可以通过 docker-compose restart 命令重新启动。

```shell
$ docker-compose stop
Stopping wyapp_web-fe_1 ... done
Stopping wyapp_redis_1  ... done
```

注意：如果用户在停止该应用后对其进行了变更，那么变更的内容不会反映在重启后的应用中，这时需要重新部署应用使变更生效。

### docker-compose rm

该命令用于删除已停止的Compose应用。它会删除容器和网络，但是不会删除卷和镜像。

```shell
$ docker-compose rm
Going to remove wyapp_web-fe_1, wyapp_redis_1
```

注意：该命令只会删除应用相关的容器和网络，不会删除卷和镜像，也不会删除应用源码（YAML文件所在的目录中的源码）。

### docker-compose restart

docker-compose restart 命令会重启已停止的Compose应用。

```shell
$ docker-compose restart
Restarting wyapp_web-fe_1 ... done
Restarting wyapp_redis_1  ... done
```

注意：如果用户在停止该应用后对其进行了变更，那么变更的内容不会反映在重启后的应用中，这时需要重新部署应用使变更生效。



## 其他命令

### docker version

查看docker版本信息。

### docker info

查看docker信息，包括当前images个数，containers数量等。
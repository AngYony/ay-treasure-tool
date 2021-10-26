# nginx.conf 详解与配置

nginx.conf 位于 /nginx/conf/ 目录中。



## nginx.conf 配置结构

![image-20211021161445039](assets/image-20211021161445039.png)

注意：

- 每个指令以`;`（英文分号）结尾；
- 每个指令块以一对`{}`结尾，且大括号的后方没有分号；
- 使用`#`注释；
- 使用`$`引入参数变量；





## nginx.conf 主要配置项说明

### user

设置worker进程的用户，指的linux中的用户，会涉及到nginx操作目录或文件的一些权限，默认为 nobody。

```nginx
user root;
```

### worker_processes

工作进程数，一般设置为CPU核心数，或者核心数减一。

```nginx
worker_processes 4;
```

### error_log

配置错误日志的级别和文件存放位置。

一般会在安装的时候，指定存放位置：

```shell
...
--error-log-path=/var/log/nginx/error.log \ 
...
```

nginx 日志级别<code>debug | info | notice | warn | error | crit | alert | emerg</code>，错误级别从左到右越来越大。

如果在安装的时候指定了日志存放的位置，那么就不需要对文件存放位置进行再次配置了。

如果需要更改日志文件存放位置，取消注释并指定新文件即可：

```nginx
#error_log logs/error.log notice;
```



### pid

设置nginx进程 pid 存放的文件位置。

可以在安装的时候直接指定：

```
...
--pid-path=/var/run/nginx/nginx.pid \
...
```

也可以重新配置，取消注释并指定文件即可：

```nginx
#pid        logs/nginx.pid;
```

### events

事件处理指令块。用于配置工作模式以及连接数。

```nginx
events {
    # 默认使用epoll
	use epoll;
    # 单个worker进程的连接数（每个worker允许连接的客户端最大连接数）
	worker_connections 10240;
}
```

### http

http 模块相关配置，针对 http 网络传输的一些指令配置。

#### include

include 引入外部配置，提高可读性，避免单个配置文件过大。

```nginx
# 导入mime.types文件
include       mime.types;
```

#### log_format 、access_log

设置日志格式，main为定义的格式名称，如此 access_log 就可以直接使用这个变量了。

access_log也可以在编译安装的时候指定：

```shell
...
--http-log-path=/var/log/nginx/access.log \
...
```

也可以重新配置，只需要取消注释，配置新的文件即可：

![image-20211021171217900](assets/image-20211021171217900.png)

access.log记录了每次请求的日志。

| 参数名                | 参数意义                             |
| --------------------- | ------------------------------------ |
| $remote_addr          | 客户端ip                             |
| $remote_user          | 远程客户端用户名，一般为：’-’        |
| $time_local           | 时间和时区                           |
| $request              | 请求的url以及method                  |
| $status               | 响应状态码                           |
| $body_bytes_send      | 响应客户端内容字节数                 |
| $http_referer         | 记录用户从哪个链接跳转过来的         |
| $http_user_agent      | 用户所使用的代理，一般来时都是浏览器 |
| $http_x_forwarded_for | 通过代理服务器来记录客户端的ip       |

#### sendfile、tcp_nopush

`sendfile`使用高效文件传输，提升传输性能。

启用后才能使用<code>tcp_nopush</code>，是指当数据表累积一定大小后才发送，提高了效率。

```nginx
sendfile        on;
#tcp_nopush      on;
```

#### keepalive_timeout

<code>keepalive_timeout</code>设置客户端与服务端请求的超时时间，保证客户端多次请求的时候不会重复建立新的连接，节约资源损耗。

```nginx
#keepalive_timeout  0;
keepalive_timeout  65;
```

#### gzip

<code>gzip</code>启用压缩，html/js/css压缩后传输会更快，当然开启后，nginx会有额外开销。

```nginx
# 开启gzip压缩功能，目的：提高传输速率，节约带宽
gzip on;
# 限制最小压缩，小于1字节文件不会压缩
gzip_min_length 1;
#定义压缩的级别，范围1~9，值值越大，压缩比越大，CPU占用资源越多
gzip_comp_level 3;
#指定对那些类型的文件进行压缩
gzip_types text/plain application/javascript application/x-javascript text/css application/xml text/javascript application/x-httpd-php image/jpeg image/gif image/png application/json;

```

#### upstream 负载均衡

用于配置上游服务器（代理服务器），也就是请求被转发到要进行处理的服务器。

通过upstream配置多台代理服务器组成集群，就可以实现nginx负载均衡。

```nginx
upstream myApp {
    server 192.168.1.173:8080;
    server 192.168.1.174:8080;
    server 192.168.1.175:8080;
}	
```

upstream需要结合server配置项一起使用：

```nginx
server {
	listen 80;
	server_name www.smallz.com;
    
    location / {
        proxy_pass http://myApp;
    }
}
```

upstream块中的其他指令参数介绍如下。

##### keepalive 提高吞吐量

- keepalive：设置长连接处理的数量，要保持的连接数。
- proxy_http_version：设置长连接http版本为1.1。
- proxy_set_header：清除Connection header信息。

```nginx
upstream myApp {
    server 192.168.1.173:8080;
    server 192.168.1.174:8080;
    
    keepalive 32;
}	

server {
	listen 80;
	server_name www.smallz.com;
    
    location / {
        proxy_pass http://myApp;
        # 配置了keepalive时，必须配置以下内容
        proxy_http_version 1.1;
        proxy_set_header Connection "";
    }
}
```

配置keepalive时，同时需要配置proxy_http_version和proxy_set_header。

##### max_conns

限制配置在upstream中的一台服务器的最大连接数，一般不需要配置。默认值为0，表示不做限制。

```nginx
upstream myApp {
    server 192.168.1.173:8080 max_conns=200;
    server 192.168.1.174:8080 max_conns=200;
    server 192.168.1.175:8080;
}
```

##### slow_start

slow_start指令只存在于商业版的Nginx，目前开源版暂不支持。（可以尝试nginx -t 测试一下）

会在指定时间内，慢慢将权重从0升级到配置的权重值。该指令只适用于权重策略，并且不适用于单台服务器（配置了也会失效）。

```nginx
upstream myApp {
    server 192.168.1.173:8080 weight=6 slow_start=60s;
    server 192.168.1.174:8080 weight=2;
    server 192.168.1.175:8080 weight=2;
}	
```

在60秒内，权重慢慢从0调整到6。

##### down

指定某台服务器不可用。

```nginx
upstream myApp {
    server 192.168.1.173:8080 down;
    server 192.168.1.174:8080;
    server 192.168.1.175:8080;
}	
```

配置了down指令的该台服务器，不会被用户访问到。在nginx中，某台服务器不可用时，最好的做法是添加down，尤其是在负载均衡配置中，不要直接删除服务器配置，而是标注down。这是因为，在负载均衡中，可能会牵扯到资源分配的算法，比如ip_hash，此时直接删除配置项，会导致基于之前算法的服务器的缓存和会话全部丢失。

##### backup

配置了backup指令的服务器，一开始是不会被访问到的，只有在其他服务器挂掉的情况下，才会被访问到。

```nginx
upstream myApp {
    server 192.168.1.173:8080 backup;
    server 192.168.1.174:8080 weight=2;
    server 192.168.1.175:8080 weight=2;
}	
```

##### max_fails、fail_timeout

max_fails：最大失败次数，默认为1；

fail_timeout：在请求达到max_fails设置的失败次数后，设置等待多长时间再次尝试请求到该服务器。默认为10秒。

```nginx
upstream myApp {
    server 192.168.1.173:8080 max_fails=2 fail_timeout=15s;
    server 192.168.1.174:8080 weight=2;
    server 192.168.1.175:8080 weight=2;
}	
```

则代表在15秒内请求某一server失败达到2次后，则认为该server已经挂了或者宕机了，随后再过15秒，这15秒内不会有新的请求到达刚刚挂掉的节点上，而是会请求到正常运作的server，15秒后会再有新请求尝试连接挂掉的server，如果还是失败，重复上一过程，直到恢复。





#### nginx负载均衡的几种策略

- 轮询，默认策略，按照轮流形式转发给应用服务器。
- 权重，加权轮询。在轮询的基础上，进行权重设置。
- ip_hash

##### 轮询

nginx负载均衡的默认模式。

##### 权重

在轮询的基础上，对于性能强的服务器，可以在nginx进行权重设置来实现资源的最大化利用。

配置权重时，需要为server指定权重级别，默认为1，值越大，被分配处理的可能性越大：

```nginx
upstream myApp {
    server 192.168.1.173:8080 weight=1;
    server 192.168.1.174:8080 weight=2;
    server 192.168.1.175:8080 weight=5;
}
```

配置了上述权重后，假如此时有8个请求，其中会有5个被转发到第三台服务器进行处理。

##### ip_hash

根据ip的hash值算法，去分配服务器。hash(ip) % node_counts = index （hash值 % 节点数= 索引下标对应的服务器节点）

同一个ip，在多次请求时，会被转发到同一台服务器上。这样就保证，每次请求时，所有的会话都处于同一个服务中，这样服务器中的缓存，都可以拿到。

```nginx
upstream myApp {
	ip_hash;
    server 192.168.1.173:8080;
    server 192.168.1.174:8080;
    server 192.168.1.175:8080;
}	
```

注意：当使用ip_hash策略时，一旦某台服务器不再使用了，不能直接删除该行配置，只能标注down。这是因为一旦删除该行配置，会导致ip_hash的重新计算，导致之前服务器上的会话和缓存丢失。

ip_hash带来的问题：

- 一旦某个服务器节点添加或移除，都会导致分配算法的重新计算和分配，这样原来的缓存和会话都会丢失。

##### url_hash

对url进行hash求值，去分配不同的服务器节点。hash(url) % node_counts = index

```nginx
upstream myApp {
	# 引入内置变量
	hash $request_uri;
    server 192.168.1.173:8080;
    server 192.168.1.174:8080;
    server 192.168.1.175:8080;
}	
```

##### least_conn

基于最少连接数分配服务器节点。哪个当前的连接数最少，就优先选择哪台服务器。

```nginx
upstream myApp {
	# 引入内置变量
	least_conn;
    server 192.168.1.173:8080;
    server 192.168.1.174:8080;
    server 192.168.1.175:8080;
}	
```





#### server

虚拟主机配置，http下面可以有多个server配置。

```nginx
server {
    # 监听的端口号，浏览器通过该端口号访问服务
	listen      80;
    # 请求的IP，或备案过的域名
	server_name localhost;
    # 配置路由规则，表达式
	location / {
        # 基于/conf的相对目录
		root html;
        # 配置默认首页
		index index.html index.htm;
	}
	error_page 500 502 503 504 /50x.html;
	location = /50x.html {
        # 配置请求位置
		root html;
	}
}

server {
    listen 90;
    server_name localhost;
    
    location / {
        # 指定目录位置，此处是绝对路径
        root /home/mysite;
        index index.html;
    }
    # 可以指定多个location
    location /wy {
        root /home/wysrc;
    }
    # 更常用的使用使用alias指定位置，而不是root
    location /smallz {
        alias /home/wysrc;
    }
}

```

一般可以将server的内容，放在一个独立的配置文件中，例如：wy_server.conf，然后使用include引入进来。

##### add_header 配置跨域

```nginx
server {
	listen 90;
    server_name localhost;
    
    #允许跨域请求的域，*代表所有
    add_header 'Access-Control-Allow-Origin' *;
    #允许带上cookie请求
    add_header 'Access-Control-Allow-Credentials' 'true';
    #允许请求的方法，比如 GET/POST/PUT/DELETE
    add_header 'Access-Control-Allow-Methods' *;
    #允许请求的header
    add_header 'Access-Control-Allow-Headers' *;
    
    location ....
    ...
}
```

##### valid_referers 配置静态资源防盗链

```nginx
server {
	listen 90;
    server_name localhost;
    #对源站点验证
    valid_referers *.imooc.com; 
    #非法引入会进入下方判断
    if ($invalid_referer) {
        return 403;
    } 
    
    location ...
    ...
}
```

上述配置表示，只有在以.imooc.com结尾的站点中，访问资源才有效。可以实现，其他站点引用图片链接，被拒绝响应的功能。



##### locatoin 路由规则

- 默认匹配规则

  ```nginx
  location / {
  	root html;
  	index index.html;
  }
  ```

- `=`：精确匹配

  ```nginx
  location = /wy/img/face.jpg {
  	root home;
  }
  ```

  精确匹配规则下，必须完全匹配location指定的规则才能访问到资源。例如只存在一条location规则，如上述所示，那么在域名下只有访问/wy/img/face.jpg才能获取到资源，访问其他任何url都不行。

- `~`：匹配正则表达式，**区分**大小写

  ```nginx
  #GIF必须大写才能匹配到
  location ~ .(GIF|jpg|png|jpeg) {
      root /home;
  }
  ```

- `~*`：匹配正则表达式，**不区分**大小写。

  ```nginx
  location ~* \.(gif|png|bmp|jpg|jpeg) {
  	root /home;
  }
  ```

  上述示例中，只要访问的url中带有括号中的任一格式，都将在/home目录下，一层层检索，只要检索的路径（root + location）与请求路径相匹配，就能够请求成功。

  假如文件路径为：/home/wy/img/face.png，在上述配置中，正确的请求url是：host:port/wy/img/face.png

- `^~`：以某个字符路径开头。

  ```nginx
  location ^~ /wy/img {
  	root /home;
  }
  ```

  

###### root 和 alias 区别

假如服务器路径为：/home/wysrc/wy/files/img/face.png

- 当使用root时，location指定的路由必须是真实存在的目录，它将和root指定的路径共同组成访问的资源所在的目录位置。例如上述的 /wy，当请求路径/wy时，实际请求的目录位置是：/home/wysrc/wy，此时必须真实的存在/home/wysrc/wy目录，才能访问正常。

  ```nginx
  location /wy {
  	root /home/wysrc;
  }
  ```

  要想访问face.png，请求的链接必须是：host:port/wy/files/img/face.png。

- alias是直接为路由指定一个位置，当访问/smallz时，实际访问的就是alias指定的目录，和IIS一样。

  ```nginx
   location /smallz {
          alias /home/wysrc;
      }
  ```

  此时要想访问face.png，请求的链接必须是：host:port/smallz/wy/files/img/face.png。




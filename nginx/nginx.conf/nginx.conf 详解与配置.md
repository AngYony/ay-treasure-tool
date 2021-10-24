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

  

##### root 和 alias 区别

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




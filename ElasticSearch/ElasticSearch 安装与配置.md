# ElasticSearch 安装与配置

### 1、下载 ElasticSearch安装包

下载地址：https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.1.1-linux-x86_64.tar.gz 不同版本，只需要更改一下版本号即可下载。

### 2、解压并安装 ElasticSearch 压缩文件

```
tar -avxf elasticsearch-7.1.1-linux-x86_64.tar.gz -C /usr/local/
```

### 3、修改JVM环境配置项 - config/jvm.options

进入到安装后的 elasticsearch 目录，修改 config/jvm.options 文件：

```
vim ./config/jvm.options
```

配置建议：

Xmx 和 Xms 设置成一样，并且不要超过机器内存的50%，且最大不要超过30G

```
Xms2g
Xmx2g
```

### 4、授权给普通用户，以非 root 身份运行 elasticsearch：

```
[VM_AngYony@localhost elasticsearch-7.1.1]$ bin/elasticsearch
```

此时会提示用户权限相关的错误，elasticsearch不允许使用root权限，因此需要将目录的权限授权给普通用户。

```
sudo chown VM_AngYony /usr/local/elasticsearch-7.1.1/ -R
```

授权之后，以普通用户身份再次运行 elasticsearch：

```
bin/elasticsearch
```

执行完成之后，在主机浏览器中输入“localhost:9200”，可看到如下响应，表名 elasticsearch 正常启动：

![image-20201022115743478](assets/image-20201022115743478.png)

### 5、插件的安装

查看已安装的插件：

```
bin/elasticsearch-plugin list
```

安装插件：

```
bin/elasticsearch-plugin install analysis-icu
```

analysis-icu 是一个分词插件。

### 6、实例的运行

运行单个 Elasticsearch 实例：

```
bin/elasticsearch -E node.name=node1 -E cluster.name=geektime -E path.data=node1_data -d
```

运行多个 Elasticsearch 实例：

```
bin/elasticsearch -E node.name=node1 -E cluster.name=geektime -E path.data=node1_data -d
bin/elasticsearch -E node.name=node2 -E cluster.name=geektime -E path.data=node2_data -d
bin/elasticsearch -E node.name=node3 -E cluster.name=geektime -E path.data=node3_data -d
```

注意：不同实例节点的cluster.name应该指向同一个name。

### 7、删除进程

```
ps | grep elasticsearch
kill -9 9937
```


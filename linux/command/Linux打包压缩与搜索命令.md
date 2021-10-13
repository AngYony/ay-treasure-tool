# Linux打包压缩与搜索命令

- tar命令
- grep命令
- find命令



------



#### tar命令

`tar`命令用于对文件进行打包压缩或解压。

格式：

```
tar [选项] [文件]
```

说明：

在Linux系统中，常见的压缩文件格式主要有：`.tar`、`.tar.gz`、`.tar.bz2`格式。这些格式都可以由`tar`命令来生成。

`tar`命令的参数及其作用：

- `-c`：创建压缩文件
- `-x `：解开压缩文件
- `-t`：查看压缩包内有哪些文件
- `-z`：用`Gzip`压缩或解压
- `-j`：用`bzip2`压缩或解压
- `-v`：显示压缩或解压的过程，对于大文件的压缩很有用，会显示压缩状态。
- `-f`：目标文件名，**该参数必须放在所有参数的最后一位**，代表要压缩或解压的软件包名称。
- `-p`：保留原始的权限与属性
- `-P`：使用绝对路径来压缩
- `-C`：指定解压到的目录

上述的参数可以组合使用，推荐组合如下：

把指定的文件进行打包压缩：`tar -czvf 压缩包名称.tar.gz 要打包的目录`

对应的解压命令：`tar -xzvf 压缩包名称.tar.gz`

示例一，使用`tar`命令把`/etc`目录通过`gzip`格式进行打包压缩，并把文件命名为`etc.tar.gz`：

```shell
[root@Linuxprobe ~]# tar -czvf etc.tar.gz /etc
tar: Removing leading `/' from member names
/etc/
/etc/fstab
/etc/crypttab
/etc/mtab
...
```

示例二，将打包后的压缩包文件指定解压到`/root/etc`目录中（先使用`mkdir`命令来创建`/root/etc`目录）：

```shell
[root@Linuxprobe ~]# mkdir /root/etc
[root@Linuxprobe ~]# tar xzvf etc.tar.gz -C /root/etc
etc/
etc/fstab
etc/crypttab
etc/mtab
....
```



------



#### find命令

`find`命令用于按照指定条件来查找文件。

格式：

```
find [查找路径] 寻找条件 操作
```

说明：

在Linux系统中，搜索工作一般都是通过`find`命令来完成的，它可以使用不同的文件特性作为寻找条件（如文件名、大小、修改时间、权限等信息），一旦匹配成功则默认将信息显示到屏幕上。

`find`命令的参数以及作用如下：

- `-name`：匹配名称
- `-perm`：匹配权限（`mode`为完全匹配，`-mode`为包含即可）
- `-user`：匹配所有者
- `-group`：匹配所有组
- `-mtime -n +n`：匹配修改内容的时间（`-n`指`n`天以内，`+n`指`n`天以前）
- `-atime -n +n`：匹配访问文件的时间（`-n`指`n`天以内，`+n`指`n`天以前）
- `-ctime -n +n`：匹配修改文件权限的时间（`-n`指`n`天以内，`+n`指`n`天以前）
- `-nouser`：匹配无所有者的文件
- `-nogroup`：匹配无所有组的文件
- `-newer f1 !f2`：匹配比文件`f1`新但比`f2`旧的文件
- `--type b/d/c/p/l/f`：匹配文件类型（后面的字幕字母依次表示块设备、目录、字符设备、管道、链接文件、文本文件）
- `-size`：匹配文件的大小（`+50KB`为查找超过`50KB`的文件，而`-50KB`为查找小于`50KB`的文件）
- `-prune`：忽略某个目录
- `-exec …… {}\;`：后面可跟用于进一步处理搜索结果的命令。该参数用于把`find`命令搜索到的结果交由紧随其后的命令作进一步处理，类似于管道符技术，并且由于`find`命令对参数的特殊要求，因此虽然`exec`是长格式形式，但依然只需要一个减号（`-`）。

示例一，获取`/etc`目录中所有以`host`开头的文件列表：

```shell
[root@Linuxprobe ~]# find /etc -name "host*" -print
/etc/avahi/hosts
/etc/host.conf
/etc/hosts
/etc/hosts.allow
/etc/hosts.deny
/etc/selinux/targeted/modules/active/modules/hostname.pp
/etc/hostname
[root@Linuxprobe ~]# 
```

示例二，在整个系统中搜索权限中包括SUID权限的所有文件（只需使用`-4000`即可）：

```shell
[root@Linuxprobe ~]# find / -perm -4000 -print
find: ‘/proc/6147/task/6147/fd/6’: No such file or directory
find: ‘/proc/6147/task/6147/fdinfo/6’: No such file or directory
find: ‘/proc/6147/fd/6’: No such file or directory
find: ‘/proc/6147/fdinfo/6’: No such file or directory
/root/桌面/vmware-tools-distrib/lib/bin64/vmware-user-suid-wrapper
/root/桌面/vmware-tools-distrib/lib/bin32/vmware-user-suid-wrapper
/usr/bin/fusermount
...
```

示例三，在整个文件系统中找出所有归属于`linuxprobe`用户的文件并复制到`/root/findresults`目录：

该命令的重点是“`-exec {}   \;`”参数，其中的`{}`表示`find`命令搜索出的每一个文件，并且命令的结尾必须是“`\;`”。完成该实验的具体命令如下：

```shell
[root@linuxprobe ~]# find / -user linuxprobe -exec cp -a {} /root/findresults/ \;
```





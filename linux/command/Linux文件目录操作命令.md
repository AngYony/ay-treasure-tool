# Linux文件目录操作命令

工作目录切换命令

- pwd命令
- cd命令
- ls命令

文件目录管理命令

- touch命令
- mkdir命令
- cp命令
- mv命令
- rm命令
- dd命令
- file命令



------



#### pwd命令

`pwd`命令用于显示用户当前所处的工作目录。

格式：

```
pwd [选项]
```

示例：

```shell
[root@Linuxprobe 桌面]# pwd
/root/桌面
```



------



#### cd命令

`cd`命令用于切换当前的操作目录。

格式：

```
cd [目录名称]
```

说明：

通过`cd`命令可以迅速、灵活地切换到不同的工作目录。除了指定具体的目录名称外，还可以使用下述几种形式，快速的切换目录。

- `cd -`：返回到上一次所处的目录。
- `cd ..`：进入到上级目录。
- `cd ~`：切换到当前用户的家目录。
- `cd ~username `：切换到其他用户的家目录。

示例一，切换到`/bin`目录下：

```shell
[root@Linuxprobe etc]# cd /bin
[root@Linuxprobe bin]# 
```

示例二，返回到上一次的目录：

```shell
[root@Linuxprobe bin]# cd -
/etc
```

示例三，切换到当前用户的家目录：

```shell
[root@Linuxprobe etc]# cd ~
[root@Linuxprobe ~]# 
```



------



#### ls命令

`ls`命令用于显示目录中的文件信息。

格式：

```
ls [选项] [文件或目录]
```

说明：

`ls`命令可以输出当前目录下的所有文件信息，包括隐藏文件。常用的选项有以下几种。

- `-a`：查看全部文件，包括隐藏文件。
- `-l`：查看文件的属性、大小等详细信息。
- `-d`：查看目录属性信息。
- `-r`：逆序宣誓
- `-t`：按照时间顺序显示
- `-R`：递归显示

可以将上述选项组合使用。

示例一，使用`ls -al`命令查看当前目录中的所有文件并输出这些文件的属性信息：

```shell
[root@Linuxprobe ~]# ls -al
total 56
dr-xr-x---. 14 root root 4096 Aug 14 14:49 .
drwxr-xr-x. 17 root root 4096 Aug 14  2018 ..
-rw-------.  1 root root 1029 Jul 18 00:21 anaconda-ks.cfg
-rw-------.  1 root root 1052 Jul 30 17:02 .bash_history
-rw-r--r--.  1 root root   18 Dec 29  2013 .bash_logout
-rw-r--r--.  1 root root  176 Dec 29  2013 .bash_profile
-rw-r--r--.  1 root root  176 Dec 29  2013 .bashrc
drwx------.  9 root root 4096 Jul 17 18:13 .cache
drwxr-xr-x. 15 root root 4096 Jul 17 18:13 .config
...
```

示例二，使用`ls -ld`查看/etc目录的权限与属性信息：

```shell
[root@Linuxprobe ~]# ls -ld /etc
drwxr-xr-x. 132 root root 8192 Aug 14 14:36 /etc
```



------



#### touch命令

`touch`命令用于创建空白文件或设置文件的时间。

格式：

```
touch [选项] [文件]
```

说明：

对于创建空白文件，使用`touch`命令比较简单，直接使用`touch 文件名`即可。

除了创建文件之外，它还可以设置以下几种情况的时间：

- 设置文件内容的修改时间（mtime） 
- 设置文件权限或属性的更改时间（ctime）
- 设置文件的读取时间（atime）

`touch`命令的参数和作用如下：

`-a`：仅修改“读取时间”（atime）

`-m`：仅修改“修改时间”（mtime）

`-d`：同时修改atime与mtime



示例，首先使用ls命令查看一下文件的修改时间，然后使用`touch`命令把修改后的文件时间设置成修改之前的时间：

```shell
[root@Linuxprobe 桌面]# cd ~
[root@Linuxprobe ~]# ls -l anaconda-ks.cfg 
-rw-------. 1 root root 1029 Jul 18 00:21 anaconda-ks.cfg
[root@Linuxprobe ~]# touch -d "2018-08-15 08:08" anaconda-ks.cfg 
[root@Linuxprobe ~]# ls -l anaconda-ks.cfg 
-rw-------. 1 root root 1029 Aug 15 08:08 anaconda-ks.cfg
```



------



#### mkdir命令

`mkdir`命令用于创建空白的目录（文件夹）。

格式：

```
mkdir [选项] 目录
```

说明：

除了能创建单个空白目录外，`mkdir`命令还可以结合`-p`参数来递归创建出具有嵌套叠层关系的文件目录。

示例，使用`mkdir -p`创建多层级目录：

```shell
[root@Linuxprobe ~]# mkdir smallz
[root@Linuxprobe ~]# cd smallz/
[root@Linuxprobe smallz]# mkdir -p a/b/c/d
[root@Linuxprobe smallz]# cd a
[root@Linuxprobe a]# cd b
[root@Linuxprobe b]# cd c
[root@Linuxprobe c]# 

```

示例，同时创建 a，b，c 多个目录：

```shell
[VM_AngYony@localhost studylinux]$ mkdir a b c
```



------



#### cp命令

`cp`命令用于复制文件或目录。

格式：

```
cp [选项] 源文件 目标文件
```

说明：

在Linux系统中，复制操作分为以下3中情况：

- 如果目标文件是目录，则会把源文件复制到该目录中；
- 如果目标文件也是普通文件，则会询问是否要覆盖它；

- 如果目标文件不存在，则执行正常的复制操作。

`cp`命令的参数及其作用如下：

- `-p`：保留原始文件的属性
- `-d`：若对象为“链接文件”，则保留该“链接文件”的属性
- `-r`：递归持续复制（用于目录）
- `-i`：若目标文件存在则询问是否覆盖
- `-a`：相当于`-pdr`（`p`、`d`、`r`为上述参数）



示例，使用`touch`创建一个新文件，接着使用`cp`命令复制为新的备份文件：

```shell
[root@Linuxprobe ~]# touch wy.log
[root@Linuxprobe ~]# cp wy.log wy.log.bak
[root@Linuxprobe ~]# ls
anaconda-ks.cfg       smallz  wy.log.bak  公共  文档  模板  音乐
initial-setup-ks.cfg  wy.log  下载        图片  桌面  视频
[root@Linuxprobe ~]# 
```



------



#### mv命令

`mv`命令用于剪切文件或将文件重命名。

格式：

```
mv [选项] 源文件 [目标路径|目标文件名]
```

说明：

剪切操作不同于复制操作，因为它会默认把源文件删除掉，只保留剪切后的文件。如果在同一个目录中对一个文件进行剪切操作，其实也就是对其进行重命名。

示例，使用`mv`命令实现重命名文件操作，将`wy.log`重命名为`linux.log`：

```shell
[root@Linuxprobe ~]# mv wy.log linux.log
[root@Linuxprobe ~]# ls
anaconda-ks.cfg       linux.log  wy.log.bak  公共  文档  模板  音乐
initial-setup-ks.cfg  smallz     下载        图片  桌面  视频

```



------



#### rm命令

`rm`命令用于删除文件或目录。

格式：

```
rm [选项] 文件
```

说明：

在Linux系统中删除文件时，系统会默认向您询问是否要执行删除操作，如果不想总是看到这种反复的确认信息，可在`rm`命令后跟上`-f`参数来强制删除。

另外，想要删除一个目录，需要在`rm`命令后面一个`-r`参数才可以，否则删除不掉。

示例，删除之前创建的文件和目录：

```shell
[root@Linuxprobe ~]# rm wy.log.bak
rm: remove regular empty file ‘wy.log.bak’? y
[root@Linuxprobe ~]# rm -f linux.log 
[root@Linuxprobe ~]# ls
anaconda-ks.cfg       smallz  公共  文档  模板  音乐
initial-setup-ks.cfg  下载    图片  桌面  视频
[root@Linuxprobe ~]# rm -r smallz
rm: descend into directory ‘smallz’? y
rm: descend into directory ‘smallz/a’? y
rm: descend into directory ‘smallz/a/b’? y
rm: descend into directory ‘smallz/a/b/c’? y
rm: remove directory ‘smallz/a/b/c/d’? y
rm: remove directory ‘smallz/a/b/c’? y
rm: remove directory ‘smallz/a/b’? y
rm: remove directory ‘smallz/a’? y
rm: remove directory ‘smallz’? y
[root@Linuxprobe ~]# ls
anaconda-ks.cfg       下载  图片  桌面  视频
initial-setup-ks.cfg  公共  文档  模板  音乐
```



------



#### dd命令

`dd`命令用于按照指定大小和个数的数据块来复制文件或转换文件。

格式：

```
dd [参数]
```

说明：

`dd`命令能够让用户按照指定大小和个数的数据块来复制文件的内容。还可以在复制过程中转换其中的数据。

`dd`命令的参数及其作用：

- `if`：输入的文件名称
- `of`：输出的文件名称
- `bs`：设置每个“块”的大小
- `count`：设置要复制“块”的个数

示例一，用`dd`命令从`/dev/zero`设备文件中取出一个大小为`560MB`的数据块，然后保存成名为`560_file`的文件：

```shell
[root@Linuxprobe ~]# dd if=/dev/zero of=560_file count=1 bs=560M
1+0 records in
1+0 records out
587202560 bytes (587 MB) copied, 2.59138 s, 227 MB/s
```

示例二，直接使用dd命令将文件压制出光盘镜像文件（ISO格式的镜像文件）：

```shell
[root@Linuxprobe ~]# dd if=560_file of=test.iso
1146880+0 records in
1146880+0 records out
587202560 bytes (587 MB) copied, 3.28271 s, 179 MB/s
[root@Linuxprobe ~]# ls
560_file         initial-setup-ks.cfg  下载  图片  桌面  视频
anaconda-ks.cfg  test.iso              公共  文档  模板  音乐
[root@Linuxprobe ~]# 
```



------



#### file命令

`file`命令用于查看文件的类型。

格式：

```
file 文件名
```

说明：

在Linux系统中，由于文本、目录、设备等所有这些一切都统称为文件，而我们又不能单凭后缀就知道具体的文件类型，这时就需要使用`file`命令来查看文件类型了。

示例：

```shell
[root@Linuxprobe ~]# file abc.txt
abc.txt: empty
[root@Linuxprobe ~]# file smallz
smallz: directory
```





------



#### 参考资源

- 《Linux就应该这么学》



本文后续会随着知识的积累不断补充和更新，内容如有错误，欢迎指正。

最后一次更新时间：2018-08-15

------


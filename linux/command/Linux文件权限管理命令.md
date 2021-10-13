# Linux 文件权限管理命令

[TOC]



### 文件类型的区分

| 字符 | 文件类型 | 字符 | 文件类型     |
| ---- | -------- | ---- | ------------ |
| `-`  | 普通文件 | b    | 块设备文件   |
| d    | 目录文件 | c    | 字符设备文件 |
| l    | 链接文件 | p    | 管道文件     |

### 权限介绍

| 权限   | 符   | 数   | 文件                                         | 目录                                   |
| ------ | ---- | ---- | -------------------------------------------- | -------------------------------------- |
| 可读   | r    | 4    | 表示能够读取文件的实际内容                   | 表示能够读取目录内的文件列表           |
| 可写   | w    | 2    | 表示能够编辑、新增、修改、删除文件的实际内容 | 表示能够在目录内新增、删除、重命名文件 |
| 可执行 | x    | 1    | 表示能够运行一个脚本程序                     | 表示能够进入该目录                     |

文件的读、写、执行权限可以简写为rwx，亦可分别用数字4、2、1来表示。

文件所有者，所属组及其他用户权限之间无关联，它们的表示方式如下图所示：

![qxz](assets/qxz.png)

#### 文件权限的数字法表示

文件权限的数字法表示基于字符表示（rwx）的权限计算而来，其目的是简化权限的表示。

若某个文件的权限为 **7** 则代表可读、可写、可执行（4+2+1）。

若权限为 **6** 则代表可读、可写（4+2）。

若权限为 **5** 则表示可读、可执行（4+1）。

若权限为 **4** 则表示==**只**==可读（对应可读权限本身：4）。

若权限为 **3** 则表示可写、可执行（2+1）。

若权限为 **2** 则表示==**只**==可写（对应可写权限本身：2）。

若权限为 **1** 则表示==**只**==可执行（对应可执行权限本身：1）。

如果一个文件的权限为：`rwxrw-r--`，使用数字法表示就是：764，表示的含义是：其所有者拥有可读、可写、可执行的权限，其文件所属组拥有可读、可写的权限；而且其他人只有可读的权限。

### 特殊权限：SUID、SGID 与 SBIT

SUID、SGID 与 SBIT 是一种对文件权限进行设置的特殊功能，可以与一般权限同时使用，以弥补一般权限不能实现的功能。

#### SUID

SUID 是一种对二进制程序进行设置的特殊权限，可以让二进制程序的执行者临时拥有属主（文件所有者，**U**）的权限（仅对拥有执行权限的二进制程序有效）。

一旦某个文件被赋予了 SUID 权限，那么该文件的**所有者权限**将会出现下述变化：

- 如果所有者的权限是 `rwx`，那么将变为 `rws`（小写s）。
- 如果所有者的权限是 `rw-`，那么将会变为`rwS`（大写S）。

例如，查看 /bin/passwd 文件的权限，可以看到文件所有者的权限为rw**s**：

```shell
[root@localhost ~]# ls -l /bin/passwd
-rwsr-xr-x. 1 root root 27856 8月   9 2019 /bin/passwd
[root@localhost ~]# 
```

SUID 可以让文件的执行者临时拥有该文件的所有者的权限。

#### SGID

SGID 的主要用途：

- 功能一：让文件的执行者临时拥有属组（文件所属组，**G**）的权限（对拥有执行权限的二进制程序进行设置）
- 功能二：在某个目录中创建的文件自动继承该目录的用户组（只可以对目录进行设置）

SGID的第一种功能是参考SUID而设计的，不同点在于执行程序的用户获取的不再是文件所有者的临时权限，而是获取到文件所属组的权限。并且SUID的权限变化体现在文件所有者部分（例如：-==rw**s**==r-xr-x），而SGID的权限变化体现在**文件所属组**部分（例如：-r-x==r-**s**==r-x）。

功能二一般多用于目录的权限设置，在某个目录上设置SGID特殊权限位后，那么任何人在该目录中创建的任何文件都会归属于该目录的所属组，而不再是自己的基本用户组。

例如，创建目录并指定权限为777：

```shell
[root@localhost ~]# cd /tmp
[root@localhost tmp]# mkdir testdir
[root@localhost tmp]# ls -ald testdir/
drwxr-xr-x. 2 root root 6 11月  4 16:36 testdir/
使用 chmod 命令赋予权限：
[root@localhost tmp]# chmod -Rf 777 testdir/
[root@localhost tmp]# ls -ald testdir/
drwxrwxrwx. 2 root root 6 11月  4 16:36 testdir/
```

此时目录的权限为 rwx==rwx==rwx，接着为目录设置SGID特殊权限：

```shell
[root@localhost tmp]# chmod -Rf g+s testdir/
[root@localhost tmp]# ls -ald testdir/
drwxrwsrwx. 2 root root 6 11月  4 16:36 testdir/
```

此时目录的权限变为了rwx==rw**s**==rwx，切换回普通用户，在该目录中创建文件，并查看创建的文件信息：

```shell
[root@localhost tmp]# su - VM_AngYony
[VM_AngYony@localhost ~]$ cd /tmp/testdir/
[VM_AngYony@localhost testdir]$ echo "hello" > test.hello
[VM_AngYony@localhost testdir]$ ls -al test.hello 
-rw-rw-r--. 1 VM_AngYony root 6 11月  4 16:47 test.hello
```

可以看到，新创建的文件会自动继承其所在的目录的所属组名称（此处所属组为root，而在不指定SGID的情况下，默认创建的文件的所属组名为用户名本身VM_AngYony）。

#### SBIT

SBIT特殊权限位可确保用户只能删除自己的文件，而不能删除其他用户的文件。换句话说，当对某个目录设置了SBIT粘滞位（也称为保护位）权限后，那么该目录中的文件就只能被其所有者执行删除操作了。

当目录被设置SBIT特殊权限位后，文件的**其他人权限**部分的x执行权限就会被替换成t或者T，原本有x执行权限则会写成t，原本没有x执行权限则会被写成T。

```shell
[VM_AngYony@localhost ~]$ ls -ald /tmp
drwxrwxrwt. 25 root root 4096 11月  5 10:40 /tmp
```

注意：文件能否被删除并不取决于自身的权限，而是看其所在目录是否有写入权限。

例如，上述的命令可以看到系统目录/tmp默认是设置了SBIT特殊权限位，此时在/tmp目录下创建一个最大权限为777（rwxrwxrwx）的文件：

```shell
[VM_AngYony@localhost ~]$ cd /tmp
[VM_AngYony@localhost tmp]$ echo "wy.txt" > wy.txt
[VM_AngYony@localhost tmp]$ chmod 777 wy.txt 
[VM_AngYony@localhost tmp]$ ls -al wy.txt
-rwxrwxrwx. 1 VM_AngYony VM_AngYony 7 11月  5 10:58 wy.txt
```

此时切换为其他普通用户，尝试删除该文件：

```shell
[VM_AngYony@localhost tmp]$ su - zhxy_user
[zhxy_user@localhost ~]$ cd /tmp
[zhxy_user@localhost tmp]$ rm -f wy.txt
rm: 无法删除"wy.txt": 不允许的操作
```

可以看到，即使文件的其他人权限部分为rwx，权限全开的情况下，由于SBIT特殊权限位的缘故，依然无法删除该文件。

#### SUID/SGID/SBIT 总结

|          | SUID                                            | SGID                                                         | SBIT                                                 |
| -------- | ----------------------------------------------- | ------------------------------------------------------------ | ---------------------------------------------------- |
| 主要用途 | 让执行者临时拥有文件所有者的权限                | 让执行者临时拥有文件所属组的权限，或在某个目录中创建的文件自动继承该目录的用户组 | 确保用户只能删除自己的文件，而不能删除其他用户的文件 |
| 权限范围 | 权限中的“文件所有者”部分                        | 权限中的“文件所属组”部分                                     | 权限中的“其他用户”部分                               |
| 表现形式 | 文件所有者的权限：`rwx`=>`rws`，或 `rw-`=>`rwS` | 文件所属组的权限：rwx=>rw**s**                               | 其他用户的权限：rwx=>rw**t**，或 `rw-`=>rw**T**      |
| chmod    |                                                 | `chmod -Rf g+s testdir/`                                     | `chmod -R o+t linux/`                                |

权限的表现形式始终体现在可读（r）可写（w）可执行（x）中的执行权限上，即最终变为s/S/t/T，都体现在执行权限所在的位置（最后一位）。

### 文件的隐藏权限（不可见的权限）

这里的隐藏不是指文件的隐藏，而是指一些被隐藏起来的权限。

Linux系统中的文件除了具备一般权限和特殊权限之外，还有一种隐藏权限，即被隐藏起来的权限，默认情况下不能直接被用户发觉。

可以使用chattr命令来设置隐藏的权限，关于该命令的介绍见下文。

### 文件访问控制列表（ACL）

通俗来讲，基于普通文件或目录设置ACL其实就是针对指定的用户或用户组设置文件或目录的操作权限。

另外，如果针对某个目录设置了ACL，则目录中的文件会继承其ACL；若针对文件设置了ACL，则文件不再继承其所在目录的ACL。

管理文件的ACL规则需要使用setfacl命令，关于该命令的介绍见下文。

例如，当使用普通用户进入到其他用户的家目录中时，会提示“权限不够”的信息。

```shell
[root@localhost ~]# su VM_AngYony
[VM_AngYony@localhost root]$ cd /root
bash: cd: /root: 权限不够
[VM_AngYony@localhost root]$ exit
exit
[root@localhost ~]# 
[root@localhost home]# su VM_AngYony
[VM_AngYony@localhost home]$ cd /home/zhxy_user/
bash: cd: /home/zhxy_user/: 权限不够
```

文件的ACL提供的是在所有者、所属组、其他人的读/写/执行权限之外的特殊权限控制，使用setfacl命令可以针对单一用户或用户组、单一文件或目录来进行读/写/执行权限的控制。

ACL的使用见setfacl命令部分的介绍。

### chmod

chmod 用来设置文件或目录的权限。

#### 格式

```
chmod [参数] 权限 文件或目录名称
```

#### 说明

针对目录进行操作时需要加上大写参数-R来表示递归操作，即对目录内所有的文件进行整体操作。

权限可以使用数字表示法。

#### 示例

示例一，如果要把一个文件的权限设置成其所有者可读可写可执行、所属组可读可写、其他人没有任何权限，则相应的字符法表示为rwxrw----，其对应的数字法表示为760：

```shell
[VM_AngYony@localhost testdir]$ chmod 760 test.hello 
[VM_AngYony@localhost testdir]$ ls -l test.hello 
-rwxrw----. 1 VM_AngYony root 6 11月  4 16:47 test.hello
```

示例二，在目录上设置SGID特殊权限位：

```
chmod -Rf g+s testdir/
```

示例三，在目录上设置SBIT特殊权限位：

```
chmod -R o+t linux/
```

### chown

chown 用于设置文件或目录的所有者和所属组。

#### 格式

```
chown [参数] 所有者:所属组 文件或目录名称
```

#### 说明

针对目录进行操作时需要加上大写参数-R来表示递归操作，即对目录内所有的文件进行整体操作。

#### 示例

示例，将test.hello文件的所有者指定为root，所属组指定为zhxy_group：

```shell
[root@localhost testdir]# chown root:zhxy_group test.hello 
[root@localhost testdir]# ll test.hello 
-rwxrw----. 1 root zhxy_group 6 11月  4 16:47 test.hello
```

### chattr

chattr命令用于设置文件的隐藏权限。

#### 格式

```
chattr [参数] 文件
```

#### 说明

如果想要把某个隐藏功能添加到文件上，则需要在命令后面追加“+参数”。

如果想要把某个隐藏功能移出文件，则需要追加“-参数”。

chattr命令中可供选择的隐藏权限参数及其作用：

| 参数 | 作用                                                         |
| ---- | ------------------------------------------------------------ |
| i    | 无法对文件进行修改；若对目录设置了该参数，则仅能修改其中的子文件内容而不能新建或删除文件 |
| a    | 仅允许补充（追加）内容，无法覆盖/删除内容（Append Only）     |
| S    | 大写S，文件内容在变更后立即同步到硬盘（sync）                |
| s    | 小写s，彻底从硬盘中删除，不可恢复（用0填充原文件所在硬盘区域） |
| A    | 不再修改这个文件或目录的最后访问时间（atime）                |
| b    | 不再修改文件或目录的存取时间                                 |
| D    | 检查压缩文件中的错误                                         |
| d    | 使用dump命令备份时忽略本文件/目录                            |
| c    | 默认将文件或目录进行压缩                                     |
| u    | 当删除该文件后依然保留其在硬盘中的数据，方便日后恢复         |
| t    | 让文件系统支持尾部合并（tail-merging）                       |
| x    | 可以直接访问压缩文件中的内容                                 |

#### 示例

先创建一个普通文件，然后执行删除操作：

```shell
[zhxy_user@localhost ~]$ su root
[root@localhost ~]# echo " for Test" > wy.txt
[root@localhost ~]# rm wy.txt 
rm：是否删除普通文件 "wy.txt"？y
```

操作成功，可以删除。然后再次创建一个普通文件，并为其设置不允许删除与覆盖（+a参数）权限，然后再尝试将这个文件删除：

```shell
[root@localhost ~]# echo "for Test2" > wy2.txt
[root@localhost ~]# chattr +a wy2.txt 
[root@localhost ~]# rm wy2.txt 
rm：是否删除普通文件 "wy2.txt"？y
rm: 无法删除"wy2.txt": 不允许的操作
```

此时即使使用root用户，依然无法删除该文件。

移除文件的隐藏权限（-a参数），再次删除：

```shell
[root@localhost ~]# chattr -a wy2.txt
[root@localhost ~]# rm wy2.txt 
rm：是否删除普通文件 "wy2.txt"？y
[root@localhost ~]# 
```

此时成功删除了该文件。

### lsattr

lsattr命令用于显示文件的隐藏权限。

#### 格式

```
lsattr [参数] 文件
```

#### 说明

在Linux系统中，文件的隐藏权限必须使用lsattr命令来查看，平时使用的ls之类的命令则无法查看出差异。

#### 示例

示例一，使用lsattr命令查看隐藏的权限信息：

```shell
[root@localhost ~]# lsattr wy.txt
--S--a---------- wy.txt
```

使用chattr命令移除隐藏的权限：

```shell
[root@localhost ~]# chattr -aS wy.txt
[root@localhost ~]# lsattr wy.txt
---------------- wy.txt
[root@localhost ~]# rm wy.txt
rm：是否删除普通文件 "wy.txt"？y
[root@localhost ~]# 
```

### setfacl

setfacl命令用于管理文件的ACL规则。

#### 格式

```
setfacl [参数] 文件名称
```

#### 说明

文件的ACL提供的是在所有者、所属组、其他人的读/写/执行权限之外的特殊权限控制，使用setfacl命令可以针对单一用户或用户组、单一文件或目录来进行读/写/执行权限的控制。

参数说明：

- -R：针对目录文件需要使用-R递归参数
- -m：针对普通文件则使用-m参数
- -b：如果想要删除某个文件的ACL，则可以使用-b参数

当文件设置了ACL后，常用的ls命令是看不到ACL表信息的，但是却可以看到文件的权限最后一个点（**.**）变成了加号（**+**）,这就意味着该文件已经设置了ACL了。

#### 示例

示例，为/root目录指定VM_AngYony用户权限：

```shell
[root@localhost home]# setfacl -Rm u:VM_AngYony:rwx /root
[root@localhost home]# su - VM_AngYony
[VM_AngYony@localhost ~]$ cd /root
[VM_AngYony@localhost root]$ ls
abc.txt ...
[VM_AngYony@localhost root]$ cat abc.txt
[VM_AngYony@localhost root]$ exit
登出
[root@localhost home]# ls -ld /root
dr-xrwx---+ 17 root root 4096 11月  5 12:07 /root
```

注意：设置了ACL后，最后的“.”变成了“+”。

### getfacl

getfacl命令用于显示文件上设置的ACL信息。

#### 格式

```
getfacl 文件名称
```

#### 说明

想要设置ACL，用的是setfacl命令；要想查看ACL，则用的是getfacl命令。

#### 示例

使用getfacl命令显示在root管理员家目录上设置的所有ACL信息：

```shell
[root@localhost home]# getfacl /root
getfacl: Removing leading '/' from absolute path names
# file: root
# owner: root
# group: root
user::r-x
user:VM_AngYony:rwx
group::r-x
mask::rwx
other::---

[root@localhost home]# 
```

### su

su命令可以解决切换用户身份的需求，使得当前用户在不退出登录的情况下，顺畅地切换到其他用户。

#### 格式

```
su [-] 用户名
```

#### 说明

su命令与用户名之间有一个减号（-），这意味着完全切换到新的用户，即把环境变量信息也变更为新用户的相应信息，而不是保留原始的信息。

强烈建议在切换用户身份时添加这个减号（-）。

#### 示例

```shell
[VM_AngYony@localhost ~]$ su - root
密码：
上一次登录：四 11月  5 15:54:17 CST 2020pts/0 上
[root@localhost ~]# 
```

尽管像上面这样使用su命令后，普通用户可以完全切换到root管理员身份来完成相应工作，但这将暴露root管理员的密码，从而增大了系统密码被黑客获取的几率；这并不是最安全的方案。所以推荐使用sudo命令。

### sudo

sudo命令用于给普通用户提供额外的权限来完成原本root管理员才能完成的任务。

#### 格式

```
sudo [参数] 命令名称
```

#### 说明

sudo命令中的可用参数以及作用：

| 参数             | 作用                                                   |
| ---------------- | ------------------------------------------------------ |
| -h               | 列出帮助信息                                           |
| -l               | 列出当前用户可执行的命令                               |
| -u 用户名或UID值 | 以指定的用户身份执行命令                               |
| -k               | 清空密码的有效时间，下次执行sudo时需要再次进行密码验证 |
| -b               | 在后台执行指定的命令                                   |
| -p               | 更改询问密码的提示语                                   |

sudo命令具有如下功能：

- 限制用户执行指定的命令
- 记录用户执行的每一条命令；
- 配置文件（/etc/sudoers）提供集中的用户管理、权限与主机等参数
- 验证密码的后5分钟内（默认值）无须再让用户再次验证密码。

可以使用sudo命令提供的visudo命令来配置用户权限，关于visudo命令的使用，见[链接](https://www.linuxprobe.com/chapter-05.html)说明。

在每次执行sudo命令后都会要求验证一下密码，如果要取消密码的验证，可以添加NOPASSWD参数，具体操作见[链接](https://www.linuxprobe.com/chapter-05.html)。
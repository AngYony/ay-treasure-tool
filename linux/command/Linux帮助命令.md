# Linux帮助命令

- man命令
- help命令
- info命令



------



#### man命令

`man`是manual的缩写。通常用于获取某个命令的使用说明。

格式：

```
man 命令
```

man命令可以看做是win中的F1功能，由于同一个名称在不同的场景下具有不同的用途，因此man命令针对不同的场景进行了章节区分，当输入某个命令时，确认其所属的章节后，可以通过`man [num] 命令`的形式获取相关的帮助。man命令共有9个章节，分别代表着不同的使用场景或类型。

例如，`passwd`命令是用户密码设置的命令，但在Linux系统中，存在一个`/etc/passwd`配置文件，如果只是使用`man passwd`命令，很难区分当前是要获取用户密码设置命令的帮助，还是要获取passwd文件的帮助，因此在使用的时候，可以添加数字进行章节（场景）区分。

获取用户密码设置命令passwd的相关帮助：

```shell
man 1 passwd  
```

如果要获取配置文件的帮助：

```
man 5 passwd
```

如果不知道是命令还是配置文件，可以使用`-a`参数。

```
man -a passwd
```



------



#### help命令

`help`可以获取帮助信息。

shell（命令解释器）自带的命令称为内部命令，其他命令称为外部命令。

判断是一个命令是否是内部命令，可以使用`type`命令查看，如下：

```shell
[root@localhost ~]# type cd
cd 是 shell 内嵌
[root@localhost ~]# type ls
ls 是 `ls --color=auto' 的别名
```

内部命令可以通过`help`命令获取帮助信息。

```
help 命令
```

外部命令使用`--help`选项获取帮助信息：

```
命令 --help
```

示例一，通过`help`命令查看`cd`（内部命令）的帮助信息：

```shell
[root@localhost ~]# help cd
cd: cd [-L|[-P [-e]]] [dir]
    Change the shell working directory.
    
    Change the current directory to DIR.  The default DIR is the value of the
    HOME shell variable.
...
```

示例二，通过`--help`选项查看`ls`（外部命令）的帮助信息：

```shell
[root@localhost ~]# ls --help
用法：ls [选项]... [文件]...
List information about the FILEs (the current directory by default).
Sort entries alphabetically if none of -cftuvSUX nor --sort is specified.
...
```



------



#### info命令

`info`命令是`help`命令的补充，可以显示更加具体的帮助信息。

格式：

```
info 命令
```


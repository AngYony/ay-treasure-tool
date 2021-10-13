# Linux环境变量

在Linux系统中，变量名称一般都是大写的。

可以使用env命令查看所有的环境变量和变量值。

```shell
[root@angyony ~]# env
XDG_SESSION_ID=3
HOSTNAME=angyony.linux.vm
SELINUX_ROLE_REQUESTED=
TERM=xterm
SHELL=/bin/bash
HISTSIZE=1000
SSH_CLIENT=10.112.25.39 3109 22
SELINUX_USE_CURRENT_RANGE=
...
```

也可以使用echo打印具体变量的值：

```shell
[root@angyony ~]# echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
```



## 系统环境变量

Linux中最重要的10个环境变量

| 变量名称     | 作用                             |
| ------------ | -------------------------------- |
| HOME         | 用户的主目录（即家目录）         |
| SHELL        | 用户在使用的Shell解释器名称      |
| HISTSIZE     | 输出的历史命令记录条数           |
| HISTFILESIZE | 保存的历史命令记录条数           |
| MAIL         | 邮件保存路径                     |
| LANG         | 系统语言、语系名称               |
| RANDOM       | 生成一个随机数字                 |
| PS1          | Bash解释器的提示符               |
| PATH         | 定义解释器搜索用户执行命令的路径 |
| EDITOR       | 用户默认的文本编辑器             |

注意：一个相同的变量会因为用户身份的不同而具有不同的值。例如HOME变量。



## 创建变量

变量是由固定的变量名与用户或系统设置的变量值两部分组成的。可以使用如下方式创建变量：

```
变量名=变量值
```

例如，创建环境变量AYWORK，变量值为某个目录，使用cd $AYWORK命令应用该变量。

```shell
[root@angyony angyony_vm]# AYWORK=/home/angyony_vm/ay_work/
[root@angyony angyony_vm]# cd $AYWORK
[root@angyony ay_work]# 
```

上述方式创建的变量不能被其他用户使用。可以使用export命令将其提升为全局变量，这样其他用户也可以使用它。

```shell
[angyony_vm@angyony root]$ WY=/home/angyony_vm/ay_work/
[angyony_vm@angyony root]$ export WY
[angyony_vm@angyony root]$ su root
密码：
[root@angyony ~]# echo $WY
/home/angyony_vm/ay_work/
```


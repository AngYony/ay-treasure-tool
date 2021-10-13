# Linux文本文件内容查看命令

- cat命令
- more命令
- head命令
- tail命令
- tr命令
- wc命令
- stat命令
- cut命令
- diff命令
- grep命令



------



#### cat命令

`cat`命令用于查看内容较少的纯文本文件。

格式：

```
cat [选项] 文件
```

说明：

Linux系统中有多个用于查看文本内容的命令，每个命令都有自己的特点，比如这个`cat`命令就是用于查看内容较少的纯文本文件的。如果想要显示行号的话，可以在`cat`命令后面追加一个-n参数。

示例，使用`cat`命令查看`initial-setup-ks.cfg`文件的内容：

```shell
[root@Linuxprobe ~]# cat -n initial-setup-ks.cfg
     1	#version=RHEL7
     2	# X Window System configuration information
     3	xconfig  --startxonboot
     4	
     5	# License agreement
     6	eula --agreed
     7	# System authorization information
     8	auth --enableshadow --passalgo=sha512
     9	# Use CDROM installation media
    10	cdrom
...
```

上述由于使用了`-n`选项，因此会显示行号信息。



------



#### more命令

`more`命令用于查看内容较多的纯文本文件。

格式：

```
more [选项] 文件
```

说明：

对于内容较多的文本文件，如果使用`cat`命令来阅读文本内容，信息就会在屏幕上快速翻滚，导致自己还没有来得及看到，内容就已经翻篇了。因此，对于内容较多或长篇的文本内容，推荐使用`more`命令进行查看。

`more`命令会在最下面使用百分比的形式来提示您已经阅读了多少内容。您还可以使用空格键或回车键向下翻页。

示例，使用`more`命令查看`initial-setup-ks.cfg`文件内容：

```shell
[root@Linuxprobe ~]# more initial-setup-ks.cfg
```

执行结果：

![more](images/more.jpg)



------



#### head命令

`head`命令用于查看纯文本文档的前N行。

格式：

```
head [选项] 文件
```

说明：

可以使用`head`命令只查看文本前几行的内容，一般用于快速预览想要知道文件中的内容操作。

示例，使用`head`命令查看`initial-setup-ks.cfg`文件中前`10`行的内容：

```shell
[root@Linuxprobe ~]# head -n 10 initial-setup-ks.cfg
#version=RHEL7
# X Window System configuration information
xconfig  --startxonboot

# License agreement
eula --agreed
# System authorization information
auth --enableshadow --passalgo=sha512
# Use CDROM installation media
cdrom
[root@Linuxprobe ~]# 
```



------



#### tail命令

`tail`命令用于查看纯文本文档的后`N`行或持续刷新内容。

格式：

```
tail [选项] 文件
```

说明：

`tail`命令不仅可以查看指定文件的最后几行内容，还可以实现持续刷新一个文件的内容（使用`-f`选项），尤其适用于实时查看最新的日志文件内容。`tail`命令更多的是关注文件末尾的内容，因此适用于实时写入的文件。

示例一，查看文本内容的最后`10`行内容：

```shell
[root@Linuxprobe ~]# head -n 10 initial-setup-ks.cfg
#version=RHEL7
# X Window System configuration information
xconfig  --startxonboot

# License agreement
eula --agreed
# System authorization information
auth --enableshadow --passalgo=sha512
# Use CDROM installation media
cdrom
[root@Linuxprobe ~]# tail -n 10 initial-setup-ks.cfg
@guest-agents
@guest-desktop-agents
@input-methods
@internet-browser
@multimedia
@print-client
@x11

%end

[root@Linuxprobe ~]# 

```

示例二，实时查看最新日志文件：

```shell
[root@Linuxprobe ~]# tail -f /var/log/messages
Aug 14 16:14:13 Linuxprobe dbus-daemon: dbus[1073]: [system] Activating via systemd: service name='net.reactivated.Fprint' unit='fprintd.service'
Aug 14 16:14:13 Linuxprobe dbus[1073]: [system] Activating via systemd: service name='net.reactivated.Fprint' unit='fprintd.service'
Aug 14 16:14:13 Linuxprobe systemd: Starting Fingerprint Authentication Daemon...
Aug 14 16:14:13 Linuxprobe dbus-daemon: dbus[1073]: [system] Successfully activated service 'net.reactivated.Fprint'
Aug 14 16:14:13 Linuxprobe dbus[1073]: [system] Successfully activated service 'net.reactivated.Fprint'
Aug 14 16:14:13 Linuxprobe systemd: Started Fingerprint Authentication Daemon.
Aug 14 16:14:13 Linuxprobe fprintd: Launching FprintObject
Aug 14 16:14:13 Linuxprobe fprintd: ** Message: D-Bus service launched with name: net.reactivated.Fprint
Aug 14 16:14:13 Linuxprobe fprintd: ** Message: entering main loop
Aug 14 16:14:43 Linuxprobe fprintd: ** Message: No devices in use, exit
```



------



#### tr命令

`tr`命令用于替换文本文件中的字符。

格式：

```
tr [原始字符] [目标字符]
```

说明：

`tr`命令可以实现文本内容的快速替换。可以先使用cat命令读取待处理的文本，然后通过管道符把这些文本内容传递给`tr`命令进行替换操作即可。

示例，把某个文本内容中的英文全部替换为大写：

```shell
[root@Linuxprobe ~]# cat anaconda-ks.cfg | tr [a-z] [A-Z]
```

上述示例中使用了管道符。

 

------



#### wc命令

`wc`命令用于统计指定文本的行数、字数、字节数。

格式：

```
wc [参数] 文本
```

说明：

Linux系统中的`wc`命令用于统计文本的行数、字数、字节数等。常用参数有以下几种：

- `-l`：只显示行数。
- `-w`：只显示单词数。
- `-c`：只显示字节数。

示例，使用`wc`命令利用`/etc/passwd`（该文件用于保存系统账户信息）文件，统计当前系统中有多少个用户：

```shell
[root@Linuxprobe 桌面]# wc -l /etc/passwd
38 /etc/passwd
```



------



#### stat命令

`stat`命令用于查看文件的具体存储信息和时间等信息。

格式：

```
stat 文件名称
```

说明：

`stat`命令可以用于查看文件的存储信息和时间等信息，使用该命令将会显示出文件的三种时间状态（已加粗）：`Access`、`Modify`、`Change`。

示例，使用stat命令显示`anaconda-ks.cfg`文件的存储信息和时间信息：

```shell
[root@Linuxprobe ~]# stat anaconda-ks.cfg
  File: ‘anaconda-ks.cfg’
  Size: 1029      	Blocks: 8          IO Block: 4096   regular file
Device: fd01h/64769d	Inode: 136255304   Links: 1
Access: (0600/-rw-------)  Uid: (    0/    root)   Gid: (    0/    root)
Context: system_u:object_r:admin_home_t:s0
Access: 2018-08-14 14:48:53.544064576 +0800
Modify: 2018-07-18 00:21:25.571947802 +0800
Change: 2018-07-18 00:21:25.571947802 +0800
 Birth: -
[root@Linuxprobe ~]# 
```



------



#### cut命令

`cut`命令用于按“列”提取文本字符。

格式：

```
cut [参数] 文本
```

说明：

使用`cut`命令可以基于“列”来搜索关键词。不仅要使用`-f`参数来设置需要看的列数，还需要使用`-d`参数来设置间隔符号。
注：`cut`有点类似字符串的切割。

示例：

```shell
[root@Linuxprobe ~]# cut -d: -f1 /etc/passwd
root
bin
daemon
adm
lp
sync
...
```



------



#### diff命令

`diff`命令用于比较多个文本文件的差异。

格式：

```
diff [参数] 文件
```

说明：

在使用`diff`命令时，不仅可以使用`--brief`参数来确认两个文件是否不同，还可以使用`-c`参数来详细比较出多个文件的差异之处。常用于判断文件是否被篡改。

示例一，使用`diff --brief`命令显示两个文件比较后的结果，判断文件是否相同：

```shell
[root@linuxprobe ~]# diff --brief diff_A.txt diff_B.txt
Files diff_A.txt and diff_B.txt differ
```

示例二，使用带有`-c`参数的`diff`命令来描述文件内容具体的不同：

```shell
[root@linuxprobe ~]# diff -c diff_A.txt diff_B.txt
```





------



#### grep命令

`grep`命令用于在文本中执行关键词搜索，并显示匹配的结果。

格式：

```
grep [选项] [文件]
```

说明：

`grep`命令是用途最广泛的文本搜索匹配工具，常用的参数及其作用如下所述：

- `-b`：将可执行文件(`binary`)当作文本文件（`text`）来搜索
- `-c`：仅显示找到的行数
- `-i`：忽略大小写
- `-n`：用来显示搜索到信息的行号
- `-v`：反向选择——仅列出没有“关键词”的行。

示例，使用`grep`命令来查找出当前系统中不允许登录系统的所有用户信息 （在Linux系统中，`/etc/passwd`文件是保存着所有的用户信息，而一旦用户的登录终端被设置成`/sbin/nologin`，则不再允许登录系统）：

```shell
[root@Linuxprobe ~]# grep /sbin/nologin /etc/passwd
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
adm:x:3:4:adm:/var/adm:/sbin/nologin
...
```


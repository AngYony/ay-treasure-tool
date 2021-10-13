# Linux管道符-通配符-转义符



## 管道符

Linux管道符：|

格式：命令A | 命令B | 命令C

作用：把前一个命令原本要输出到屏幕的标准正常数据当作是后一个命令的标准输入。

示例一，使用grep命令查找文件readme.txt中出现字符n的结果，并通过管道符统计结果的行数：

```shell
[angyony_vm@angyony s3_sample]$ grep n readme.txt 
nihao
.net core
[angyony_vm@angyony s3_sample]$ grep n readme.txt  | wc -l
2
```

示例二，使用ls -l命令查看目录/etc/下的文件列表，并通过管道符结合more命令分页显示：

```shell
[angyony_vm@angyony s3_sample]$ ls -l /etc/ |more
总用量 1372
drwxr-xr-x.  3 root root      101 8月   9 00:09 abrt
-rw-r--r--.  1 root root       16 8月   9 00:13 adjtime
-rw-r--r--.  1 root root     1518 6月   7 2013 aliases
...
```

示例三，通过把管道符和passwd命令的--stdin参数相结合，可以用一条命令来完成密码重置操作：

```shell
[root@angyony s3_sample]# echo "mypassword" | passwd --stdin root
```

上述语句尤其适用于编写自动化脚本的情况，可以避免输入两次密码进行确认。



## 通配符

通配符指的是通用的匹配信息的符号。常见的通配符有：

- `*`：匹配零个或多个字符。
- `?`：匹配单个字符。
- `[0-9]`：匹配0~9之间的单个数字的字符。
- [abc]：匹配a、b、c三个字符中的任意一个字符。注意：`[]`只能限制一个字符的匹配条件，多个字符需要使用多次`[]`通配符。（见示例四）



示例一，查看/dev目录中文件名以net开头的文件：

```shell
[root@angyony dev]# ls -l net*
crw-------. 1 root root 10, 60 8月  23 18:06 network_latency
crw-------. 1 root root 10, 59 8月  23 18:06 network_throughput

```

示例二，查看文件名以tty开头的，后面紧跟一个字符的文件：

```shell
[root@angyony dev]# ls tty?
tty0  tty1  tty2  tty3  tty4  tty5  tty6  tty7  tty8  tty9
```

示例三，查看文件名以tty开头，后面紧跟5~9之间的任一个数字的文件：

```
[root@angyony dev]# ls tty[5-9]
tty5  tty6  tty7  tty8  tty9
```

示例四，查看文件名以tty开头的，后面紧跟两个字符，第一个字符是2或3的，第二个字符是4、5、6三个中的一种的，满足这种匹配规则的文件：

```
[root@angyony dev]# ls tty[23][4-6]
tty24  tty25  tty26  tty34  tty35  tty36
```



## 转义符

转义字符用来处理输入的特殊数据，常见的转义字符如下：

- 反斜杠（\）：使反斜杠后面的一个变量变为单纯的字符串。
- 单引号（''）：转义其中所有的变量为单纯的字符串。
- 双引号（""）：保留其中的变量属性，不进行转义处理。
- 反引号（``）：把其中的命令执行后返回结果。



示例一，定义变量price=3，然后输出带有“`$`”符号的结果（理想结果为`price=$3`），未使用转移符时，输出如下：

```shell
[root@angyony dev]# price=3
[root@angyony dev]# echo "price=$price"
price=3
[root@angyony dev]# echo "price=$$price"
price=10947price
```

上述命令中，$$作用是显示当前程序的进程ID号码，并不能得到想要的结果，需要使用转义符"`\`"实现：

```shell
[root@angyony dev]# echo "price=\$$price"
price=$3
```

示例二，使用反引号（``）通配符，将命令的结果通过echo输出。

```shell
[root@angyony dev]# uname -a
Linux angyony.linux.vm 3.10.0-957.el7.x86_64 #1 SMP Thu Oct 4 20:48:51 UTC 2018 x86_64 x86_64 x86_64 GNU/Linux
[root@angyony dev]# echo `uname -a`
Linux angyony.linux.vm 3.10.0-957.el7.x86_64 #1 SMP Thu Oct 4 20:48:51 UTC 2018 x86_64 x86_64 x86_64 GNU/Linux
```




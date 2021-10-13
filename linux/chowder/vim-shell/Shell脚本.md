# Shell脚本

Shell脚本命令的工作方式有两种：交互式和批处理。

- 交互式（Interactive）：用户每输入一条命令就立即执行。

- 批处理（Batch）：由用户事先编写好一个完整的Shell脚本，Shell会一次性执行脚本中诸多的命令。



## 编写Shell脚本文件

使用vim创建shell脚本文件：

```shell
[angyony_vm@angyony s4_sample]$ vim example.sh
```

在文件中编写Shell脚本：

```shell
#! /bin/bash
#注释内容
pwd
ls -al
```

### Shell脚本格式说明

- 通常shell脚本文件以.sh作为文件后缀名。
- 第一行的脚本声明（`#!`）用来告诉系统使用哪种Shell解释器来执行该脚本。
- 第二行的注释信息（`#`）是对脚本功能和某些命令的介绍信息。

使用`bash`命令执行Shell脚本文件：

```shell
[angyony_vm@angyony s4_sample]$ bash example.sh 
/home/angyony_vm/ay_work/s4_sample
总用量 24
drwxrwxr-x. 2 angyony_vm angyony_vm    70 8月  26 22:12 .
drwxrwxr-x. 4 angyony_vm angyony_vm    40 8月  26 20:16 ..
-rw-rw-r--. 1 angyony_vm angyony_vm    23 8月  26 20:48 a.txt
-rw-rw-r--. 1 angyony_vm angyony_vm    38 8月  26 22:12 example.sh
-rw-rw-r--. 1 angyony_vm angyony_vm    61 8月  26 20:31 wy.txt
-rw-r--r--. 1 angyony_vm angyony_vm 12288 8月  26 20:24 .wy.txt.swo
```

也可以通过输入完整路径的方式来执行shell脚本文件。但默认会因为权限不足而提示报错信息，此时只需要为脚本文件增加执行权限即可。



## 接收用户的参数

为shell脚本传入参数值时，多个参数值之间使用空格间隔。例如：

```shell
[angyony_vm@angyony s4_sample]$ sh example.sh one two three four five six
```

上述命令为example.sh传入了6个参数值。

在shell脚本文件的内部，可以使用$符号对传入的参数值进行匹配。其中：

- `$0`：对应的是当前Shell脚本程序的名称。
- `$#`：对应的是总共有几个参数的数量。
- `$*`：对应的是所有位置的参数值。
- `$?`：对应的是显示上一次命令的执行返回值
- `$1`、`$2`、`$3`……：则分别对应着第N个位置的参数值。

example.sh文件中的shell脚本如下：

```shell
#! /bin/bash
#带有输入参数的shell脚本示例
echo "当前脚本名称为$0"
echo "总共有$#个参数，分别是$*。"
echo "第1个参数为$1，第5个参数为$5。"
```

运行该脚本，输出的内容如下所示：

```shell
[angyony_vm@angyony s4_sample]$ sh example.sh one two three four five six
当前脚本名称为example.sh
总共有6个参数，分别是one two three four five six。
第1个参数为one，第5个参数为five。
```



## 条件表达式

在Shell脚本中，==如果条件表达式成立则返回数字0==，否则返回其他随机数值。

条件表达式语句的语法格式如下：

```
[ 条件表达式 ]
```

注意：在`[]`中的开头和末尾各有一个空格。

例如，判断wy.txt是否存在，并使用`$?`得到返回的结果：

```shell
[angyony_vm@angyony s4_sample]$ [ -e wy.txt ]
[angyony_vm@angyony s4_sample]$ echo $?
0
```

按照判断对象来划分，可以分为以下4种不同的表达式语句：

- 文件测试语句
- 逻辑测试语句
- 整数值比较语句
- 字符串比较语句

### 文件测试语句

文件测试即使用指定条件来判断文件是否存在或权限是否满足等情况的运算符。

常用的操作符如下：

| 操作符 | 作用                       |
| ------ | -------------------------- |
| -d     | 测试文件是否为目录类型     |
| -e     | 测试文件是否存在           |
| -f     | 判断是否为一般文件         |
| -r     | 测试当前用户是否有权限读取 |
| -w     | 测试当前用户是否有权限写入 |
| -x     | 测试当前用户是否有权限执行 |

示例，判断文件是否是一般文件，如果返回值为0，则代表文件存在，且为一般文件：

```shell
[angyony_vm@angyony s4_sample]$ [ -f wy.txt ]
[angyony_vm@angyony s4_sample]$ echo $?
0
```

### 逻辑测试语句

| 操作符 | 作用                                           |
| ------ | ---------------------------------------------- |
| &&     | 当前面的命令执行成立后才会执行它后面的命令     |
| \|\|   | 当前面的命令执行不成立时，才会执行它后面的命令 |
| ！     | 把条件测试中的判断结果取相反值                 |

示例一，使用逻辑运算符`&&`，实现只有文件存在时，才输出指定的内容：

```
[angyony_vm@angyony s4_sample]$ [ -e wy.txt ] && echo "存在"
存在
```

上述示例中，只有文件wy.txt真实存在时，才会输出“存在”字样。

示例二，使用逻辑运算符||，实现如果当前用户不是root，就输出指定的内容：

```shell
[angyony_vm@angyony s4_sample]$ [ $USER = root ] || echo "不是root"
不是root
```

上述示例中，如果当前用户不是root，就会输出“不是toot”的字样。注意：`$USER = root`中，“`=`”的前后都必须要有一个空格。

示例三，使用逻辑运算符`!`，实现条件的结果取相反值。

```shell
[root@angyony ~]# [ $USER != root ] || echo "是root"
是root
```

上述示例中，如果`[ $USER != root ]`的条件不成立，就会输出“是root”的字样。

示例四，同时使用多个逻辑运算符，实现如果当前用户不是root，就输出“user”字样，否则输出“root”字样。

```shell
[root@angyony ~]# [ $USER != root ] && echo "user" || echo "root"
root
[root@angyony ~]# su angyony_vm
[angyony_vm@angyony root]$ [ $USER != root ] && echo "user" || echo "root"
user
```

### 整数值比较语句

整数比较运算符仅是对数字的操作，不能将数字与字符串、文件等内容一起操作。

不能直接使用等号、大于号、小于号等来判断。因为等号与赋值命令符冲突，大于号和小于号分别与输出重定向命令符和输入重定向命令符冲突。

可用的整数比较运算符如下所示：

| 操作符 | 作用           |
| ------ | -------------- |
| -eq    | 是否等于       |
| -ne    | 是否不等于     |
| -gt    | 是否大于       |
| -lt    | 是否小于       |
| -le    | 是否等于或小于 |
| -ge    | 是否大于或等于 |

示例一，10是否大于10，表达式不成立；10是否等于10，表达式成立，返回0：

```shell
[root@angyony ay_work]# [ 10 -gt 10 ]
[root@angyony ay_work]# echo $?
1
[root@angyony ay_work]# [ 10 -eq 10 ]
[root@angyony ay_work]# echo $?
0
```

示例二，先使用`free -m`命令查看内存使用量情况（单位为MB）；再通过`grep Mem:`命令筛选出剩余内存量的行；再用`awk '{print $4}'`命令只保留第四列；最后用反引号的形式将语句内执行的结果赋值给变量。

```powershell
[root@angyony ay_work]# free -m
              total        used        free      shared  buff/cache   available
Mem:           3722         534        2762          12         425        2882
Swap:          3967           0        3967
[root@angyony ay_work]# free -m | grep Mem:
Mem:           3722         534        2762          12         425        2882
[root@angyony ay_work]# free -m | grep Mem: | awk '{print $4}'
2762
[root@angyony ay_work]# FreeMem=`free -m | grep Mem: | awk '{print $4}'`
[root@angyony ay_work]# echo $FreeMem
2764
```

示例三，在上述示例的基础上，如果内存可用量的值小于1024M，就提示“内存不足”，否则提示“内存不足”：

```shell
[root@angyony ay_work]# [ $FreeMem -lt 1024 ] && echo "内存不足" || echo “内存充足”
“内存充足”
```

### 字符串比较语句

字符串比较语句用于判断测试字符串是否为空值，或两个字符串是否相同。它经常用来判断某个变量是否未被定义（即内容为空值）。

常见的字符串比较运算符：

| 操作符 | 作用                   |
| ------ | ---------------------- |
| =      | 比较字符串内容是否相同 |
| !=     | 比较字符串内容是否不同 |
| -z     | 判断字符串内容是否为空 |

示例一，通过判断String变量是否为空值，进而判断是否定义了这个变量：

```shell
[root@angyony ay_work]# [ -z $String ]
[root@angyony ay_work]# echo $?
0
[root@angyony ay_work]# echo $String

[root@angyony ay_work]# 
```

示例二，判断变量的值是否和指定字符串相同：

```shell
[root@angyony ay_work]# echo $LANG
zh_CN.UTF-8
[root@angyony ay_work]# [ $LANG != "zh_CN.UTF-8" ] && echo "不是中文" || echo "是中文"
是中文
```



## 流程控制语句

### if...then...fi

单分支语法格式：

```
if 条件测试操作
	then 命令序列
fi
```

示例，判断目录是否存在，如果不存在就创建这个目录：

```shell
[root@angyony s4_sample]# pwd
/home/angyony_vm/ay_work/s4_sample
[root@angyony s4_sample]# vim ifthenfi.sh
#! /bin/bash
DIR="/home/angyony_vm/ay_work/s4_sample/test"
if [ ! -e $DIR ]
then
mkdir -p $DIR
fi
```

写好shell脚本之后，执行该脚本，并查看是否创建了文件目录：

```shell
[root@angyony s4_sample]# bash ifthenfi.sh 
[root@angyony s4_sample]# ls
a.txt  example.sh  ifthenfi.sh  test  wy.txt
```

### if...then...else...fi

双分支语法格式：

```
if 条件测试操作
	then 命令序列1
	else 命令序列2
fi
```

示例，使用`ping`命令判断主机是否在线，`ping`命令的用法示例如下：

```shell
[root@localhost VM_AngYony]# vim chkhost.sh
ping -c 3 -i 0.2 -W 3 $1 &> /dev/null
if [ $? -eq 0 ]
then
echo "Host $1 is On-line."
else
echo "Host $1 is Off-line."
fi
```

执行上述的shell文件，输出如下内容：

```shell
[root@localhost VM_AngYony]# bash chkhost.sh 192.168.10.10
Host 192.168.10.10 is Off-line.
```

### if...then...elif...then...else...fi

多分支语法结构：

```
if 条件测试操作1
	then 命令序列1
elif 条件测试操作2
	then 命令序列2
else
	命令序列3
fi
```

示例，使用多分支`if`语句判断输入的分数在哪个成绩区间内。

说明：读取用户输入的信息需要使用`read`命令，它能够把接收到的用户输入信息赋值给后面的指定变量，其`-p`参数用于向用户显示一定的提示信息。

```shell
[root@localhost VM_AngYony]# vim chkscore.sh
read -p "Enter your score（0-100）：" GRADE
if [ $GRADE -ge 85 ] && [ $GRADE -le 100 ] ; then
echo "$GRADE is Excellent"
elif [ $GRADE -ge 70 ] && [ $GRADE -le 84 ] ; then
echo "$GRADE is Pass"
else
echo "$GRADE is Fail" 
fi
```

执行上述sh文件，显示信息如下：

```shell
[root@localhost VM_AngYony]# bash chkscore.sh 
Enter your score（0-100）：67
67 is Fail
```

### for...in...do...done

for循环语句允许脚本一次性读取多个信息，然后逐一对信息进行操作处理。

for循环语句结构：

```
for 变量名 in 取值列表
do
	命令序列
done
```

示例，使用for循环语句读取文件中的内容：

```shell
for zm in `cat zimu.txt`
do
  echo $zm
done
```

执行该sh文件，显示信息如下：

```shell
[root@localhost ~]# bash example.sh 
AAA
BBB
CCC
DDD
```

补充：

```shell
`cat zimu.txt` 
等同于：
$(cat zimu.txt)
```

### while

while循环语句通过判断条件测试的真假来决定是否继续执行命令，若条件为真就继续执行，为假就结束循环。

while语句格式：

```shell
while 条件测试操作
do
	命令序列
	exit 0
done
```

示例 ，随机返回一个1000以内的数字，通过用户输入的数字猜测数值大小。

返回一个随机数，可以使用下述命令：

```shell
[root@localhost ~]# expr $RANDOM
8489
```

随机数的范围是0~32767，如果需要随机到1000以内，可以`%1000`即可。完整shell脚本如下：

```shell
[root@localhost ~]# vim guess.sh 
#
PRICE=$(expr $RANDOM % 1000)
TIMES=0
echo "商品实际价格为0-999之间，猜猜看是多少？"
while true
do
  read -p "请输入您猜测的价格数目：" INT
  let TIMES++
if [ $INT -eq $PRICE ] ; then
  echo "恭喜您答对了，实际价格是 $PRICE"
  echo "您总共猜测了 $TIMES 次"
  exit 0
elif [ $INT -gt $PRICE ] ; then
  echo "太高了！"
else
  echo "太低了！"
fi
done
```

上述脚本中，使用exit 0命令，终止脚本的执行。

执行上述脚本，显示信息如下：

```shell
[root@localhost ~]# bash guess.sh
商品实际价格为0-999之间，猜猜看是多少？
请输入您猜测的价格数目：500
太高了！
请输入您猜测的价格数目：400
太高了！
请输入您猜测的价格数目：300
太高了！
请输入您猜测的价格数目：200
太低了！
请输入您猜测的价格数目：250
太高了！
请输入您猜测的价格数目：230
恭喜您答对了，实际价格是 230
您总共猜测了 6 次
```

### case...in...esac

case语句类似于C语言中的switch语句，case语句是在多个范围内匹配数据，若匹配成功则执行相关命令并结束整个条件测试；而如果数据不在所列出的范围内，则会去执行星号（`*`）中所定义的默认命令。

case语句格式：

```shell
case 变量值 in
模式1)
	命令序列1
	;;
模式2)
	命令序列2
	;;
*)
	默认命令序列
esac
```

示例，检测用户输入的是数字、还是字母：

```shell
read -p "请输入一个字符，并按Enter键确认：" KEY
case "$KEY" in
[a-z]|[A-Z])
  echo "您输入的是 字母。"
  ;;
[0-9])
  echo "您输入的是 数字。"
  ;;
*)
  echo "您输入的是 空格、功能键或其他控制字符。"
esac
```

执行上述shell文件，显示信息如下：

```shell
[root@localhost ~]# bash checkkeys.sh 
请输入一个字符，并按Enter键确认：a
您输入的是 字母。
[root@localhost ~]# bash checkkeys.sh 
请输入一个字符，并按Enter键确认：3
您输入的是 数字。
```








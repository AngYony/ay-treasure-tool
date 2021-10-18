# pip的安装与使用以及常用python包汇集

`pip`是一个负责为你下载并安装python包的程序。

#### 检查是否安装了pip

大多数较新的Python版本都自带`pip`，可以使用下述命令检查系统是否已经安装了`pip`。在Python3中，`pip`有时也被称为`pip3`。

在Linux和OS X系统中检查是否安装了`pip`：

```shell
octocean@octocean-virtual-machine:~$ python --version
Python 2.7.11+
octocean@octocean-virtual-machine:~$ pip --version
程序“pip”尚未安装。 您可以使用以下命令安装：
sudo apt install python-pip
octocean@octocean-virtual-machine:~$ pip3 --version
程序“pip3”尚未安装。 您可以使用以下命令安装：
sudo apt install python3-pip
octocean@octocean-virtual-machine:~$ 
```

在Windows系统中检查是否安装了`pip`：

```powershell
C:\Users\SmallZ>python -m pip --version
pip 18.0 from D:\Program Files (x86)\Python36-32\lib\site-packages\pip (python 3
.6)
```

#### 安装pip

安装`pip`可参考官方链接：https://pip.pypa.io/en/stable/installing/

首先需要下载`get-pip.py`脚本文件，接着以管理员的身份使用python命令执行该文件即可。

在Linux和OS X系统中安装`pip`：

```shell
sudo python get-pip.py
```

在windows系统中安装`pip`：

```
python get-pip.py
```

上述命令中，如果需要使用python3，将命令中的python换成python3即可。

安装完后，可以执行命令查看`pip`的版本以确认安装。



## 常用Python包

#### pygame

使用pygame可以用于管理图形、动画、声音等。可以开发复杂的游戏。



#### matplotlib

它是一个数学绘图库，可以使用它来制作简单的图表，如折线图和散点图等。



#### pygal

专注于生成适合在数字设备上显示的图表。通过使用Pygal，可在用户与图表交互时突出元素以及调整其大小，还可以轻松地调整整个图表的尺寸，使其适合在微型智能手表或巨型显示器上显示。可以使用pygal包来生成可缩放的矢量图形文件。



#### csv(内置模块)

用于处理CSV格式文件数据。



#### datetime（内置模块）

用于处理日期相关的格式化。例如，字符串转换为日期，按照指定格式输出日期等。



#### json（内置模块）

用于处理json格式文件数据



#### pygal-maps-world

用于处理地理政治数据，例如标准化国别码集。



#### requests

用于处理Web请求和返回的响应信息。



#### operator

用于列表元素操作，比如合并、查找、添加、搜索元素等。

------



#### 参考资源

- 《Python编程：从入门到实践》

 

本文后续会随着知识的积累不断补充和更新，内容如有错误，欢迎指正。

最后一次更新时间：2018-08-31

------




























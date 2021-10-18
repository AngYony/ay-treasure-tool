# Python生成数据图表

数据可视化：通过可视化表示来探索数据，它与数据挖掘紧密相关。

数据挖掘：使用代码来探索数据集的规律和关联。



## matplotlib

`matplotlib`是一个数学绘图库，可以使用它制作简单的图表，如折线图和散点图等。

#### 使用plot()绘制简单的折线图

下面是一个简单的示例，使用`plot()`绘制折线图，具体说明和用法见代码中的注释描述：

```python
import matplotlib.pyplot as plt

input_values=[1,2,3,4,5]

#创建一个列表，存储的值来自于对应下标的平方数
squares=[1,4,9,16,25]

# 绘制图形，并设置线条宽度
plt.plot(input_values,squares,linewidth=5)

#设置图表标题
plt.title("Square Numbers",fontsize=24)
# 为X轴设置标题和字体大小
plt.xlabel("Value",fontsize=14)
# 为Y轴设置标题和字体大小
plt.ylabel("Square of Value",fontsize=14)

# 设置刻度标记的大小
plt.tick_params(axis='both',labelsize=14)

#打开matplotlib查看器，并显示绘制的图形
plt.show()
```

#### 使用scatter()绘制散点图

完整代码如下：

```python
import matplotlib.pyplot as plt

# 创建包含1-1000的列表
x_values=list(range(1,1001))
# 使用列表解析根据x生成y的值对应的列表
y_values=[x**2 for x in x_values]

# 绘制单个点，设置点使用的尺寸
# edgecolors='none'用于消除点的黑色轮廓
# c='red'设置数据点为红色，也可以使用RGB表示法：c=(0,0,0.8)，包含三个0~1之间的小数值，分别表示红色、绿色和蓝色分量。值越接近0，指定的颜色越深，值越接近1，指定的颜色越浅
plt.scatter(x_values,y_values,c=(0.5,0.5,0.8),edgecolors='none',s=40)

## 使用颜色渐变
#plt.scatter(x_values,y_values,c=y_values,cmap=plt.cm.Blues,edgecolors='none',s=40)

#设置图表标题并给坐标轴加上标签
plt.title("Square numbers",fontsize=24)
plt.xlabel("Value",fontsize=14)
plt.ylabel("Square of Value",fontsize=14)

#设置刻度标记的大小
plt.tick_params(axis='obth',which='major',lobelsize=14)

#设置每个坐标轴的取值范围，四个值分别对应x和y坐标轴的最小值和最大值
#x坐标轴的取值范围设置为0~1100，y轴取值范围设置为0~1100000
plt.axis([0,1100,0,1100000])
plt.show()

##自动保存图表
#plt.savefig('squares_plot.png',bbox_inches='tight')
```

由于`x_values`是一个连续的数字列表，数据点的尺寸设置为`s=40`，因此执行完结果之后，将会看到一条连续的线条。

上述代码中，最重要的是`scatter()`方法，它可以传入许多的参数，不同参数代表着不同功能。

###### 删除数据点的轮廓

数据点默认是蓝色点和黑色轮廓。大量的数据点会使黑色轮廓连在一起，可以在调用`scatter()`方法时，传入实参`edgecolors='none'`。

###### 自定义颜色

可以向`scatter()`传递参数`c`，`c`的值可以是颜色的名称也可以是一个RGB颜色模式的元组，例如：

- `c='red'`：设置数据点为红色。
- `c=(0.5,0.5,0.8)`：使用RGB颜色模式来设置数据点的颜色。它是一个包含三个`0~1`之间的小数值组成的元组，分别表示红色、绿色和蓝色所占分量。值越接近`0`，指定的颜色越深，值越接近`1`，指定的颜色越浅。

###### 使用颜色渐变

```python
# 使用颜色渐变
plt.scatter(x_values,y_values,c=y_values,cmap=plt.cm.Blues,edgecolors='none',s=40)
```

该代码演示了如何根据每个点的y值来设置其颜色。这里将参数`c`设置成了一个`y`值列表，并使用参数`cmap`告诉`pyplot`使用哪个颜色映射。这些代码将`y`值较小的点显示为浅蓝色，并将`y`值较大的点显示为深蓝色。

###### 自动保存图表

要让程序自动将图表保存到文件中，可将对`plt.show()`的调用替换为对`plt.savefig()`的调用：

```python
#自动保存图表
plt.savefig('squares_plot.png',bbox_inches='tight')
```

第一个实参指定要以什么样的文件名保存图表，这个文件将存储到`scatter_squares.py`所在的目录中；第二个实参指定将图表多余的空白区域裁剪掉。如果要保留图表周围多余的空白区域，可省略这个实参。

#### 综合示例

本示例来自于《Python编程从入门到实践》一书中的“随机漫步”相关章节，关于“随机漫步”请参见书中表述，这里只对代码进行概述。

###### 创建RandomWalk()类

random_walk.py：

```python
from random import choice

class RandomWalk():
    """一个生成随机漫步数据的类"""
    #将默认点数设置为5000
    def __init__(self, num_points=5000):
        """初始化随机漫步的属性"""
        self.num_points=num_points

        #所有随机漫步都始于(0,0)
        self.x_values=[0]
        self.y_values=[0]

    def fill_walk(self):
        """计算随机漫步包含的所有点"""

        #不断漫步，直到列表达到指定的长度
        while len(self.x_values)<self.num_points:
            # 决定前进方向以及沿这个方向前进的距离
            # choice([1,-1])表示在1或-1中，随机返回一个值，返回1表示向右走，-1表示向左走
            x_direction=choice([1,-1])
            # 随机返回0~4之间的任意一个整数，表示走多远
            x_distance=choice([0,1,2,3,4])
            #将移动方向乘以移动距离，得到沿x轴移动的距离
            x_step=x_direction*x_distance

            y_direction=choice([1,-1])
            y_distance=choice([0,1,2,3,4])
            y_step=y_direction*y_distance

            #拒绝原地踏步
            if x_step==0 and y_step==0:
                continue

            #计算下一个点的x和y的值，获取x_values中的最后一个值并相加
            next_x=self.x_values[-1]+x_step
            next_y=self.y_values[-1]+y_step

            self.x_values.append(next_x)
            self.y_values.append(next_y)
```

###### 绘制随机漫步图

完整代码如下

rw_bisual.py：

```python
import matplotlib.pyplot as plt
from random_walk import RandomWalk

while True:
    # 创建一个RandomWalk实例，并将其包含的点都绘制出来
    rw=RandomWalk(50000)
    rw.fill_walk()

    #设置绘图窗口的尺寸
    plt.figure(dpoint_numbers=128, figsize=(10,6))
    
    point_numbers=list(range(rw.num_points))
    #渐变显示
    plt.scatter(rw.x_values,rw.y_values,c=point_numbers,cmap=plt.cm.Blues,
                edgecolors='none',s=1)
    
    #plt.scatter(rw.x_values,rw.y_values,s=15)
    
    #突出起点和终点
    plt.scatter(0,0,c='green',edgecolors='none',s=100)
    plt.scatter(rw.x_values[-1],rw.y_values[-1],c='red',edgecolors='none',s=100)

    #隐藏坐标轴
    plt.axes().get_xaxis().set_visible(False)
    plt.axes().get_yaxis().set_visible(False)

    plt.show()

    keep_running=input("是否重新生成？（y/n）")
    if(keep_running=='n'):
        break
```

上述代码中，设置绘图窗口的尺寸使用了如下代码：

```python
plt.figure(dpi=128, figsize=(10,6))
```

函数`figure()`用于指定图表的宽度、高度、分辨率和背景色。你需要给形参`figsize`指定一个元组，向`matplotlib`指出绘图窗口的尺寸，单位为英寸。Python假定屏幕分辨率为`80`像素/英寸，如果上述代码指定的图表尺寸不合适，可根据需要调整其中的数字。如果你知道自己的系统的分辨率，可使用形参`dpi`向`figure()`传递该分辨率，以有效地利用可用的屏幕空间。



## 使用pygal包创建矢量图表文件

`pygal`包可用于生成可缩放的矢量图形文件，对于需要在尺寸不同的屏幕上显示的图表，这很有用，因为它们将自动缩放，以适合观看者的屏幕。

#### 综合示例

本示例来自于《Python编程：从入门到实践》一书中的15.4章节“使用`pygal`模拟投掷骰子”，该示例主要用来模拟随机投掷骰子，得到的各个点数出现的概率情况，并使用`pygal`包生成矢量文件（`.svg`）。

完整示例代码如下：

die.py：

```python
from random import randint

class Die():
    """表示一个骰子的类"""

    def __init__(self, num_sides=6):
        """骰子默认为6面"""
        self.num_sides=num_sides

    def roll(self):
        """返回一个位于1和骰子面数之间的随机值"""
        return randint(1,self.num_sides)
```

die_visual.py：

```python
import pygal
from die import Die

#创建D6（面数为6）骰子
die_1=Die()
#创建面数为10的骰子
die_2=Die(10)

#投掷几次骰子，并将结果存储在一个列表中
results=[]

for roll_num in range(50000):
    result=die_1.roll()+die_2.roll()
    results.append(result)
 
#分析结果，用于存储每种点数出现的次数
frequencies=[]

#存储最大点数，最大点数应该是6+6=12
max_result=die_1.num_sides+die_2.num_sides
for value in range(2,max_result+1):
    #计算每个点数出现的次数
    frequency=results.count(value)
    frequencies.append(frequency)

#绘制直方图，对结果进行可视化
hist=pygal.Bar()

#设置用于标示直方图的字符串
hist.title="Results of rolling one D6 1000 times."
#存储可能出现的结果，最大为10+6=16
hist.x_labels=['2','3','4','5','6','7','8','9','10','11','12','13','14','15','16']
hist.x_title="Result"
hist.y_title="Frequency of Result"
#使用add()将一系列值添加到图表中
#（向它传递要给添加的值指定的标签，还有一个列表，其中包含将出现在图表中的值）
hist.add('D6+D10',frequencies)
#将这个图表渲染为一个SVG文件，这种文件的扩展名必须为.svg
hist.render_to_file('die_visual.svg')
```

上述代码中，使用`pygal`绘制直方图，直方图是一种条形图，指出了各种结果出现的频率。





------



#### 参考资源

- 《Python编程：从入门到实践》

 

本文后续会随着知识的积累不断补充和更新，内容如有错误，欢迎指正。

最后一次更新时间：2018-08-31

------


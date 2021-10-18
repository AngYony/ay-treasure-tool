# Python中的if条件语句

if语句主要用于代码流程控制。



## if语句几种形式



#### 简单的if语句

形式：

> if 布尔表达式:
>     代码块

如果布尔表达式的结果为True，Python就会执行紧跟if语句后面的代码，否则Python将会忽略这些代码。

```python
>>> item='python'
>>> if item=="python":
...     print("这是python")
... 
这是python
>>> 
```

#### if-else语句

形式：

> if 布尔表达式:
>     代码块1
> else:
>     代码块2

如果布尔表达式为True，Python就执行代码块1的代码，否则执行代码块2。

```python
>>> age=16
>>> if age>=18:
...     print('age>=18')
... else:
...     print('age<18')
... 
age<18
>>> 
```

#### if-elif-else语句

形式：

> if 布尔表达式A:
>     代码块A
> elif 布尔表达式B:
>     代码块B
> else:
>     代码块C

如果布尔表达式A为True，就执行代码A，否则就判断布尔表达式B的值，如果为True，就执行代码B；如果表达式A和表达式B都不为True，就执行代码C。

```python
>>> age=18
>>> if(age<12):
...     print('age<12')
... elif(age>16):
...     print('age>16')
... else:
...     print('age在12~16之间')
... 
age>16
>>> 
```

可以根据需要使用任意数量的`elif`代码块。



## if语句和列表



#### 判断列表是否为空

```python
>>> mylist=[]
>>> if mylist:
...     print('列表不为空')
... else:
...     print('列表为空')
... 
列表为空
>>> 
```

#### 判断列表中是否存在某个元素

```python
>>> mylist=["java","csharp","python","php","go"]
>>> if 'node.js' in mylist:
...     print('node.js在集合中')
... 
>>> if 'node.js' not in mylist:
...     print('node.js不在列表中')
... 
node.js不在列表中
>>> 
```



## if语句的常用判断积累

if判断字符串是否有值(Python将非空字符串解读为True)

```python
>>> name=''
>>> if name:
...     print('有值')
... else:
...     print('没有值')
... 
没有值
>>> 
```





------



#### 参考资源

- 《Python编程：从入门到实践》

 

本文后续会随着知识的积累不断补充和更新，内容如有错误，欢迎指正。

最后一次更新时间：2018-07-10

------












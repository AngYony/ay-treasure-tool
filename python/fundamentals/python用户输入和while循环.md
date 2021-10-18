# Python用户输入和while循环 



## input()函数

函数`input()`用于接收用户的输入信息。使用`input()`时，python将用户输入的内容解读为字符串，因此在进行其他数据类型操作时，需要进行相应的类型转换。注意：在Python2.7中，`input()`函数作用有所不同，`input()`函数会将用户输入解读为Python代码，并尝试运行它们，所以在Python2.7中，请使用`raw_input()`代替`input()`来获取输入。

```python
>>> myname=input("请输入你的姓名：")
请输入你的姓名：
octocean

>>> myage=input("请输入你的年龄：")
请输入你的年龄：
19

>>> if int(myage)>18:
...     print('恭喜你，'+myname+",你已经长大了，你的年龄是"+myage+'岁')
... else:
...     print('抱歉，你还未成年！')
... 
恭喜你，octocean,你已经长大了，你的年龄是19岁
>>> 
```



## while循环

for循环用于针对集合中的每个元素都有一个代码块，而while循环不断的运行，直到指定的条件不满足为止。

简单的示例：

```python
index=1
while index<=5:
    print(index)
    index+=1 #python中没有++运算符，请谨慎使用
```

使用break语句立即退出while循环，不再执行break之后的语句；使用continue跳过此次循环的执行，转而执行下一次循环。

```python
status=True
result=80
num=input('请输入任意一个数字：')
while status:
    if int(num)>100:
        print('不和你玩了，break一下！')
        break;
    if(result>int(num)):
        num=input('该数字比你输入的大，请再次输入：')
    elif(result<int(num)):
        num=input('该数字比你输入的小，请再次输入：')
    else:
        status=False
        print('恭喜你猜对了！')
```

#### 使用while循环处理列表

将一个列表中的元素循环添加到另一个列表中：

```python
>>> mylist=['python','java','csharp']
>>> newlist=[]
>>> while mylist:
...     item=mylist.pop() #得到并删除列表末尾元素
...     newlist.append(item)
... 
>>> print(mylist)
[]
>>> print(newlist)
['csharp', 'java', 'python']
>>> 
```

删除包含特定值的所有列表元素：

```python
>>> mylist=['php','go','java','go','java','python','java']
>>> #remove()一次只能删除一个元素
... mylist.remove('java')
... 
>>> print(mylist)
['php', 'go', 'go', 'java', 'python', 'java']
>>> while 'java' in mylist:
...     mylist.remove('java')
... 
>>> print(mylist)
['php', 'go', 'go', 'python']
>>> 
```





------



#### 参考资源

- 《Python编程：从入门到实践》



本文后续会随着知识的积累不断补充和更新，内容如有错误，欢迎指正。 

最后一次更新时间：2018-07-10



------


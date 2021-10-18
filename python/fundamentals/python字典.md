# Python 字典

在Python中，字典是一系列键值对。每个键都与一个值相关联，可以使用键来访问与之相关联的值。与键相关联的值可以是任何值，包括数字、字符串、列表、字典等其他任何Python对象。

Python中字典的使用和Javascript中的json对象特别的类似。



## 字典的创建

在创建一个字典时，字典的键和值之间用冒号分割，每一组键-值对之间用逗号分割，整个键值对放在花括号的内部，形式如下：

```
dic={'key1':'value1','key2':'value2'}
```

例如：

```python
>>> mydic={'name':'小明','age':18,'sex':'男'}
```

也可以直接创建一个空字典：

```python
>>>mydic={}
```



## 访问字典中的值

要获取字典的值，需要指定字典名和放在方括号内的键，形式如下：

```
dic['key']
```

例如获取字典中的name值：

```python
>>> mydic['name']
'小明'
```



## 为字典添加值或修改值

要为字典添加键值对或修改字典中的值，需要指定字典名、用方括号括起的键和相关联的新值。形式如下：

```
dic['new_key']='new_value'
```

例如为字典添加mail信息：

```python
#为字典添加新值
>>> mydic['mail']='xiaoming@163.com'
>>> print(mydic)
{'name': '小明', 'age': 18, 'sex': '男', 'mail': 'xiaoming@163.com'}
#修改字典中的值
>>> mydic['name']='小华'
>>> print(mydic)
{'name': '小华', 'age': 18, 'sex': '男', 'mail': 'xiaoming@163.com'}
```

注意：键值对的排列顺序并不总是 与添加顺序相同。



## 删除字典中的值

使用`del`语句删除字典中的值，需要指定字典名 和要删除的键。形式如下：

```
del dic_name['key']
```

例如删除字典中的mail信息：

```python
>>> del mydic['mail']
>>> print(mydic)
{'name': '小华', 'age': 18, 'sex': '男'}
```



## 遍历字典

遍历字典采用的是`for`循环语句，具体有以下几种形式。

#### 遍历所有的键值对

需要调用字典的`items()`函数，该函数返回一个键值对列表，然后对该列表进行遍历，分别声明两个变量用来存储键值对中的键和值，代码如下：

```python
>>> for k,v in mydic.items():
...     print('k:'+str(k)+'\t v:'+str(v))
... 
k:name	 v:小华
k:age	 v:18
k:sex	 v:男
>>> 
```

由于遍历的过程中得到值为18，因此需要调用`str()`函数进行非字符串的转换。

#### 遍历字典中的所有键

使用字典的`key()`函数获取所有的键组成的列表，然后遍历该列表，代码如下：

```python
>>> for k in mydic.keys():
...     print(k)
... 
name
age
sex
>>> 
```

在遍历字典时，会默认遍历所有的键，因此即使不显式的调用`key()`函数，结果仍然不变，如下：

```python
>>> for k in mydic:
...     print(k)
... 
name
age
sex
>>> 
```

如果想要按顺序遍历字典中所有的键，可以使用`sorted()`函数对获取的键列表进行排序后再遍历：

```python
>>> for k in sorted(mydic):
...     print(k)
... 
age
name
sex
>>> 
```

#### 遍历字典中所有值

使用`values()`函数获取字典的所有值组成的列表，该列表不包含任何键，然后使用`for`循环遍历该值列表，代码如下：

```python
>>> for v in mydic.values():
...     print(v)
... 
小华
18
男
>>> 
```

如果需要对获取的值列表进行去重，可以调用`set()`函数，它将返回一个所有元素都不是重复的set集合。

```python
>>> dic={'name1':'小明','name2':'小明','name3':'小华'}
>>> print(set(dic.values()))
{'小明', '小华'}
>>> for v in set(dic.values()):
...     print(v)
... 
小明
小华
>>> 
```



## 字典嵌套

字典嵌套的意思就是字典中存储列表，或列表中存储字典，或字典中存储字典。

#### 字典列表

列表中存储一系列的字典。

```python
>>> dic1={'name':'小明','age':18,'sex':'男'}
>>> dic2={'name':'小芳','age':15,'sex':'女'}
>>> dic3={'name':'小米','age':25,'sex':'男'}
>>> diclist=[dic1,dic2,dic3]
>>> print(diclist)
[{'name': '小明', 'age': 18, 'sex': '男'}, {'name': '小芳', 'age': 15, 'sex': '女'}, {'name': '小米', 'age': 25, 'sex': '男'}]
>>> for dic in diclist:
...     print(dic)
... 
{'name': '小明', 'age': 18, 'sex': '男'}
{'name': '小芳', 'age': 15, 'sex': '女'}
{'name': '小米', 'age': 25, 'sex': '男'}
>>> 
```

#### 字典中存储列表

```python
>>> dic= {
...     'name':'编程语言',
...     'type':['python','c#','java']
...     }
... 
>>> for t in dic['type']:
...     print(t)
... 
python
c#
java
>>> 
```

####字典中存储字典

```python
>>> mydic={
...     'student':{
...         'stuname':'小明','stuage':18
...         },
...     'class':{
...         'classname':'一班','teacher':'陈老师'
...         }
...     }
... 
>>> for k,v in mydic.items():
...     for lk ,lv in v.items():
...         print(lk+'\t'+str(lv))
... 
stuname	小明
stuage	18
classname	一班
teacher	陈老师
>>> 
```

通过以上的学习不难发现，Python字典的操作和json对象操作几乎是一模一样，如果你对json对象操作很熟悉的话，相信你会很快掌握Python字典的相关用法。








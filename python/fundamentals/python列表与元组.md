# Python 列表和元组



## 列表的介绍和定义

python中的列表由一系列按特定顺序排列的元素组成。

在python中，使用方括号（[]）来表示列表，列表中的各个元素使用逗号（,）来分割。

```python
>>> mylist=['python','java','dotnet']
>>> print(mylist)
['python', 'java', 'dotnet']
```

#### 访问列表元素

在python中，使用索引方括号的方式进行元素的访问。元素的索引从0开始访问第一个元素，索引支持负数，-1表示最后一个元素的索引，-2表示倒数第二个元素索引，-3表示倒数第三个元素索引……以此类推。

```python
>>> mylist=['python','java','dotnet']
>>> print('第一个元素:'+mylist[0])
第一个元素:python
>>> print('第三个元素:'+mylist[2])
第三个元素:dotnet
>>> print('最后一个元素：'+mylist[-1])
最后一个元素：dotnet
>>> print('倒数第二个元素：'+mylist[-2])
倒数第二个元素：java
```



## 修改、添加和删除列表元素

#### 修改列表元素

修改列表元素的语法和访问列表元素的语法类似，需要指定列表元素的索引和对应的值。

```python
>>> mylist=['python','java','dotnet']
>>> #修改第一个元素的值
>>> mylist[0]='php'
>>> print(mylist)
['php', 'java', 'dotnet']
```

#### 添加列表元素

##### 将元素添加到列表末尾：`append()`

```python
>>> mylist=['python','java','dotnet']
>>> mylist.append('javascript')
>>> print(mylist)
['python', 'java', 'dotnet', 'javascript']
```

##### 在列表的指定位置插入元素：`insert()`

```python
>>> mylist=['python','java','dotnet']
>>> mylist.insert(1,'C++')
>>> print(mylist)
['python', 'C++', 'java', 'dotnet']
```

#### 删除列表元素

##### 使用`del`语句删除指定索引位置的元素：

```python
>>> mylist=['python','java','dotnet']
>>> del mylist[1]
>>> print(mylist)
['python', 'dotnet']
```

##### 删除列表中指定索引位置的元素：`pop(index)`

`pop()`函数可以删除指定索引位置的元素，如果函数不带参数，默认为-1，表示删除的是列表的末尾元素并返回该元素。

`pop()`函数在删除元素的同时，会返回该元素。

```python
>>> mylist=['csharp','python','java','php','go']
>>> d1=mylist.pop()
>>> print(d1)
go
>>> print(mylist)
['csharp', 'python', 'java', 'php']
>>> d2=mylist.pop(2)
>>> print(d2)
java
>>> print(mylist)
['csharp', 'python', 'php']
>>> d3=mylist.pop(-2)
>>> print(d3)
python
>>> print(mylist)
['csharp', 'php']
```

关于`del`语句和`pop()`函数的选择：

如果需要删除一个元素并使用该元素时，使用`pop()`函数，如果不需要使用要删除的元素，直接选择`del`语句。

##### 删除列表中指定值的元素：`remove()`

```python
>>> mylist=['csharp','python','java','php','go']
>>> mylist.remove('java')
>>> print(mylist)
['csharp', 'python', 'php', 'go']
```

*注意：`remove()`函数一次只删除第一个指定的值。如果要删除的值在列表中有多个，需要使用循环来判断是否删除了所有这样的值。*



## 列表元素排序和反转元素排列顺序

#### 对列表进行永久性排序：`sort()`

`sort()`是对列表进行升序排序，如果按照倒序排序，需要给`sort()`指定参数`reverse=True`。

```python
>>> mylist=['python','node.js','java','go','php','csharp']
>>> mylist.sort()
>>> print(mylist)
['csharp', 'go', 'java', 'node.js', 'php', 'python']
>>> mylist.sort(reverse=True)
>>> print(mylist)
['python', 'php', 'node.js', 'java', 'go', 'csharp']
```

*注意：`sort()`是对列表进行永久性排序，一旦调用该函数，列表中的元素的顺序就会永久性改变。*
#### 对列表进行临时性排序：`sorted()`

`sorted()`函数在对列表元素进行排序的同时，不影响列表中的原始排列顺序。如果需要按照降序排序，可以在函数`sorted()`传递参数`reverse=True`。

```python
>>> mylist=['python','node.js','java','go','php','csharp']
>>> arr=sorted(mylist)
>>> print(arr)
['csharp', 'go', 'java', 'node.js', 'php', 'python']
>>> print(mylist)
['python', 'node.js', 'java', 'go', 'php', 'csharp']
>>> print(sorted(mylist,reverse=True))
['python', 'php', 'node.js', 'java', 'go', 'csharp']
>>> print(mylist)
['python', 'node.js', 'java', 'go', 'php', 'csharp']
```

#### 反转列表元素的排列顺序：reverse()

`reverse()`函数会**<u>永久性</u>**的修改列表元素的排列顺序，如果要恢复原来的排列顺序，只需对列表再次调用`reverse()`即可。

```python
>>> mylist=['python','node.js','java','go','php','csharp']
>>> mylist.reverse()
>>> print(mylist)
['csharp', 'php', 'go', 'java', 'node.js', 'python']
>>> mylist.reverse()
>>> print(mylist)
['python', 'node.js', 'java', 'go', 'php', 'csharp']
```

*注意：`reverse()`不是指按与字母顺序相反的顺序排列列表元素，而只是反转列表元素的排列顺序。*



## 获取列表的元素个数

使用函数`len()`获取列表的长度（元素的个数）。

```python
>>> mylist=['python','node.js','java','go','php','csharp']
>>> len(mylist)
6
```



## 遍历列表

遍历列表使用for循环进行遍历。

```python
for s in mylist:
    print(s)
```

注意：使用`for`语句时，末尾的冒号（:）不要忘记了，它的作用是告诉python，下一行是循环的第一行。

循环体内的代码块范围使用缩进的方式进行确认，因此需要注意代码的缩进情况，防止不必要的缩进。



## 检查特定值是否包含在列表中

要判断特定值是否已包含在列表中，可使用关键字`in`。如果要判断元素不在列表中，使用`not in` 即可。常常用于`if`语句判断：

```python
>>> mylist=["java","python","C#"]
>>> 'python' in mylist
True
>>> if 'C#' in mylist:
...     print("存在C#")
... 
存在C#
>>> if 'php' not in mylist:
...     print('列表中不存在php')
... 
列表中不存在php
>>>
```



## 数值列表

数值列表是存储数字的列表。

#### `range()`函数

可以使用`range()`函数生成一系列数字。函数`range()`从指定的第一个参数值开始数，到指定的第二个参数值停止，不包括第二个指定的参数值。

`range()`函数不会直接返回数值列表，需要使用函数`list()`对`range()`的结果进行转换。

```python
>>> for value in range(1,5):
...     print(value)
... 
1
2
3
4
>>> list(range(1,3))
[1, 2]
>>> n2=range(1,4)
>>> print(n2)
range(1, 4)
>>> list(n2)
[1, 2, 3]
>>> list(range(2,5))
[2, 3, 4]
>>> 
```

`range()`函数可以指定第三个参数，表示数值的步长。

```python
>>> for value in range(2,11,4):
...     print(value)
... 
2
6
10
>>> 
```

上述示例表示，函数`range()`将从2开始生成，不断加4，直到达到或超过终值11停止，返回生成的所有小于且不等于11的数值。

#### 数值列表的统计计算

`min()`：返回数值列表中的最小值。

`max()`：返回数值列表中的最大值。

`sum()`：返回数值列表中的值的总和。

```python
>>> nums=[2,5,1,6]
>>> print(min(nums))
1
>>> print(max(nums))
6
>>> print(sum(nums))
14
```



## 列表解析

列表解析是一种使用简短代码快速生成列表的一种方式。它可以将for循环和创建新元素的代码合并成一行，并自动附加新元素，返回整个列表。

```python
>>> mylist=[v+3 for v in range(2,4)]
>>> print(mylist)
[5, 6]
>>> nlist=[str(n)+'w' for n in mylist]
>>> print(nlist)
['5w', '6w']
```

上述`range(2,4)`会生成2、3两个元素，列表解析在元素的基础上各加上3进行返回，直接得到返回后的列表`[5,6]`。



## 列表截取

可以使用`[start_index:end_index]`这种切片形式截取指定索引位置的列表。有如下几种使用方式：

- `list[start_index:end_index]`：指定起始索引位置和结束索引位置。例如，`list[1:3]`表示的是从索引为1的元素开始截取，到索引为3的元素停止（返回的结果不包含索引为3的元素）。
- `list[start_index:]`：只指定起始索引的位置。将会从起始索引位置开始，截取到之后的所有元素。
- `list[:end_index]`：只指定结束索引的位置，没有指定起始位置，相当于`list[0:end_index]`，将会从列表的开头开始截取，到结束索引位置停止（不包括结束索引位置的元素）。
- `list[:]`：既不指定起始索引位置，也不指定结束索引位置，将会截取列表的全部数据，相当于复制了一个全新的列表。

由于python中的索引可以为负数，因此当`start_index`为负数时，表示的是从列表的倒数第`star_index`个元素开始截取，例如：如果要截取列表的最后2个元素，可以直接使用`list[-2:]`即可。

```python
>>> mylist=['csharp','python','java','php','go']
>>> #用法一
... mylist[1:3]
['python', 'java']
>>> #用法二
... mylist[:3]
['csharp', 'python', 'java']
>>> #用法三
... mylist[1:]
['python', 'java', 'php', 'go']
>>> #输出最后三个元素
... mylist[-3:]
['java', 'php', 'go']
>>> #输出倒数第三个和倒数第二个元素
... mylist[-3:-1]
['java', 'php']
>>> #输出最后三个元素时，第二个参数不能指定为0（将会得不到任何结果）
... mylist[-3:0]
[]
>>> 
```

可以直接使用 for循环对截取的列表进行遍历：

```python
>>> mylist=['csharp','python','java','php','go']
>>> for p in mylist[:4]:
...     print(p)
... 
csharp
python
java
php
>>> 
```

可以使用`[:]`的形式快速的复制列表并返回一个全新的列表。这种形式的复制可以避免直接变量赋值（直接定义一个新的变量引用该列表）导致的同一个引用在列表元素发生改变时互相影响的情况（原列表中的元素发生了改变，直接会影响新引用的变量）。

```python
>>> mylist=['csharp','python','java','php','go']
>>> copy_list=mylist[:]
>>> print(copy_list)
['csharp', 'python', 'java', 'php', 'go']
```



## 列表中的元素去重

如果列表中存在重复的数据，想要快速去重的话，可以使用`set()`函数，它可以将列表转换为set集合，而set集合中的每个元素必须是独一无二的，如下：

```python
>>> mylist=[1,3,4,2,1,5,3,2]
>>> myset=set(mylist)
>>> print(myset)
#调用了set()函数后显示为集合
{1, 2, 3, 4, 5}
#如果要显示为列表，需要再次调用list()函数进行转换
>>> print(list(myset))
[1, 2, 3, 4, 5]
>>> 
```





## 元组

Python中的列表是可以修改的，用于存储在程序运行期间可能发生变化的数据集。而元组是用来存储不可修改的元素的。元组一旦被定义，元素内的元素就不能发生改变。

#### 定义元组

使用圆括号（`()`）而不是方括号（`[]`）来定义元组。

```python
>>> mytuple=(10,20,30)
>>> for t in mytuple:
...     print(t)
... 
10
20
30
>>> #直接为元组赋值将会报错
... mytuple[0]=100
Traceback (most recent call last):
  File "<stdin>", line 2, in <module>
TypeError: 'tuple' object does not support item assignment
>>> mytuple[0]
10
```


























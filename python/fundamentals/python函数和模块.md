# Python 函数和模块

函数是带名字的代码块，可以在其他地方被反复调用。



## 定义函数

定义函数使用`def`关键字，后面指定函数名称和参数信息，如果没有参数，括号也必不可少。例如：

```python
def myfun():
    """方法体内容"""
    print("这是新定义的方法！");
#调用该方法
myfun()
>>>这是新定义的方法！
>>> 
```

上述中使用三引号对文本进行了注释，被三引号括起的文本被称为文档字符串，主要用来描述函数是做什么的。Python使用它们来生成有关程序中函数的文档。

####带参数的函数

```python
def hello(name):
    print("hello,"+name)

#调用带参函数
hello("张三")
```

#### 实参和形参

形参：定义函数时，指定函数需要使用到的参数变量被称为形参，比如上述中的“`name`”。

实参：调用函数时，指定具体需要给函数传递的值被称为实参，比如上述中的”张三“。

#### 参数默认值

编写函数时，可以给形参指定默认值。如果在调用函数时，提供了实参，python将使用指定的实参值；否则，将使用形参的默认值。因此，给形参指定默认值后，可以在函数调用中省略相应的实参。

```python
def hello(name="python"):
    print("hello,"+name)
#调用带默认值的参数函数
hello()
```

注意：为了让Python能够正确的解读位置实参，应在形参列表中必须先列出没有默认值的形参，再列出有默认值的实参。也就是，**带默认值的形参，应该定义在参数列表的最后**。

在调用函数时，函数需要接受的实参的个数并不总是固定的，如果形参采用了星号（`*`）形式进行定义，就可以传递任意数量的实参，具体请查看下述中的“传递任意数量的实参”相关说明。

## 传递实参

调用函数时，为函数传递实参的形式有：

- 位置实参：要求实参的顺序与形参的顺序相同。
- 关键字实参：指定实参的变量名和值。
- 任意数量的位置实参（`*par`）或任意数量的关键字实参（`**par`)

#### 位置实参

调用函数时，传递给函数的实参顺序与定义函数时的形参顺序相同。

```python
def myfun(par1,par2,par3):
    print("par1="+par1)
    print("par2="+par2)
    print("par3="+par3)
#位置实参调用
myfun("A","B","C")
```

#### 关键字实参

关键字实参是传递给函数的名称-值对，需要指定参数名称和对应的值，关键字实参无需考虑函数调用中的实参顺序。

```python
def myfun(par1,par2,par3):
    print("par1="+par1)
    print("par2="+par2)
    print("par3="+par3)
#关键字实参调用
myfun(par3="A",par1="B",par2="C")
```



## 返回值

Python中无需像其它语言一样指定返回值的类型，而是直接在函数体内使用`return`语句返回对应的值。Python的函数可以返回任何类型的值，包括列表和字典等较复杂的数据结构。

```python
def myname(first_name,last_name,middle_name=''):
    
    if middle_name:
        full_name=first_name+' '+middle_name+' '+last_name
    else:
        full_name= first_name+ ' '+last_name
    return full_name.title()
#调用函数
name=myname('ma','yun')
hello(name)
```



## 传递任意数量的实参

####  使用任意数量的位置实参

在定义函数时，如果形参采用星号（`*`）的形式进行定义，那么它就表示可以接受任意数量的实参。例如：

```python
>>> def show_string(*strs):
...     print(strs)
... 
>>> show_string()
()
>>> show_string('A')
('A',)
>>> show_string("B","C")
('B', 'C')
>>> 
```

上述中的`show_string`函数自定义了一个形参`*strs`，形参名中的星号（`*`）让Python创建一个名为`strs`的空元组，并将接收到的所有值都封装到这个元组中。为了得到传入的每个实参，可以使用`for`循环的方式进行遍历。

```python
>>> def show_string(*strs):
...     print(strs)
...     for str in strs:
...         print(str)
... 
>>> show_string("B","C")
('B', 'C')
B
C
>>> 
```

在定义函数时，将接收任意数量实参的形参放在参数列表的最后。

#### 使用任意数量的关键字实参

在定义函数时，采用两个星号（`**`）的形式指定可以接收任意数量的实参，每一个实参将采用键值对的形式进行调用。例如：

```python
>>> def show_student_info(name,**stus):
...     group={}
...     group["name"]=name
...     for key,value in stus.items():
...         group[key]=value
...         print(key+":"+value)
...     return group
... #调用
... 
>>> mygroup=show_student_info('小明',age='18',sex='男')
age:18
sex:男
>>> print(mygroup)
{'name': '小明', 'age': '18', 'sex': '男'}
>>> 
```

上述中的函数`show_student_info`在定义时，形参`**stus`中的两个星号让Python创建一个名为`stus`的空字典，并将接收到的所有名称-值对都封装在这个字典中。在这个函数中，可以像访问其他字典那样访问这个函数中的名称-值对。



## 函数常见的应用场景

#### 禁止函数修改列表

如果列表作为实参传递给函数，函数体内对列表的修改操作，将会直接影响到传入的列表本身，它是永久性更改的，如果不想在函数体内修改列表本身，可以给函数传递一个列表的副本而不是原件。采用列表切片的形式：`list_name[:]`来创建列表的副本，将其作为实参进行传递即可。例如：

```python
function_name(list_name[:])
```



## 模块

模块是扩展名为`.py`的文件，包含要导入到程序中的代码。模块可以隐藏程序代码的细节，将重点放在程序的高层逻辑上。模块可以让你在众多不同的程序中重用函数，可以与其他程序员共享这些文件而不是整个程序，同时也可以让你使用到其他程序员编写的函数库等。

先创建一个模块，模块文件名叫`student.py`，包含两个函数。

`student.py`：

```python
def show_student(stu_name):
    print('hello,'+stu_name)
def student_age(stu_name,stu_age):
    print(stu_name+'的年龄是：'+str(stu_age))
```

然后在和`stuent.py`文件同级目录中创建名为`manage_student.py`的文件，用来说明如何使用模块。

#### 导入整个模块

使用`import`关键字导入要使用的模块，可以在程序中使用该模块中的所有函数，要调用被导入的模块中的函数，可以指定模块名.函数名进行调用。

`manage_student.py`：

```python
import student
student.show_student('小明')
```

#### 导入特定的函数

可以导入模块中特定的函数，导入的语法如下：

```python
from module_name import function_name1[,function_name2,function_name3...]
```

多个函数之间使用逗号分隔函数名。在调用函数的时候，只需要指定函数名即可。

```python
from student import student_age
student_age("小明",18)
```

#### 使用`as`给函数指定别名

如果要导入的函数的名称可能与程序中现有的名称冲突，或者函数的名称太长，可指定简短而独一无二的别名。

通用语法：

```python
from module_name import function_name1 as bm1[,function_name2 as bm2...]
```

多个函数别名中间用逗号隔开。

```python
from student import student_age as age, show_student as stu
stu("小芳")
age("小明",18)
```

#### 使用`as`给模块指定别名

也可以给模块指定别名，通过给模块自动简短的别名，可以跟轻松的调用函数。

通用语法：

```python
import module_name as bm
```

一旦给模块取了别名，就可以使用别名.函数名的形式进行调用：

```python
import student as stu
stu.show_student("小华")
```

#### 导入模块中的所有函数（不推荐）

使用星号（`*`）运算符可以导入模块中的所有函数。

```python
from student import *
show_student("小牛")
```

这种形式的导入，也不需要使用模块名加句点表示法的形式调用函数，直接可以通过函数名进行调用。

注意：实际应用中，最好不要使用这种方式进行导入，如果模块中的函数名称和项目中的名称相同，调用时，将会出现意想不到的结果。最佳的做法是，要么只导入你需要使用的函数，要么导入整个模块并使用句点表示法进行函数的调用。



## 函数编写规范

- 函数名应该是具有描述性的名称
- 函数名应该只由小写字母和下划线组成
- 函数应该包含简要的阐述其功能的注释，该注释应该紧跟在函数定义后面，并采用文档字符串格式（三个双引号）。
- 给形参指定默认值或使用关键字实参调用函数时，等号两边不要有空格。
- 如果程序或模块包含多个函数，相邻的函数之间使用两个空行来分开。
- 在文件开头没有注释的情况下，应该将`import`语句放在文件开头。





------



#### 参考资源

- 《Python编程：从入门到实践》

 

本文后续会随着知识的积累不断补充和更新，内容如有错误，欢迎指正。

最后一次更新时间：2018-07-10

------


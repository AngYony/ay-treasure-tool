# Python文件和异常



## 从文件中读取数据

首先准备一个文本文件，文件中存储着普通文本数据。读取文件需要调用open()和read()函数。

#### 读取整个文件

代码示例：

```python
with open('pi_digits.txt') as file_object:
    contents=file_object.read()
    print(contents)
```

###### open()函数

在读取文件之前，必须先要打开文件，这样才能访问它。打开文件需要调用open()函数，它接受一个参数：要打开的文件路径名称（可以是相对路径，也可以是绝对路径，相对路径时，Python将会以当前执行的文件所在的目录作为相对位置去查找指定的文件）。

注意：在Linux和OS X中，使用斜杠（/）分割文件路径；而在Windows系统中，使用反斜杠（\）分割文件路径。

函数open()返回一个表示文件的对象。例如此处的`open('pi_digits.txt')`	返回一个表示文件pi_digits.txt的对象，Python将这个对象存储在我们将在后面使用的变量file_object中。

###### with关键字

关键字with在不再需要访问文件后将其关闭。它可以解决显式调用close()函数可能出现的一些问题，如果显式的调用close()函数，一旦程序出现异常，导致close()语句还未执行，文件将不会关闭，而且如果过早的调用close()，将会出现文件读取错误，因此使用with关键字可以很好的避免这类问题，Python让你只管打开文件，并在需要时使用它，Python自会在合适的时候自动将其关闭。

另外还需要注意一点，使用关键字with时，open()返回的文件对象只在with代码块内可用。

###### read()函数

如果不给read()函数传递参数，将会读取全部内容。

注意：read()读取到文件末尾时会返回空白符（文本的末尾有一个看不见的换行符），为了去除多余的空白，应该结合使用rstrip()函数：

```python
#去除字符串末尾的多余空白
print(contents.rstrip())
```

#### 逐行读取

```python
#逐行读取
with open('pi_digits.txt') as file_object2:
    for line in file_object2:
        print(line.rstrip())
```

可以直接使用for循环遍历文件对象，去读取每一行。

#### 创建一个包含文件各行内容的列表

使用关键字with时，open()返回的文件对象只在with代码块内可用，可以先将读取的内容放入一个列表中，然后在with代码块的外面去访问文件的内容。

```python
#创建包含文件各行内容的列表
with open('pi_digits.txt') as file_object3:
    #从文件中读取每一行，并将其存储在一个列表中
    lines=file_object3.readlines()
#在with代码块的外面读取该列表
for line in lines:
    print(line.rstrip())
```



## 将数据写入文件

将数据写入到文件中，需要调用open()和write()函数。

#### 写入空文件

```python
filename='test.txt'
#写入空文件
with open(filename,'w') as file_obj:
    file_obj.write('hello python!')
```

写入文件时，也需要使用open()函数先打开文件，不同的是打开文件的模式不同。open()函数的第一个参数用来指定文件名，第二个参数指定打开的模式，相关模式如下：

- 写入模式（`w`）：如果文件不存在，将会创建一个空文件。如果文件已经存在，将会在返回该文件对象前清空该文件。即永远以空文件的形式返回文件对象，不管该文件是否有数据。
- 读取模式（`r`）：如果open()函数省略了模式实参，将默认以该模式打开文件，即文件只能读取不能写入。
- 附加模式（`a`）：不清空原文件，而是将新写入的内容附加到原文件的末尾。如果文件不存在，将会创建一个空文件，并附加内容。
- 读取和写入模式（`r+`）

使用open()写入文件时，如果文件不存在，将会自动创建它。

#### 写入多行

```python
#写入多行
with open(filename,'w') as file_obj2:
    file_obj2.write('java \n')
    file_obj2.write('python \n')
```

write()函数不会在你写入的文本末尾添加换行符，因此写入多行时，需要手动的在字符串的末尾添加换行符（\n）。

#### 附加到文件

```python
#附加到文件
with open(filename,'a') as file_obj3:
    file_obj3.write('one \n')
    file_obj3.write('two \n')
```

以附加模式打开文件时，python不会在返回文件对象前清空文件，而是将要写入到文件的内容追加到原文件的末尾。如果指定的文件不存在，将创建一个空文件，并附加内容。



## 异常

Python在程序执行期间发生错误时，都会创建一个异常对象，如果不做处理，将会显示一个Traceback，其中包含有关异常的报告。为了处理异常，在Python中的异常使用try-except代码块处理。

#### 使用try-except代码块

当你认为可能发生错误时，可以编写try-except代码块来处理可能引发的异常。代码块格式如下：

```python
try:
	可能会发生异常的代码片段
except 异常对象:
	异常处理的代码片段
```

例如，捕捉被除数为0引发的ZeroDivisionError异常对象：

```python
try:
    print(5/0)
except ZeroDivisionError:
    print('被除数不能为0')
```

#### try-except-else代码块

else代码块不是必须的，它只有在需要依赖于try代码块成功执行时才需要。它在try-except中的结构位置如下：

```python
try:
	片段1
except 异常对象:
	片段2
else:
	片段3
```

try-except-else代码块的工作原理：python尝试执行try代码块中的片段1代码，片段1的代码应该是只有可能引发异常的代码，不会引发异常的代码不要放在try代码块中（片段1）。如果片段1的代码发生了异常，就执行片段2的代码进行异常处理，否则，如果片段1的代码没有发生异常，就执行片段3的代码，片段3的代码应该是仅在片段1的代码成功执行时才需要运行的代码。

```python
while True:
    first_num=input("第一个数：")
    if first_num=='q':
        break
    second_num=input('第二个数：')
    try:
        result=int(first_num)/int(second_num)
    except ZeroDivisionError:
        print('被除数不能为0')
    else:
        print('值为：'+str(result))
```

#### 使用pass关键字在抛出异常时不做任何处理

如果在捕获到异常时，并不想写任何处理操作，可以直接在片段2的代码中，使用pass关键字。

```python
try:
	片段1
except 异常对象:
	pass
```

pass语句还充当了占位符，它提醒你在程序的某些对方什么都没有做，并且以后也许要在这里做些什么。





#### 处理FileNotFoundError异常

使用文件读写操作时，如果文本名错误或文件不存在，就会抛出异常。此时，可以通过捕获FileNotFoundError异常对象进行处理。

```python
filename='alice.txt'
try:
    with open(filename) as f_obj:
        contents=f_obj.read()
except FileNotFoundError:
    print('文件找不到！')
```



## 附加：存储JSON格式数据到文件中

需要导入json模块来存储数据，然后调用json.dump()和json.load()分别存储和读取JSON数据。

#### 使用json.dump()来存储数据

```python
#导入json模块
import json

numbers=[2,3,5,7,11,13]
filename='numbers.json'
with open(filename,'w') as f_obj:
    #存储数据
    json.dump(numbers,f_obj)
```

#### 使用json.load()来读取数

```python
import json
filename='numbers.json'
with open(filename) as f_obj:
    #读取数据
    numbers=json.load(f_obj)
print(numbers)
```







------



#### 参考资源

- 《Python编程：从入门到实践》

 

本文后续会随着知识的积累不断补充和更新，内容如有错误，欢迎指正。

最后一次更新时间：2018-08-22

------


# Python 字符串操作函数整理





## 字符串大小写操作



##### 将字符串全部转换为大写：`upper()`

```python
>>> name="Super Python"
>>> print(name.upper())
SUPER PYTHON
```

##### 将字符串全部转换为小写：`lower()`

```python
>>> name="Super Python"
>>> print(name.lower())
super python
```

##### 返回字符串中的各个单词首字母大写形式： `title()`

```python
>>> name="abc def gh"
>>> print(name.title())
Abc Def Gh
```



## 字符串删除空白操作



##### 删除字符串末尾空白：`rstrip()`

```python
>>> str=" abc "
>>> print(str.rstrip())
 abc
```

##### 删除字符串开头空白：`lstrip()`

```python
>>> str=" abc "
>>> print(str.lstrip())
abc 
```

##### 同时删除字符串两端空白：`strip()`

```python
>>> str=" abc "
>>> print(str.strip())
abc
```



## 字符串类型转换



##### 将非字符串类型转换为字符串：`str()`

```python
>>> age=23
>>> msg="我的年龄："+str(age)
>>> print(msg)
我的年龄：23
```


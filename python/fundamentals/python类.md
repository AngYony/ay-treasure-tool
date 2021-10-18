# Python 类



## 创建和使用类

Python中使用`class`关键字创建类，根据约定，类名首字母要大写。

示例，创建一个`Dog`类：

```python
class Dog(object):
    """类的定义和使用"""
    def __init__(self,name,age):
        #初始化属性name和age
        self.name=name
        self.age=age

    def sit(self):
        print(self.name.title()+"执行sit命令")

    def roll_over(self):
        print(self.name.title()+"执行roll_over命令")
```

下面对上述示例中的代码以及注意事项做详细说明。

#### class关键字

```python
#Python 3
class Dog():
#Python 2.7
class Dog(object):
```

声明类时，使用`class`关键字，类名按照约定首字母要大写，在Python2.7中创建类时，需要在括号中包含`object`；在Python3中创建类时，括号中可以不指定`object`。

#### `__init__()`方法

```python
def __init__(self,name,age):
    #初始化属性name和age
    self.name=name
    self.age=age
```

`__init__()`是一个特殊的方法，类似于C#或java中的构造方法，当创建类的实例时，会自动被调用。该方法的名称中，开头和结尾包含两个下划线，这是Python中的一种约定，旨在避免Python默认方法与普通方法发生名称冲突。

在`__init__()`方法的参数中，形参`self`必不可少，还必须位于其他形参的前面。形参`self`不需要显示的传入实参值，Python在创建实例时，调用`__init__()`将自动传入实参`self`。并且不仅仅是`__init__()`方法，每个与类相关联的方法调用都自动传递实参`self`，它是一个指向实体本身的引用，让实例能够访问类中的属性和方法。

另外，还需要注意一点，和其他语言相比（比如C#或java），Python不需要显式的在方法体外声明类的属性，而是直接在`__init__()`方法中，使用`self`定义了属性和赋值操作（有点像Javascript中的对象的属性赋值操作），以`self`为前缀的变量可供类中的所有方法使用，也可以通过类的任何实例来访问这些变量属性。

#### 实例化类和访问类成员

Python中实例化一个类，可以直接按照方法调用的形式实例化类，而不需要使用`new`关键字。

```python
my_dog=Dog("旺财","3")
#访问类的属性
print(my_dog.age)
print(my_dog.name)
#调用类的成员方法
my_dog.sit()
my_dog.roll_over()
```

Python中使用句点表示法来访问类成员，即：`实例名称.类成员`。

#### 给属性指定默认值

Python中的属性，不像其他语言在方法的外部声明和赋值，而是在`__init__()`方法中指定，因此给属性指定默认值，也需要在`__init__()`方法中进行。

```python
class Car(object):
    """description of class"""
    def __init__(self,make,model,year):
        #初始化描述汽车的属性
        self.make=make
        self.model=model
        self.year=year
        #为odometer_reading指定默认值为0
        self.odometer_reading=0
```

由于Python并不是一个像C#或Java那种对面向对象有着严格要求的语言，Python相对来说更加的松散和灵活，它没有那么多的限制，（例如C#中的私有成员（`private`）），在Python中，可以对实例的所有属性进行读写操作，大量的直接对实例属性读写操作很容易导致混乱，因此在实际开发中，强烈建议，使用类中的方法去操作属性，而尽量避免直接使用实例名给属性赋值。



## 继承

一个类继承另一个类时，它将自动获得另一个类的所有属性和方法；原有的类称为父类，而新类称为子类。子类继承了其父类的所有属性和方法，同时还可以定义自己的数学和方法。

#### 子类的方法`__init__()`

创建子类的实例时，Python首先需要完成的任务是给父类的所有属性赋值。因此，需要在子类的`__init__()`方法中调用父类的`__init__()`方法，为此需要使用`super()`特殊函数。另外，还需要在子类定义时，指明要继承的父类。

```python
class ElectricCar(Car):
    def __init__(self, make, model, year):
        super().__init__(make, model, year)
```

在Python中使用继承需要注意以下几点：

- 由于Python是一种解释型语言，类似于Javascript，因此在创建子类时，父类必须包含在当前文件中，且位于子类前面。在定义子类时，必须在括号内指定父类的名称。
- 为了实现父类和子类的关联，需要在子类的`__init__()`方法中使用`super().__init__()`语句，使子类包含父类的所有属性。

#### 重写父类的方法

可以在子类中定义一个和父类方法同名的方法实现重写。Python将会忽略父类中的方法，只关注子类定义的同名方法。

#### 补充

Python也可以像其它于语言一样，将一个类的对象作为另一个类的成员属性进行使用。



## 导入类

Python允许将类存储在模块中，然后在主程序中导入所需的模块。

#### 导入单个类

首先将单个类存储在单个模块（`.py`文件）中，类名和模块文件名不必保持一致，一般类名的首字母大写，但是模块名使用下划线连接各个词组并且全是小写。然后使用导入模块的语句导入单个类。

例如，`Car`类在`car.py`模块文件中，可以使用下述语句导入`Car`类：

```python
from car import Car
#使用Car类
my_new_car=Car('audi','a4','2016')
```

#### 在一个模块中存储多个类并导入

一个`.py`文件对应一个模块，可以根据需要在一个模块中定义多个类，注意：为了便于阅读，应该尽量包含该类的说明注释。接着，就可以使用下述语句导入该模块中需要使用到的一个类或多个类。导入多个类时，用逗号分隔各个类，之后就可以直接使用这些导入的类。

```python
from car import Car,ElectricCar
```

#### 导入整个模块

可以直接导入整个模块，然后使用句点表示法访问需要访问的类，`模块名.类名`

```python
import car
my_beetle=car.Car('test','wy','12')
```

#### 导入模块中所有的类（不推荐）

```python
from module_name import *
```

需要从一个模块中导入很多类时，最好导入整个模块，并使用`module_name.class_name`的形式访问类。

#### 在一个模块中导入另一个模块

可以在需要使用的模块中使用多条导入语句进行导入。例如：

```python
from car import Car
from electric_car import ElectricCar
```



## 类编码格式说明

- 类名采用驼峰命名法，即类名中的每个单词的首字母都大写，而不使用下划线。实例名和模块名都采用小写格式，并且在单词之间使用下划线连接。
- 类在定义时，应在类定义后面包含一个文档字符串（使用`"""`包裹的字符串），用来描述类的功能。
- 在类中，可以使用一个空行来分割方法；在模块中，可以使用两个空行来分隔类。
- 需要同时导入标准库中的模块和自己编写的模块时，应该先编写导入标准库模块的`import`语句，再添加一个空行，然后编写导入自己模块的`import`语句。



------



#### 参考资源

- 《Python编程：从入门到实践》

 

本文后续会随着知识的积累不断补充和更新，内容如有错误，欢迎指正。

最后一次更新时间：2018-08-13

------


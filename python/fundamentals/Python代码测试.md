# Python代码测试

对于编写的代码，可以使用`unittest`模块中的相关方法进行测试。

## 测试函数

首先定义一个简单的函数，该函数用来合并名称并返回。

`name_function.py`：

```python
def get_fromatted_name(first,last):
    """组合姓名并返回"""
    full_name=first+' '+last
    return full_name.title()
```

接着编写测试代码，需要先导入`unittest`模块。然后创建一个测试类，用于包含对上述函数的单元测试，这个类必须继承`unittest.TestCase`类。

`test_name_function.py`：

```python
#导入模块和要测试的函数
import unittest
from name_function import get_fromatted_name

#编写测试类，必须继承自unittest.TestCase
class NamesTestCase(unittest.TestCase):
    """测试name_function.py"""

    #测试方法
    def test_first_last_name(self):
        """能够正确的处理Python Java这样的名字吗？"""
        formatted_name=get_fromatted_name('python','java')
        #调用断言方法用来核实得到的结果是否与期望值结果一致
        self.assertEqual(formatted_name,'Python Java')

#运行测试
unittest.main()
```

上述中最重要的是调用`TestCase`类的`assertEqual()`断言方法，用来核实代码执行结果和预期结果是否一致。

注意：当编写测试类时，除了需要继承`unittest.TestCase`外，测试类中的测试方法必须以`test_`开头，这样在调用`unittest.main()`方法时，这些以`test_`开头的方法才会自动运行。





## unittest.TestCase类的断言方法

断言方法检查你认为应该满足的条件是否确实满足。如果该条件确实满足，你对程序行为的假设就得到了确认，你就可以确信其中没有错误。如果你认为应该满足的条件实际上并不满足，Python将引发异常。

| 方法                     | 用途                   |
| ------------------------ | ---------------------- |
| `assertEqual(a,b)`       | 核实`a==b`             |
| `assertNotEqual(a,b)`    | 核实`a!=b`             |
| `assertTrue(x)`          | 核实`x`为`True`        |
| `assertFalse(x)`         | 核实`x`为`False`       |
| `assertIn(item,list)`    | 核实`item`在`list`中   |
| `assertNotIn(item,list)` | 核实`item`不在`list`中 |



## 测试类

首先定义一个简单的类，接着对这个类编写测试代码。

```python
class AnonymousSurvey():
    """收集匿名调查问卷的答案"""
    def __init__(self,question):
        #存储一个问题，并为存储答案做准备
        self.question=question
        self.responses=[]

    def show_question(self):
        #显示调查问卷
        print(self.question)

    def store_response(self,new_response):
        self.responses.append(new_response)

    def show_results(self):
        print("答案：")
        for response in self.responses:
            print('-'+response)
```

测试类和测试函数类似，核心都是应用断言方法来实现的。

```python
import unittest
from survey import AnonymousSurvey

class TestAnonyousSurvey(unittest.TestCase):
    """对类AnonymousSurvey进行测试"""

    def setUp(self):
        question="你对什么语言感兴趣？"
        self.my_survey=AnonymousSurvey(question)
        #设定程序回答的答案
        self.responses=["java","python","c#"]
    
    #方法以test_开头
    def test_store_three_response(self):
        for response in self.responses:
            self.my_survey.store_response(response)
        for response in self.responses:
            self.assertIn(response,self.my_survey.responses)
unittest.main()
```



#### setUp()方法

`unittest.TestCase`类包含方法`setUp()`，让我们只需创建这些对象一次，就可以在每个测试方法中使用它们。

如果你在自己的测试类中重写了`setUp()`方法，python将先运行它，再运行各个以`test_`开头的方法。这样，在你编写的每个测试方法中都可使用在方法`setUp()`中创建的对象了。

```python
import unittest
from survey import AnonymousSurvey

class TestAnonyousSurvey(unittest.TestCase):
    """对类AnonymousSurvey进行测试"""

    def setUp(self):
        question="你对什么语言感兴趣？"
        self.my_survey=AnonymousSurvey(question)
        #设定程序回答的答案
        self.responses=["java","python","c#"]
    
    #方法以test_开头
    def test_store_three_response(self):
        for response in self.responses:
            self.my_survey.store_response(response)
        for response in self.responses:
            self.assertIn(response,self.my_survey.responses)
unittest.main()
```



## 总结

python代码单元测试，需要使用`unittest`模块，尤其是其中的`TestCase`类及其断言方法。

在编写测试代码时，需要自定义一个测试类，并且继承自`unittest.TestCase`。

所有编写的测试方法都必须以`test_`开头，这样在调用`unittest.main()`方法后，才能自动执行。

如果需要在不同的测试方法中使用同一个对象，可以考虑在类中重写`setUp()`。

断言方法用于验证程序运行的值和期望值（一般是写死的值）是否一致，从而反馈测试的结果。





------



#### 参考资源

- 《Python编程：从入门到实践》

 

本文后续会随着知识的积累不断补充和更新，内容如有错误，欢迎指正。

最后一次更新时间：2018-08-23

------


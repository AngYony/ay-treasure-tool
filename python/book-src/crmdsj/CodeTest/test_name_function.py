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

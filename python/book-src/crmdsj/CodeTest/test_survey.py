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

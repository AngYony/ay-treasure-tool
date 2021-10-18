from survey import AnonymousSurvey

#定义一个问题
question="你喜欢python吗？"
my_survey=AnonymousSurvey(question)

#显示问题并存储答案
my_survey.show_question()
response=input("请输入答案：")
my_survey.store_response(response)

#显示结果
my_survey.show_results()

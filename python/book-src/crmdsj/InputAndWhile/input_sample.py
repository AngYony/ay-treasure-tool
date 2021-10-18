#input()示例
myname=input("请输入你的姓名：")
myage=input("请输入你的年龄：")
if int(myage)>18:
    print('恭喜你，'+myname+",你已经长大了，你的年龄是"+myage+'岁')
else:
    print('抱歉，你还未成年！')

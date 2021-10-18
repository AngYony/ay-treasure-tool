#异常处理else代码块
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
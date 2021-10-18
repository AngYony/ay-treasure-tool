filename='test.txt'
#写入空文件
with open(filename,'w') as file_obj:
    file_obj.write('hello python!')

#写入多行
with open(filename,'w') as file_obj2:
    file_obj2.write('java \n')
    file_obj2.write('python \n')

#附加到文件
with open(filename,'a') as file_obj3:
    file_obj3.write('one \n')
    file_obj3.write('two \n')


异常处理
try:
    print(5/0)
except ZeroDivisionError:
    print('被除数不能为0')


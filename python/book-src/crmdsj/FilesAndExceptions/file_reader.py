#读取整个文件
with open('pi_digits.txt') as file_object:
    contents=file_object.read()
    #去除多余空白
    #print(contents.rstrip())

#逐行读取
#with open('pi_digits.txt') as file_object2:
#    for line in file_object2:
#        print(line)

#创建包含文件各行内容的列表
with open('pi_digits.txt') as file_object3:
    #从文件中读取每一行，并将其存储在一个列表中
    lines=file_object3.readlines()
#在with代码块的外面读取该列表
for line in lines:
    print(line.rstrip())
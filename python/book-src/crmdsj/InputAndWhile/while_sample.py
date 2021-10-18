#while示例
index=1
while index<=5:
    print(index)
    index+=1 #python中没有++运算符，请谨慎使用


status=True
result=80
num=input('请输入任意一个数字：')
while status:
    if int(num)>100:
        print('不和你玩了，break一下！')
        break;
    if(result>int(num)):
        num=input('该数字比你输入的大，请再次输入：')
    elif(result<int(num)):
        num=input('该数字比你输入的小，请再次输入：')
    else:
        status=False
        print('恭喜你猜对了！')


#使用while循环处理列表
mylist=['python','java','csharp']
newlist=[]
while mylist:
    item=mylist.pop() #得到并删除列表末尾元素
    newlist.append(item)
print(mylist)
print(newlist)

#删除包含特定值的所有列表元素
mylist=['php','go','java','go','java','python','java']
#remove()一次只能删除一个元素
mylist.remove('java')
print(mylist)
while 'java' in mylist:
    mylist.remove('java')
print(mylist)
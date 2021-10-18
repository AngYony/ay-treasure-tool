#定义一个集合
mylist=['python','java','dotnet']
print(mylist)
print('第一个元素:'+mylist[0])
print('第三个元素:'+mylist[2])
print('最后一个元素：'+mylist[-1])
print('倒数第二个元素：'+mylist[-2])

#修改元素
mylist[0]='php'
print(mylist)

#将元素添加到列表末尾
mylist.append('javascript')
print(mylist)
#在第二个元素之前插入
mylist.insert(1,'C++')
print(mylist)
#删除指定索引位置的元素
del mylist[1]
mylist.append('go')
mylist.pop(1)
print(mylist)
#删除列表中指定值的元素
mylist=['csharp','python','java','php','go']
mylist.remove('java')
print(mylist)

#列表排序
#永久性排序
mylist=['python','node.js','java','go','php','csharp']
mylist.sort()
print(mylist)
#临时性排序
arr=sorted(mylist)
print(arr)
print(mylist)
#永久性的反转元素的排列顺序
mylist.reverse()
print(mylist)
#获取长度
len(mylist)
#遍历列表
for s in mylist:
    print(s)
#数值列表
for value in range(1,5):
    print(value)
#设置步长
for value in range(2,11,4):
    print(value)

#数值列表的统计计算
nums=[2,5,1,6]
print(min(nums))
print(max(nums))
print(sum(nums))

#列表解析
mylist=[v+3 for v in range(2,4)]
print(mylist)
nlist=[str(n)+'w' for n in mylist]
print(nlist)

#列表切片
mylist=['csharp','python','java','php','go']
#用法一
print(mylist[1:3])
#用法二
print(mylist[:3])
#用法三
print(mylist[1:])
#输出最后三个元素
print(mylist[-3:])
#输出倒数第三个和倒数第二个元素
print(mylist[-3:-1])
#输出最后三个元素时，第二个参数不能指定为0（将会得不到任何结果）
print(mylist[-3:0])
for p in mylist[:4]:
    print(p)

#复制一个全新的列表
copy_list=mylist[:]
print(copy_list)

#元组的使用
mytuple=(10,20,30)
for t in mytuple:
    print(t)


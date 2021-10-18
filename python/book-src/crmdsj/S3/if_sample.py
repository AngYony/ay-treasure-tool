mylist=["java","csharp","python","php","go"]
for item in mylist:
    if item=='python':
        print("这是python")
    if item!='php':
        print(item+"不是php")
    if len(item)>2 and len(item)<=4:
        print('字符串长度大于2并且小于等于4:'+item)
    if len(item)==2 or len(item)==5:
        print('字符串长度为2或5：'+item)
    #判断某个元素是否在列表中
    if 'node.js' in mylist:
        print('node.js在集合中')
    #判断某个元素是否不包含在列表中
    if 'node.js' not in mylist:
        print('node.js不在列表中')


if 布尔表达式A:
    代码块A
elif 布尔表达式B:
    代码块B
else:
    代码块C
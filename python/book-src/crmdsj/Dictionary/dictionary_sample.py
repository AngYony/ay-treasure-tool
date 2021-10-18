mydic={'name':'小明','age':18,'sex':'男'}
#获取name的值
name=mydic['name']
#添加新的键值对
mydic['mail']='xiaoming@163.com'
#修改值
mydic['name']='小华'
#删除值
del mydic['mail']
print(mydic)
#遍历所有的键值对
for k,v in mydic.items():
    print('k:'+str(k)+'\t v:'+str(v))
#遍历所有的键
for k in mydic.keys():
    print(k)
#遍历字典时，默认会遍历所有的键，上述语句等同于该语句
for k in mydic:
    print(k)
#排序遍历
for k in sorted(mydic):
    print(k)
#遍历所有值
for v in mydic.values():
    print(v)
#set()去重
dic={'name1':'小明','name2':'小明','name3':'小华'}
print(set(dic.values()))
for v in set(dic.values()):
    print(v)

#字典列表
dic1={'name':'小明','age':18,'sex':'男'}
dic2={'name':'小芳','age':15,'sex':'女'}
dic3={'name':'小米','age':25,'sex':'男'}
diclist=[dic1,dic2,dic3]
print(diclist)
for dic in diclist:
    print(dic)

#字典中存储列表 
dic= {
    'name':'编程语言',
    'type':['python','c#','java']
    }
for t in dic['type']:
    print(t)

#字典中存储字典
mydic={
    'student':{
        'stuname':'小明','stuage':18
        },
    'class':{
        'classname':'一班','teacher':'陈老师'
        }
    }
for k,v in mydic.items():
    for lk ,lv in v.items():
        print(lk+'\t'+str(lv))
   
def myfun():
    """方法体内容"""
    print("这是新定义的方法！");
#调用该方法
myfun()

def hello(name):
    print("hello,"+name)

#调用带参函数
hello("张三")

def myfun(name="python"):
    print("hello,"+name)
#调用带默认值的参数函数
myfun()
#位置实参的应用
def myfun(par1,par2,par3):
    print("par1="+par1)
    print("par2="+par2)
    print("par3="+par3)
#调用
myfun("A","B","C")

#关键字实参调用
myfun(par3="A",par1="B",par2="C")

#函数返回值
def myname(first_name,last_name,middle_name=''):
    
    if middle_name:
        full_name=first_name+' '+middle_name+' '+last_name
    else:
        full_name= first_name+ ' '+last_name
    return full_name.title()

name=myname('ma','yun')
hello(name)

#传递任意数量的实参
def show_string(*strs):
    print(strs)
    for str in strs:
        print(str)
show_string("B","C")

def show_student_info(name,**stus):
    group={}
    group["name"]=name
    for key,value in stus.items():
        group[key]=value
        print(key+":"+value)
    return group
#调用
mygroup=show_student_info('小明',age='18',sex='男')
print(mygroup)


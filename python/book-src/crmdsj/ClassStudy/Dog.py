class Dog(object):
    """类的定义和使用"""
    def __init__(self,name,age):
        #初始化属性name和age
        self.name=name
        self.age=age

    def sit(self):
        print(self.name.title()+"执行sit命令")

    def roll_over(self):
        print(self.name.title()+"执行roll_over命令")

my_dog=Dog("旺财","3")
print(my_dog.age)
print(my_dog.name)
my_dog.sit()
my_dog.roll_over()



class Car(object):
    def __init__(self,make,model,year):
        #初始化描述汽车的属性
        self.make=make
        self.model=model
        self.year=year
        self.odometer_reading=0

    def get_descriptive_name(self):
        #返回描述性信息
        long_name=str(self.year)+' '+ self.make+' '+self.model
        return long_name.title()

class ElectricCar(Car):
    def __init__(self, make, model, year):
        super().__init__(make, model, year)

#调用类成员
my_tesla=ElectricCar('audi','a4','2016')
print(my_tesla.get_descriptive_name())

        


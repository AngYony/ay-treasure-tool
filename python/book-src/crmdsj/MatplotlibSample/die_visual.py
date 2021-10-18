import pygal
from die import Die

#创建D6（面数为6）骰子
die_1=Die()
#创建面数为10的骰子
die_2=Die(10)

#投掷几次骰子，并将结果存储在一个列表中
results=[]

for roll_num in range(50000):
    result=die_1.roll()+die_2.roll()
    results.append(result)
 
#分析结果，用于存储每种点数出现的次数
frequencies=[]

#存储最大点数，最大点数应该是6+6=12
max_result=die_1.num_sides+die_2.num_sides
for value in range(2,max_result+1):
    #计算每个点数出现的次数
    frequency=results.count(value)
    frequencies.append(frequency)

#绘制直方图，对结果进行可视化
hist=pygal.Bar()

#设置用于标示直方图的字符串
hist.title="Results of rolling one D6 1000 times."
#存储可能出现的结果，最大为10+6=16
hist.x_labels=['2','3','4','5','6','7','8','9','10','11','12','13','14','15','16']
hist.x_title="Result"
hist.y_title="Frequency of Result"
#使用add()将一系列值添加到图表中
#（向它传递要给添加的值指定的标签，还有一个列表，其中包含将出现在图表中的值）
hist.add('D6+D10',frequencies)
#将这个图表渲染为一个SVG文件，这种文件的扩展名必须为.svg
hist.render_to_file('die_visual.svg')

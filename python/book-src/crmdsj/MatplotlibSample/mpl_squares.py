#coding:utf-8 
import matplotlib.pyplot as plt

input_values=[1,2,3,4,5]

#创建一个列表，存储的值来自于对应下标的平方数
squares=[1,4,9,16,25]

# 绘制图形，并设置线条宽度
plt.plot(input_values,squares,linewidth=5)

#设置图表标题
plt.title("Square Numbers",fontsize=24)
# 为X轴设置标题和字体大小
plt.xlabel("Value",fontsize=14)
# 为Y轴设置标题和字体大小
plt.ylabel("Square of Value",fontsize=14)

# 设置刻度标记的大小
plt.tick_params(axis='both',labelsize=14)

#打开matplotlib查看器，并显示绘制的图形
plt.show()

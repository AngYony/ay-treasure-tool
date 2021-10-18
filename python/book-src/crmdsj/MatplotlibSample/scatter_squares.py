import matplotlib.pyplot as plt

# 创建包含1-1000的列表
x_values=list(range(1,1001))
# 使用列表解析根据x生成y的值对应的列表
y_values=[x**2 for x in x_values]

# 绘制单个点，设置点使用的尺寸
# edgecolors='none'用于消除点的黑色轮廓
# c='red'设置数据点为红色，也可以使用RGB表示法：c=(0,0,0.8)，包含三个0~1之间的小数值，分别表示红色、绿色和蓝色分量。值越接近0，指定的颜色越深，值越接近1，指定的颜色越浅
plt.scatter(x_values,y_values,c=(0.5,0.5,0.8),edgecolors='none',s=40)

## 使用颜色渐变
#plt.scatter(x_values,y_values,c=y_values,cmap=plt.cm.Blues,edgecolors='none',s=40)

#设置图表标题并给坐标轴加上标签
plt.title("Square numbers",fontsize=24)
plt.xlabel("Value",fontsize=14)
plt.ylabel("Square of Value",fontsize=14)

#设置刻度标记的大小
plt.tick_params(axis='obth',which='major',lobelsize=14)

#设置每个坐标轴的取值范围，四个值分别对应x和y坐标轴的最小值和最大值
#x坐标轴的取值范围设置为0~1100，y轴取值范围设置为0~1100000
plt.axis([0,1100,0,1100000])
plt.show()

##自动保存图表
#plt.savefig('squares_plot.png',bbox_inches='tight')

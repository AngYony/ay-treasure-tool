import csv
from datetime import datetime
from matplotlib import pyplot as plt

filename='sitka_weather_2014.csv'
#打开文件并将结果文件对象存储在f中
with open(filename) as f:
    #创建一个与该文件相关联的reader对象
    reader=csv.reader(f)
    #只调用一次next()方法，得到文件的第一行，将第一行数据中的每一个元素存储在列表中
    header_row=next(reader)
    
    #用于分别保存日期和最高气温，最低气温的列表
    dates,highs,lows=[],[],[]
    #遍历文件中余下的各行
    #reader对象从其当前所在的位置继续读取CSV文件，每次都自动返回当前所处位置的下一行
    for row in reader:
        try:
            #将包含日期信息的数据（row[0])转换为datetime对象
            current_date=datetime.strptime(row[0],"%Y-%m-%d")
            #转换为数字，便于后面让matplotlib能够读取它们
            high=int(row[1])
            #读取最低气温
            low=int(row[3])
        except ValueError:
            print(current_date,'missing data')
        else:
            dates.append(current_date)
            highs.append(high)
            lows.append(low)

#根据数据绘制图形
fig=plt.figure(dpi=128,figsize=(10,6))
#将数据集传给绘图对象，并将数据点绘制为红色（表示最高气温）
#plt.plot(highs,c='red')
#同时将日期和最高气温列表传递给plot(),alpha指定颜色的透明度
plt.plot(dates,highs,c='red',alpha=0.5)
#使用蓝色绘制最低气温
plt.plot(dates,lows,c='blue',alpha=0.5)
plt.fill_between(dates,highs,lows,facecolor='blue',alpha=0.1)

#设置图形的格式
#这是字体大小和标签
plt.title("Daily high and low temperatures-2014",fontsize=24)
plt.xlabel('Date',fontsize=16)
#为了避免X轴日期显示彼此重叠，调用该方法，将以倾斜的形式显示日期标签
fig.autofmt_xdate()

#设置标签
plt.ylabel("Temperature (F)",fontsize=16)
plt.tick_params(axis='both',which='major',labelsize=16)

plt.show()

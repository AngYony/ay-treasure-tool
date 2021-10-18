import json
import pygal.maps.world
from country_codes import get_country_code
#from pygal.style import LightColorizedStyle,RotateStyle
from pygal.style import LightColorizedStyle as LCS, RotateStyle as RS


#将数据加载到一个列表中
filename='population_data.json'
with open(filename) as f:
    #加载JSON数据到列表pop_data中
    pop_data=json.load(f)
  
#创建一个包含人口数量的字典
cc_populations={}

#打印每个国家2010年的人口数量
for pop_dict in pop_data:
    #遍历pop_data中的每个元素，每个元素都是一个字典，包含4个键值对
    #获取字典对应键的值
    if pop_dict['Year']=='2010':
        country_name=pop_dict["Country Name"]
        #将字符串转换为数字
        population=int(float(pop_dict['Value']))
        code=get_country_code(country_name)
        if code:
            cc_populations[code]=population
        #else:
        #    print("ERROR - "+country_name)

#根据人口数量将所有国家分成三组，每组都是独立的字典
cc_pops_1,cc_pops_2,cc_pops_3={},{},{}
#遍历每个国家的人口数量
for cc,pop in cc_populations.items():
    if pop<10000000:
        cc_pops_1[cc]=pop
    elif pop<100000000:
        cc_pops_2[cc]=pop
    else:
        cc_pops_3[cc]=pop

#输出每组分别包含多少个国家
print(len(cc_pops_1),len(cc_pops_2),len(cc_pops_3))

#设置地图基于的基色和图表的主题，包括背景色、标签以及各个国家的颜色
#wm_style = RotateStyle('#336699')
wm_style = RS('#336699',base_style=LCS)
wm = pygal.maps.world.World(style= wm_style)
wm.title = 'World Population in 2010, by Country'

# 传递由国别码和人口数量组成的字典
#wm.add('2010', cc_populations)
#将分组后的字典传递给add()方法，这里调用了三次add()方法，将使用三种不同的颜色显示，
#同一组中的不同国家，将按照人口数量从少到多，从浅到深的显示该颜色
wm.add('0-10m', cc_pops_1)
wm.add('10m-1bn', cc_pops_2)
wm.add('>1bn', cc_pops_3)

wm.render_to_file('world_population.svg')
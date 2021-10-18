import pygal.maps.world

#创建地图对象
wm = pygal.maps.world.World()
#设置地图title
wm.title='North,Central,and South America'
#添加一组标签和国别码列表，列表中的国别码对应的国家将会以同一种颜色显示
wm.add('North Aerica',['ca','mx','us'])
wm.add('Central Americal',['bz','cr','gt','hn','ni','pa','sv'])
wm.add('South America',['ar','bo','br','cl','co','ec','gf','gy','pe','py','sr','uy','ve'])
#创建一个包含该图表的.svg文件
wm.render_to_file('americas.svg')
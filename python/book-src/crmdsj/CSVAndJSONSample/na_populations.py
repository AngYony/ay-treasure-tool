import pygal.maps.world

wm = pygal.maps.world.World()
wm.title='Populations of Countries in North America'
#为方法传递一个字典，将会根据这些数字自动给不同国家着以深浅不一的颜色
wm.add('North America', {'ca': 34126000, 'us': 309349000, 'mx': 113423000})
wm.render_to_file('na_populations.svg')

import requests
import pygal
from pygal.style import LightColorizedStyle as LCS, LightenStyle as LS

#执行API调用并存储响应
url='https://api.github.com/search/repositories?q=language:python&sort=stars'
# 调用url，将响应对象存储在变量r中
r=requests.get(url)
# 查看请求返回的http 状态码，200表示请求成功
print("Stauts Code",r.status_code)

# 使用json()将API的响应信息（json格式）转换为一个Python字典或JSON对象
response_dict=r.json()
# 获取GitHub包含的Python库数量
print("Total repositories:",response_dict["total_count"])

#探索有关仓库的信息，items是由多个字典组成的列表，每一个字典包含一个仓库信息
repo_dicts=response_dict['items']
#print("Repositories returned:",len(repo_dicts))
## 创建两个空列表存储包含在图表中的信息，名称用于条形图表的标签，星的数量用于确定条形图表的高度
#names,stars=[],[]
# plot_dicts用于添加自定义工具提示
names,plot_dicts=[],[]


for repo_dict in repo_dicts:
    names.append(repo_dict["name"])
    # 并不是每个节点一定有description，所以加if判断
    if repo_dict["description"]:
        plot_dict={
        # Pygal根据与键'value'相关联的数字来确定条形的高度
        'value':int(repo_dict["stargazers_count"]),
        # 使用与'label'相关联的字符串给条形创建工具提示
        'label':repo_dict["description"],
        # 为条形图表添加可点击的链接
        'xlink': repo_dict['html_url'],
        }
        plot_dicts.append(plot_dict)

#可视化，定义样式，将其基色设置为深蓝色，并传入LightColorizedStyle
my_style=LS('#333366',base_style=LCS)

my_config = pygal.Config()
# 表示让标签绕x轴旋转45度
my_config.x_label_rotation = 45
# 表示隐藏了图例
my_config.show_legend = False
# 图表标题字体大小
my_config.title_font_size = 24
# 副标签字体大小，包括x轴上的项目名以及y轴上的大部分数字
my_config.label_font_size = 14
# 主标签字体大小，y轴上为5000整数倍的刻度
my_config.major_label_font_size = 18
# 将较长的项目名缩短为15个字符
my_config.truncate_label = 15
# 隐藏图表中的水平线
my_config.show_y_guides = False
# 设置了自定义宽度
my_config.width = 1000

# 使用Bar()创建一个简单的条形图
# x_label_rotation=45：表示让标签绕x轴旋转45度
# show_legend=False：表示隐藏了图例
# chart=pygal.Bar(style=my_style,x_label_rotation=45,show_legend=False)
# 将上述的配置进行改进，分装为一个my_config对象
# 传递配置设置
chart=pygal.Bar(my_config,style=my_style)
chart.title="Most-Starred Python Projects on GitHub"
chart.x_labels=names

# 暂不需要添加标签
#chart.add('',stars)
# 添加工具提示需要的字典列表
chart.add('',plot_dicts)
chart.render_to_file("python_repos.svg")


#print("\nSelected information about each repository:")
## 循环遍历获取每一个仓库的详细信息
#for repo_dict in repo_dicts:
#    # 项目名称
#    print('\nName:', repo_dict['name'])
#    # 键owner来访问表示所有者的字典，再使用键key来获取所有者的登录名。
#    print('Owner:', repo_dict['owner']['login'])
#    print('Stars:', repo_dict['stargazers_count'])
#    print('Repository:', repo_dict['html_url'])
#    print('Created:', repo_dict['created_at'])
#    print('Updated:', repo_dict['updated_at'])
#    print('Description:', repo_dict['description'])
    

import json
from country_codes import get_country_code

filename = 'population_data.json'
with open(filename) as f:
    # 将数据加载到一个列表中
    pop_data = json.load(f)
    # 打印每个国家2010年的人口数量
    for pop_dict in pop_data:
        # 遍历pop_data中的每个元素，每个元素都是一个字典，包含4个键值对
        if pop_dict['Year'] == '2010':
            country_name = pop_dict['Country Name']
            #将人口数量由字符串转换为数字值
            #由于在JSON文件中，含有小数部分，这里只需要保留整数，因此需要先转换为浮点数，再转换为整数，将自动丢弃小数部分
            population =int(float( pop_dict['Value']))
            code = get_country_code(country_name)
            #如果有国别码就显示国别码和人口数量
            if code:
                print(code + ": "+ str(population))
            else:
                print('ERROR - ' + country_name)
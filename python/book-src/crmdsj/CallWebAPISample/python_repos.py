import requests

#执行API调用并存储响应
url='https://api.github.com/search/repositories?q=language:python&sort=stars'
# 调用url，将响应对象存储在变量r中
r=requests.get(url)
# 查看请求返回的http 状态码，200表示请求成功
print("Stauts Code",r.status_code)

# 使用json()将API的响应信息（json格式）转换为一个Python字典或JSON对象
response_dict=r.json()

#处理结果
print(response_dict.keys())
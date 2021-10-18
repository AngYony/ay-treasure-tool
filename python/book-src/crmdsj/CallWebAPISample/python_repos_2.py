import requests

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
print("Repositories returned:",len(repo_dicts))

##研究第一个仓库
#repo_dict=repo_dicts[0]

#print("\nKeys:",len(repo_dict))
#for key in sorted(repo_dict.keys()):
#    print(key)

print("\nSelected information about each repository:")
# 循环遍历获取每一个仓库的详细信息
for repo_dict in repo_dicts:
    # 项目名称
    print('\nName:', repo_dict['name'])
    # 键owner来访问表示所有者的字典，再使用键key来获取所有者的登录名。
    print('Owner:', repo_dict['owner']['login'])
    print('Stars:', repo_dict['stargazers_count'])
    print('Repository:', repo_dict['html_url'])
    print('Created:', repo_dict['created_at'])
    print('Updated:', repo_dict['updated_at'])
    print('Description:', repo_dict['description'])
    

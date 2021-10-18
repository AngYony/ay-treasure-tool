import json

username=input("what's you name?")

filename="username.json"
with open(filename,'w') as f_obj:
    json.dump(username,f_obj)
    print('您的姓名已经写入')
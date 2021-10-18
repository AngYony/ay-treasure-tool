filename='alice.txt'
try:
    with open(filename) as f_obj:
        contents=f_obj.read()
except FileNotFoundError:
    print('文件找不到！')

from name_function import get_fromatted_name
print("输入'q'退出程序")
while True:
    first=input("请输入firstName:")
    if first=='q':
        break
    last=input("请输入LastName:")
    if last=='q':
        break

    full_name=get_fromatted_name(first,last)
    print(full_name)



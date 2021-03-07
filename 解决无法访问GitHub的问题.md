# 解决无法访问GitHub的问题  

访问GitHub时会出现如下《无法访问此网站》

 解决方法： 访问IP查询网址：[ www.Github.com Website statistics and traffic an...](https://github.com.ipaddress.com/www.github.com)  

修改HOSTS文件，

位置：C:Windows/system32/drivers/etc， 

Mac:位置 /etc/hosts 

```
xxxx.xxxx.xxxx.xx github.com
xxxx.xxxx.xxxx.xx www.github.com
```

 IP地址改为查询网址中的地址，然后保存即可访问。

cmd中输入ipconfig/flushdns刷新dns。

 
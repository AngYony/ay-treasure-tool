# CentOS 安装 .NET Core 并部署到 Nginx

参考链接：

- [在 CentOS 上安装 .NET Core SDK 或 .NET Core 运行时](https://docs.microsoft.com/zh-cn/dotnet/core/install/linux-centos)
- [在 Linux 上安装 .NET Core](https://docs.microsoft.com/zh-cn/dotnet/core/install/linux)
- [使用 Nginx 在 Linux 上托管 ASP.NET Core](https://docs.microsoft.com/zh-cn/aspnet/core/host-and-deploy/linux-nginx?view=aspnetcore-2.2#monitor-the-app)

## .NET Core 下载与安装

CentOS 7在安装 .NET 之前，请运行以下命令，将 Microsoft 包签名密钥添加到受信任密钥列表，并添加 Microsoft 包存储库。 打开终端并运行以下命令：

```
sudo rpm -Uvh https://packages.microsoft.com/config/centos/7/packages-microsoft-prod.rpm
```

安装 SDK：

```
sudo yum install dotnet-sdk-3.1
```



## 部署到 Nginx






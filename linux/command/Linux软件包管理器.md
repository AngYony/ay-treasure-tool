# Linux软件包管理器

软件安装
• 软件包管理理器器
• rpm 包和 rpm 命令
• yum 仓库
• 源代码编译安装
• 内核升级
• grub 配置⽂文件

软件包管理理器器
• 包管理理器器是⽅方便便软件安装、卸载，解决软件依赖关系的重要⼯工具
• CentOS、 RedHat 使⽤用 yum 包管理理器器，软件安装包格式为 rpm
• Debian、 Ubuntu 使⽤用 apt 包管理理器器，软件安装包格式为 deb

rpm 包
• rpm 包格式
• vim-common-7.4.10-5.el7.x86_64.rpm
软件名称 软件版本 系统版本 平台

rpm 命令

rpm 命令常⽤用参数
• -q 查询软件包
• -i 安装软件包
• -e 卸载软件包

yum 包管理理器器
• rpm 包的问题
• 需要⾃自⼰己解决依赖关系
• 软件包来源不不可靠
• CentOS yum 源
• http://mirror.centos.org/centos/7/
• 国内镜像
• https://opsx.alibaba.com/mirror

yum 配置⽂文件
• yum 配置⽂文件
• /etc/yum.repos.d/CentOS-Base.repo
• wget -O /etc/yum.repos.d/CentOS-Base.repo
http://mirrors.aliyun.com/repo/Centos-7.rep



yum命令常⽤用选项
• 常⽤用选项
• install 安装软件包
• remove 卸载软件包
• list| grouplist 查看软件包
• update 升级软件包



其他⽅方式安装
• ⼆二进制安装
• 源代码编译安装
• wget https://openresty.org/download/openresty-1.15.8.1.tar.gz
• tar -zxf openresty-VERSION.tar.gz
• cd openresty-VERSION/
• ./configure --prefix=/usr/local/openresty
• make -j2
• make install



升级内核
• rpm 格式内核
• 查看内核版本
• uname –r
• 升级内核版本
• yum install kernel-3.10.0
• 升级已安装的其他软件包和补丁
• yum update



源代码编译安装内核
• 安装依赖包
• yum install gcc gcc-c++ make ncurses-devel openssl-devel elfutils-libelf-devel
• 下载并解压缩内核
• https://www.kernel.org
• tar xvf linux-5.1.10.tar.xz -C /usr/src/kernels



源代码编译安装内核
• 配置内核编译参数
• cd /usr/src/kernels/linux-5.1.10/
• make menuconfig | allyesconfig | allnoconfig
• 使⽤用当前系统内核配置
• cp /boot/config-kernelversion.platform /usr/src/kernels/
linux-5.1.10/.config



源代码编译安装内核
• 查看 CPU
• lscpu
• 编译
• make -j2 all
• 安装内核
• make modules_install
• make install



grub 配置⽂文件
• grub 是什什么
• grub 配置⽂文件
• /etc/default/grub
• /etc/grub.d/
• /boot/grub2/grub.cfg
• grub2-mkconfig -o /boot/grub2/grub.cfg
• 使⽤用单⽤用户进⼊入系统（忘记 root 密码）
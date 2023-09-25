# Linux 内存与磁盘管理



## 内存和磁盘使⽤用率查看

内存使⽤用率查看
• 常⽤用命令介绍
• free
• top



磁盘使⽤用率的查看
• 查看命令
• fdisk
• df
• du
• du 与 ls 的区别





## ext4 ⽂文件系统

常⻅见⽂文件系统
• Linux ⽀支持多种⽂文件系统，常⻅见的有
• ext4
• xfs
• NTFS（需安装额外软件）



ext4 ⽂文件系统
• ext4 ⽂文件系统基本结构⽐比较复杂
• 超级块
• 超级块副本
• i 节点(inode)
• 数据块(datablock)

ext4 ⽂文件系统深⼊入理理解
• 执⾏行行 mkdir 、 touch、 vi 等命令后的内部操作
• 符号链接与硬链接
• facl



## 磁盘配额的使⽤用

⽤用户磁盘配额
• xfs⽂文件系统的⽤用户磁盘配额 quota
• mkfs.xfs /dev/sdb1
• mkdir /mnt/disk1
• mount -o uquota,gquota /dev/sdb1 /mnt/disk1
• chmod 1777 /mnt/disk1
• xfs_quota -x -c ‘report -ugibh’ /mnt/disk1
• xfs_quota -x -c ‘limit -u isoft=5 ihard=10 user1’ /mnt/disk1



## 磁盘的分区与挂载

磁盘分区与挂载
• 常⽤用命令
• fdisk
• mkfs
• parted
• mount
• 常⻅见配置⽂文件
• /etc/fstab





## 交换分区（虚拟内存）的查看与创建

交换分区
• 增加交换分区的⼤大⼩小
• mkswap
• swapon
• 使⽤用⽂文件制作交换分区
• dd if=/dev/zero bs=4M count=1024 of=/swapfile





## 软件 RAID 的使⽤用

RAID 与软件 RAID 技术
• RAID 的常⻅见级别及含义
• RAID 0 striping 条带⽅方式，提⾼高单盘吞吐率
• RAID 1 mirroring 镜像⽅方式，提⾼高可靠性
• RAID 5 有奇偶校验
• RAID 10 是RAID 1 与 RAID 0 的结合
• 软件 RAID 的使⽤用







## 逻辑卷管理理

逻辑卷管理理
• 逻辑卷和⽂文件系统的关系
• 为 Linux 创建逻辑卷
• 动态扩容逻辑卷  



## 系统综合状态查看

系统综合状态查询
• 使⽤用 sar 命令查看系统综合状态
• 使⽤用第三⽅方命令查看⽹网络流量量
• yum install epel-release
• yum install iftop
• iftop -P






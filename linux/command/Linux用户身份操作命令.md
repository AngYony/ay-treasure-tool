# Linux用户身份操作命令

- useradd
- groupadd
- usermod
- passwd
- userdel



------



### useradd 命令

useradd命令用于创建新的用户。

#### 格式

```
useradd [选项] 用户名
```

#### 说明

使用useradd命令创建用户账户时，默认的用户家目录会被存放在/home目录中，默认的Shell解释器为/bin/bash，而且默认会创建一个与该用户同名的基本用户组。

==在Linux系统中创建每个用户时，将自动创建一个与其同名的基本用户组，而且这个基本用户组只有该用户一个人。如果该用户以后被归纳入其他用户组，则这个其他用户组称之为扩展用户组。一个用户只有一个基本用户组，但是可以有多个扩展用户组。==

**用户的基本用户组的组名等于该用户名；在其他用户组的被称为扩展用户组。**

Linux系统中的一切都是文件，因此在系统中创建用户也就是修改配置文件的过程。用户的信息保存在/etc/passwd文件中，可以直接用文本编辑器来修改其中的用户参数项目。

useradd命令中的选项说明：

- `-d`：指定用户的家目录（默认为/home/username）
- `-e`：账户的到期时间，格式为YYYY-MM-DD
- `-u`：指定该用户的默认UID，由管理员创建的普通用户的UID默认是从1000开始的（即使前面有闲置的号码）。（root管理员UID为0，系统用户UID为1～999，Linux系统为了避免因某个服务程序出现漏洞而被黑客提权至整台服务器，默认服务程序会有独立的系统用户负责运行，进而有效控制被破坏范围。）
- `-g`：指定一个初始的用户基本组（必须已存在）（在Linux系统中创建每个用户时，将自动创建一个与其同名的基本用户组，而且这个基本用户组只有该用户一个人。）
- `-G`：指定一个或多个扩展用户组。（如果该用户以后被归纳入其他用户组，则这个其他用户组称之为扩展用户组。一个用户只有一个基本用户组，但是可以有多个扩展用户组。）
- `-N`：不创建与用户同名的基本用户组。
- `-s`：指定该用户的默认Shell解释器。

#### 示例

示例一，创建一个普通用户wynologin，并指定家目录的路径为/home/wynologin、用户的UID为8888，以及Shell解释器为/sbin/nologin：

```shell
[root@localhost ~]# useradd -d /home/wynologin -u 8888 -s /sbin/nologin wynologin
[root@localhost home]# id wynologin
uid=8888(wynologin) gid=8888(wynologin) 组=8888(wynologin)
```

注意：/sbin/nologin解释器与Bash解释器完全不同，一旦用户的解释器被设置为nologin，则代表该用户不能登录到系统中。（因为登录系统使用的是Bash解释器）



------



### groupadd 命令

groupadd命令用于创建用户组。

#### 格式

```
groupadd [选项] 群组名
```

#### 说明

在工作中常常会把几个用户加入到同一个组里面，这样便可以针对一类用户统一安排权限。

#### 示例

示例一，创建用户组testuser：

```shell
[root@localhost ~]# groupadd testuser
```



------



### usermod 命令

usermod 命令用于修改用户的属性。

#### 格式

```
usermod [选项] 用户名
```

#### 说明

Linux系统中的一切都是文件，因此在系统中创建用户也就是修改配置文件的过程。用户的信息保存在/etc/passwd文件中，可以直接用文本编辑器来修改其中的用户参数项目，也可以用usermod命令修改已经创建的用户信息，诸如用户的UID、基本/扩展用户组、默认终端等。

usermod 中的重要参数说明：

- `-c`：填写用户账户的备注信息
- `-d` ` -m`：参数`-m`与参数`-d`连用，可重新指定用户的家目录并自动把旧的数据转移过去
- `-e`：账户的到期时间，格式为YYYY-MM-DD
- `-g`：变更所属用户组（基本组）
- `-G`：变更扩展用户组
- `-L`：锁定用户禁止其登录系统
- `-U`：解锁用户，允许其登录系统
- `-s`：变更默认终端
- `-u`：修改用户的UID

#### 示例

示例一，将用户 zhxy_user 加入到root用户组中：

```shell
[root@localhost VM_AngYony]# usermod -G root zhxy_user
[root@localhost VM_AngYony]# id zhxy_user
uid=8889(zhxy_user) gid=8890(zhxy_user) 组=8890(zhxy_user),0(root)
```

辅助记忆：要修改的用户名放在命令的最后。



------



### passwd 命令

passwd 命令用于修改用户密码、过期时间、认证信息等。

#### 格式

```
passwd [选项] [用户名]
```

#### 说明

普通用户只能使用passwd命令修改自身的系统密码。

而root管理员则有权限修改其他所有人的密码，并且root管理员在Linux系统中修改自己或他人的密码时不需要验证旧密码。

passwd命令中的参数以及作用：

- `-l`：锁定用户，禁止其登录
- `-u`：解除锁定，允许用户登录
- `--stdin`：允许通过标准输入修改用户密码，如echo "NewPassWord" | passwd --stdin Username
- `-d`：使该用户可用空密码登录系统
- `-e`：强制用户在下次登录时修改密码
- `-S`：显示用户的密码是否被锁定，以及密码所采用的加密算法名称

#### 示例

示例一，直接修改自己密码：

```shell
[root@localhost VM_AngYony]# passwd
```

示例二，使用 root 修改其他用户的密码：

```shell
[root@localhost VM_AngYony]# passwd zhxy_user
```

示例三，禁止某用户登录系统（而不是将其删除）：

```shell
[root@localhost VM_AngYony]# passwd -l zhxy_user
锁定用户 zhxy_user 的密码 。
passwd: 操作成功
```

示例四，查看用户的密码是否被锁定：

```shell
[root@localhost VM_AngYony]# passwd -S zhxy_user
zhxy_user LK 2020-10-29 0 99999 7 -1 (密码已被锁定。)
```

示例五，解除用户密码的锁定：

```shell
[root@localhost VM_AngYony]# passwd -u zhxy_user
解锁用户 zhxy_user 的密码。
passwd: 操作成功
[root@localhost VM_AngYony]# passwd -S zhxy_user
zhxy_user PS 2020-10-29 0 99999 7 -1 (密码已设置，使用 SHA512 算法。)
```



------



### userdel 命令

userdel 命令用于删除用户。

#### 格式

```
userdel [选项] 用户名
```

#### 说明

通过 userdel 命令删除该用户的所有信息。在执行删除操作时，该用户的家目录默认会保留下来，此时可以使用-r参数将其删除。

userdel 命令的参数以及作用：

- `-f`：强制删除用户
- `-r`：同时删除用户及用户家目录

#### 示例

示例一，使用 userdel 命令将 wynologin 用户删除：

```shell
[root@localhost home]# userdel -r wynologin
[root@localhost home]# id wynologin
id: wynologin: no such user
```


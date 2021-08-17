## git config

安装好Git后，第一件事就是配置user.name和user.email，在配置之前，可以使用下述命令查看指定作用域的配置信息。

### 查看user.name和user.email

```shell
$ git config --global user.name
wy
$ git config --global user.email
wy@163.com
```

### 配置user.name和user.email

使用以下命令设置使用Git时的姓名和邮箱地址：

```shell
$ git config --global user.name "Firstname Lastname"
$ git config --global user.email "your_email@example.com"
```

这里设置的姓名和邮箱地址会用在 Git 的提交日志中。

GitHub 上连接已有仓库时的认证，是通过使用了 SSH 的公开密钥认证方式进行的。因此，在设置SSH Key时指定的邮箱地址：

```shell
$ ssh-keygen -t rsa -C "your_email@example.com"
```

是代表着身份认证的GitHub账户邮箱地址。 

### config的三个作用域

```shell
$ git config --local
```

local只对某个仓库有效。

```shell
$ git config --global
```

global对当前用户的所有仓库有效。

```shell
$ git config --system
```

system对系统所有登录的用户有效。

### 显示config的配置信息

在git config的基础上，添加--list，如下：

```shell
$ git config --list   # 显示的是所有的配置信息
$ git config --list --global
$ git config --list --local
$ git config --list --system
```



## git init



## git add

`git add`命令用于将工作目录中的变更添加到暂存区中。

```
git add 文件名1 [文件名2] [文件夹名]
```

`git add`命令可以同时添加多个文件或文件夹，下述命令将添加b1.txt文件，和b目录（及其子目录文件）。

```shell
$ git add b1.txt b
```

注意：每次修改了文件时，都需要执行`git add`命令，用于将修改的文件放入暂存区，对于已经放入暂存区的文件，再次修改时，可以不指定文件名，直接使用`-u`将目录中的全部文件再次提交到暂存区。

```shell
$ git add -u
```

## git commit

`git commit`将暂存区的内容提交到版本历史库中。

```shell
$ git commit -m'提交说明'
```

注意：每次`git commit`前，必须使用`git add`命令将修改的文件添加到暂存区，才能提交成功。这和直接使用TortoiseGit工具中的“提交”操作并不相同，TortoiseGit工具中的“提交”=`git add`+`git commit`。

### --amend

使用--amend修改最近一次提交的Message信息。

```shell
$ git commit --amend
```



### -am

也可以直接使用-am，一次性提交更改。相当于是先使用了git add，再做git commit，比较省事，但是不建议这么做，除非特别有把握。

```shell
$ git commit -am'test ssss'
```



## git log

`git log`用于查看git当前分支提交日志。

```
$ git log
```

可以使用`--oneline`选项，将log显示在一行：

```shell
$ git log --oneline
4e9bdb4 (HEAD -> master) 提交内容
24e63f6 修改了文件
b892227 提交新的文件
182ce38 添加了文件
```

使用`-n`选项，只显示最近几条log，例如，显示最近2条log信息，使用`-n2`：

```shell
$ git log -n2 --oneline
4e9bdb4 (HEAD -> master) 提交内容
24e63f6 修改了文件
```

使用`--all`选项，查看所有分支的log信息：

```shell
$ git log --all
```

使用`--graph`选项，以图形化的方式查看log信息。

```shell
$ git log --graph
```

上述的选项可以搭配使用：

```shell
$ git log --all --oneline
$ git log --all --oneline -n2
$ git log --all --oneline -n2 --graph
```

## git status

`git status`用于查看工作目录和暂存区的状态。



## git rm

`git rm`用于将暂存区的文件移除，一旦暂存区的文件移除后，对应的工作区的文件也会移除，类似于删除操作，但它不是真正的从磁盘中删除，而是在版本库中打上了删除的标记。可以使用git reset命令进行恢复。

```shell
$ git rm a1.txt
```

上述命令会将文件a1.txt移除，如果想要恢复移除的文件，可以使用git reset命令，如下：

```shell
$ git reset --hard HEAD
```



## git mv

`git mv`用于重命名已被添加到暂存区的文件。

```shell
git mv 旧文件名 新文件名
```



## git reset

git reset主要用于暂存区的文件恢复操作，将暂存区的内容恢复到工作区。相当于撤销git add操作。

```shell
$ git reset HEAD
```

如果只想恢复指定的文件，可以指定文件名（多个文件之间使用空格隔开）：

```shell
$ git reset HEAD -- a1.txt c1.txt
```

### --hard

--hard选项用于将当前HEAD指向指定的一次Commit，即还原到指定的Commit，它会撤销和丢失当前工作区和暂存区的内容，回退到指定的一次commit状态。

```shell
$ git reset --hard 28b220d
```









## git branch

### -v

使用`-v`查看本地有多少分支：

```shell
$ git branch -v
* master 4e9bdb4 提交内容
```

### -a

加上-a可以查看远程分支，远程分支会用红色表示出来（如果你开了颜色支持的话）：

```shell
$ git branch -av
* master 4e9bdb4 提交内容
```

### -d / -D

使用-d或-D删除指定分支：

```shell
$ git branch -d fix_readme
```



## git checkout

git checkout可用于撤销工作区的变更，即恢复到工作区更改前的状态，相当于还原操作。

示例，还原指定的文件：

```shell
$ git checkout -- a1.txt
```

git checkout命令还用于切换当前分支到指定的分支。

切换到master分支：

```shell
$ git checkout master
```

### -b

使用-b创建并切换到新分支，例如，基于master创建新分支fix_readme：

```shell
$ git checkout -b fix_readme master
```





## gitk

输入gitk命令，可以直接打开gitk工具，以图形化的界面进行git管理。

## git cat-file

使用`git cat-file`命令查看指定哈希值的信息。

### -t

使用`-t`查看类型：

```shell
$ git cat-file -t 4e9bdb48841d
commit
```

常见的类型有：

- tree 
- blob
- commit

上述的`4e9bdb48841d`来自于master分支哈希值：

```shell
$ git branch -av
* master 4e9bdb4 提交内容
```

### -p

使用-p查看具体内容：

```shell
$ git cat-file -p 4e9bdb48841d
tree cd29fd89e4746029700f3115ec8fa6a4d7025f8c
parent 24e63f6de6d013b284d81df637f250ad58d6a715
author wy <wy@163.com> 1571916282 +0800
committer wy <wy@163.com> 1571916282 +0800

提交内容

$ git cat-file -p cd29fd89
100644 blob e69de29bb2d1d6434b8b29ae775ad8c2e48c5391    a1.txt
040000 tree 99081f0c8fb4d66540422c10ae04b00be63716a4    b
100644 blob 8a0dd3a7b3e654dffaafffd5073a579f705fc9eb    c1.txt

$ git cat-file -t e69de29bb
blob
```





## git diff

在不使用任何参数的情况下，git diff用于查看工作区和暂存区之间的差异。

```shell
$ git diff
```

不加任何内容，比较的是工作区中全部的文件。如果只想查看多个文件的差异，可以使用选项的形式进行指定。

示例，查看工作区中的a1.txt、a2.txt文件的差异（多个文件之间，使用空格隔开）：

```shell
$ git diff -- a1.txt a2.txt
```

也可以用于比较两个commit或分支之间的差异.

HEAD：指代当前分支或最近的一次commit。

`HEAD^1`或`HEAD^`或`HEAD~1`：都指代上一级提交。

`HEAD^1^1`或`HEAD^^`或`HEAD~2`：指代上上一级提交。

```shell
$ git diff HEAD HEAD^1
$ git diff HEAD HEAD^
$ git diff HEAD HEAD~1
$ git diff HEAD HEAD^^
```

比较两个分支fix_readme和master之间的差异：

```shell
$ git diff fix_readme master
```

也可以指定具体的文件名，例如笔记这两个分支上的a1.txt文件的差异：

```shell
$ git diff fix_readme master -- a1.txt
```

比较两次commit之间的差异：

```shell
$ git diff 4f066a35a661 28b220d1b95 -- a1.txt
```



### --cached

使用--cached比较暂存区和HEAD之间的差异。

```shell
$ git diff --cached
```





## git rebase（慎用，不推荐使用）

#### 修改已经提交的message

使用git rebase修改任意一次提交的Message信息。

git rebase是变基操作，需要指定父级commit的HashCode，如果不知道父级的commit，可以通过gitk命令查看。

在本示例中，9be33cd401的父级是182ce386c9bb，当要修改9be33cd401的message信息，需要在命令中指定父级182ce386c9bb：

```
 git rebase -i 182ce386c9bb
```

使用上面命令后，将会进入到一个vi交互界面，如下所示：

```shell
pick b892227 提交新的文件
pick 24e63f6 修改了文件
pick b50caeb 修改交sssssssssss

# Rebase 182ce38..b50caeb onto 182ce38 (3 commands)
#
# Commands:
# p, pick <commit> = use commit
# r, reword <commit> = use commit, but edit the commit message
# e, edit <commit> = use commit, but stop for amending
# s, squash <commit> = use commit, but meld into previous commit
# f, fixup <commit> = like "squash", but discard this commit's log message
# x, exec <command> = run command (the rest of the line) using shell
# b, break = stop here (continue rebase later with 'git rebase --continue')
# d, drop <commit> = remove commit
# l, label <label> = label current HEAD with a name

```

找到想要修改的旧的message，将其pick命令改为r，其余保持不变。

本示例只需要修改第一行的pick，将pick改为r即可：

```shell
r b892227 提交新的文件
```

vi保存并退出，将会进入到一个新的vi交互界面：

```shell
提交新的文件

# Please enter the commit message for your changes. Lines starting
# with '#' will be ignored, and an empty message aborts the commit.
#
# Date:      Mon Oct 21 17:59:33 2019 +0800
#
# interactive rebase in progress; onto 182ce38
# Last command done (1 command done):
#    reword b892227 提交新的文件
# Next commands to do (2 remaining commands):
#    pick 24e63f6 修改了文件
#    pick b50caeb 修改交sssssssssss
# You are currently editing a commit while rebasing branch 'fix_readme' on '182ce38'.
#
# Changes to be committed:
#       new file:   b/b2.txt
#       new file:   b1.txt
#

```

在第一行修改新的message信息，vi保存并退出，即可。成功后，显示信息如下：

```shell
[detached HEAD 9be33cd] 修改了新的提交wwwwwwwww
 Date: Mon Oct 21 17:59:33 2019 +0800
 2 files changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 b/b2.txt
```

[detached HEAD 9be33cd]表明这是一个分离头指针，HEAD自动指向了9be33cd对应的commit，并且已经修改了9be33cd提交的message信息。可以再次通过gitk命令进行验证。

需要特别注意的是：` git rebase -i 182ce386c9bb`==指定的是父级commit，而不是本身。==

#### 合并连续的commit的Message信息

和修改任意一次commit的message用法类似，需要指定连续的commit中的最后一个commit对应的父级，可以通过`git log  --graph`命令查看：

```shell
$ git log --graph
* commit 5fec03ffa4fd552ab94c5a13684e40de59352e2c (HEAD -> fix_readme)
| Author: wy <wy@163.com>
| Date:   Thu Oct 24 19:24:42 2019 +0800
|
|     修改交sssssssssss
|
* commit d97bd5b7a72ff882bc5dae40939b0d5a49f394ca
| Author: wy <wy@163.com>
| Date:   Mon Oct 21 18:00:45 2019 +0800
|
|     修改了文件
|
* commit 9be33cd4018083ee5403960db7ee28e601038123
| Author: wy <wy@163.com>
| Date:   Mon Oct 21 17:59:33 2019 +0800
|
|     修改了新的提交wwwwwwwww
|
* commit 182ce386c9bbcf336c5eeb3f91cdf25e3be2199f
  Author: wy <wy@163.com>
  Date:   Mon Oct 21 17:39:05 2019 +0800

      添加了文件

```

可以看到，如果需要合并前三个commit，需要在git rebase命令中，指定最后一次commit（9be33cd40）的父级（182ce386）。

```shell
$ git rebase -i 182ce386
```

将会进入vi交互界面，内容如下：

```shell
pick 9be33cd 修改了新的提交wwwwwwwww
pick d97bd5b 修改了文件
pick 5fec03f 修改交sssssssssss

# Rebase 182ce38..5fec03f onto 182ce38 (3 commands)
#
# Commands:
# p, pick <commit> = use commit
# r, reword <commit> = use commit, but edit the commit message
# e, edit <commit> = use commit, but stop for amending
# s, squash <commit> = use commit, but meld into previous commit
# f, fixup <commit> = like "squash", but discard this commit's log message
# x, exec <command> = run command (the rest of the line) using shell
# b, break = stop here (continue rebase later with 'git rebase --continue')
# d, drop <commit> = remove commit
# l, label <label> = label current HEAD with a name
....
```

pick命令用于指定是基于哪一个commit合并，然后其他的commit使用squash（简写为s）命令指定。

```shell
pick 9be33cd 修改了新的提交wwwwwwwww
s d97bd5b 修改了文件
s 5fec03f 修改交sssssssssss

# Rebase 182ce38..5fec03f onto 182ce38 (3 commands)
...
```

修改好了之后，保存并退出，将会进入到下一个交互界面：

```shell
# This is a combination of 3 commits.
# This is the 1st commit message:

修改了新的提交wwwwwwwww

# This is the commit message #2:

修改了文件

# This is the commit message #3:

修改交sssssssssss

# Please enter the commit message for your changes. Lines starting
# with '#' will be ignored, and an empty message aborts the commit.
...
```

可以编写一些为什么进行合并message的原因：

```shell
# This is a combination of 3 commits.
用来测试用的，没有其他意思
# This is the 1st commit message:

修改了新的提交wwwwwwwww

# This is the commit message #2:

修改了文件

# This is the commit message #3:

修改交sssssssssss

# Please enter the commit message for your changes. Lines starting
...
```

保存并退出，即可。合并完成之后，将会只看到合并后的提交和其父级。

```shell
$ git log --graph
* commit 28b220d1b95fc803d828114640bddf1fefc74890 (HEAD -> fix_readme)
| Author: wy <wy@163.com>
| Date:   Mon Oct 21 17:59:33 2019 +0800
|
|     用来测试用的，没有其他意思
|
|     修改了新的提交wwwwwwwww
|
|     修改了文件
|
|     修改交sssssssssss
|
* commit 182ce386c9bbcf336c5eeb3f91cdf25e3be2199f
  Author: wy <wy@163.com>
  Date:   Mon Oct 21 17:39:05 2019 +0800

      添加了文件

```

#### 合并非连续的commit的Message信息（不常用）

假如存在如下分支：

```shell
commit 5cc5aa
commit 34e735
commit f09122
```

想要5cc5aa和f09122合并。

第一步，找出要合并的分支的父级分支，f09122没有父级，这里写本身：

```shell
git rebase -i f09122
```

将会显示：

```shell
pick 34e735
pick 5cc5aa
```

第二步：编辑pick，添加f09122的支持。

```shell
pick f09122
s 5cc5aa 必须和上面一个紧挨着
pick 34e735
```

非连续的commit合并，会弹出提示。

第三步：应用git rebase --continue。

```shell
git rebase --continue
```

### 不推荐使用git rebase命令

注意：上述示例只是演示了git rebase命令的用法，实际使用中，不推荐使用该命令用来合并Commit的Message信息。

合并Commit的Message信息的最优做法是，增加新的Commit信息，使message变得更有条理性。



## git stash

git stash用于将当前暂存区中的修改（执行过git add命令的修改）临时存起来，类似于快照，执行了该命令后，当前的修改将会被快照起来，工作区的文件会恢复到上一次commit的状态。例如，当前正在基于commit A做修改，临时需要对之前已经提交的Commit A进行其他修改，又不想丢弃现有的修改，可以使用git stash命令，将当前修改快照起来。

示例，当前使用git add命令，添加了b1.txt文件到暂存区，此时使用git stash命令：

```shell
$ git stash
Saved working directory and index state WIP on fix_readme: 4f066a3 TV
```

该命令会使工作区恢复到git add命令之前的状态，此时在工作区已看不到b1.txt文件。

### list

存好之后，可以使用git stash list查看：

```shell
$ git stash list
stash@{0}: WIP on fix_readme: 4f066a3 TV
```

### apply

如果需要恢复快照，还原快照中的修改，可以使用git stash apply命令：

```shell
$ git stash apply
On branch fix_readme
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
        new file:   b1.txt
```

执行了上述命令后，会恢复快照中的暂存区内容，b1.txt文件也会被恢复。

### pop

实现和apply同样的功能，与apply不同之处在于：

apply会保留stash信息，当使用git stash list查看时，会显示`stash@{0}: WIP on fix_readme: 4f066a3 TV`。

pop不会保留stash信息，使用git stash list进行查看时，不会显示`stash@{0}: WIP on fix_readme: 4f066a3 TV`。



## git clone

### --bare

不带工作区的裸仓库。

```shell
$ git clone --bare /e/Wy_Work/AngYony/gitstudy/git_learning/.git ya.git
```

上述使用的是哑协议进行的克隆，在目标目录中，只会克隆版本库.git文件夹，不会克隆工作区。

如果使用智能协议，可以指定file://形式的文件路径，智能协议在克隆时，有进度大小显示。例如：

```shell
$ git clone --bare file:///e/Wy_Work/AngYony/gitstudy/git_learning/.git zhineng.git
```

推荐使用智能协议，更快、更方便。



## git remote

git remote用于和远端仓库进行关联。

### -v

使用-v选项查看远端仓库信息.

```shell
$ git remote -v
```

### add

使用git remote add命令，添加远端仓库。

```shell
$ git remote add zhineng file:///e/Wy_Work/AngYony/gitstudy/666-backup/zhineng.git
```

上述命令，添加远端仓库zhineng， 远端地址为：file:///e/Wy_Work/AngYony/gitstudy/666-backup/zhineng.git

```shell
$ git remote add wygithub git@github.com:AngYony/ay-english-notes.git
```

上述命令用于将本地的版本库.git与远端版本库进行关联，注意：本地一定要存在.git仓库才能执行成功。命令中的wygithub为远端remote名称。



## git push

将本地内容推送到远端。



将本地所有分支推送到远端wygithub上：

```
git push wygithub --all
```

### -f（严禁使用）

强制将本地分支推送到远端分支。

注意：不推荐使用该选项，会污染远端分支，并且会让远端分支的所有提交信息全部消失。





## git fetch

获取.

获取远端仓库wygithub上的master分支到本地：

```
git fetch wygithub master
```





## git pull

拉取=获取+合并。

由于git的智能，使用git pull可以智能解决以下问题：

- 不同人修改了不同的文件，会自动合并。
- 不同人修改了同一个文件，不同区域可以自动合并，同一个区域会提示合并冲突，需要手工修复。
- 别人同时变更了文件名和文件内容，而你仍在旧的文件上面修改了内容时，使用git pull，也会智能的自动合并到新的文件中。
- 不同的人把同一个文件改成了不同的文件名，会同时保留新的文件，由用户自行取舍。 







## git merge



https://www.cnblogs.com/flydashpig/p/11795238.html
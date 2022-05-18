# Git 操作

1. ### 显示config的配置信息

   在git config的基础上，添加--list，如下：

   ```shell
   $ git config --list   # 显示的是所有的配置信息
   $ git config --list --global
   $ git config --list --local
   $ git config --list --system
   ```

2. ### 配置user.name和user.email

   - 查看user.name和user.email：

     ```shell
     $ git config --global user.name
     wy
     $ git config --global user.email
     wy@163.com
     ```

   - 配置user.name和user.email：

     使用以下命令设置使用Git时的姓名和邮箱地址：

     ```shell
     $ git config --global user.name "Firstname Lastname"
     $ git config --global user.email "your_email@example.com"
     ```

     这里设置的姓名和邮箱地址会用在 Git 的提交日志中。

3. ### 从远端仓库克隆到本地

   ```
   git clone --progress --recursive -v "https://gitee.com/AngYony/diss-backend.git" "E:\Anesec_Work\src\diss-backend"
   ```

4. ### 创建并切换分支

   - 方式一：登录github，手动创建远端分支，然后基于远端分支创建本地分支，并切换到该分支。

     前提还是已经存在远端分支，可以直接基于远端分支创建本地分支，并做好了关联：

     ```shell
     $ git checkout -b feature/bendi_dev origin/feature/dev
     ```

     上述命令基于远端分支dev创建本地分支bendi_dev（这里为了区分，名称不同，实际开发中建议本地分支名称和远端分支名称保持一致），并切换到本地分支bendi_dev。

   - 方式二：先创建本地分支，再关联并创建远端分支

     ```shell
     git checkout -b dev #创建本地分支
     git push --set-upstream origin dev #将本地分支推送到远端并关联，远端将会自动创建该分支
     ```

     

5. ### 编辑文件并添加到暂存区

   `git add`命令用于将工作目录中的变更添加到暂存区中。`git add`命令可以同时添加多个文件或文件夹，下述命令将添加b1.txt文件，和b目录（及其子目录文件）。

   ```shell
   $ git add b1.txt b
   ```

   注意：每次修改了文件时，都需要执行`git add`命令，用于将修改的文件放入暂存区，对于已经放入暂存区的文件，再次修改时，可以不指定文件名，直接使用`-u`将目录中的全部文件再次提交到暂存区。

   ```shell
   $ git add -u
   ```

6. ### 查看暂存区与工作区的差异

   当一个文件被添加到暂存区，在执行提交之前，可以查看一下暂存区与工作区的差异，也就是修改了哪些内容

   ```shell
   git diff
   git diff -- a.html site.css
   ```

   查看暂存区和最近一次提交的差异：

   ```shell
   git diff --cached
   ```

   HEAD：指代当前分支或最近的一次commit。

7. ### 执行提交操作

   ```shell
   $ git commit -m'提交说明'
   ```

   注意：每次`git commit`前，必须使用`git add`命令将修改的文件添加到暂存区，才能提交成功。这和直接使用TortoiseGit工具中的“提交”操作并不相同，TortoiseGit工具中的“提交”=`git add`+`git commit`。

   - 一次性执行添加和提交操作

     也可以直接使用-am，一次性提交更改。相当于是先使用了git add，再做git commit，比较省事，但是不建议这么做，除非特别有把握。

     ```shell
     $ git commit -am'test ssss'
     ```

   - 修改最近一次的提交信息

     使用--amend修改最近一次提交的Message信息。

     ```shell
     $ git commit --amend
     ```

8. ### 推送

   ```
   git push --progress "origin" master:master
   ```

9. ### 获取

10. ### 合并

11. ### 拉取

    ```
    git pull
    ```

    

12. ### 移动或重命名已添加到暂存区的文件

    `git mv`用于重命名已被添加到暂存区的文件。

    ```shell
    git mv 旧文件名 新文件名
    ```

13. ### 删除已添加到暂存区的文件

    `git rm`用于将暂存区的文件移除，一旦暂存区的文件移除后，对应的工作区的文件也会移除，类似于删除操作，但它不是真正的从磁盘中删除，而是在版本库中打上了删除的标记。可以使用git reset命令进行恢复。

    ```shell
    $ git rm a1.txt
    ```

    上述命令会将文件a1.txt移除，如果想要恢复移除的文件，可以使用git reset命令，如下：

    ```shell
    $ git reset --hard HEAD
    ```

14. ### 查看本地和远端有多少分支

    ```
    $ git branch -av
    * master 4e9bdb4 提交内容
    ```

    使用`-v`查看本地有多少分支，加上-a可以查看远程分支，远程分支会用红色表示出来（如果你开了颜色支持的话）。 

15. ### 删除分支

    使用-d或-D删除指定分支：

    ```shell
    $ git branch -d fix_readme
    ```

    删除远端分支：

    ```shell
    git push origin --delete fix_feadme
    ```

    

16. ### 查看日志

    `git log`用于查看git当前分支提交日志。

    可以使用`--oneline`选项，将log显示在一行。

    使用`-n`选项，只显示最近几条log。

    使用`--all`选项，查看所有分支的log信息。

    使用`--graph`选项，以图形化的方式查看log信息。

    上述的选项可以搭配使用：

    ```shell
    $ git log --all --oneline
    $ git log --all --oneline -n2
    $ git log --all --oneline -n2 --graph
    ```






有用的命令：

git fetch upstrem ，用于fork仓库

git pull up master

同步Fork仓库：https://jianshu.com/p/7f6598253a2b
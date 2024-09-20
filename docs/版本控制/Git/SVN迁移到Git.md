## git-svn 工具安装



### Linux

yum install git-svn



### Windows

[Git (git-scm.com)](https://git-scm.com/)

git官方工具安装后自带此命令



### 文档

[Git - git-svn Documentation (git-scm.com)](https://git-scm.com/docs/git-svn)



## 使用 git-svn 工具迁移代码



### 迁移前准备

#### 获取需要迁移的目录第一次提交的版本号

按照第一次提交代码的时间（或者需要保留`commit`记录的时间段，`commit`记录过多时，容易更新失败，建议只保留最近50个`commit`或2个月即可）过滤版本号，`SVN`仓库较大时必须执行此步

`svn log -r {2023-1-1}:{2023-3-10}` 



####  authors-file 文件准备

用于将`commit`记录中的SVN账号转换为对应的Git账号

`--authors-file=userinfo.txt`

userinfo.txt 内容如下

```txt
svn账号=git账号<git账号邮箱>
```



下面的两种方案任选一个

仓库较大时必须指定一个起始版本号，否则容易更新不动，看`SVN`服务端性能决定

最新版本号为`HEAD`



### 方案1 clone

`clone` 是 `init` 与 `fetch`命令的合并命令



仓库比较大时

`git svn clone --revision 起始版本号:结束版本号 SVN仓库地址`



仓库较小时

`git svn clone SVN仓库地址`



其它指令

添加`svn`账号与`git`账号的对应关系

`git svn clone SVN仓库地址 --authors-file=userinfo.txt`



### 方案2 init

`git svn init SVN仓库地址 本地文件目录名称（不指定会在当前目录初始化Git仓库）`



`cd 本地文件目录名称`



`git svn fetch --revision 起始版本号:结束版本号 --authors-file=../userinfo.txt`



### 同步`SVN`最新代码

迁移后 `SVN`仓库有新的`commit`时，将新的`commit`记录同步到`Git`仓库，`commit`过多时，此命令可能执行失败，重新执行即可，直到此命令无数据返回为止

`git svn fetch --authors-file=../userinfo.txt`

### 开始迁移

查看分支情况，包括SVN远程分支

`git show-ref`

结果如下

```sh
006a72ad904d6812954ab9def2ce2db4b251415c refs/heads/master
1646833c17316a3d09534bc33d3f627be5ea7271 refs/remotes/git-svn
```

其中 `refs/remotes/git-svn` 即远程`SVN`仓库

将 `refs/remotes/git-svn` 远程`SVN`仓库`checkout`到本地分支，命令如下，其中`local-git-svn`是本地分支名称，可自由命名，`-b`参数用于强制将远程分支的`commit`覆盖本地分支

`git checkout -b local-git-svn remotes/git-svn`

切换到主分支

`git checkout master`

合并分支到主分支

`git merge local-git-svn`

添加Git远程库地址

`git remote add 远程git仓库标签 "远程git仓库地址"`

推送到远程Git仓库

`git push 远程git仓库标签 master:master --force`



## 参考链接

> [git学习------＞从SVN迁移到Git之后，项目开发代码继续在SVN提交，如何同步迁移之后继续在SVN提交的代码到Git？_git svn fetch-CSDN博客](https://blog.csdn.net/ouyang_peng/article/details/76220621)

> [SVN项目迁移到Git方法 - 测试开发小记 - 博客园 (cnblogs.com)](https://www.cnblogs.com/hiyong/p/17157796.html)

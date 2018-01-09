---
title: SVN
date: 2017-12-29
time: 13:33:05
categories: svn
toc: true
tag: 
---
</p>

# SVN

## check out

得到一个项目的私有拷贝

## update 从云端更新到本地

## commit 将本地修改提交到云端

## svn import
  svn import是将未版本化文件导入版本库的最快方法，会根据需要创建中介目录。svn import不需要一个工作拷贝，文件会直接提交到版本库

## 查看你的修改概况  svn status

为了浏览修改的内容，你会使用这个svn status命令，在所有Subversion命令里，svn status可能会是你用的最多的命令。

## revert

如果你想抛弃还没有提交的更改并将文件复原到修改之前的状态， TortoiseSVN → SVN 还
原 就是你的好伙伴。它抛弃了所做的更改(扔到回收站里)并复原到修改之前的版本。如果你想抛弃更
改的一部分，可以使用 TortoiseMerge 来查看区别并有选择的复原被修改的文件行。
如果你要撤销某一个特定版本的影响，启动日志对话框，找到不想要的版本。选择 右键菜单 → 复原此
版本作出的修改 然后这些更改就会被撤销。
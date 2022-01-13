所有weblogic的启动关闭脚本都必须使用指定账户 不能用root用户

## ps -ef|grep 进程名
ps -ef|grep AdminServer

## 杀AdminServer进程

kill -9 AdminServer进程号

## 部署无法停止无法删除

进入以下目录 删除 部署应用目录 如果部署到了多个server 每个server都删除

> WebLogic根目录\user_projects\domains\应用所在domain\servers\服务名\tmp\_WL_user

## 启动部署时报错 Application cvdecs does not have any Components in it
部署程序名 不能与已经存在的部署或数据源名冲突

## 安装部署时报错 zip file not closed
停止对应server再安装

## u01/scripts

银海 weblogic脚本常用位置
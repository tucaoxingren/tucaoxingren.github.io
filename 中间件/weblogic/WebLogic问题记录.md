## 部署无法停止无法删除

进入以下目录 删除 部署应用目录 如果部署到了多个server 每个server都删除

> WebLogic根目录\user_projects\domains\应用所在domain\servers\服务名\tmp\_WL_user

## 启动部署时报错 Application cvdecs does not have any Components in it
部署程序名 不能与已经存在的部署或数据源名冲突

## 安装部署时报错 zip file not closed
停止对应server再安装
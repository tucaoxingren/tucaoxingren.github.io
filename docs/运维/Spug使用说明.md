## 问题记录

### 管理Windows服务器

`首页/系统管理/系统设置/密钥设置` 将公钥复制到要管理的`Windows`服务器的 `ssh` `authorized_keys`文件中

由于`Windows`服务器默认不带`ssh`服务，需要自行安装 公钥保存的位置决定于你在`Windows`服务器安装的ssh软件

[Windows OpenSSH安装](Windows/Windows-SSH.md)



### Windows服务器执行命令注意

1. 在最后必须写exit 否则不会退出ssh 导致Spug前台任务运行界面无法关闭



### Linux服务器执行命令注意

1. 不支持 su 命令 如需切换账户 建议在创建主机时直接输入需要切换的账户
2. 所有会弹出输入的命令都无法批量执行或在应用自定义发布中流程中执行 所以在批量执行或在应用自定义发布中流程必须测试 保证不会弹出输入命令 例如 删除文件 `rm 文件` 必须写成 `rm -f 文件`



## 账户被锁定



```
docker -it 容器id /bin/bash

mysql -u root

mysql > use spug;

mysql > update users set is_active='1' where id='要解锁的账户id';
```



### 新增超级管理员账户

在界面上新增账户

```
docker -it 容器id /bin/bash

mysql -u root

mysql > use spug;

mysql > update users set is_super='1' where id='新增账号的id';
```



## 验证失败 E02

```sh
vi /etc/ssh/sshd_config


PubkeyAuthentication yes
PubkeyAcceptedKeyTypes +ssh-rsa

service sshd restart
```



## 应用部署示例

### weblogic

```text
目标主机动作1 数据传输
数据来源 发布时上传
目标路径 /u01/war/hisservercct.war

目标主机动作2 设置临时环境变量
执行内容
# Weblogic安装目录
export Weblogic_Home=/u01/Middleware/wlserver_10.3
export Weblogic_LIB_Home=$Weblogic_Home/server/lib
# Weblogic管理URL
export Weblogic_Manage_URL=127.0.0.1:7001
export Weblogic_Manage_USER=weblogic
export Weblogic_Manage_PWD=cdgllwzz#2403
# 备份war
export dirdate=`date +%Y%m%d`
export time_cur=`date +%H%M%S`
mkdir -p /u01/war/$dirdate/$time_cur
cp /u01/war/hisservercct.war /u01/war/$dirdate/$time_cur/hisservercct.war

目标主机动作3 设置部署信息
执行内容
# 部署名称
export APP_NAME=hisservercct
# 要部署的Server名称 多个Server以逗号分隔
export APP_SERVERS=AppServer7003,AppServer7005,AppServer7007,AppServer7009,AppServer7011,AppServer7013
# 部署包本地路径
export APP_LOCAL_PATH=/u01/war/hisservercct.war

目标主机动作4 停止原应用
执行内容
java -cp $Weblogic_LIB_Home/weblogic.jar weblogic.Deployer -adminurl t3://$Weblogic_Manage_URL -user $Weblogic_Manage_USER -password $Weblogic_Manage_PWD -name $APP_NAME -stop -graceful

目标主机动作5 删除部署
执行内容
java -cp $Weblogic_LIB_Home/weblogic.jar weblogic.Deployer -adminurl t3://$Weblogic_Manage_URL -user $Weblogic_Manage_USER -password $Weblogic_Manage_PWD -name $APP_NAME -undeploy

目标主机动作6 安装新部署
执行内容
java -cp $Weblogic_LIB_Home/weblogic.jar weblogic.Deployer -adminurl t3://$Weblogic_Manage_URL -user $Weblogic_Manage_USER -password $Weblogic_Manage_PWD -name $APP_NAME -targets $APP_SERVERS -deploy $APP_LOCAL_PATH

目标主机动作7 启动部署
执行内容
java -cp $Weblogic_LIB_Home/weblogic.jar weblogic.Deployer -adminurl t3://$Weblogic_Manage_URL -user $Weblogic_Manage_USER -password $Weblogic_Manage_PWD -name $APP_NAME -start
```


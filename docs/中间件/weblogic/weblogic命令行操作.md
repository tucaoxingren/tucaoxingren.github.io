## 参考资料

[(13条消息) weblogic命令行操作_panda-star的博客-CSDN博客_weblogic命令](https://blog.csdn.net/chinabestchina/article/details/107703483)

[Using the WebLogic Scripting Tool (oracle.com)](https://docs.oracle.com/cd/E13222_01/wls/docs90/config_scripting/using_WLST.html#1080667)



## Windows

```cmd
rem 设置临时环境变量
rem Weblogic安装目录
set Weblogic_Home=C:\Weblogic\weblogic11g\wlserver_10.3\
set Weblogic_LIB_Home=%Weblogic_Home%server\lib\
rem Weblogic管理URL
set Weblogic_Manage_URL=127.0.0.1:7201
set Weblogic_Manage_USER=weblogic
set Weblogic_Manage_PWD=1234567890

rem 部署名称
set APP_NAME=hissicp3
rem 要部署的Server名称 多个Server以逗号分隔
set APP_SERVERS=AppServer7203
rem 部署包本地路径
set APP_LOCAL_PATH=D:\yinhai\hissicp3.ear

rem 删除部署（必须先停止）
java -cp %Weblogic_LIB_Home%weblogic.jar weblogic.Deployer -adminurl t3://%Weblogic_Manage_URL% -user %Weblogic_Manage_USER% -password %Weblogic_Manage_PWD% -name %APP_NAME% -undeploy

rem 安装部署（会自动启动）
java -cp %Weblogic_LIB_Home%weblogic.jar weblogic.Deployer -adminurl t3://%Weblogic_Manage_URL% -user %Weblogic_Manage_USER% -password %Weblogic_Manage_PWD% -name %APP_NAME% -targets %APP_SERVERS% -deploy %APP_LOCAL_PATH% 

rem 停止部署 立即停止 -graceful   -adminmode
java -cp %Weblogic_LIB_Home%weblogic.jar weblogic.Deployer -adminurl t3://%Weblogic_Manage_URL% -user %Weblogic_Manage_USER% -password %Weblogic_Manage_PWD% -name %APP_NAME% -stop -graceful

rem 启动部署
java -cp %Weblogic_LIB_Home%weblogic.jar weblogic.Deployer -adminurl t3://%Weblogic_Manage_URL% -user %Weblogic_Manage_USER% -password %Weblogic_Manage_PWD% -name %APP_NAME% -targets %APP_SERVERS% -start
```



## Linux

```sh
# 设置临时环境变量
# Weblogic安装目录
export Weblogic_Home=/Weblogic/weblogic11g/wlserver_10.3
export Weblogic_LIB_Home=$Weblogic_Home/server/lib
# Weblogic管理URL
export Weblogic_Manage_URL=127.0.0.1:7201
export Weblogic_Manage_USER=weblogic
export Weblogic_Manage_PWD=1234567890

# 部署名称
export APP_NAME=hissicp3
# 要部署的Server名称 多个Server以逗号分隔
export APP_SERVERS=AppServer7203
# 部署包本地路径
export APP_LOCAL_PATH=D:\yinhai\hissicp3.ear

# 删除部署（必须先停止）
java -cp $Weblogic_LIB_Home/weblogic.jar weblogic.Deployer -adminurl t3://$Weblogic_Manage_URL -user $Weblogic_Manage_USER -password $Weblogic_Manage_PWD -name $APP_NAME -undeploy

# 安装部署（会自动启动）
java -cp $Weblogic_LIB_Home/weblogic.jar weblogic.Deployer -adminurl t3://$Weblogic_Manage_URL -user $Weblogic_Manage_USER -password $Weblogic_Manage_PWD -name $APP_NAME -targets $APP_SERVERS -deploy $APP_LOCAL_PATH

# 停止部署 立即停止 -graceful
java -cp $Weblogic_LIB_Home/weblogic.jar weblogic.Deployer -adminurl t3://$Weblogic_Manage_URL -user $Weblogic_Manage_USER -password $Weblogic_Manage_PWD -name $APP_NAME -stop -adminmode -graceful

# 启动部署
java -cp $Weblogic_LIB_Home/weblogic.jar weblogic.Deployer -adminurl t3://$Weblogic_Manage_URL -user $Weblogic_Manage_USER -password $Weblogic_Manage_PWD -name $APP_NAME -start
```


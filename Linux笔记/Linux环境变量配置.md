# JAVA环境变量配置示例

## JAVA环境配置选做
卸载 openJDK

## 修改 `/etc/profile`
`vi /etc/profile`

1. 查看当前Linux系统是否安装java
`rpm -qa | grep java`
2. 卸载系统中已经存在的openJDK
`rpm -e --nodeps 上一步查询到的包名`
3. 上传并解压自己所需JDK

添加以下内容

```bash
JAVA_HOME=/u01/tools/jdk1.8.0_144
PATH=$JAVA_HOME/bin:$PATH

export JAVA_HOME PATH
```

刷新环境变量

`source /etc/profile`
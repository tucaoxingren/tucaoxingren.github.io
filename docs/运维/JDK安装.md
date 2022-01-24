# JDK 安装

## 安装

### Linux

1. 下载tar包

2. 解压`tar -xzvf xxx.tar.gz -C /usr/local `

3. 添加环境变量 ` vi /etc/profile` (可选)

   ```
   export JAVA_HOME=/usr/local/jdk1.8.0_301
   export PATH=$JAVA_HOME/bin:$PATH
   export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
   ```

   刷新环境变量 `source /etc/profile`

### Windows

1. exe安装
2. 设置环境变量

```powershell
setx JAVA_HOME "C:\Program Files\Java\jdk1.8.0_301"
setx CLASSPATH ".;%JAVA_HOME%\lib\dt.jar;%JAVA_HOME%\lib\tools.jar;"
```



## 问题记录

### Windows

#### 错误码61003

缺失vc运行环境

jdk8->vc2015


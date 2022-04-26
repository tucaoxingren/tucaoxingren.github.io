### 防火墙



| 命令                                                         | 命令说明                      |
| ------------------------------------------------------------ | ----------------------------- |
| netsh firewall add portopening protocol = UDP port =2123 name = Jpom Agent | 添加防火墙端口入站规则        |
| netsh advfirewall firewall add rule name= "ElasticSearch" dir=in action=allow protocol=TCP localport=9200 | 添加防火墙端口入站规则 新系统 |



### 环境变量



| 命令                                                | 命令说明                 |
| --------------------------------------------------- | ------------------------ |
| setx JAVA_HOME "C:\Program Files\Java\jdk1.8.0_301" | 添加环境变量（当前用户） |



### 系统操作



| 命令            | 命令说明     |
| --------------- | ------------ |
| date 2021-10-15 | 修改系统日期 |
| time 09:33:00   | 修改系统时间 |



### 远程桌面无法复制

rdpclip.exe

### sh脚本无法执行

```powershell
# 信任所有脚本
Set-ExecutionPolicy Unrestricted 
# 信任本地签名脚本
Set-ExecutionPolicy RemoteSigned 
```

### 端口转发

netsh interface portproxy add v4tov4 listenaddress=本机IP listenport=本机端口 connectaddress=远程IP connectport=远程端口

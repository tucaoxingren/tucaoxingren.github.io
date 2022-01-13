## 客户端基本命令

### 连接

zkCli.cmd -server ip:port

### 命令
```
 -server host:port cmd args
stat path [watch]
set path data [version]
ls path [watch]
delquota [-n|-b] path
ls2 path [watch]
setAcl path acl
setquota -n|-b val path
history
redo cmdno
printwatches on|off
delete path [version]
sync path
listquota path
rmr path
get path [watch]
create [-s] [-e] path data acl
addauth scheme auth
quit
getAcl path
close
connect host:port
```

### delete 删除节点
只能删除没有子节点的节点

### rmr 删除节点(包含子节点)
删除节点(包含子节点)

rmr 删除节点报错 not empty node  
因为有应用还在连着此节点 请停止所有应用(或停止zookeeper)后重新执行rmr

## 查看日志

cmd 切换到zookeeper根目录

windows
`java -classpath zookeeper-3.4.14.jar;.\lib\slf4j-api-1.7.25.jar org.apache.zookeeper.server.LogFormatter log文件路径\log.2194ac`

linux
`java -classpath zookeeper-3.4.14.jar:.\lib\slf4j-api-1.7.25.jar org.apache.zookeeper.server.LogFormatter log文件路径\log.2194ac`


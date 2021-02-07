
## zookeeper单机伪集群

以单机三节点伪集群示例
目录结构
```
zookeeper-3.4.14-Cluster
|    ├── data
|    |    ├─ 1
|    |    |  └─ myid 文件内容为 1
|    |    ├─ 2
|    |    |  └─ myid 文件内容为 2
|    |    └─ 3
|    |       └─ myid 文件内容为 3
|    ├── log
|    |     ├─ 1
|    |     ├─ 2
|    |     └─ 3
|    ├── zookeeper-1
|    ├── zookeeper-2
└─   └── zookeeper-3
```

zookeeper-1 zookeeper-2 zookeeper-3 即三个节点 必须是相同版本zookeeper的拷贝

每个节点下的zoo.cfg文件可按此配置
`clientPort` 节点监听端口 每个节点必须不一样
```json
# zookeeper时间单元，单位为毫秒
tickTime=2000
# 集群中的follower服务器(F)与leader服务器(L)之间 初始连接 时能容忍的最多心跳数（tickTime的数量）
initLimit=10
# 集群中的follower服务器(F)与leader服务器(L)之间 请求和应答 之间能容忍的最多心跳数（tickTime的数量）
syncLimit=5
# data数据目录
dataDir=D:\\PortableProgram\\zookeeper-3.4.14-Cluster\\data\\1
dataLogDir=D:\\PortableProgram\\zookeeper-3.4.14-Cluster\\log\\1
# 客户端连接端口
clientPort=2181
# 客户端最大连接数
maxClientCnxns=60
# 需要保留的快照数目
autopurge.snapRetainCount=3
# 是否开启自动清理事务日志和快照功能 0 不开启，1表示开启
autopurge.purgeInterval=1

#集群配置 
server.1=127.0.0.1:2888:3888
server.2=127.0.0.1:2889:3889
server.3=127.0.0.1:2890:3890
```

启动每一个节点的server会自动配置为集群模式
## 索引自动删除

使用索引模板与索引生命周期策略实现

```http
PUT _template/delete-30-days
{
  "order": 1,
  "index_patterns": ["mbs-hi-intf-log-*", "mbs-hi-intf-trns-acss"]
}
```

**index_patterns**注意要配置成使用此模板的索引名的匹配表达式 注意索引模板新增前创建的符合此索引模板规则的的索引不会被包含

在`Kibana`中创建索引生命周期策略

> 配置删除阶段 

保存索引生命周期策略 并将此策略分配给上面创建的索引模板



## 设置密码

`./bin/elasticsearch-setup-passwords interactive`



## 配置说明

elasticsearch.yml

```
cluster.name: my-els                               # 集群名称
node.name: els-node1                               # 节点名称，仅仅是描述名称，用于在日志中区分

path.data: /opt/elasticsearch/data                 # 数据的默认存放路径
path.logs: /opt/elasticsearch/log                  # 日志的默认存放路径

network.host: 192.168.60.201                       # 当前节点的IP地址
http.port: 9200                                    # 对外提供服务的端口

http.cors.enabled: true
http.cors.allow-origin: /.*/

# 集群配置添加如下内容 9300为集群服务的端口
#culster transport port
transport.tcp.port: 9300
transport.tcp.compress: true
discovery.zen.ping.unicast.hosts: ["192.168.60.201", "192.168.60.202","192.168.60.203"]       
# 集群个节点IP地址，也可以使用els、els.shuaiguoxia.com等名称，需要各节点能够解析
discovery.zen.minimum_master_nodes: 2              # 为了避免脑裂，集群节点数最少为 半数+1
```





## 问题记录

### linux 不能使用root用户运行

### Authentication of [elastic] was terminated by realm [reserved] - failed to authenticate user [elastic]

#### 问题发生原因

 因宕机或存储空间满了 导致 data目录被删除或损坏

#### 解决方案

重新设置密码

重置密码

`elasticsearch-setup-passwords auto | interactive`

 `auto`  随机密码 

`interactive`  手动设置

### linux 后台运行

#### 解决方案

`elasticsearch -d`

### max file descriptors [4096] for elasticsearch process is too low, increase to at least [65536]

每个进程最大同时打开文件数太小，可通过下面2个命令查看当前数量 

> ulimit -Hn
>
> ulimit -Sn

修改/etc/security/limits.conf文件，增加配置，用户退出后重新登录生效 

> 用户名 soft nofile 65536
>
> 用户名 hard nofile 65536

### max number of threads [3818] for user [es] is too low, increase to at least [4096]

问题同上，最大线程个数太低。修改配置文件/etc/security/limits.conf，增加 配置

> 用户名 soft nproc 4096 
>
> 用户名 hard nproc 4096

### max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]

修改/etc/sysctl.conf文件，增加配置

> vm.max_map_count=262144

执行命令`sysctl -p`生效


## 安装

### linux

以搭建一个拥有三个节点的es集群为例，三台机器的ip如下: 

`machine1： 192.168.70.100 `

`machine2： 192.168.70.101` 

`machine3： 192.168.70.102 `

步骤如下: 

1. 在第一台机器上，解压`elasticsearch`安装包  

创建`elasticsearch `运行用户，执行命令（windows跳过） 

`adduser es`

`passwd es`

输入密码，创建成功。 

2. 然后修改`elasticsearch`目录访问权限（windows跳过） 

`chown -R es:es elasticsearch-*.*.* `

再修改索引文件目录和日志文件目录的访问权限（如果使用默认路径可略过这 一步,windows跳过） 

再切换账号到新用户(windows跳过) 

`su es`

3. 进入主目录下`config`目录，编辑`elasticsearch.yml`（也可以提前修改好） 

`cd elasticsearch-*.*.*/config` 

`vim elasticsearch.yml` 

参考配置如下: 

```properties
#集群的名称 
cluster.name: escluster 
#节点名称,其余两个节点分别为node-2 和node-3(每个节点的名称不同) 
node.name: node-1 
#指定该节点是否有资格被选举成为master节点，默认是true，es是默认集群中的第一台机器为master，如果这台机挂了就会重新选举master 
node.master: true 
#允许该节点存储数据(默认开启) 
node.data: true 
#索引数据的存储路径（elasticsearch运行用户必须有该目录的访问权限，不配置使用默认路径elasticsearch/data）#索引数据的存储路径（elasticsearch运行用户必须有该目录的访问权限，不配置使用默认路径elasticsearch/data） 
path.data: /usr/local/elk/elasticsearch/data 
#日志文件的存储路径（elasticsearch运行用户必须有该目录的访问权限，不配置使用默认路径elasticsearch/logs） 
path.logs: /usr/local/elk/elasticsearch/logs 
#设置为true来锁住内存。因为内存交换到磁盘对服务器性能来说是致命的，当jvm开始swapping时es的效率会降低，所以要保证它不swap 
bootstrap.memory_lock: true 
#绑定的ip地址 
network.host: 0.0.0.0 
#设置对外服务的http端口，默认为9200 
http.port: 9200 
# 设置节点间交互的tcp端口,默认是9300 
transport.tcp.port: 9300 
#Elasticsearch 集群种子节点IP地址列表 
discovery.seed_hosts: ["192.168.70.100", "192.168.70.101", "192.168.70.102"] 
#引导启动集群的主节点 
cluster.initial_master_nodes: ["node-1", "node-2"] 
#允许通过http端口访问 elasticsearch api 
http.cors.enabled: true 
http.cors.allow-origin: /.*/ 
```



编辑`es安装目录/config/jvm.options`修改jvm参数，一般只需要调整最小/最大内存参数 

```
-Xms4g 
-Xmx4g
```



4. 在另外两台机器上重复步骤1-3 

5. 把所有es节点都启动起来， 

linux 下采用后台启动的方式 

`chmod +x modules/x-pack-ml/platform/linux-x86_64/bin/controller`

`chmod +x bin/elasticsearch`

`bin/elasticsearch -d`

然后找其中一台输入查看节点数是否正确 

`curl 127.0.0.1:9200/_cluster/health?pretty`



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



### system call filters failed to ``install``; check the logs and fix your configuration or disable system call filters at your own risk

出现错误的原因：是因为centos6.x操作系统不支持SecComp，而elasticsearch 5.5.2默认bootstrap.system_call_filter为true进行检测，所以导致检测失败，失败后直接导致ES不能启动。

在elasticsearch.yml中添加配置项：bootstrap.system_call_filter为false：

```yml
# ----------------------------------- Memory -----------------------------------
bootstrap.memory_lock: false
bootstrap.system_call_filter: false
```




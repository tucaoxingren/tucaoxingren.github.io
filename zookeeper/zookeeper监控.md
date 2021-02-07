## 性能监控

四字命令

使用范例`echo ZooKeeper四字命令 | nc ip port`(四字命令只能在linux客户端执行 wsl亦可)

| ZooKeeper四字命令 | 功能描述                                                     |
| ----------------- | ------------------------------------------------------------ |
| conf              | 打印配置                                                     |
| **cons**          | 列出所有连接到这台服务器的客户端全部连接/会话详细信息。包括"接受/发送"的包数量、会话id、操作延迟、最后的操作执行等等信息。 |
| crst              | 重置所有连接的连接和会话统计信息。                           |
| dump              | 列出那些比较重要的会话和临时节点。这个命令只能在leader节点上有用。 |
| envi              | 打印出服务环境的详细信息。                                   |
| reqs              | 列出未经处理的请求                                           |
| ruok              | 即"Are you ok"，测试服务是否处于正确状态。如果确实如此，那么服务返回"imok"，否则不做任何相应。 |
| stat              | 输出关于性能和连接的客户端的列表。                           |
| srst              | 重置服务器的统计。                                           |
| srvr              | 列出连接服务器的详细信息                                     |
| wchs              | 列出服务器watch的详细信息。                                  |
| wchc              | 通过session列出服务器watch的详细信息，它的输出是一个与watch相关的会话的列表。 |
| wchp              | 通过路径列出服务器watch的详细信息。它输出一个与session相关的路径。 |
| **mntr**          | 输出可用于检测集群健康状态的变量列表                         |

### `mntr`命令使用示例

`echo mntr | nc ip port`

例如`echo mntr | nc 10.179.3.25 2181`

上述命令指标解释

| 指标名                        | 解释                 |
| ----------------------------- | -------------------- |
| zk_version                    | 版本                 |
| zk_avg_latency                | 平均 响应延迟        |
| zk_max_latency                | 最大 响应延迟        |
| zk_min_latency                | 最小 响应延迟        |
| zk_packets_received           | 收包数               |
| zk_packets_sent               | 发包数               |
| zk_num_alive_connections      | 活跃连接数           |
| zk_outstanding_requests       | 堆积请求数           |
| zk_server_state               | 主从状态             |
| zk_znode_count                | znode 数             |
| zk_watch_count                | watch 数             |
| zk_ephemerals_count           | 临时节点数           |
| zk_approximate_data_size      | 近似数据总和大小     |
| zk_open_file_descriptor_count | 打开 文件描述符 数   |
| zk_max_file_descriptor_count  | 最大 文件描述符 数   |
| **leader才有的指标**          |                      |
| zk_followers                  | Follower 数          |
| zk_synced_followers           | 已同步的 Follower 数 |
| zk_pending_syncs              | 阻塞中的 sync 操作   |

### `srvr`命令使用示例 server的简要信息
| 指标名                        | 解释                 |  输出示例 |
| ----------------------------- | -------------------- | --- |
| Zookeeper version | 版本 | 3.4.6-1569965, built on 02/20/2014 09:09 GMT |
| Latency min/avg/max | 延时 | 0/0/182 |
| Received | 收包数 | 97182 |
| Sent | 发包数 | 97153 |
| Connections | 连接数 | 22 |
| Outstanding |  | 8 |
| Zxid |  | 0x68000af381 |
| Mode | 当前连接zookeeper模式 leader/follower | follower |
| Node count | 节点数 | 101065 |
## 安装说明

### windows

1. 注册为服务 使用powershell 执行 install-service-metricbeat.ps1
2. 编辑配置文件 metricbeat.yml 设置 elasticsearch和kibana信息
3. 启用模块 默认只启用了 system模块`metricbeat.exe modules enable 模块名1 模块名2` 
4. 加载模块默认仪表板 `metricbeat.exe setup`
5. 启动 `metricbeat.exe -e`后台运行 或 启动第一步注册的服务`sc start metricbeat`

### linux rpm安装

rpm -ivf xxx.rpm

## 常见问题

### redis模块

```conf
# Module: redis
# Docs: https://www.elastic.co/guide/en/beats/metricbeat/7.x/metricbeat-module-redis.html

- module: redis
  #metricsets:
  #  - info
  #  - keyspace
  period: 10s

  # Redis hosts
  hosts: ["192.168.5.200:6379"]

  # Network type to be used for redis connection. Default: tcp
  #network: tcp

  # Max number of concurrent connections. Default: 10
  #maxconn: 10

  # Redis AUTH password. Empty by default.
  #password: foobared
  password: "123456" #密码必须用“”包裹
```



### nginx模块

```
# Module: nginx
# Docs: https://www.elastic.co/guide/en/beats/metricbeat/7.x/metricbeat-module-nginx.html

- module: nginx
  #metricsets:
  #  - stubstatus
  period: 10s

  # Nginx hosts
  hosts: ["http://192.168.5.200"]

  # Path to server status. Default nginx_status
  #server_status_path: "nginx_status"
  server_status_path: "server-status"

  #username: "user"
  #password: "secret"
```



### kibana模块

```
# Module: kibana
# Docs: https://www.elastic.co/guide/en/beats/metricbeat/7.x/metricbeat-module-kibana.html

- module: kibana
  metricsets:
    - status
  period: 10s
  hosts: ["192.168.5.200:5601"]
  basepath: "/kibana"
  #username: "user"
  #password: "secret"
```



### oracle模块

```
# Module: oracle
# Docs: https://www.elastic.co/guide/en/beats/metricbeat/7.x/metricbeat-module-oracle.html

- module: oracle
  metricsets: ["tablespace", "performance"]
  enabled: true
  period: 10s
  hosts: ["kmltci/kmltci@192.168.5.6:1521/orcl"]

  # username: ""
  # password: ""
```

### elasticsearch

```
# Module: elasticsearch
# Docs: https://www.elastic.co/guide/en/beats/metricbeat/7.x/metricbeat-module-elasticsearch.html

- module: elasticsearch
  #metricsets:
  #  - node
  #  - node_stats
  period: 10s
  hosts: ["http://192.168.5.6:9200"]
  #username: "user"
  #password: "secret"
```

新版本使用 xpack 时配置此模块 elasticsearch-xpack

```
# Module: elasticsearch
# Docs: https://www.elastic.co/guide/en/beats/metricbeat/7.x/metricbeat-module-elasticsearch.html

- module: elasticsearch
  xpack.enabled: true
  period: 10s
  hosts: ["http://192.168.5.6:9200"]
  #username: "user"
  #password: "secret"
```



下载oracle oci

https://www.oracle.com/database/technologies/instant-client/linux-x86-64-downloads.html

oracle.yml

host=["oracle:ip:host/sid"]

#### linux

1. 解压到此目录/usr/lib

2. 配置环境变量 vim /etc/profile

   ```
   export ora_home=/usr/lib
   export PATH=$PATH:$ora_home/instantclient版本号
   export ORACLE_BASE=$ora_home
   export ORACLE_HOME=$ORACLE_BASE/instantclient版本号
   export LD_LIBRARY_PATH=$ORACLE_BASE
   export NLS_LANG="SIMPLIFIED CHINESE_CHINA.ZHS16GBK"
   ```

3. source /etc/profile

4. systemctl restart metricbeat

#### windows

1. 

## 配置说明

1. `setup.dashboards.enabled: true` 默认为`false`,设置为`true`  `metricbeat.exe setup`时只初始化enable的模块的仪表板


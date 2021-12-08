## 安装

### Linux

#### 下载地址

[Redis](https://redis.io/download)

```shell
# 解压安装包
tar zxf redis-x.x.x.tar.gz
cd redis-x.x.x/
# 编译
make
# 安装
make install PREFIX=/usr/local/redis

# 单机启动
cp ./redis.conf /usr/local/redis/bin/
cd /usr/local/redis/bin/
vi redis.conf
# 修改以下内容
daemonize yes
# 后台启动
./redis-server redis.conf
```

### 安装问题

#### cc command not found

没有安装gcc

#### jemalloc/jemalloc.h: No such file or directory

清理上次编译残留文件，重新编译

```shell
make distclean && make
```

### windows

redis官方无windows版

使用微软编译的版本即可

#### 下载地址

[Releases · microsoftarchive/redis (github.com)](https://github.com/microsoftarchive/redis/releases)

```shell
# 下载压缩包
解压
配置conf
注册为服务 redis-server.exe --service-install redis.windows-service.conf
启动 管理员运行cmd
net start redis
# 下载安装包 则按照安装包流程配置即可
```



## redis.conf 说明

1. `daemonize`  `yes`-后端启动 `no`-前端启动 `Windows`系统不支持
2. `requirepass` 密码 默认无密码
3. `bind` 绑定的ip 一般注释掉默认配置 默认配置只能本机访问
4. `port` 端口 默认 `6379`
5. `protected-mode` no#关闭保护，允许非本地连接
6. `pidfile` /var/run/redis_7001.pid#进程守护文件，就是存放该进程号相关信息的地方
7. `dir` /usr/software/redis/redis-ms/7001/data//#db等相关目录位置
8. `logfile` "/usr/software/redis/redis-ms/7001/log/redis.log"
9. `replicaof` <masterip> <masterport> 主从模式 主机 ip 端口
10. `masterauth` <master-password> 主从模式 主机 密码
11. `appendonly` `yes` `no` 是否开启AOF模式 默认 no



## 配置主从同步

从机设置 `replicaof`和`masterauth`


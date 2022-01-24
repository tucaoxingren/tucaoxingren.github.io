# Nginx使用指南

## Nginx的操作
```bash
# 启动nginx
/usr/local/nginx/sbin/nginx
# 重读配置文件
/usr/local/nginx/sbin/nginx -s reload
# 关闭nginx
/usr/local/nginx/sbin/nginx -s stop
# 测试配置文件是否正确，一般修改配置后先测试后再reload或重启进程
/usr/local/nginx/sbin/nginx -t
```

## 问题记录

### 带下划线的header参数无法转发

```nginx
server {
	underscores_in_headers on;
}
```



### 重定向端口丢失

```nginx
proxy_set_header Host $http_host;
# 关键需要在此处添加端口号变量,或者直接使用端口号
proxy_set_header X-Forwarded-Host $host:$server_port;
```

### 最大连接数的配置

最大并发连接数=worker_processes * events.worker_connections

```nginx
#工作进程数，auto表示按CPU核数启动工作线程，如果服务器不是专门给nginx使用，那需要根据具体需要来指定工作线程数
worker_processes auto;

events {
    # 每个工作进程最大支持的连接数，注意同时会受到文件句柄数的限制 windows最大1024
    worker_connections  1024;
    # 启用多路复用模式，如果关闭就和Apache一样，一个请求一个进程
    multi_accept on;
    # 使用Linux epoll，它是Linux内核为处理大批量文件操作符而优化的多路复用IO接口，
	# 相对于应用自己的实现，性能更高	（但只有Linux可用）
    #use epoll;
}
```



## 安装手册

### Linux

#### 源码安装

1. [源码下载]([nginx: download](http://nginx.org/en/download.html))

2. 解压源码 `tar -xzvf nginx-xxx.tar.gz -C /usr/local/src/`

3. 创建程序根目录 `mkdir /usr/local/nginx`

4. 进入源码目录 准备编译 `cd /usr/local/src/nginx-xxx`

5. 指定安装目录编译 `./configure --prefix=/usr/local/nginx`

6. (可选) 打上`nginx_upstream_check_module`模块补丁，注意补丁文件对应了nginx的不同版本，需要选择正确的版本
    `patch -p1 < ../nginx_upstream_check_module-master/check_1.20.1+.patch`

  配置编译环境，注意加上`nginx_upstream_check_module`模块
  `./configure --add-module=../nginx_upstream_check_module-master`

7. 如果没有安装上面提到的zlib-devel和pcre-devel 需要禁用对应模块进行编译

8. `./configure --add-module=../nginx_upstream_check_module-master --without-http_gzip_module --without-http_rewrite_module`

9. 编译安装 `make install`

10. 配置 `nginx.conf`

11. 启动 `./sbin/nginx`

12. 重启 `./sbin/nginx -s reload`

11. 停止 `./sbin/nginx -s stop`

```bash
# 安装编译工具
yum install make gcc gcc-c++
# 安装其他编译依赖包
# zlib包用于响应压缩
# pcre包用于代理的请求Rewrite模块
# openssl包用于ssl（https）支持，如果不需要可以在安装时禁用对应模块
# patch 用于安装扩展模块，必须，如果不需要负载均衡的掉线检测，也可以不安装
yum install zlib-devel pcre-devel patch openssl-devel
```

### Windows

1. [下载官方ZIP]([nginx: download](http://nginx.org/en/download.html))
2. 解压
3. 配置`nginx.conf`
4. 双击`nginx.exe`启动

### Nginx Upstream Check模块
1. 访问https://github.com/yaoweibin/nginx_upstream_check_module 下载仓库（建议下载当前的master分支）

### ngx_dynamic_upstream 动态管理负载均衡模块

[yaoweibin/nginx_upstream_check_module: Health checks upstreams for nginx (github.com)](https://github.com/yaoweibin/nginx_upstream_check_module)

## 配置手册

### conf示例

```nginx
# 一般使用 默认nginx是运行在nobody用户下，我们一般自己部署的静态文件是足够用的
# 如果是Java程序上传的文件，可能nobody用户在权限上无法读取，要做这些文件的直接下载，我们可以用user修改nginx
#user  root;
# 工作进程数，auto表示按CPU核数启动工作线程，如果服务器不是专门给nginx使用，那需要根据具体需要来指定工作线程数
#worker_processes auto;
worker_processes  1;
# nginx最大文件句柄数：需要注意对应的用户的文件句柄数也需要做调整
worker_rlimit_nofile 100000;

error_log  logs/error.log warn;
pid        logs/nginx.pid;

events {
    # 每个工作进程最大支持的连接数，注意同时会受到文件句柄数的限制
    worker_connections  2048;
    # 启用多路复用模式，如果关闭就和Apache一样，一个请求一个进程
    multi_accept on;
    # 使用Linux epoll，它是Linux内核为处理大批量文件操作符而优化的多路复用IO接口，相对于应用自己的实现，性能更高（但只有Linux可用）
    use epoll;
}

# 针对http的配置，同理还有https配置等
http {
    log_format  main  '$remote_addr [$time_local] "$request" ' '$status $body_bytes_sent' '"$http_user_agent"' '$upstream_addr';
    #access_log  logs/access.log  main;
    # 不记录access_log时 必须明确指定 off
    access_log off;

    server_tokens     off;
    sendfile          on;
    tcp_nopush        on;
    tcp_nodelay       on;

    # 一些超时设置
    keepalive_timeout         10;
    client_header_timeout     10;
    client_body_timeout       10;
    reset_timedout_connection on;
    send_timeout              10;

    # 并发连接限制，另还有一组 limit_req 是并发请求限制
    limit_conn_zone $binary_remote_addr zone=addr:5m;
    limit_conn addr 1024;

    types_hash_max_size 2048;

    # 响应头的 content-type适配
    include       mime.types;
    default_type  application/octet-stream;
    charset UTF-8;

    # 最大请求包体大小，默认只有1m
    # 如果有上传文件，需要根据需要改大这个值。注意需根据需要
    client_max_body_size 1m;

    # 负载均衡配置
    upstream nacos {
        server 127.0.0.1:8848;
        # 需要安装Nginx Upstream Check模块
        check interval=3000 rise=2 fall=5 timeout=1000;
    }

    # http配置下可以有若干个server，他们可能是端口不同，也可以端口相同但主机名不同
    server {
        # 监听端口
        listen       80;
        # 主机名，用于匹配http请求的host部分
        # _ 表示不限制主机名，可以指定主机名或用通配符或正则表达式
        server_name  _;
        
        # 本地静态资源的例子
        location /download {
            root /u01/var/download;
            autoindex on;
            autoindex_exact_size off;
            autoindex_localtime on;
            charset utf-8,gbk;
        }
        
        # location 指定匹配路径，下面用的是前缀模式；也可以使用正则表达式等
        location /UP {
            # 指定静态资源目录
            # http://127.0.0.1:80/UP/index.html => //home/ybapp/UP/index.html
            alias /home/ybapp/UP;
            index  index.html;
            # 设置对html文件不缓存，避免前端打包的前端工程替换后无法使用
            # location ~ \.html {
            #     add_header Cache-Control no-cache;
            # }
        }

        # 代理后端资源的例子
        location /nacos {
            proxy_pass http://nacos;
            proxy_set_header Host $host;
            # proxy_set_header Host $host:$server_port;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-Port $server_port;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_pass_header Content-Type;
            # WebSocket增加配置
            # proxy_http_version 1.1;
            # proxy_set_header Upgrade $http_upgrade;
            # proxy_set_header Connection "upgrade";
            # 后端响应超时，默认60s，根据需要调整
            # proxy_read_timeout 60;
        }

        # 负载均衡节点监测报告，生产环境最好换到独立的内部端口
        location /_check {
            check_status;
            access_log off;
        }
        
        # 开启请求记录，生产环境最好换到独立的内部端口
        location /server-status {
            stub_status on;
            access_log nginxstatus.log;
        }
    }
}
```



### 问题记录

#### http upstream check module can not find any check server, make sure you've added the check servers

使用`nginx_upstream_check_module`模块时要注意 编译安装时必须打补丁(patch) 否则访问负载监控页面时就会报错



#### upstream sent invalid chunked response while reading upstream

```nginx
location /nacos {
    # 增加此配置
    proxy_http_version 1.1
}
```


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
# error_log 不配置时默认为 logs/error.log
# windows 关闭error_log
# error_log null;
# linux 关闭error_log
# error_log /dev/null;
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
        
        location / {
            proxy_pass http://webhost;
            proxy_redirect off;
            proxy_set_header X-Real-IP $remote_addr;
            #后端的Web服务器可以通过X-Forwarded-For获取用户真实IP
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            #以下是一些反向代理的配置,可选.
            proxy_set_header Host $host;
            client_max_body_size 10m; #允许客户端请求的最大单文件字节数
            client_body_buffer_size 128k; #缓冲区代理缓冲用户端请求的最大字节数,
            proxy_connect_timeout 90; #nginx跟后端服务器连接超时时间(代理连接超时)
            proxy_send_timeout 90; #后端服务器数据回传时间(代理发送超时)
            proxy_read_timeout 90; #连接成功后,后端服务器响应时间(代理接收超时)
            proxy_buffer_size 4k; #设置代理服务器（nginx）保存用户头信息的缓冲区大小
            proxy_buffers 4 32k; #proxy_buffers缓冲区,网页平均在32k以下的设置
            proxy_busy_buffers_size 64k; #高负荷下缓冲大小（proxy_buffers*2）
            proxy_temp_file_write_size 64k; #设定缓存文件夹大小,大于这个值,将从upstream服务器传
        }
    }
}
```



### Nginx 中的超时设置

“client_body_timeout”：设置客户端向服务器发送请求体的超时时间，单位为秒。

“client_header_timeout”：设置客户端向服务器发送请求头的超时时间，单位为秒。

“send_timeout”：设置服务器向客户端发送响应的超时时间，单位为秒。

“keepalive_timeout”：设置服务器与客户端之间保持连接的超时时间，单位为秒。

“proxy_connect_timeout”：设置代理服务器与后端服务器建立连接的超时时间，单位为秒。

“proxy_read_timeout”：设置代理服务器从后端服务器读取数据的超时时间，单位为秒。

“proxy_send_timeout”：设置代理服务器向后端服务器发送数据的超时时间，单位为秒。

具体介绍可以参考如下



#### client_body_timeout

用于设置客户端在发送请求体时的超时时间，如果超过了设置的时间客户端还没有发送完请求体，则 Nginx 会返回 “408 Request Time-out” 错误。

默认值为 60s，可以在 “http” 或 “server” 块内使用 “client_body_timeout” 指令进行设置。

例如，要将 “client_body_timeout” 设置为 30 秒，可以在 “http” 或 “server” 块中加入以下指令：

client_body_timeout 30s;

此时，如果客户端在发送请求体时超过了 30 秒，则 Nginx 会返回 “408 Request Time-out” 错误。



#### client_header_timeout

用于设置客户端在发送请求头时的超时时间，如果超过了设置的时间客户端还没有发送完请求头，则 Nginx 会返回 “408 Request Time-out” 错误。

默认值为 60s，可以在 “http” 或 “server” 块内使用 “client_header_timeout” 指令进行设置。

例如，要将 “client_header_timeout” 设置为 30 秒，可以在 “http” 或 “server” 块中加入以下指令：

client_header_timeout 30s;

此时，如果客户端在发送请求头时超过了 30 秒，则 Nginx 会返回 “408 Request Time-out” 错误。



#### send_timeout

用于设置 Nginx 在响应请求时的超时时间。如果在设置的时间内 Nginx 还没有将响应完全发送出去，则会返回 “408 Request Time-out” 错误。

默认值为 60s，可以在 “http” 或 “server” 块内使用 “send_timeout” 指令进行设置。

例如，要将 “send_timeout” 设置为 30 秒，可以在 “http” 或 “server” 块中加入以下指令：

send_timeout 30s;

此时，如果 Nginx 在响应请求时超过了 30 秒还没有将响应完全发送出去，则会返回 “408 Request Time-out” 错误。



#### keepalive_timeout

用于设置 Nginx 保持连接的超时时间。当浏览器发送请求时，如果它已经与 Nginx 建立了连接，则可以直接使用该连接发送请求，而不需要再次建立连接。这样就可以减少建立连接的开销，提高性能。

默认值为 75s，可以在 “http” 或 “server” 块内使用 “keepalive_timeout” 指令进行设置。

例如，要将 “keepalive_timeout” 设置为 60 秒，可以在 “http” 或 “server” 块中加入以下指令：

keepalive_timeout 60s;

此时，如果浏览器与 Nginx 建立了连接，则在 60 秒内浏览器可以直接使用该连接发送请求。超过 60 秒后，如果浏览器还没有发送请求，则 Nginx 会断开连接。



#### proxy_connect_timeout

用于设置连接上游服务器的超时时间，单位为秒。当 Nginx 从客户端请求后，如果在规定时间内没有连接上游服务器，则会返回超时错误。这个超时时间也包含了建立连接的时间。这个参数通常用于配置反向代理，也可以用于配置负载均衡。



#### proxy_read_timeout

用于设置从上游服务器读取响应的超时时间，单位为秒。当 Nginx 连接上游服务器后，如果在规定时间内没有收到响应，则会返回超时错误。这个超时时间也包含了接收响应数据的时间。这个参数通常用于配置反向代理，也可以用于配置负载均衡。



#### proxy_send_timeout

用于设置向上游服务器发送请求的超时时间，单位为秒。当 Nginx 向上游服务器发送请求后，如果在规定时间内没有收到响应，则会返回超时错误。这个超时时间也包含了发送请求数据的时间。这个参数通常用于配置反向代理，也可以用于配置负载均衡。



#### 其它

在调整 Nginx 的超时配置时，需要注意以下几点：

合理设置超时时间：超时时间设置过短会导致误判，设置过长会增加服务器的负担。需要根据实际情况合理调整。

超时时间的相互关系：有些超时配置之间存在相互关系，需要注意配置的先后顺序。例如，在配置反向代理时，proxy_read_timeout应该大于proxy_connect_timeout。

客户端超时设置：客户端也可能会设置超时时间，需要注意服务器端的超时配置是否会与客户端的超时配置冲突。

监控超时事件：应该定期监控超时事件的发生情况，如果发现超时事件过多，则可能需要调整超时配置。

注意超时配置的影响范围：有些超时配置只对特定的场景有效，需要注意在哪些场景下使用。例如，send_timeout只对发送响应给客户端的场景有效。



## 问题记录

#### http upstream check module can not find any check server, make sure you've added the check servers

使用`nginx_upstream_check_module`模块时要注意 编译安装时必须打补丁(patch) 否则访问负载监控页面时就会报错



#### upstream sent invalid chunked response while reading upstream

```nginx
location /nacos {
    # 增加此配置
    proxy_http_version 1.1
}
```


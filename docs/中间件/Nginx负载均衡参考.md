---
link: https://blog.csdn.net/xyang81/article/details/51702900
title: Nginx负载均衡配置
description: 原文链接：http://blog.csdn.net/xyang81/article/details/51702900Nginx安装请参考：《Nginx源码安装》      负载均衡的目的是为了解决单个节点压力过大，造成Web服务响应过慢，严重的情况下导致服务瘫痪，无法正常提供服务。春节期间在12306网站上买过火车票的朋友应该深有体会，有时查询一张火车票都会很慢，甚至整个网页都卡住不动了。通常一个访
keywords: nginx负载均衡配置
author: Xyang0917 Csdn认证博客专家 Csdn认证企业博客 码龄13年 暂无认证
date: 2016-06-18T14:58:00.000Z
publisher: null
stats: paragraph=42 sentences=103, words=349
---
负载均衡的目的是为了解决单个节点压力过大，造成Web服务响应过慢，严重的情况下导致服务瘫痪，无法正常提供服务。春节期间在12306网站上买过火车票的朋友应该深有体会，有时查询一张火车票都会很慢，甚至整个网页都卡住不动了。通常一个访问量非常大的Web网站（比如：淘宝、京东、12306等），由于一个Web服务同时能处理的用户并发请求的数量有限，同时还有机器故障的情况，所以一个Web站点通常会在N台机器上各部署一套同样的程序。当某一个服务挂掉的时候，还有第二个、第三个、第N个服务。。。继续为用户提供服务，给用户的感觉，你的服务还在正常的运行！在这些提供同样服务的机器当中，在硬件配置方面也各不一样，这样就会存在部份机器性能非常好，能快速计算并响应用户的请求，另外一部份机器可能配置差点，响应用户的请求的时间会长一些。这就需要我们思考一个问题？如果有一个服务正在同时处理1000个用户的请求，这个服务的上限可能最多能同时处理1000个用户的请求，这时它已经很忙了，如果此时又有一个新请求过来，我们仍然把这个请求分配给这台机器，这时候这个请求就只能在干等着，等这个服务处理完那些请求后，再继续处理它。这样在浏览器中的反应就像12306我们在春节买票一样，卡在那不动了，让用户眼巴巴的干着急。而能提供同样服务的其它机器，这时确很空闲。这样不仅是对服务器资源的浪费，也充分发挥不出弄多台服务器装同一个服务的最高价值。我们通常称对某一台机器的访问量称为负载量，如何将一个用户的请求，合理的分配到一台能快速响应用户请求的服务器上，我们就需要用到一些负载策略。也就体现出了文章主题的用意了：负载均衡，将用户的所有HTTP请求均衡的分配到每一台机器上，充分发挥所有机器的性能，提高服务的质量和用户体验。负载均衡可以通过负载均衡网络硬件设备和Web服务器软件来实现，前者设备成本较高，小公司通常负担不起，所以后者一般是我们的首选。实现负载均衡常用的Web服务器软件有Nginx、[HAProxy](http://baike.baidu.com/link?url=ye-AIyJhjsD-K5rTQAqk_2RPVjnz7rkNCjy6E7AvJFpvNU5IsglXVPJjfpr2mRMRSEDaO3OyWyEJOdWromj1za)、[LVS](http://baike.baidu.com/link?url=8MlCzwQFXzLVucz9KYftTkVGv1Zzgo2H18707DyLHgv9VJ31anzGFtpriuXDLBfNWg0ACWsbKLlExlheJTHwwb-gKLH_IiZp2rGJdkEgWN7)、[Apache](http://www.cnblogs.com/fly_binbin/p/3881207.html)，本文主要介绍Nginx的负载均衡策略，至于Nginx是干嘛的，自行百度。[这篇文章介绍了Nginx、HAProxy和LVS的优缺点。](http://blog.chinaunix.net/uid-27022856-id-3236257.html)

## 一、内置负载策略

### 轮循（默认）

Nginx根据请求次数，将每个请求均匀分配到每台服务器



### 最少连接

将请求分配给连接数最少的服务器。Nginx会统计哪些服务器的连接数最少。

### IP Hash

[nginx 负载均衡之ip_hash - 简书 (jianshu.com)](https://www.jianshu.com/p/be5c7efd37d7)

**由于nginx ip_hash算法 以 ip的前三个网段做hash 对于 客户端ip过于集中在同一子网下的情况不适用**



绑定处理请求的服务器。第一次请求时，根据该客户端的IP算出一个HASH值，将请求分配到集群中的某一台服务器上。后面该客户端的所有请求，都将通过HASH算法，找到之前处理这台客户端请求的服务器，然后将请求交给它来处理。

```nginx
http {

    # ... 省略其它配置

    upstream tomcats {
        server 192.168.0.100:8080;
        server 192.168.0.101:8080;
        server example.com:8080;
    }

    server {
        listen 80;

        location / {
            proxy_pass http://tomcats;
        }
    }

    # ... 省略其它配置
}
```

* proxy_pass [http://tomcats](http://tomcats)：表示将所有请求转发到tomcats服务器组中配置的某一台服务器上。
* upstream模块：配置反向代理服务器组，Nginx会根据配置，将请求分发给组里的某一台服务器。 **tomcats**是服务器组的名称。
* upstream模块下的server指令：配置处理请求的服务器IP或域名，端口可选，不配置默认使用80端口。通过上面的配置，Nginx默认将请求依次分配给100，101，102来处理，可以通过修改下面这些参数来改变默认的分配策略：
  - weight
  默认为1，将请求平均分配给每台server

```nginx
upstream tomcats {
    server 192.168.0.100:8080 weight=2;  # 2/6次
    server 192.168.0.101:8080 weight=3;  # 3/6次
    server 192.168.0.102:8080 weight=1;  # 1/6次
}
```

上例配置，表示6次请求中，100分配2次，101分配3次，102分配1次
  - max_fails
默认为1。某台Server允许请求失败的次数，超过最大次数后，在fail_timeout时间内，新的请求将不会分配给这台机器。如果设置为0，Nginx会将这台Server置为永久无效状态，然后将请求发给定义了proxy_next_upstream, fastcgi_next_upstream, uwsgi_next_upstream, scgi_next_upstream, and memcached_next_upstream指令来处理这次错误的请求。
  - fail_timeout
默认为10秒。某台Server达到max_fails次失败请求后，在fail_timeout期间内，nginx会认为这台Server暂时不可用，不会将请求分配给它

```nginx
upstream tomcats {
    server 192.168.0.100:8080 weight=2 max_fails=3 fail_timeout=15;
    server 192.168.0.101:8080 weight=3;
    server 192.168.0.102:8080 weight=1;
}
```

192.168.0.100这台机器，如果有3次请求失败，nginx在15秒内，不会将新的请求分配给它。

  - backup
备份机，所有服务器挂了之后才会生效

```nginx
upstream tomcats {
    server 192.168.0.100:8080 weight=2 max_fails=3 fail_timeout=15;
    server 192.168.0.101:8080 weight=3;

    server 192.168.0.102:8080 backup;
}
```

在100和101都挂了之前，102为不可用状态，不会将请求分配给它。只有当100和101都挂了，102才会被启用。
  - down
标识某一台server不可用。可能能通过某些参数动态的激活它吧，要不真没啥用。

```nginx
upstream tomcats {
    server 192.168.0.100:8080 weight=2 max_fails=3 fail_timeout=15;

    server 192.168.0.101:8080 down;

    server 192.168.0.102:8080 backup;
}
```

表示101这台Server为无效状态，不会将请求分配给它。
  - max_conns
限制分配给某台Server处理的最大连接数量，超过这个数量，将不会分配新的连接给它。默认为0，表示不限制。注意：1.5.9之后的版本才有这个配置

```nginx
upstream tomcats {
    server 192.168.0.100:8080 max_conns=1000;
}
```

表示最多给100这台Server分配1000个请求，如果这台Server正在处理1000个请求，nginx将不会分配新的请求给到它。假如有一个请求处理完了，还剩下999个请求在处理，这时nginx也会将新的请求分配给它。
  - resolve
将server指令配置的域名，指定域名解析服务器。需要在http模块下配置resolver指令，指定域名解析服务

```nginx
http {
    resolver 10.0.0.1;

    upstream u {
        zone ...;
        ...
        server example.com resolve;
    }
}
```

表示example.com域名，由10.0.0.1服务器来负责解析。
upstream模块server指令的其它参数和详细配置说明，请参考[官方文档](http://nginx.org/en/docs/http/ngx_http_upstream_module.html#server)。

## 二、第三方负载策略

### fair

根据服务器的响应时间来分配请求，响应时间短的优先分配，即负载压力小的优先会分配。

由于fair模块是第三方提供的，所以在编译nginx源码的时候，需要将fair添加到nginx模块中。

1. 下载fair模块源码
   下载地址：https://github.com/xyang0917/nginx-upstream-fair

```bash
cd /opt
wget https://github.com/xyang0917/nginx-upstream-fair/archive/master.zip
unzip master.zip
```

解压后的目录名为：nginx-upstream-fair-master

2. 重新编译nginx，将fair模块添加到编译参数
   我的nginx源码目录在/opt/nginx-1.10.0

```bash
cd /opt/nginx-nginx-1.10.0
./configure --prefix=/opt/nginx --add-module=/opt/nginx-upstream-fair-master
make
```

**注意：**不要执行make install，这样会覆盖之前nginx的配置

3. 将新编译的nginx可执行程序拷贝到/opt/nginx/sbin/目录下，覆盖之前安装的nginx
   编译后的nginx执行程序，放在nginx源码的objs目录下

```bash
ps -aux | grep nginx
kill -9 nginx进程ID  # 停止nginx服务
cp /opt/nginx-1.10.0/objs/nginx /opt/nginx/sbin/  # 覆盖旧的nginx
nginx # 启动服务
```

配置使用fair负载策略模块：

```nginx
upstream tomcats {
    fair;
    server 192.168.0.100:8080;
    server 192.168.0.101:8080;
    server 192.168.0.102:8080;
}
```

由于采用fair负载策略，配置weigth参数改变负载权重将无效。

### url_hash

按请求url的hash结果来分配请求，使每个url定向到同一个后端服务器，服务器做缓存时比较有效。

1.7.2版本以后，url_hash模块已经集成到了nginx源码当中，不需要单独安装。之前的版本仍需要单独安装，下载地址：[https://github.com/evanmiller/nginx_upstream_hash](https://github.com/evanmiller/nginx_upstream_hash)
安装方法和fair模块一样，先下载url_hash源码，然后重新编译nginx源码，将url_hash模块添加到编译配置参数当中，最后将编译后生成的nginx二进制文件替换之前安装的nginx二进制文件即可。

```nginx
upstream tomcats {
    server 192.168.0.100:8080;
    server 192.168.0.101:8080;
    server 192.168.0.102:8080;
    hash $request_uri;
}
```

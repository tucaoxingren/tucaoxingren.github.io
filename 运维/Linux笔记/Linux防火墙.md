Linux的防火墙一般是 iptables(老版本) 或 firewalld（新版本），都是以系统服务启动的



## 查看防火墙软件

查看防火墙服务状态，主要关注是否启动，是否随机启动



`service firewalld status`

`service iptables status`



## 关闭防火墙

### firewalld 

`service firewalld stop`  # 关闭防火墙服务
`systemctl disable firewalld.service` # 禁用开机启动 



### iptables 

`service iptables stop`  # 关闭防火墙服务
`systemctl iptables firewalld.service` # 禁用开机启动 



## firewalld 使用

### 添加 指定端口允许通过防火墙

`firewall-cmd --permanent --add-port=1521/tcp`



### 查看防火墙是否开启了指定端口
`firewall-cmd --permanent --query-port=1521/tcp`



### 重新加载防火墙策略
`firewall-cmd --reload`
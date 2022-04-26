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
`systemctl disable iptables.service` # 禁用开机启动 



## firewalld 使用

### 添加 指定端口允许通过防火墙

`firewall-cmd --permanent --add-port=1521/tcp`



### 查看防火墙是否开启了指定端口
`firewall-cmd --permanent --query-port=1521/tcp`

### 端口转发
例如3306 -> 3336
`firewall-cmd --permanent --zone=public --add-forward-port=port=3336:proto=tcp:toport=3306:toaddr=`

### 开放端口
```
# 添加多个端口
firewall-cmd --permanent --zone=public --add-port=8080-8083/tcp
 
# 删除某个端口
firewall-cmd --permanent --zone=public --remove-port=81/tcp
 
# 针对某个 IP开放端口
firewall-cmd --permanent --add-rich-rule="rule family="ipv4" source address="192.168.142.166" port protocol="tcp" port="6379" accept"
firewall-cmd --permanent --add-rich-rule="rule family="ipv4" source address="192.168.0.233" accept"
 
# 删除某个IP
firewall-cmd --permanent --remove-rich-rule="rule family="ipv4" source address="192.168.1.51" accept"
 
# 针对一个ip段访问
firewall-cmd --permanent --add-rich-rule="rule family="ipv4" source address="192.168.0.0/16" accept"
firewall-cmd --permanent --add-rich-rule="rule family="ipv4" source address="192.168.1.0/24" port protocol="tcp" port="9200" accept"
```


### 重新加载防火墙策略
`firewall-cmd --reload`
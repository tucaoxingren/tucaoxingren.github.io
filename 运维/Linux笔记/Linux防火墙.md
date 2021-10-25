
Linux的防火墙一般是 iptables(老版本) 或 firewalld（新版本），都是以系统服务启动的

root用户操作

service firewalld status  # 查看防火墙服务状态，主要关注是否启动，是否随机启动

service firewalld stop  # 关闭防火墙服务
systemctl disable firewalld.service # 禁用随机启动 

现在基本都还是firewalld比较多了 然后 如果是iptables的话 可能还没有systemctl 命令（这个也是新版本加的），可能需要chkconfig来调整随机启动



添加 指定端口允许通过防火墙

firewall-cmd --zone=public --add-port=2122/tcp --permanent
## 搭建

```bash
# 创建sftp用户组（可忽略）
groupadd sftp
# 创建一个用户sftpuser：
useradd -g sftp -s /bin/false sftpuser
# 设置sftpuser用户的密码
passwd sftpuser
# 创建一个sftp的工作根目录
mkdir /datas/www
# 修改用户sftpuser所在的目录
usermod -d /datas/www sftpuser
#配置sshd_config
vi /etc/ssh/sshd_config

#找到如下这行，并注释掉
#Subsystem sftp /usr/libexec/openssh/sftp-server

#添加如下几行（如果添加之后出现问题，则添加到最后）
#这行指定使用sftp服务使用系统自带的internal-sftp
Subsystem sftp internal-sftp
#这行用来匹配用户
Match User sftpuser
#用chroot将用户的根目录指定到/datas/www ，这样用户就只能在/datas/www下活动
ChrootDirectory /datas/www
AllowTcpForwarding no
#指定sftp命令
ForceCommand internal-sftp
#保存退出

# 设定Chroot目录权限
chown -R root:root /datas/www
chmod 755 /datas/www

# 建立SFTP用户登入后可写入的目录
mkdir /datas/www/sftpuser
chown -R sftpuser:sftp /datas/www/sftpuser/
chmod 755 /datas/www/sftpuser/

# 重启sshd服务
service sshd restart

# 测试是否能正常登陆
sftp sftpuser@127.0.0.1


```


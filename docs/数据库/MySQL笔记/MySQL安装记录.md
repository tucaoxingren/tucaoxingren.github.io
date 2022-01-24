# MySQL安装记录
## 下载MySQL安装包
1. 访问 https://downloads.mysql.com/archives/community/ 下载MySQL
> 1. MySQL版本选 5.7 的最新版本（5.7.34）
> 2. 系统选择 Linux - Generic （Linux通用二进制版）在Linux中较为通用，其他的需要注意Linux的版本
> 3. 选择下载：Linux - Generic (glibc 2.12) (x86, 64-bit), Compressed TAR Archive，文件为 mysql-5.7.34-linux-glibc2.12-x86_64.tar.gz

## MySQL安装（root用户）
1. 上传 mysql-5.7.34-linux-glibc2.12-x86_64.tar.gz 到 /usr/local/src 下
2. yum安装依赖包，MySQL依赖该库进行aio支持，需要预装
> yum install libaio
3. 添加用户和用户组（如果已经有mysql用户，不需要再执行下面两个指令）
```bash
groupadd mysql
useradd -r -g mysql -s /bin/false mysql
```
4. 开始安装MySQL
```bash
cd /usr/local/src
# 注意检查一下版本号
tar -zxvf mysql-5.7.34-linux-glibc2.12-x86_64.tar.gz
mv mysql-5.7.34-linux-glibc2.12-x86_64 /usr/local/mysql
# 编写mysql配置文件（使用准备好的配置文件替换），配置内容参考配置文件中的注释，注意需要根据规划给MySQL的内存、CPU核数、最大连接数来调整配置参数
vi /etc/my.cnf
# 初始化数据目录
cd /usr/local/mysql
mkdir data
chown mysql:mysql data
chmod 750 data
# 初始化mysql服务器文件，注意输出里面包含了root@local用户的缺省密码
bin/mysqld --initialize --user=mysql
bin/mysql_ssl_rsa_setup    # 初始化MySQL SSL连接密钥
bin/mysqld_safe --user=mysql &  # 测试启动mysql服务
bin/mysql -u root -p       # 测试进入mysql，初始密码请在上面操作的输出中找
# 连接成功后，需要使用 set password = password('password'); 修改root密码，否则不能执行任何操作
# 测试完后kill掉该进程（最好不要kill -9，另外需要kill的是 mysql用户启动的那个mysqld进程，而不是 mysqld_safe）
```
5. 配置mysqld服务和自启动
```bash
# 这个是使用chkconfig管理系统服务的情形，如果系统用的systemd，按systemd的方式配置
cp support-files/mysql.server /etc/init.d/mysqld
# 修改mysqld里面的路径变量，注意为basedir和datadir两个变量赋值（如果均采用上述步骤安装在默认位置，不需要修改）
vi /etc/init.d.mysqld
# 设置随机启动
chkconfig --add mysqld
chkconfig --level 3 mysqld on
service mysqld start
```
6. 设置环境变量
```bash
# 命令行配置
vi /etc/profile
# 在末尾添加以下内容
# MYSQL_HOME=/usr/local/mysql
# PATH=$MYSQL_HOME/bin:$PATH
# export PATH
# 最好另外开一个窗口测试一下能否正常登录，并且mysql --version显示的版本号正确
# 配置好后，我们可以使用以下方式直接连接mysql（会提示输入密码）
mysql -u root -p
```
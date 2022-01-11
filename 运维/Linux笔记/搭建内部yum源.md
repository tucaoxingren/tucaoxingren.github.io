# 一、说明
1. 按正常需求，应尽可能要求平台方提供内部yum源或使用外网yum源头
2. 如果没有提供，为了保证服务器的正常操作，需要搭建自用的yum源
> 如果没有yum源，会影响nginx、时间同步、常规运维工具等的安装

# 二、自定义yum源的部署（需要root用户）
1. 将CentOS的安装镜像上传到服务器，最好传 __Everything__ 版本的镜像（防止一些依赖包找不到），建议镜像与系统小版本保持完全一致，否则容易出现依赖包不兼容的情况（因为镜像里面没有全部版本的依赖包）
> 1. 假定镜像文件上传位置为: /opt/yum.repo/CentOS-7-x86_64-Everything-1804.iso
> 2. 如果云平台将镜像作为光驱挂载到服务器，也可以mount光驱来使用
2. 挂载该镜像到本地，由于yum源本身不需要一直在线，这里就不修改 __fstab__ 文件，如果发生机器重启，重新挂载镜像即可
```shell
# 挂载目录可以根据情况修改，但务必和下面yum源配置中的baseurl部分以及nginx的配置保持一致
mkdir /mnt/cdrom
mount -t iso9660 -o loop /opt/yum.repo/CentOS-7-x86_64-Everything-1804.iso /mnt/cdrom
```
3. 配置本地yum源（提前备份CentOS-Base.repo），主要是下面 __baseurl__ 要指向 镜像挂载的目录
```conf
# CentOS-Base.repo
#
# The mirror system uses the connecting IP address of the client and the
# update status of each mirror to pick mirrors that are updated to and
# geographically close to the client.  You should use this for CentOS updates
# unless you are manually picking other mirrors.
#
# If the mirrorlist= does not work for you, as a fall back you can try the
# remarked out baseurl= line instead.
#
#

[media-c7]
name=CentOS-$releasever - Base Media
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os&infra=$infra
baseurl=file:///mnt/cdrom/
gpgcheck=0
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
```
4. 刷新本地yum源缓存
```shell
yum makecache
```
5. 安装Nginx（正常安装），修改配置文件，将yum源发布出去给其他机器使用
```shell
location /cdrom {
    root   /mnt;
    autoindex on;
}
```

# 三、其他服务器应用该yum源（root）
1. 配置本地yum源（提前备份CentOS-Base.repo），主要是下面 __baseurl__ 要指向 yum源服务器
```conf
# CentOS-Base.repo
#
# The mirror system uses the connecting IP address of the client and the
# update status of each mirror to pick mirrors that are updated to and
# geographically close to the client.  You should use this for CentOS updates
# unless you are manually picking other mirrors.
#
# If the mirrorlist= does not work for you, as a fall back you can try the
# remarked out baseurl= line instead.
#
#

[media-c7]
name=CentOS-$releasever - Base Media
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os&infra=$infra
baseurl=http://10.85.254.136/cdrom/
gpgcheck=0
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
```
2. 刷新本地yum源缓存
```shell
yum makecache
```
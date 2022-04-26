---
title: Linux commond(1)
date: 2017-09-11 
categories: Linux
toc: true
tag: Linux commond
---
</p>


`sudo create_ap wlp3s0 enp2s0f1 Debian 19960525`
## 下载工具
wget
axel
BCloud
## 安装本地deb包
`dpkg -i *.deb`
如果提示出错：用命令修复：`apt-get -f install`
（所有命令在root下执行）

## 编辑软件源
`sudo gedit /etc/apt/sources.list`

## dpkg命令
`dpkg -i package-name` (安装包)
`dpkg -l | grep package-name` (查看包的完整名字)
`dpkg -r package-name` (卸载包)

## 搜索软件包
apt-cache search 软件包名

## 找不到sudo
`apt-get install sudo`

## sudo 出错
`gedit /etc/sudoers`
添加：`laoke	ALL=(ALL:ALL) ALL`

## 双系统问题（Windows+Debian）
### Windows 耳机没有声音
进入睡眠/休眠/重启，再唤醒就有声音
### 时间不一致
Linux:  `sudo hwclock -w --localtime`

## 软件包安装失败
使用`apt --fix-broken install`（或`apt-get install -f`）安装/移除依赖包

## Chrome/Opera 第一次启动需要输入key ring
处理：执行 `google-chrome --password-store=basic`；再次打开，设置密码（两次）,以后就不需要在输入。
相关文件在`~/.local/share/keyrings/`

## Linux下彻底卸载LibreOffice方法

终端中输入命令：

对所有基于 Debian 的发行版（Debian、Ubuntu、Kubuntu、Xubuntu、*buntu、Sidux 等）：

`sudo apt-get purge libreoffice?`

或

`sudo aptitude purge libreoffice?`

不要漏掉通配符“?”，否则无法清除/卸载全部 LibreOffice 软件包

或者

`sudo apt-get remove --purge libreoffice*`

## CrossOver 破解

Deepin移植好的CrossOver QQ
先安装CrossOver，然后把破解覆盖到 /opt/cxoffice/lib/wine/ 即破解完毕
然后deepin的QQ安装好之后CrossOver里就会有deepinQQ容器和deepin做好的QQ，
先别急打开，打开容器的C:\Users\crossover\,删掉My Documents再新建一个My Documents，然后QQ就能打开了

然後64位系統裝32的庫，需要添加32的架構，命令是
sudo dpkg --add-architecture i386

下载破解补丁 `winewrapper.exe.so`，放到 `/opt/cxoffice/lib/wine` 目录。

`sudo cp winewrapper.exe.so /opt/cxoffice/lib/wine/`

## make 找不到
`apt-get install gcc automake autoconf libtool make`

## vim 新建文件
`vi /dir/filename`
```bash
:w   保存文件但不退出vi
:w file 将修改另外保存到file中，不退出vi
:w!   强制保存，不推出vi
:wq  保存文件并退出vi
:wq! 强制保存文件，并退出vi
q:  不保存文件，退出vi
:q! 不保存文件，强制退出vi
:e! 放弃所有修改，从上次保存文件开始再编辑
```

##  新建快捷方式
`sudo vi /usr/share/applications/app.desktop`(app : 软件名)
app.desketop 文件内容如下
```bash
[Desktop Entry]
Type=Application #不可更改
Name=Eclipse #软件名
Comment=Eclipse Integrated Development Environment #软件介绍
Icon=/home/vibexie/software/eclipse/icon.xpm #图标路径
Exec=/home/vibexie/software/eclipse/eclipse #执行软件路径
Terminal=false
Categories=Development;IDE;Java; #标签
```



## 运行shell脚本No such file or directory错误的解决办法

1. 在Windows下转换： 

利用一些编辑器如UltraEdit或EditPlus等工具先将脚本编码转换，再放到Linux中执行。转换方式如下（UltraEdit）：File-->Conversions-->DOS->UNIX即可。 

2. 在Linux下转换 

用vim打开该sh文件，输入：
`:set ff `
回车，显示`fileformat=dos`，重新设置下文件格式：
`:set ff=unix `
保存退出: 
`:wq `
再执行，竟然可以了 

3. 在Linux中的权限转换 

也可在Linux中转换： 

首先要确保文件有可执行权限 

\#chmod u+x filename 

然后修改文件格式 

\#vi filename 

三种方法都可以方便快速的解决关于Linux执行.sh文件，提示No such file or directory这个问题了

## 磁盘挂载

```sh
mount 磁盘 挂载目录

示例
mount /dev/sda6 /u02

永久挂载
vi /etc/fstab
新增一行
/dev/sda6 /u02 ext3 defaults 0 0
```
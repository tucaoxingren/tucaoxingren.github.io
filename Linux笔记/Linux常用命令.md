---
title: Linux commond(2)
data: 2017-09-13
categories: Linux
toc: true
tag: Linux
---
</p>


# 编译命令
```sh
mkdir build
cd build
qmake ..
make 
```
# 查看系统信息
| 命令 | 命令说明 |
| --- | --- |
| uname -a | 查看内核/操作系统/CPU信息 |
| head -n 1 /etc/issue | 查看操作系统版本 |
| cat /proc/cpuinfo | 查看CPU信息 |
| hostname | 查看计算机名 |
| lspci -tv | 列出所有PCI设备 |
| lsusb -tv | 列出所有USB设备 |
| lsmod | 列出加载的内核模块 |
| env | 查看环境变量 |

## 资源
| 命令 | 命令说明 |
| --- | --- |
| free -m                  | 查看内存使用量和交换区使用量 |
| df -h                    | 查看各分区使用情况 |
| du -sh <目录名>          | 查看指定目录的大小 |
| grep MemTotal /proc/meminfo     | 查看内存总量 |
| grep MemFree /proc/meminfo      | 查看空闲内存量 |
| uptime                   | 查看系统运行时间、用户数、负载 |
| cat /proc/loadavg        | 查看系统负载 |
| ls -lht | 查看当前目录下文件夹或文件详细信息 文件大小自动单位 |
| ls -ll | 查看当前目录下文件夹或文件详细信息 |

## 磁盘和分区
| 命令 | 命令说明 |
| --- | --- |
| mount | column -t        | 查看挂接的分区状态 |
| fdisk -l                 | 查看所有分区 |
| swapon -s                | 查看所有交换分区 |
| hdparm -i /dev/hda       | 查看磁盘参数(仅适用于IDE设备) |
| dmesg | grep IDE         | 查看启动时IDE设备检测状况 |

## 网络
| 命令 | 命令说明 |
| --- | --- |
| ifconfig                 | 查看所有网络接口的属性 |
| iptables -L              | 查看防火墙设置 |
| route -n                 | 查看路由表 |
| netstat -lntp            | 查看所有监听端口 |
| netstat -antp            | 查看所有已经建立的连接 |
| netstat -s               | 查看网络统计信息 |

## 进程
| 命令 | 命令说明 |
| --- | --- |
| ps -ef|grep 进程名  | 按进程名搜索进程 |
| ps -ef                   | 查看所有进程 |
| top                      | 实时显示进程状态 |

## 用户
| 命令 | 命令说明 |
| --- | --- |
| w                        | 查看活动用户 |
| id <用户名>              | 查看指定用户信息 |
| last                     | 查看用户登录日志 |
| cut -d: -f1 /etc/passwd     | 查看系统所有用户 |
| cut -d: -f1 /etc/group      | 查看系统所有组 |
| crontab -l               | 查看当前用户的计划任务 |

## 服务
| 命令 | 命令说明 |
| --- | --- |
| chkconfig --list         | 列出所有系统服务 |
| chkconfig --list | grep on      | 列出所有启动的系统服务 |

## 程序
| 命令 | 命令说明 |
| --- | --- |
| rpm -F xxxx.rpm | 更新rpm包 |
| sudo apt-get update      | 更新软件列表 |
| sudo apt-get upgrade     | 更新软件 |
| rpm -qa                  | 查看所有安装的软件包 |

### ftp
| 命令 | 命令说明 |
| --- | --- |
| ftp ip      | 连接ftp 如果FTP 允许匿名用户，那么用户名要输入anonymous,密码任意。 不能直接敲回车。 |
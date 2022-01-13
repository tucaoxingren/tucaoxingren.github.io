# 源端LVM扩容
## 首先掌握服务器现在的情况
可能df看到的磁盘空间和需要的不符，lsblk可以看到有可能有磁盘没有完全格式化或有全新的磁盘。fdisk主要是为了确认当前是否启用了LVM（如果没有使用的话，没法扩容，只能走挂载点）。
> 操作前一定要确定系统是使用了LVM安装，否则重新检讨扩容方案
```bash
df -h
fdisk -l
lsblk
```

## 首先格式化磁盘（一定要看清楚设备）
```bash
# 格式化第二块物理磁盘，vdb 还是其他设备这个需要根据lsblk命令结果来定
fdisk /dev/vdb
# 进入后，依次输入 n（新建分区），其余一直回车取默认值即可，分区新建好后，输入 wq 保存退出

# 通知系统分区表发生了变化，需要重新加载分区表
partprobe

# 执行后就可以看到 vdb 下有个新的分区 /dev/vdb1
fdisk -l
lsblk
```

## 进行卷组扩容
操作前一定要确定系统是使用了LVM安装，否则重新检讨扩容方案
```bash
# 查看当前卷组（vg），确定目标卷组名称（Centos默认安装的时候应该是centos，但不是一定的，一定要先确认）
vgdisplay

# 使用刚新建的分区创建物理卷 (pv)
pvcreate /dev/vdb1
# 将新建的物理卷加入到目标卷组，注意卷组名centos 是上面vgdisplay中查看到的
vgextend centos /dev/vdb1

# 查看卷组大小发生了变化，卷组已经完成扩容
vgdisplay


[root@localhost ~]#

 
6、挂载目录在线扩容，并查看是否已经扩容。
[root@localhost ~]# 
[root@localhost ~]# df -h

```

## 完成磁盘扩容
```bash
# 查看磁盘挂载情况，确定要扩容的挂载点设备
df -hT

# 执行逻辑卷扩容，把卷组剩余空间全部扩给指定挂载点设备（注意设备名字是上面df命令查看到的）
lvextend -l 100%VG /dev/mapper/centos-root

# 更新文件系统元数据，重新计算大小，需要按文件系统类型来执行，目前常见的是xfs或ext4，文件系统类型由上面的 df -hT可以查看
# xfs分区格式
xfs_growfs /dev/mapper/centos-root
# ext3 ext4分区格式
resize2fs /dev/mapper/centos-root
```
## 问题记录

### 管理Windows服务器

`首页/系统管理/系统设置/密钥设置` 将公钥复制到要管理的`Windows`服务器的 `ssh` `authorized_keys`文件中

由于`Windows`服务器默认不带`ssh`服务，需要自行安装 公钥保存的位置决定于你在`Windows`服务器安装的ssh软件

[Windows OpenSSH安装](Windows/Windows-SSH.md)



### Windows服务器执行命令注意

1. 在最后必须写exit 否则不会退出ssh 导致Spug前台任务运行界面无法关闭



### Linux服务器执行命令注意

1. 不支持 su 命令 如需切换账户 建议在创建主机时直接输入需要切换的账户
2. 所有会弹出输入的命令都无法批量执行或在应用自定义发布中流程中执行 所以在批量执行或在应用自定义发布中流程必须测试 保证不会弹出输入命令 例如 删除文件 `rm 文件` 必须写成 `rm -f 文件`



## 账户被锁定



```
docker -it 容器id /bin/bash

mysql -u root

mysql > use spug;

mysql > update users set is_supper='0', is_active='1' where id='1';
```


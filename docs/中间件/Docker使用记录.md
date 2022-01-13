## 安装

### 离线包下载地址

https://download.docker.com/linux/static/stable/x86_64/



### 镜像操作

```shell
# 导出镜像
docker save -o 导出镜像文件名.tar image_name:tag;
# 导入镜像
docker load -i 导出镜像文件名.tar

# 查看镜像
docker image ls

# 删除镜像
docker rmi 镜像id
```



### 容器操作

```shell
# 查看容器
docker ps -a
# 删除容器
docker rm 容器id
# 停止容器
docker stop 容器id
```


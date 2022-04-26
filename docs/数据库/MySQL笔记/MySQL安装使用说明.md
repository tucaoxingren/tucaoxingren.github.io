# MySQL 安装使用说明

## 安装

安装资源到官网选社区版

Linux Generic 一般选择此版本 解压后 初始化后可直接运行

### 资源需求

Linux系统

CPU核数要多

内存要大 内存大小最好是能和经常使用的数据大小一致 MySQL建议把系统的80%的内存分配给MySQL的数据页



## 备份

### 冷备

数据文件

redolog文件



### 逻辑备份

mysql dump备份



## 使用记录



### 变量

```mysql
-- 查询全部变量
show global variables;
-- 变量搜索
show variables like '%变量名%';
-- 修改变量
set global 变量名=变量值;
```



### 创建用户

```mysql
# 创建可以使用任何ip登录的用户
create user 'medplatform'@'%' identified by 'med@35334cXsMr5R0';
```


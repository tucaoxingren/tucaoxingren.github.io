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

### 数据导入导出

#### 导入

1. mysql -u用户名 -p密码 数据库名 < sql文件名

2. 登录mysql后 
```mysql
use 数据库名
source sql文件全路径
```

#### 导出

1. 导出数据和表结构：
mysqldump -u用户名 -p密码 数据库名 > 数据库名.sql

说明：一定要确保数据全导完，不要随便Ctrl+c结束，否则导出的sql脚本不完整

2. 只导出表结构
mysqldump -u用户名 -p密码 -d 数据库名 > 数据库名.sql


3. 排除某张表

mysqldump -u用户名 -p密码 数据库名  --ignore-table=数据库名.表名 > 数据库名.sql

4. 排除多张表

mysqldump -u用户名 -p密码 数据库名  --ignore-table=数据库名.表名1 --ignore-table=数据库名.表名2 > 数据库名.sql
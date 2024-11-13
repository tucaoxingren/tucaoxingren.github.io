# PostgreSQL使用记录

## 数据库安装

[PostgreSQL 11 For CentOS 7安装手册](/docs/数据库/PostgreSQL/PostgreSQL_11_for_CentOS_7安装手册.pdf ':ignore')

## 使用问题记录

### 语法

#### 类型转换

1. 使用::{数据类型}
   1. `select 233::text; ` 即将数字型转换成字符型

2. 使用{数据类型}''
   1. `select text '233';`
   2. `select text'233'`

3. 使用`cast`函数转换
   1. `select cast(233 as TEXT)`


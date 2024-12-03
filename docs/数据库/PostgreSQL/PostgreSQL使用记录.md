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

### 常用函数

#### split_part

分隔字符为字符数组

> select split_part('1/100', '/', 1) -- 结果 '1'

> select split_part('1/100', '/', 2) -- 结果 '100'

#### 字符串截取

> SELECT RIGHT('abcdef', 1) -- 结果 'f'

> SELECT SUBSTRING('abcdef' FROM LENGTH('abcdef') FOR 1) -- 结果 'f'

> select substring('abcd', 1, 2) -- 结果 'ab'

> select substr('abcd', 1, 2) -- 结果 'ab'

#### to_char 将字符串转为指定格式输出

> select to_char(now(),'yyyy-MM-dd HH24:mi:ss') -- 结果 '2024-11-21 16:11:30'

#### position 类似于java的indexOf函数

返回序号从1开始

> select position('c' IN 'abcd') -- 结果 3

#### string_agg()：根据分组将多条数据合并为一条数据

> SELECT string_agg(合并字段,',') as a FROM 表名 WHERE 1=1 GROUP BY 分组条件

#### concat 连接函数

> select concat('a', 'b', 'c') -- 结果 'abc'

### 常用sql

#### 查询列信息

```PostgreSQL
SELECT
	a.attname AS column_name,
	concat_ws('', t.typname) AS column_type,
	COALESCE(col.character_maximum_length, col.numeric_precision, -1) AS length,
	col.is_identity AS IDENTITY,
	col.column_default AS column_default,
		( CASE WHEN a.attnotnull = TRUE THEN TRUE ELSE FALSE END ) AS required,
		( CASE
			WHEN ( 
				SELECT count(pg_constraint.*) 
					FROM pg_constraint
				INNER JOIN pg_class ON pg_constraint.conrelid = pg_class.oid
				INNER JOIN pg_attribute ON pg_attribute.attrelid = pg_class.oid
				AND pg_attribute.attnum = ANY(pg_constraint.conkey)
				INNER JOIN pg_type ON pg_type.oid = pg_attribute.atttypid
				WHERE pg_class.relname = c.relname
				AND pg_constraint.contype = 'p'
				AND pg_attribute.attname = a.attname
		) > 0 THEN TRUE
			ELSE FALSE
		END
	) AS pk,
		( SELECT description FROM pg_description WHERE objoid = a.attrelid AND objsubid = a.attnum ) AS column_comment
	FROM pg_catalog.pg_namespace n
	JOIN pg_class c ON(C.relnamespace = n.oid)
	-- 模式名
	-- and n.nspname
	-- 表名
	AND c.relname = 't_gis_data_sale_imei'
JOIN pg_attribute a ON a.attnum > 0
	AND a.attrelid = c.oid
JOIN pg_type t ON a.atttypid = t.oid
JOIN information_schema.columns AS col ON col.table_name = c.relname
	AND col.column_name = a.attname
	AND n.nspname = col.table_schema
ORDER BY
		c.relname DESC,
		a.attnum ASC
```
## 基础语法
> 数据定义语言（DDL），包括CREATE（创建）命令、ALTER（修改）命令、DROP（删除）命令等
> 数据操纵语言（DML），包括INSERT（插入）命令、UPDATE（更新）命令、DELETE（删除）命令、SELECT … FOR UPDATE（查询）等
> 数据查询语言（DQL），包括基本查询语句、Order By子句、Group By子句等
> 事务控制语言（TCL），包括COMMIT（提交）命令、SAVEPOINT（保存点）命令、ROLLBACK（回滚）命令
> 数据控制语言（DCL），GRANT（授权）命令、REVOKE（撤销）命令

### `order by`使用注意
1. `order by asc`增序排序
 `order by desc`降序排序
1. `order by` 默认增序 即 `order by asc`
1. `order by`的值有空值(NULL)时 空值被视为最大

### `rownum` 使用注意
`rownum`伪列 是sql查询到的结果集的序号
1. `rownum` 比较时只能 `<` 或 `<=`某个值
2. 使用`rownum`分页时 务必`order by`唯一值

`rownum`分页示例
```sql
select *
  from (select a.*, rownum as rownum_ from emp a order by empno)
 where rownum_ > 3
   and rownum_ < 5
```

## 常用Oracle函数

### `decode` 数据转换函数
#### 语法
 `decode(条件,值1,返回值1,值2,返回值2,...值n,返回值n,缺省值)`
```sql
-- 该函数的含义如下：
IF 条件=值1 THEN
    RETURN(翻译值1)
ELSIF 条件=值2 THEN
    RETURN(翻译值2)
    ......
ELSIF 条件=值n THEN
    RETURN(翻译值n)
ELSE
    RETURN(缺省值)
END IF;
```

#### 说明
1. 条件可以是某个值 也可以是某个表达式 值 返回值 也可以是表达式
2. `decode`可以用于纵表转横表 [详见示例2](#decodeDemo2)
3. `group by`及`order by`中也可以使用

#### 示例
**示例-1 decode语法简单示例**
```sql
select decode('1', '1', '是', '否') from dual;-- 输出 '是'
select decode('0', '1', '是', '否') from dual;-- 输出 '否'
```

**示例-2 decode用于纵表转横表** <a id="decodeDemo2"></a>

```sql
-- 表结构
-- 纵表
create table 纵表-- 姓名-课程-成绩表
(
    姓名 varchar(20),
    课程 varchar(20),
    成绩 int
);
create table 横表
(
    姓名 varchar(20),
    语文 int,
    数学 int,
    英语 int
);
```

纵表数据示例
| 姓名 | 课程 | 成绩 |
| --- | --- | --- |
| 张三 | 语文 | 65 |
| 张三 | 数学 | 90 |
| 张三 | 英语 | 55 |

横表数据示例
| 姓名 | 语文 | 数学 | 英语 |
| --- | --- | --- | --- |
| 张三 | 65 | 90 | 55 |

```sql
-- 纵表转横表示例sql
SELECT 姓名,
       SUM(DECODE(课程, '语文', 成绩, 0)) 语文,
       SUM(DECODE(课程, '数学', 成绩, 0)) 数学,
       SUM(DECODE(课程, '英语', 成绩, 0)) 英语
  FROM 纵表
GROUP BY 姓名
```

### `to_date` 字符串转date型数据

#### 语法
`to_date(待转化字符串), 格式化字符串)`

#### 格式化字符串 说明 <a id="dateFormat"></a>
1. `yyyy` 四位年
2. `mm` 两位月
3. `dd` 两位日期
4. `hh` 两位小时 12时制
5. `hh24` 两位小时 24时制
6. `mi` 两位分钟
7. `ss` 两位秒钟
8. `Q` 季度 取值 1-4 对应一季度-四季度

#### 示例

```sql
select to_date('20200101', 'yyyymmdd') from dual;-- 输出 2020/1/1
-- 只指定时分秒时 日期默认为当月第一天
select to_date('10', 'hh24') from dual;-- 输出 2020/8/1 10:00:00
```

### `to_char` 格式化字符串

#### 语法
to_char(待转换的数据, 格式化字符串)

#### 说明
1. 待转换的数据可以是 `date`型 `timestamp`型 `number`型
2. 对于`date`型 `timestamp`型 格式化字符串说明 
参考`to_date` [格式化字符串说明](#dateFormat)

#### 数字格式化说明

| 参数 | 示例 | 说明 |
| ------------- | -------------- | -------------------------------- |
| 9             | 999            | 指定位置处显示数字             |
| .             | 9.9            | 指定位置返回小数点               |
| ,             | 99,99          | 指定位置返回一个逗号             |
| $             | $999           | 数字开头返回一个美元符号         |
| EEEE          | 9.99EEEE       | 科学计数法表示                   |
| L             | L999           | 数字前加一个本地货币符号         |
| PR            | 999PR          | 如果数字式负数则用尖括号进行表示 |
| fm | fm9.9 | 把多余的空格去除 |

#### 示例
```sql
/*************** 日期转换 **************/
select to_char(sysdate,'yyyy-MM-dd HH24:mi:ss') from dual;-- 输出 '2020-08-31 14:39:52 

/*************** 数字转换 **************/
select to_char(123456) from dual;
-- 整数补足
select to_char(1234567890,'099999999999999') from dual;-- 输出 '000001234567890'
-- 数字分隔(注意空格)
select to_char(12345678,'999,999,999,999') from dual;-- 输出 '      12,345,678'
select to_char(123,'$99,999.9') from dual;-- 输出 `    $123.0`
-- 小数格式化 对小数部分四舍五入 整数部分位数必须和格式化字符串小数点前部分 位数一直 否则 输出为#
select to_char(12.3456, '99.999') from dual;-- 输出 ' 12.346'
select to_char(123456, '99.999') from dual;-- 输出 '#######'
select to_char(121.3456, '99.999') from dual;-- 输出 '#######'
select to_char(123,'fmL99,999.9') from dual;-- 输出 `    $123.0`

```

### `nvl` 判空函数

#### 语法
`nvl(值或表达式, 为空时的值)` 不为空时 返回第一个参数值

#### 说明
1. 所有参数均可为表达式

#### 示例
```sql
select nvl(null, 1) from dual;-- 输出 '1'
select nvl(1, 1) from dual;-- 输出 '1'
```

### `nvl2` 判空函数

#### 语法
`nvl2(值或表达式, 不为空时的值, 为空时的值)`

#### 说明
1. 所有参数均可为表达式

#### 示例
```sql
select nvl2(null, 1, 0) from dual;-- 输出 '0'
select nvl2(1, 1, 0) from dual;-- 输出 '1'
```

### `trunc` 截取函数

#### 语法

**date**
> `TRUNC(date, date_format)`
> `date` 需要截取的`date`型数据
> `date_format` 截取日期的格式化字符串 参考`to_date` [格式化字符串说明](#dateFormat)

**number**
> `TRUNC(number, num_digits)`
> `number` 需要截取的`number`型数据
> `num_digits` 用于指定取整精度的数字 num_digits 的默认值为 0

#### 说明
1. TRUNC()函数截取`date`型数据没有秒的精确
2. TRUNC()函数截取`number`型数据时不进行四舍五入

#### 示例
```sql
/**************日期********************/
1.select trunc(sysdate) from dual --2013-01-06 今天的日期为2013-01-06
2.select trunc(sysdate, 'mm') from dual --2013-01-01 返回当月第一天.
3.select trunc(sysdate,'yy') from dual --2013-01-01 返回当年第一天
4.select trunc(sysdate,'dd') from dual --2013-01-06 返回当前年月日
5.select trunc(sysdate,'yyyy') from dual --2013-01-01 返回当年第一天
6.select trunc(sysdate,'d') from dual --2013-01-06 (星期天)返回当前星期的第一天
7.select trunc(sysdate, 'hh') from dual --2013-01-06 17:00:00 当前时间为17:35
8.select trunc(sysdate, 'mi') from dual --2013-01-06 17:35:00 
/***************数字********************/
9.select trunc(123.458) from dual --123
10.select trunc(123.458,0) from dual --123
11.select trunc(123.458,1) from dual --123.4
12.select trunc(123.458,-1) from dual --120
13.select trunc(123.458,-4) from dual --0
14.select trunc(123.458,4) from dual --123.458
15.select trunc(123) from dual --123
16.select trunc(123,1) from dual --123
17.select trunc(123,-1) from dual --120
```

### 常用日期函数

```sql
-- 某天是星期几     
select to_char(sysdate,'day') from dual;-- 输出 '星期一 ' 
-- 计算两个日期间的天数     
select floor(sysdate - to_date('0101','mmdd')) from dual;-- 输出 '243'
-- 获取指定日期下个周日期 参数1-日期型数据 参数2-下周几取值范围1-7 注意1对应的是周日 2是周一 依次类推
select next_day(sysdate, 1) from dual; 
/*
add_months(d_date, n_num)
d_date 为日期型数据
n_num 必须为整数 为正数时指定日期加n_num月 为负数时指定日期减-n_num月

注意 d_date为某月最后一天时 加减指定月数时获取的是那个月的最后一天 看下面的示例
*/
-- sysdate 为 2020/8/31 15:14:31
select add_months(sysdate, 1) from dual;-- 输出为 '2020/9/30 15:15:34'
select add_months(sysdate, 1) from dual;-- 输出为 '2020/7/31 15:15:34'

-- last_day(d_date) 获取d_date所在月份的最后一天
-- sysdate 为 2020/8/31 15:14:31
select last_day(sysdate) from dual;-- 输出 '2020/8/31 15:14:31'

-- 日期型数据加减运算
-- sysdate 为 2020/8/31 15:14:31
select sysdate + 1 from dual;-- 输出 '2020/9/1 15:14:31'
select sysdate - 1 from dual;-- 输出 '2020/8/30 15:14:31'
-- 获取一小时后 同理 10分钟后 + 10*1/60
select sysdate + 1/24 from dual;-- 输出 '2020/8/31 16:14:31'

-- sysdate 为 2020/8/31 00:00:00
select sysdate + 0.99999 from dual;-- 输出 '2020/8/31 23:59:59'
```

### 常用数字函数

| 函数 | 说明 | 示例 |
| -------------- | ------------------- | ------------------- |
| ABS(x)         | x绝对值       | ABS(-3)=3           |
| ACOS(x)        | x的反余弦           | ACOS(1)=0           |
| COS(x)         | 余弦                | COS(1)=1.57079633   |
| **CEIL(x)**   | 大于或等于x的最小值 | CEIL(5.4)=6         |
| **FLOOR(x)**  | 小于或等于x的最大值 | FLOOR(5.8)=5        |
| LOG(x,y)       | x为底y的对数        | LOG(2,4)=2          |
| **MOD(x,y)**  | x除以y的余数        | MOD(8,3)=2          |
| POWER(x,y)     | x的y次幂            | POWER(2,3)=8        |
| **ROUND(x[,y])** | x在第y位四舍五入    | ROUND(3.456,2)=3.46 |
| SQRT(x)        | x的平方根           | SQRT(4)=2           |
| **TRUNC(x[,y])** | x在第y位截断        | TRUNC(3.456,2)=3.45 |

#### 说明
1. ROUND(X[,Y])，四舍五入
> 在缺省y时，默认y=0；比如：ROUND(3.56)=4
> y是正整数，就是四舍五入到小数点后y位ROUND(5.654,2)=5.65
> y是负整数，四舍五入到小数点左边|y|位ROUND(351.654,-2)=400

2. TRUNC(x[,y])，直接截取，不四舍五入
> 在缺省y时，默认y=0；比如：TRUNC (3.56)=3
> y是正整数，就是四舍五入到小数点后y位TRUNC (5.654,2)=5.65
> y是负整数，四舍五入到小数点左边|y|位TRUNC (351.654,-2)=300

### 常用字符函数

| 函数 | 说明 | 示例 | 示例结果 |
| --- | --- | --- | --- |
| **ASCII(x)** | 返回字符x的ASCII码 | ASCII('a') | 97 |
| CONCAT(x,y) | 连接字符串x和y 也可以用`||` | CONCAT('Hello', ' world') | Hello world |
| INSTR(x, str [,start] [,n) | 在x中查找str，可以指定从start开始，也可以指定从第n次开始 | INSTR('Hello world'，'or') | 8  |
| LENGTH(x) | 返回x的长度 | LENGTH('Hello') | 5 |
| LOWER(x) | x转换为小写 | LOWER('hElLO') | hello |
| UPPER(x) | x转换为大写 | UPPER('hello') | HELLO |
| LTRIM(x[,trim_str]) | 把x的左边截去trim_str字符串，缺省截去空格 | LTRIM('1111HELLO1111', '1')  | ` HELLO1111` |
| RTRIM(x[,trim_str]) | 把x的右边截去trim_str字符串，缺省截去空格 | RTRIM('1111HELLO1111', '1') | 1111HELLO |
| **TRIM([trim_str FROM] x)** | 把x的两边截去trim_str字符串，缺省截去空格 | TRIM('  HELLO  ')  | `HELLO` |
| **REPLACE(x,old,new)** | 在x中查找old，并替换为new | REPLACE('HELLO11', '1', '2') | HELLO22 |
| **SUBSTR(x,start[,length])** | 返回x的字串，从start处开始，截取length个字符，缺省length，默认到结尾 从头开始时 start既可以是0也可以是1 | SUBSTR('HELLO11', 1, 2) | HE  |

### 常用聚合函数
| 函数名 | 说明 |
| --- | --- |
| SUM | 求和 |
| MIN | 最小值 |
| MIN | 最大值 |
| AVG | 平均值 |

## 复杂sql语句
以下所有示例语句表结构如下
```sql
create table EMP -- 雇员信息表
(
  empno    NUMBER(4) not null, -- 雇员编号
  ename    VARCHAR2(10), -- 雇员姓名
  job      VARCHAR2(9), -- 职位
  mgr      NUMBER(4), -- 上级领导雇员编号
  hiredate DATE, -- 雇佣日期
  sal      NUMBER(7,2), -- 工资
  comm     NUMBER(7,2), -- 奖金
  deptno   NUMBER(2) -- 部门编号
);

create table DEPT -- 部门信息表
(
  deptno NUMBER(2), -- 部门编号
  dname  VARCHAR2(14), -- 部门名称
  loc    VARCHAR2(50) -- 工作地点
);
```
EMP 表数据如下
| 雇员编号  | 雇员姓名 | 职位 | 上级领导雇员编号 | 雇佣日期 | 工资 | 奖金 | 部门编号 |
| ---  | --- | --- | --- | --- | --- | --- | --- |
| 0 | 土豪 | 老板 	|  |	2020/9/1 |  |  |  |
| 1 | 张三 | 程序员 	| 2 |	2020/9/1 |  9000 | 0 | 1 |
| 2 | 李四 | 开发经理	| 0 |	2020/9/1 | 10000 | 0 | 1 |
| 3 | 王五 | 行政经理	| 0 |	2020/9/1 |  6000 | 0 | 2 |
| 4 | 李六 | 测试经理	| 0 |	2020/9/1 |  7000 | 0 | 3 |

DEPT 表数据如下
| 部门编号  | 部门名称 | 工作地点 |
| ---  | --- | --- |
| 1 | 开发部门 | 中 	|
| 2 | 行政部门 | 东	|
| 3 | 测试部门 | 西	|
| 4 | 发展部门 | 北	|

### 多表关联

```sql
/* --------------------- 1. 查询 雇员编号 雇员姓名及部门名称 --------------------- */
-- 等值连接
select empno, ename, dname from emp a, dept b where a.deptno = b.deptno order by empno;
-- `join` 等同于 `inner join` 
select empno, ename, dname from emp a join dept b on a.deptno = b.deptno order by empno;
select empno, ename, dname from emp a inner join dept b on a.deptno = b.deptno order by empno;
/* -- 输出
1	张三	开发部门
2	李四	开发部门
3	王五	行政部门
4	李六	测试部门
*/
-- 等值连接中多表间关联条件无匹配项的数据不会被查询到 例如 职位为'老板'的员工由于无部门编号所以没有查询到 如需查询到职位为'老板'的员工信息可以使用左外连接 示例如下

-- 左外连接 `left join`关键字左边的表数据会全部查询出来即使`on`没有匹配
select empno, ename, dname from emp a left join dept b on a.deptno = b.deptno order by empno;
/* -- 输出
0	土豪	
1	张三	开发部门
2	李四	开发部门
3	王五	行政部门
4	李六	测试部门
*/

-- 右外连接 `right join`关键字右边的表数据会全部查询出来即使`on`没有匹配
select empno, ename, dname from emp a right join dept b on a.deptno = b.deptno order by empno;
/* -- 输出
1	张三	开发部门
2	李四	开发部门
3	王五	行政部门
4	李六	测试部门
                发展部门
*/

-- 全连接 `full join`关键字会把两表数据会全部查询出来即使`on`没有匹配
select empno, ename, dname from emp a full join dept b on a.deptno = b.deptno order by empno;
/* -- 输出
0	土豪	
1	张三	开发部门
2	李四	开发部门
3	王五	行政部门
4	李六	测试部门
		发展部门
*/
```

### 子查询
在上面[多表关联](#多表关联)的示例中`示例1`也可以用子查询实现示例如下
```sql
/* --------------------- 1. 查询 雇员编号 雇员姓名及部门名称 --------------------- */
select empno, ename, (select dname from dept where deptno=a.deptno) as dname from emp a order by empno;
/* -- 输出
0	土豪	
1	张三	开发部门
2	李四	开发部门
3	王五	行政部门
4	李六	测试部门
*/

/******************************* `in`  `exists` 示例 *******************************/
/* --------------------- 2. 查询 部门名称不为空 的雇员编号 雇员姓名--------------------- */
select empno, ename from emp a where deptno in (select deptno from dept b) order by empno;
select empno, ename from emp a where exists (select 1 from dept b where deptno =a.deptno) order by empno;
/* -- 输出
1	张三
2	李四
3	王五
4	李六
*/
```
**`in`  `exists`区别**
在上面的`示例2`中 如果a表数据总量远大于b表数据总量 使用 `in` 反之 使用 `exists`

### 复杂select
```sql
/* --------------------- 1. 查询 emp表中的不重复的部门编号列表 --------------------- */
select distinct deptno from emp;
/* -- 输出

1
2
3
*/
/* --------------------- 2. 查询 各部门的工资总额 --------------------- */
select deptno, sum(sal) from emp group by deptno where deptno is not null;
/* -- 输出
1	19000
2	6000
3	7000
*/
```

## pl/sql语法

pl/sql语法 是指 oracle针对标准sql进行扩充的语法,专用于oracle数据库中函数 过程及程序包中使用的专属语法

> PL/SQL支持面向对象的编程，在PL/SQL中可以创建类型，可以对类型进行继承，可以在子程序中重载方法等

### PL/SQL中的特殊符号说明
| 类型 | 符号 | 说明 |
| --- | --- | --- |
| 赋值运算符 | `:=` | PL/SQL的赋值是 `:=` |
| **特殊字符** | `||`    | 字符串连接操作符 |
| 特殊字符 | `--`    | PL/SQL中的单行注释|
| 特殊字符 | `/* */` | PL/SQL中的多行注释，多行注释不能嵌套 |
| 特殊字符 | `<< >>` | 标签分隔符 只为了标识程序特殊位置 `goto label1; <<label1>>` |
| 特殊字符 | `..`    | 范围操作符 比如: `1..5` 标识从1到5 |
| 算术运算符 | `+` `-` `*` `/` | 基本算术运算符 |
| 算术运算符 | `**`      | 求幂操作 比如: `3**2=9` |
| 关系运算符 | `>` `<` `>=` `<=` `=` | 基本关系运算符 `=`表示相等关系 不是赋值 |
| 关系运算符 | `<>` `!=` | 不等关系 |
| 逻辑运算符 | `AND` `OR` `NOT` | 逻辑运算符 |

### 变量与常量

**变量声明**
`变量名 数据类型[:=初始值]` 例如: `s_aaa VARCHAR2 := '1';` 或 `s_aaa VARCHAR2;`

**变量赋值**
1. `变量名 := 值` 例如: `s_aaa := '111';`
2. `SELECT 值1, 值2 INTO 变量1, 变量2 FROM 表名` 例如: `SELECT '1' INTO s_aaa FROM dual`

**常量声明**
`CONSTANT 常量名 := 值` 例如: `CONSTANT S_AAA := '111';`

### 数据类型
| 类型       | 说明 |
| --- | --- |
| **VARCHAR2(长度)**   | 可变长度字符串，Oracle SQL定义的数据类型，在PL/SQL中使用时最长4000字节在PL/SQL中使用没有默认长度，因此必须指定 |
| **NUMBER(精度，小数)** | Oracle SQL定义的数据类型，见第二章 |
| **DATE**             | Oracle SQL定义的日期类型，见第二章 |
| TIMESTAMP            | Oracle SQL定义的日期类型，见第二章 |
| **CHAR(长度)**       | Oracle SQL定义的日期类型，固定长度字符，最长32767字节，默认长度是1，如果内容不够用空格代替 |
| LONG                 | Oracle SQL定义的数据类型，变长字符串基本类型，最长32760字节在Oracle SQL中最长2147483647字节 |
| BOOLEAN              | PL/SQL附加的数据类型，逻辑值为TRUE、FALSE、NULL |
| BINARY_INTEGER       | PL/SQL附加的数据类型，介于-231和231之间的整数 |
| PLS_INTEGER          | PL/SQL附加的数据类型，介于-231和231之间的整数类似于BINARY_INTEGER，只是PLS_INTEGER值上的运行速度更快 |
| NATURAL              | PL/SQL附加的数据类型，BINARY_INTEGER子类型，表示从0开始的自然数 |
| NATURALN             | 与NATURAL一样，只是要求NATURALN类型变量值不能为NULL |
| POSITIVE             | PL/SQL附加的数据类型，BINARY_INTEGER子类型，正整数 |
| POSITIVEN            | 与POSITIVE一样，只是要求POSITIVE的变量值不能为NULL         |
| REAL                 | Oracle SQL定义的数据类型，18位精度的浮点数                   |
| INT,INTEGER,SMALLINT | Oracle SQL定义的数据类型，NUMBERDE的子类型，38位精度整数   |
| SIGNTYPE             | PL/SQL附加的数据类型，BINARY_INTEGER子类型值有：1、-1、0 |
| STRING               | 与VARCHAR2相同 |
| BLOB | 常用于存储文件等二进制数据 |
| CLOB | 与VARCHAR2相同 区别最大长度4G字节 |

### 属性数据类型
> 当声明一个变量的值是数据库中的一行或者是数据库中某列时，可以直接使用属性类型来声明 Oracle中存在两种属性类型：%TYPE和%ROWTYPE 

**%ROWTYPE**
> 引用数据库表中的一行作为数据类型，即RECORD类型（记录类型）, 是PL/SQL附加的数据类型 表示一条记录，就相当于java中的一个对象 可以使用“.”来访问记录中的属性

例如: 
```sql
DECLARE
    myemp EMP%ROWTYPE;
BEGIN
    SELECT * INTO myemp FROM emp WHERE empno=7934;
    dbms_output.put_line(myemp.ename);
END;
```

**%TYPE**
> 引用某个变量或者数据库的列的类型作为某变量的数据类型

### 基础pl/sql代码块

```sql
declare
-- 定义变量
begin
-- 业务逻辑
end;
```

### IN/OUT 输入/输出
IN 代表输入参数 输入参数在函数/过程/包中不可修改
OUT 代表输出参数 输出参数在过程/包中可以修改 函数无OUT参数

过程/包中需要返回值时 请传入OUT参数 并将要返回的数据赋值给OUT参数

### 条件控制

#### IF语法
注意: `else if` 应为 `elsif`
```sql
IF 条件1 THEN
    -- do something
ELSIF 条件2 THEN
    -- do something
ELSE
    -- do something
END IF;
```

#### CASE语法
注意: CASE语法可以在`select`语句中使用 但是不需要`END CASE` 只需要`END`即可
```sql
-- 
CASE 数据
    WHEN 值1 THEN
        -- do something
    WHEN 值2 THEN
        -- do something
    ELSE
        -- do something
END CASE;
-- 或者
CASE 
    WHEN 数据=值1 THEN
        -- do something
    WHEN 数据=值2 THEN
        -- do something
    ELSE
        -- do something
END CASE;
```

### 循环语法
#### LOOP循环基础语法
```sql
LOOP
    --循环体
    --EXIT 或 EXIT WHEN 条件 终止循环
END LOOP;
```

#### FOR循环基础语法
```sql
/*
循环变量：该变量的值每次循环根据上下限的REVERSE关键字进行加1或者减1。
REVERSE：指明循环从上限向下限依次循环
*/
FOR 循环变量 IN [REVERSE] 循环下限..循环上限 LOOP
--循环体
END LOOP
```
**示例**
```sql
BEGIN
  FOR i in 1..5 LOOP
      dbms_output.put_line(i);
  END LOOP;
END;
/*
-- 输出
1
2
3
4
5
*/
```
for 循环还有一种特殊的隐式游标的循环 可参考[FOR循环隐式游标示例](#forCursor)


#### WHILE循环基础语法
```sql
-- 条件不满足时退出循环
WHILE 条件 LOOP
    --循环体
END LOOP;
```

### 立即执行sql`EXECUTE IMMEDIATE`
用来执行sql字符串
示例
```sql
DECLARE
  s_sql VARCHAR2(2000);
BEGIN
  s_sql := 'SELECT 1 FROM dual';
  EXECUTE IMMEDIATE s_sql;
END;
```

### 异常处理

#### 预定义常用异常

|  异常名称   |  异常码  |  描述 |
| --- | --- | --- |
| DUP_VAL_ON_INDEX    | ORA-00001    | 试图向唯一索引列插入重复值 |
| INVALID_CURSOR      | ORA-01001    | 试图进行非法游标操作 |
| INVALID_NUMBER      | ORA-01722    | 试图将字符串转换为数字 |
| NO_DATA_FOUND       | ORA-01403    | SELECT INTO语句中没有返回任何记录 |
| TOO_MANY_ROWS       | ORA-01422    | SELECT INTO语句中返回多于1条记录 |
| ZERO_DIVIDE         | ORA-01476    | 试图用0作为除数 |
| CURSOR_ALREADY_OPEN | ORA-06511    | 试图打开一个已经打开的游标 |
| OTHERS |  | 包含所有异常 类似于java中的`Exception`类 |

#### 异常处理语法
```sql
BEGIN
  --可执行部分
EXCEPTION   -- 异常处理开始
  WHEN 异常名1 THEN
       --对应异常处理
  WHEN 异常名2 THEN
       --对应异常处理
       ……
  WHEN OTHERS THEN
       --其他异常处理
END;
```

**示例**

```sql
DECLARE
  n_num NUMBER;
BEGIN
  SELECT 1/0 INTO n_num FROM dual;
  EXCEPTION
    WHEN ZERO_DIVIDE THEN
      dbms_output.put_line('除数不能为0!');
END;
/*
-- 输出
除数不能为0!
*/
```

### 错误获取

#### `sqlcode`
`sqlcode`关键字 可以获取错误代码

#### 获取错误信息
`dbms_utility.format_error_backtrace()`

### 游标
前面 [变量与常量](#变量与常量)一章说到可以用`SELECT xxx INTO xxx`语法对变量进行赋值 通常用于取出某个表的数据 但这种情况只适用于SELECT只查询到一条数据的情况 如果SELECT查询到多条且想循环赋值并执行其他操作 此时便可以使用游标

> 游标的概念: 
    游标是SQL的一个内存工作区，由系统或用户以变量的形式定义。游标的作用就是用于临时存储从数据库中提取的数据块。在某些情况下，需要把数据从存放在磁盘的表中调到计算机内存中进行处理，最后将处理结果显示出来或最终写回数据库。这样数据处理的速度才会提高，否则频繁的磁盘数据交换会降低效率。 
游标有两种类型：显式游标和隐式游标。在前述程序中用到的SELECT...INTO...查询语句，一次只能从数据库中提取一行数据，对于这种形式的查询和DML操作，系统都会使用一个隐式游标。但是如果要提取多行数据，就要由程序员定义一个显式游标，并通过与游标有关的语句进行处理。显式游标对应一个返回结果为多行多列的SELECT语句。 
游标一旦打开，数据就从数据库中传送到游标变量中，然后应用程序再从游标变量中分解出需要的数据，并进行处理。 

#### 隐式游标 
如前所述，DML操作和单行SELECT语句会使用隐式游标，它们是 `INSERT` `UPDATE` `DELETE` `SELECT ... INTO ...`
> 当系统使用一个隐式游标时，可以通过隐式游标的属性来了解操作的状态和结果，进而控制程序的流程。隐式游标可以使用名字SQL来访问，但要注意，通过SQL游标名总是只能访问前一个DML操作或单行SELECT操作的游标属性。所以通常在刚刚执行完操作之后，立即使用SQL游标名来访问属性

| 隐式游标的属性 | 返回值类型 | 意义 |
| --- | --- | --- |
| SQL%ROWCOUNT | 整型 | 代表DML语句成功执行的数据行数 |
| SQL%FOUND | 布尔型 | 值为TRUE代表插入、删除、更新或单行查询操作成功 |
| SQL%NOTFOUND | 布尔型 | 与SQL%FOUND属性返回值相反 |
| SQL%ISOPEN | 布尔型 | DML执行过程中为真，结束后为假 |

**示例**
```sql
BEGIN
  UPDATE emp SET sal = sal + 100 WHERE empno = 1234;
  IF SQL%FOUND THEN
    DBMS_OUTPUT.PUT_LINE('成功修改雇员工资！');
    COMMIT;
  ELSE
    DBMS_OUTPUT.PUT_LINE('修改雇员工资失败！');
  END IF;
END;
```

**FOR循环隐式游标示例** <a id="forCursor"></a>

```sql
BEGIN
  for e in (select * from emp) LOOP
    DBMS_OUTPUT.PUT_LINE(e.ename);
  END LOOP;
END;
```

#### 显式游标

**声明游标**
`CURSOR 游标名[(参数1 数据类型[, 参数2 数据类型...])] IS SELECT语句`

**打开游标**
`OPEN 游标名[(实际参数1[, 实际参数2...])]`

**提取数据**
1. `FETCH 游标名 INTO 变量名1[, 变量名2...];`
2. `FETCH 游标名 INTO 记录变量;`

第一种格式中的变量名是用来从游标中接收数据的变量，需要事先定义。变量的个数和类型应与SELECT语句中的字段变量的个数和类型一致。 
第二种格式一次将一行数据取到记录变量中，需要使用%ROWTYPE(`记录变量 游标名%ROWTYPE`)事先定义记录变量，这种形式使用起来比较方便，不必分别定义和使用多个变量

**关闭游标**
`CLOSE 游标名;`
显式游标打开后，必须显式地关闭。游标一旦关闭，游标占用的资源就被释放，游标变成无效，必须重新打开才能使用

**示例**

```sql
DECLARE
  v_ename VARCHAR2(10);
  v_job   VARCHAR2(10);
  CURSOR emp_cursor IS
    SELECT ename, job FROM emp;
BEGIN
  OPEN emp_cursor;
  LOOP
    FETCH emp_cursor
      INTO v_ename, v_job;
    DBMS_OUTPUT.PUT_LINE(v_ename || ',' || v_job);
    EXIT WHEN emp_cursor%NOTFOUND;
  END LOOP;
  CLOSE emp_cursor;
END;

-- foreach循环 无需显式打开/关闭游标
DECLARE
  CURSOR emp_cursor IS
    SELECT ename, job FROM emp;
BEGIN
  FOR c_record IN emp_cursor LOOP
    DBMS_OUTPUT.PUT_LINE(c_record.ename || ',' || c_record.job);
  END LOOP;
END;
```

### 编程规范

#### 大小写规范
| 类型 | 约定 | 举例           |
| -------------- | -------------- | ------------------------ |
| 保留字         | 大写           | BEGIN、DECLARE、ELSIF    |
| 内置函数       | 大写           | SUBSTR、COUNT、TO_NUMBER |
| 预定义类型     | 大写           | NUMBER(7,2)、BOOLEAN     |
| SQL关键字      | 大写           | SELECT、INTO、WHERE      |
| 数据库对象     | 小写           | abc007、ac021            |
| 变量名         | 小写           | gn_dwhrbl                |

#### 变量命名规范
| 数据类型 | 变量名前缀 |
| --- | --- |
| date | d_ |
| number | n_ |
| varchar | s_ |
| varchar2 | s_ |
| cursor | cur_ |
| boolean | b_ |
| clob | c_ |

## 函数

```sql
CREATE OR REPLACE FUNCTION 函数名(参数1 IN 参数1数据类型, 参数2 IN 参数2数据类型) RETURN 返回值数据类型 IS
   -- 变量声明
BEGIN
   -- pl/sql代码块
   RETURN 返回值;
EXCEPTION
   WHEN OTHERS THEN
      RETURN 返回值;
END 函数名;
```

## 过程
```sql
CREATE OR REPLACE PROCEDURE 过程名(参数1 IN 参数1数据类型, 参数2 IN 参数2数据类型, 参数3 OUT 参数3数据类型) IS
   -- 变量声明
BEGIN
   -- pl/sql代码块
EXCEPTION
   WHEN OTHERS THEN
    -- pl/sql代码块
END 过程名;
```

## 程序包
程序包`PACKAGE`是指多个过程的合集 实际开发中可以将多个相似业务的过程放到一个程序包中
程序包体`PACKAGE BODY`是对程序包的实现`PACKAGE`只定义过程名及参数未做具体实现
`PACKAGE`可以类比于java中的`interface`
`PACKAGE BODY`可以类比于java中的`interface`的实现类
```sql
CREATE OR REPLACE PACKAGE 程序包名 IS
-- 声明过程
PROCEDURE 过程名1();
PROCEDURE 过程名2();
END 程序包名;

CREATE OR REPLACE PACKAGE BODY 程序包名 IS
-- 实现过程
PROCEDURE 过程名1() IS
BEGIN
-- pl/sql代码块
END 过程名1;

PROCEDURE 过程名2() IS
BEGIN
-- pl/sql代码块
END 过程名2;
```

## pl/sql developer工具使用技巧

### 快捷输入
设置方法：菜单Tools --> Preferences --> Editor --> AutoReplace.(勾选) --> Edit

参考规则

```
s=SELECT
f=FROM
i=INSERT
u=UPDATE
d=DELETE
w=WHERE
o=ORDER BY
sf=SELECT * FROM
df=DELETE FROM
sc=SELECT COUNT (*) FROM
```

**使用方法**
例如 `sf=SELECT * FROM`
在sql窗口输入`sf`空格即可快速输入`SELECT * FROM`

### 数字显示精确值
过长的数字会用科学计数法展示
修改设置 勾选 Tools --> Preferences --> Window types -->  SQL Window  --> Number fields to_char
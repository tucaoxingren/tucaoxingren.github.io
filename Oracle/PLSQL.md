---
title: PL/SQL
date: 2017-11-28
time: 21:12:05
categories: oracle
toc: true
tag: 
---
</p>

# PL/SQL

# PL/SQL基本语法
```sql
DECLARE
    声明 - 定义对象的可选部分 
    1. 表示程序块声明部分的开始 
    2. 声明对于程序块而言是局部的
BEGIN
    可执行语句 - 构成可执行语句的必要部分 
    表示程序块可执行部分的开始 
EXCEPTION
    例外处理程序 - 构成错误处理代码的可选部分 
END; - 表示程序块的结束 
```

## 变量
1. 以使用变量存储查询结果以便以后处理，或使用变量来计算要插入到数据库表中的值 
2. 在 SQL 或 PL/SQL语句中，都可以将 PL/SQL变量用于表达式的任何位置
3. 在其他语句（包括声明性语句）中对其引用前必须先进行声明 
4. 是通过指定数据类型的名称来声明的 
5. 可以被声明为任何 Oracle 内部数据类型

> 示例 `变量名 数据类型`
> 
> oldfare NUMBER(5);
> 
> m_name VARCHAR(15);
> 
> cont BOOLEAN;

## 常量
>示例 `变量名 CONSTANT 数据类型 := 赋值`
>
>bonus_multiplier CONSTANT NUMBER(3,2) := 0.33;

## 使用属性声明变量和常量
>PL/SQL 对象（如变量和常量）和数据库对象（如列和表）与某些属性关联 
>
>这些属性可以用于简化变量和常量声明 

## 使用 SELECT INTO 进行赋值
>可以按如下方法使用 SELECT INTO 对变量赋值

```sql
SELECT <列名> INTO <变量名>

FROM <表名> WHERE <条件>;
```

示例

`SELECT first_fare INTO oldfare FROM fare WHERE route_code = ‘SAN-LOU’;`

SELECT 语句执行后，将出现下列情况之一 

1. 只检索了一行 
2. 检索了多行 
3. 不检索任何行 

仅当它检索一行时，SELECT 才成功操作 
其他两种情况将导致错误并产生异常处理程序

## 接受用户输入的值

使用“&”操作符及赋值操作符可以接受用户输入的值 

示例 

`mbranch_code := ‘&mcode’;`

`num := &num;`

`mcode`是绑定变量，不应该声明，但是需要声明 `mbranch_code`

## 特殊数据类型  %type record %rowtype

```sql
-- %type 定义变量时定义为已存在的列或变量的数据类型
declare
  var_ename emp.ename%type;
begin
  SELECT ename INTO var_ename
  FROM emp
  WHERE ename='SMITH';
end;

-- %rowtype记录表中一行的数据类型
declare
-- emp_row表示变量名；emp为指定的表名，表示用来存储哪个表中的一行数据
   emp_row emp%rowtype;
begin
  select * into emp_row
  from emp
  where empno=7369;
end;

-- record类型 记录特定列的类型
declare
  type emp_record is record --emp_record为定义的记录类型名
  (
       var_ename varchar2(20),
       var_job varchar2(20),
       var_sal number
   );
   -- 声明一个记录类型的变量
   empinfo emp_record;
   -- 使用声明的记录类型变量
begin
  select ename,job,sal into empinfo
  from emp
  where empno=7369;
end;
```

## 程序流程控制

### IF-THEN-ELSIF 结构
    此结构可以从几个互斥的、排它的选项中选择操作行为 

    IF 语句可以具有任意数目的 ELSIF 子句 

    最终的 ELSE 是可选项

    将按自顶向下的顺序逐项检测条件 

```sql
-- `[]`可缺省
IF <条件1> THEN
    语句;
[ELSIF <条件2> THEN]
    [语句;]
[ELSIF <条件3> THEN]
    [语句;]
[ELSE]
    [语句;]
END IF;
```

### 循环控制
    使用 LOOP 或  GOTO 语句可以重复或跳过程序块的选取部分
    有三种形式的 LOOP 语句 
    LOOP
    WHILE-LOOP
    FOR-LOOP

    LOOP 将重复某些语句序列 
    被重复的语句位于关键词  LOOP 和  END LOOP 之间 
    每执行一次循环迭代过程，就执行一次语句序列，然后控制又回到循环的开始位置 
```sql
LOOP
    语句;
END LOOP;

LOOP
    语句;
    IF <条件> THEN
        EXIT;   --立即退出循环 
    END IF;
END LOOP;
--控制到此处恢复 

LOOP
    语句;
    EXIT WHEN <条件>;-- 如果判定条件为 TRUE,则循环完成 
END LOOP;

```

### WHILE-LOOP 语句 
    将条件与 LOOP-END LOOP 中的语句序列相关联 
    在每次循环前判定条件 
    如果条件值为 TRUE，就执行一次语句序列，然后控制又回到循环的开始位置 
    如果条件判定为 FALSE 或 NULL，则绕过循环，并且控制转到下一个语句 

```sql
-- 循环执行的次数取决于条件且只有完成循环后才可知 
WHILE <条件>
    LOOP
        语句;
    END LOOP;
```

### FOR-LOOP 语句 
    循环在指定的整数范围内进行 
    对于一定范围内的每个整数，都执行一次该语句
    此范围为循环架构的一部分，它位于 FOR 和 LOOP 之间 
    当首次进入循环时，范围只判定一次 
    每执行一次循环，循环计数器就会增加

```sql
-- 不能为循环计数器赋值 
-- 在运行时可以动态分配循环范围 
FOR <计数器> IN [逆转] 
    lower_bound .. higher_bound 
LOOP
    语句;
END LOOP;
```

### GOTO 语句 
    无条件分支到一个标签 
    执行时，语句将更改 PL/SQL 程序块的控制流
编制 GOTO 语句代码需要有两个部分

1. 定义标签名称 
2. 使用 GOTO 语句将控制转到标签

在下列位置可以使用 GOTO 语句来转移控制 

1. 从程序块到可执行语句 
2. 从异常处理程序分支到封闭的程序块 

不允许在下列位置使用 GOTO 语句来转移控制

1. 从某个 IF 语句或循环子句内转到其他语句
2. 从封闭程序块转到某个子程序块
3. 从异常处理程序转到当前程序块
4. 子程序之外
5. 转到关键字

```sql
-- 标签名称 
    -- 可以选择将其用于命名 PL/SQL程序块或程序块中的语句
    -- 使用尖括号进行定义 (<<  >>)
<<if_fare_label>>
IF 条件 THEN
    语句;
END IF;
    语句;
GOTO if_fare_label;
```

### 游标(cursor)

声明游标语法：`cursor  <游标名>  is  select语句;`
声明ref游标语法: `<游标名>  is  ref  cursor;`
打开游标语法：`open  <游标名>;`
移动游标并获取数据语法：`fetch  <游标名>  into  <用于保存读取的数据的变量的名>;`
关闭游标语法:`close  <游标名>;`
游标属性（游标的属性必须在关闭游标之前）：
 `%isopen` 判断游标是否打开
 `%notfound` 找不到数据时
 `%found`
 `%rowcount` 返回当前游标已扫描的数据行数量
游标分类：1、显示游标（自定义游标）；2、隐示游标（系统游标）；3、REF游标
```sql
--例：
declare
  v_row t_test%rowtype; -- 匹配t_test表中一行所有的数据类型
  cursor v_cur is select * from t_test;-- 声明游标
begin
  open v_cur;-- 打开游标
  loop
    fetch v_cur into v_row;-- 将游标所在行的数据转存到v_row中
    exit when v_cur%notfound; -- 当游标到最后一行时跳出
    dbms_output.put_line('id = '||v_row.t_id||'  name = '||v_row.t_name||'  msg = '||v_row.t_msg);
  end loop;
  close v_cur;-- 关闭游标
exception
  when others then dbms_output.put_line('throw exception: others');
end;
-- /
-- REF游标 --
create or replace package upk_select_test
as type uc_test is ref cursor; -- 声明ref游标
end upk_select_test;
-- /
-- 存储过程中调用ref游标，并将查询结果以游标的方式返回
create or replace procedure up_select_test_2
(uc_result out upk_select_test.uc_test)
is
begin
  open uc_result for select * from t_test;
end up_select_test_2;
```








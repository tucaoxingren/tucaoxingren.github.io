---
title: Oracle学习笔记
date: 2017-11-21
time: 13:41:05
categories: 
toc: true
tag: oracle
---
</p>
# Oracle

## 特殊用户
sys用户是超级用户，具有最高权限，具有sysdba角色，有 create database的权限
	默认密码是 chang_on_install

system用户是管理操作员，权限也很大。具有sysoper角色，没有 create database的权限
	默认的密码是 manager

## 特殊角色
dba  	数据库管理员角色
sysdba	系统管理员角色
sysoper	系统操作员角色

## 角色权限比较
sysdba > sysoper > dba

sys用户 	具有 dba sysdba sysoper角色
system用户 	具有 dba sysdba角色

## pl/sql
pl/sql(procedural language/sql)是oracle在标准sql语言上的扩展
pl/sql不仅允许嵌入sql语言，还可以定义 **变量** 和 **常量** ，允许使用条件语句和循环语句，允许使用例外处理各种错误

## oracle函数
```sql
-- oracle 创建函数的一般格式
CREATE [OR REPLACE] FUNCTION function_name
 (arg1 [ { IN | OUT | IN OUT }] type1 [DEFAULT value1],
 [arg2 [ { IN | OUT | IN OUT }] type2 [DEFAULT value1]],
 ......
 [argn [ { IN | OUT | IN OUT }] typen [DEFAULT valuen]])
 [ AUTHID DEFINER | CURRENT_USER ]
RETURN return_type
 IS | AS
    <类型.变量的声明部分>
BEGIN
    执行部分
    RETURN expression
EXCEPTION
    异常处理部分
END function_name;
```

> IN,OUT,IN OUT是形参的模式。若省略，则为IN模式。IN模式的形参只能将实参传递给形参，进入函数内部，但只能读不能写，函数返回时实参的值不变。OUT模式的形参会忽略调用时的实参值（或说该形参的初始值总是NULL），但在函数内部可以被读或写，函数返回时形参的值会赋予给实参。IN OUT具有前两种模式的特性，即调用时，实参的值总是传递给形参，结束时，形参的值传递给实参。调用时，对于IN模式的实参可以是常量或变量，但对于OUT和IN OUT模式的实参必须是变量。      一般，只有在确认function_name函数是新函数或是要更新的函数时，才使用OR REPALCE关键字，否则容易删除有用的函数。

## JavaWeb连接oracle数据库
javaWEB项目与普通java项目在连接oracle数据库上略有不同

普通java项目直接将ojdbc.jar构建路径即可

而javaweb项目却可能并不能运行，需要再设置一下：

项目名上右键点击→属性→Deployment Assembly→Add→java Build Path Entries →ojdbc.jar,最后确定，重新运行项目。



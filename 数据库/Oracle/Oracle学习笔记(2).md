---
title: Oracle学习笔记(2)
date: 2017-11-21
time: 13:41:05
categories: oracle
toc: true
tag: oracle
---
</p>
# Oracle学习笔记(2)

## 常用函数
```sql
-- date -> char  and  char -> date
select hiredate,to_char(hiredate,'yyyy-mm-dd') "日期转字符串",
       to_date('2015-12-31','yyyy-mm/dd') "字符串转日期"
from emp;
-- number -> char  and  char -> number
select sal,to_char(sal,'$9999.999'),to_number('2423423') from emp;
-- NVL(A,B) 如果A为null则返回B，否则返回A
select sal "薪水",comm "奖金",sal+nvl(comm,0) "薪金和" from emp;
-- NVL2(A,B,C) 如果A不为null 返回B 为null返回C
select sal,comm,nvl2(comm,1000,100) from emp;
-- NULLIF(A,B) 如果A和B相等 返回null 否则 返回A
select comm,nullif(comm,500) from emp;
-- COLAESCE(expr1,expr2,...,exprn) 返回清单中的第一个非空值
select coalesce(null,null,2,null) from dual;
-- DECODE(col|expression,search1,result1[,search2,result2,...,][,default])
select sal,decode(sal,800,'a',1600,'b','c') from emp;
-- 分组函数 AVG MAX MIN COUNT SUM
SELECT COUNT(*),SUM(SAL),AVG(SAL),MAX(SAL),MIN(SAL) FROM EMP;
SELECT DEPTNO,COUNT(*) FROM EMP GROUP BY DEPTNO;

SELECT * FROM EMP;

-- 查询雇员姓名以及所属部门的名字
select e.ename,d.dname from emp e,dept d where e.deptno=d.deptno;
```
## 外连接
```sql
-- 查询所有部门的名字及他们所包含员工的名字
select d.dname,e.ename
from emp e,dept d
where d.deptno=e.deptno(+);-- 左外连接 显示右表的剩余结果
--where d.deptno(+)=e.deptno;-- 右外连接 显示左表的剩余结果
```

## 自连接

```sql
-- 查询所有员工的领导的名字
select e1.ename,e2.ename mgr
from emp e1,emp e2
where e1.mgr=e2.empno(+);
```

## 子查询
```sql
-- 子查询语句只有一行结果 -> 单行比较操作符  <,<=,>,>=,<>,is not null
-- 子查询语句有多行结果 -> 多行操作符   NOT IN  IN  ANY  ALL
-- 子查询语句 有一个null  整个查询语句返回的结果都是 null
select ename,sal from emp where sal>(select sal from emp where ename='ALLEN');
select sal from emp where ename='ALLEN';
-- 查询工资最高的前5名
select ename,sal
from (select * from emp order by sal desc)
where rownum <=5;
```

## 集合操作
```sql
-- 并 -> UNION/UNION ALL
-- 交 -> INTERSECT
-- 差 -> MINUS
select empno,ename,sal from emp where sal>1500
MINUS
select empno,ename,sal from emp where sal<3000;
```

## 行转列
```sql
-- 查询员工总数，以及分布在1980 1981 1982 1987 雇佣的员工人数
select count(*) total,
       sum(decode(extract(year from hiredate),'1980',1,0))"1980",
       sum(decode(extract(year from hiredate),'1981',1,0))"1981",
       sum(decode(extract(year from hiredate),'1982',1,0))"1982",
       sum(decode(extract(year from hiredate),'1987',1,0))"1987"
from emp;
```

## 存储过程
调用存储过程的方式

1. 命令窗口下：
   set serveroutput on
   exec produre_name;
2. SQL 窗口下：
   begin
       produre_name(参数值...);
   end;
3. 一个存储过程可以调用另一个存储过程

存储过程示例
```sql
create or replace procedure proc1(eno in number,salary out number) is
begin
  select sal into salary from emp where empno=eno;
  dbms_output.put_line(salary);
end proc1;
-- 调用示例  sql窗口下
declare
  salary number;
begin
  proc1(7499,salary);  
end;
-- 测试窗口下
begin
  proc1(eno => :eno,salary => :salary);  
end;
```

## 函数
函数示例
```sql
create or replace function fn1(eno IN number) return number
is
  salary number ;
begin
  select sal into salary from emp where empno=eno;
  return salary;
exception
  when too_many_rows then
    return -1;
    when no_data_found then
      return -2;
      when others then
        return 0;
end fn1;
-- 调用示例
select fn1(7499) from dual;--dual是一张Oracle的特殊表

begin
  dbms_output.put_line(fn1(7499));
end;
```

## dual表
>Dual 是 Oracle中的一个实际存在的表，任何用户均可读取，常用在没有目标表的Select语句块中

>DUAL表可以执行插入、更新、删除操作，还可以执行drop操作。但是不要去执行drop表的操作，否则会使系统不能用，数据库起不了，会报Database startup crashes with ORA-1092错误

>如果DUAL表被“不幸”删除后的恢复：用sys用户登陆。创建DUAL表。授予公众SELECT权限（SQL如上述，但不要给UPDATE，INSERT，DELETE权限）

>向DUAL表插入一条记录（仅此一条）： insert into dual values('X');提交修改

```sql
--用sys用户登陆。
SQL> create pfile=’d:\pfile.bak’ from spfile
SQL> shutdown immediate
--在d:\pfile.bak文件中最后加入一条：replication_dependency_tracking = FALSE
--重新启动数据库：
SQL> startup pfile=’d:\pfile.bak’
SQL> create table “sys”.”DUAL”
( “DUMMY” varchar2(1) )
pctfree 10 pctused 4;
SQL> insert into dual values(‘X’);
SQL> commit;
SQL> Grant select on dual to Public;

SQL> select * from dual;
D
-
X
SQL> shutdown immediate
数据库已经关闭。
已经卸载数据库。
ORACLE 例程已经关闭。
SQL> startup
ORACLE 例程已经启动。
Total System Global Area 135338868 bytes
Fixed Size                   453492 bytes
Variable Size             109051904 bytes
Database Buffers           25165824 bytes
Redo Buffers                 667648 bytes
数据库装载完毕。
数据库已经打开。
SQL>
--OK， 下面就可以正常使用了
```
[详解Oracle数据库中DUAL表的使用](http://database.51cto.com/art/200905/123612.htm)
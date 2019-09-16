需要给用户授权 grant select any dictionary to xjsi_p_cz;
--COMMAND_TYPE 代码值
SELECT * FROM v$sqlcommand;

--exesqltext 将绑定变量赋值在sql脚本中
select sql_text,
       sql_fulltext,
       sql_id,
       --sql_arg,
       fun_sql_BindArg(sql_arg,sql_fulltext) as exesqltext,
       "执行时间'S'",
       "执行次数",
       "COST",
       SORTS,
       MODULE,
       "物理读",
       "物理写",
       "返回行数",
       "磁盘读",
       "直接路径写",
       PARSING_SCHEMA_NAME,
       COMMAND_TYPE,
       LAST_ACTIVE_TIME
   from (
SELECT S.SQL_TEXT,
       S.SQL_FULLTEXT,
       S.SQL_ID,
       (SELECT listagg(NAME||'#'||value_string||ANYDATA.accesstimestamp(value_anydata),';') within group (order by SQL_ID) --ANYDATA.accesstimestamp(value_anydata)
          From gV$sql_Bind_Capture A where a.sql_id = s.sql_id and rownum <30) as sql_arg,
       ROUND(ELAPSED_TIME / 1000000 / (CASE
               WHEN (EXECUTIONS = 0 OR NVL(EXECUTIONS, 1 ) = 1) THEN
                1
               ELSE
                EXECUTIONS
             END),
             2) "执行时间'S'",
       S.EXECUTIONS "执行次数",
       S.OPTIMIZER_COST "COST",
       S.SORTS,
       S.MODULE, --连接模式（JDBC THIN CLIENT：程序）
       -- S.LOCKED_TOTAL,
       S.PHYSICAL_READ_BYTES "物理读",
       -- S.PHYSICAL_READ_REQUESTS "物理读请求",
       S.PHYSICAL_WRITE_REQUESTS "物理写",
       -- S.PHYSICAL_WRITE_BYTES "物理写请求",
       S.ROWS_PROCESSED      "返回行数",
       S.DISK_READS          "磁盘读",
       S.DIRECT_WRITES       "直接路径写",
       S.PARSING_SCHEMA_NAME,
       S.COMMAND_TYPE,
       S.LAST_ACTIVE_TIME
  FROM GV$SQLAREA S
 WHERE ROUND(ELAPSED_TIME / 1000000 / (CASE
               WHEN (EXECUTIONS = 0 OR NVL(EXECUTIONS, 1 ) = 1) THEN
                1
               ELSE
                EXECUTIONS
             END),
             2) > 2 --100 0000微秒=1S
   AND S.PARSING_SCHEMA_NAME = USER
   AND S.MODULE='JDBC Thin Client'
   AND TO_CHAR(S.LAST_ACTIVE_TIME, 'YYYY-MM-DD') =
       TO_CHAR( SYSDATE, 'YYYY-MM-DD' )
   AND S.COMMAND_TYPE IN (2 , 3, 5, 6 ,7 , 189) )
 ORDER BY "执行时间'S'" DESC;
 
SELECT S.SQL_TEXT,
       S.SQL_FULLTEXT,
       S.SQL_ID,
       (SELECT listagg(NAME||','||'-->'||value_string||' '||ANYDATA.accesstimestamp(value_anydata),',') within group (order by SQL_ID) --ANYDATA.accesstimestamp(value_anydata)
          From gV$sql_Bind_Capture A where a.sql_id = s.sql_id) as arg,
       ROUND(ELAPSED_TIME / 1000000 / (CASE
               WHEN (EXECUTIONS = 0 OR NVL(EXECUTIONS, 1 ) = 1) THEN
                1
               ELSE
                EXECUTIONS
             END),
             2) "执行时间'S'",
       S.EXECUTIONS "执行次数",
       S.OPTIMIZER_COST "COST",
       S.SORTS,
       S.MODULE, --连接模式（JDBC THIN CLIENT：程序）
       -- S.LOCKED_TOTAL,
       S.PHYSICAL_READ_BYTES "物理读",
       -- S.PHYSICAL_READ_REQUESTS "物理读请求",
       S.PHYSICAL_WRITE_REQUESTS "物理写",
       -- S.PHYSICAL_WRITE_BYTES "物理写请求",
       S.ROWS_PROCESSED      "返回行数",
       S.DISK_READS          "磁盘读",
       S.DIRECT_WRITES       "直接路径写",
       S.PARSING_SCHEMA_NAME,
       S.LAST_LOAD_TIME,
       S.LAST_ACTIVE_TIME
  FROM GV$SQLAREA S
 WHERE ROUND(ELAPSED_TIME / 1000000 / (CASE
               WHEN (EXECUTIONS = 0 OR NVL(EXECUTIONS, 1 ) = 1) THEN
                1
               ELSE
                EXECUTIONS
             END),
             2) > 2 --100 0000微秒=1S
   AND S.PARSING_SCHEMA_NAME = USER
   AND TO_CHAR(S.LAST_LOAD_TIME, 'YYYY-MM-DD') =
       TO_CHAR( SYSDATE, 'YYYY-MM-DD' )
   --AND S.COMMAND_TYPE IN (2 , 3, 5, 6 ,7, 189)
 ORDER BY "执行时间'S'" DESC;

 --可以获取到sql_id的执行主机
 select * from dba_hist_active_sess_history where sql_id ='dd13sr39vjzm3';
 
 --获取历史信息
 select * from v$active_session_history;
 
 

ORACLE 获取绑定变量值

--- 查看进程正在执行的SQL
select p.SPID,sql.SQL_TEXT,sql.SQL_FULLTEXT,sql.sql_id,s.* from gv$process p , gv$session s,gv$sqlarea sql 
where p.ADDR=s.PADDR and p.INST_ID=s.INST_ID  and sql.INST_ID=s.INST_ID
and sql.ADDRESS=s.SQL_ADDRESS


-- ORACLE 获取绑定变量值：

SELECT SQL_ID,NAME, POSITION, value_string, ANYDATA.accesstimestamp(value_anydata)
  From gV$sql_Bind_Capture A
 Where sql_id='aqfcs7drzzcfw';

时间变量通过 ANYDATA.accesstimestamp(value_anydata)显示。



create or replace function fun_sql_BindArg(in_str in varchar2,in_clob in clob) return clob is
   i Number(10);
   str_arg varchar2(4000);
   out_clob clob:=' ';
begin
    i:=0;
    out_clob:= in_clob;
    if trim(in_str) is not null then
       Loop
         i:=i+1;
         str_arg:= fun_split_str(in_str,';',i);
         if trim(str_arg) is null then    
            exit ;
         end if;
         out_clob := regexp_replace(out_clob,fun_split_str(str_arg,'#',1)||'[^0-9]',''''||fun_split_str(str_arg,'#',2)||'''');
       end loop; 
   end if;
   RETURN out_clob;   
end fun_sql_BindArg;



CREATE OR REPLACE FUNCTION fun_split_str(p_input IN VARCHAR2,s_split IN VARCHAR2,n_count IN NUMBER)
    RETURN VARCHAR2 AS
       v_return VARCHAR2(4000);
    BEGIN
      IF (n_count=1) THEN
        SELECT SUBSTR(REGEXP_REPLACE(TRIM(p_input),'['||s_split||']+',s_split)||s_split,
                    1,
                    INSTR(REGEXP_REPLACE(TRIM(p_input),'['||s_split||']+',s_split)||s_split,s_split,1,n_count)-1)
        INTO v_return
        FROM DUAL;
      ELSE
        SELECT SUBSTR(REGEXP_REPLACE(TRIM(p_input),'['||s_split||']+',s_split)||s_split,
                    INSTR(REGEXP_REPLACE(TRIM(p_input),'['||s_split||']+',s_split)||s_split,s_split,1,DECODE(n_count-1,'0','1',n_count-1))+1,
                    INSTR(REGEXP_REPLACE(TRIM(p_input),'['||s_split||']+',s_split)||s_split,s_split,1,n_count)-INSTR(REGEXP_REPLACE(TRIM(p_input),'['||s_split||']+',s_split)||s_split,s_split,1,n_count-1)-1)
        INTO v_return
        FROM DUAL;
      END IF;

        RETURN v_return;
    END;





select sql_text,
       sql_fulltext,
       sql_id,
       --sql_arg,
       --fun_sql_BindArg(sql_arg,sql_fulltext) as exesqltext,
       "执行时间'S'",
       "执行次数",
       "COST",
       SORTS,
       MODULE,
       "物理读",
       "物理写",
       "返回行数",
       "磁盘读",
       "直接路径写",
       PARSING_SCHEMA_NAME,
       LAST_ACTIVE_TIME
   from (
SELECT S.SQL_TEXT,
       S.SQL_FULLTEXT,
       S.SQL_ID,
       /*(SELECT listagg(NAME||'#'||value_string||ANYDATA.accesstimestamp(value_anydata),';') within group (order by SQL_ID) --ANYDATA.accesstimestamp(value_anydata)
          From gV$sql_Bind_Capture A where a.sql_id = s.sql_id and rownum <30) as sql_arg,*/
       ROUND(ELAPSED_TIME / 1000000 / (CASE
               WHEN (EXECUTIONS = 0 OR NVL(EXECUTIONS, 1 ) = 1) THEN
                1
               ELSE
                EXECUTIONS
             END),
             2) "执行时间'S'",
       S.EXECUTIONS "执行次数",
       S.OPTIMIZER_COST "COST",
       S.SORTS,
       S.MODULE, --连接模式（JDBC THIN CLIENT：程序）
       -- S.LOCKED_TOTAL,
       S.PHYSICAL_READ_BYTES "物理读",
       -- S.PHYSICAL_READ_REQUESTS "物理读请求",
       S.PHYSICAL_WRITE_REQUESTS "物理写",
       -- S.PHYSICAL_WRITE_BYTES "物理写请求",
       S.ROWS_PROCESSED      "返回行数",
       S.DISK_READS          "磁盘读",
       S.DIRECT_WRITES       "直接路径写",
       S.PARSING_SCHEMA_NAME,
       S.LAST_ACTIVE_TIME
  FROM GV$SQLAREA S
 WHERE ROUND(ELAPSED_TIME / 1000000 / (CASE
               WHEN (EXECUTIONS = 0 OR NVL(EXECUTIONS, 1 ) = 1) THEN
                1
               ELSE
                EXECUTIONS
             END),
             2) >=0 --100 0000微秒=1S
   AND S.PARSING_SCHEMA_NAME = USER
   --AND S.MODULE='JDBC Thin Client'
   AND TO_CHAR(S.LAST_ACTIVE_TIME, 'YYYY-MM-DD') =
       TO_CHAR( SYSDATE, 'YYYY-MM-DD' )
   and S.SQL_TEXT like 'select aa10a1po0_.AAA100 as col_0_0_%'
   AND S.COMMAND_TYPE IN (2 , 3, 5, 6 , 189) )
 ORDER BY LAST_ACTIVE_TIME DESC;
 
 
 select * from v$active_session_history
 
 select count(1),to_char(sample_time,'yyyymmdd hh24:mi:ss') 
 from dba_hist_active_sess_history 
 group by to_char(sample_time,'yyyymmdd hh24:mi:ss');
 

v$sql command_type各数字所代表的含义
1
CREATE TABLE
2
INSERT

3
SELECT
4
CREATE CLUSTER

5
ALTER CLUSTER
6
UPDATE

7
DELETE
8
DROP CLUSTER

9
CREATE INDEX
10
DROP INDEX

11
ALTER INDEX
12
DROP TABLE

13
CREATE SEQUENCE
14
ALTER SEQUENCE

15
ALTER TABLE
16
DROP SEQUENCE

17
GRANT OBJECT
18
REVOKE OBJECT

19
CREATE SYNONYM
20
DROP SYNONYM

21
CREATE VIEW
22
DROP VIEW

23
VALIDATE INDEX
24
CREATE PROCEDURE

25
ALTER PROCEDURE
26
LOCK

27
NO-OP
28
RENAME

29
COMMENT
30
AUDIT OBJECT

31
NOAUDIT OBJECT
32
CREATE DATABASE LINK

33
DROP DATABASE LINK
34
CREATE DATABASE

35
ALTER DATABASE
36
CREATE ROLLBACK SEG

37
ALTER ROLLBACK SEG
38
DROP ROLLBACK SEG

39
CREATE TABLESPACE
40
ALTER TABLESPACE

41
DROP TABLESPACE
42
ALTER SESSION

43
ALTER USER
44
COMMIT

45
ROLLBACK
46
SAVEPOINT

47
PL/SQL EXECUTE
48
SET TRANSACTION

49
ALTER SYSTEM
50
EXPLAIN

51
CREATE USER
52
CREATE ROLE

53
DROP USER
54
DROP ROLE

55
SET ROLE
56
CREATE SCHEMA

57
CREATE CONTROL FILE
59
CREATE TRIGGER

60
ALTER TRIGGER
61
DROP TRIGGER

62
ANALYZE TABLE
63
ANALYZE INDEX

64
ANALYZE CLUSTER
65
CREATE PROFILE

66
DROP PROFILE
67
ALTER PROFILE

68
DROP PROCEDURE
70
ALTER RESOURCE COST

71
CREATE SNAPSHOT LOG
72
ALTER SNAPSHOT LOG

73
DROP SNAPSHOT LOG
74
CREATE SNAPSHOT

75
ALTER SNAPSHOT
76
DROP SNAPSHOT

77
CREATE TYPE
78
DROP TYPE

79
ALTER ROLE
80
ALTER TYPE

81
CREATE TYPE BODY
82
ALTER TYPE BODY

83
DROP TYPE BODY
84
DROP LIBRARY

85
TRUNCATE TABLE
86
TRUNCATE CLUSTER

91
CREATE FUNCTION
92
ALTER FUNCTION

93
DROP FUNCTION
94
CREATE PACKAGE

95
ALTER PACKAGE
96
DROP PACKAGE

97
CREATE PACKAGE BODY
98
ALTER PACKAGE BODY

99
DROP PACKAGE BODY
100
LOGON

101
LOGOFF
102
LOGOFF BY CLEANUP

103
SESSION REC
104
SYSTEM AUDIT

105
SYSTEM NOAUDIT
106
AUDIT DEFAULT

107
NOAUDIT DEFAULT
108
SYSTEM GRANT

109
SYSTEM REVOKE
110
CREATE PUBLIC SYNONYM

111
DROP PUBLIC SYNONYM
112
CREATE PUBLIC DATABASE LINK

113
DROP PUBLIC DATABASE LINK
114
GRANT ROLE

115
REVOKE ROLE
116
EXECUTE PROCEDURE

117
USER COMMENT
118
ENABLE TRIGGER

119
DISABLE TRIGGER
120
ENABLE ALL TRIGGERS

121
DISABLE ALL TRIGGERS
122
NETWORK ERROR

123
EXECUTE TYPE
157
CREATE DIRECTORY

158
DROP DIRECTORY
159
CREATE LIBRARY

160
CREATE JAVA
161
ALTER JAVA

162
DROP JAVA
163
CREATE OPERATOR

164
CREATE INDEXTYPE
165
DROP INDEXTYPE

167
DROP OPERATOR
168
ASSOCIATE STATISTICS

169
DISASSOCIATE STATISTICS
170
CALL METHOD

171
CREATE SUMMARY
172
ALTER SUMMARY

173
DROP SUMMARY
174
CREATE DIMENSION

175
ALTER DIMENSION
176
DROP DIMENSION

177
CREATE CONTEXT
178
DROP CONTEXT

179
ALTER OUTLINE
180
CREATE OUTLINE

181
DROP OUTLINE
182
UPDATE INDEXES

183
ALTER OPERATOR

## 表空间扩容

```sql
ALTER TABLESPACE "表空间名称" ADD DATAFILE 'xxx.dbf' SIZE 20G;
-- 自动扩展
alter tablespace "表空间名称" add datafile size 1024M AUTOEXTEND ON NEXT 100M MAXSIZE 20480M;
```


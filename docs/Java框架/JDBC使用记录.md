
## url 连接参数说明

`url: jdbc:postgresql://127.0.0.1:5432/xxxx?useSSL=false&allowMultiQueries=true&defaultRowFetchSize=1000`

查看数据库支持的连接参数
1. 到对应数据库的官网查询文档
2. 直接查看`JDBC`驱动的源码，以`postgresql`举例
   1. `driverClassName: org.postgresql.Driver`
   2. 查看上面源码中的`getPropertyInfo`方法
   3. 上面方法源码中有一段`PGProperty[] knownProperties = PGProperty.values();`可以猜测出`PGProperty`枚举类即`postgresql`数据库支持的`url`参数
   4. 同理，`MySQL`的`url`连接参数在`com.mysql.cj.conf.PropertyKey`中定义
   5. 同理，`Oracle`的`url`连接参数在`oracle.jdbc.OracleConnection`中定义
3. `allowMultiQueries` ：`MySQL` 支持`mybatis`中执行多条`sql`，多条`sql`中使用`;`分隔
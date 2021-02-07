## 配置理解

`schema` 逻辑库 由MyCat管理的逻辑数据库 非物理库

`dataNode` 逻辑节点 逻辑库下可有多个逻辑节点 一个节点通常可以理解为一个分片

`dataHost` 物理库 物理库配置即实际库

`writeHost` 可写物理库

`readHost` 只读物理库

**当只有writeHost存在时既可读又可写,当writeHost与readHost同时存在时readHost负责读 writeHost负责写**

`heartbeat` 心跳语句 MyCat会不定时的执行心跳sql语句 以判断当前物理库是否可用

## 分片库合并查询结果配置

`~/conf/server.xml` useOffHeapForMerge=0

如果schema设置了sqlMaxLimit，而物理库中结果记录大于此值，那么你查询的结果会总是不超过sqlMaxLimit(疑似bug),`sqlMaxLimit=-1`关闭此限制

## 查询最大条数控制
`sqlMaxLimit=-1` 表示无限制  
`sqlMaxLimit=100` 表示每次最多查询100条  
`<schema name="hseafSchema" checkSQLschema="false" sqlMaxLimit="-1" >`  

## 端口
默认管理端口 9066  
默认端口 8066

## 测试
mysql -u用户名 -p密码 -h主机ip -P 8066

## order by 空值问题
如果sql的order by 字段可能有空值 则此sql中条件必须含有分片参数 即必须确保能够唯一指向一个确定的数据库

猜测: 由于sql条件中无分片参数时 会查询所有分片做汇总 猜测在多个实体库汇总时 无法处理空值的order by

## 分片方法

### 枚举分片
注意: defaultNode 是枚举不到时才会指向defaultNode sql条件中不包含分片参数时不会指向默认节点

通过在配置文件中配置可能的枚举 id，自己配置分片，本规则适用于特定的场景，比如有些业务需要按照省份或区县来做保存，而全国省份区县固定的，这类业务使用本条规则，配置如下：
```xml
<tableRule name="sharding-by-intfile">
  <rule>
    <columns>user_id</columns>
    <algorithm>hash-int</algorithm>
  </rule>
</tableRule>
<function name="hash-int" class="io.mycat.route.function.PartitionByFileMap">
  <property name="mapFile">partition-hash-int.txt</property>
  <property name="type">0</property>
  <property name="defaultNode">0</property>
</function>
```

配置说明
| 标签属性 | 说明 |
| --- | --- |
| columns | 标识将要分片的表字段 |
| algorithm | 分片函数 |
| mapFile | 标识配置文件名称 |
| type | 默认值为 0，0 表示 Integer，非零表示 String |
| defaultNode | 默认节点:小于 0 表示不设置默认节点，大于等于 0 设置默认节点 |


## rule.xml
必须所有tableRule在一起 function在一起不能交叉
例如
```xml
<!-- 错误示例 -->
<mycat:rule xmlns:mycat="http://io.mycat/">
	<tableRule name="rule1">
		<rule>
			<columns>id</columns>
			<algorithm>func1</algorithm>
		</rule>
	</tableRule>
    <function name="func1" class="io.mycat.route.function.PartitionByMurmurHash">
		<property name="seed">0</property><!-- 默认是0 -->
	</function>

	<tableRule name="rule2">
		<rule>
			<columns>user_id</columns>
			<algorithm>func2</algorithm>
		</rule>
	</tableRule>
	<function name="func2" class="io.mycat.route.function.PartitionByCRC32PreSlot">
		<property name="count">2</property><!-- 要分片的数据库节点数量，必须指定，否则没法分片 -->
	</function>
</mycat:rule>
<!-- 正确示例 -->
<mycat:rule xmlns:mycat="http://io.mycat/">
	<tableRule name="rule1">
		<rule>
			<columns>id</columns>
			<algorithm>func1</algorithm>
		</rule>
	</tableRule>
	<tableRule name="rule2">
		<rule>
			<columns>user_id</columns>
			<algorithm>func2</algorithm>
		</rule>
	</tableRule>

    <function name="func1" class="io.mycat.route.function.PartitionByMurmurHash">
		<property name="seed">0</property><!-- 默认是0 -->
	</function>
	<function name="func2" class="io.mycat.route.function.PartitionByCRC32PreSlot">
		<property name="count">2</property><!-- 要分片的数据库节点数量，必须指定，否则没法分片 -->
	</function>
</mycat:rule>
```

## dataNode
```xml
<!-- $为通配符 例如下一行的配置表示为 dn10,dn11,...dn1743-->
<dataNode name="dn1$0-743" dataHost="localhost1" database="db$0-743"/> <dataNode name="dn2" dataHost="localhost1" database="db2" />
```

## dataHost
```xml
<dataHost name="sequoiadb1" maxCon="1000" minCon="1" balance="0" dbType="sequoiadb" dbDriver="jdbc">
    <heartbeat></heartbeat>
    <writeHost host="hostM1" url="sequoiadb://1426587161.dbaas.sequoialab.net:11920/SAMPLE" user="jifeng" 	password="jifeng"></writeHost>
</dataHost>

<dataHost name="oracle1" maxCon="1000" minCon="1" balance="0" writeType="0" dbType="oracle" dbDriver="jdbc"> <heartbeat>select 1 from dual</heartbeat>
    <connectionInitSql>alter session set nls_date_format='yyyy-mm-dd hh24:mi:ss'</connectionInitSql>
    <writeHost host="hostM1" url="jdbc:oracle:thin:@127.0.0.1:1521:nange" user="base" 	password="123456" ></writeHost>
</dataHost>

<dataHost name="jdbchost" maxCon="1000" 	minCon="1" balance="0" writeType="0" dbType="mongodb" dbDriver="jdbc">
    <heartbeat>select 	user()</heartbeat>
    <writeHost host="hostM" url="mongodb://192.168.0.99/test" user="admin" password="123456" ></writeHost>
</dataHost>

<dataHost name="sparksql" maxCon="1000" minCon="1" balance="0" dbType="spark" dbDriver="jdbc">
    <heartbeat> </heartbeat>
    <writeHost host="hostM1" url="jdbc:hive2://feng01:10000" user="jifeng" 	password="jifeng"></writeHost>
</dataHost>

<dataHost name="jdbchost" maxCon="1000" minCon="10" balance="0" dbType="mysql" dbDriver="jdbc">
    <heartbeat>select user()</heartbeat>
    <writeHost host="hostM1" url="jdbc:mysql://localhost:3306" user="root" password="123456"></writeHost>
</dataHost>
```

## MyCat sql注意事项

### order by(mycat)
含有`order by`的sql语句 需注意

1. sql语句条件中要有分片参数
2. 不满足1时order by的的字段必须在所有分片中都不为空

### 表名大小写(mycat)
尽量全部小写

### as(mycat)
取别名时 别名不能和列名一样

聚合函数必须取别名

错误示例:`select akb020 as akb020 from kb01 a`

正确示例:`select a.akb020 as akb020 from kb01 a`

### with(mysql)
支持 `with`

不支持 `with as`

可以使用创建临时表的方式解决
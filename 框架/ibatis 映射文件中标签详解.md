# ibatis 映射文件中标签详解

## select
查询语句标签 返回一个结果集 如果返回多个结果集则用 resultMap 
如果返回单个结果集则用resultClass="AlarmCauseResult"
```xml
<select id="ALARM_CAUSE_selectAllAlarmCause" resultMap="AlarmCauseResult">
	<!--  select statement  -->   
</select>
```

## delect
删除语句标签 在ibatis中默认的删除语句是 返回数据库受影响的行数  
```xml
<delete id="ALARM_CAUSE_deleteByPrimaryKey"  parameterClass="com.metarnet.ipnms.alarm.model.AlarmCause" >
	<!--  delete  statement  -->
</delete>
```

## insert
新增语句标签 返回数据库受影响的行数
```xml
<insert id="ALARM_CAUSE_insert"  parameterClass="com.metarnet.ipnms.alarm.model.AlarmCause" >
	<!--  insertstatement  -->
</insert> 
```

## update
修改语句标签 返回数据库受影响的行数
```xml
<update id="ALARM_CAUSE_updateByPrimaryKey"  parameterClass="com.metarnet.ipnms.alarm.model.AlarmCause">
	<!-- update statement -->
</update> 
```

## 调用存储过程
```xml
<procedure id="ALARM_CAUSE_getById" parameterMap="" >
	{? = call alarm.getSingleDetailRows(?)}
</procedure>
```

## 参数-重点
两种参数

#{}：首选方式，和jdbc的？方式一致，安全传递值；

${}：替换方式，该方式将参数值直接替换，不转义，容易造成SQL注入，
不安全；但有时又需要使用 如 order by 字段
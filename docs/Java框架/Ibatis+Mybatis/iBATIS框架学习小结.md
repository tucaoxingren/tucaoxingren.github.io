---
title: iBATIS 框架 学习小结
date: 2017-12-14
time: 15:20:05
categories: IBatis
toc: true
tag: 
---
</p>

# iBATIS 框架 学习小结

## iBATIS简单查询语句

```xml
<!-- 查询一批数据的查询 -->
<!-- id: sql语句id parameterClass：参数集 resultClass：结果集-->
<!-- sql语句后不要写分号 -->
<select id="get" parameterClass="map" resultClass="kf05Domain">
		SELECT 
		       a.aaz263 as aaz263,
		  FROM kf05 a
		 WHERE 1 = 1 <!-- 若要查询的参数未输入 则返回全部数据  -->
<![CDATA[	   AND a.aaz263 = #aaz263#    ]]> <!-- <![CDATA[[ 可缺省参数 ]]> -->
</select>
```

## ibatis Dynamic(ibatis使用安全的拼接语句，动态查询)

  1.示例

```xml
<select id="selectAllProducts" parameterClass="Product" resultMap="ProductResult"> 
    select id,note from Product 
       <dynamic prepend="WHERE"> 
       <!-- isNotNull判断参数是否存在,Integer类型 --> 
            <isNotNull property="id"> 
                <!-- isGreaterThan判断参数是否大于compareValue,isGreaterEquals是大于等于 --> 
                <isGreaterThan prepend=" and " property="id" compareValue="0"> 
                id = #id# 
                </isGreaterThan> 
            </isNotNull> 
            <!-- isNotEmpty判断字串不为空,isEmpty可以判断字串为空 --> 
            <isNotEmpty prepend=" and " property="note"> 
            <!-- 模糊查询不能用#,#在是用prepareStatement的?插入参数,$是文本替换 --> 
            note like '%$note$%' 
            </isNotEmpty> 
        </dynamic> 
  </select> 
```

  2.用Map传参数 或者用class传参

```xml
<select id="selectAllProducts" parameterClass="java.util.HashMap" resultMap="ProductResult"> 
    select id,note from Product 
       <dynamic prepend="WHERE"> 
       <!-- isPropertyAvailable判断属性是否有效 --> 
          <isPropertyAvailable property="id"> 
            <isNotNull property="id"> 
                <!-- isLessThan判断参数是否小于compareValue,isLessEquals是小于等于 --> 
                <isLessThan prepend=" and " property="id" compareValue="10"> 
                id = #id# 
                </isLessThan> 
            </isNotNull> 
          </isPropertyAvailable> 
        </dynamic> 
  </select> 
```

  3.动态SQL的参数 

属性关键字--
含义

`<isEqual>` 
如果参数相等于值则查询条件有效。 

`<isNotEqual>` 
如果参数不等于值则查询条件有效。 

`<isGreaterThan>` 
如果参数大于值则查询条件有效。 

`<isGreaterEqual>` 
如果参数等于值则查询条件有效。 

`<isLessEqual> `
如果参数小于值则查询条件有效 如下所示

```xml
<isLessEqual prepend = ”AND” property = ”age” compareValue = ”18” > 
　　ADOLESCENT = ‘TRUE’ 
</isLessEqual>
```

`<isPropertyAvailable> `
如果参数有使用则查询条件有效。 

`<isNotPropertyAvailable> `
如果参数没有使用则查询条件有效。 

`<isNull> `
如果参数为NULL则查询条件有效。 

`<isNotNull> `
如果参数不为NULL则查询条件有效。 

`<isEmpty> `
如果参数为空则查询条件有效。 

`<isNotEmpty> `
如果参数不为空则查询条件有效。参数的数据类型为Collection、String 时参数不为NULL或“”。如下所示： 

```xml
<isNotEmpty prepend=”AND” property=”firstName” >
    FIRST_NAME=#firstName#
</isNotEmpty>
```

`<isParameterPresent> `
如果参数类不为NULL则查询条件有效。 

`<isNotParameterPresent> `
对象不存在有效。示例: 
```xml
<isNotParameterPresent prepend=”AND”>
    EMPLOYEE_TYPE = ‘DEFAULT’
</isNotParameterPresent>
```

>参考连接[IBATIS动态标签](http://blog.csdn.net/wanghuan203/article/details/8557659)

## Ibatis与Spring集成

1. 对Ibatis工程引入Spring支持，即将Spring相关的jar包加入到类路径中，在/src目录下创建spring配置文件，在web.xml文件中指定spring配置文件并添加spring的WebContext启动监听器。

2. 将对数据库的连接信息放交由spring管理，在spring配置文件中添加数据库连接信息
```xml
<!-- 一般配置如下 -->
<bean id=”dataSource” class=”org.apache.commons.dbcp.BasicDataSource” destroy-method=”close”> 
       <property name=”driverClassName” value=”数据库驱动类”/> 
       <property name=”url” value=”数据库连接URL”/> 
       <property name=”username” value=”数据库连接用户名”/>
       <property name=”password” value=”数据库连接密码”/> 
</bean>
<!-- 也可用.properties 文件为整个工程配置好数据库后 用下面的语句引用工程配置好的数据库 -->
<bean id="sqlExecutor" class="com.yinhai.sysframework.persistence.ibatis.LimitSqlExecutor">
        <property name="dialect">
            <bean class="com.yinhai.sysframework.persistence.ibatis.OracleDialect" />
        </property>
    </bean>
```
3. 在spring配置文件中添加对ibatis的支持
```xml
    <bean id="sqlMapClient" class="org.springframework.orm.ibatis.SqlMapClientFactoryBean">
        <property name="configLocations">
            <list>
                <value>classpath:/resource/SqlmapConfig-system.xml</value>
                <!-- 引入sql语句xml文件 -->
                <value>classpath:/resource/SqlmapConfig-cfg-include.xml</value>
            </list>
        </property>
        <property name="dataSource">
            <ref bean="dataSourceProxy" />
        </property>
    </bean>
```

> servlet 与 iBatis对应关系图

![servlet 与 iBatis对应关系图](../img/image008.gif)


> 参考文章
[深入iBATIS](https://www.ibm.com/developerworks/cn/java/j-lo-ibatis-principle/)
---
title: Service的配置
date: 2017-12-07
time: 09:02:05
categories: 
toc: true
tag: 
---
</p>

# Service的配置

## spring-demo
文件位置：javacode/demo/resource
```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:context="http://www.springframework.org/schema/context"
	xsi:schemaLocation="http://www.springframework.org/schema/beans
		http://www.springframework.org/schema/beans/spring-beans.xsd
		http://www.springframework.org/schema/context
        http://www.springframework.org/schema/context/spring-context-2.5.xsd">
	<bean id="empService" parent="transactionProxy">
		<property name="target">
			<bean class="com.yinhai.ta3.demo.service.impl.EmpServiceImpl"
				parent="baseService">				
			</bean>
		</property>
	</bean>
</beans>
```

## spring-cfg-include.xml
在spring-cfg-include.xml中引入上一个文件

该文件位置：javacode/config/resource
```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:context="http://www.springframework.org/schema/context"
	xmlns:tx="http://www.springframework.org/schema/tx"
	xsi:schemaLocation="http://www.springframework.org/schema/beans
		http://www.springframework.org/schema/beans/spring-beans.xsd
		http://www.springframework.org/schema/context
        http://www.springframework.org/schema/context/spring-context-2.5.xsd
        http://www.springframework.org/schema/tx
        http://www.springframework.org/schema/tx/spring-tx-2.5.xsd">
	<!-- 该文件专门用于引用系统的service配置文件的 -->
	<import resource="spring-demo.xml"/>
</beans>
```
## 在app-context.xml中引入spring-cfg-include.xml文件
`<import resource="resource/spring-cfg-include.xml"/> `

## action 与 jsp交互 中文乱码
修改tomcat  server.xml文件部分如下 修改传输编码为 项目编码方式
```xml
<Connector port="8080" protocol="HTTP/1.1"
               connectionTimeout="20000"
               redirectPort="8443" 
			   useBodyEncodingForURI="true" URIEncoding="utf-8"/>
```
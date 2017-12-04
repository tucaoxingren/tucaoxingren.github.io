---
title: Action 配置
date: 2017-12-01
time: 09:21:05
categories: action
toc: true
tag: 
---
</p>


# Action 配置

## 注解配置方式

```java
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.Result;
@Namespace("/demo")
@Action(value="demo2Action",results={
		@Result(name="success",location="/demo/demo2.jsp")
})
public class Demo2Action extends BaseAction{
	public String execute() throws Exception{
		return SUCCESS;
	}
}
```

## xml配置方式

javacode/config/resource/struts-cfg-include.xml 如下
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE struts-config PUBLIC "-//Apache Software Foundation//DTD Struts Configuration 1.1//EN" "http://jakarta.apache.org/struts/dtds/struts-config_1_1.dtd">

<struts>
	<include file="resource/struts-demo.xml"/>
</struts>
```

javacode/demo/resource/struts-demo.xml 如下
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE struts-config PUBLIC "-//Apache Software Foundation//DTD Struts Configuration 1.1//EN" "http://jakarta.apache.org/struts/dtds/struts-config_1_1.dtd">

<struts>
	<package name="ta-demo" extends="ta-default" namespace="/demo">
		<action name="demo2Action" class="com.yinhai.ta3.demo.action.Demo2Action">
			<result name="sucesss">/demo/demo2.jsp</result>
		</action>
	</package>
</struts>
```

javacode/config/struts.xml  添加如下语句
`<include file="resource/struts-cfg-include.xml"/>`

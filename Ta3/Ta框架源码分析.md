
## `spring-mvc.xml`配置文件分析
```xml
<!-- 前端页面参数转DTO转换器 -->
<mvc:interceptor>
	<mvc:mapping path="/**" />
	<bean class="com.yinhai.core.app.ta3.web.interceptor.ParamInterceptor">
	</bean>
</mvc:interceptor>
<mvc:interceptor>
	<mvc:mapping path="/**" />
	<bean class="com.yinhai.core.app.ta3.web.interceptor.MaxParamInterceptor">
	</bean>
</mvc:interceptor>
```
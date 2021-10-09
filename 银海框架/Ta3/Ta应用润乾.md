## 润乾问题记录
### 填报报表
#### 自动计算 导出excel 自动计算单元格无数据
自动计算单元格的自动计算是前台js完成的 导出excel时取得服务器缓存 所以要给自动计算单元格加上计算表达式
#### 对设置为下拉列表框的填报单元格设置默认值
将此单元格赋值为默认选择的下拉列表的代码值
#### 填报报表 输入数据 提交数据
必须要配置更新策略 即 输入的数据必须存储到数据库
### 报表文件采用存在数据库的方式 更新后 报表未实时更新
因为报表模板只有第一次使用时会从数据库查询 否则从缓存中读取 重新上传报表后 清除报表缓存即可 开发管理->缓存管理

润乾缓存名`reportCache` `menuReportCache` `childReportCache`

## 表达式
### now()函数
v4版(银海使用版本)取当前日期 date(now())
		官网介绍的 now@d() 是 润乾2018版

## 配置文件
###　pom依赖
```xml
<!-- 润乾报表模块 可选-->
<dependency>
    <groupId>com.yinhai</groupId>
    <artifactId>ta3-modules-runqian-ta3-app</artifactId>
    <version>${project-ta3.version}</version>
</dependency>
<!-- 银海润乾模块 对org.apache.poi重写模块 可选 使用ta3框架对润乾报表导出文件时 必须添加此依赖 例如使用Base.exportAsExcel-->
<dependency>
    <groupId>com.yinhai.runqian</groupId>
    <artifactId>poi2</artifactId>
    <version>2.0</version>
</dependency>
```

### reportConfig.xml
```xml
<!-- 授权文件路径 当前服务器系统-->
<config>
    <name>license</name>
    <!-- 此处为相对于reportServlet的相对路径 由于weblogic会将class目录下的所有文件包装为一个jar包 所以一定要写相对路径! -->
    <value>runqian/runqianLinuxServer.lic</value>
</config>
```

### app-context.xml
```xml
<!-- 润乾报表模块 -->
<import resource="spring/spring-runqian.xml"/>
```

### web.xml
```xml
<!-- 润乾filter -->
<filter>
        <filter-name>runqianPrintFilter</filter-name>
        <filter-class>com.yinhai.ta3.runqian.filter.RunqianPrintFilter</filter-class>
        <init-param>
        <param-name>includeServlets</param-name>
        <param-value>pagedPrintServer,reportServlet</param-value>
        </init-param>
</filter>
<filter-mapping>
    <filter-name>runqianPrintFilter</filter-name>
    <url-pattern>/reportServlet</url-pattern>
    <dispatcher>REQUEST</dispatcher>
</filter-mapping>
<filter-mapping>
    <filter-name>runqianPrintFilter</filter-name>
    <url-pattern>/pagedPrintServer</url-pattern>
    <dispatcher>REQUEST</dispatcher>
</filter-mapping>
<!-- 润乾Servlet -->
<servlet>
    <servlet-name>SetContextServlet</servlet-name>
    <servlet-class>com.runqian.util.webutil.SetContextServlet</servlet-class>
    <load-on-startup>2</load-on-startup>
</servlet>
<servlet>
    <servlet-name>reportServlet</servlet-name>
    <servlet-class>com.runqian.report4.view.ReportServlet</servlet-class>
        <init-param>
            <param-name>configFile</param-name>
            <param-value>/WEB-INF/classes/runqian/reportConfig-dev.xml</param-value>
        </init-param>
    <load-on-startup>1</load-on-startup>
</servlet>
<servlet-mapping>
    <servlet-name>reportServlet</servlet-name>
    <url-pattern>/reportServlet</url-pattern>
</servlet-mapping>
```
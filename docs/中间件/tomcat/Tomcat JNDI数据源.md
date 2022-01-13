## 全局数据源 单个应用使用
server.xml 添加如下节点
```xml
 <GlobalNamingResources>
    <!-- 添加全局数据源 -->
    <Resource name="ynstspjhkdevta"  
               scope="Shareable"  
               type="javax.sql.DataSource" 
               factory="org.apache.tomcat.dbcp.dbcp2.BasicDataSourceFactory" 
               url="jdbc:oracle:thin:@192.168.5.250:1521/kmdev" 
               driverClassName ="oracle.jdbc.driver.OracleDriver" 
               username="ynstspjhkta" 
               password="ynstspjhkta" />
  </GlobalNamingResources>

<Host name="localhost"  appBase="webapps"
        unpackWARs="true" autoDeploy="true">
            
    <Context docBase="ynsp" path="/ynsp" reloadable="true" source="org.eclipse.jst.jee.server:ynsp">
        <!-- global全局数据源 name应用中的JNDI名 -->
        <ResourceLink global="ynstspjhkdevta" name="ynhseaftest" type="javax.sql.DataSource" />
    </Context>

</Host>
```

java spring中配置JNDI数据源
数据源名前加`java:comp/env/`
```xml
<bean id="ta3DataSource" class="org.springframework.jndi.JndiObjectFactoryBean">
    <property name="jndiName">
        <value>java:comp/env/ynhseaftestta</value>
    </property>
</bean>
```
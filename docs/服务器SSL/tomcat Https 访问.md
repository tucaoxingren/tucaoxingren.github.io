# tomcat Https 访问
## JKS格式证书生成
> keytool -genkey -v -alias testKey -keyalg RSA -validity 3650 -keystore d:\tomcat.keystore
上一行命令后提示输入证书信息
> 密钥库口令:123456（这个密码非常重要）
> 名字与姓氏:192.168.0.110（以后访问的域名或IP地址，非常重要，证书和域名或IP绑定）
> 组织单位名称:anything（随便填）
> 组织名称:anything（随便填）
> 城市:anything（随便填）
> 省市自治区:anything（随便填）
> 国家地区代码:anything（随便填）
## tomcat根目录/conf/server.xml 开启服务器对SSL的支持
```xml
	<!-- https访问端口号 -->
	<Connector port="8443" protocol="org.apache.coyote.http11.Http11Protocol" SSLEnabled="true"
    enableLookups="false"
    acceptCount="100" disableUploadTimeout="true"
    maxThreads="150" scheme="https" secure="true"
    clientAuth="false" sslProtocol="TLS"
	<!-- keystore文件位置 -->
    keystoreFile="d:\tomcat.keystore"
	<!-- key密码 -->
    keystorePass="002777" /> 
```
## tomcat根目录/conf/web.xml 
```xml
<login-config>  
    <!-- Authorization setting for SSL -->  
    <auth-method>CLIENT-CERT</auth-method>  
    <realm-name>Client Cert Users-only Area</realm-name>  
</login-config>  
<security-constraint>  
    <!-- Authorization setting for SSL -->  
    <web-resource-collection >  
        <web-resource-name >SSL</web-resource-name>  
		<!-- 强制Https访问的路径 /* 即该应用全部强制Https访问 -->
        <url-pattern>/*</url-pattern>  
    </web-resource-collection>  
    <user-data-constraint>  
        <transport-guarantee>CONFIDENTIAL</transport-guarantee>  
    </user-data-constraint>  
</security-constraint>
```


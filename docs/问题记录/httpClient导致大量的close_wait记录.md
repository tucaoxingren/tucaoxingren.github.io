# 问题发现
前端大量报错 `Too many open files`
翻看程序日志发现下面的堆栈信息
```
java.net.SocketException: Too many open files
	at java.net.Socket.createImpl(Socket.java:477)
	at java.net.Socket.<init>(Socket.java:448)
	at java.net.Socket.<init>(Socket.java:303)
	at org.apache.commons.httpclient.protocol.DefaultProtocolSocketFactory.createSocket(DefaultProtocolSocketFactory.java:79)
	at org.apache.commons.httpclient.protocol.DefaultProtocolSocketFactory.createSocket(DefaultProtocolSocketFactory.java:121)
	at org.apache.commons.httpclient.HttpConnection.open(HttpConnection.java:706)
	at org.apache.commons.httpclient.HttpMethodDirector.executeWithRetry(HttpMethodDirector.java:386)
	at org.apache.commons.httpclient.HttpMethodDirector.executeMethod(HttpMethodDirector.java:170)
	at org.apache.commons.httpclient.HttpClient.executeMethod(HttpClient.java:396)
	at org.apache.commons.httpclient.HttpClient.executeMethod(HttpClient.java:324)
	at com.yinhai.sicp3.his.common.apps.service.impl.HisSicp3BaseServiceImpl.callBizServiceIntf(Unknown Source)
	at com.yinhai.sicp3.his.common.apps.service.impl.HisSicp3BaseServiceImpl.callBizService(Unknown Source)
	at com.yinhai.sicp3.his.common.apps.service.impl.HisSicp3BaseServiceImpl.getBke057(Unknown Source)
	at com.yinhai.mobile.service.MobileService.mobilebalance(Unknown Source)
	at sun.reflect.GeneratedMethodAccessor149.invoke(Unknown Source)
	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
	at java.lang.reflect.Method.invoke(Method.java:498)
	at com.yinhai.mobile.bus.ControlBus.invokeFactoryProxyClass(Unknown Source)
	at com.yinhai.mobile.bus.MobileServlet.formField(Unknown Source)
	at com.yinhai.mobile.bus.MobileServlet.doPost(Unknown Source)
	at javax.servlet.http.HttpServlet.service(HttpServlet.java:515)
	at javax.servlet.http.HttpServlet.service(HttpServlet.java:583)
	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:212)
	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:156)
	at org.apache.tomcat.websocket.server.WsFilter.doFilter(WsFilter.java:51)
	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:181)
	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:156)
	at org.apache.catalina.core.StandardWrapperValve.invoke(StandardWrapperValve.java:167)
	at org.apache.catalina.core.StandardContextValve.invoke(StandardContextValve.java:90)
	at org.apache.catalina.authenticator.AuthenticatorBase.invoke(AuthenticatorBase.java:483)
	at org.apache.catalina.core.StandardHostValve.invoke(StandardHostValve.java:130)
	at org.apache.catalina.valves.ErrorReportValve.invoke(ErrorReportValve.java:93)
	at org.apache.catalina.valves.AbstractAccessLogValve.invoke(AbstractAccessLogValve.java:682)
	at org.apache.catalina.core.StandardEngineValve.invoke(StandardEngineValve.java:74)
	at org.apache.catalina.connector.CoyoteAdapter.service(CoyoteAdapter.java:343)
	at org.apache.coyote.http11.Http11Processor.service(Http11Processor.java:617)
	at org.apache.coyote.AbstractProcessorLight.process(AbstractProcessorLight.java:63)
	at org.apache.coyote.AbstractProtocol$ConnectionHandler.process(AbstractProtocol.java:932)
	at org.apache.tomcat.util.net.NioEndpoint$SocketProcessor.doRun(NioEndpoint.java:1694)
	at org.apache.tomcat.util.net.SocketProcessorBase.run(SocketProcessorBase.java:52)
	at org.apache.tomcat.util.threads.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1191)
	at org.apache.tomcat.util.threads.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:659)
	at org.apache.tomcat.util.threads.TaskThread$WrappingRunnable.run(TaskThread.java:61)
	at java.lang.Thread.run(Thread.java:750)
```

# 运行环境
jdk8
tomcat8
# 问题解决

1. 搜索 `java.net.SocketException: Too many open files`找到下面这篇文章

[问题 java.net.SocketException Too many open files_java.net.socketexception: too many open files_默默前行的蜗牛的博客-CSDN博客](https://blog.csdn.net/ywf008/article/details/128035692)

2. 命令 `netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'` 观察到有大量的`close_wait`进程
3. 尝试修改 `/etc/security/limits.conf` 文件打开数量限制 再次观察`close_wait`进程，未改善
4. 经同事指点有可能是 apache httpClient导致的 搜索到了这篇文章[解决:HttpClient导致应用出现过多Close_Wait的问题 - jessezeng - 博客园](https://www.cnblogs.com/jessezeng/p/5616518.html) 按照最后一种方案解决(或httpClient.getHttpConnectionManager().closeIdleConnections(-1);)后，观察`close_wait`进程明显减少了

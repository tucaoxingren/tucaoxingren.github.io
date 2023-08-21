# Cache实现

## 配置文件：

spring-cache.xml 文件

增加一个bean，修改name和 region

​      ![image-20200108202618339](../img/image-20200108202618339.png)                         

 

ehcache.xml文件

 ![image-20200108202625025](../img/image-20200108202625025.png)

 

## 代码实现（controller层）：

1、引入ICacheManger

 ![image-20200108202629563](../img/image-20200108202629563.png)

 

2、获取cache 根据ehcache.xml 中配置的缓存名

 ![image-20200108202635481](../img/image-20200108202635481.png)

3、根据key获取缓存值，判断是否为空，如果不为空，直接返回数据，如果为空，去数据库里面查，将结果放到缓存里面

![image-20200108202639200](../img/image-20200108202639200.png)

![image-20200108202644518](../img/image-20200108202644518.png)


4、页面初始化之后需清除缓存(可选)

 ![image-20200108202649650](../img/image-20200108202649650.png)


备注：

API

 ![image-20200108202701796](../img/image-20200108202701796.png)
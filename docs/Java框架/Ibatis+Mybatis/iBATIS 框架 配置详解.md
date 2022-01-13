---
title: iBATIS 框架 配置详解
date: 2017-12-15
time: 09:20:05
categories: IBatis
toc: true
tag: 
---
</p>

# iBATIS 框架 配置详解

## sqlmap-config.xml

一个简单的配置文件如下
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE sqlMapConfig PUBLIC
    "-//ibatis.apache.org//DTD SQL Map Config 2.0//EN"
    "http://ibatis.apache.org/dtd/sql-map-config-2.dtd">
    
<sqlMapConfig>
<!-- cacheModelsEnabled 是否启用SqlMapClient上的缓存机制 建议为true -->
<!-- enhancementEnabled 是否针对POJO启用字节编码增强机制以提升getter/setter 的调用效能  -->
<!-- 避免使用JavaReflect所带来的性能开销 -->
<!-- errorTracingEnabled 是否启用错误日志 在开发期间方便调试 建议设置为 true -->
<settings
    useStatementNamespaces="true"
    cacheModelsEnabled="true"
    enhancementEnabled="true"
    errorTracingEnabled="true"
/>
<sqlMap resource="resource/sqlmap/sqlmap-demo.xml"/>
</sqlMapConfig>

```

`<settings>`元素的配置，这个元素即设置iBatis的全局配置信息。具体属性信息如下

`lazyLoadingEnabled`从名字即可看出是否进行延迟加载。通俗来说，延迟加载就是只加载必要信息而推迟加载其他未明确请求的数据，这里要和Hibernate中延迟加载区分开。那也就是说，除非绝对必须，否则程序加载的数据越少越好。iBatis默认使用了延迟加载，即不配置时也是默认为true的。 

`cacheModelsEnabled`这是数据缓存的配置，缓存可以提高程序的性能，这是显而易见的。和延迟加载一样，缓存也是默认启用的。 

`enhancementEnabled`该配置是来说明是否使用`cglib`中那些优化的类来提高延迟加载的性能，默认值为`true`，也就是启用。但是之前的示例中，并没有在`lib`中加入`cglib`的类库，那么`iBatis`没有在类路径上发现`cglib`时，该功能也就不能起作用了。这里多说一点，对于增强框架，除非必须，尽量避免使用。 

`useStatementNamespaces`该配置说明是否使用语句的命名空间，默认是不使用的，但是在大型应用时，使用命名空间来作为限定就比较清楚了。使用方法是在`<sql-map>`标记上加`namespace`属性即可，在程序中就使用“命名空间`.SQL`映射语句”这种语法来执行。

`<typeAlias>`元素:起别名

不想使用过长的类名时，可以用它来起个别名，之后使用别名就可以了。比如：
`<typeAlias alias="User" type="ibatis.model.User" />`
type属性是原始的类名，而alias属性配置我们希望使用的名字即可

iBatis已经为我们设置了一些类型的别名，我们就可以直接使用了，比如事务管理器的`JDBC,JTA和EXTERNAL`；数据类型的`string,byte,long,short,int`等；数据源工厂的`SIMPLE,DBCP,JNDI`；高速缓存控制器的`FIFO,LRU,MEMORY,OSCACHE`和XML结果类型的`DOM,domCollection,Xml,XmlCollection`，它们是可以直接使用的

```xml
<sqlMap namespace="User">  
    <typeAlias alias="User" type="ibatis.model.User" />  
    <select id="getUserByName" parameterClass="java.lang.String" resultClass="User">  
        select * from users where USERNAME=#VARCHAR#  
    </select>
</sqlMap>  
```

配置关系图如下
![](https://github.com/tucaoxingren/ProgramingNote/raw/master/img/1476328818405984.jpg)

## 常用的三种查询方法

1.`queryForObject()`方法

它返回数据库查询的一条结果，并放入到Java对象中，这里的一条记录可以是一个`JavaBean`，也可以是Java的集合类型。它可以根据`<select>`标签中配置的`resultClass`属性来确定的，如果不指定`resultClass`属性，那么查询结果就是`null`了，因为iBatis不知道怎么处理这个结果，而且我们也没有配置结果映射`（resultMap）`

首先根据上面的User类型，将resultClass设置为User，代码如下
```xml
<sqlMap namespace="User">  
    <typeAlias alias="User" type="ibatis.model.User" />  
    <select id="getUserByName" parameterClass="java.lang.String"  
        resultClass="User">  
        select * from users where USERNAME=#VARCHAR#  
    </select>  
</sqlMap>  
```

这时要求User类中必须要有一个默认的构造方法，否则将不能实例化这个对象，抛出异常，这一点不能忘记（如果重载了构造方法的话）  demo.java：
```java
System.out.println(sqlMap.queryForObject("User.getUserByName", "sarin").getClass().getName());
```
此时，输出内容为：`ibatis.model.User`，这就很清楚的看到了，查询的结果类型是由`<select>`中的`resultClass`来确定的

`queryForObject()`的另外一个重载方法是`Object queryForObject(String id, Object parameter, Object resultObject) throws Exception`，这种方法是为对象不能轻易创建的情况使用的（如没有默认的构造方法的对象），那么使用前面那种格式就会抛出异常，就需要使用这种方法，看下面代码：（这里去掉User类中的默认构造方法） 
```java
User user=new User(null, null, null, null, null);  
user = (User) sqlMap.queryForObject("User.getUserByName", "sarin",user);  
System.out.println(user);
```
这样才能获得user对象

2.`queryForMap()`方法

返回结果可以是一条，也可以是多条。它的方法签名有两种形式：

第一种是`Map queryForMap(String id, Object parameter, String key) throws SQLException`

第二种是再多一个参数`String value`。前面两个参数 就是select标签的id和传入的参数，而后面的key和value:key指定了Map中存储的键，而value确定了存储的值，不设置value时则存储查询的一个对象，如下面代码（此时已经将select的resultClass设置为hashmap了）： 
```java
Map map = sqlMap.queryForMap("User.getAllUsers", null,"userId");  
System.out.println(map);
/* 输出为：
{1={email=gmail@gmail.com, userId=1, userName=sarin, password=123, mobile=15940912345}, 2={email=gmail@gmail.com, userId=2, userName=sarin, password=123, mobile=15940912345}} 
*/
//queryForMap()的第二个重载方法则是指定了value的内容： 
Map map = sqlMap.queryForMap("User.getAllUsers", null, "userId","mobile");  
System.out.println(map);//打印：{1=15940912345, 2=15940912345}
```

3.`queryForList()`方法

同样，该方法的方法签名也有两类形式：

第一类是`queryForList(String id, Object parameter) throws SQLException`，或者不需要参数，这很好理解了。示例：
```java
//SqlMap中的resultClass设置为hashmap） 
List users = sqlMap.queryForList("User.getAllUsers");  
System.out.println(users);
/*打印的结果是：
[{email=gmail@gmail.com, userId=1, userName=sarin, password=123, mobile=15940912345}, {email=gmail@gmail.com, userId=2, userName=sarin, password=123, mobile=15940912345}]*/
```

`queryForList()`的第二类方法是`queryForList(String id, Object parameter, int skip, int max) throws SQLException`,后面多了两个int类型的参数,SQL中使用两个int类型的参数实现分页。iBatis在queryForList()中提供了为分页提供支持的方法。`skip`是从0开始计算的，而max就是取出的条数，那么取前10条就是(0,10)，取11~20条就是(10,10)，以此类推。 
    

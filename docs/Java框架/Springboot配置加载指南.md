## 本地开发覆盖Nacos配置

基于下面的论述，Nacos配置优先级最高

本地开发若想覆盖Nacos中的同名配置

1. 不起用Nacos，将全部配置放到本地启动项目

2. 将下面的配置放到nacos上 [nacos配置文件优先级过程_java_脚本之家](https://www.jb51.net/program/324266vge.htm)

```yml
spring:
  cloud:
    config:
      # 如果本地配置优先级高，那么 override-none 设置为 true，包括系统环境变量、本地配置文件等配置
      override-none: true
      # 如果想要远程配置优先级高，那么 allow-override 设置为 false，如果想要本地配置优先级高那么 allow-override 设置为 true
      allow-override: true
      # 只有系统环境变量或者系统属性才能覆盖远程配置文件的配置，本地配置文件中配置优先级低于远程配置；注意本地配置文件不是系统属性
      override-system-properties: false

```





## SpringBoot配置及Nacos配置中心加载顺序及覆盖生效优先关系

### 一、测试环境版本
spring-boot-starter-parent  2.7.10

spring-cloud-starter-bootstrap  3.1.6

spring-cloud-starter-alibaba-nacos-config  2021.0.4.0

nacos-client 2.1.1

nacos服务端 2.2.1

### 二、测试结果
#### 1、标准的SpringBoot应用
在标准的`SpringBoot`应用中，本地配置加载顺序如下：

`bootstrap`配置 加载先于 `application`配置

不带`profile`的配置 加载先于 带`profile`的配置

(不含后缀的)同文件名配置 `*.yaml`  加载先于 `*.properties`

综上，本地加载顺序为：

`bootstrap.yaml`

`bootstrap.properties`

`bootstrap-{profile}.yaml`

`bootstrap-{profile}.properties`

`application.yaml`

`application.properties`

`application-{profile}.yaml`

`application-{profile}.properties`

`环境变量`

`jvm参数`

因此，配置生效覆盖关系：

    对于key名相同，后加载会覆盖掉前加载，故而最终为后加载的配置项生效！
    
    对于key名不同，则直接生效（会加载，但不会被覆盖）；
    
    注意：不能理解为文件级整体覆盖，而仅是同名key会被后加载的键值覆盖。

#### 2、含有Nacos配置中心的SpringBoot应用
带`Nacos`配置中心的`SpringBoot`应用中，配置加载顺序如下：

本地`bootstrap`配置 加载先于 本地`application`配置

本地配置 加载先于 `nacos`配置中心

`nacos`配置中心上共享配置(见下说明) 加载先于 `nacos`配置中心该服务配置（见下说明）

不带`profile`的配置 加载先于 带`profile`的配置

本地(不含后缀的)同文件名配置 `*.yaml`  加载先于 `*.properties`

`nacos`配置中心因需要通过`data ID`指定（或者通过`spring.cloud.nacos.config.file-extension`指定后缀），所以对于Nacos配置中心上的某个Data ID而言，不会存在既加载其`*.yaml`又加载其`*.properties`的情形。

综上，本地及`Nacos`配置中心共同加载顺序为：

`bootstrap.yaml`

`bootstrap.properties`

`bootstrap-{profile}.yaml`

`bootstrap-{profile}.properties`

`application.yaml`

`application.properties`

`application-{profile}.yaml`

`application-{profile}.properties`

`nacos配置中心共享配置（通过spring.cloud.nacos.config.shared-configs指定）`

`Nacos配置中心该服务配置（通过spring.cloud.nacos.config.prefix和spring.cloud.nacos.config.file-extension指定）`

`Nacos配置中心该服务-{profile}配置（通过spring.cloud.nacos.config.prefix和spring.cloud.nacos.config.file-extension、以及spring.profiles.active指定）`

`环境变量`

`jvm参数`

因此，配置生效覆盖关系：

    对于key名相同，后加载会覆盖掉前加载，故而最终为后加载的配置项生效！
    
    对于key名不同，则直接生效（会加载，但不会被覆盖）；
    
    注意：不能理解为文件级整体覆盖，而仅是同名key会被后加载的键值覆盖。
————————————————
版权声明：本文为CSDN博主「zyplanke」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/zyplanke/article/details/131101840
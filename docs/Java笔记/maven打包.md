
## 指定 maven路径打包

`-Dmaven.repo.local` 指定本地仓库地址
`-Dmaven.home` 指定本地maven根目录
`-Dclassworlds.conf` 指定maven settings.xml文件
`-P !xxxx` 设置不激活指定 profiles
`-P xxxx` 设置激活指定 profiles
`-DskipTests` 设置跳过编译测试代码
`-U`  该参数能强制让Maven检查所有SNAPSHOT依赖更新，确保集成基于最新的状态，如果没有该参数，Maven默认以天为单位检查更新，而持续集成的频率应该比这高很多

```
mvn clean package -U -Dmaven.repo.local=D:\Users\repository -DskipTests -P single-portal,spring-cloud -o -Dmaven.home=D:\PortableProgram\apache-maven-3.6.1 -Dclassworlds.conf=D:\PortableProgram\apache-maven-3.6.1\conf\settings.xml
```
## 问题记录

### 生产环境与本地对同一个脚本的checksum不一致问题排查

1. 检查代码版本控制 文件是否一致

2. 检查脚本中是否有动态字符 例如`${xxx}` 这种字符会被maven打包时替换 导致生产环境的脚本与本地不一致

   检查maven配置

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <project xmlns="http://maven.apache.org/POM/4.0.0"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
   
       <build>
           <plugins>
               <plugin>
                   <groupId>org.apache.maven.plugins</groupId>
                   <artifactId>maven-compiler-plugin</artifactId>
                   <version>3.8.1</version>
                   <configuration>
                       <source>${java.version}</source>
                       <target>${java.version}</target>
                       <encoding>${project.build.sourceEncoding}</encoding>
                       <parameters>true</parameters>
                   </configuration>
               </plugin>
               <plugin>
   			    <groupId>org.codehaus.mojo</groupId>
   			    <artifactId>build-helper-maven-plugin</artifactId>
   			    <version>3.2.0</version>
   			    <executions>
   			    	<execution>
   			     		<id>timestamp-property</id>
   			     		<goals>
   			       			<goal>timestamp-property</goal>
   			    		</goals>
   			    	</execution>
   			    </executions>
   			    <configuration>
   			    	<name>build.version</name>
   			    	<pattern>yyyy-MM-dd HH:mm:ss</pattern>
   			    	<timeZone>GMT+8</timeZone>
   			    </configuration>
   			</plugin>
           </plugins>
           <resources>
               <!-- 主资源目录：启用过滤，但确保不排除db目录 -->
               <resource>
                   <directory>src/main/resources</directory>
                   <filtering>true</filtering>
                   <!-- 只排除不需要过滤的子目录（如db/migration），而不是整个db目录 -->
                   <excludes>
                       <exclude>db/migration/**</exclude> <!-- 仅排除migration子目录的过滤 -->
                   </excludes>
               </resource>
   
               <!-- 单独处理db/migration目录：禁用过滤，确保Flyway脚本不被修改 -->
               <resource>
                   <directory>src/main/resources/db/migration</directory>
                   <targetPath>db/migration</targetPath>
                   <includes>
                       <include>**/*</include> <!-- 包含db/migration目录下所有SQL脚本 -->
                   </includes>
                   <filtering>false</filtering>
               </resource>
               
               <resource>
                   <directory>src/main/java</directory>
                   <includes>
                       <include>**/*.xml</include>
                   </includes>
               </resource>
           </resources>
       </build>
   
   
   </project>
   
   ```

   
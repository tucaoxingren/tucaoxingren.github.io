## 设置 java complier
-encoding utf-8

##  设置单个文件运行编码
 -Dfile.encoding=GBK

## tomcat乱码

tomcat / conf 目录下，设置 logging.properties 增加



java.util.logging.ConsoleHandler.encoding = GBK




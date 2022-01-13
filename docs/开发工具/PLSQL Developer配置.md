## PL/SQL Developer 配置

### 注册信息
A64W-XE5X-K64M-QB2T-SKPK-33WF-8QP2
381.80890
xs374ca

### Initialization error
未配置ODBC

1. 解压 instantclient_11_2.rar
2. 工具->首选项 Oracle主目录：`C:\developSoftware\instantclient_11_2` OCI库：`C:\developSoftware\instantclient_11_2\oci.dll`

### 快捷输入
工具->首选项->编辑器->自动替换
`sf=select * from `

### 字体大小
工具->首选项->用户界面->字体

### 中文乱码
在windows中创建一个名为`NLS_LANG`的系统环境变量，设置其值为`SIMPLIFIED CHINESE_CHINA.ZHS16GBK`

### 数字太长 显示科学计数法
工具->首选项->窗口类型->SQL窗口
勾选 `数字字段 to char`
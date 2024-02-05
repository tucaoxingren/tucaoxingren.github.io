**本站点使用Docsify搭建**



`Docsify`使用手册：[快速开始 (docsify.js.org)](https://docsify.js.org/#/zh-cn/quickstart)





## 目录结构

```txt
-- docs #文档
-- docsify #Docsify配置
	-- _sidebar.md #Docsify文档目录 注意md文件路径使用相对地址
	-- index.html #Docsify首页html
	-- README.md #Docsify首页readme
```



## 预览(适用于docsify官方推荐配置)

`docsify start docsify`

使用 `http://localhost:4000/docsify/index.html`访问

## 预览(针对上述目录结构)

使用`Nginx`预览

nginx.conf 配置如下

```conf
server {
	listen       7001;
	server_name  _;
	location / {
		# 项目根目录
		root   D:\ProgramingNote;
		index  docsify/index.html;
	}
}
```

预览地址

`http://localhost:7001/docsify/index.html#/`


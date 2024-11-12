## Node

### NodeJS与Npm的版本关系

[Node.js — Node.js 版本 (nodejs.org)](https://nodejs.org/zh-cn/about/previous-releases)

## NPM

### npm install 报错 Error: certificate has expired

可能是镜像源的https证书失效或过期，以下步骤二选一即可

1. 取消SSL验证 `npm config set strict-ssl false`
2. 更换镜像源



淘宝最新镜像源地址

```
npm config set registry https://registry.npmmirror.com
```



### cli npm vX.X.X does not support Node.js vX.X.X.

可能是之前全局安装过高版本的npm



#### windows

`where npm` 查看npm全局安装的位置，删除高版本即可

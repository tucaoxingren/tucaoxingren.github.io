## 远程调试

1. 打开浏览器 输入下面的地址
   > 1. chrome浏览器 `chrome://inspect/#devices`
   > 2. edge浏览器 `edge://inspect/#devices`
2. 运行到需要调试的页面
3. 点击`inspect`

## 利用node构建项目

1. 创建一个node项目
2. 兼容`md.`或其它`mdlife`插件
	- 2.1 修改`.eslinttrc.js` 如下

	```js
	module.exports = {
		rules: {
			'no-undef': 'off'
		}
	};
	```

	- 2.2 如果是`vue`项目 可以添加全局变量`Vue.prototype.md = {};`

3. 设定打包脚本 将编译后的静态文件输出到`widget`目录 用于 `mdlife`打包

4. 开发调试

   > 由于node项目需要编译为静态文件 并放置到widget目录下才能同步到真机进行调试 此过程太繁琐耗时 因此建议使用远程调试
   >
   > 远程调试时 可以创建一个空的mdlife项目 并在首页打开node项目的网址 md.openWin({name: 'home', url: 'http://xxx'})
   >
   
5. node项目开发需要注意

   > 1. 页面间的跳转、传参不要使用 mdlife开发文档->窗口系统中的接口  `removeLaunchView` 、`removeOnClickDelay` 除外 。`execScript`建议使用消息事件代替
   > 2. mdlife生命周期由node代替



## 问题记录

### 在页面底部的input输入框被输入法遮挡

修改`config.json`

`appSetting.statusBarAppearance=true`


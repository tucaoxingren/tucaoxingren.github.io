---
title: CSS初识
date: 2017-12-29
time: 10:33:05
categories: css
toc: true
tag: 
---
</p>

# CSS初识

## 样式分类

外部样式
```html
<head><!-- 指定样式表文件的路径 -->
<link rel="stylesheet" type="text/css" href="mystyle.css">
</head>
```

内部样式

标签名{样式属性：属性值}
```html
<head>
<style>
hr {color:sienna;}
p {margin-left:20px;}
body {background-image:url("images/back40.gif");}
</style>
</head>
```

内联样式

由于要将表现和内容混杂在一起，内联样式会损失掉样式表的许多优势。请慎用这种方法，例如当样式仅需要在一个元素上应用一次时。

要使用内联样式，需要在相关的标签内使用样式（style）属性。Style 属性可以包含任何 CSS 属性。本例展示如何改变段落的颜色和左外边距：
`<p style="color:sienna;margin-left:20px">这是一个段落。</p>`

### 样式表优先级

内联样式>内部样式>外部样式>浏览器默认样式
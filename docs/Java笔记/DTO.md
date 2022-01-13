---
title: DTO
date: 2017-12-05
time: 16:28:05
categories: 
toc: true
tag: 
---
</p>


# DTO
Data Transfer Object（数据传输对象）DTO 是一组需要跨进程或网络边界传输的聚合数据的简单容器

它不应该包含业务逻辑，并将其行为限制为诸如内部一致性检查和基本验证之类的活动

注意，不要因实现这些方法而导致 DTO 依赖于任何新类

在设计数据传输对象时，您有两种主要选择：
1. 使用一般集合
2. 使用显式的 getter 和 setter 方法创建自定义对象

[参考文章](http://blog.csdn.net/dchjmichael/article/details/7905766)
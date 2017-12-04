---
title: iBATIS 框架 学习小结
date: 2017-11-28
time: 11:41:05
categories: 
toc: true
tag: 
---
</p>

# iBATIS 框架 学习小结

## iBATIS简单查询语句

```xml
<!-- 查询一批数据的查询 -->
<!-- id: sql语句id parameterClass：参数集 resultClass：结果集-->
<!-- sql语句后不要写分号 -->
<select id="get" parameterClass="map" resultClass="kf05Domain">
		SELECT 
		       a.aaz263 as aaz263,
		  FROM kf05 a
		 WHERE 1 = 1 <!-- 若要查询的参数未输入 则返回全部数据  -->
<![CDATA[	   AND a.aaz263 = #aaz263#    ]]> <!-- <![CDATA[[ 可缺省参数 ]]> -->
</select>
```

> 对应关系图

![对应关系图](https://github.com/tucaoxingren/ProgramingNote/raw/master/img/image008.gif)


> 参考文章
[深入iBATIS](https://www.ibm.com/developerworks/cn/java/j-lo-ibatis-principle/)
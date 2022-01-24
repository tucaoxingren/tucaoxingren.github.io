---
title: xml 标记语言浅析
date: 2017-12-14
time: 17:41:05
categories: xml
toc: true
tag: 
---
</p>

# xml 标记语言浅析

## 常见xml文件头释义

```xml
<!-- 版本  编码方式 -->
<?xml version="1.0" encoding="UTF-8"?>
<!-- 文档类型  校验规则  可以自己编写  可以引入外部文件规则（包括从网络引入规则） -->
<!DOCTYPE sqlMap PUBLIC
    "-//ibatis.apache.org//DTD SQL Map 2.0//EN"
    "http://ibatis.apache.org/dtd/sql-map-2.dtd">
```

## DTD

### 文档类型定义 (Document Type Definition)

DTD 是一套关于标记符的语法规则。它是XML1.0版规格得一部分,是XML文件的验证机制,属于XML文件组成的一部分

DTD 是一种保证XML文档格式正确的有效方法，可以通过比较XML文档和DTD文件来看文档是否符合规范，元素和标签使用是否正确。一个DTD文档包含：元素的定义规则，元素间关系的定义规则，元素可使用的属性，可使用的实体或符号规则

XML文件提供应用程序一个数据交换的格式,DTD正是让XML文件能够成为数据交换的标准,因为不同的公司只需定义好标准的DTD,各公司都能够依照DTD建立XML文件,并且进行验证,如此就可以轻易的建立标准和交换数据，这样满足了网络共享和数据交互

DTD文件是一个ASCII的文本文件，后缀名为.dtd

### DTD 简介

文档类型定义（DTD）可定义合法的XML文档构建模块。它使用一系列合法的元素来定义文档的结构

DTD 可被成行地声明于 XML 文档中，也可作为一个外部引用

#### 内部的 DOCTYPE 声明

　　假如 DTD 被包含在您的 XML 源文件中，它应当通过下面的语法包装在一个 DOCTYPE 声明中：

　　`<!DOCTYPE 根元素 [元素声明]>`

　　带有 DTD 的 XML 文档实例

```xml
    <?xml version="1.0"?>
　　<!DOCTYPE note [
　　<!ELEMENT note (to,from,heading,body)>
　　<!ELEMENT to (#PCDATA)>
　　<!ELEMENT from (#PCDATA)>
　　<!ELEMENT heading (#PCDATA)>
　　<!ELEMENT body (#PCDATA)>
　　]>
　　<note>
　　<to>Tove</to>
　　<from>Jani</from>
　　<heading>Reminder</heading>
　　<body>Don't forget me this weekend</body>
　　</note>
```

以上 DTD 解释如下：

　　!DOCTYPE note (第二行)定义此文档是 note 类型的文档

　　!ELEMENT note (第三行)定义 note 元素有四个元素："to、from、heading,、body"

　　!ELEMENT to (第四行)定义 to 元素为 "#PCDATA" 类型

　　!ELEMENT from (第五行)定义 from 元素为 "#PCDATA" 类型

　　!ELEMENT heading (第六行)定义 heading 元素为 "#PCDATA" 类型

　　!ELEMENT body (第七行)定义 body 元素为 "#PCDATA" 类型

#### 外部文档声明

　　假如 DTD 位于 XML 源文件的外部，那么它应通过下面的语法被封装在一个 DOCTYPE 定义中：
　　`<!DOCTYPE 根元素 SYSTEM "文件名">`
　　这个 XML 文档和上面的 XML 文档相同，但是拥有一个外部的 DTD:

```xml
　　<?xml version="1.0"?>
　　<!DOCTYPE note SYSTEM "note.dtd">
　　<note>
　　<to>Tove</to>
　　<from>Jani</from>
　　<heading>Reminder</heading>
　　<body>Don't forget me this weekend!</body>
　　</note> 这是包含 DTD 的 "note.dtd" 文件：
　　<!ELEMENT note (to,from,heading,body)>
　　<!ELEMENT to (#PCDATA)>
　　<!ELEMENT from (#PCDATA)>
　　<!ELEMENT heading (#PCDATA)>
　　<!ELEMENT body (#PCDATA)>
```

3. 为什么使用 DTD 

　　通过 DTD，您的每一个 XML 文件均可携带一个有关其自身格式的描述

　　通过 DTD，独立的团体可一致地使用某个标准的 DTD 来交换数据

　　而您的应用程序也可使用某个标准的 DTD 来验证从外部接收到的数据

　　您还可以使用 DTD 来验证您自身的数据
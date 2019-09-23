---
title: JavaScript初识
date: 2017-12-12
time: 15:33:05
categories: JavaScript
toc: true
tag: 
---
</p>

# JavaScript初识

## JavaScript 用法

HTML 中的脚本必须位于 `<script>` 与 `</script>` 标签之间

脚本可被放置在 HTML 页面的 `<body>` 和 `<head>` 部分中

### javascript改变HTML

```html
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
    <title>菜鸟教程(runoob.com)</title>
</head>
<body>
    <h1>我的第一段 JavaScript</h1>
    <div id="demo">
        <div>
            JavaScript 能改变 HTML 元素的内容。
        </div>
    </div>
    <script>
        function myFunction(){
            x=document.getElementById("demo");  // 找到元素
            // innerHTML 即指定DOM节点下的所有内容包含子节点
            x.innerHTML="Hello JavaScript!";    // 改变内容
        }
    </script>
    <button type="button" onclick="myFunction()">点击这里</button>
</body>
</html>
```

## JavaScript 语法

### typeof

`constructor` 属性返回所有 `JavaScript` 变量的构造函数
`变量名.constructor`

```javascript
// null 和 undefined 的值相等，但类型不等：

typeof undefined             // undefined
typeof null                  // object
null === undefined           // false
null == undefined            // true
123..toString(); // '123', 注意是两个点！
(123).toString(); // '123'

```

1. 不要使用`new Number()`、`new Boolean()`、`new String()`创建包装对象；

1. 用`parseInt()`或`parseFloat()`来转换任意类型到`number`；

1. 用`String()`来转换任意类型到`string`，或者直接调用某个对象的`toString()`方法；

1. 通常不必把任意类型转换为`boolean`再判断，因为可以直接写`if (myVar) {...}`

1. `typeof`操作符可以判断出`number`、`boolean`、`string`、`function`和`undefined`；

1. 判断`Array`要使用`Array.isArray(arr)`；

1. 判断`null`请使用`myVar === null`；

1. 判断某个全局变量是否存在用`typeof window.myVar === 'undefined'`；

1. 函数内部判断某个变量是否存在用`typeof myVar === 'undefined'`

### JavaScript 数据类型

在 JavaScript 中有 6 种不同的数据类型：

`string`
`number`
`boolean`
`object`
`function`
`undefined` 未定义的

1 个不包含任何值的对象类型：

`null`(数据类型 object)

3 种对象类型(数据类型 object)：

`Object` `var obj = {};`\
`Date` `var date = new Date();` \
`Array` `var arr = new Array;` 或 `var arr = [];`

    NaN 的数据类型是 number
    数组(Array)的数据类型是 object
    日期(Date)的数据类型为 object
    null 的数据类型是 object
    未定义变量的数据类型为 undefined

### JavaScript 变量

在编程语言中，变量用于存储数据值。
JavaScript 使用关键字 var 来定义变量， 使用等号来为变量赋值：

```javascript
var x, length,value//value=undefined 未赋值的变量默认为undefined
x = 5
length = 6
```

**变量是一个名称,字面量是一个值**

> 变量可以通过变量名访问。在指令式语言中，变量通常是可变的。字面量是一个恒定的值

声明变量类型

当您声明新变量时，可以使用关键词 "new" 来声明其类型：

```javascript
var carname=new String;//
var x=      new Number;
var y=      new Boolean;
var cars=   new Array;
var person= new Object;
```

局部变量：在函数中通过var声明的变量

全局变量：在函数外通过var声明的变量

没有声明就使用的变量，默认为全局变量，不论这个变量在哪被使用

### JavaScript 操作符

| 类型 | 实例 | 描述 |
|------|------|------|
| 赋值，算术和位运算符   | =  +  -  *  / | 在 JS 运算符中描述      |
| 条件，比较及逻辑运算符 | ==  != <  >   | 在 JS 比较运算符中描述 |

### `JavaScript` 字符集

`JavaScript` 使用 `Unicode` 字符集。
`Unicode` 覆盖了所有的字符，包含标点等字符。

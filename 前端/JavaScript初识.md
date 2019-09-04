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

## JavaScript简介
JavaScript 是 Web 的编程语言
>HTML 定义了网页的内容

>CSS 描述了网页的布局

>JavaScript 网页的行为

JavaScript 是脚本语言

JavaScript 是一种轻量级的编程语言

## JavaScript 用法
HTML 中的脚本必须位于 `<script>` 与 `</script>` 标签之间

脚本可被放置在 HTML 页面的 `<body>` 和 `<head>` 部分中

## JavaScript 语法

### JavaScript 字面量

#### 数字（Number）字面量 

可以是整数或者是小数，或者是科学计数(e)
```javascript
3.14

1001

123e5
```

#### 字符串（String）字面量 
可以使用单引号或双引号
```javascript
"John Doe"

'John Doe'
```

#### 表达式字面量
用于计算
```javascript
5 + 6

5 * 10
```

#### 数组（Array）字面量 
定义一个数组
```javascript
[40, 100, 1, 5, 25, 10]
```

JavaScript 数组
下面的代码创建名为 cars 的数组：
```javascript
var cars=new Array();
cars[0]="Saab";
cars[1]="Volvo";
cars[2]="BMW";
```

或者 (condensed array):
`var cars=new Array("Saab","Volvo","BMW");`

或者 (literal array):
实例
`var cars=["Saab","Volvo","BMW"];`

#### 对象（Object）字面量
定义一个对象
```javascript
{firstName:"John", lastName:"Doe", age:50, eyeColor:"blue"}
```
#### 函数（Function）字面量 
定义一个函数
```javascript
function myFunction(a, b) { return a * b;}
```

对象由花括号分隔。在括号内部，对象的属性以名称和值对的形式 (name : value) 来定义。属性由逗号分隔：

`var person={firstname:"John", lastname:"Doe", id:5566};`
上面例子中的对象 `(person) `有三个属性：`firstname、lastname` 以及 `id`

空格和折行无关紧要 声明可横跨多行：

```javascript
var person={
firstname : "John",
lastname  : "Doe",
id        :  5566
};
```

对象属性有两种寻址方式：
实例
```javascript
name=person.lastname;
name=person["lastname"];
```

### JavaScript 变量
在编程语言中，变量用于存储数据值。
JavaScript 使用关键字 var 来定义变量， 使用等号来为变量赋值：
```javascript
var x, length,value//value=undefined 未赋值的变量默认为undefined
x = 5
length = 6
```

** 变量是一个名称,字面量是一个值 **
>变量可以通过变量名访问。在指令式语言中，变量通常是可变的。字面量是一个恒定的值

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

### JavaScript 关键字
`var` 定义变量

JavaScript是弱类型语言

`//`单行注释  `/* */`多行注释

### JavaScript 数据类型
JavaScript 有多种数据类型：数字，字符串，数组，对象等等：
```javascript
var length = 16;                                  // Number 通过数字字面量赋值 
var points = x * 10;                              // Number 通过表达式字面量赋值
var lastName = "Johnson";                         // String 通过字符串字面量赋值
var cars = ["Saab", "Volvo", "BMW"];              // Array  通过数组字面量赋值
var person = {firstName:"John", lastName:"Doe"};  // Object 通过对象字面量赋值
```

### JavaScript 函数
JavaScript 语句可以写在函数内，函数可以重复引用：
引用一个函数 = 调用函数(执行函数内的语句)。
```javascript
function myFunction(a, b) {
    return a * b;                                // 返回 a 乘于 b 的结果
}
```

### JavaScript 字母大小写
`JavaScript` 对大小写是敏感的。
当编写 `JavaScript` 语句时，请留意是否关闭大小写切换键
函数 `getElementById` 与 `getElementbyID` 是不同的
同样，变量 `myVariable` 与 `MyVariable` 也是不同的

### `JavaScript` 字符集
`JavaScript` 使用 `Unicode` 字符集。
`Unicode` 覆盖了所有的字符，包含标点等字符。
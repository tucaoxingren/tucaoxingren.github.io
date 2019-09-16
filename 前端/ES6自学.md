## 新增定义变量关键字
### let
拥有代码块级作用域
### const
定义常量

**注意**

只有定义的基本类型的常量才是真正的常量

对于对象而言只是保证指向的内存地址不变

例如
```javascript
const foo = {};

// 为 foo 添加一个属性，可以成功
foo.prop = 123;
foo.prop // 123

// 将 foo 指向另一个对象，就会报错
foo = {}; // TypeError: "foo" is read-only
```

## 数组的解构赋值 
`let [a, b, c] = [1, 2, 3];`
```javascript
let [foo, [[bar], baz]] = [1, [[2], 3]];
foo // 1
bar // 2
baz // 3

let [ , , third] = ["foo", "bar", "baz"];
third // "baz"

let [x, , y] = [1, 2, 3];
x // 1
y // 3

let [head, ...tail] = [1, 2, 3, 4];
head // 1
tail // [2, 3, 4]

let [x, y, ...z] = ['a'];
x // "a"
y // undefined
z // []
```

## 模板字符串

```javascript
// 字符串中嵌入变量
let name = "Bob", time = "today";
`Hello ${name}, how are you ${time}?`
```

## 正则
```javascript
var reg = /\d/g;
console.log(reg.exec("2016"));//->["2", index: 0, input: "2016"]
/*
g(global)->全局匹配
i(ignoreCase)->忽略大小写匹配
m(multiline)->换行匹配
ES6新增
u(Unicode)->用来正确处理大于\uFFFF的 Unicode 字符。也就是说，会正确处理四个字节的 UTF-16 编码
y(sticky)修饰符的作用与g修饰符类似，也是全局匹配，后一次匹配都从上一次匹配成功的下一个位置开始。不同之处在于，g修饰符只要剩余位置中存在匹配就可，而y修饰符确保匹配必须从剩余的第一个位置开始，这也就是“粘连”的涵义。
s 匹配任意字符 即 . 可以匹配 \n \r 等
*/
// ^和$匹配每一行的行首和行尾
var s = 'aaa_aa_a';
var r1 = /a+/g;
var r2 = /a+/y;

r1.exec(s) // ["aaa"]
r2.exec(s) // ["aaa"]

r1.exec(s) // ["aa"]
r2.exec(s) // null
```
# TypeScript

`TypeScript`是`JavaScript`的超集

在`JavaScript`的基础上添加了静态类型检查、接口、泛型等很多**现代开发特性**，因此更适合**大型项目**的开发



在浏览器运行环境下`TypeScript`需要编译为`JavaScript`才能使用



## 基础语法



### 数据类型

使用`JavaScript`时，经常会遇到一个问题调用一个函数，函数入参是一个`object`，但是编程中，这个`object`通常IDE不会自动代码补全其中的属性（Webstorm开发工具会通过输入记录及代码推导，进行代码补全，并不精确，有可能出错），降低了开发效率，且此`object`在传递过程中可能会被其它函数添加了新的属性，不利于大型软件工程的代码管控。

> 注：在`JavaScript`中可以函数上添加适当的注释，使一些IDE能自动代码补全 例如 `@param {a: string}`



```typescript
type User = {
    name: string,
    age: number
}

/**
 * 获取用户年龄
 * @param user {name: string, age: number} // 若是JavaScript 需要在JSDoc中说明参数的数据结构 才能获取IDE的代码补全支持 TypeScript则不需要
 */
function getUserAge(user: User): number {
    return user.age;
}

const user: User = {
    name: '张三',
    age: 18
}

console.log(getUserAge(user));// 此处 若是JavaScript 传入的数据类型错误时编译时不会提示错误，运行时才会报错
```



#### 键值对结构

即Map结构数据

```typescript
type colorMapType = Record<string, number>;

let colorMap: colorMapType = {
    red: 1,
    white: 2
}

console.log(colorMap.red);


// 第二种写法 推荐
type colorMapType = { [key: string]: number };

let colorMap: colorMapType = {
    red: 1,
    white: 2
}

console.log(colorMap.red);

```



#### 元组结构

我们知道数组中元素的数据类型都一般是相同的（any[] 类型的数组可以不同），如果存储的元素数据类型不同，则需要使用元组。

TypeScript 中的元组（Tuple）是一种特殊类型的数组，它允许在数组中存储不同类型的元素，与普通数组不同，元组中的每个元素都有明确的类型和位置。元组可以在很多场景下用于表示固定长度、且各元素类型已知的数据结构。

创建元组的语法格式如下：

```typescript
let tuple: [类型1, 类型2, 类型3, ...];
```



示例

```typescript
type colorTupleType = [string, number];

let colorTuple: colorTupleType = ['red', 1];
// let colorTuple: colorTupleType = ['red', 1, 2]; // 编译错误

console.log(colorTuple[0]);// 输出 'red'

colorTuple.push(1);// 不会报错 因为本质还是数组
colorTuple.push(1);
console.log(colorTuple);

```


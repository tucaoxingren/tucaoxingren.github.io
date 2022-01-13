## 切点 `@Pointcut`

### 表达式

`execution(modifiers-pattern? ret-type-pattern declaring-type-pattern? name-pattern(param-pattern)throws-pattern?) `

括号中各个`pattern`分别表示：

- 修饰符匹配    `modifier-pattern?` 
- 返回值匹配    `ret-type-pattern`    可以为`*`表示任何返回值,全路径的类名等
- 类路径匹配    `declaring-type-pattern?`
- 方法名匹配    `name-pattern`    可以指定方法名 或者 `*`代表所有, `set*` 代表以`set`开头的所有方法
-   参数匹配    `(param-pattern)`    可以指定具体的参数类型，多个参数间用`,`隔开，各个参数也可以用`*`来表示匹配任意类型的参数，如`(String)`表示匹配一个`String`参数的方法；`(*,String)` 表示匹配有两个参数的方法，第一个参数可以是任意类型，而第二个参数是String类型；可以用`(..)`表示零个或多个任意参数
- 异常类型匹配    `throws-pattern?`
- 其中后面跟着`?`的是可选项

### 通配符的使用：

- `*`  匹配所有字符
- `..`  一般用于匹配多个包，多个参数
- `+`   表示类及其子类
- 运算符有：与   `&&`、或   `||`、非   `!`



## 问题记录

### 对`servlet`切片

`aop` 是基于`spring bean`的技术 无法对`servlet`切片


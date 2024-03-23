

## 数据类型

| Dalvik字节码类型 | java基本数据类型 |
| ---------------- | ---------------- |
| V                | void             |
| Z                | boolean          |
| B                | byte             |
| C                | char             |
| S                | short            |
| I                | int              |
| J                | long             |
| F                | float            |
| D                | double           |
| L                | java类类型       |
| [                | 数组类型         |



### 赋值示例



#### Boolean

赋值`true`

```smali
const/4 v0, 0x1
return v0
```



赋值`false`

```smali
const/4 v0, 0x0
return v0
```



## return-void

`return-void`表示方法没有返回值，也就是`void`，同时返回值还可以是:

- `return vx`：返回 `vx` 寄存器中的值。
- `return-wide vx`：返回在 `vx,vx+1` 寄存器的 `doubl e/long` 值。
- `return-object vx`：返回在 vx 寄存器的对象引用。

| smali方法返回关键字 | java    |
| ------------------- | ------- |
| return              | byte    |
| return              | short   |
| return              | int     |
| return-wide         | long    |
| return              | float   |
| return-wide         | double  |
| return              | char    |
| return              | boolean |
| return-void         | void    |
| return-object       | 数组    |
| return-object       | object  |



## 打包错误记录

### Failed parse during installPackageLI: Targeting R+

[Android 11 重打包对齐错误_failure [-124: failed parse during installpackagel-CSDN博客](https://blog.csdn.net/xys616/article/details/123892541)

[zipalign  | Android Studio  | Android Developers (google.cn)](https://developer.android.google.cn/tools/zipalign?hl=zh-cn)
---
title: Java正则表达式
date: 2017-10-08
time: 16:13:05
categories: java
toc: true
tag: 正则表达式
---
</p>

# Java正则表达式

## 简单运用
```java
//匹配手机号码是否正确。 
String tel = "15800001111";
String regex = "1[34578]\\d{9}";//  \\d{9} 匹配9位数字
//.* 匹配任意字符
String str = "abdc你45.java";
String reg = ".*.java";
//字符串以 特定字符串或字符结尾
System.out.println(str.endsWith(".java"));
//字符串以 特定字符串或字符开头
System.out.println(str.startsWith("a"));

//重复字母切字符串
String str = "zhangsanttttxiaoqiangmmmmmmzhaoliu";
//  (.) 字符组 即重复字符为1组  \\1 为组编号
//编号为1的组即(.)  编号0的组代表整个表达式
String[] names = str.split("(.)\\1+");
//输出
//zhangsan
//xiaoqiang
//zhaoliu

String tel = "15800001111";
// $ 代表前一个参数中的正则表达式中的组后面接组的编号
tel = tel.replaceAll("(\\d{3})\\d{4}(\\d{4})", "$1****$2");
System.out.println(tel);//158****1111;
```

获取以空格分隔的包含三个字符的字符串组 并返回字符串组的下标
```java
String str = "da jia hao,ming tian bu fang jia!";
String regex = "\\b[a-z]{3}\\b";
//1,将正则封装成对象。
Pattern p = Pattern.compile(regex);
//2, 通过正则对象获取匹配器对象。 
Matcher m = p.matcher(str);
//使用Matcher对象的方法对字符串进行操作。
//既然要获取三个字母组成的单词 
//查找。 find();
System.out.println(str);
while(m.find()){
    System.out.println(m.group());//获取匹配的子序列            
    System.out.println(m.start()+":"+m.end());
}
/*//输出
da jia hao,ming tian bu fang jia!
jia
3:6
hao
7:10
jia
29:32
*/
```

## 常用字符匹配

### 字符

| 构造        | 匹配    |
| --------    | -----:   |
| \\          | 反斜线字符     |
| \0n         | 带有八进制值 0 的字符 n (0 <= n <= 7)      |
| \0nn        | 带有八进制值 0 的字符 nn (0 <= n <= 7)     |
| \0mnn       | 带有八进制值 0 的字符 mnn（0 <= m <= 3、0 <= n <= 7） |
| \xhh        | 带有十六进制值 0x 的字符 hh |
| \uhhhh      | 带有十六进制值 0x 的字符 hhhh |
| \t          | 制表符 ('\u0009') |
| \n          | 新行（换行）符 ('\u000A') |
| \r          | 回车符 ('\u000D') |
| \f          | 换页符 ('\u000C') |
| \a          | 报警 (bell) 符 ('\u0007') |
| \e          | 转义符 ('\u001B') |
| \cx         | 对应于 x 的控制符 |

### 字符类
| 构造            | 匹配    |
| --------        | -----:   |
| [abc]           | a、b 或 c（简单类） |
| [^abc]          | 任何字符，除了 a、b 或 c（否定） |
| [a-zA-Z]        | a 到 z 或 A 到 Z，两头的字母包括在内（范围） |
| [a-d[m-p]]      | a 到 d 或 m 到 p：[a-dm-p]（并集） |
| [a-z&&[def]]    | d、e 或 f（交集） |
| [a-z&&[^bc]]    | a 到 z，除了 b 和 c：[ad-z]（减去） |
| [a-z&&[^m-p]]   | a 到 z，而非 m 到 p：[a-lq-z]（减去） |

### 预定义字符类
| 构造            | 匹配    |
| --------        | -----:   |
| .   | 任何字符（与行结束符可能匹配也可能不匹配） |
| \d  | 数字：[0-9] |
| \D  | 非数字： [^0-9] |
| \s  | 空白字符：[ \t\n\x0B\f\r] |
| \S  | 非空白字符：[^\s] |
| \w  | 单词字符：[a-zA-Z_0-9] |
| \W  | 非单词字符：[^\w] |

### 边界匹配器
| 构造            | 匹配    |
| --------        | -----:   |
| ^   | 行的开头 |
| $   | 行的结尾 |
| \b  | 单词边界 |
| \B  | v非单词边界 |
| \A  | 输入的开头 |
| \G  | 上一个匹配的结尾 |
| \Z  | 输入的结尾，仅用于最后的结束符（如果有的话） |
| \z  | 输入的结尾 |

### Greedy 数量词
| 构造            | 匹配    |
| --------        | -----:   |
| X?  | X，一次或一次也没有 |
| X*  | X，零次或多次 |
| X+  | X，一次或多次 |
| X{n}    | X，恰好 n 次 |
| X{n,}   | X，至少 n 次 |
| X{n,m}  | X，至少 n 次，但是不超过 m 次 |

---
title: Java StringBuffer
date: 2017-09-08
time: 11:15:02
categories: Java
toc: true
tag: StringBuffer
---
</p>

# StringBuffer
**StringBuffer:就是字符串缓冲区。**
**用于存储数据的容器。**
## 特点：
1.长度的可变的。 
2.可以存储不同类型数据。
3.最终要转成字符串进行使用。
4.可以对字符串进行修改。 
 
## 既然是一个容器对象。应该具备什么功能呢？
### 1.添加：
> 
StringBuffer append(data);
StringBuffer insert(index,data);
### 2.删除：
> 
StringBuffer delete(start,end):包含头，不包含尾。
StringBuffer deleteCharAt(int index):删除指定位置的元素 
### 3.查找：
> 
char charAt(index);
int indexOf(string);
int lastIndexOf(string);
### 4.修改：
> 
StringBuffer replace(start,end,string);
void setCharAt(index,char);
 
### 增删改查  C(create)U(update)R(read)D(delete) 
 
```java
public class StringBufferDemo {

	public static void main(String[] args) {

		
		bufferMethodDemo_2();
	}
	
	private static void bufferMethodDemo_2() {
		StringBuffer sb = new StringBuffer("abcd");
		System.out.println("初始字符:"+sb);
		sb.delete(1, 3);//ad
		System.out.println("删除1-3位置的字符:"+sb);
		//清空缓冲区。
		sb.delete(0,sb.length());//sb = new StringBuffer();
		System.out.println("清空:"+sb);
		sb.append("abcd");//添加字符
		System.out.println("添加字符:"+sb);
		//替换字符
		sb.replace(1, 3, "nba");System.out.println("替换位置1-3位置的字符为”nba“:"+sb);
		sb.replace(0, 5, "abcd");sb.setCharAt(2, 'q');//改变特定位置的字符
		System.out.println("替换位置2的字符为”q“:"+sb);
		System.out.println("设置字符串长度为10，若原字符串长度不足10，则不足部位部空字符");
		sb.setLength(10);
		System.out.println("sb:"+sb);
		System.out.println("len:"+sb.length());
		sb.replace(0, 10, "abcd");
		System.out.println("反转字符串:"+sb.reverse());
	}

	public static void bufferMethodDemo(){
		//创建缓冲区对象。
		StringBuffer sb = new StringBuffer();
		
		sb.append(4).append(false);//.append("haha");
		sb.insert(1, "haha");
//		sb.append(true);
		
		System.out.println(sb);
		
	}

}
```
## 运行结果

```
初始字符:abcd
删除1-3位置的字符:ad
清空:
添加字符:abcd
替换位置1-3位置的字符为”nba“:anbad
替换位置2的字符为”q“:abqd
设置字符串长度为10，若原字符串长度不足10，则不足部位部空字符
sb:abqd
```
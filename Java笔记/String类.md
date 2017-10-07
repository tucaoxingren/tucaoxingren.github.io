---
title: String类
date: 2017-09-06
time: 21:15:02
categories: Java
toc: true
tag: 字符串
---
</p>

# String类

## 示例代码

```java
package cn.test.t1.string.demo;

public class StringDemo {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		/*
		 * String类的特点：
		 * 字符串对象一旦被初始化就不会被改变
		 * */
		//"abc"存储在字符串常量池中 池中有 直接使用 没有 创建新对象
		String s = "abc";//创建一个字符串对象在常量池中
		//s = "cba";
		/*虽然输出是 cba 但实际上并不是把原来的“abc” 改变为
		 * “cba” 而是 新建了一个 “cba”对象 然后把s指向“cba”
		 * 而原对象“abc”并没有被改变
		*/
		String s1 = "abc";//新建一个字符串的引用对象s1指向已经存在的“abc”
		String s2 = new String("abc");//创建两个对象一个new，一个字符串对象在堆内存中
		String s3 = new String("abc");//开辟一个新的“abc”对象，并使s3指向它
		byte[] arr = {'a','b','c','d','e'};
		String s4 = new String(arr,1,3);//从arr数组的角标1位置开始取数据连续取3个数据
		System.out.println(s4);
		/* s s1 s2 s3 是引用型变量 存储着引用对象的地址
		 * == 比较的是对象的内容 即 引用对象的地址 
		 * Object 中的equals方法比较的是地址
		 * String 覆写了Object类中的equals方法 比较的是字符串 内容是否一致*/
		System.out.println(s == s1);//true
		System.out.println(s.equals(s1));//true
		System.out.println(s == s2);//false
		System.out.println(s.equals(s2));//true
		System.out.println(s2 == s3);//false
		System.out.println(s2.equals(s3));//true
	}

}

```

## 运行结果
> 
bcd
true
true
false
true
false
true
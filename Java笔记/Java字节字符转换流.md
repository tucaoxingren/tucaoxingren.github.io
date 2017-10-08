---
title: Java字节字符转换流
date: 2017-10-07
time: 15:41:05
categories: java
toc: true
tag: 
---
</p>

# Java字节字符转换流

## 转换流的用法
```java
//字节流
InputStream in = System.in;

//将字节转成字符的桥梁  转换流
InputStreamReader isr = new InputStreamReader(in);

//字符流
BufferedReader bufr = new BufferedReader(isr);

OutputStream out = System.out;

OutputStreamWriter osw = new OutputStreamWriter(out);

BufferedWriter  bufw = new BufferedWriter(osw);

String line = null;

while((line=bufr.readLine())!=null){
	if("over".equals(line))
		break;
	
	bufw.write(line);//写入文件中
	bufw.newLine();//换行
	bufw.flush();//刷新
}
```

## 从键盘读数据存储到指定文件中
```java
/*
 * 将键盘录入的数据写入到一个文件中
 * 
 * 将一个文本文件内容显示在控制台上
 */

BufferedReader bufr = new BufferedReader(new InputStreamReader(System.in));

BufferedWriter bufw = new BufferedWriter(new OutputStreamWriter(new FileOutputStream("b.txt")));


String line = null;

while((line=bufr.readLine())!=null){
    if("over".equals(line))
        break;
    
    //bufw.write(line.toUpperCase());
    bufw.write(line);
    bufw.newLine();
    bufw.flush();
}

}
```
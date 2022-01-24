---
title: Java IO流
date: 2017-10-05
time: 16:25:05
categories: Java
toc: true
tag: IO流
---
</p>

# Java IO流

## 输入流FileReader
```java
/*
 * 在创建读取流对象时，必须要明确被读取的文件。一定要确定该文件是存在的。 
 * 
 * 用一个读取流关联一个已存在文件。 
 */
FileReader fr = null;
try {
    fr = new FileReader("demo.txt");
} catch (FileNotFoundException e) {
    System.out.print("系统找不到指定的文件。");
} finally {
    //fr.close();
}
int ch = 0;

if(fr != null) {
    while((ch=fr.read())!=-1){
        System.out.print((char)ch);
    }
    fr.close();
}
```

## 输出流 FileWriter
```java
//创建一个可以往文件中写入字符数据的字符输出流对象。
/*
 * 既然是往一个文件中写入文字数据，那么在创建对象时，就必须明确该文件(用于存储数据的目的地)。
 * 
 * 如果文件不存在，则会自动创建。
 * 如果文件存在，则会被覆盖。
 * 
 * 如果构造函数中加入true，可以实现对文件进行续写！
 */
FileWriter fw = new FileWriter("demo.txt",true);//附加写入

/*
 * 调用Writer对象中的write(string)方法，写入数据。 
 * 
 * 其实数据写入到临时存储缓冲区中。
 * 
 */
fw.write("abcde"+LINE_SEPARATOR+"hahaha");
fw.write("xixi");

/*
 * 进行刷新，将数据直接写到目的地中。
 */

//      fw.flush();

/*
 * 关闭流，关闭资源。在关闭前会先调用flush刷新缓冲中的数据到目的地。
 */
fw.close();
```

## 按字符复制文本文件
```java
//1,读取一个已有的文本文件，使用字符读取流和文件相关联
FileReader fr = new FileReader("IO流_2.txt");
//2,创建一个目的，用于存储读到数据
FileWriter fw = new FileWriter("copytext_1.txt");
//3,频繁的读写操作
int ch = 0;
while((ch=fr.read())!=-1){
    fw.write(ch);
}
//4,关闭流资源
fw.close();
fr.close();
```

## 按缓冲区复制文本文件
```java
FileReader fr = null;
FileWriter fw = null;
try {
    fr = new FileReader("IO流_2.txt");
    fw = new FileWriter("copytest_2.txt");
    
    //创建一个临时容器，用于缓存读取到的字符。
    char[] buf = new char[BUFFER_SIZE];//这就是缓冲区。 
    
    //定义一个变量记录读取到的字符数，(其实就是往数组里装的字符个数 )
    int len = 0;
    
    while((len=fr.read(buf))!=-1){
        fw.write(buf, 0, len);
    }
    
} catch (Exception e) {
//          System.out.println("读写失败");
    throw new RuntimeException("读写失败");
}finally{
    if(fw!=null)
        try {
            fw.close();
        } catch (IOException e) {
            
            e.printStackTrace();
        }
    if(fr!=null)
        try {
            fr.close();
        } catch (IOException e) {
            
            e.printStackTrace();
        }
}
}
```

## BufferedReader
```java
FileReader fr = new FileReader("buf.txt");
BufferedReader bufr = new BufferedReader(fr);
String line = null;
while((line=bufr.readLine())!=null){
    System.out.println(line);
}
bufr.close();
```

## BufferedWriter
```java
FileWriter fw = new FileWriter("buf.txt");

//为了提高写入的效率。使用了字符流的缓冲区。
//创建了一个字符写入流的缓冲区对象，并和指定要被缓冲的流对象相关联
BufferedWriter bufw = new BufferedWriter(fw);

//使用缓冲区的写入方法将数据先写入到缓冲区中。
//      bufw.write("abcdefq"+LINE_SEPARATOR+"hahahha");
//      bufw.write("xixiixii");
//      bufw.newLine();
//      bufw.write("heheheheh");

for(int x=1; x<=4; x++){
    bufw.write("abcdef"+x);
    bufw.newLine();
    bufw.flush();
}


//使用缓冲区的刷新方法将数据刷目的地中。
//bufw.flush();


//关闭缓冲区。其实关闭的就是被缓冲的流对象。
bufw.close();
```

## Buffer复制文件
```java
FileReader fr = new FileReader("buf.txt");      
BufferedReader bufr = new BufferedReader(fr);

FileWriter fw = new FileWriter("buf_copy.txt");
BufferedWriter bufw = new BufferedWriter(fw);


String line = null;
while((line=bufr.readLine())!=null){
    bufw.write(line);
    bufw.newLine();
    bufw.flush();
}
bufw.close();
bufr.close();
```
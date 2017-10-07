---
title: 成员变量与局部变量理解及static变量
date: 2017-08-29
time: 15:15:02 
categories: Java
toc: true
tag: static
---
</p>

成员变量与局部变量理解及static变量
======
```java
class Demo2 {
 
    int a;//a为成员变量，成员变量没有赋初值，自动赋值0
    char c;//ascii(0)对应的转义字符 '\0' 代码为NUL 意味空字符；
    //扩展：ascii码 0-31 为控制字符，32-127为可打印字符
    double d;
    float f;
    byte by;
    boolean boo;
    //static修饰的变量为真正意义上的全局变量，但java中没有全局变量的概念
    //此处的变量b等同于全局变量
    static int b;
 
    void printNum(){
        //成员变量可以在成员方法中直接使用
        System.out.println("printNum-a="+a);
        System.out.println("printNum-b="+b);
        System.out.println("------各基本类型初值------");
        System.out.println("printNum-char="+c);
        System.out.println("printNum-double="+d);
        System.out.println("printNum-float="+f);
        System.out.println("printNum-byte="+by);
        System.out.println("printNum-boolean="+boo);
        System.out.println("----printNum函数结束----");
    }
 
    public static void main(String[] args) {
        // TODO 自动生成的方法存根
        //static修饰的成员变量可以直接在main中使用
        //静态方法   main 为静态方法
        //通常，在一个类中定义一个方法为static，那就是说，无需本类的对象即可调用此方法
        //声明为static的方法有以下几条限制：
        //· 它们仅能调用其他的static 方法。
            /*(static方法中可以通过创建（new）该类的引用或者在调用static方法的时
            候传递一个对象的引用过去，这两种方法来调用非static方法。
            典型的例子就是static void main()方法，在这个static方法中可以看到，
            会创建任意的实例，然后通过这些实例来调用所属类的非静态方法。)*/
        //· 它们只能访问static数据。 （所以不能访问成员变量a，而有static修饰的b可以访问）
        //· 它们不能以任何方式引用this 或super。
        System.out.println("成员变量b="+b);
 
        //没有static修饰的成员变量不可以直接在main中使用
        //System.out.println("a="+a);
 
        Demo2 printTest = new Demo2();
        printTest.printNum();
 
        //不直接在class中定义的变量都是局部变量
        int i = 10;//局部变量必须初始化
        System.out.println("局部变量i="+i);
 
        //缓存变量可以放置在代码块中{}
        {
            int temp;//局部变量temp声明
            temp = i;
            i = b;
            b = temp;
            System.out.println("temp="+temp);
        }//局部变量temp被回收，内存空间释放
 
        //此处编译出错，因为temp为局部变量，而局部变量作用域为声明该变量外一层{}的代码块区间
        //System.out.println(temp);
        System.out.println("局部变量i与成员变量b交换后i="+i);
    }
}
```

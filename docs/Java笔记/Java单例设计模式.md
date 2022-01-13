---
title: Java 单例设计模式
date: 2017-09-08
time: 11:22:05
categories: Java
toc: true
tag: Java
---
</p>

Java 单例设计模式
=============
__设计模式__
   对问题行之有效的解决方式
### 1. 单例设计模式
> 解决的问题：就是可以保证一个类在内存中的对象唯一性
> 必须对于多个应用程序使用同一配置信息对象时，就需要保证对象的唯一性。
> 如何保证对象的唯一性？
 > 1.不允许其他程序用new创建该类对象。
 > 2.在该类中创建一个本类实例。
 > 3.对外提供一个方法让其他程序可以获取到该对象。

 ### 2.步骤：
 > 1.把构造方法私有化
 > 2.通过new在本类中创建一个本类对象
 > 3.定义一个共有的方法，将创建的对象返回。

```java

//开发常用此种
class Single{//类一加载，对象就已经存在了
    private static Single s = new Single();
    private Single(){};
    public static Single getInstance() {       
        return s;      
    }  
}
//面试常用此种
class Single2{//类加载进来，没有对象，只有调用了getInstance
              //方法时，才会创建对象，延迟加载形式。
    private static Single2 s = null;
    private Single2(){};
    public static Single2 getInstance() {
        if (s == null)
            s = new Single2();
        return s;      
    }  
}
public class SingleDemo {  
 
    public static void main(String[] args) {
        // TODO 自动生成的方法存根
        Single ss1 = Single.getInstance();
        Single ss2 = Single.getInstance();
        System.out.println(ss1==ss2);
        //Test类不可new对象 只能在Test类中创建一次对象
        //需要获取对象需要使用类中的方法获取对象内存地址
        Test t1 = Test.getInstance();
        Test t2 = Test.getInstance();
        //t1 t2 都是指向同一个对象
        //下面的赋值操作实际是对同一个成员变量进行赋值操作
        t1.setNum(10);t2.setNum(20);
        //输出内容是一样的
        System.out.println(t1.getNum());
        System.out.println(t2.getNum());
    }
}
 
class Test {
    private int num;
    private static Test t = new Test();
    private Test(){}//构造函数私有化，不可创建对象
    public static Test getInstance(){
        return t;//返回本类中创建的对象
    }
    public void setNum(int num) {
        this.num = num;
    }
    public int  getNum() {
        return num;
 
    }
}
```

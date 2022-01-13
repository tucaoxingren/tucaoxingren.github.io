---
title: Handler初识(3)
date: 2017-09-29
time: 14:30:05
categories: android
toc: true
tag: handler
---
</p>

## Handler与线程
Handle 其实并没有真正的启动一个线程,`Handle.post(Thread);`只是调用了线程的`run`方法

## HandlerThread
真正开启了新线程
```java
protected void onCreate(Bundle savedInstanceState) {
    ...
    //HandlerThread
    //输出
    // com.example.handleactivity I/System.out:Activity-->1
    // com.example.handleactivity I/System.out: Thread-->119
    //此种方式新建了一个线程
    //打印当前线程ID
    System.out.println("Activity-->"+Thread.currentThread().getId());
    //生成一个HandlerThread对象,实现了使用Looper来处理消息队列的功能,
    //这个类由Android应用程序提供
    HandlerThread handlerThread = new HandlerThread("handler_thread");
    //在使用HandlerThread的getLooper()方法之前,必须先调用start方法
    handlerThread.start();
    MyHandler myHandler = new MyHandler(handlerThread.getLooper());
    Message msg = myHandler.obtainMessage();
    //发送信息
    Bundle bundle = new Bundle();
    bundle.putInt("age",21);bundle.putString("name","LiQi");
    msg.setData(bundle);

    msg.sendToTarget();//发送到调用msg的Handle对象
}

class MyHandler extends  Handler{
    public MyHandler(){

    }
    public  MyHandler(Looper looper){
        super(looper);
    }
    @Override
    public void handleMessage(Message msg) {
        //super.handleMessage(msg);
        //接收信息
        Bundle bundle = msg.getData();
        int age = bundle.getInt("age");
        String name = bundle.getString("name");
        System.out.println("name-->"+name+"\nage-->"+age);
        System.out.println("Thread-->"+Thread.currentThread().getId());
        System.out.println("handlerMessage");
    }
}
```
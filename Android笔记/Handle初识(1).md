---
title: Handler初识(1)
date: 2017-09-28
time: 21:41:05
categories: android
toc: true
tag: handler
---
</p>

# Handler

## What's handler

Android程序实现多线程的方式

## How use

创建Handle对象`Handler handler = new Handler();`
将要执行的操作写在线程对象的run方法中
```java
Runnable updateThread = new Runnable() {
    @Override
    public void run() {
        //要执行的动作
        //延迟2000ms再加载updateThread线程
        //handler.postDelayed(updateThread,2000);
    }
};
```
调用Handle的post方法,将要执行的线程对象添加到队列中`handler.post(updateThread);`

`updateThread`-线程名

移除线程`handler.removeCallbacks(updateThread);`
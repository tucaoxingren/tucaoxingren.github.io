---
title: Android Activity
date: 2017-09-21
time: 21:15:02 
categories: Java
toc: true
tag: Android
---
</p>

# Android 

## Activity
控件容器
### 创建Activity
1. 一个`Activity`就是一个类，要继承`AppCompatActivity`类
2. 要覆写`onCreat`方法 （即**main**方法，`Activity`的入口）
```java
public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    }
}
```
3. 每一个`Activity`都需要`在AndroidMainfest.xml`文件中进行配置
4. 若一个`Activity`含有`<intent_filter>`标签则这个`Activity`是*APP*启动时第一个加载的Activity
```xml
<activity android:name=".MainActivity">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />

                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
```
5. 为Activity添加控件

### 为Activity添加控件
`～/layout/activity_main.xml`(即`MainActivity`的布局文件)
常见布局文件如下 `<TextView>` 即一个文本控件 可以显示文本
布局方式 ：`ConstraintLayout`即约束布局
**Android studio2.2 新加入的布局方式，适合手动布局而非代码布局**
[ConstraintLayout详解](http://blog.csdn.net/guolin_blog/article/details/53122387)
```xml
<?xml version="1.0" encoding="utf-8"?>
<android.support.constraint.ConstraintLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    xmlns:tools="http://schemas.android.com/tools"
    android:layout_width="match_parent"
    android:layout_height="match_parent"

    android:layout_centerHorizontal="true"
    android:layout_centerVertical="true"

    tools:context="com.example.laoke.helloworld.MainActivity">

    <TextView
        android:text="@string/hello"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content" />

</android.support.constraint.ConstraintLayout>

```
常用控件：
`TextView`：文本
`Button`：按钮
所有控件的父类是`view`


## Xml

每个Activity对应一个xml ,xml控制布局位置
xml即布局文件

src目录：存放代码

---
title: Activity布局
date: 2017-09-25
time: 13:41:05
categories: android
toc: true
tag: activity
---
</p>

# Activity布局
`android:orientation="horizontal`  水平布局-横屏
`android:orientation="vertical`    垂直布局-竖屏
`android:layout_width="fill_parent`  宽度填满屏幕

```xml
<?xml version="1.0" encoding="utf-8"?>
<RelativeLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:id="@+id/activity_main"
    android:orientation="horizontal"
    android:layout_width="match_parent"
    android:layout_height="match_parent">
</RelativeLayout>
```

控件标签及含义

```xml
<!--
        android:id="@+id/refresh" \\控件id
        android:text \\控件文字
        android:grivity \\指定控件的基本位置,比如 居中等等
        android:textSize  \\指定控件中的字体大小
        android:layout_width="70dp"
        android:layout_height="70dp"
        android:layout_alignParentBottom="true"
        android:layout_centerInParent="true"
        android:layout_marginBottom="20dp"
        android:background="@drawable/refresh_icon"  \\控件背景颜色
-->
```
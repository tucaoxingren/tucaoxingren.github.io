---
title: Android menu
date: 2017-09-21
time: 11:15:02 
categories: Android
toc: true
tag: Menu
---
</p>

# android menu
若想使用菜单键
需要覆写onCreatOptionsMenu方法

## 直接创建
```java
public boolean onCreateOptionsMenu(Menu menu) {
        //菜单组ID，菜单ID，排序，菜单名字
        menu.add(0,1,1,R.string.exit);
        menu.add(0,2,2,R.string.about);

        return super.onCreateOptionsMenu(menu);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        //菜单按钮回调函数
        if (item.getItemId() == 1)
            finish();
        return super.onOptionsItemSelected(item);
    }
```

## 使用menu布局文件构建

### MainActivity.java

```java

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // 使用menu布局文件构建menu
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int id = item.getItemId();
        if (id == R.id.menu_about) {// 关于
            //displayAboutDialog();
            return true;
        } else if(id == R.id.menu_bluetooth){//蓝牙信息
            //ToastUtil.showToast(mContext, getString(R.string.menu_share));
            return true;
        }
        else if(id == R.id.menu_bluetoothTest){//蓝牙测试
            //ToastUtil.showToast(mContext, getString(R.string.menu_share));
            return true;
        }
        else if(id == R.id.menu_exit){//退出
            finish();
            return true;
        }

```

### menu_main.xml
```xml
<?xml version="1.0" encoding="utf-8"?>
<menu xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto">
    <item
        android:id="@+id/menu_about"
        android:orderInCategory="100"
        android:title="@string/menu_about"
        app:showAsAction="never" />
    <item
        android:id="@+id/menu_bluetooth"
        android:orderInCategory="100"
        android:title="@string/menu_bluetooth"
        app:showAsAction="never" />
    <item
        android:id="@+id/menu_bluetoothTest"
        android:orderInCategory="100"
        android:title="@string/menu_bluetoothTest"
        app:showAsAction="never" />
    <item
        android:id="@+id/menu_exit"
        android:orderInCategory="100"
        android:title="@string/menu_exit"
        app:showAsAction="never" />
</menu>
```
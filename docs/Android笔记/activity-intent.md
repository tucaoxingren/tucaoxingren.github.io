---
title: Android--Activity与Intent
date: 2017-09-24
time: 21:41:05
categories: Android
toc: true
tag: Activity
---
</p>

# Activity 与 Intent
## Intent
多个Activity间相互跳转
`startActivity(Intent intent)`

```java
Intent intent = new Intent();
//intent.putExtra("参数名","参数值");//传递参数
//从‘MainActivity’跳转到‘MapActivity’
intent.setClass(MainActivity.this,MapActivity.class);
//启动跳转
MainActivity.this.startActivity(intent);
```

## activity生命周期
```java
    @Override
    protected void onCreat() {
        super.onStart();
    }
    @Override
    protected void onStart() {
        super.onStart();
    }
    @Override
    protected void onDestroy() {
        super.onDestroy();
    }
    @Override
    protected void onResume() {
        super.onResume();
    }
    @Override
    protected void onPause() {
        super.onPause();
    }
    @Override
    protected void onRestart() {
        super.onStop();
    }
    @Override
    protected void onStop() {
        super.onStop();
    }
```
## 对话框式activity
新建Activity
并在`AppMainifest.xml`中作如下设置
```xml
<activity android:name=".AboutActivity"
            android:label="@string/about"
            android:theme="@style/Theme.AppCompat.Dialog" />
```
注意:若`Application`使用的是自定义theme  如:
```xml
<application
        android:name=".MApplication"
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/AppTheme">
```
应如此设置

若是自带theme则按此设置即可`android:theme="@android:style/Theme.Dialog"`

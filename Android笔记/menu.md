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
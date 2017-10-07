---
title: Android 常用控件
date: 2017-09-27
time: 14:41:05
categories: 
toc: true
tag: 
---
</p>

## TextView
```xml
<TextView
android:layout_width="53dp"
android:layout_height="30dp"
android:text="Hello World!"
app:layout_constraintBottom_toBottomOf="parent"
app:layout_constraintLeft_toLeftOf="parent"
app:layout_constraintRight_toRightOf="parent"
app:layout_constraintTop_toTopOf="parent"
app:layout_constraintHorizontal_bias="0.552"
app:layout_constraintVertical_bias="0.108"
android:layout_marginRight="8dp"
android:layout_marginLeft="8dp"
android:id="@+id/textView" />
```
## Button
```xml
<Button
android:id="@+id/button"
android:layout_width="wrap_content"
android:layout_height="wrap_content"
android:text="Begin"
android:layout_marginTop="8dp"
app:layout_constraintTop_toBottomOf="@+id/textView"
android:layout_marginBottom="8dp"
app:layout_constraintBottom_toTopOf="@+id/progressBar2"
app:layout_constraintLeft_toRightOf="@+id/progressBar"
android:layout_marginLeft="8dp"
android:layout_marginRight="8dp"
app:layout_constraintRight_toRightOf="parent"
app:layout_constraintHorizontal_bias="0.563"
app:layout_constraintVertical_bias="0.098" />
```
```java
Button button = (Button)findViewById(R.id.button);
button.setOnClickListener(new Button.OnClickListener(){
    public void onClick(View view){
        //点击动作
    }
}
```
## Toast
![浮动消息](.\img\浮动消息.png)
    浮动显示消息的控件
```java
Toast.makeText(MainActivity.this,"要显示的内容",Toast.LENGTH_SHORT).show();
```
## ProgressBar
![](.\img\进度条.png)
```java
ProgressBar secondBar = (ProgressBar)findViewById(R.id.progressBar2);//长条形进度条
//secondBar ProgressBar对象名
//设置为可见状态
secondBar.setVisibility(View.VISIBLE);
//设置进度条最大值
secondBar.setMax(200);
//设置进度条为不可见状态
secondBar.setVisibility(View.GONE);
```

## 单选按钮组
![单选按钮](.\img\单选按钮.PNG)
```java
//声明控件变量
private RadioGroup genderGroup = null
private RadioButton femaleButton = null;
private RadioButton maleButton = null;
...
//通过控件ID获取控件对象
genderGroup = (RadioGroup)findViewById(R.id.genderGroup);
femaleButton = (RadioButton)findViewById(R.id.femaleButton);
maleButton = (RadioButton)findViewById(R.id.maleButton);
...
//单选按钮组 共用一个监听代码块
genderGroup.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener(){

    @Override
    public void onCheckedChanged(RadioGroup radioGroup, @IdRes int i) {
        if (femaleButton.getId() == i){
            System.out.println("female");
            //浮动提示信息
            Toast.makeText(MainActivity.this,"您已选择性别-女",Toast.LENGTH_SHORT).show();
        }
        else if (maleButton.getId() == i){
            System.out.println("male");
            Toast.makeText(MainActivity.this,"您已选择性别-男",Toast.LENGTH_SHORT).show();
        }
    }
});
```

## 多选按钮
![多选按钮](.\img\多选按钮.png)
```java
//声明控件变量
private CheckBox swimBox = null;
private CheckBox runBox = null;
private CheckBox readBox = null;
 //通过控件ID获取控件对象
swimBox = (CheckBox)findViewById(R.id.swim);
runBox = (CheckBox)findViewById(R.id.run);
readBox = (CheckBox)findViewById(R.id.read);
//checkBox没有组 每个checkBox都需要单独的监听
swimBox.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener(){

    @Override
    public void onCheckedChanged(CompoundButton compoundButton, boolean b) {
        if (b)
            System.out.println("swim is checked");
        else
            System.out.println("swim is unchecked");
    }
});
runBox.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener(){

    @Override
    public void onCheckedChanged(CompoundButton compoundButton, boolean b) {
        if (b)
            System.out.println("run is checked");
        else
            System.out.println("run is unchecked");
    }
});
readBox.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener(){

    @Override
    public void onCheckedChanged(CompoundButton compoundButton, boolean b) {
        if (b)
            System.out.println("read is checked");
        else
            System.out.println("read is unchecked");
    }
});
```
---
title: Bean
date: 2017-12-05
time: 16:32:05
categories: 
toc: true
tag: 
---
</p>

# JavaBean
bean，保存数据的实体，通常与数据库中的表对应

也称为，pojo，entity，domain

javabean是数据的映射

## JavaBean 程序示例
这是StudentBean.java文件：
```java
package com.runoob;

public class StudentsBean implements java.io.Serializable
{
   private String firstName = null;
   private String lastName = null;
   private int age = 0;

   public StudentsBean() {
   }
   public String getFirstName(){
      return firstName;
   }
   public String getLastName(){
      return lastName;
   }
   public int getAge(){
      return age;
   }

   public void setFirstName(String firstName){
      this.firstName = firstName;
   }
   public void setLastName(String lastName){
      this.lastName = lastName;
   }
   public void setAge(int age) {
      this.age = age;
   }
}
```
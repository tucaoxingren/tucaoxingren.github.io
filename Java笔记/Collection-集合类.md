---
title: Collection-集合类
date: 2017-09-12
time: 16:41:05
categories: Java
toc: true
tag: collection
---
</p>

# Collection-集合类
## 集合类的由来：
对象用于封装特有数据，对象多了需要存储，如果对象的个数不确定。
就使用集合容器进行存储。
	
## 集合特点：
1.用于存储对象的容器。
2.集合的长度是可变的。
3.集合中不可以存储基本数据类型值。
> 
集合容器因为内部的数据结构不同，有多种具体容器。
不断的向上抽取，就形成了集合框架。

**框架的顶层Collection接口**

## Collection的常见方法：

### 1.添加。
	boolean add(Object obj):
	boolean addAll(Collection coll):	

### 2.删除。
	boolean remove(object obj):
	boolean removeAll(Collection coll);
	void clear();
	
### 3.判断：
	boolean contains(object obj):
	boolean containsAll(Colllection coll);
	boolean isEmpty():判断集合中是否有元素。 

### 4.获取：
	int size():
	Iterator iterator():取出元素的方式：迭代器。
	该对象必须依赖于具体容器，因为每一个容器的数据结构都不同。
	所以该迭代器对象是在容器中进行内部实现的。
	对于使用容器者而言，具体的实现不重要，只要通过容器获取到该实现的迭代器的对象即可，
	也就是iterator方法。
	
	Iterator接口就是对所有的Collection容器进行元素取出的公共接口。

### 5，其他：
	boolean retainAll(Collection coll);取交集。
	Object[] toArray():将集合转成数组。
	
## Collection
	|--List：有序(存入和取出的顺序一致),元素都有索引(角标)，元素可以重复。
	|--Set：元素不能重复,无序。

**List:特有的常见方法：有一个共性特点就是都可以操作角标。**
	
### 1.添加
	void add(index,element);
	void add(index,collection);

### 2.删除；
	Object remove(index):

### 3.修改：
	Object set(index,element);	

### 4.获取：
	Object get(index);
	int indexOf(object);
	int lastIndexOf(object);
	List subList(from,to);	
	
list集合是可以完成对元素的增删改查。

List:
	|--Vector:内部是数组数据结构，是同步的。增删，查询都很慢！
	|--ArrayList:内部是数组数据结构，是不同步的。替代了Vector。查询的速度快。
	|--LinkedList:内部是链表数据结构，是不同步的。增删元素的速度很快。
---
title: List遍历：for，foreach还是Iterator
date: 2017-10-09
time: 21:07:05
categories: java
toc: true
tag: list
---
</p>

转载自http://blog.csdn.net/nazir2513/article/details/51168345

# List遍历：for，foreach还是Iterator

## 先说现象： 
如果是ArrayList，用三种方式遍历的速度是for>Iterator>foreach，但基本上属于同一个速度级别； 
如果是LinkedList，则三种方式遍历的差距很大了，用for遍历的效率远远落后于foreach和Iterator，Iterator>foreach>>>for； 
模拟50000条数据，放入ArrayList和LinkedList，对两个List分别用三种方式进行遍历，耗时如下图所示： 
这里写图片描述 
## 究其原因： 
**1：**首先发现foreach和Iterator基本上都在一个速度级别，但Iterator会稍稍快于foreach，事实上，foreach就是基于Iterator实现的。也就是说下面两段代码效果是一样的：
```java
// foreach
for(Object obj : list){  
    System.out.println(obj);  
}

// Iterator
Iterator<Object> iterator = list.iterator();  
while(iterator.hasNext()){  
    Object obj = iterator.next();  
    System.out.println(obj);  
}  
```

所以foreach和Iterator基本是效率相当的，但foreach比Iterator慢的时间我猜测就是foreach隐式转换成Iterator所消耗的时间，所以接下去我们就撇开foreach了不谈了

**2：**接下来要解释的是为什么ArrayList的遍历中for比Iterator快，而LinkedList中却是Iterator远快于for？这得从ArrayList和LinkedList两者的数据结构说起了： 
ArrayList是基于索引(index)的数组，索引在数组中搜索和读取数据的时间复杂度是O(1)，但是要增加和删除数据却是开销很大的，因为这需要重排数组中的所有数据。 
LinkedList的底层实现则是一个双向循环带头节点的链表，因此LinkedList中插入或删除的时间复杂度仅为O(1)，但是获取数据的时间复杂度却是O(n)。 
明白了两种List的区别之后，就知道，ArrayList用for循环随机读取的速度是很快的，因为ArrayList的下标是明确的，读取一个数据的时间复杂度仅为O(1)。但LinkedList若是用for来遍历效率很低，读取一个数据的时间复杂度就达到了为O(n)。而用Iterator的next()则是顺着链表节点顺序读取数据的效率就很高了。

## 最后总结： 
1：ArrayList用三种遍历方式都差得不算太多，一般都会用for或者foreach，因为Iterator写法相对复杂一些。当然在三种都能实现的情况下，具体用那种方式，原则就是：看你的心情。。。 
2：LinkedList的话，我会毫无疑问用foreach或者Iterator。 
3：有理解不到位的，欢迎请指正！


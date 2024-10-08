## 问题发现

同事反馈一个接口多次请求，入参完全一致的情况下，输出的数据条数不一致，输出数据为一个list，且本地开发环境无法复现。



## 问题分析

1. 检查接口输入是否因前端bug携带了`pageNum`、`pageSize`等参数，无此情况

2. 通过使用抓包工具`ProxyPin` 重放问题接口20次，发现确实是接口输出数据有问题，排除前端原因。

3. 分析后端代码，此接口为一个普通查询接口，无分页

4. 分析后端日志，发现此接口偶尔会被拼接分页参数

5. 基于上一点，猜测是`mybatis`缓存机制问题，导致有分页的接口的分页参数被共享给了无分页的接口

   1. > [Mybatis-PageHelper为什么使用PageHelper后面一定要跟一次查询？_pagehelper作用于下一个查询码-CSDN博客](https://blog.csdn.net/qq_34988304/article/details/90030134)

6. 基于上一点，检查代码，发现有个接口A，手动调用了`PageHelper.startPage`方法，进行手动分页，没有使用`mybatis`的分页实现，且执行完`PageHelper.startPage`方法后没有手动调用`PageHelper.clearPage`方法，导致此问题的出现。也解释了为什么本地开发环境无法复现，A接口手动调用了`PageHelper.startPage`方法，触发了此bug，但本地复现时，没有触发A接口，因此无法在本地复现此bug，在本地复现时手动触发A接口，100%触发此bug。
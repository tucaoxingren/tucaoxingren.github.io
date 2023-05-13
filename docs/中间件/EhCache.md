## 配置说明



### 3.8.x

ehcache.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<config xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'
        xmlns='http://www.ehcache.org/v3'
        xsi:schemaLocation="http://www.ehcache.org/v3 http://www.ehcache.org/schema/ehcache-core.xsd">
    
    <!-- 1分钟后自动过期的模板示例 -->
    <cache-template name="expire1mTemplate">
        <key-type>java.lang.String</key-type>
        <value-type>java.lang.Object</value-type>
        <expiry>
            <ttl unit="minutes">1</ttl>
        </expiry>
        <resources>
            <heap>200000</heap>
            <offheap unit="MB">10</offheap>
        </resources>
    </cache-template>

    <!-- 默认缓存模板 永不过期 -->
    <cache-template name="cacheTemplate">
        <!-- 缓存key的类型 -->
        <key-type>java.lang.String</key-type>
        <!-- 缓存value的类型 建议覆盖 -->
        <value-type>java.lang.Object</value-type>
        <resources>
            <!-- 三种策略可以混合在一起使用。读取速度对比： heap > off-heap > disk -->
            <!-- heap满后 存储到 offheap;offheap 需要序列化与反序列化 -->
            <!--配置堆储存 单位缺省时 代指N个缓存-->
            <heap unit="MB">10</heap>
            <!-- 配置堆外储存，堆外存储容量必须大于堆存储容量 -->
            <offheap unit="MB">20</offheap>
            <!--配置磁盘持久化储存，persistent=是否启用磁盘缓存，默认为false-->
            <!--            <disk unit="MB" persistent="false">500</disk>-->
        </resources>
    </cache-template>

    <cache alias="demo1" uses-template="cacheTemplate">
        <value-type>com.yinhai.dsmp.comm.db.entity.AcssSysBDO</value-type>
    </cache>
</config>

```


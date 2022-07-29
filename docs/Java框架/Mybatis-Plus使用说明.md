## update

### 自动填充不生效

```java
UpdateWrapper<FixmedinsInfoBDO> updateWrapper = new UpdateWrapper<>();
updateWrapper.eq("FIXMEDINS_INFO_ID", "KM53429153");
updateWrapper.set("MEMO", "");
updateWrapper.set("ENDDATE", "");
fixmedinsInfoBService.update(updateWrapper);
// 应改成下面的实现
fixmedinsInfoBService.update(new FixmedinsInfoBDO(), updateWrapper);
```

配置了全库都有例如更新时间字段的数据应禁止使用`update(Wrapper<T> updateWrapper)`



### 空值更新情况示例

1. 使用entity更新时使用默认字段验证策略 `FieldStrategy.DEFAULT` 
2. 更新null 不生效
3. 字符型更新“” 空字符串 生效
4. 解决方案
   1. 设置全局或单个字段字段验证策略 `FieldStrategy.IGNORED` 不合适 容易误更新
   1. 使用Wrapper更新
   1. 使用`com.baomidou.mybatisplus.extension.injector.methods.AlwaysUpdateSomeColumnById` 更新

```java
// 以下代码使用默认字段验证策略 FieldStrategy.DEFAULT

// 1. update(Wrapper<T> updateWrapper)
updateWrapper = new UpdateWrapper<>();
updateWrapper.eq("FIXMEDINS_INFO_ID", "KM53429153");
updateWrapper.set("ENDDATE", null);
fixmedinsInfoBService.update(updateWrapper);// 抛出异常 参考 Oracle数据库配置jdbcTypeForNull

// 2. updateById(T entity)
DataDicADO updateDictDO = new DataDicADO();
updateDictDO.setDataDicId("530101000000000086");
updateDictDO.setSeq(null);// 数值型 不更新
updateDictDO.setEnddate(null);// 日期型 不更新
updateDictDO.setMemo(null);// 字符型 不更新
updateDictDO.setMemo("");// 字符型 更新
dataDicAService.updateById(updateDictDO);
```



### Oracle数据库配置jdbcTypeForNull

mybatis-config.xml

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration PUBLIC "-//mybatis.org//DTD Config 3.0//EN" "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
    <settings>
        <setting name="cacheEnabled" value="false"/>
        <setting name="localCacheScope" value="STATEMENT"/>
        <!-- java 传入 null时 jdbcType 设置为NULL -->
        <setting name="jdbcTypeForNull" value="NULL"/>
    </settings>
</configuration>

```





## select

1. 针对空字符串作为查询条件 绝大部分业务场景是不需要的 解决办法
   1. 全局配置修改 参考[使用配置 | MyBatis-Plus (baomidou.com)](https://baomidou.com/pages/56bac0/#基本配置)
   2. 全局配置修改ta404 5.3.2版本不支持
   3. 针对上一条 新建配置类`implements ApplicationListener<ContextRefreshedEvent>` 获取Mybatis-Plus的GlobalConfig`GlobalConfig globalConfig = GlobalConfigUtils.getGlobalConfig(                applicationContext.getBean(datasource + "SqlSessionFactory", SqlSessionFactory.class).getConfiguration());`  ta404 5.3.2版本 虽然修改成功 但依旧不生效
   4. 针对上两条 ta404 5.3.2版本 可以采用修改 DO `whereStrategy` 策略的方式
2. 确实需要使用空字符串查询的 请使用`queryWrapper.eq(true, "FIXMEDINS_INFO_ID", "");`

### 空值查询

#### 默认字段验证策略 FieldStrategy.DEFAULT

```java
// null 查询
QueryWrapper<FixmedinsInfoBDO> queryWrapper = new QueryWrapper<>();
List<FixmedinsInfoBDO> list = new ArrayList<>();
queryWrapper.eq("FIXMEDINS_INFO_ID", "KM53429153");
queryWrapper.eq("FIXMEDINS_CODE", null);// 抛出异常
list = fixmedinsInfoBService.list(queryWrapper);

queryWrapper.eq("FIXMEDINS_INFO_ID", "KM53429153");
queryWrapper.eq(StingUtils.isNotEmpty(""), "", "FIXMEDINS_CODE", "");
list = fixmedinsInfoBService.list(queryWrapper);// list.size() = 1

// 空字符串查询
QueryWrapper<FixmedinsInfoBDO> queryWrapper = new QueryWrapper<>();
List<FixmedinsInfoBDO> list = new ArrayList<>();
queryWrapper.eq("FIXMEDINS_INFO_ID", "KM53429153");
queryWrapper.eq("FIXMEDINS_CODE", "");// 查询结果错误 正确结果list.size()=1 实际是list.size()=0
list = fixmedinsInfoBService.list(queryWrapper);

queryWrapper = new QueryWrapper<>();
queryDO.setFixmedinsInfoId("KM53429153");
queryDO.setFixmedinsCode("");
queryWrapper.setEntity(queryDO);
list = fixmedinsInfoBService.list(queryWrapper);// list.size() = 0

```



#### 字段验证策略 FieldStrategy.NOT_EMPTY

```java
QueryWrapper<FixmedinsInfoBDO> queryWrapper = new QueryWrapper<>();
LambdaQueryWrapper<FixmedinsInfoBDO> lambdaQueryWrapper = new LambdaQueryWrapper<>();
List<FixmedinsInfoBDO> list = new ArrayList<>();
FixmedinsInfoBDO queryDO = new FixmedinsInfoBDO();

queryWrapper.eq("FIXMEDINS_INFO_ID", "KM53429153");
queryWrapper.eq("FIXMEDINS_CODE", "");
list = fixmedinsInfoBService.list(queryWrapper);// list.size() = 0

queryWrapper.eq("FIXMEDINS_INFO_ID", "KM53429153");
queryWrapper.eq(StingUtils.isNotEmpty(""), "", "FIXMEDINS_CODE", "");
list = fixmedinsInfoBService.list(queryWrapper);// list.size() = 1

lambdaQueryWrapper.eq(FixmedinsInfoBDO::getFixmedinsInfoId, "KM53429153");
lambdaQueryWrapper.eq(FixmedinsInfoBDO::getFixmedinsCode, "");
list = fixmedinsInfoBService.list(lambdaQueryWrapper);// list.size() = 0

queryWrapper = new QueryWrapper<>();
queryDO.setFixmedinsInfoId("KM53429153");
queryDO.setFixmedinsCode("");
queryWrapper.setEntity(queryDO);
list = fixmedinsInfoBService.list(queryWrapper);// list.size() = 1
```


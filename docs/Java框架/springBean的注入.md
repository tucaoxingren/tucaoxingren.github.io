## 配置文件方式配置

```xml
<bean id="demoBean" parent="transactionProxy">
        <property name="target">
            <bean class="com.demo.DemoBean" parent="bpo">
                <!-- 依赖bean -->
                <property name="dependencyBean" ref="dependencyBean"></property>
            </bean>
        </property>
    </bean>
```

```java
private DependencyBean dependencyBean;
public void setDemoDean(DependencyBean dependencyBean){
    this.dependencyBean = dependencyBean;
}
```

## 注解配置

```xml
<bean id="demoBean" parent="transactionProxy">
        <property name="target">
            <bean class="com.demo.DemoBean" parent="bpo"></bean>
        </property>
    </bean>
```

```java
@Autowired
private DependencyBean dependencyBean;
```

**注解配置 与 配置文件方式 不能同时存在**

## @Autowired 与 @Resource

基本相同

@Autowired 按类型注入

@Resource 默认按名称注入 也可以按类型注入

Spring将@Resource注解的name属性解析为bean的名字，而type属性则解析为bean的类型

### @Resource装配顺序
1. 如果同时指定了name和type，则从Spring上下文中找到唯一匹配的bean进行装配，找不到则抛出异常

2. 如果指定了name，则从上下文中查找名称（id）匹配的bean进行装配，找不到则抛出异常

3. 如果指定了type，则从上下文中找到类型匹配的唯一bean进行装配，找不到或者找到多个，都会抛出异常

4. 如果既没有指定name，又没有指定type，则自动按照byName方式进行装配；如果没有匹配，则回退为一个原始类型进行匹配，如果匹配则自动装配；

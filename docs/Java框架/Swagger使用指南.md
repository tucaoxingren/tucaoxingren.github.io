## 注解介绍

[swagger注释API详细说明 - 寒植 - 博客园 (cnblogs.com)](https://www.cnblogs.com/hanzhi/articles/8638397.html)

### @ApiImplicitParam

| 属性         | 取值   | 作用                                          |
| ------------ | ------ | --------------------------------------------- |
| paramType    |        | 查询参数类型                                  |
|              | path   | 以地址的形式提交数据                          |
|              | query  | 直接跟参数完成自动映射赋值                    |
|              | body   | 以流的形式提交 仅支持POST                     |
|              | header | 参数在request headers 里边提交                |
|              | form   | 以form表单的形式提交 仅支持POST               |
| dataType     |        | 参数的数据类型 只作为标志说明，并没有实际验证 |
|              | Long   |                                               |
|              | String |                                               |
| name         |        | 接收参数名                                    |
| value        |        | 接收参数的意义描述                            |
| required     |        | 参数是否必填                                  |
|              | true   | 必填                                          |
|              | false  | 非必填                                        |
| defaultValue |        | 默认值                                        |



## 错误解决

### Could not resolve pointer: /definitions/String does not exist in document

Resolver error at paths./tasks/detail.post.parameters.0.schema.$ref
Could not resolve reference because of: Could not resolve pointer: /definitions/String does not exist in document



`dataType` `String` 改为`string`
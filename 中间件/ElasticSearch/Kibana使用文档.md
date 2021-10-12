## 身份验证

kibana本身无身份验证 依托于elasticsearch的验证

## 导入导出对象

设置->Kibana->已保存对象

## 配置说明

1. `server.basePath: "/kibana" `配置context 默认无 注意配置此项后必须配置`server.rewriteBasePath: true`
2. `i18n.locale: "zh-CN"` 修改语言为中文



## 问题记录

### 生命周期错误

[(21条消息) 【Kibana】索引生命周期策略错误illegal_argument_exception: index.lifecycle.rollover_alias does not point to index_明天的地平线-CSDN博客](https://blog.csdn.net/husong_/article/details/114012199)

### 新增索引模板

```shell
PUT _template/delete-30-days
{
  "order": 1,
  "index_patterns": ["kmltci-api-*"]
}
```






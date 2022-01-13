## 记录执行日志与存储日志到oracle数据库问题
指定记录日志到数据库 在job的配置中添加属性`event-trace-rdb-data-source='数据源名'`
### 提示无效的字符
因为elastic-job开发时以mysql/h2作为日志记录的数据库 所以sql语法不适用于Oracle数据库

解决方案:
修改`com.dangdang.ddframe.job.event.rdb.JobEventRdbStorage.java` 将建表语句与insert语句等修改为Oracle数据库支持的语法 去掉`与;即可

### insert JOB_STATUS_TRACE_LOG 失败
`JOB_STATUS_TRACE_LOG`表 字段`original_task_id`仅在`elastic-job-cloud`版使用 但由于 `elastic-job-lite`与`elastic-job-cloud`共同使用同一份核心api即源码中的`elastic-job-common`,在`JobEventRdbStorage.createJobStatusTraceTable()`方法中建立`JOB_STATUS_TRACE_LOG`表的语句字段`original_task_id`为非空,在lite版中对此值赋值为空字符,在mysql数据库中空字符串可以被赋值给`not null`的字段,但在Oracle数据库中空字符串不能赋值给`not null`的字段.

解决方案:可以将`JOB_STATUS_TRACE_LOG`表的建表语句中`original_task_id`设置为可以为null
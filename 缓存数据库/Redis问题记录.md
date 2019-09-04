## MISCONF Redis is configured to save RDB snapshots
问题详细报错信息
> MISCONF Redis is configured to save RDB snapshots, but is currently not able to persist on disk. Commands that may modify the data set are disabled. Please check Redis logs for details about the error

中文描述
> Redis被配置为保存数据库快照，但它目前不能持久化到硬盘。用来修改集合数据的命令不能用。请查看Redis日志的详细错误信息。

解决办法

在redis-cli中执行`config set stop-writes-on-bgsave-error no`
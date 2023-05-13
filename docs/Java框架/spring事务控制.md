## spring Transaction 事务控制

### TransactionSynchronizationManager
是否开启事务
`TransactionSynchronizationManager.isActualTransactionActive()`

是否只读事务

`TransactionSynchronizationManager.isCurrentTransactionReadOnly()`

获取当前方法事务级别
`TransactionSynchronizationManager.getCurrentTransactionIsolationLevel()`

获取当前方法事务名称
`TransactionSynchronizationManager.getCurrentTransactionName()`



### TransactionInterceptor

事务切面


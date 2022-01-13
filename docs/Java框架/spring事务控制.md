## spring Transaction 事务控制

### TransactionSynchronizationManager
检测当前方法是否开启了事务
`TransactionSynchronizationManager.isActualTransactionActive()`
获取当前方法事务级别
`TransactionSynchronizationManager.getCurrentTransactionIsolationLevel()`
获取当前方法事务名称
`TransactionSynchronizationManager.getCurrentTransactionName()`
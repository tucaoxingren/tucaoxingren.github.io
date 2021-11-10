select sess.sid,
    sess.serial#,
    lo.oracle_username,
    lo.os_user_name,
    ao.object_name,
    lo.locked_mode
    from v$locked_object lo,
    dba_objects ao,
    v$session sess
where ao.object_id = lo.object_id and lo.session_id = sess.sid;

--alter system kill session 'sid,serial#';
alter system kill session '237,18829';

/*

Oracle进程无法KILL处理方案：

出处：

1.oracle提供的所类型可以根据v$lock_type 中的type来查询,我们平时接触的最多的是两种

Oracle进程被KILL之后，状态被置为"KILLED"，但是锁定的资源长时间不释放，会出现类似下面这样的错误提示：

ORA-00030: User session ID does not exist

或

ORA-00031: session marked for kill

以往大多都是通过重启数据库的方式来强行释放锁资源。
现提供另一种方式解决该问题，在ORACLE中KILL不掉，在OS系统中再杀，操作方式如下：

1.下面的语句用来查询哪些对象被锁：
select object_name,machine,s.sid,s.serial# from v$locked_object l,dba_objects o ,v$session s where l.object_id　=　o.object_id and l.session_id=s.sid;
2.下面的语句用来杀死一个进程：
alter system kill session '42,21993';
3在os一级再杀死相应的进程（线程），首先执行下面的语句获得进程（线程）号：
select spid, osuser, s.program from v$session s,v$process p where s.paddr=p.addr and s.sid=24 （24是上面的sid）
4.在OS上杀死这个进程（线程）：
1)在unix上，用root身份执行命令:
#kill -9 12345（即第3步查询出的spid）
2)在windows（unix也适用）用orakill杀死线程，orakill是oracle提供的一个可执行命令，语法为：
orakill sid thread
sid：表示要杀死的进程属于的实例名
thread：是要杀掉的线程号，即第3步查询出的spid。

*/

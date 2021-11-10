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

Oracle�����޷�KILL��������

������

1.oracle�ṩ�������Ϳ��Ը���v$lock_type �е�type����ѯ,����ƽʱ�Ӵ�������������

Oracle���̱�KILL֮��״̬����Ϊ"KILLED"��������������Դ��ʱ�䲻�ͷţ�������������������Ĵ�����ʾ��

ORA-00030: User session ID does not exist

��

ORA-00031: session marked for kill

������඼��ͨ���������ݿ�ķ�ʽ��ǿ���ͷ�����Դ��
���ṩ��һ�ַ�ʽ��������⣬��ORACLE��KILL��������OSϵͳ����ɱ��������ʽ���£�

1.��������������ѯ��Щ��������
select object_name,machine,s.sid,s.serial# from v$locked_object l,dba_objects o ,v$session s where l.object_id��=��o.object_id and l.session_id=s.sid;
2.������������ɱ��һ�����̣�
alter system kill session '42,21993';
3��osһ����ɱ����Ӧ�Ľ��̣��̣߳�������ִ�����������ý��̣��̣߳��ţ�
select spid, osuser, s.program from v$session s,v$process p where s.paddr=p.addr and s.sid=24 ��24�������sid��
4.��OS��ɱ��������̣��̣߳���
1)��unix�ϣ���root���ִ������:
#kill -9 12345������3����ѯ����spid��
2)��windows��unixҲ���ã���orakillɱ���̣߳�orakill��oracle�ṩ��һ����ִ������﷨Ϊ��
orakill sid thread
sid����ʾҪɱ���Ľ������ڵ�ʵ����
thread����Ҫɱ�����̺߳ţ�����3����ѯ����spid��

*/

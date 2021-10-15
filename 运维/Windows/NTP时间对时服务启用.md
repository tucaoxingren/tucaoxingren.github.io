## Windows NTP 服务器配置及开启

在不通公网的服务器中可以选择一台服务器作为标准时间 其它服务器向此服务器对时

1. 运行 `regedit`打开注册表
2. `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\Parameters`
`Type` 设定值修改为 `NTP`
3. `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\Config`
`AnnounceFlags `设定值修改为 `5`
4. `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NtpServer `
`Enabled` 设定值修改为 `1`
5. 重启Windows Time服务 `net stop w32time && net start w32time`
6. 开放防火墙`123`端口 类型为UDP
6. 将其它服务器的同步时钟服务器改为当前机器的ip


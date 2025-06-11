## 使用手册

[Git使用手册](/docs/版本控制/Git/git文档.pdf ':ignore')



[git 常用命令详解_51CTO博客_git常用命令](https://blog.51cto.com/JackieLion/6174807)



## commit规范

> [Commit message 和 Change log 编写指南 - 阮一峰的网络日志 (ruanyifeng.com)](https://www.ruanyifeng.com/blog/2016/01/commit_message_change_log.html)



## Git使用前准备

1. 下载git客户端

   1. [git-for-windows_v2.43.0](https://jaist.dl.sourceforge.net/project/git-for-windows.mirror/v2.43.0.windows.1/Git-2.43.0-64-bit.exe)
   2. [Git - Downloads (git-scm.com)](https://git-scm.com/downloads)

2. 设置`user.name`与`user.emali`

   ```bash
   # --global 代表全局设置 没有此选项时只能在项目根目录下执行，即为当前项目指定
   git config --global user.name 姓名（公司项目请使用GitLab账号的昵称即自己的名字）
   git config --global user.email 邮箱地址（公司项目请使用公司邮箱，必须设置正确，否则Gitlab提交记录的作者信息将无法正确关联）
   ```

   

## 公司Git项目commit规范

1. 禁止直接向`master`、`dev`分支`push`，已设置保护，除管理员外禁止`push`

2. 新建个人分支，分支名称可以是开发者姓名或需求简述，新建分支有如下方法

   1. 在云效平台->代码托管->分支->新建分支，最后在本地`pull`刚才新建的分支

   2. 在`GitLab`平台->新建分支，最后在本地`pull`刚才新建的分支

   3. 在本地创建分支，然后push到远程（不推荐）

      ```bash
      # 创建分支
      git checkout -b 分支名称
      # commit
      # 推送分支
      git push --set-upstream 远程git仓库标签 分支名称
      ```

3. 切换到个人分支

   1. 本地创建分支，`push`到远程时，创建分支后已默认切换到个人分支

   2. 远程创建分支，`pull`到本地后，需要手工切换分支`git checkout 远程git仓库标签 分支名称`

4. 在个人分支`commit`并`push`到远程git仓库

5. 新建合并请求，注意合并请求只能选择dev分支

   1. 在云效平台->代码托管->合并请求->新建合并请求
   2. 在`GitLab`平台->合并请求->新建合并请求

6. 合并请求遇到冲突时参考[gitlab 合并分支，解决冲突(实用)_gitlab合并冲突怎么解决-CSDN博客](https://blog.csdn.net/m0_67841039/article/details/127044584)

6. 由对应开发人员审核合并到`dev`分支的合并请求

7. 由管理员发起合并到`master`分支的合并请求

## Git 配置

### 代理配置

开启了梯子，但是仍旧无法访问`Github`时，可以手动设置下代理

```bash
# 使用socks5代理的 例如ss，ssr
git config --global http.proxy socks5 127.0.0.1:7890
git config --global https.proxy socks5 127.0.0.1:7890
# 使用http代理的 例如Clash
git config --global http.proxy 127.0.0.1:7890
git config --global https.proxy 127.0.0.1:7890
# 只针对Github开启全局代理
git config --global http.https://github.com.proxy http://127.0.0.1:7890
git config --global https.https://github.com.proxy https://127.0.0.1:7890
#取消github代理
git config --global --unset http.https://github.com.proxy
git config --global --unset https.https://github.com.proxy
#取消全局代理
git config --global --unset http.proxy
git config --global --unset https.proxy
```
---
title: Linux 备份与恢复
data: 2017-09-12
categories: Linux
toc: true
tag: Linux 备份与恢复
---
</p>

## tar备份与恢复linux

  在使用Ubuntu之前，相信很多人都有过使用Windows系统的经历。如果你备份过Windows系统，那么你一定记忆犹新：首先需要找到一个备份工 具(通常都是私有软件)，然后重启电脑进入备份工具提供的软件环境，在这里备份或者恢复Windows系统。Norton Ghost是备份Windows系统时经常使用的备份工具。

在备份Windows系统的时候你可能想过，我能不能把整个C盘都放到一个ZIP文件里去呢。这在Windows下是不可能的，因为在Windows中有 很多文件在它们运行时是不允许拷贝或覆盖的，因此你需要专门的备份工具对Windows系统进行特殊处理。

和备份Windows系统不同，如果你要备份Ubuntu系统(或者其它任何Linux系统)，你不再需要像Ghost这类备份工具。事实上，Ghost 这类备份工具对于Linux文件系统的支持很糟糕，例如一些Ghost版本只能完善地支持Ext2文件系统，如果你用它来备份Ext3文件系统，你可能会 丢失一些宝贵的数据。

### 1. 备份系统

我该如何备份我的Ubuntu系统呢？很简单，就像你备份或压缩其它东西一样，使用TAR。和Windows不同，Linux不会限制root访问任何东 西，你可以把分区上的所有东西都扔到一个TAR文件里去！

首先成为root用户：
`$ sudo su`

然后进入文件系统的根目录(当然，如果你不想备份整个文件系统，你也可以进入你想要备份的目录，包括远程目录或者移动硬盘上的目录)：
`# cd /`

下面是我用来备份系统的完整命令：
`# tar cvpzf backup.tgz –exclude=/proc –exclude=/lost+found –exclude=/backup.tgz –exclude=/mnt –exclude=/sys /`

让我们来简单看一下这个命令：

“tar”当然就是我们备份系统所使用的程序了。

“cvpfz”是tar的选项，意思是“创建档案文件”、“保持权限”(保留所有东西原来的权限)、“使用gzip来减小文件尺寸”。

“backup.gz”是我们将要得到的档案文件的文件名。

“/”是我们要备份的目录，在这里是整个文件系统。

在档案文件名“backup.gz”和要备份的目录名“/”之间给出了备份时必须排除在外的目录。有些目录是无用的，例如“/proc”、“/lost+ found”、“/sys”。当然，“backup.gz”这个档案文件本身必须排除在外，否则你可能会得到一些超出常理的结果。如果不把“/mnt”排 除在外，那么挂载在“/mnt”上的其它分区也会被备份。另外需要确认一下“/media”上没有挂载任何东西(例如光盘、移动硬盘)，如果有挂载东西， 必须把“/media”也排除在外。

有人可能会建议你把“/dev”目录排除在外，但是我认为这样做很不妥，具体原因这里就不讨论了。

执行备份命令之前请再确认一下你所键入的命令是不是你想要的。执行备份命令可能需要一段不短的时间。

备份完成后，在文件系统的根目录将生成一个名为“backup.tgz”的文件，它的尺寸有可能非常大。现在你可以把它烧录到DVD上或者放到你认为安全 的地方去。

在备份命令结束时你可能会看到这样一个提示：’tar: Error exit delayed from previous errors’，多数情况下你可以忽略它。

你还可以用Bzip2来压缩文件，Bzip2比gzip的压缩率高，但是速度慢一些。如果压缩率对你来说很重要，那么你应该使用Bzip2，用“j”代替 命令中的“z”，并且给档案文件一个正确的扩展名“bz2”。完整的命令如下：
/*
`# tar cvpjf backup.tar.bz2 –exclude=/proc –exclude=/lost+found –exclude=/backup.tar.bz2 –exclude=/mnt –exclude=/sys /`
*/
```bash
tar cvpjf backup.tar.bz2 –exclude=/proc –exclude=/lost+found –exclude=/backup.tar.bz2 –exclude=/mnt –exclude=/sys –exclude=/media –exclude=/home/laoke/下载  –exclude=/home/laoke/program media/laoke/文档/备份/debian/tarDebian
```

### 2. 恢复系统

在进行恢复系统的操作时一定要小心！如果你不清楚自己在做什么，那么你有可能把重要的数据弄丢，请务必小心！

接着上面的例子。切换到root用户，并把文件“backup.tgz”拷贝到分区的根目录下。

在 Linux中有一件很美妙的事情，就是你可以在一个运行的系统中恢复系统，而不需要用boot-cd来专门引导。当然，如果你的系统已经挂掉不能启动了， 你可以用Live CD来启动，效果是一样的。你还可以用一个命令把Linux系统中的所有文件干掉，当然在这里我不打算给出这个命令！

使用下面的命令来恢复系统：
`# tar xvpfz backup.tgz -C /`

如果你的档案文件是使用Bzip2压缩的，应该用：
`# tar xvpfj backup.tar.bz2 -C /`

注意：上面的命令会用档案文件中的文件覆盖分区上的所有文件。

执行恢复命令之前请再确认一下你所键入的命令是不是你想要的，执行恢复命令可能需要一段不短的时间。

恢复命令结束时，你的工作还没完成，别忘了重新创建那些在备份时被排除在外的目录：
```bash
# mkdir proc
# mkdir lost+found
# mkdir mnt
# mkdir sys
```
等等

当你重启电脑，你会发现一切东西恢复到你创建备份时的样子了！

本仓库除了 syzoj 相关文件外均以 MIT 协议发布，syzoj 相关文件的许可证见压缩包内。

本教程仅在 Ubuntu 18.04 LTS 上测试通过，可能适用其它 Linux 发行版，但**不支持** Windows 系统。如果使用 Windows，请使用虚拟机。
# 准备
```
sudo apt-get install curl ruby ruby-2.5-dev libmysqlclient-dev
gem install mysql2
```

# 抓取
新建一个目录用于存放抓取的相关文件。首先执行 `get.sh` 抓取题面。该操作将会在当前文件夹下生成形如 xxxx.html 的文件，其中 xxxx 为题号。可能会有部分文件下载失败，重新执行 `get.sh` 即可，不会重复下载已经下载完成的文件。**下载后请重新执行 get.sh，确保所有题目都抓到，没有抓到的题目将不会被导入。**

然后执行 `process.rb` 解析题面。会生成两个文件，分别是 `syzoj.sql` 和 `download_all.sh`，分别是用于导入数据库的题库文件和资源文件下载器。

由于太懒，我没有对 URL 进行检查，所以理论上 `download_all.sh` 可能会出现恶意代码。需要手动检查 `download_all.sh`，确保没有语法错误和不合法的代码，然后执行 `bash download_all.sh`。脚本会生成一个 JudgeOnline 目录，并自动下载所有的图片等文件。这样抓取就完成了。

# 部署
需要安装 docker 和 docker-compose。请前往 <https://github.com/hewenyang/syzoj-docker> 下载 SYZOJ Docker 版，参考目录内的 README.md 进行部署，需要做出以下修改：
* 从 <https://github.com/hewenyang/judge-v3> 的 hustoj-like 分支重新打包为 judge-v3.tar.xz 并放入 syzoj-docker 目录中。打包以 git 仓库为根目录。该版本的 SYZOJ 在没有 data.yml 的情况下默认使用“min”方式测评，并且时限指的是整个子任务的总时限。

本章只介绍部署后导入题目的方法。

在导入之前，请在系统里创建至少一个账号。第一个账号将成为所有题目的所有者。不创建账号会导致导入失败。
将刚才生成的 syzoj.sql 复制到容器中：
`docker cp syzoj.sql build_web_1:/root/`

然后导入：输入`docker exec -it build_web_1 /bin/bash`进入容器环境
```
mysql -hmysql -uroot -proot
set global max_allowed_packet=1024*1024*16
exit

mysql -hmysql -usyzoj -psyzoj syzoj < syzoj.sql
```
如果一切顺利，那么应该可以看到所有题目的题面了。

接下来导入图片文件：
```
docker cp JudgeOnline /var/syzoj/syzoj/static/
```

将数据文件拷贝到部署时指定的目录即可。

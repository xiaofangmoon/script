##  vhost.sh
### 说明
1. 动态的添加host 记录，并且添加nginx配置文件到 `/usr/local/etc/nginx` 目录
2. hosts.txt : host文件
### 使用
1. ./vhost.sh ： 按照提示操作就行
##  mhost.sh 
1. 因为要和前端很多人员联调，每个人的开发机地址不一样，需要动态的切换，所以写的一个简单的脚本
### 用法
1. ./mhosts.sh 行号 : 先把hosts.txt 覆盖hosts文件，然后取出 hosts-front.txt 指定行的内容，输出到host文件里面
2. 

tips : `hosts.txt` 作为一个备份

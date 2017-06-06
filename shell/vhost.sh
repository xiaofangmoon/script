#!/bin/bash
# Author:  xiaofang
# Project home page:

clear
printf "
#######################################################################
#       edit by xiaofang     #
#       operate host       #
#######################################################################
"
# 变量
. /Users/xiaofang/bin/vhost-option.conf

## 输出变量
echo '配置文件所在路径：'$nginx_conf_path
echo '默认wwww目录：'$wwwroot_dir
echo '当前用户:' $run_user

while :
do
    echo
    read -p "Please input domain(example: www.linuxeye.com): " domain
    if [ -z "`echo $domain | grep '.*\..*'`" ]; then
        echo "${CWARNING}input error! "
    else
        break
    fi
done

## 判断配置文件是否存在
if [ -e "${nginx_conf_path}/vhost/$domain.conf"  ]; then
    echo "${domain} 该配置文件已经存在"
    exit
else
    echo "domain=$domain"
fi


## 需不需要添加第二个域名
while :
do
    echo
    read -p "Do you want to add more domain name? [y/n]: " moredomainame_yn
    if [[ ! $moredomainame_yn =~ ^[y,n]$ ]];then
        echo "input error! Please only input 'y' or 'n'"
    else
        break
    fi
done

if [ "$moredomainame_yn" == 'y' ]; then
    while :
    do
        echo
        read -p "Type domainname or IP(example: linuxeye.com 121.43.8.8): " moredomain
        if [ -z "`echo $moredomain | grep '.*\..*'`" ]; then
            echo "input error! "
        else
            [ "$moredomain" == "$domain" ] && echo "Domain name already exists! " && continue
            echo domain list="$moredomain"
            moredomainame=" $moredomain"
            break
        fi
    done
fi

## 设置目录
while :
do
    echo
    echo "Please input the directory for the domain:$domain :"
    read -p "(请输入目录: ): " vhostdir
    if [ -n "$vhostdir" -a -z "`echo $vhostdir | grep '^/'`" ];then
        echo "input error! Press Enter to continue..."
    else
        if [ -z "$vhostdir" ]; then
            echo $vhostdir
            vhostdir="$wwwroot_dir/$domain"
            echo "Virtual Host Directory=$vhostdir"
            echo
            echo "Create Virtul Host directory......"
            mkdir -p $vhostdir
            echo "set permissions of Virtual Host directory......"
            chown -R ${run_user}.$run_user $vhostdir
        fi
        break
    fi
done



Create_nginx_php-fpm_conf() {
[ ! -d $nginx_conf_path/vhost ] && mkdir $nginx_conf_path/vhost
cat > $nginx_conf_path/vhost/$domain.conf << EOF
server{
    listen 80;
    server_name $domain $moredomainame;
    root ${vhostdir};
    index index.html index.htm index.shtml index.php;

    error_page  404               /404.html;
        location = /500.html {
        }

    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }
        location ~ \.php$ {
            fastcgi_pass  127.0.0.1:9000;
            include        fastcgi_params;
            fastcgi_param  SCRIPT_FILENAME  \$document_root\$fastcgi_script_name;
            access_log     /var/log/nginx/access_log;
        }

        location ~ /\.ht {
            deny  all;
        }
}
EOF

}


Create_nginx_php-fpm_conf

sudo chmod 777 /etc/hosts
record_line="127.0.0.1 ${domain} ${moredomainame} "
echo "添加的记录是："$record_line

echo $record_line >> /Users/xiaofang/bin/hosts.txt
sudo echo $record_line >> /etc/hosts


sudo nginx -s reload

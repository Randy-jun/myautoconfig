# My auto config
This is my autoconfig tools.

# 系统自动发送邮件
安装 mailutils 软件：sudo apt install mailutils
安装软件时选择：Internet with smarthost 选项；
第一个选项（System mail name）默认，第二个选项（SMTP relay host）留空；
编辑：/etc/hosts文件，删除：127.0.1.1 pve 增加：192.168.0.3 pve.yroot pve
使用命令：echo "$(date) Test！" | mail -s "Test" yangjun.randy@139.com
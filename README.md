# My auto config
This is my autoconfig tools.

# 系统自动发送邮件
安装 mailutils 软件
安装软件时选择：Internet with smarthost 选项；
第一个选项默认，第二个选项留空
编辑：/etc/hosts文件，增加：192.168.0.3 pve.yroot pve
使用命令：echo "$(date) Test！" | mail -s "Test" yangjun.randy@139.com
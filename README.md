# My auto config
This is my autoconfig tools.

# 系统自动发送邮件
安装 mailutils 软件
安装软件时选择选项
编辑：/etc/hosts文件，增加：192.168.0.3 pve.yroot pve
使用命令：echo "$(date) Test！" | mail -s "Test" yangjun.randy@139.com
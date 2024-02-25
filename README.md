# My auto config
This is my autoconfig tools.

# 系统自动发送邮件
1.安装 mailutils 软件：sudo apt install mailutils postfix;<br>
2.安装软件时选择：Internet with smarthost 选项；<br>
3.第一个选项（System mail name）默认，第二个选项（SMTP relay host）留空；<br>
4.编辑：/etc/hosts文件，删除：127.0.1.1 pve 增加：192.168.0.x pve.yroot pve<br>
5.使用命令：echo "$(date) Test！" | mail -s "Test" yangjun.randy@139.com<br>
6.编辑定时文件添加：*/5 *   * * *   yroot   /home/yroot/myautoconfig/ip_post.sh<br>

# Immich-app
1.镜像下载使用南京大学镜像：`https://doc.nju.edu.cn/books/35f4a/page/gcr`<br>
2.人脸识别等模型可使用镜像站：https://hf-mirror.com,在.env文件中添加：<br>
`HF_ENDPOINT=https://hf-mirror.com`<br>

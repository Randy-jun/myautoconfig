#!/bin/bash

tmux_config()
{
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm > /dev/null 2>&1 &&
    ln -s $HOME/myautoconfig/dotfiles/tmux.conf $HOME/.tmux.conf > /dev/null 2>&1;
    if [ $? = 0 ] ; then
        return 0;
    else
        return 1;
    fi
}

vim_config()
{
    ln -s $HOME/myautoconfig/dotfiles/vimrc $HOME/.vimrc > /dev/null 2>&1;
    if [ $? = 0 ] ; then
        return 0;
    else
        return 1;
    fi
}

oh_my_zsh_config()
{
    sudo chsh $LOGNAME -s /bin/zsh > /dev/null 2>&1 &&
    git clone https://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh/ > /dev/null 2>&1 &&
    ln -s $HOME/myautoconfig/dotfiles/zshrc $HOME/.zshrc > /dev/null 2>&1;
    if [ $? = 0 ] ; then
        return 0;
    else
        return 1;
    fi
}

pip_config()
{
    sudo ln -s $HOME/myautoconfig/dotfiles/pip.conf /etc/pip.conf > /dev/null 2>&1;
    if [ $? = 0 ] ; then
        return 0;
    else
        return 1;
    fi
}

mariadb_config()
{
    echo "mariadb_config...";
	mysql -v
    sudo systemctl start mariadb && sudo systemctl enable mariadb && sudo systemctl restart mariadb;
    if [ $? = 0 ] ; then
        return 0;
    else
        return 1;
    fi
}

nginx_config()
{
    echo "nginx_config...";
	nginx -v
	sudo cat $HOME/myautoconfig/dotfiles/env_config_file/default > /etc/nginx/sites-enabled/default
    sudo systemctl start nginx && sudo systemctl enable nginx && sudo systemctl restart nginx;
    if [ $? = 0 ] ; then
        return 0;
    else
        return 1;
    fi
}

php_config()
{
    echo "php_config...";
	php -v;
	sudo cat $HOME/myautoconfig/dotfiles/env_config_file/php.ini > /etc/php/7.1/cli/php.ini;
	curl -sS https://getcomposer.org/installer | php;
	sudo mv composer.phar /usr/local/bin/composer;
	composer config -g repo.packagist composer https://packagist.phpcomposer.com;
	composer self-update;
    sudo systemctl start php7.1-fpm && sudo systemctl enable php7.1-fpm && sudo systemctl restart php7.1-fpm;
    if [ $? = 0 ] ; then
        return 0;
    else
        return 1;
    fi
}

main()
{
    #sudo apt update && sudo apt -y full-upgrade;
    #sudo apt -y install htop vim tmux zsh curl synapse > /dev/null 2>&1;
    sudo apt -y install htop vim zsh curl synapse > /dev/null 2>&1;

    if [ $? = 0 ] ; then
        echo -e "Software has been installed [\033[;32mFinish\033[;m].";
    else
        echo -e "Software has been installed [\033[;31mFaile\033[;m].";
        exit 1;
    fi

    # tmux vim oh_my_zsh pip
    software=(vim oh_my_zsh pip);
    
    for sw in ${software[*]};
    do
        ${sw}'_config';
        if [ $? = 0 ] ; then
            echo -e "$0 deployed ${sw} [\033[;32mFinish\033[;m].";
            continue;
        else
            echo -e "$0 deployed ${sw} [\033[;31mFaile\033[;m].";
            return 1;
        fi
    done

    return 0;
}

env_install()
{

    cd $HOME/myautoconfig/;
    git pull;
    
	env_software=(mariadb nginx php);
    #sudo apt update && sudo apt -y full-upgrade;
    sudo apt -y install mariadb-server-10.1 mariadb-client-10.1 nginx php7.1-dev php7.1-fpm curl > /dev/null 2>&1;
    for env_sw in ${env_software[*]};
    do
        ${env_sw}'_config';
        if [ $? = 0 ] ; then
            echo -e "$0 deployed ${env_sw} [\033[;32mFinish\033[;m].";
        else
            echo -e "$0 deployed ${env_sw} [\033[;31mFaile\033[;m].";
            return 1;
        fi
    done
    echo -e "ThinkPHP5 install.";
    cd $HOME;
	composer create-project topthink/think=5.1.* tp5  --prefer-dist;
	sudo ln -s $HOME/tp5/ /var/www/html/;
    echo -e "ThinkPHP5 installed.";

    exit 0;
}

env_update()
{
    cd $HOME/myautoconfig/;
    git pull;

	sudo cat $HOME/myautoconfig/dotfiles/env_config_file/default > /etc/nginx/sites-enabled/default;
    sudo systemctl restart nginx;
	sudo cat $HOME/myautoconfig/dotfiles/env_config_file/php.ini > /etc/php/7.1/cli/php.ini;
    sudo systemctl restart ginx;
    sudo systemctl restart php7.1-fpm;
    if [ $? = 0 ] ; then
        echo -e "$0 updated [\033[;32mFinish\033[;m].";
        return 0;
    else
        echo -e "$0 updated [\033[;31mFaile\033[;m].";
        return 1;
    fi
}

update()
{
    cd $HOME/myautoconfig/;
    git pull;
    if [ $? = 0 ] ; then
        echo -e "$0 updated [\033[;32mFinish\033[;m].";
        return 0;
    else
        echo -e "$0 updated [\033[;31mFaile\033[;m].";
        return 1;
    fi
}

DATE=$(date);
sudo echo "Time is $DATE";

if [ $# -ge 0 -a $# -le 1 ]; then
    if [ $# -eq 0 ]; then
        echo "$0 start install...";
        main;
        exit 0;
    fi
    case $1 in
        install) echo "$0 start install..." && main;
            exit 0;
            ;;
        update) echo "$0 start update..." && update;
            exit 0;
            ;;
        env_install) echo "$0 start install environment..." && env_install;
            exit 0;
            ;;
        env_update) echo "$0 start update environment..." && env_update;
            exit 0;
            ;;
        *) echo -e "Usage:$0 [ \033[;32minstall\033[;m | \033[;32mupdate\033[;m ]";
            exit 0;
            ;;
    esac
else
    echo -e "Usage:$0 [ \033[;32minstall\033[;m | \033[;32mupdate\033[;m ]";
    exit 0;
fi

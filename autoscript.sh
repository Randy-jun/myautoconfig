#!/bin/bash

tmux_config()
{
    rm -f ${HOME}/.tmux.conf &&
    rm -rf ${HOME}/.tmux.conf &&
    git clone https://github.com/tmux-plugins/tpm ${HOME}/.tmux/plugins/tpm > /dev/null 2>&1 &&
    ln -s ${HOME_DIR}/dotfiles/tmux.conf ${HOME}/.tmux.conf > /dev/null 2>&1;
    if [ $? = 0 ] ; then
        return 0;
    else
        return 1;
    fi
}

vim_config()
{
    rm -f ${HOME}/.vimrc &&
    ln -s ${HOME_DIR}/dotfiles/vimrc ${HOME}/.vimrc > /dev/null 2>&1;
    if [ $? = 0 ] ; then
        return 0;
    else
        return 1;
    fi
}

oh_my_zsh_config()
{
    rm -f ${HOME}/.zshrc &&
    rm -rf ${HOME}/.oh-my-zsh/ &&
    sudo chsh $LOGNAME -s /bin/zsh > /dev/null 2>&1 &&
    git clone https://github.com/robbyrussell/oh-my-zsh.git ${HOME}/.oh-my-zsh/ > /dev/null 2>&1 &&
    ln -s ${HOME_DIR}/dotfiles/zshrc ${HOME}/.zshrc > /dev/null 2>&1;
    if [ $? = 0 ] ; then
        return 0;
    else
        return 1;
    fi
}

pip_config()
{
    sudo rm -f /etc/pip.conf &&
    sudo ln -s ${HOME_DIR}/dotfiles/pip.conf /etc/pip.conf > /dev/null 2>&1;
    if [ $? = 0 ] ; then
        return 0;
    else
        return 1;
    fi
}

mariadb_config()
{
    echo "mariadb_config...";
	mysql -V;
    # sudo systemctl start mariadb && sudo systemctl enable mariadb && sudo systemctl restart mariadb;
    sudo systemctl stop mariadb.service;
    echo "systemctl enable mariadb_config...";
    sudo systemctl enable mariadb.service && sudo systemctl restart mariadb.service || sudo systemctl start mariadb.service;
    echo "systemctl enable mariadb_config...";
	sudo sh -c ${HOME_DIR}/mariadb.sh;
    if [ $? = 0 ] ; then
        return 0;
    else
        return 1;
    fi
}

nginx_config()
{
    echo "nginx_config...";
	nginx -v;
	sudo rm -f /etc/nginx/sites-available/default;
	sudo systemctl stop nginx.service;
    echo "systemctl enable nginx_config...";
	sudo ln ${HOME_DIR}/dotfiles/env_config_file/default  /etc/nginx/sites-available/default;
    sudo systemctl enable nginx.service && sudo systemctl restart nginx.service || sudo systemctl start nginx.service;
    echo "systemctl enable nginx_config...";
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
	# curl -sS https://getcomposer.org/installer | php;
	sudo systemctl stop php7.1-fpm.service;
	curl -sS https://install.phpcomposer.com/installer | php; # in domain
	sudo mv composer.phar /usr/local/bin/composer;
	composer config -g repo.packagist composer https://packagist.phpcomposer.com;
	# composer self-update;
	sudo rm -f /etc/php/7.1/fpm/php.ini;
	sudo rm -f /etc/php/7.1/cli/php.ini;
	sudo ln ${HOME_DIR}/dotfiles/env_config_file/php.ini /etc/php/7.1/fpm/php.ini;
	sudo ln ${HOME_DIR}/dotfiles/env_config_file/php.ini /etc/php/7.1/cli/php.ini;
    echo "systemctl enable php7.1-fpm_config...";
    sudo systemctl enable php7.1-fpm.service && sudo systemctl restart php7.1-fpm.service || sudo systemctl start php7.1-fpm.service;
    echo "systemctl enable php7.1-fpm_config...";
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

    cd ${HOME_DIR};
    git pull;
    
	env_software=(mariadb php nginx);
    #sudo apt update && sudo apt -y full-upgrade;
	sw_db="mariadb-server-10.1 mariadb-client-10.1";
	sw_web="nginx";
	sw_php="curl php7.1-dev php7.1-fpm php7.1-mbstring php7.1-mysql";
	sw_phpmyadmin_must="php7.1-xml php7.1-curl phpunit phpunit-selenium";
	sw_phpmyadmin_improve="php-invoker php-bz2 php-zip php-opcache php-gd php-gmp php-libsodium php-xdebug php-soap";
    # sudo apt -y install mariadb-server-10.1 mariadb-client-10.1 nginx php7.1-dev php7.1-fpm php7.1-mbstring php7.1-mysql php7.1-xml php7.1-curl phpunit phpunit-selenium curl > /dev/null 2>&1;
	sudo apt -y install ${sw_db} ${sw_web} ${sw_php} ${sw_phpmyadmin_must} ${sw_phpmyadmin_improve};
    if [ $? = 0 ] ; then
        echo -e "Software has been installed [\033[;32mFinish\033[;m].";
    else
        echo -e "Software has been installed [\033[;31mFaile\033[;m].";
        exit 1;
    fi
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

	sudo ln -s ${HOME_DIR}/dotfiles/env_config_file/index.php /var/www/html/;

	composer create-project topthink/think=5.1 $HOME/tp5  --prefer-dist;
	sudo ln -s $HOME/tp5/ /var/www/;
    echo -e "ThinkPHP5 installed.";

    echo -e "phpmyadmin install.";
	composer create-project phpmyadmin/phpmyadmin $HOME/phpmyadmin;
	sudo ln -s $HOME/phpmyadmin/ /var/www/;
	cd ${HOME}/phpmyadmin;
	composer update && cd ${HOME};
    echo -e "phpmyadmin installed.";
	 
	sudo sh -c ${HOME_DIR}/host_wrtie.sh;
    exit 0;
}

env_update()
{
    cd ${HOME_DIR};
    git pull;

    echo -e "Start nginx service...";
    sudo systemctl start nginx.service || sudo systemctl restart nginx.service;
    echo -e "Nginx service is [\033[;32mOK!\033[;m]";
    echo -e "Start mariadb service...";
    sudo systemctl start mariadb.service || sudo systemctl restart mariadb.service;
    echo -e "Mariadb service is [\033[;32mOK!\033[;m]";
    echo -e "Start php-fpm service...";
    sudo systemctl start php7.1-fpm.service || sudo systemctl restart php7.1-fpm.service;
    echo -e "PHP-FPM service is [\033[;32mOK!\033[;m]";
    if [ $? = 0 ] ; then
        echo -e "$0 env_updated [\033[;32mFinish\033[;m].";
        return 0;
    else
        echo -e "$0 env_updated [\033[;31mFaile\033[;m].";
        return 1;
    fi
}

update()
{
    cd ${HOME_DIR};
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
HOME_DIR=$(pwd);

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
    echo -e "Usage:$0 [ \033[;32minstall\033[;m | \033[;32mupdate\033[;m ] | \033[;32menv_install\033[;m ] | \033[;32menv_update\033[;m ]";
    exit 0;
fi

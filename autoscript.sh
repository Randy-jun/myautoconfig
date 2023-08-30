#!/bin/bash

tmux_config()
{
    rm -f ${HOME}/.tmux.conf;
    rm -f ${HOME}/.tmux.conf.local;
    git clone https://github.com/tmux-plugins/tpm ${HOME}/.tmux/plugins/tpm > /dev/null 2>&1;
    ln -s -f ${HOME_DIR}/dotfiles/.tmux/.tmux.conf ${HOME}/.tmux.conf > /dev/null 2>&1 &&
    cp ${HOME_DIR}/dotfiles/.tmux/.tmux.conf.local ${HOME}/.tmux.conf.local > /dev/null 2>&1;
    if [ $? = 0 ] ; then
        return 0;
    else
        return 1;
    fi
}

vim_config()
{
    rm -f ${HOME}/.vimrc;
    # ln -s -f ${HOME_DIR}/dotfiles/vimrc ${HOME}/.vimrc > /dev/null 2>&1;
    # git clone https://github.com/amix/vimrc.git ${HOME}/.vim_runtime &&
    ln -s -f ${HOME_DIR}/dotfiles/vimrc ${HOME}/.vim_runtime > /dev/null 2>&1 &&
    sh -c ${HOME_DIR}/dotfiles/vimrc/install_awesome_vimrc.sh > /dev/null 2>&1 &&
    sed -i "2iset nu" ${HOME}/.vimrc;
    if [ $? = 0 ] ; then
        return 0;
    else
        return 1;
    fi
}

oh_my_zsh_config()
{
    rm -f ${HOME}/.zshrc;
    rm -rf ${HOME}/.oh-my-zsh/;
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git && ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k &&
    # sudo chsh $LOGNAME -s /bin/zsh > /dev/null 2>&1 &&
    # git clone https://github.com/ohmyzsh/ohmyzsh.git ${HOME}/.oh-my-zsh/ > /dev/null 2>&1 &&
    # ln -s -f ${HOME_DIR}/dotfiles/zshrc ${HOME}/.zshrc > /dev/null 2>&1;
    # sh -c ${HOME_DIR}/dotfiles/ohmyzsh/tools/install.sh > /dev/null 2>&1;
    # (${HOME_DIR}/dotfiles/ohmyzsh/tools/install.sh --unattended) > /dev/null 2>&1 &&
    (${HOME_DIR}/dotfiles/ohmyzsh/tools/install.sh --unattended) &&
    rm -f ${HOME}/.zshrc && ln -s -f ${HOME_DIR}/dotfiles/zshrc ${HOME}/.zshrc > /dev/null 2>&1;
    sudo chsh $LOGNAME -s /bin/zsh > /dev/null 2>&1;
    if [ $? = 0 ] ; then
        return 0;
    else
        return 1;
    fi
}

pip_config()
{
    sudo rm -f /etc/pip.conf;
    sudo ln -s -f ${HOME_DIR}/dotfiles/pip.conf /etc/pip.conf > /dev/null 2>&1;
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
    sudo ln -s -f ${HOME_DIR}/dotfiles/env_config_file/default  /etc/nginx/sites-available/default;
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
    sudo ln -s -f ${HOME_DIR}/dotfiles/env_config_file/php.ini /etc/php/7.1/fpm/php.ini;
    sudo ln -s -f ${HOME_DIR}/dotfiles/env_config_file/php.ini /etc/php/7.1/cli/php.ini;
    echo "systemctl enable php7.1-fpm_config...";
    sudo systemctl enable php7.1-fpm.service && sudo systemctl restart php7.1-fpm.service || sudo systemctl start php7.1-fpm.service;
    echo "systemctl enable php7.1-fpm_config...";
    if [ $? = 0 ] ; then
        return 0;
    else
        return 1;
    fi
}

sublime_new_install()
{
    echo "new_sublime_install...";
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add - &&
    sudo apt-get install apt-transport-https &&
    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list;
    if [ $? = 0 ] ; then
        return 0;
    else
        return 1;
    fi
}

nodejs_current_install()
{
    echo "Node.js current install...";
    for pkg in nodejs npm; do sudo apt purge nodejs npm -y $pkg && sudo rm -r /etc/apt/sources.list.d/nodesource.list; done
    if [ $? = 0 ] ; then
    echo "Node.js current reinstall...";
    else
        echo "Node.js reinstall...";
    fi
    # curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash - &&
    curl -sL https://deb.nodesource.com/setup_current.x | sudo -E bash - &&
    sudo apt update &&
    sudo apt install nodejs -y &&
    sudo apt install npm -y;
    sudo npm install -g cnpm --registry=https://registry.npmmirror.com &&
    sudo cnpm install cnpm@latest -g &&
    sudo cnpm install pnpm@latest -g;
    if [ $? = 0 ] ; then
        return 0;
    else
        return 1;
    fi
}

vue_install()
{
    cd ${HOME_DIR};
    git pull;
    nodejs_current_install;
    if [ $? = 0 ] ; then
        echo -e "Nodejs has been installed. [\033[;32mFinish\033[;m].";
    else
        echo -e "Nodejs installed [\033[;31mFaile\033[;m].";
        exit 1;
    fi
    # sudo npm install -g cnpm --registry=https://registry.npmmirror.com &&
    # sudo cnpm install cnpm@latest -g;
    # if [ $? = 0 ] ; then
    #     echo -e "cnpm has been installed. [\033[;32mFinish\033[;m].";
    # else
    #     echo -e "cnpm installed [\033[;31mFaile\033[;m].";
    #     exit 1;
    # fi
    #sudo cnpm install vue-cli -g;#旧版本
    # sudo cnpm install @vue/cli -g;#新版本
    # if [ $? = 0 ] ; then
    #     echo -e "Vue-cli has been installed. [\033[;32mFinish\033[;m].";
    # else
    #     echo -e "Vue-cli installed [\033[;31mFaile\033[;m].";
    #     exit 1;
    # fi
    # exit 0;
}

docker_install()
{
    echo "Docker current install...";
    # for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt remove $pkg; done
    # sudo apt autoremove docker.io docker-doc docker-compose podman-docker containerd runc;
    # sudo apt -y install ca-certificates curl gnupg;
    # sudo install -m 0755 -d /etc/apt/keyrings;
    # curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg;
    # echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu   "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null;
    # sudo apt update && sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin;
    export DOWNLOAD_URL="https://mirrors.tuna.tsinghua.edu.cn/docker-ce";
    curl -fsSL https://get.docker.com/ | sudo -E sh;
    # sudo docker run hello-world;
    if [ $? = 0 ] ; then
        return 0;
    else
        return 1;
    fi
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

    sudo ln -s -f ${HOME_DIR}/dotfiles/env_config_file/index.php /var/www/html/;

    composer create-project topthink/think=5.1 $HOME/tp5  --prefer-dist;
    sudo ln -s $HOME/tp5/ /var/www/;
    echo -e "ThinkPHP5 installed.";

    echo -e "phpmyadmin install.";
    composer create-project phpmyadmin/phpmyadmin $HOME/phpmyadmin;
    sudo ln -s -f $HOME/phpmyadmin/ /var/www/;
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
    git pull --rebase;
    # cd ${HOME};
    # git pull --rebase;
    # python update_plugins.py;
    sudo git submodule update --remote;
    if [ $? = 0 ] ; then
        echo -e "$0 updated [\033[;32mFinish\033[;m].";
        return 0;
    else
        echo -e "$0 updated [\033[;31mFaile\033[;m].";
        return 1;
    fi
}

main()
{
    # sudo git submodule update  --recursive > /dev/null 2>&1;
    # sudo git submodule update  --init > /dev/null 2>&1;
    sudo git submodule update --init;
    if [ $? = 0 ] ; then
        echo -e "Submodule has been copied [\033[;32mFinish\033[;m].";
    else
        echo -e "Software has been copied [\033[;31mFaile\033[;m].";
        exit 1;
    fi
    # sudo git submodule update --remote > /dev/null 2>&1;
    sudo git submodule update --remote;
    if [ $? = 0 ] ; then
        echo -e "Submodule has been updated [\033[;32mFinish\033[;m].";
    else
        echo -e "Software has been updated [\033[;31mFaile\033[;m].";
        exit 1;
    fi
    # git fetch;
    # sublime_new_install;
    # sudo apt update && sudo apt -y apt-traca-certificates gnupg && sudo apt -y full-upgrade;
    sudo apt update && sudo apt -y full-upgrade;
    sudo apt -y install htop vim tmux zsh curl gawk perl sed;
    # sudo apt -y install htop vim zsh curl synapse sublime-text > /dev/null 2>&1;
    if [ $? = 0 ] ; then
        echo -e "Software has been installed [\033[;32mFinish\033[;m].";
    else
        echo -e "Software has been installed [\033[;31mFaile\033[;m].";
        exit 1;
    fi

    software=(tmux vim oh_my_zsh pip);
    # software=(vim oh_my_zsh pip);

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
        vue_install) echo "$0 start install environment..." && vue_install;
            exit 0;
            ;;
        docker_install) echo "$0 start install Docker..." && docker_install;
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

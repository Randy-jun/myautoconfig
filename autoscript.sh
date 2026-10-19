#!/bin/bash

#tmux_config()
tmux_config()
{
    rm -f ${HOME}/.tmux.conf;
    rm -f ${HOME}/.tmux.conf.local;
    git clone https://github.com/tmux-plugins/tpm ${HOME}/.tmux/plugins/tpm > /dev/null 2>&1;
    ln -s -f ${HOME_DIR}/dotfiles/.tmux/.tmux.conf ${HOME}/.tmux.conf > /dev/null 2>&1 &&
    ln -s -f ${HOME_DIR}/dotfiles/tmux.conf.local ${HOME}/.tmux.conf.local > /dev/null 2>&1;
    #cp ${HOME_DIR}/dotfiles/tmux.conf.local ${HOME}/.tmux.conf.local > /dev/null 2>&1;
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
    # sudo chsh $LOGNAME -s /bin/zsh > /dev/null 2>&1 &&
    # git clone https://github.com/ohmyzsh/ohmyzsh.git ${HOME}/.oh-my-zsh/ > /dev/null 2>&1 &&
    # ln -s -f ${HOME_DIR}/dotfiles/zshrc ${HOME}/.zshrc > /dev/null 2>&1;
    # sh -c ${HOME_DIR}/dotfiles/ohmyzsh/tools/install.sh > /dev/null 2>&1;
    # (${HOME_DIR}/dotfiles/ohmyzsh/tools/install.sh --unattended) > /dev/null 2>&1 &&
    (${HOME_DIR}/dotfiles/ohmyzsh/tools/install.sh --unattended) &&
    rm -f ${HOME}/.zshrc && ln -s -f ${HOME_DIR}/dotfiles/zshrc ${HOME}/.zshrc > /dev/null 2>&1;
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k &&
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
    curl -fsSL https://get.docker.com/ | sudo -E sh;
    # sudo docker run hello-world;
    if [ $? = 0 ] ; then
        return 0;
    else
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
        echo -e "$0 updated [\033[;31mFail\033[;m].";
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
        echo -e "Software has been copied [\033[;31mFail\033[;m].";
        exit 1;
    fi
    # sudo git submodule update --remote > /dev/null 2>&1;
    sudo git submodule update --remote;
    if [ $? = 0 ] ; then
        echo -e "Submodule has been updated [\033[;32mFinish\033[;m].";
    else
        echo -e "Software has been updated [\033[;31mFail\033[;m].";
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
        echo -e "Software has been installed [\033[;31mFail\033[;m].";
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
            echo -e "$0 deployed ${sw} [\033[;31mFail\033[;m].";
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
        docker_install) echo "$0 start install Docker..." && docker_install;
            exit 0;
            ;;
        *) echo -e "Usage:$0 [ \033[;32minstall\033[;m | \033[;32mupdate\033[;m | \033[;32mdocker_install\033[;m ]";
            exit 0;
            ;;
    esac
else
    echo -e "Usage:$0 [ \033[;32minstall\033[;m | \033[;32mupdate\033[;m | \033[;32mdocker_install\033[;m ]";
    exit 0;
fi

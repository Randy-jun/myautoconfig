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

main()
{
	#sudo apt update && sudo apt -y upgrade;
	sudo apt -y install htop vim tmux zsh > /dev/null 2>&1;

	if [ $? = 0 ] ; then
		echo -e "Software has been installed [\033[;32mFinish\033[;m].";
	else
		echo -e "Software has been installed [\033[;31mFaile\033[;m].";
		exit 1;
	fi

	tmux_config;
	if [ $? = 0 ] ; then
		echo -e "Tmux deployed [\033[;32mFinish\033[;m].";
	else
		echo -e "Tmux deployed [\033[;31mFaile\033[;m].";
		exit 1;
	fi

	vim_config;
	if [ $? = 0 ] ; then
		echo -e "Vim deployed [\033[;32mFinish\033[;m].";
	else
		echo -e "Vim deployed [\033[;31mFaile\033[;m].";
		exit 1;
	fi

	oh_my_zsh_install;
	if [ $? = 0 ] ; then
		echo -e "Zsh deployed [\033[;32mFinish\033[;m].";
	else
		echo -e "Zsh deployed [\033[;31mFaile\033[;m].";
		exit 1;
	fi
	return 0;
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
		echo "$0 install start...";
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
		*) echo -e "Usage:$0 1[ \033[;32minstall\033[;m | \033[;32mupdate\033[;m ]";
			exit 0;
			;;
	esac
else
	echo -e "Usage:$0 [ \033[;32minstall\033[;m | \033[;32mupdate\033[;m ]";
	exit 0;
fi

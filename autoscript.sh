#!/bin/bash

oh_my_zsh_install()
{
	#sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)";
	git clone https://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh/ > /dev/null 2>&1;
}

main()
{
	#sudo apt update && sudo apt -y upgrade;
	sudo apt -y install htop vim tmux zsh > /dev/null 2>&1 &&

	if [ $? = 0 ] ; then
		echo -e "Software has been installed [\033[;32mFinish\033[;m].";
	else
		echo -e "Software has been installed [\033[;31mFaile\033[;m].";
	fi

	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm > /dev/null 2>&1 &&
	ln -s $HOME/myautoconfig/dotfiles/tmux.conf $HOME/.tmux.conf > /dev/null 2>&1;
	if [ $? = 0 ] ; then
		echo -e "Tmux deployed [\033[;32mFinish\033[;m].";
	else
		echo -e "Tmux deployed [\033[;31mFaile\033[;m].";
	fi

	ln -s $HOME/myautoconfig/dotfiles/vimrc $HOME/.vimrc > /dev/null 2>&1;
	if [ $? = 0 ] ; then
		echo -e "Vim deployed [\033[;32mFinish\033[;m].";
	else
		echo -e "Vim deployed [\033[;31mFaile\033[;m].";
	fi

	sudo chsh -s /bin/zsh > /dev/null 2>&1 &&
	oh_my_zsh_install && ln -s $HOME/myautoconfig/dotfiles/zshrc $HOME/.zshrc > /dev/null 2>&1;
	if [ $? = 0 ] ; then
		echo -e "Zsh deployed [\033[;32mFinish\033[;m].";
	else
		echo -e "Zsh deployed [\033[;31mFaile\033[;m].";
	fi
}

update()
{
	echo "$0 update";
}

DATE=$(date);
sudo echo "Time is $DATE";

if [ $# -ge 0 -a $# -le 1 ]; then
	echo "$# $0 $1";
	if [ $# -eq 0 ]; then
		echo "$0 install start...";
		main;
	fi
	case $1 in
		install) echo "$0 install start..." && main;
			exit 0
			;;
		update) echo "$0 update start..." && update;
			exit 0
			;;
		*) echo -e "Usage:$0 1[ \033[;32minstall\033[;m | \033[;32mupdate\033[;m ]";
			;;
	esac
else
	echo -e "Usage:$0 [ \033[;32minstall\033[;m | \033[;32mupdate\033[;m ]";
fi

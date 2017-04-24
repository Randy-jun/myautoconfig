#!/bin/bash

DATE=$(date)
echo "Time is $DATE"

#sudo apt update && sudo apt -y upgrade
sudo apt -y install htop vim tmux zsh > /dev/null 2>&1
if [ $? = 0 ] ; then
	echo -e "Software has been installed [\033[;32mFinish\033[;m]."
else
	echo -e "Software has been installed [\033[;31mFaile\033[;m]."
fi

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm > /dev/null 2>&1
ln -s $HOME/myautoconfig/dotfiles/tmux.conf $HOME/.tmux.conf > /dev/null 2>&1
if [ $? = 0 ] ; then
	echo -e "Tmux deployed [\033[;32mFinish\033[;m]."
else
	echo -e "Tmux deployed [\033[;31mFaile\033[;m]."
fi

ln -s $HOME/myautoconfig/dotfiles/vimrc $HOME/.vimrc > /dev/null 2>&1
if [ $? = 0 ] ; then
	echo -e "Vim deployed [\033[;32mFinish\033[;m]."
else
	echo -e "Vim deployed [\033[;31mFaile\033[;m]."
fi

cd $HOME && curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh > /dev/null 2>&1 && cd - >/dev/null 2>&1
ln -s $HOME/myautoconfig/dotfiles/zshrc $HOME/.zshrc > /dev/null 2>&1
if [ $? = 0 ] ; then
	echo -e "Zsh deployed [\033[;32mFinish\033[;m]."
else
	echo -e "Zsh deployed [\033[;31mFaile\033[;m]."
fi

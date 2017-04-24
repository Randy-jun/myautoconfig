#!/bin/sh

DATE=$(date)
echo "Time is $DATE"

#sudo apt update && sudo apt -y upgrade
sudo apt -y install htop vim tmux zsh

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm 2> /dev/null
ln -s $HOME/myautoconfig/dotfiles/tmux.conf $HOME/.tmux.conf 2> /dev/null
if [ $? = 0 ] ; then
	echo "Tmux deployed [\033[;32mFinish\033[;m]."
else
	echo "Tmux deployed [\033[;31mFaile\033[;m]."
fi

ln -s $HOME/myautoconfig/dotfiles/vimrc $HOME/.vimrc 2> /dev/null
if [ $? = 0 ] ; then
	echo "Vim deployed [\033[;32mFinish\033[;m]."
else
	echo "Vim deployed [\033[;31mFaile\033[;m]."
fi

curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh 2> /dev/null
ln -s $HOME/myautoconfig/dotfiles/zshrc $HOME/.zshrc 2> /dev/null
if [ $? = 0 ] ; then
	echo "Zsh deployed [\033[;32mFinish\033[;m]."
else
	echo "Zsh deployed [\033[;31mFaile\033[;m]."
fi

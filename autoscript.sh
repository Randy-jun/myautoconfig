#!/bin/sh

DATE=$(date)
echo "Time is $DATE"

#sudo apt update && sudo apt -y upgrade
#sudo apt -y install htop vim tmux zsh

ln -s $HOME/myautoconfig/dotfiles/tmux.conf $HOME/myautoconfig/.tmux.conf 2> /dev/null
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
if [ $? = 0 ] ; then
	echo -e "Tmux deployed [\033[;32mFinish\033[;m]."
else
	echo -e "Tmux deployed [\033[;31mFaile\033[;m]."
fi

ln -s $HOME/myautoconfig/dotfiles/vimrc $HOME/myautoconfig/.vimrc 2> /dev/null
if [ $? = 0 ] ; then
	echo -e "Vim deployed [\033[;32mFinish\033[;m]."
else
	echo -e "Vim deployed [\033[;31mFaile\033[;m]."
fi

ln -s $HOME/myautoconfig/dotfiles/zshrc $HOME/myautoconfig/.zshrc 2> /dev/null
if [ $? = 0 ] ; then
	echo -e "Zsh deployed [\033[;32mFinish\033[;m]."
else
	echo -e "Zsh deployed [\033[;31mFaile\033[;m]."
fi

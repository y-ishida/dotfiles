#!/bin/bash

self_dir=$(cd $(dirname $0); pwd)

# $1: backup file's path
backup() {
	if [ -e $1 ]; then
		cp --backup=numbered -f $1 $1
	fi
}

install_git() {
	sudo yum install -y git

	git config --global color.ui auto
	git config --global core.editor vim
	git config --global push.default simple
}

install_bashrc() {
	backup ~/.bashrc
	ln -fs $self_dir/.bashrc ~/.bashrc
}

install_vim() {
	sudo yum install -y vim

	# Vundleのインストール
	if ! [ -e ~/.vim/bundle/Vundle.vim ]; then
		git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	fi

	# .vimrcのシンボリックリンク生成
	backup ~/.vimrc
	ln -fs $self_dir/.vimrc ~/.vimrc

	# vimプラグインのインストール (Vundle)
	vim +PluginInstall +qall
}

install_tmux() {
	sudo yum install -y tmux

	# .tmux.confのシンボリックリンク生成
	backup ~/.tmux.conf
	ln -fs $self_dir/.tmux.conf ~/.tmux.conf
}

install_misc() {
	sudo yum install -y tree
	sudo yum install -y bash-completion
}

install_nodejs() {
   curl -sL https://rpm.nodesource.com/setup_6.x | sudo bash -
   yum install -y nodejs
}

gen_key() {
	# 公開鍵の生成
	if ! [ -f ~/.ssh/id_rsa.pub ]; then
		ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
	fi


	# 公開鍵の表示
	echo
	echo 'あなたの公開鍵↓'
	echo '------------------------------'

	cat ~/.ssh/id_rsa.pub

	echo '------------------------------'
}


#set -x
set -e

install_git
install_bashrc
install_vim
install_tmux
install_misc
#install_nodejs
gen_key


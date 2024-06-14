#!/bin/bash

DIR=$(cd $(dirname $0); pwd)
SRC=~/src

update_bashrc() {
	cat >> ~/.bashrc <<-EOF
		# My setting
		umask 022
		export EDITOR=vim

		# byobu でステータスライン表示がおかしくなる問題対策
		export VTE_CJK_WIDTH=1
		EOF

	. ~/.bashrc
}


install_git() {
	sudo apt-get -y install git

	git config --global color.ui auto
	git config --global core.editor vim
	git config --global push.default simple
}


install_vim() {
	sudo apt-get -y install vim

	# vim-plug インストール
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

	# .vimrcのシンボリックリンク生成
	if [ -e ~/.vimrc ]; then
		mv ~/.vimrc ~/.vimrc.old
	fi
	ln -fs $DIR/.vimrc ~/.vimrc

	# プラグインのインストール
	vim +PlugInstall +qall
}


install_build_tools() {
	sudo apt-get -y install build-essential autoconf automake libtool
}


gen_key() {
	# 公開鍵の生成
	if ! [ -f ~/.ssh/id_ed25519.pub ]; then
		ssh-keygen -t ed25519 -N ""
	fi

	# 公開鍵の表示
	echo
	echo 'あなたの公開鍵↓'
	echo '------------------------------'

	cat ~/.ssh/id_ed25519.pub

	echo '------------------------------'
}

#set -x
set -e

update_bashrc
install_git
install_vim
# gen_key


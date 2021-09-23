#! /bin/sh

DIR=$(cd $(dirname $0); pwd)
SRC=~/src


install_git() {
	git config --global color.ui auto
	git config --global core.editor vim
	git config --global push.default simple
}


install_vim() {
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


install_tmux() {
	brew install tmux

	# .vimrcのシンボリックリンク生成
	if [ -e ~/.tmux ]; then
		mv ~/.tmux.conf ~/.tmux.conf.old
	fi
	#ln -fs $DIR/.tmux.conf ~/.tmux.conf
	# for tmux >= 2.9
	ln -fs $DIR/.tmux.conf.2.9 ~/.tmux.conf
}


install_homebrew() {
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}


install_build_tools() {
	sudo apt-get -y install build-essential autoconf automake libtool
	#sudo apt-get -y install libxml2-dev

	# MinGW
	#sudo apt-get -y install mingw-w64
}


install_pyenv() {
	brew install pyenv pyenv-virtualenv
	echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\n  eval "$(pyenv virtualenv-init -)"\nfi' >> ~/.zshrc
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

# install from repository
#install_git
#install_vim
install_tmux
#install_build_tools
#install_pyenv

gen_key

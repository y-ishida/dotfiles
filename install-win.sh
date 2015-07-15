#/bin/sh

DIR=$(cd $(dirname $0); pwd)
SRC=~/src

setup_git() {
	git config --global color.ui auto
	git config --global core.editor gvim
	git config --global push.default simple
}

setup_vim() {
	# Vundleのインストール
	if ! [ -e ~/.vim/bundle/Vundle.vim ]; then
		git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	fi

	# .vimrcをコピー
	iconv -f UTF-8 -t CP932 $DIR/.vimrc > ~/_gvimrc

	# vimプラグインのインストール (Vundle)
	gvim +PluginInstall +qall
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
setup_git
setup_vim

# etc.
gen_key


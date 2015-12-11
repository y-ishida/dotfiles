#/bin/sh

DIR=$(cd $(dirname $0); pwd)
SRC=~/src


install_git() {
	sudo apt-get -y install git

	git config --global color.ui auto
	git config --global core.editor vim
	git config --global push.default simple
}


install_vim() {
	sudo apt-get -y install vim

	# Vundleのインストール
	if ! [ -e ~/.vim/bundle/Vundle.vim ]; then
		git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	fi

	# .vimrcのシンボリックリンク生成
	if [ -e ~/.vimrc ]; then
		mv ~/.vimrc ~/.vimrc.old
	fi
	ln -fs $DIR/.vimrc ~/.vimrc

	# vimプラグインのインストール (Vundle)
	vim +PluginInstall +qall
}


install_byobu() {
	sudo apt-get -y install byobu
}


install_build_tools() {
	sudo apt-get -y install build-essential autoconf automake libtool
	sudo apt-get -y install libxml2-dev

	# MinGW
	sudo apt-get -y install mingw-w64
}


install_sphinx() {
	sudo apt-get -y install python-sphinx
	sudo apt-get -y install python-pip
	pip install sphinx-intl
}


install_gollum() {
	sudo apt-get -y install python
	sudo apt-get -y install ruby ruby-dev libicu-dev
	sudo gem install gollum
}


install_src_valac() {
	if type vala > /dev/null 2>&1; then
		echo "Valaはイントール済みです"
		return
	fi

	cd $SRC

	# valacビルドに必要なパッケージをインストール
	sudo apt-get -y install flex bison libgtk-3-dev

	# valacソースをダウンロード
	wget http://download.gnome.org/sources/vala/0.28/vala-0.28.0.tar.xz

	# ソース展開
	tar xvf vala-0.28.0.tar.xz
	rm vala-0.28.0.tar.xz

	# make and install
	cd vala-0.28.0/
	./configure
	make
	sudo make install
	sudo ldconfig

	# anjuta-tags
	sudo apt-get -y install anjuta
}


install_src_libgee() {
	if pkg-config --exists gee-0.8; then
		echo "libgeeはインストール済みです"
		return
	fi

	local VERSION
	VERSION='0.18.0'

	cd $SRC

	wget https://download.gnome.org/sources/libgee/${VERSION%.*}/libgee-${VERSION}.tar.xz

	# ソース展開
	tar xvf libgee-${VERSION}.tar.xz
	rm libgee-${VERSION}.tar.xz

	# make and install
	cd libgee-${VERSION}
	./configure
	make
	sudo make install
}


install_src_valadoc() {
	if type valadoc > /dev/null 2>&1; then
		echo "Valadocはイントール済みです"
		return
	fi

	cd $SRC

	# ビルドに必要なパッケージをインストール
	sudo apt-get -y install libgraphviz-dev

	# ソースをダウンロード
	if ! [ -e valadoc ]; then
		git clone https://git.gnome.org/browse/valadoc
	fi

	# make and install
	cd valadoc
	./autogen.sh
	./configure
	make
	sudo make install
	sudo ldconfig
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
install_git
install_vim
install_byobu
install_build_tools
install_sphinx
install_gollum

# make and install from source code
if ! [ -e $SRC ]; then
	mkdir $SRC
fi
install_src_valac
install_src_libgee
install_src_valadoc

# etc.
gen_key


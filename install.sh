#!/bin/bash

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

	# ~/.byobu ディレクトリを作る
	byobu -c exit

	# for 256 colors setting
	echo 'set -g default-terminal "screen-256color"' >> ~/.byobu/profile.tmux
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
	sudo pip install sphinx-intl
}


install_gollum() {
	sudo apt-get -y install python
	sudo apt-get -y install ruby ruby-dev libicu-dev zlib1g-dev
	sudo gem install gollum
}


install_deb_tools() {
	sudo apt-get -y install dh-make devscripts pbuilder

	pb_dir=/var/cache/pbuilder
	hook_dir=$pb_dir/hooks
	result_dir=$pb_dir/result

	# フックスクリプト置き場の作成
	if ! [ -e $hook_dir ]; then
		sudo mkdir $hook_dir
	fi
	sudo chmod 777 $hook_dir

	# 結果置き場のアクセス権設定
	sudo chmod 777 $result_dir

	# ビルドエラー時に pbuilder 環境内のシェルにとどまるスクリプト
	cp /usr/share/doc/pbuilder/examples/C10shell $hook_dir

	# pbuilder の設定
	cat <<-'EOF' > ~/.pbuilderrc
	AUTO_DEBSIGN=${AUTO_DEBSIGN:-no}
	HOOKDIR=/var/cache/pbuilder/hooks
	EOF
}


install_rpm_tools() {
	sudo apt-get -y install alien gdebi

	if type rpmrebuild > /dev/null 2>&1; then
		echo "rpmrebuild はイントール済みです"
		return
	fi

	cd /tmp

	wget --trust-server-names http://sourceforge.net/projects/rpmrebuild/files/rpmrebuild/2.11/rpmrebuild-2.11-1.noarch.rpm/download
	sudo alien --to-deb rpmrebuild-2.11-1.noarch.rpm
	sudo gdebi -n rpmrebuild_2.11-2_all.deb

	cd $SRC
}


install_gh() {
	sudo apt-get -y install curl
	curl -sL https://deb.nodesource.com/setup_0.12 | sudo -E bash -
	sudo apt-get -y install nodejs
	sudo npm install -g gh
}


install_ghi() {
	sudo apt-get -y install ruby
	sudo gem install ghi
}


install_apache2() {
	sudo apt-get install apache2
	sudo apt-get install php5 php-pear libapache2-mod-php5
	sudo pear install Mail
	sudo chmod 777 /var/www/html
	sudo a2enmod rewrite
	sudo apache2ctl restart

	# さらに、 /etc/apache2/apache2.conf 内の
	#
	# <Directory /var/www/>
	# 	Options Indexes FollowSymLinks
	# 	AllowOverride None
	# 	Require all granted
	# </Directory>
	#
	# の部分を、
	#
	# 	AllowOverride All
	#
	# に変更する必要がある。
	# (.htaccess を有効化するため)
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


install_src_imagemagick() {
	cd $SRC

	# ビルドに必要なパッケージをインストール
	sudo apt-get -y install librsvg2-dev

	# ソースをダウンロード
	wget http://www.imagemagick.org/download/ImageMagick.tar.gz
	tar xzvf ImageMagick.tar.gz

	# make and install
	cd ImageMagick-*/
	./configure --with-rsvg
	make
	sudo make install
	sudo ldconfig
}

install_src_cmake() {
	cd $SRC

	# ソースをダウンロード
	wget https://cmake.org/files/v3.5/cmake-3.5.1.tar.gz
	tar xzvf cmake-*

	# make and install
	cd cmake-*/
	./bootstrap
	make
	sudo make install
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
#install_sphinx
#install_gollum
#install_deb_tools
#install_rpm_tools
#install_gh
#install_ghi
#install_apache2

# make and install from source code
if ! [ -e $SRC ]; then
	mkdir $SRC
fi
#install_src_valac
#install_src_libgee
#install_src_valadoc
#install_src_imagemagick

# etc.
gen_key


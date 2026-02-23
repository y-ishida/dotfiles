#!/bin/bash

DIR=$(cd $(dirname $0); pwd)
SRC=~/src

update_bashrc() {
	cat >> ~/.bashrc <<'EOF'

export EDITOR=vim

# Prevent accidental shell exit when pressing Ctrl+D
set -o ignoreeof

# For direnv
eval "$(direnv hook bash)"

# For venv with direnv  https://kellner.io/direnv.html
show_virtual_env() {
	if [[ -n "$VIRTUAL_ENV" && -n "$DIRENV_DIR" ]]; then
		echo "($(basename $VIRTUAL_ENV))"
	fi
}
export -f show_virtual_env
PS1='$(show_virtual_env)'$PS1
EOF

	. ~/.bashrc
}


setup_git() {
	git config --global color.ui auto
	git config --global core.editor vim
	git config --global core.quotepath false
	git config --global push.default simple
}


setup_vim() {
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


setup_tmux() {
	ln -fs $DIR/.tmux.conf.2.9 ~/.tmux.conf
}


install_aws() {
	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
	unzip awscliv2.zip
	sudo ./aws/install
}


gen_key() {
	# 公開鍵の生成
	if ! [ -f ~/.ssh/id_ed25519.pub ]; then
		ssh-keygen -t ed25519 -N "" -f ~/.ssh/id_ed25519
	fi

	# 公開鍵の表示
	echo
	echo 'あなたの公開鍵↓'
	echo '------------------------------'

	cat ~/.ssh/id_ed25519.pub

	echo '------------------------------'
}


set -x
set -e

update_bashrc
setup_git
setup_vim
setup_tmux

# デーモン再起動の問い合わせをしない
#echo "\$nrconf{restart} = 'a';" | sudo tee -a /etc/needrestart/needrestart.conf > /dev/null

sudo apt-get update
sudo apt-get install -y build-essential autoconf automake libtool
sudo apt-get install -y zip unzip
sudo apt-get install -y direnv
sudo apt-get install -y npm  # LPS で必要

# docker
sudo apt-get install -y docker.io docker-compose-v2
sudo usermod -aG docker $USER
cp -r $DIR/.docker ~/

sudo apt-get install -y python3 python3-pip python3-venv python-is-python3
sudo apt-get install -y mysql-server mysql-client
sudo systemctl disable mysql.service
sudo systemctl stop mysql.service

# /tmp を tmpfs にマウント
sudo systemctl enable /usr/share/systemd/tmp.mount

mkdir src
gen_key

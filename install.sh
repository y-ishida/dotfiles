#/bin/sh

sudo apt-get install vim

sudo apt-get install git

# 公開鍵の生成
if ! [ -f ~/.ssh/id_rsa.pub ]; then
	ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
fi

# Vundleのインストール
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# .vimrcのシンボリックリンク生成
if [ -e ~/.vimrc ]; then
	mv ~/.vimrc ~/.vimrc.old
fi
ln -fs $(dirname $0)/.vimrc ~/.vimrc

# vimプラグインのインストール (Vundle)
vim +PluginInstall +qall

# 公開鍵の表示
echo
echo 'あなたの公開鍵↓'
echo '------------------------------'

cat ~/.ssh/id_rsa.pub

echo '------------------------------'

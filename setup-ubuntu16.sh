#! /bin/sh

cd

# Gitの初期設定
git config --global user.email "yusuke.ishida@gridraw.com"
git config --global user.name "Yusuke Ishida"

# VirtualBox でホストとファイル共有設定
sudo gpasswd -a yusuke vboxsf
ln -s /media/sf_onedrive onedrive

# urxvt のインストールと設定
sudo apt-get install rxvt-unicode-256color
sudo apt-get -y install fonts-ricty-diminished
ln -s dotfiles/.Xdefaults .Xdefaults

# byobu のブリンク無効化
byobu-disable-prompt

# xsel のインストール
sudo apt-get -y install xsel

# 不要なソフトの削除
sudo apt-get -y --purge remove libreoffice*
sudo apt-get -y --purge remove unity-webapps-*
sudo apt-get -y --purge remove gnome-mines gnome-sudoku gnome-mahjongg aisleriot
sudo apt-get -y --purge autoremove

# Node.js と Polymer のインストール
sudo apt-get -y install nodejs nodejs-legacy npm
sudo npm install -g polymer-cli

echo
echo "Urxvt で IM の on the spot 入力を有効にするには..."
echo "  Fcitx設定 -> アドオン -> 拡張 -> Fcitx XIM Frontend"
echo "  「XIM で On The Spot スタイルを使う」をチェック"
echo


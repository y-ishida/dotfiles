#!/bin/sh

DIR=$(cd $(dirname $0); pwd)
SRC=~/src

planex_drv_name=gw-450d_katana_driver_linux_v3002
mediatek_drv_name=mt7610u_wifi_sta_v3002_dpo_20130916

# make and install from source code
if ! [ -e $SRC ]; then
	mkdir $SRC
fi

cd $SRC

if [ -e $planex_drv_name ]; then
	rm -rf $planex_drv_name
fi

# ソースを展開
cp $DIR/$planex_drv_name.zip .
unzip $planex_drv_name.zip
cd $planex_drv_name

tar xjvf $mediatek_drv_name.tar.bz2
cd $mediatek_drv_name

# ネットワークマネージャからWPAを使う為の設定
#   HAS_WPA_SUPPLICANT と HAS_NATIVE_WPA_SUPPLICANT_SUPPORT を n -> y へ変更
sed -i -r \
	-e 's/(HAS_WPA_SUPPLICANT)=.*/\1=y/' \
	-e 's/(HAS_NATIVE_WPA_SUPPLICANT_SUPPORT)=.*/\1=y/' \
	os/linux/config.mk

# ベンダーIDとプロダクトIDの追加
sed -i -r \
	-e '/MT76x0/a\	{USB_DEVICE(0x2019,0xab31)},' \
	common/rtusb_dev_id.c

make

# ドライバオブジェクトファイルのコピー
chmod 644 os/linux/mt7650u_sta.ko
sudo cp os/linux/mt7650u_sta.ko /lib/modules/`uname -r`/kernel/drivers/net/wireless/

# 設定ファイルの変更
sed -i -r \
	-e 's/(CountryRegion)=.*/\1=1/' \
	-e 's/(CountryCode)=.*/\1=JP/' \
	-e 's/(SSID)=.*/\1=/' \
	RT2870STA.dat

# 設定ファイルのコピー
sudo mkdir -p /etc/Wireless/RT2870STA
sudo cp RT2870STA.dat /etc/Wireless/RT2870STA/

# 依存関係の更新
sudo depmod -a


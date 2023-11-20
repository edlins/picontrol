echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
ln -fs /usr/share/zoneinfo/US/Mountain /etc/localtime
dpkg-reconfigure --frontend noninteractive tzdata
dd if=/dev/zero of=/swap bs=1M count=512 && mkswap /swap
echo "/swap none swap sw 0 0" >> /etc/fstab
/usr/bin/apt-get -y --no-install-recommends install raspi-copies-and-fills
/usr/bin/apt-get -y --no-install-recommends install rng-tools
/usr/bin/apt-get -y --no-install-recommends install git-core

# broken
#wget https://raw.githubusercontent.com/edlins/pibuttonpower/master/netinst.sh
#/bin/bash netinst.sh
#rm netinst.sh

wget http://raw.githubusercontent.com/edlins/libPCA9685/develop/netinst.sh
/bin/bash netinst.sh
rm netinst.sh

wget https://raw.githubusercontent.com/edlins/libPCA9685/develop/examples/olaclient/netinst.sh
/bin/bash netinst.sh
rm netinst.sh

wget https://raw.githubusercontent.com/edlins/libPCA9685/develop/examples/audio/netinst.sh
/bin/bash netinst.sh
rm netinst.sh

cat << EOF > /etc/wpa_supplicant/wpa_supplicant.conf
network={
ssid="WPOD_2G"
psk="deadzone"
}
EOF
wget https://raw.githubusercontent.com/edlins/picontrol-netinst/master/wifi-netinst.sh
/bin/bash wifi-netinst.sh
systemctl restart networking.service
rm wifi-netinst.sh


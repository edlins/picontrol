#!/bin/sh

echo ""
echo "=== Adding rt2870 wifi ==="

# install firmware-misc-nonfree
echo ""
echo "= Adding firmware-misc-nonfree"
/usr/bin/apt-get -y --no-install-recommends install firmware-misc-nonfree

# install wpasupplicant
echo ""
echo "= Adding wpasupplicant"
/usr/bin/apt-get -y --no-install-recommends install wpasupplicant

# configure interfaces
echo ""
echo "= Configuring interface"
cat >> /etc/network/interfaces << EOF
auto wlan0
allow-hotplug wlan0
iface wlan0 inet dhcp
  wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
EOF

# copy the wpa_supplicant.conf from boot
echo ""
echo "= Configuring WPA"
ls -l /boot/raspberrypi-ua-netinst/config
cp -v /boot/raspberrypi-ua-netinst/config/wpa_supplicant.conf /etc/wpa_supplicant/

# enable wpa_supplicant
echo ""
echo "= Enabling wpa_supplicant"
systemctl enable wpa_supplicant

# fix bug # 838291
echo ""
echo "= Fixing wpa_supplicant"
cp -v functions.sh /etc/wpa_supplicant

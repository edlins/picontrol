#!/bin/sh

echo ""
echo "=== Adding rt2870 wifi ==="

# install firmware-misc-nonfree
echo "= Adding firmware-misc-nonfree"
/usr/bin/apt-get -y --no-install-recommends install firmware-misc-nonfree

# install wpasupplicant
echo "= Adding wpasupplicant"
/usr/bin/apt-get -y --no-install-recommends install wpasupplicant

# configure interfaces
cat >> /etc/network/interfaces << EOF
auto wlan0
allow-hotplug wlan0
iface wlan0 inet dhcp
  wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf

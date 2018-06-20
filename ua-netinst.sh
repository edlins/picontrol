#!/bin/sh

# helper script to burn an image to /dev/mmcblk0 and add post-install.txt
# call with a {raspberrypi,raspbian}-ua-netinst.*.img.xz compressed image file like:
#   $ sudo ./ua-netinst.sh raspberrypi-ua-netinst-git-13a6782.img.xz
# this will destroy all data on the SD card!

if [ $# -ne 1 -a $# -ne 3 ]; then
  echo "usage:"
  echo "  $0 image"
  echo "  $0 image SSID PSK"
  echo "where:"
  echo "  image is a xz compressed ua-netinst sdcard image to write to /dev/mmcblk0"
  echo "  SSID is the ssid of a Wi-Fi AP"
  echo "  PSK is the psk of the given ssid"
  exit 1
fi

if [ ! -e /dev/mmcblk0 ]; then
  echo "/dev/mmcblk0 does not exist!"
  exit 1
fi

umount /dev/mmcblk0p1
umount /dev/mmcblk0p2

echo "delete the first two partitions (if they exist)"
fdisk /dev/mmcblk0 << EOF1
d
2
d
1
w
EOF1

echo "writing $1 to /dev/mmcblk0"
xzcat -c $1 > /dev/mmcblk0

echo "run fdisk again to force the new partition table into effect"
fdisk /dev/mmcblk0 << EOF2
w
EOF2
mount /dev/mmcblk0p1 /mnt/tmp

# raspberrypi-ua-netinst uses /raspberrypi-ua-netinst/config/post-install.txt
# raspbian-ua-netinst uses /post-install.txt
cd /mnt/tmp/raspberrypi-ua-netinst/config || cd /mnt/tmp

echo "fetch the master branch post-install.txt"
wget https://raw.githubusercontent.com/edlins/picontrol-netinst/master/post-install.txt

if [ $# -eq 3 ]; then
  echo "preconfiguring wpa_supplicant.conf with wifi info"
  cat << EOF >> /mnt/tmp/wpa_supplicant.conf
network={
    ssid="$2"
    psk="$3"
}
EOF
fi
sleep 1

# unmount
cd /
umount /dev/mmcblk0p1

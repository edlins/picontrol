Copyright (c) 2018 by Scott Edlin

# picontrol-netinst
Automated unattended installs of Raspbian customized for my RPi projects

This project consists of a single file intended to be used with [`raspbian-ua-netinst`](https://github.com/debian-pi/raspbian-ua-netinst) or [`raspberrypi-ua-netinst`](https://github.com/FooDeas/raspberrypi-ua-netinst).

Follow the installations instructions to lay a `netinst` image on a SD card.
Then, follow the instructions at the top of `post-install.txt`.

Alternately, run the included ua-netinst.sh helper script with an image for a parameter like
```
sudo ./ua-netinst.sh ./raspberrypi-ua-netinst-git-13a6782.img.xz
```
Then load the SD card in the unpowered RPi, connect it to ethernet, power it on, wait 30 minutes, and play!

Once that's all done, you should have a fresh, updated Raspbian install on a DHCP address accessible via SSH or the console.
Simply ssh to the IP address and login with `root:raspbian` and change the root password.  Currently `raspberrypi-ua-netinst` installs Raspbian stretch and `raspbian-ua-netinst` installs Raspbian jessie.

The EXTRAS are all downloaded and installed in subfolders of `/usr/local/`.

# Wi-Fi
When using the `raspberrypi-ua-netinst` to install `stretch`, Wi-Fi is not enabled by default during or after install.

## To enable Wi-Fi *after* install:
- `apt-get install firmware-misc-nonfree` (loads misc firmware, inc `/usr/lib/rt2870.bin`)
- `apt-get install iw` (loads `iw` for managing wireless devices and connections)
- `ifconfig wlan0 up` (brings the interface up)
- `iw dev wlan0 connect <SSID> key 0:<passphrase>` (connects to an AP)

## To perform the install over Wi-Fi:
- image your SD card with a `raspberrypi-ua-netinst` release
- `mount /dev/mmcblk0p1 /mnt`
- `vi /mnt/raspberrypi-ua-netinst/config/installer-config.txt` and add: `ifname=wlan0`(change network interface to wlan0)
- `vi /mnt/raspberrypi-ua-netinst/config/wpa_supplicant`and add:
```
network={
 ssid="YYYYY"
 psk="XXXXX"
 key_mgmt=WPA-PSK
}
```
(add ssid and psk)
- `umount /dev/mmcblk0p1`

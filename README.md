## Description

An open source picture frame project built upon a Raspberry Pi Zero. This was initially built/started as a project for two young friends of mine, who are not technically minded. All being well, it should be an easy method for someone interested in Raspberry Pi to make a system that a non-technical person can use.

### Installing

Take a fresh SD card and use the Raspberry Pi imaging tools to install Raspbian Stretch on it.

Boot it up, and log in with the default user and password, 'pi' and 'raspberry'

Initially, use raspi-config to set the following options and get internet access.

```
sudo raspi-config
```
Use option 2 "Network Options" to enable wifi and connect the pi to your wifi.

Wait a moment and then it should be connected to the internet.

Exit raspi-config and install git with the following command

```
sudo apt update ; sudo apt install -y git
```

Clone this software to the Pi's home directory with the following command

```
git clone https://github.com/kylegordon/pictureframe ~/PicturePi/
```

You can then cd into the directory and run the following command to install the software

```
cd ~/PicturePi/
sudo ./install.sh
```

```
sudo raspi-config nonint do_ssh 0 # Enable SSH
```



## Goals

- Scheduler (Incomplete) - turn the display on and off at scheduled times.
- Smart Reloading (Incomplete) - reload the slideshow application when the USB stick is inserted.

### Gadget Mode
Gadget mode permits TCP/IP over USB. There may be times where the Pi Zero is inaccessible to a regular computer. By providing gadget mode, it can simply be plugged into the computer.

## Notes

Things to customize after install
Access Point name, in /etc/hostapd/hostapd.conf

To determine firmware version, use sudo /opt/vc/bin/vcgencmd version

Some good info on using livestream to do youtube streaming, etc at https://www.instructables.com/Live-Picture-Frame-With-Raspberry-PI/

### Using Gadget Mode
#### Ubuntu
Plug the Raspberry Pi Zero USB connector into your computer as normal.
Go into Network Settings
Click on gear icon for the 'Netchip Ethernet' connection
Select IPv4 tab
Select Shared to other computers
Click Apply

After a few moments, the Pi will have an address likely in the 10.42.0.0 range.
If MDNS is still configured correctly, it will also be available under the .local domain, such as pictureframe.local

### Scheduler
Reboot every morning. Absorb into Pi user crontab later.
sudo cp ~/PicturePi/cronjobs/morning_reboot /etc/cron.d/morning_reboot
Import crontab as Pi user
crontab ~/PicturePi/cronjobs/on_off_schedule

### Reloading
Place the inotify watcher into systemd
sudo cp inotify.service /etc/systemd/system/

### Longevity
Use something to maintain a read-only SD card
http://blog.pi3g.com/2014/04/make-raspbian-system-read-only/

https://www.raspberrypi.org/blog/adafruits-read-only/

###  Quirks
My current home set up has this fstab entry due to pictures being stored on the central server
echo '172.24.32.5:/srv/nfs4/store/home/Pictures/PictureFrames/ /home/pi/Pictures/ nfs defaults,_netdev,vers=4,async 0 0' | sudo tee -a /etc/fstab

### Todo

Improve the non-interactive setup part - https://github.com/kylegordon/PictureFrame/tree/noninteractive-raspi-config
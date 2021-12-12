## Description

An open source picture frame project built upon a Raspberry Pi Zero. This was initially built/started as a project for two young friends of mine, who are not technically minded. All being well, it should be an easy method for someone interested in Raspberry Pi to make a system that a non-technical person can use.
## Goals

- Bluetooth Support (Complete) - send files to the picture frame directly from an Android or Windows device
- Airdrop Support (Incomplete) - send files to the picture frame directly from an Apple device
- Access Point (Complete) - connect to the device and use a web based interface to manage existing files
- Scheduler (Incomplete) - turn the display on and off at scheduled times.
- Smart Reloading (Incomplete) - reload the slideshow application when a new file is uploaded.
- Gadget Mode - access to the Pi by TCP/IP over the USB interface.

### Bluetooth Support
Desirable in order to provide an easy to use method of sending files to the device, without having to connect wirelessly.
Sending of files has been tested from Android devices and works as expected.
### Airdrop Support
Desirable in order to provide an easy to use method of sending files to the device, without having to connect wirelessly.
This is the only way of sending files natively in the Apple ecosystem.
### Access Point
Rather than assuming access to someone elses home wifi, take the stance of providing an open access point to connect to. Use DNS capture and redirection to trigger the captive portal detection and offer up a management page such that existing files can be manipulated, such as rotation, renaming, deletion.
### Gadget Mode
Gadget mode permits TCP/IP over USB. Since the device will often exist in station mode (access point), there may be times where the Pi Zero is inaccessible to a regular computer. By providing gadget mode, it can simply be plugged into the computer.



## Notes

Things to customize after install
Access Point name, in /etc/hostapd/hostapd.conf

To determine firmware version, use sudo /opt/vc/bin/vcgencmd version

Some good info on using livestream to do youtube streaming, etc at https://www.instructables.com/Live-Picture-Frame-With-Raspberry-PI/

### Installing
I think the picture frame needed lightdm or lxde installed....

Initially, use sudo raspi-config to set the following options

See https://github.com/kylegordon/PictureFrame/tree/noninteractive-raspi-config

Hostname
Wireless details
Enable wait for network

git clone https://github.com/kylegordon/pictureframe ~/PicturePi/

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

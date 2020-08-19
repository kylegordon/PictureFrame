# Sort of an executable README for now.
# Probably best to move all the pictures to a dedicated directory on the home server, and then have it mounted over NFS.
# I think the picture frame needed lightdm or lxde installed....

# Initially, use sudo raspi-config to set the following options

#Hostname
#Wireless details
#Enable wait for network


sudo apt-get update
sudo apt-get install -y nfs-common openssh-server
sudo /etc/init.d/ssh restart
sudo apt-get install -y feh lightdm raspberrypi-ui-mods watchdog vim

#cp pictureframe.desktop /etc/xdg/autostart/

sudo cp ~/PicturePi/autostart /etc/xdg/lxsession/LXDE/autostart
sudo cp ~/PicuturePi/autostart /etc/xdg/lxsession/LXDE-pi/autostart
sudo cp ~/PicturePi/pictureframe.desktop /etc/xdg/autostart/

echo '172.24.32.5:/srv/nfs4/store/home/Pictures/PictureFrames/ /home/pi/Pictures/ nfs defaults,_netdev,vers=4,async 0 0' | sudo tee -a /etc/fstab

# Use sudo raspi-config again to enable auto-login to desktop

30 8 * * 1-5 /usr/bin/tvservice -p && sleep 10 && DISPLAY=:0.0 /usr/bin/xset -dpms 2>&1
30 16 * * 1-5 /usr/bin/tvservice -o 2>&1

# Use something to maintain a read-only SD card
http://blog.pi3g.com/2014/04/make-raspbian-system-read-only/

https://www.raspberrypi.org/blog/adafruits-read-only/

All the scheduling guff below should really be done through home-assistant, by sharing a SSH key and having scripts that remote in and run these commands directly.

Crontab contents
################

# TBH, this should be automated through home-assistant

# On all weekend
0 7 * * 6-7 /usr/bin/tvservice -p && sleep 10 && DISPLAY=:0.0 /usr/bin/xset -dpms 2>&1
30 23 * * 6-7 /usr/bin/tvservice -o 2>&1

# On in the morning during the work week
0 7 * * 1-5 /usr/bin/tvservice -p && sleep 10 && DISPLAY=:0.0 /usr/bin/xset -dpms 2>&1
30 8 * * 1-5 /usr/bin/tvservice -o 2>&1

# On all evening during the work week
30 17 * * 1-5 /usr/bin/tvservice -p && sleep 10 && DISPLAY=:0.0 /usr/bin/xset -dpms 2>&1
30 23 * * 1-5 /usr/bin/tvservice -o 2>&1

Also, in /etc/cron.d/morning_reboot

0 7 * * * root /sbin/reboot


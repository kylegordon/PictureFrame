# Sort of an executable README for now.
# Probably best to move all the pictures to a dedicated directory on the home server, and then have it mounted over NFS.
# I think the picture frame needed lightdm or lxde installed....

# Initially, use sudo raspi-config to set the following options

#Hostname
#Wireless details
#Enable wait for network


sudo apt-get update
sudo apt-get install -y git \
                        inotify-tools \
                        nfs-common \
                        openssh-server \
                        wget \
                        lighttpd \
                        php-fpm \
                        php-gd \
                        php-cgi \
                        feh \
                        lightdm \
                        raspberrypi-ui-mods \
                        watchdog \
                        vim
sudo apt-get remove --purge xscreensaver xscreensaver-data
sudo /etc/init.d/ssh restart


git clone https://github.com/kylegordon/pictureframe ~/PicturePi/

# Place the inotify watcher into systemd
sudo cp inotify.service /etc/systemd/system/

sudo cp ~/PicturePi/autostart /etc/xdg/lxsession/LXDE/autostart
sudo cp ~/PicturePi/autostart /etc/xdg/lxsession/LXDE-pi/autostart
sudo cp ~/PicturePi/pictureframe.desktop /etc/xdg/autostart/

# Should do the same job as setting raspi-config autologin to Graphical Pi Desktop
sudo rm /etc/systemd/system/default.target
sudo ln -s /lib/systemd/system/graphical.target /etc/systemd/system/default.target

echo '172.24.32.5:/srv/nfs4/store/home/Pictures/PictureFrames/ /home/pi/Pictures/ nfs defaults,_netdev,vers=4,async 0 0' | sudo tee -a /etc/fstab

# Reboot every morning. Absorb into Pi user crontab later.
sudo cp ~/PicturePi/cronjobs/morning_reboot /etc/cron.d/morning_reboot
# Import crontab as Pi user
crontab ~/PicturePi/cronjobs/on_off_schedule

# Use something to maintain a read-only SD card
http://blog.pi3g.com/2014/04/make-raspbian-system-read-only/

https://www.raspberrypi.org/blog/adafruits-read-only/

All the scheduling guff below should really be done through home-assistant, by sharing a SSH key and having scripts that remote in and run these commands directly.

# Things to customize after install
# Access Point name, in /etc/hostapd/hostapd.conf

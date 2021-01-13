# Sort of an executable README for now.
# Probably best to move all the pictures to a dedicated directory on the home server, and then have it mounted over NFS.
# I think the picture frame needed lightdm or lxde installed....

# Initially, use sudo raspi-config to set the following options

#Hostname
#Wireless details
#Enable wait for network

TFMVER=2.4.3

sudo apt-get update
sudo apt-get install -y git
git clone https://github.com/kylegordon/pictureframe ~/PicturePi/
sudo apt-get install -y nfs-common openssh-server wget nginx php-fpm
sudo /etc/init.d/ssh restart
sudo apt-get install -y feh lightdm raspberrypi-ui-mods watchdog vim
sudo apt-get remove --purge xscreensaver xscreensaver-data

sudo systemctl restart php7.3-fpm.service

wget https://github.com/prasathmani/tinyfilemanager/archive/${TFMVER}.tar.gz -O /tmp/tinyfilemanager.tar.gz
tar -zxvf /tmp/tinyfilemanager.tar.gz --directory /tmp/
sudo mv /tmp/tinyfilemanager-${TFMVER}/* /var/www/html/

sudo cp ~/PicturePi/autostart /etc/xdg/lxsession/LXDE/autostart
sudo cp ~/PicturePi/autostart /etc/xdg/lxsession/LXDE-pi/autostart
sudo cp ~/PicturePi/pictureframe.desktop /etc/xdg/autostart/
sudo cp ~/PicturePi/nginx-site.conf /etc/nginx/sites-available/default

echo '172.24.32.5:/srv/nfs4/store/home/Pictures/PictureFrames/ /home/pi/Pictures/ nfs defaults,_netdev,vers=4,async 0 0' | sudo tee -a /etc/fstab

# Use sudo raspi-config again to enable auto-login to desktop

sudo cp ~/PicturePi/cronjobs/morning_reboot /etc/cron.d/morning_reboot
sudo cp ~/PicturePi/cronjobs/on_off_schedule /etc/cron.d/on_off_schedule

# Use something to maintain a read-only SD card
http://blog.pi3g.com/2014/04/make-raspbian-system-read-only/

https://www.raspberrypi.org/blog/adafruits-read-only/

All the scheduling guff below should really be done through home-assistant, by sharing a SSH key and having scripts that remote in and run these commands directly.


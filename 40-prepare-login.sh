# Place relevant symlinks to enable autostart of LXDE
sudo cp ~/PicturePi/autostart /etc/xdg/lxsession/LXDE/autostart
sudo cp ~/PicturePi/autostart /etc/xdg/lxsession/LXDE-pi/autostart
sudo cp ~/PicturePi/pictureframe.desktop /etc/xdg/autostart/

# Should do the same job as setting raspi-config autologin to Graphical Pi Desktop
sudo rm /etc/systemd/system/default.target
sudo ln -s /lib/systemd/system/graphical.target /etc/systemd/system/default.target

# Enable autologin for user. Can only be done once lightdm is installed.
sudo raspi-config nonint do_boot_behaviour B4 # Enable GUI and autologin
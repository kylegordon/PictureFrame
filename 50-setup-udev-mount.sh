# Courtesy of https://www.andreafortuna.org/2019/06/26/automount-usb-devices-on-linux-using-udev-and-systemd/

sudo cp udev/usb-mount.sh /usr/local/bin/usb-mount.sh
sudo chmod +x /usr/local/bin/usb-mount.sh
sudo cp udev/usb-mount@.service /etc/systemd/system/usb-mount@.service
sudo systemctl daemon-reload
sudo systemctl enable usb-mount@.service
sudo systemctl start usb-mount@.service

sudo cp udev/99-local.rules /etc/udev/rules.d/99-local.rules
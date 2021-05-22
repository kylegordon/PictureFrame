sudo apt-get -y install obexpushd

sudo systemctl stop bluetooth
sudo cp bluetooth-configs/bluetooth-compat.conf /etc/systemd/system/bluetooth.service.d/compat.conf
sudo systemctl daemon-reload
sudo systemctl start bluetooth

sudo bluetoothctl <<EOF
power on
discoverable on
pairable on
EOF

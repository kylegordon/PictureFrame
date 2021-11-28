sudo apt-get -y install obexpushd

sudo systemctl stop bluetooth
sudo cp bluetooth-configs/bluetooth-compat.conf /etc/systemd/system/bluetooth.service.d/compat.conf
sudo cp bluetooth-configs/obexpushd.service /etc/systemd/system/obexpushd.service
sudo systemctl daemon-reload
sudo systemctl start bluetooth
sudo systemctl enable obexpushd; sudo systemctl start obexpushd

sudo bluetoothctl <<EOF
power on
discoverable on
pairable on
EOF

sudo cp feh/feh.service /etc/systemd/system/feh.service
sudo systemctl daemon-reload
sudo systemctl enable feh; sudo systemctl start feh
sudo apt-get -y install dnsmasq hostapd

# Allow hostapd to start on bootup
sudo systemctl unmask hostapd
sudo systemctl enable hostapd

sudo cp network-configs/dnsmasq.conf /etc/dnsmasq.conf
sudo cp network-configs/hostapd.conf /etc/hostapd/hostapd.conf

# Prevent dhcpcd from calling wpa_supplicant on the interface
cat << EOF > /etc/dhcpcd.conf
interface wlan0
  static ip_address=192.168.1.1/24
  nohook wpa_supplicant
EOF
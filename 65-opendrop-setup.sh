sudo apt-get install raspberrypi-kernel-headers git libgmp3-dev gawk qpdf bison flex make autoconf
sudo apt-get remove --purge wpasupplicant # Maybe use this instead? - sudo systemctl mask wpa_supplicant ; sudo systemctl stop wpa_supplicant.service

./build-nexmon.sh
./build-owl.sh
./install-opendrop.sh
./run-opendrop.sh
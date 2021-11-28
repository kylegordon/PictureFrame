sudo apt install libpcap-dev libev-dev libnl-3-dev libnl-genl-3-dev libnl-route-3-dev

git clone https://github.com/seemoo-lab/owl.git
cd owl
git submodule update --init
mkdir build
cd build
cmake ..
make
sudo make install
## Mostly sourced from https://owlink.org/2019/05/16/howto-use-airdrop-on-raspberry-pi-3.html
## and https://github.com/seemoo-lab/nexmon/blob/master/README.md

cd ~
git clone https://github.com/seemoo-lab/nexmon.git --depth=1
cd nexmon
touch DISABLE_STATISTICS

if [[ ! -f /usr/lib/arm-linux-gnueabihf/libisl.so.10 ]]; then \
   cd buildtools/isl-0.10/ && ./configure && make && make install && \
   ln -s /usr/local/lib/libisl.so \
         /usr/lib/arm-linux-gnueabihf/libisl.so.10 && \
   cd ../../ ; fi

source setup_env.sh
make
cd utilities/nexutil/ && make && make install && cd ../../

# Build and install monitor mode firmware patch
cd patches/bcm43430a1/7_45_41_46/nexmon/

ln -s /usr/lib/arm-linux-gnueabihf/libmpfr.so.6 /usr/lib/arm-linux-gnueabihf/libmpfr.so.4

make
make backup-firmware
make install-firmware

## Notes ##
## Remove wifi module with 
# rmmod brcmfmac
# modprobe brcmfmac

path                                            source                  size
/lib/firmware/brcm/brcmfmac43430-sdio.bin       firmware-brcm80211      400447
/lib/firmware/brcm/brcmfmac43430-sdio.bin
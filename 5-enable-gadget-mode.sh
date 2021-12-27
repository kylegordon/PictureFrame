#!/bin/bash

if [ -f /sys/kernel/debug/usb/gadget/g1/UDC ]; then
    echo "gadget" > /sys/kernel/debug/usb/gadget/g1/UDC
elif [ -f /sys/kernel/debug/usb/gadget/g1/functions/rndis.usb0/os_desc/b_vendor_code ]; then
    echo "rndis" > /sys/kernel/debug/usb/gadget/g1/functions/rndis.usb0/os_desc/b_vendor_code
fi

patch -d /boot/ < config.stretch.patch

# Use sed to append, not overwrite, the following to the end of /boot/config.txt
# PARTUUID changes with every install, so patch/diff will never work
sudo sed '$s/$/ modules-load=dwc2,g_ether/' /boot/cmdline.txt

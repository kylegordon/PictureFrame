#!/bin/bash

if lsb_release -c | grep -q stretch; then
    echo "Patching for stretch"
    patch -d /boot/ < config.stretch.patch
elif lsb_release -c | grep -q bullseye; then
    echo "Patching for bullseye"
    patch -d /boot/ < config.bullseye.patch
else
    echo "Unknown distro, not patching"
fi

# Use sed to append, not overwrite, the following to the end of /boot/config.txt
# PARTUUID changes with every install, so patch/diff will never work
sudo sed '$s/$/ modules-load=dwc2,g_ether/' /boot/cmdline.txt

#!/bin/bash

if grep -q "dtoverlay=dwc2" /boot/config.txt; then
    echo "Gadget mode already enabled"
else
    echo "Enabling gadget mode : patching config.txt"
    if lsb_release -c | grep -q stretch; then
        echo "Patching for stretch"
        sudo patch -d /boot/ < config.stretch.patch
    elif lsb_release -c | grep -q bullseye; then
        echo "Patching for bullseye"
        sudo patch -d /boot/ < config.bullseye.patch
    else
        echo "Unknown distro, not patching"
    fi
fi

if grep -q "modules-load=dwc2,g_ether" /boot/cmdline.txt; then
    echo "Gadget mode already enabled"
else
    echo "Enabling gadget mode : patching cmdline.txt"
    # Use sed to append, not overwrite, the following to the end of /boot/config.txt
    # PARTUUID changes with every install, so patch/diff will never work
    sudo sed -i '$s/$/ modules-load=dwc2,g_ether/' /boot/cmdline.txt
fi


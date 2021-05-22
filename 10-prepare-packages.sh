sudo apt-get update
sudo apt-get install -y git \
                        inotify-tools \
                        nfs-common \
                        openssh-server \
                        wget \
                        lighttpd \
                        php-fpm \
                        php-gd \
                        php-cgi \
                        feh \
                        lightdm \
                        raspberrypi-ui-mods \
                        watchdog \
                        vim

# Remove xscreensaver so that it doesn't take over the screen
sudo apt-get remove --purge xscreensaver xscreensaver-data pulseaudio
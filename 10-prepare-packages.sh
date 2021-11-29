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
                        vim \
                        build-essential \
                        cmake\
                        bison

# Remove xscreensaver so that it doesn't take over the screen
sudo apt-get remove --purge xscreensaver xscreensaver-data \
                            pulseaudio libpulse0 pulseaudio-utils \
                            cups cups-browsed cups-client cups-core-drivers cups-daemon cups-filters cups-filters-core-drivers cups-ipp-utils cups-server-common cups-common cups-pk-helper cups-ppdc python3-cups
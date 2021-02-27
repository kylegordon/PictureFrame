cp lighttpd-configs/15-fastcgi-php.conf /etc/lighttpd/conf-available/15-fastcgi-php.conf

lighttpd-enable-mod fastcgi
lighttpd-enable-mod fastcgi-php

service lighttpd force-reload
systemctl restart php7.3-fpm.service
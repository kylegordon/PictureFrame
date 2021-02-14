#!/usr/bin/env bash

## The target and source can contain spaces as long as they are quoted.
source="/var/www/html/Pictures/schedule.txt";
target="/etc/cron.d/schedule"

while true; do
  ## Watch for new files, the grep will return true if a file has
  ## been copied, modified or created.
  inotifywatch -e modify -e create -e moved_to -t 1 "$source" 2>/dev/null | grep total &&

  ## The -u option to cp causes it to only copy files
  ## that are newer in $source than in $target. Any files
  ## not present in $target will be copied.
  cp -vu "$source" "$target"
done
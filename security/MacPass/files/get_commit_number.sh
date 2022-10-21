#!/bin/sh

/usr/bin/curl -s -I -k "https://api.github.com/repos/MacPass/MacPass/commits?per_page=1&tag=:@VERSION@" | /usr/bin/sed -n '/^[Ll]ink:/ s/.*"next".*page=\([0-9]*\).*"last".*/\1/p'

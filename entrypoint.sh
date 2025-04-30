#!/bin/bash
# start the CGI wrapper for git-http-backend
spawn-fcgi -s /var/run/fcgiwrap.socket -M 766 /usr/sbin/fcgiwrap

# launch nginx in foreground
exec nginx -g 'daemon off;'


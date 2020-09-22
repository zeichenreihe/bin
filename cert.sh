#!/bin/bash
#    Program to update certificate, with it the ip.
#    Copyright (C) 2020  Johannes Schmatz
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

## CONFIG ##
email="johannes_schmatz@gmx.de"
webroot="/srv/http"
file_on_server="cert_test.txt"
linkfile="link.html"
webroot_cert="/var/lib/letsencrypt/"

ssl_config_dir="/etc/httpd/conf/ssl"
ssl_config="certbot.conf"
name_config="server_name.conf"

verbose_var=1
## CODE ##
## SET VERBOSE FUNCTION

## SET VARIABLES
oldhostname="$1"
newhostname="$2"

## CODE
echo "=== CERTIFICATE IP CHANGE ==="
echo "== UPDATE CERTIFICATE =="
echo "Please choose the Hostname $oldhostname (normally 1):"
certbot delete
certbot certonly --email "$email" --webroot -w "$webroot_cert" -d "$newhostname"

## CREATE CONFIG FILES
echo
echo -n "== UPDATE CONFIG FILES =="
echo "ServerName ${newhostname}:80" > $ssl_config_dir/$name_config

echo "SSLCertificateFile /etc/letsencrypt/live/${newhostname}/fullchain.pem" > $ssl_config_dir/$ssl_config
echo "SSLCertificateKeyFile /etc/letsencrypt/live/${newhostname}/privkey.pem" >> $ssl_config_dir/$ssl_config
echo "... done."

## CREATE HTML LINK
echo -n "== CREATE HTML LINK =="
echo "<a href=\"https://${newhostname}/\">https</a>" > $webroot/$linkfile
echo "... done."

## RESTART HTTPD
echo -n "== RESTART HTTPD =="
systemctl restart httpd.service
echo "... done."

## CHECK IF ONLINE
echo
echo "== SYSTEMCTL REPORT =="
echo "Shows systemctl's state httpd.service:"
sleep 5
systemctl status httpd.service | head -8

if systemctl status httpd.service 2>/dev/null >/dev/null; then
	echo
	echo "== NMAP REPORT =="
	echo "Here you can see the open ports:"
	nmap -T 5 -A "$newhostname"
	echo "If port 443 is open everything is ok."
	if [[ ! -s "$webroot/$file_on_server" ]];
	then
		echo
		echo "== CURL ON A FILE =="
		echo "Creating file..."
		echo "File, to test if you can access the webserver." > $webroot/$file_on_server
		echo "Here you can see curls output from a file on the server:"
		curl "https://${newhostname}/$file_on_server" 2>/dev/null | cat
		rm $webroot/$file_on_server
	fi
fi

# syntax
# vim: ts=8 sts=8 sw=8 noet si syntax=bash

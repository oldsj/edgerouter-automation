#!/bin/bash

ad_list_url="http://pgl.yoyo.org/adservers/serverlist.php?hostformat=dnsmasq&showintro=0&mimetype=plaintext"
#The IP address below should point to the IP of your router or to 0.0.0.0
pixelserv_ip="0.0.0.0"
ad_file="/etc/dnsmasq.d/dnsmasq.adlist.conf"
temp_ad_file="/etc/dnsmasq.d/dnsmasq.adlist.conf.tmp"

curl -s $ad_list_url | sed "s/127\.0\.0\.1/$pixelserv_ip/" > $temp_ad_file

if [ -f "$temp_ad_file" ]
then
        #sed -i -e '/www\.favoritesite\.com/d' $temp_ad_file
        mv $temp_ad_file $ad_file
else
        echo "Error building the ad list, please try again."
        exit
fi

/etc/init.d/dnsmasq force-reload
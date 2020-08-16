#!/bin/bash

# LANBox installer script
# created by Alexander Voglsperger (c) 2020
# inspired by the PirateBox which was created by Matthias Strubel
# Project can be found on GitHub https://github.com/MrMinemeet/LANBox


scriptfile="$(readlink -f $0)"
CURRENT_DIR="$(dirname ${scriptfile})"

clear
echo -e '\E[0;30m'"\033[1m
 _     _____ _   _ ____
( )   (  _  ) ) ( )  _ \            
| |   | (_) |  \| | (_) )  _       
| |  _(  _  )     |  _ ( / _ \( \/ )
| |_( ) | | | | \ | (_) ) (_) ))  ( 
(____/(_) (_)_) (_)____/ \___/(_/\_)
\033[0m" 

# Check if script is run as root
if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root"
        exit 0
fi

# Check if packages are missing
DEPENDENT_PACKAGES="hostapd apache2 dnsmasq php net-tools python3"

if [ "$DEPENDENT_PACKAGES" != "" ]; then
  echo -n "Some dependencies may be missing. Would you like to install them? (Y/n): "
  read SURE

  # If user want to install missing dependencies
  if [[ $SURE = "Y" || $SURE = "y" ]]; then
    apt install $DEPENDENT_PACKAGES -y
    echo "Installed dependencies"
  fi
fi

LANBOX_CONFIG=/home/pi/LANBox/conf/lanbox.conf
if [ ! -f $LANBOX_CONFIG ] ; then
  echo "Config-File LANBOX_CONFIG not found..."
  exit 1
fi

#Load Config
. $LANBOX_CONFIG

# Setup AccessPoint
$LANBOX_PATH/Setup/setup_ap.sh $LANBOX_CONFIG


# Setup website
$LANBOX_PATH/Setup/setup_www.sh $LANBOX_CONFIG


#!/bin/bash

# Load Config
. $1

ORIG_WWW_FOLDER="/var"

if [ -z $WWW_FOLDER ]; then
    echo "No www folder found!"
    exit 1
fi

# remove default www folder
echo "Deleting original website folder"
# unlink $ORIG_WWW_FOLDER/www/
rm -rf $ORIG_WWW_FOLDER/www/

# add softlink to www folder of LANBox
echo "Linking LANBox website"
ln -s $WWW_FOLDER $ORIG_WWW_FOLDER

#Give permissions for webuser
chown -R pi:www-data $WWW_FOLDER
chmod -R 770 $WWW_FOLDER

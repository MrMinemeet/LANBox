#!/bin/bash

# Load Config
. $1

DNSMASQ_CONFIG=$CONFIG_FOLDER/dnsmasq.conf
DNSMASQ_DEFAULT_CONFIG=$CONFIG_FOLDER/dnsmasq_default.conf
HOSTS="$CONFIG_FOLDER/hosts"
HOSTAPD_CONFIG="$CONFIG_FOLDER/hostapd.conf"
HOSTS_DAEMON_CONFIG="/etc/default/hostapd"

generate_hosts(){
    hostname=$1
    ipv4=$2

    echo "$ipv4     $hostname " > $HOSTS
}

generate_dnsmasq(){
    net=$1
    ip_short=$2
    lease_start=$3
    lease_stop=$4
    lease_time=$5
    dnsmasq_interface=$6
    lease_file=$7

    echo "Generating dnsmasq.conf ..."
    
    echo "interface=$dnsmasq_interface"     > $DNSMASQ_CONFIG
    lease_line="$net.$lease_start,$net.$lease_stop,$lease_time"
    echo "dhcp-range=$lease_line"           >> $DNSMASQ_CONFIG
    echo "dhcp-leasefile=$lease_file"       >> $DNSMASQ_CONFIG
    echo "addn-hosts=$HOSTS"            >> $DNSMASQ_CONFIG
    
    echo "Generate link for dnsmasq"
    rm /etc/dnsmasq.conf
    ln -s $DNSMASQ_CONFIG /etc/dnsmasq.conf
}

generate_dnsmasq $NETWORK $IP_SHORT $DHCP_LEASE_START $DHCP_LEASE_STOP $LEASE_DURATION $INTERFACE $LEASE_LOC
generate_hosts $HOSTNAME $IP

# --- Check Config ---
if [ -z $IP ]; then
    echo "Please define IP in LANBOX.conf"
    exit 1
fi
if [ -z $INTERFACE ]; then
    echo "Please define interface in LANBOX.conf"
    exit 1
fi
if [ -z $NETMASK ]; then
    echo "Please define netmask in LANBOX.conf"
    exit 1
fi

# --- Set static IP for LANBox ---
# Bring up interface
echo "Bringing up wifi interface $INTERFACE"
ifconfig $INTERFACE up
if [ $? -ne 0 ]; then
    echo "failed...";
    exit 1
fi

# Setting IP in interface
echo "Setting up $INTERFACE"
# e.g.: ifconfig wlan0 192.168.2.1 netmask 255.255.255.0
ifconfig $INTERFACE $IP netmask $NETMASK
if [ $? -ne 0 ]; then
    echo "failed...";
    exit 1
fi

# Configure hostapd
echo "RUN_DAEMON=yes" >> $HOSTS_DAEMON_CONFIG
echo "DAEMON_CONF=\"$HOSTAPD_CONFIG\"" >> $HOSTS_DAEMON_CONFIG

# Handle services
systemctl restart dhcpcd
systemctl restart dnsmasq
systemctl enable dnsmasq
systemctl unmask hostapd
systemctl start hostapd
systemctl enable hostapd

# Restart every service
systemctl restart dhcpcd
systemctl restart dnsmasq
systemctl restart hostapd
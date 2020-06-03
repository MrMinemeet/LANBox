import shutil, os, apt, sys


# Check if user is root
if os.geteuid() != 0:
    print("Please execute this script as root")
    sys.exit(0)

# Check if hostapd and dnsmasq is installed
#os.system('sudo apt update')
cache = apt.Cache()
if not cache['hostapd'].is_installed:
    # Is not installed --> install
    os.system('sudo apt install hostapd -y')

if not cache['dnsmasq'].is_installed:
    # Is not installed --> install
    os.system('sudo apt install dnsmasq -y')


# Configure DNSMASQ

# Enable DHCP daemon
with open('/etc/dhcpcd.conf', 'w') as f:
    f.write("""interface wlan1
static ip_address=192.168.2.1/24""")

# restart DHCP daemon
os.system('sudo systemctl restart dhcpcd')

# configure dhcp server using dnsmasq
# IP Range 192.168.2.100 - 192.168.2.200
# Lease time: 2h
with open('/etc/dnsmasq.conf', 'w') as f:
    f.write("""# DHCP-Server aktiv für WLAN-Interface
interface=wlan1

# DHCP-Server nicht aktiv für bestehendes Netzwerk
no-dhcp-interface=eth0

# IPv4-Adressbereich und Lease-Time
dhcp-range=192.168.2.100,192.168.2.200,255.255.255.0,2h

# DNS
dhcp-option=option:dns-server,192.168.2.1""")

# Restart DNSMASQ
os.system('sudo systemctl restart dnsmasq')

# Start DNSMASQ on startup
os.system('sudo systemctl enable dnsmasq')


# Configure AP with hostapd
with open('/etc/hostapd/hostapd.conf', 'w') as f:
    f.write("""# WLAN-Router-Betrieb

# Schnittstelle und Treiber
interface=wlan1
#driver=nl80211

# WLAN-Konfiguration
ssid=LANBox
channel=1
hw_mode=g
ieee80211n=1
ieee80211d=1
country_code=AT
wmm_enabled=1

# WLAN-Verschlüsselung
auth_algs=1
wpa=2
wpa_key_mgmt=WPA-PSK
rsn_pairwise=CCMP
wpa_passphrase=TheLanBox""")

# Set rights so only root has rights to read
os.system('sudo chmod 600 /etc/hostapd/hostapd.conf')

# Configure hostapd daemon
with open('/etc/default/hostapd', 'w') as f:
    f.write("""RUN_DAEMON=yes
DAEMON_CONF="/etc/hostapd/hostapd.conf""")

# start hostapd daemon
os.system("sudo systemctl unmask hostapd")
os.system("sudo systemctl start hostapd")
os.system("sudo systemctl enable hostapd")
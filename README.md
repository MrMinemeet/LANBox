# LANBox

## Maintainers / Collaborators
* [Alexander Voglsperger (MrMinemeet)](alexander.voglsperger@protonmail.com)

The LANBox creates a local wireless network to anonymously chat and share files.

## Info
This project does the following things:
* Setup wlan interface
* Setup hotspot functionallity (hostapd)
* Setup ip-address rent (dnsmasq)
* Setup an apache2 web-server
* Setup chat on `192.168.2.1/Chat`

## Stuff you need
* **Raspberry Pi**
You'll Raspberry Pi to run the LANBox on. This is a small PC, which can run off a powerbank. Here are the ones I'd recommend and the ones I think the project will most likly run on:
  * [Raspberry Pi 3b](https://amzn.to/30XMNyV)
  * [Raspberry Pi 3b+](https://amzn.to/2V3Zog5)
  * [Raspberry Pi 4 (2GB-Model)](https://amzn.to/2V3Zog5)
  * [Raspberry Pi 4 (4GB-Model)](https://amzn.to/2YkDaIE)

2. **Micro-SD Card**
Stores the operating system called [Raspberry Pi OS](https://www.raspberrypi.org/downloads/)

3. **5V USB power supply**
  * For the Pi 3b, 3b+ you'll need a power supply with a Micro-USB plug. Anyting with 2A will do it here.
  * For the Pi 4 you'll need a power supply with a USB-C plug [Official Powersupply](https://amzn.to/3dlqzJy)

4. **USB Flash Drive**
USB flash drive
Any USB flash drive that has decent speed and a decent capazity will do it. The flash drive will store the uploaded files.

5. **5V USB Powerbank *(optional)***
For mobile use you can connect the Raspberry Pi to a powerbank, so it can run without plugging it into the wall. I'd recommend something like this [Anker PowerCore](https://amzn.to/3eliWEu).
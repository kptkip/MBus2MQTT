# MBUS2MQTT

This Software is used to fetch your MBUS-Data from a heat counter of your heating system and provide it via MQTT to any SmartHome-System (IoBroker, Home Assistant, FHEM, etc.).


# Hardware
I use a MBus-Hat for my Raspberry Pi 3B:
https://www.hwhardsoft.de/deutsch/projekte/m-bus-rpi-hat/ (No Affiliate-Link )

![1723992566](https://github.com/user-attachments/assets/d5d31200-575d-4aed-9574-e47d216dae3d)
![meterbus-mbus-raspberry-pi](https://github.com/user-attachments/assets/3a89ec79-e142-4624-b257-46b7f90e96d0)



# Prerequisites: 
## UART(0) Configuration 
(While using a USB-MBUS Adapter this step is obsolete!)
```
  sudo raspi-config
  goto '3 Interfacing Options'
  goto 'I6 Serial Port'
  'Would you like a login shell to be accessible over serial?' --> NO
  'Would you like the serial port hardware to be enabled?' --> YES
  Finish raspi-config
  sudo echo "dtoverlay=disable-bt" | sudo tee -a /boot/config.txt
  sudo systemctl disable hciuart
  reboot
```
## Installation of libmbus (C++)
```
 sudo apt install git libtool autoconf cmake build-essential
 sudo apt-get install -y cmake
 sudo git clone https://github.com/rscada/libmbus.git
 cd libmbus
 sudo ./build.sh
 sudo make install
 cd bin
 sudo ln -s /usr/local/lib/libmbus.so.0 /usr/lib/libmbus.so.0
```
## Mosquitto Client
```
  sudo apt-get install mosquitto-clients
```
## libxml2-utils
```
  sudo apt-get installlibxml2-utils
```
# Disclaimer

This repository contains files for demonstration purposes only. Use the files on your own risk. I am not responsible for any damage!

# License

Script: [![CC BY-NC-SA 4.0][cc-by-nc-sa-shield]][cc-by-nc-sa]


This work is licensed under a
[Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License][cc-by-nc-sa].

[![CC BY-NC-SA 4.0][cc-by-nc-sa-image]][cc-by-nc-sa]

[cc-by-nc-sa]: http://creativecommons.org/licenses/by-nc-sa/4.0/
[cc-by-nc-sa-image]: https://licensebuttons.net/l/by-nc-sa/4.0/88x31.png
[cc-by-nc-sa-shield]: https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-lightgrey.svg

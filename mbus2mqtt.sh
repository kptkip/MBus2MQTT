#! /bin/bash
# Purpose: Fetch your MBUS-Data from heat counter of your heating system and provide it 
# via MQTT to any SmartHome-System (IoBroker, Home Assistant, FHEM, etc.) 
#
# Howto use:
#    Change data of your MQTT Server
#    Change MBUS data according to your MBUS-Master and MBUS Slave
#    I use the following device for my RaspberryPi: (https://www.hwhardsoft.de/deutsch/projekte/m-bus-rpi-hat/) 
#    Add Crontab entry like this:
#    */2 * * * *  /home/pi/mbus2mqtt.sh >/dev/null 2>&1
#
# (C) Alexander Marquart 2024
# ver. 0.1.0

######## Variables
TMPFILE=/tmp/mbus_output.xml

# MBus Settings
PRIMARY_ADDRESS=0 # Bus address of MBUS Slave
BAUDRATE=2400
DEVICE=/dev/serial0 

# MQTT Settings
MQTT_HOST=[IPADDRESS]
MQTT_PORT=1883
MQTT_USER=""
MQTT_PASS=""
MQTT_TOPIC=[MQTT-PREFIX]


######## Fetch MBus-Data and write into XML
/usr/local/bin/mbus-serial-request-data -b $BAUDRATE $DEVICE $PRIMARY_ADDRESS > $TMPFILE


######### Parse XML-Data

# MBusData
SerialNumber="$(echo "cat //MBusData/SlaveInformation/Id/text()" | xmllint --nocdata --shell $TMPFILE | sed '1d;$d')"
Vendor="$(echo "cat //MBusData/SlaveInformation/Manufacturer/text()" | xmllint --nocdata --shell $TMPFILE | sed '1d;$d')"
Product="$(echo "cat //MBusData/SlaveInformation/ProductName/text()" | xmllint --nocdata --shell $TMPFILE | sed '1d;$d')"
Medium="$(echo "cat //MBusData/SlaveInformation/Medium/text()" | xmllint --nocdata --shell $TMPFILE | sed '1d;$d')"

# DataRecord
Uptime="$(echo "cat //DataRecord[@id=10]/Value/text()" | xmllint --nocdata --shell $TMPFILE | sed '1d;$d')"
Power="$(echo "cat //DataRecord[@id=3]/Value/text()" | xmllint --nocdata --shell $TMPFILE | sed '1d;$d')"
Energy="$(echo "cat //DataRecord[@id=1]/Value/text()" | xmllint --nocdata --shell $TMPFILE | sed '1d;$d')"
FlowTemp="$(echo "cat //DataRecord[@id=7]/Value/text()" | xmllint --nocdata --shell $TMPFILE | sed '1d;$d')"
ReturnTemp="$(echo "cat //DataRecord[@id=8]/Value/text()" | xmllint --nocdata --shell $TMPFILE | sed '1d;$d')"
DeltaTemp="$(echo "cat //DataRecord[@id=9]/Value/text()" | xmllint --nocdata --shell $TMPFILE | sed '1d;$d')"
FlowVol="$(echo "cat //DataRecord[@id=5]/Value/text()" | xmllint --nocdata --shell $TMPFILE | sed '1d;$d')"
FlowVol2Liter=$((FlowVol / 60))


########## Publish to MQTT-Broker

# MBusData
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t $MQTT_TOPIC/SerialNumber -m "$SerialNumber"
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t $MQTT_TOPIC/Vendor -m "$Vendor"
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t $MQTT_TOPIC/Product -m "$Product"
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t $MQTT_TOPIC/Medium -m "$Medium"

# DataRecord
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t $MQTT_TOPIC/Uptime -m "$Uptime"
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t $MQTT_TOPIC/Leistung -m "$Power"
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t $MQTT_TOPIC/Energy -m "$Energy"
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t $MQTT_TOPIC/FlowTemp -m "$FlowTemp"
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t $MQTT_TOPIC/ReturnTemp -m "$ReturnTemp"
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t $MQTT_TOPIC/DeltaTemp -m "$DeltaTemp"
mosquitto_pub -h $MQTT_HOST -p $MQTT_PORT -t $MQTT_TOPIC/FlowVol -m "$FlowVol2Liter"

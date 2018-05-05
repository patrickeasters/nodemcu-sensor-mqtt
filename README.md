# nodemcu-sensor-mqtt
A project to report home alarm sensor status via MQTT using a [NodeMCU](https://github.com/nodemcu/nodemcu-firmware) development board.

## Hardware
This was a pretty simple build, using only a few components

* NodeMCU Development Board (can easily be found on [Amazon](https://www.amazon.com/HiLetgo-Version-NodeMCU-Internet-Development/dp/B010O1G1ES/) or [AliExpress](https://www.aliexpress.com/item/1PCS-Wireless-module-CH340-NodeMcu-V3-Lua-WIFI-Internet-of-Things-development-board-based-ESP8266/32665100123.html))

* Door sensors (any kind of switch will do)

## Firmware Requirements
This project runs using a customized NodeMCU firmware package from the [Cloud Build Service](http://nodemcu-build.com/). The following modules are needed:
* file
* gpio
* mqtt
* net
* node
* tmr
* uart
* wifi

## Configuration
**secrets.yaml** contains the WiFi SSID/PSK and the MQTT broker credentials. Use the secrets.yaml.example file as a base.

**config.yaml** contains GPIO pin/device mappings as well as some basic MQTT topic/payload configuration.

## Circuit Digram
The GPIO pins are configured with the weak internal pull-up resistor enabled. The switches are then connected to ground. When a switch is closed, the GPIO pin reads low.

![Circuit Diagram](https://raw.githubusercontent.com/patrickeasters/nodemcu-sensor-mqtt/master/extra/nodemcu-sensor_schem.png)

## MQTT
This code publishes a payload of open or closed to an individual topic for each sensor. The topic prefix, topic names, and payload are defined in config.yaml.

## Other Links
[Blog post](https://patrickeasters.com/integrating-existing-home-security-sensors-with-mqtt/)

[My full Home Assistant Configuration](https://github.com/patrickeasters/smart-house)

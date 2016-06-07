Nager.BathControl
==========

Activate the bath fan if humidity high. Small Webinterface to activate the fan over a responsive website with a json output for historical data.

#####Hardware
ESP8266, Aosong AM2302

#####Firmware
http://nodemcu-build.com/
Modules: DHT, file, GPIO, net, node, RTC time, timer, WiFi


#####Available commands
* **/config/70/10** set the humidity limits
* **/wlan/SSID/password** set wlan config for the home wlan
* **/command/fan/on** start the fan
* **/command/fan/off** stop the fan
* **/json** data in json format
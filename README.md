Nager.BathControl
==========

Activate the bath fan if humidity high. Small responsive Webinterface to check humidity, temperature, activate the fan, get json output for historical data.

##### Hardware
ESP8266, Aosong AM2302

##### Firmware
http://nodemcu-build.com/
Modules: DHT, file, GPIO, net, node, RTC time, timer, WiFi


##### Available commands
* **/config/70/10** set the humidity limits
* **/wlan/SSID/password** set wlan config for the home wlan
* **/command/fan/on** start the fan
* **/command/fan/off** stop the fan
* **/json** data in json format


##### JSON Example
```json
{
	"humidity": 62.3,
	"temperature": 24.5,
	"sensorState": "ready",
	"uptime": 28293,
	"treshold": 60,
	"hysteresis": 10,
	"fanActive": true,
	"heap": 16000
}
```

### Alternative
[Sonoff TH10/TH16](https://www.itead.cc/smart-home/sonoff-th.html)

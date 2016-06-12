dofile("Humidity.lua")
dofile("Webserver.lua")
dofile("Dnsserver.lua")
dofile("Wifi.lua")

--gpio
dhtpin = 3
fanpin = 4

--fan
fanState = 0
fanLastRun = 0
fanTimeout = 120

----humidity sensor
sensorState = "unknown"
dhttemp = 0
dhthum = 0

--humidity 	threshold
logichumtreshold = 60
logichumhysteresis = 10

--wlan password for accesspoint
wlanpassword = "password"

--default dns answer
--captive portal‏ the same as setip->ip
dns_ip = "\192\168\230\1"

function startSystem()
	print('start controller')

	initGpio()

	rtctime.set(0)

	print('start wifi')
	wifi.setmode(wifi.STATIONAP)
	wifi.ap.config({ssid="BathControl", pwd=wlanpassword, auth=wifi.AUTH_WPA2_PSK})
	wifi.ap.setip({ip="192.168.230.1", netmask="255.255.255.0", gateway="192.168.230.1"})
	wifi.ap.dhcp.config({start="192.168.230.10"})

	print('start webserver')
	startWebserver()
	print('start dnsserver')
	startDnsServer();

	tmr.alarm(1, 2000, tmr.ALARM_AUTO, function() readDht() end)
	tmr.alarm(2, 10000, tmr.ALARM_AUTO, function() logic() end)
end

startSystem()

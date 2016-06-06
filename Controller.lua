	("Humidity.lua")
	("Webserver.lua")
	("Wifi.lua")

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

function startSystem()
	print('start controller')

	initGpio()

	rtctime.set(0)

	print('start wifi')
	wifi.setmode(wifi.STATIONAP)
	wifi.ap.config({ssid="BathControl", pwd="password", auth=wifi.AUTH_WPA2_PSK})

	print('start webserver')
	startWebserver()

	tmr.alarm(1, 2000, tmr.ALARM_AUTO, function() readDht() end)
	tmr.alarm(2, 10000, tmr.ALARM_AUTO, function() logic() end)
end

startSystem()

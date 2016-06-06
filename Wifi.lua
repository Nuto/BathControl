function setWifi(ssid, password)
	wifi.sta.config(ssid, password)
	local status = wifi.sta.status()
	print(status)
end

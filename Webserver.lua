function startWebserver()
	srv = net.createServer(net.TCP, 10)
	srv:listen(80, function(conn)
		conn:on("receive", function(sck, payload)
			local path = parseRequest(payload)
			print(path)
			local status = "200 OK";
			local contenttype = "text/html"
			local response = nil;
			local cache = true
			
			if (path == "/") then
				response = getMainPage()
			elseif (path == "/json") then
				contenttype = "application/json"
				response = getJson()
			elseif (path == "/common.css") then
				contenttype = "text/css"
				response = loadFile("common.css")
			elseif (path == "/script.js") then
				contenttype = "text/javascript"
				response = loadFile("script.js")
			else
				local successful = executeCommand(path)
				if (successful) then
					cache = false
				else
					print("404 - " .. path)
					status = "404 Not Found";
					response = "page not found"
				end
			end
			
			local header = { }
			header[#header + 1] = 'HTTP/1.1 ' .. status
			header[#header + 1] = 'Content-Length: ' .. string.len(response)
			if (cache == false) then
				header[#header + 1] = 'Cache-Control: no-cache, no-store, must-revalidate'
				header[#header + 1] = 'Pragma: no-cache'
				header[#header + 1] = 'Expires: 0'
			end
			header[#header + 1] = 'Connection: close'
			header[#header + 1] = 'Content-Type: ' .. contenttype
			
			sck:send(table.concat(header," \r\n") .. "\r\n\r\n" .. response)
		end)
	end)
end

function loadFile(staticfile)
	file.open(staticfile)
	local chunk = file.read(1024)
	file.close()
	return chunk
end

function getMainPage()
	local t = { }
	t[#t + 1] = '<html>'
	t[#t + 1] = '<head>'
	t[#t + 1] = '<title>Bath Control</title>'
	t[#t + 1] = '<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">'
	t[#t + 1] = '<link rel="stylesheet" href="common.css">'
	t[#t + 1] = '</head>'
	t[#t + 1] = '<body>'
	t[#t + 1] = '<h1>Bath Control</h1>'
	t[#t + 1] = '<table class="primary">'
	t[#t + 1] = '<tr>'
	t[#t + 1] = '<td>' .. dhthum .. '</td><td>' .. dhttemp .. '</td>'
	t[#t + 1] = '</tr><tr>'
	t[#t + 1] = '<th>Humidity</th><th>Temperature</th>'
	t[#t + 1] = '</tr>'
	t[#t + 1] = '</table>'
	t[#t + 1] = '<table>'
	t[#t + 1] = '<tr>'
	t[#t + 1] = '<th>Sensor State</th><td>' .. sensorState .. '</td>'
	t[#t + 1] = '</tr><tr>'
	t[#t + 1] = '<th>Uptime</th><td>' .. rtctime.get() .. 's</td>'
	t[#t + 1] = '</tr><tr>'
	t[#t + 1] = '<th>Treshold</th><td>' .. logichumtreshold .. '</td>'
	t[#t + 1] = '</tr><tr>'
	t[#t + 1] = '<th>Hysteresis</th><td>' .. logichumhysteresis .. '</td>'
	t[#t + 1] = '</tr><tr>'
	t[#t + 1] = '<th>Fan State</th><td>' .. (fanState == 1 and 'on' or 'off')  .. '</td>'
	t[#t + 1] = '</tr>'
	t[#t + 1] = '</table>'
	t[#t + 1] = '<button onclick="command(\'fan/on\')">fanon</button>'
	t[#t + 1] = '<button onclick="command(\'fan/off\')">fanoff</button>'
	t[#t + 1] = '<script src="script.js"></script>'
	t[#t + 1] = '</body></html>'
	return table.concat(t, "\n")
end

function getJson()
	local t = { }
	t[#t + 1] = '{'
	t[#t + 1] = '"humidity": ' .. dhthum .. ','
	t[#t + 1] = '"temperature": ' .. dhttemp .. ','
	t[#t + 1] = '"sensorState": "' .. sensorState .. '",'
	t[#t + 1] = '"uptime": ' .. rtctime.get() .. ','
	t[#t + 1] = '"treshold": ' .. logichumtreshold .. ','
	t[#t + 1] = '"hysteresis": ' .. logichumhysteresis .. ','
	t[#t + 1] = '"fanActive": ' .. (fanState == 1 and 'true' or 'false')
	t[#t + 1] = '}'
	return table.concat(t, "\n")
end

function parseRequest(payload)
	local getLength = 4
	local indexOfGet = string.find(payload, 'GET', 1)
	if (indexOfGet == nil)
	then
		return nil
	end
	local indexOfHttp = string.find(payload, 'HTTP', indexOfGet + getLength)
	if (indexOfHttp == nil)
	then
		return nil
	end
	return string.sub(payload, indexOfGet + getLength, indexOfHttp - 1 - indexOfGet)	
end

function executeCommand(path)
	for p1, p2, p3 in string.gmatch(path, "(%w+)/(%w+)/(%w+)") do
		
		if (p1 == "command") then
			if (p2 == "fan") then
				if (p3 == "on") then
					setFan(1)
				elseif (p3 == "off") then
					setFan(0)
				end
			end
		elseif (p1 == "wlan") then
			setWifi(p2, p3)
			print(p2 .. "-" .. p3)
		elseif (p1 == "config") then
			logichumtreshold = tonumber(p2)
			logichumhysteresis = tonumber(p3)
		end
		
		return true
	end
	
	return false
end

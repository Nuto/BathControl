function handleDnsRequest(con, req)
	local ix = 13
	while (req:byte(ix) > 0) do
		ix = ix + 1 + req:byte(ix)
	end
	if ("\0\1" == req:sub(ix + 1, ix + 2)) then
		local id = req:sub(1, 2)
		local nr = req:sub(5, 6)
		local query = req:sub(13, ix)
		local class = req:sub(ix + 3, ix + 4)
		local resp = {id, "\129\128", nr, "\0\1\0\0\0\0", query,
						"\0\1", class, "\192\12\0\1", class,
						"\0\0\0\218\0\4", dns_ip};
		con:send(table.concat(resp))
	end
end

function startDnsServer()
	local s = net.createServer(net.UDP)
	s:on("receive", handleDnsRequest)
	s:on("sent", function(con) con:close(); con:listen(53); end)
	s:listen(53)
end
// By Author

function CAP.ViewScreen(data, caller, victim)
	local pnl = vgui.Create("DFrame")
	pnl:SetSize(ScrW()/1.15, ScrH()/1.15)
	pnl:SetPos(25,25)
	pnl:MakePopup()
	pnl:SetTitle( "Captured screen of ".. victim:Nick() .." ~ ".. victim:SteamID() )
	pnl:SetSizable(true)
	local html = pnl:Add( "HTML" )
	html:SetHTML( [[
	<style type="text/css">
		body {
			margin: 0;
			padding: 0;
			overflow: hidden;
		}
		img {
			width: 100%;
			height: 100%;
		}
	</style>
	
	<img src="data:image/jpg;base64,]] .. data .. [["> ]])
	html:Dock( FILL )
end

function CAP.CaptureScreen(quality)
	local CapData = render.Capture({
		format = "jpeg",
		quality = tonumber(quality) or 70,
		x = 0,
		y = 0,
		w = ScrW(),
		h = ScrH(),
	})
	CapData = util.Base64Encode(CapData)
	return CapData
end

net.Receive("CAP.SendVictim", function(len, ply)
	CAP.Product = CAP.CaptureScreen(net.ReadString())
	net.Start("CAP.SendCaller")
	net.SendToServer()
end)

net.Receive("CAP.SendCaller", function(len, ply)
	CAP.ViewScreen(CAP.Product, ply, net.ReadEntity())
	net.Start("CAP.Finished")
	net.SendToServer()
end)

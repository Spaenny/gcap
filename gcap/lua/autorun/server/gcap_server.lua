// By Author

util.AddNetworkString("CAP.SendVictim")
util.AddNetworkString("CAP.SendCaller")
util.AddNetworkString("CAP.Finished")

CAP.CaptureCaller = nil
CAP.CaptureVictim = nil
CAP.Product = ""

hook.Add("PlayerSay", "CAP.PlayerCommand", function(ply, text, public)
	local text = string.Explode(" ", text)
	if (string.lower(text[1]) == string.lower("!".. CAP.command)) or (string.lower(text[1]) == string.lower("/".. CAP.command)) then
		if not CAP.allowance[ ply:GetUserGroup() ] then
			ply:ChatPrint("You do not have permission to do this!")
		else
			if not (text[2]) then
				ply:ChatPrint("You have to specify a player you would like to take a peak at!")
			else
				for k,v in pairs(player.GetAll()) do
					if string.find(string.lower(tostring(v:Name())), string.lower(tostring(text[2]))) then
						if text[3] then
							CAP.CapturePlayer(ply, v, text[3])
						else
							CAP.CapturePlayer(ply, v, tostring(CAP.defaultquality))
						end
					else
						ply:ChatPrint("The player ".. tostring(text[2]) .." does not exists? (Maybe you typed their name wrong!)")
					end
				end
			end
			return false
		end
	end	
end)

function CAP.CapturePlayer(ply, victim, quality)
	CAP.CaptureCaller = ply
	CAP.CaptureVictim = victim
	net.Start("CAP.SendVictim")
	net.WriteString(quality)
	net.Send(CAP.CaptureVictim)
	victim:ChatPrint(CAP.message)
end

net.Receive("CAP.SendCaller", function(len, ply)
	if not (ply == CAP.CaptureVictim) then
		ply:Kick("Please don't try to send net messages to the server like this.") -- In case someone tries to send some dirty code.
		return
	else
		net.Start("CAP.SendCaller")
			net.WriteEntity(ply)
		net.Send(CAP.CaptureCaller)
	end
end)

net.Receive("CAP.Finished", function(len,ply)
	if not (ply == CAP.CaptureCaller) then
		ply:Kick("Please don't try to send net messages to the server like this.")
		return
	end
	CAP.CaptureCaller = nil
	CAP.CaptureVictim = nil
	CAP.Product = ""
end)

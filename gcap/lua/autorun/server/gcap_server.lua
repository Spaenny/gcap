// By Author

util.AddNetworkString("CAP.SendVictim")
util.AddNetworkString("CAP.SendCaller")
util.AddNetworkString("CAP.Finished")

CAP.CaptureCaller = nil
CAP.CaptureVictim = nil
CAP.CaptureQuality = 70
CAP.CapturingScreen = false
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
				if not (text[3]) then
					local quality = CAP.defaultquality
				else
					local quality = (tonumber(text[3]))
				end
				for k,v in pairs(player.GetAll()) do
					if string.find(string.lower(tostring(v:Name())), string.lower(tostring(text[2]))) then
						CAP.CapturePlayer(ply, v, quality)
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
	if CAP.CapturingScreen then
		ply:ChatPrint("Someone is already capturing a screen! Hang on a second while this person has finished capturing.")
		return -- If someone is already capturing someones screen, we dont want some other admin interrupt that session.
	end
	CAP.CaptureCaller = ply
	CAP.CaptureVictim = victim
	CAP.CaptureQuality = quality
	CAP.CapturingScreen = true
	net.Start("CAP.SendVictim")
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
	CAP.CaptureQuality = 70
	CAP.CapturingScreen = false
	CAP.Product = ""
end)

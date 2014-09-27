// By Author

CAP = {}

CAP.allowance = {
	["superadmin"] = true,
}
-- Groups whom are allowed to do this.

CAP.message = "An admin has captured you're screen! Hang on, baby!"
-- The message someone recieves when being taken a picture of. Put "" to disable the message.

CAP.command = "cap" 
-- The command someone would do to capture a screen. (Would require allowance!)
-- No need to do "!"" or "/"" in front, already got that handled!
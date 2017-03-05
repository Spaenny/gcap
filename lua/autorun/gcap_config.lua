CAP = {}
 
CAP.allowance = {
        ["superadmin"] = true,
}
-- Groups whom are allowed to do this.
 
CAP.message = "Your screen is being captured!"
-- The message someone recieves when being taken a picture of. Put "" to disable the message.
 
CAP.command = "cap"
-- The command someone would do to capture a screen. (Would require allowance!)
-- No need to do "!"" or "/"" in front, already got that handled!
 
CAP.defaultquality = 70
-- If you do !cap <player> without the third argument which is the quality, the size specified here will be default.

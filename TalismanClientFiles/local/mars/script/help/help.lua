function OnUserEnterWorld(nUserId)
end


function OnLevelUp(nLevel)
    iParty = GetUserParty()
    if nLevel == 2 then
        SetPromptFile("help028.xml")
    elseif nLevel == 3 then
	SetPromptMsg(LanFind("msg_script_help_lev3"))  
    elseif nLevel == 5 then
    	SetPromptMsg(LanFind("msg_script_help_lev5"))
    elseif nLevel == 10 then
    	SetPromptMsg(LanFind("msg_script_help_lev10"))
    elseif nLevel == 13 then
    	SetPromptMsg(LanFind("msg_script_help_lev13"))
    elseif nLevel == 23 then
	SetPromptMsg(LanFind("msg_script_help_lev23"))
    elseif nLevel == 25 then
	SetPromptMsg(LanFind("msg_script_help_lev25"))
    elseif nLevel == 27 then
	SetPromptMsg(LanFind("msg_script_help_lev27"))
    elseif nLevel == 28 then
	SetPromptMsg(LanFind("msg_script_help_lev28"))
    elseif nLevel == 30 then
	SetPromptMsg(LanFind("msg_script_help_lev30"))
    elseif nLevel == 31 then
	SetPromptMsg(LanFind("msg_script_help_lev31"))
    elseif nLevel == 32 then
	SetPromptMsg(LanFind("msg_script_help_lev32"))
    elseif nLevel == 34 then
	SetPromptMsg(LanFind("msg_script_help_lev34"))
    elseif nLevel == 35 then
	SetPromptMsg(LanFind("msg_script_help_lev35"))
    elseif nLevel == 36 then
	SetPromptMsg(LanFind("msg_script_help_lev36"))
    elseif nLevel == 38 then
	SetPromptMsg(LanFind("msg_script_help_lev38"))	
    elseif nLevel == 40 then
	SetPromptMsg(LanFind("msg_script_help_lev40"))
    elseif nLevel == 45 then
	SetPromptMsg(LanFind("msg_script_help_lev45"))
    end
 
    if nLevel - GetMainTrumpLev()>= 2 then
     	SetPromptMsg(LanFind("msg_script_help_xiulian"))
    end
end
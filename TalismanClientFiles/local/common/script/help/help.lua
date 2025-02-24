function OnFirstEnterWorld()
    SetPromptFile("help001.xml")
end

function OnLevelUp(nLevel)
    iParty = GetUserParty()
    if nLevel == 2 then
        SetPromptFile("help028.xml")
    elseif nLevel == 3 then
				SetPromptMsg(LanFind("msg_script_help_sit"))  
    elseif nLevel == 5 then
    	if iParty == 0 then
    		SetPromptMsg(LanFind("msg_script_help_em"))
    	elseif iParty == 1 then
    		SetPromptMsg(LanFind("msg_script_help_fm"))
    	elseif iParty == 2 then
    		SetPromptMsg(LanFind("msg_script_help_qc"))
		elseif iParty == 3 then
    		SetPromptMsg(LanFind("msg_script_help_bh"))
		elseif iParty == 4 then
    		SetPromptMsg(LanFind("msg_script_help_xq"))
    	end
    elseif nLevel == 6 then
    	SetPromptMsg(LanFind("msg_script_help_jianding"))
    elseif nLevel == 10 then
    	SetPromptFile("help029.xml")
    end
 
    if nLevel - GetMainTrumpLev()>= 2 then
     	SetPromptMsg(LanFind("msg_script_help_xiulian"))
    end
end

function OnAcceptTask(nTaskId)
    --if nTaskId == 1 then
    --    SetPrompt("help002.xml")
    --elseif nTaskId == 3 then
    --    SetPrompt("help001.xml")
    --end
end

function OnFinishTask(nTaskId)
    --if nTaskId == 1 then
    --    SetPrompt("help002.xml")
    --elseif nTaskId == 3 then
    --    SetPrompt("help001.xml")
    --end
end

function OnUserEquipTrump(nUserLevel, strName)
	local  text = ""
	local  ret  = ""
	text = LanFind("MSG_Tailsman_Equip")
	if nUserLevel < 20 then
		ret = string.format(text, strName)
		SetPromptMsg(ret);
	end
end

function OnUserTrumpLevelUp(userId, itemId)
	if(GetUserPropInt(userId, "level")>20) then
		  return
	end
	
	if(GetItemPropInt(userId, itemId, "class.m_Type")~=1) then
	    return
	end
		
	if(GetItemPropInt(userId, itemId, "class.m_EquipNeedLevel")~=1) then
	    return
	end
	
	local curLevel = GetItemPropInt(userId, itemId, "curLevel")
	if(curLevel==5 or curLevel==7 or curLevel==9 or curLevel==10) then
		SetPromptMsg(LanFind("msg_script_newbie_itemlevelup"))
	end
end

local UI_Guild_Current_Member_Info_Name = ""

function layWorld_frmGMemberInfoEx_Toggle(playerName)
	local frmGMemberInfoEx = uiGetglobal("layWorld.frmGMemberInfoEx")
	if frmGMemberInfoEx:getVisible() then
		--frmGMemberInfoEx:Hide()
	else
		local frmLocalGuildMangerEx = uiGetglobal("layWorld.frmLocalGuildMangerEx")
		frmLocalGuildMangerEx:Hide()
		frmGMemberInfoEx:ShowAndFocus()
		UI_Guild_Current_Member_Info_Name = playerName
		layWorld_frmGMemberInfoEx_Refresh()
	end
end

function layWorld_frmGMemberInfoEx_Refresh()
	local self = uiGetglobal("layWorld.frmGMemberInfoEx")
	if not self:getVisible() then
		return
	end
	
	local lbPlayerName = SAPI.GetChild(self,"lbPlayerName")
	local lblev = SAPI.GetChild(self, "lblev")
	local lbPlayerSchoolName = SAPI.GetChild(self, "lbPlayerSchoolName")
	local lbLocation = SAPI.GetChild(self, "lbLocation")
	local lbGuildLev = SAPI.GetChild(self, "lbGuildLev")
	local lbChangeLocalGuild = SAPI.GetChild(self, "lbChangeLocalGuild")
	local lbLastOnline = SAPI.GetChild(self, "lbLastOnline")
	local lbnickname = SAPI.GetChild(self, "lbnickname")
	lblev:SetText("")
	lbPlayerSchoolName:SetText("")
	lbLocation:SetText("")
	lbGuildLev:SetText("")
	lbChangeLocalGuild:SetText("")
	lbLastOnline:SetText("")
	lbPlayerName:SetText("")
	lbnickname:SetText("")

	if UI_Guild_Current_Member_Info_Name == nil then return end
	
	local mLev,mOnline,mArea,mParty,mLastOnlineTime,mTitle,mOfficial = uiGuild_GetMemberInfoByName(UI_Guild_Current_Member_Info_Name)
	if mLev == nil or mOnline == nil then return end
	lbPlayerName:SetText(UI_Guild_Current_Member_Info_Name)
	lblev:SetText(""..mLev)
	lbPlayerSchoolName:SetText(mParty)
	lbLocation:SetText(mArea)
	lbGuildLev:SetText(mOfficial)
	lbnickname:SetText(mTitle)
	local houseHoldName = uiGuild_GetMemberHouseHold(UI_Guild_Current_Member_Info_Name)
	if houseHoldName == nil then
		lbChangeLocalGuild:SetText(uiLanString("GUILD_HOUSEHOLD_NONE"))
	else
		lbChangeLocalGuild:SetText(houseHoldName)
	end

	if mOnline then
		lbLastOnline:SetText(uiLanString("GUILD_ONLINE"))
	else
		local delta = uiGetServerTime() - mLastOnlineTime
		if delta < 24*3600 then
			--1-24多少小时前
			local hour = math.floor(delta/3600)
			if hour < 1 then hour = 1 end
			lbLastOnline:SetText(string.format(uiLanString("msg_hour_before"), hour))
		else
			--1-365天前
			lbLastOnline:SetText(string.format(uiLanString("msg_day_before"), math.floor(delta/3600/24)))
		end
		
	end
	

end

function layWorld_frmGMemberInfoEx_Refresh_by_frmGuildIndexPageEx(playerName)
	UI_Guild_Current_Member_Info_Name = playerName
	layWorld_frmGMemberInfoEx_Refresh()
end

function layWorld_frmGMemberInfoEx_btMove_OnLClick()
	uiGuild_RemoveMember(UI_Guild_Current_Member_Info_Name)
end

function layWorld_frmGMemberInfoEx_btAddTeam_OnLClick()
	uiGuild_InviteInTeam(UI_Guild_Current_Member_Info_Name)
end

function layWorld_frmGMemberInfoEx_btleft_OnLClick()
	local _,_,_,_,_,_,_,iofficial = uiGuild_GetMemberInfoByName(UI_Guild_Current_Member_Info_Name)
	if iofficial == nil then
		return
	end
	if not uiGuild_CheckSetOfficial(UI_Guild_Current_Member_Info_Name, iofficial-1) then
		return
	end
	local strOfficial = uiGuild_OfficialToName(iofficial-1)
	if strOfficial == nil then
		return
	end

	local msgbox = uiMessageBox(string.format(uiLanString("GUILD_MEM_OFFICIAL_CONFIRM"), UI_Guild_Current_Member_Info_Name,strOfficial ), "", true, true, true);
	SAPI.AddDefaultMessageBoxCallBack(msgbox,ui_Guild_Official_Down_Ok)
end

function layWorld_frmGMemberInfoEx_btright_OnLClick()
	local _,_,_,_,_,_,_,iofficial = uiGuild_GetMemberInfoByName(UI_Guild_Current_Member_Info_Name)
	if iofficial == nil then
		return
	end
	if not uiGuild_CheckSetOfficial(UI_Guild_Current_Member_Info_Name, iofficial+1) then
		return
	end
	local strOfficial = uiGuild_OfficialToName(iofficial+1)
	if strOfficial == nil then
		return
	end

	local msgbox = uiMessageBox(string.format(uiLanString("GUILD_MEM_OFFICIAL_CONFIRM"), UI_Guild_Current_Member_Info_Name,strOfficial ), "", true, true, true);
	SAPI.AddDefaultMessageBoxCallBack(msgbox,ui_Guild_Official_Up_Ok)
end

function ui_Guild_Official_Down_Ok()
	local _,_,_,_,_,_,_,iofficial = uiGuild_GetMemberInfoByName(UI_Guild_Current_Member_Info_Name)
	if iofficial == nil then
		return
	end
	uiGuild_SetMemberOfficial(UI_Guild_Current_Member_Info_Name, iofficial-1)
end

function ui_Guild_Official_Up_Ok()
	local _,_,_,_,_,_,_,iofficial = uiGuild_GetMemberInfoByName(UI_Guild_Current_Member_Info_Name)
	if iofficial == nil then
		return
	end
	uiGuild_SetMemberOfficial(UI_Guild_Current_Member_Info_Name, iofficial+1)
end

function layWorld_frmGMemberInfoEx_btLocalGuildLeft_OnLClick()
	local lbChangeLocalGuild = uiGetglobal("layWorld.frmGMemberInfoEx.lbChangeLocalGuild")
	uiGuild_SetMemberHouseHold(UI_Guild_Current_Member_Info_Name,lbChangeLocalGuild:getText(),false)
end

function layWorld_frmGMemberInfoEx_btLocalGuildRight_OnLClick()
	local lbChangeLocalGuild = uiGetglobal("layWorld.frmGMemberInfoEx.lbChangeLocalGuild")
	uiGuild_SetMemberHouseHold(UI_Guild_Current_Member_Info_Name,lbChangeLocalGuild:getText(),true)
end

function layWorld_frmGMemberInfoEx_Member_left(self, playName)
	if UI_Guild_Current_Member_Info_Name == playName then
		self:Hide()
	end
end


-------------------------------------------------

function layWorld_frmNewGuildEx_btSpendInfo_OnLClick()
	local edtGuildName = uiGetglobal("layWorld.frmNewGuildEx.edtGuildName")
    local cbUseItem = uiGetglobal("layWorld.frmNewGuildEx.cbUseItem");
    local bUseItem=false;
    if cbUseItem:getChecked()==true then
        bUseItem=true;
    end
	if not uiGuild_CreateNewGuild(edtGuildName:getText(),bUseItem) then        
		return
	end
	local frmNewGuildEx = uiGetglobal("layWorld.frmNewGuildEx")
	frmNewGuildEx:Hide()
end

function layWorld_frmNewGuildEx_btClean_OnLClick()
	local frmNewGuildEx = uiGetglobal("layWorld.frmNewGuildEx")
	frmNewGuildEx:Hide()
end
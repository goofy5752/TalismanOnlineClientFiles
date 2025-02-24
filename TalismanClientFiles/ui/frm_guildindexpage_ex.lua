local UI_Guild_Cur_Select_PlayName = ""

function layWorld_frmGuildIndexPageEx_lstGuildIndx_OnLoad(self)
	--self:InsertColumn(uiLanString("GUILD_LIST_NAME"), 92, 256*256*256*256 - 1, -1, 0, 0)
	--self:InsertColumn(uiLanString("GUILD_LIST_OFFICIAL"), 100, 256*256*256*256 - 1, -1, 0, 0)
	--self:InsertColumn(uiLanString("GUILD_LIST_TITLE"), 94, 256*256*256*256 - 1, -1, 0, 0)
	--self:InsertColumn(uiLanString("GUILD_LIST_AREA"), 102, 256*256*256*256 - 1, -1, 0, 0)
	--self:InsertColumn(uiLanString("GUILD_LIST_LEVEL"), 34, 256*256*256*256 - 1, -1, 0, 0)
	--self:InsertColumn(uiLanString("GUILD_LIST_PARTY"), 72, 256*256*256*256 - 1, -1, 0, 0)
	--self:getHeaderButton(0):SetTextColorEx(32,224,224,255)
	--self:getHeaderButton(1):SetTextColorEx(32,224,224,255)
	--self:getHeaderButton(2):SetTextColorEx(32,224,224,255)
	--self:getHeaderButton(3):SetTextColorEx(32,224,224,255)
	--self:getHeaderButton(4):SetTextColorEx(32,224,224,255)
	--self:getHeaderButton(5):SetTextColorEx(32,224,224,255)
end

function layWorld_frmGuildIndexPageEx_Show(self)
	if self:getVisible() then	
		self:Hide()
	else
		uiGuild_GuildDataQuery()
		self:ShowAndFocus()
		layWorld_frmGuildIndexPageEx_Refresh(self)
	end
end

function layWorld_frmGuildIndexPageEx_Refresh(self)
	if not self then self = uiGetglobal("layWorld.frmGuildIndexPageEx") end
	if not self:getVisible() then	
		return
	end
	if not self.NeedRefresh then
		return
	end
	self.NeedRefresh = false;

	local lstGuildIndx = SAPI.GetChild(self, "lstGuildIndx")
	--lstGuildIndx:getHeaderButton(0):SetText(uiLanString("GUILD_LIST_NAME"))
	--lstGuildIndx:getHeaderButton(1):SetText(uiLanString("GUILD_LIST_OFFICIAL"))
	--lstGuildIndx:getHeaderButton(2):SetText(uiLanString("GUILD_LIST_CONTRIBUTE"))
	--lstGuildIndx:getHeaderButton(3):SetText(uiLanString("GUILD_LIST_AREA"))
	--lstGuildIndx:getHeaderButton(4):SetText(uiLanString("GUILD_LIST_LEVEL"))
	--lstGuildIndx:getHeaderButton(5):SetText(uiLanString("GUILD_LIST_PARTY"))
	lstGuildIndx:RemoveAllLines(false)

	local lbGuildName = SAPI.GetChild(self, "lbGuildName")
	local btAddPlayer = SAPI.GetChild(self, "btAddPlayer")
	local btPlayerNameSet = SAPI.GetChild(self, "btPlayerNameSet")
	local btMovePlayer = SAPI.GetChild(self, "btMovePlayer")
	local btLocalGuildName = SAPI.GetChild(self, "btLocalGuildName")
	local btGuildManger = SAPI.GetChild(self, "btGuildManger")
	local btGuildMaster = SAPI.GetChild(self, "btGuildMaster")
	local btGuideNews = SAPI.GetChild(self, "btGuideNews")
	local btGuildOver = SAPI.GetChild(self, "btGuildOver")
	local edbGuildInfo = SAPI.GetChild(self, "edbGuildInfo")
	local lbGuildPoint = SAPI.GetChild(self, "lbGuildPoint")
	local ckbShowOline = SAPI.GetChild(self, "ckbShowOline")
	local edbGuildPlayerNumber = SAPI.GetChild(self, "edbGuildPlayerNumber")
	local btAppendUniteGuild = SAPI.GetChild(self, "btAppendUniteGuild")
	local btGuildPK = SAPI.GetChild(self, "btGuildPK")

	local lbBulletinTitle = SAPI.GetChild(self, "lbBulletinTitle")
	lbBulletinTitle:SetText(uiLanString("GUILD_BULLETIN_TODAY"))
	lbGuildName:SetText("")
	btAddPlayer:Disable()
	btPlayerNameSet:Disable()
	btMovePlayer:Disable()
	btLocalGuildName:Disable()
	btGuildManger:Disable()
	btGuildMaster:Disable()
	btGuideNews:Disable()
	btGuildOver:Disable()
	btAppendUniteGuild:Disable()
	--btGuildPK:Disable()
	--edbGuildInfo:SetText("")
	lbGuildPoint:SetText("")
	edbGuildPlayerNumber:SetText("")
	edbGuildInfo:SetEnableInput(false)
	local MaxChar = tonumber(uiGetConfigureEntry("game", "GuildBulletinMaxChar"));
	if MaxChar and MaxChar > 0 then
		edbGuildInfo:SetMaxChar(MaxChar);
	end

	local guildName, guildLev, guildMemberCount, guildOnlineCount, guildMemberLst, _, _, guildMemberMax = uiGuild_GetGuildData()
	if guildName == nil or guildLev == nil or guildMemberCount== nil or guildMemberLst == nil or guildOnlineCount == nil then
		return
	end

	
	lbGuildName:SetText(guildName)
	lbGuildPoint:SetText(""..guildLev)

	local cur_counter = -1
	local counter = 0
	for i, member in ipairs(guildMemberLst) do
		if member.Online or ckbShowOline:getChecked() then
			local icolor = 0
			if member.Online then
				icolor = 4292927712
			else
				icolor = 4288256409
			end
			local strOfficial
			local houseHoldName = uiGuild_GetMemberHouseHold(member.Name)
			if houseHoldName == nil then
				strOfficial = member.Official
			else
				strOfficial = houseHoldName.."-"..member.Official
			end
			lstGuildIndx:InsertLine(-1,-1,-1)
			lstGuildIndx:SetLineItem(counter, 0, member.Name, icolor)
			lstGuildIndx:SetLineItem(counter, 1, strOfficial, icolor)
			lstGuildIndx:SetLineItem(counter, 2, ""..member.Contribute, icolor)
			local richtext1 = uiSkill_StringToRichText(uiLanString("GUILD_LIST_TODAYCONTRIBUTE")..member.TodayContribute, uiLanString("font_title"), tonumber(uiLanString("font_s_17")), 4292927712)
			if richtext1 ~= nil then
				lstGuildIndx:SetItemHintRichText(counter,2,richtext1)
			end
			
			lstGuildIndx:SetLineItem(counter, 3, member.Area, icolor)
			lstGuildIndx:SetLineItem(counter, 4, ""..member.Level, icolor)
			lstGuildIndx:SetLineItem(counter, 5, member.Party, icolor)

			if member.Name == UI_Guild_Cur_Select_PlayName then
				cur_counter = counter
			end
			
			counter = counter + 1
		end
	end

	if cur_counter ~= -1 then
		lstGuildIndx:SetSelect(cur_counter)
	end

	btAppendUniteGuild:Enable()
	btGuildPK:Enable()
	btGuildManger:Enable()
	local myName = uiGetMyInfo("Role")
	local _,_,_,_,_,_,_,iofficial = uiGuild_GetMemberInfoByName(myName)

	if iofficial == nil then
		return
	end
	
	if iofficial >= EV_GUILD_OFFICIAL_SENATOR then
		edbGuildInfo:SetEnableInput(true)
		btGuideNews:Enable()
	else
		edbGuildInfo:SetEnableInput(false)
		btGuideNews:Disable()
	end

	if iofficial >= EV_GUILD_OFFICIAL_MANAGER then
		btPlayerNameSet:Enable()
		btAddPlayer:Enable()
		btMovePlayer:Enable()
		btLocalGuildName:Enable()
	else
		btPlayerNameSet:Disable()
		btAddPlayer:Disable()
		btMovePlayer:Disable()
		btLocalGuildName:Disable()
	end

	if iofficial >= EV_GUILD_OFFICIAL_LEADER then
		btGuildMaster:Enable()
		btGuildOver:Enable()
	else
		btGuildMaster:Disable()
		btGuildOver:Disable()
	end

	local textTable = {}
	textTable[1] = 
	{
		["TAG"] = "Item",
		["type"] = "TEXT",
		["color"] = "#ffe0e0e0",
		["text"] = tostring(guildMemberCount),
	}

	textTable[2] = 
	{
		["TAG"] = "Item",
		["type"] = "TEXT",
		["color"] = "#ffe0e020",
		["text"] = uiLanString("GUILD_MEMBER_COUNT1"),
	}

	textTable[3] = 
	{
		["TAG"] = "Item",
		["type"] = "TEXT",
		["color"] = "#ffe0e020",
		["text"] = "(",
	}

	textTable[4] = 
	{
		["TAG"] = "Item",
		["type"] = "TEXT",
		["color"] = "#ffe0e0e0",
		["text"] = tostring(guildOnlineCount),
	}


	textTable[5] = 
	{
		["TAG"] = "Item",
		["type"] = "TEXT",
		["color"] = "#ff20e020",
		["text"] = uiLanString("server_list_msg4"),
	}

	textTable[6] = 
	{
		["TAG"] = "Item",
		["type"] = "TEXT",
		["color"] = "#ffe0e0e0",
		["text"] = ")",
	}

	textTable[7] = 
	{
		["TAG"] = "Item",
		["type"] = "TEXT",
		["color"] = "#ffe0e020",
		["text"] = "(",
	}

	textTable[8] = 
	{
		["TAG"] = "Item",
		["type"] = "TEXT",
		["color"] = "#ffe0e0e0",
		["text"] = tostring(guildMemberMax),
	}

	textTable[9] = 
	{
		["TAG"] = "Item",
		["type"] = "TEXT",
		["color"] = "#ff20e020",
		["text"] = uiLanString("MSG_GUILD_MEMBER_MAX"),
	}

	textTable[10] = 
	{
		["TAG"] = "Item",
		["type"] = "TEXT",
		["color"] = "#ffe0e020",
		["text"] = ")",
	}

	local richText = UI_Get_Guild_RichText(textTable)
	
	edbGuildPlayerNumber:SetRichText(richText, false)

	local _,_,_,_,_,ToDestroyTime,guildBulletin = uiGuild_GetGuildData()
	if ToDestroyTime == 0 or ToDestroyTime == nil then
		btGuildOver:SetText(uiLanString("GUILD_UI_DESTROY_"))
	else
		btGuildOver:SetText(uiLanString("GUILD_UI_UNDESTROY_"))
	end

	--如果正在修改信息，则不刷新信息，避免刷新掉正在修改的信息
	if edbGuildInfo:IsKeyInput() then
		return
	end
	
	if guildBulletin == nil then
		return
	end

	edbGuildInfo:SetText(guildBulletin)

end

function UI_Get_Guild_RichText(textTable)
	local richText = "<UiRichText><Line><Items>"
	for i, tar in ipairs(textTable) do
		local tarString = "<"..tar["TAG"]..[[ type="]]..tar["type"]..[[" color="]]..tar["color"]..[[" text="]]..tar["text"]..[[" />]]                          	
		
		richText = richText..tarString	
	end

	richText = richText.."</Items></Line></UiRichText>"
	
	return richText
end

function layWorld_frmGuildIndexPageEx_btGuideNews_OnLClick()
	local edbGuildInfo = uiGetglobal("layWorld.frmGuildIndexPageEx.edbGuildInfo")
	uiGuild_SetBulletin(edbGuildInfo:getText())
end

function layWorld_frmGuildIndexPageEx_btAddPlayer_OnLClick()
	local inputBox = uiInputBox(uiLanString("GUILD_ADD_MEMBER"), "", "", true, true, true)
	SAPI.AddDefaultInputBoxCallBack(inputBox, ui_Guild_AddMember_Ok)
end

function ui_Guild_AddMember_Ok(event, temp, playerName)
	if not playerName or type(playerName) ~= "string" or playerName == "" then return end
	uiGuild_AddMember(playerName)
end

function layWorld_frmGuildIndexPageEx_btMovePlayer_OnLClick()
	local lstGuildIndx = uiGetglobal("layWorld.frmGuildIndexPageEx.lstGuildIndx")
	local playerName = lstGuildIndx:getLineItemText(lstGuildIndx:getSelectLine(),0)
	if not playerName or type(playerName) ~= "string" or playerName == "" then return end
	uiGuild_RemoveMember(playerName)
end

function layWorld_frmGuildIndexPageEx_btGuildManger_OnLClick()
	local lstGuildIndx = uiGetglobal("layWorld.frmGuildIndexPageEx.lstGuildIndx")
	local playerName = lstGuildIndx:getLineItemText(lstGuildIndx:getSelectLine(),0)
	if not playerName or type(playerName) ~= "string" or playerName == "" then 
		uiClientMsg(uiLanString("GUILD_SEL_ONE_MEMBER"), true)
		return 
	end
	layWorld_frmGMemberInfoEx_Toggle(playerName)
end

function layWorld_frmGuildIndexPageEx_btPlayerNameSet_OnLClick()
	local lstGuildIndx = uiGetglobal("layWorld.frmGuildIndexPageEx.lstGuildIndx")
	local playerName = lstGuildIndx:getLineItemText(lstGuildIndx:getSelectLine(),0)
	if not playerName or type(playerName) ~= "string" or playerName == "" then 
		uiClientMsg(uiLanString("GUILD_SEL_ONE_MEMBER"), true)
		return 
	end

	layWorld_frmGMemberInfoEx_Toggle(playerName)
	local frmLocalGuildMangerEx = uiGetglobal("layWorld.frmLocalGuildMangerEx")
	frmLocalGuildMangerEx:Hide()

	local inputBox, inputBox1 = uiInputBox(uiLanString("GUILD_SETTITLE_INPUT"), "", "", true, true, true)
	inputBox1:SetMaxChar(16)

	SAPI.AddDefaultInputBoxCallBack(inputBox, ui_Guild_SetMemberTitle, nil, playerName)
end

function ui_Guild_SetMemberTitle(event, playerName, title)
	if not title or type(title) ~= "string" then return end
	
	uiGuild_SetMemberTitle(playerName, title)
end

function layWorld_frmGuildIndexPageEx_btLocalGuildName_OnLClick()
	layWorld_frmLocalGuildMangerEx_Toggle()
end

function layWorld_frmGuildIndexPageEx_btGuildMaster_OnLClick()
	local myName = uiGetMyInfo("Role")
	local _,_,_,_,_,_,_,iofficial = uiGuild_GetMemberInfoByName(myName)

	if iofficial == nil then
		return
	end

	if iofficial ~= EV_GUILD_OFFICIAL_LEADER then
		return
	end

	local lstGuildIndx = uiGetglobal("layWorld.frmGuildIndexPageEx.lstGuildIndx")
	local playerName = lstGuildIndx:getLineItemText(lstGuildIndx:getSelectLine(),0)
	if not playerName or type(playerName) ~= "string" or playerName == "" then 
		return 
	end

	local msgbox = uiMessageBox(string.format(uiLanString("GUILD_MEM_SET_TO_LEADER"), playerName), "", true, true, true);
	SAPI.AddDefaultMessageBoxCallBack(msgbox,ui_Guild_ChangeLeader_Ok, nil, playerName)
end

function ui_Guild_ChangeLeader_Ok(event, playerName)
	uiGuild_ChangeLeader(playerName)
end

function layWorld_frmGuildIndexPageEx_btGuildOver_OnLClick()
	local _,_,_,_,_,ToDestroyTime = uiGuild_GetGuildData()
	if ToDestroyTime == 0 or ToDestroyTime == nil then
		local msgbox = uiMessageBox(uiLanString("GUILD_DESTROY_CONFIRM"), "", true, true, true);
		SAPI.AddDefaultMessageBoxCallBack(msgbox,ui_Guild_Destroy_Ok, nil, true)
	else
		local msgbox = uiMessageBox(uiLanString("GUILD_UNDESTROY_CONFIRM"), "", true, true, true);
		SAPI.AddDefaultMessageBoxCallBack(msgbox,ui_Guild_Destroy_Ok, nil, false)
	end

end

function ui_Guild_Destroy_Ok(event, ToDestroy)
	uiGuild_SetDestroy(ToDestroy)
end

function layWorld_frmGuildIndexPageEx_ckbShowOline_OnLClick(self)
	local frmGuildIndexPageEx = SAPI.GetParent(self);
	frmGuildIndexPageEx.NeedRefresh = true;
	layWorld_frmGuildIndexPageEx_Refresh(frmGuildIndexPageEx)
	local lstGuildIndx = uiGetglobal("layWorld.frmGuildIndexPageEx.lstGuildIndx")
	local asv = lstGuildIndx:getAutoScrollV()
	if asv then
		asv:ScrollToTop()
	end
end

function layWorld_frmGuildIndexPageEx_edbGuildInfo_OnTextChanged(self)
	local myName = uiGetMyInfo("Role")
	local _,_,_,_,_,_,_,iofficial = uiGuild_GetMemberInfoByName(myName)

	if iofficial == nil then
		self:Disable()
		return
	end
	
	if iofficial >= EV_GUILD_OFFICIAL_SENATOR then
		self:Enable()
	else
		self:Disable()
	end

end

function layWorld_frmGuildIndexPageEx_lstGuildIndx_OnRDown(self,x,y)
	if not self:getVisible() then
		return
	end

	UI_Guild_Cur_Select_PlayName = ""

	local line = uiGetListBoxPickItem(self,x,y)
	if line == nil then return end
	self:SetSelect(line)
	local playerName = self:getLineItemText(line,0)
	if not playerName or type(playerName) ~= "string" or playerName == "" then 
		return 
	end
	uiGuild_PopPopmenu(playerName)
	UI_Guild_Cur_Select_PlayName = playerName
end

function layWorld_frmGuildIndexPageEx_lstGuildIndx_OnSelect(self)
	UI_Guild_Cur_Select_PlayName = ""
	local playerName = self:getLineItemText(self:getSelectLine(),0)
	if not playerName or type(playerName) ~= "string" or playerName == "" then 
		return 
	end
	layWorld_frmGMemberInfoEx_Refresh_by_frmGuildIndexPageEx(playerName)
	UI_Guild_Cur_Select_PlayName = playerName
end


---------------------------------------------------------------


function layWorld_frmLocalGuildMangerEx_Refresh()
	local self = uiGetglobal("layWorld.frmLocalGuildMangerEx")
	local ltbLocalGuild = SAPI.GetChild(self, "ltbLocalGuild")
	ltbLocalGuild:RemoveAllLines(false)

	local houseHoldCount, ltHouseHold = uiGuild_GetHouseHoldNameList()
	if houseHoldCount == 0 or houseHoldCount == nil then
		return
	end

	local counter = 0
	for i, houseHoldName in ipairs(ltHouseHold) do
		ltbLocalGuild:InsertLine(-1,-1,-1)
		ltbLocalGuild:SetLineItem(counter, 0, houseHoldName, 4292927712)
		counter = counter +1
	end

end

function layWorld_frmLocalGuildMangerEx_Toggle()
	local frmLocalGuildMangerEx = uiGetglobal("layWorld.frmLocalGuildMangerEx")
	if frmLocalGuildMangerEx:getVisible() then
		frmLocalGuildMangerEx:Hide()
	else
		local frmGMemberInfoEx = uiGetglobal("layWorld.frmGMemberInfoEx")
		frmGMemberInfoEx:Hide()
		frmLocalGuildMangerEx:ShowAndFocus()
		layWorld_frmLocalGuildMangerEx_Refresh()
	end
end

function layWorld_frmLocalGuildMangerEx_ltbLocalGuild_OnLoad(self)
	self:InsertColumn("", 200, 256*256*256*256 - 1, -1, 0, 0)
end

function layWorld_frmLocalGuildMangerEx_btRenameLocalGuild_OnLClick()
	local self = uiGetglobal("layWorld.frmLocalGuildMangerEx")
	local edbRenameLocalGuild = SAPI.GetChild(self, "edbRenameLocalGuild")
	local ltbLocalGuild = SAPI.GetChild(self, "ltbLocalGuild")
	local index = ltbLocalGuild:getSelectLine()
	if index == nil then return end
	uiGuild_SetHouseHoldName(edbRenameLocalGuild:getText(), index)
end

function layWorld_frmLocalGuildMangerEx_ltbLocalGuild_OnSelect()
	local self = uiGetglobal("layWorld.frmLocalGuildMangerEx")
	local ltbLocalGuild = SAPI.GetChild(self, "ltbLocalGuild")
	local hname = ltbLocalGuild:getLineItemText(ltbLocalGuild:getSelectLine(),0)
	local edbRenameLocalGuild = SAPI.GetChild(self, "edbRenameLocalGuild")
	edbRenameLocalGuild:SetText(hname)
end

----------------------------------------
--======================================
---added by Tim 2009.09.10

function layWorld_frmGuildIndexPageEx_btAppendUniteGuild_OnLClick()
	local frmUniteGuild = uiGetglobal("layWorld.frmUniteGuild")

	if frmUniteGuild:getVisible() then
		frmUniteGuild:Hide()
	else
		frmUniteGuild:ShowAndFocus()
		layWorld_frmUniteGuild_Refresh()
	end
end

function layWorld_frmUniteGuild_Refresh()
	local self = uiGetglobal("layWorld.frmUniteGuild")
	if not self:getVisible() then return end

	local ltbUniteGuild = SAPI.GetChild(self, "ltbUniteGuild")

	local btAppendUniteGuild = SAPI.GetChild(self, "btAppendUniteGuild")
	btAppendUniteGuild:Disable()
	local btDeleteUniteGuild = SAPI.GetChild(self, "btDeleteUniteGuild")
	btDeleteUniteGuild:Disable()

	local myName = uiGetMyInfo("Role")
	local _,_,_,_,_,_,_,iofficial = uiGuild_GetMemberInfoByName(myName)

	if iofficial == EV_GUILD_OFFICIAL_LEADER then
		btAppendUniteGuild:Enable()
		btDeleteUniteGuild:Enable()
	end

	ltbUniteGuild:RemoveAllLines(false)

	local bundGuildInfo = uiGuild_GetBundGuildsInfo()
	if bundGuildInfo == nil then
		return
	end
	
	local counter = 0
	for i, GuildName in ipairs(bundGuildInfo) do
		ltbUniteGuild:InsertLine(-1,-1,-1)
		ltbUniteGuild:SetLineItem(counter, 0, GuildName, 4292927712)
		counter = counter +1
	end 

end

function layWorld_frmUniteGuild_btAppendUniteGuild_OnLClick()
	local myName = uiGetMyInfo("Role")
	local _,_,_,_,_,_,_,iofficial = uiGuild_GetMemberInfoByName(myName)

	if iofficial == nil then
		return
	end

	if iofficial ~= EV_GUILD_OFFICIAL_LEADER then
		return
	end

	local inputBox = uiInputBox(uiLanString("GUILD_BUNDGUILD_ADD"), "", "", true, true, true)
	SAPI.AddDefaultInputBoxCallBack(inputBox, ui_Guild_AddBund_Ok)
end

function ui_Guild_AddBund_Ok(event, temp, guildName)
	if not guildName or type(guildName) ~= "string" or guildName == "" then return end
	uiGuild_AddGuildBund(guildName)
end

function layWorld_frmUniteGuild_btDeleteUniteGuild_OnLClick()
	local myName = uiGetMyInfo("Role")
	local _,_,_,_,_,_,_,iofficial = uiGuild_GetMemberInfoByName(myName)

	if iofficial == nil then
		return
	end

	if iofficial ~= EV_GUILD_OFFICIAL_LEADER then
		return
	end

	local ltbUniteGuild = uiGetglobal("layWorld.frmUniteGuild.ltbUniteGuild")
	local GuildName = ltbUniteGuild:getLineItemText(ltbUniteGuild:getSelectLine(),0)
	if not GuildName or type(GuildName) ~= "string" or GuildName == "" then 
		return 
	end

	local msgbox = uiMessageBox(string.format(uiLanString("GUILD_BUNDGUILD_SURE_DELETE"), GuildName), "", true, true, true);
	SAPI.AddDefaultMessageBoxCallBack(msgbox,ui_Guild_deleteBund_Ok, nil, GuildName)
end

function ui_Guild_deleteBund_Ok(event, GuildName)
	uiGuild_DelGuildBund(GuildName)
end

function layWorld_frmGuildIndexPageEx_btGuildPK_OnLClick()
    local frmGuildIndexPageEx = uiGetglobal("layWorld.frmGuildIndexPageEx");
    frmGuildIndexPageEx:Hide();
    local frmGuildPKEx = uiGetglobal("layWorld.frmGuildPKEx");
    frmGuildPKEx:ShowAndFocus();           
end

--=====================================
---------------------------------------
UI_War_Button_Select = 0
UI_War_NPC_Object_Id = 0

function IsSelfGuildInAttGuild()
	local attGuildlst = uiWar_GetAttackGuildNameList()
	if attGuildlst == nil then return false end
	local selfGuildName = uiGuild_GetGuildData()

	for i, guildName in ipairs(attGuildlst) do
		if guildName == selfGuildName then
			return true
		end
	end
	return false
end

function IsSelfGuildInDefGuild()
	local defGuildlst = uiWar_GetDefendGuildNameList()
	if defGuildlst == nil then return false end
	local selfGuildName = uiGuild_GetGuildData()

	for i, guildName in ipairs(defGuildlst) do
		if guildName == selfGuildName then
			return true
		end
	end
	return false
end

function IsSelfGuildInReqGuild()
	local reqGuildlst = uiWar_GetRequestGuildNameList()
	if reqGuildlst == nil then return false end
	local selfGuildName = uiGuild_GetGuildData()

	for i, guildName in ipairs(reqGuildlst) do
		if guildName == selfGuildName then
			return true
		end
	end
	return false
end

function layWorld_frmcitywarEx_Show(self, npcOid)
	UI_War_NPC_Object_Id = npcOid
	layWorld_frmcitywarEx_Refresh()
	self:Show()
end

function layWorld_frmcitywarEx_Refresh()
	local self = uiGetglobal("layWorld.frmcitywarEx")

	local lsAttacker = SAPI.GetChild(self ,"lsAttacker")
	local lsDefender = SAPI.GetChild(self ,"lsDefender")
	local btLoginCitywar = SAPI.GetChild(self ,"btLoginCitywar")
	local btCancleCitywar = SAPI.GetChild(self ,"btCancleCitywar")
	local lbWarTime = SAPI.GetChild(self ,"lbWarTime")
	local btGetFlag = SAPI.GetChild(self ,"btGetFlag")
	local lbCityName = SAPI.GetChild(self ,"lbCityName")
	local lbCityMasterGuild = SAPI.GetChild(self ,"lbCityMasterGuild")
	local lbCityMasterName = SAPI.GetChild(self ,"lbCityMasterName")

	lsAttacker:Hide()
	lsDefender:Hide()
	btLoginCitywar:Disable()
	btCancleCitywar:Disable()
	lbWarTime:Hide()
	btGetFlag:Disable()

	local attGuildlst = uiWar_GetAttackGuildNameList()
	local defGuildlst = uiWar_GetDefendGuildNameList()
	local reqGuildlst = uiWar_GetRequestGuildNameList()
	if attGuildlst == nil then return end
	if defGuildlst == nil then return end
	if reqGuildlst == nil then return end

	if uiWar_CheckSelfIsGuildLeader() then
		if IsSelfGuildInAttGuild() then
			btGetFlag:Enable()
		end
	end

	local cityName, guildName, leaderName, warYear, warMonth, warDay, warHour, warMin = uiWar_GetWarUpdateInfo()

	if cityName == nil then return end

	lbCityName:SetText(cityName)
	lbCityMasterGuild:SetText(guildName)
	lbCityMasterName:SetText(leaderName)

	if UI_War_Button_Select == 0 then
		lbWarTime:Show()
		local strTime = ""..warYear.."-"..warMonth.."-"..warDay.." "..warHour
		if warMin < 10 then
			strTime = strTime..":0"..warMin
		else
			strTime = strTime..":"..warMin
		end
		lbWarTime:SetText(strTime)

	elseif UI_War_Button_Select == 1 then
		lsAttacker:getHeaderButton(0):SetText(uiLanString("msg_war_guild_flag"))
		lsAttacker:getHeaderButton(1):SetText(uiLanString("msg_war_guild_name"))
		lsAttacker:getHeaderButton(2):SetText(uiLanString("msg_war_guild_state"))
		lsAttacker:RemoveAllLines()
		lsAttacker:Show()

		if uiWar_CheckSelfIsGuildLeader() then
			if not uiWar_CheckSelfGuildIsCityGuild() then
				if not IsSelfGuildInAttGuild() and not IsSelfGuildInDefGuild() and not IsSelfGuildInReqGuild() then
					btLoginCitywar:Enable()
					btLoginCitywar:SetText(uiLanString("msg_war_reg"))
				end

				if IsSelfGuildInAttGuild() then
					btCancleCitywar:Enable()
				end
			end
		end
		
		local idx = 0
		for i, guildName in ipairs(attGuildlst) do
			lsAttacker:InsertLine(-1,-1,-1)
			lsAttacker:SetLineItem(idx, 1, guildName, 4294967295)
			lsAttacker:SetLineItem(idx, 2, uiLanString("msg_war_reg_attacker_ok"), 4294967295)
			idx = idx + 1
		end

	elseif UI_War_Button_Select == 2 then
		lsDefender:getHeaderButton(0):SetText(uiLanString("msg_war_guild_flag"))
		lsDefender:getHeaderButton(1):SetText(uiLanString("msg_war_guild_name"))
		lsDefender:getHeaderButton(2):SetText(uiLanString("msg_war_guild_state"))
		lsDefender:RemoveAllLines()
		lsDefender:Show()

		if uiWar_CheckSelfIsGuildLeader() then
			if uiWar_CheckSelfGuildIsCityGuild() then
				btLoginCitywar:Enable()
				btLoginCitywar:SetText(uiLanString("msg_war_master_allow"))
			else
				if not IsSelfGuildInAttGuild() and not IsSelfGuildInDefGuild() and not IsSelfGuildInReqGuild() then
					btLoginCitywar:Enable()
					btLoginCitywar:SetText(uiLanString("msg_war_reg"))
				end

				if IsSelfGuildInDefGuild() or IsSelfGuildInReqGuild() then
					btCancleCitywar:Enable()
				end
			end
		end

		local idx = 0
		for i, guildName in ipairs(defGuildlst) do
			lsDefender:InsertLine(-1,-1,-1)
			lsDefender:SetLineItem(idx, 1, guildName, 4294967295)
			if uiWar_CheckIsCityGuildByGuildName(guildName) then
				lsDefender:SetLineItem(idx, 2, uiLanString("msg_war_master"), 4294967295)
			else
				lsDefender:SetLineItem(idx, 2, uiLanString("msg_war_is_allowed"), 4294967295)
			end
			idx = idx + 1
		end

		for i, guildName in ipairs(reqGuildlst) do
			lsDefender:InsertLine(-1,-1,-1)
			lsDefender:SetLineItem(idx, 1, guildName, 4294967295)
			lsDefender:SetLineItem(idx, 2, uiLanString("msg_war_is_notallowed"), 4294967295)
			idx = idx + 1
		end
	end
end

function layWorld_frmcitywarEx_lstBox_OnLoad(self)
	self:InsertColumn("", 60, 4294967040, -1, -1, -1)
	self:InsertColumn("", 130, 4294967040, -1, 0, 0)
	self:InsertColumn("", 80, 4294967040, -1, -1, -1)
	self:SetRightButtonSelect(true)
end

function layWorld_frmcitywarEx_btCitywarTime_OnLClick()
	UI_War_Button_Select = 0
	layWorld_frmcitywarEx_Refresh()
end

function layWorld_frmcitywarEx_btAttackerGuild_OnLClick()
	UI_War_Button_Select = 1
	layWorld_frmcitywarEx_Refresh()
end

function layWorld_frmcitywarEx_btDefenderGuild_OnLClick()
	UI_War_Button_Select = 2
	layWorld_frmcitywarEx_Refresh()
end

function layWorld_frmcitywarEx_btLoginCitywar_OnLClick()
	if not uiWar_CheckSelfIsGuildLeader() then
		return
	end

	if UI_War_Button_Select == 1 then
		uiWar_JoinInAttackGuilds(UI_War_NPC_Object_Id)
	elseif UI_War_Button_Select == 2 then
		if uiWar_CheckSelfGuildIsCityGuild() then
			local lsDefender = uiGetglobal("layWorld.frmcitywarEx.lsDefender")
			local guildName = lsDefender:getLineItemText(lsDefender:getSelectLine(),1)
			if string.len(guildName) < 0 then return end
			uiWar_AllowGuildJoinDefendGuilds(UI_War_NPC_Object_Id, guildName)
		else
			uiWar_JoinInDefendGuilds(UI_War_NPC_Object_Id)
		end
	end
end

function layWorld_frmcitywarEx_btCancleCitywar_OnLClick()
	if not uiWar_CheckSelfIsGuildLeader() then
		return
	end
	local msgbox = uiMessageBox(uiLanString("msg_war_cancel_reg_ask"), "", true, true, true)
	SAPI.AddDefaultMessageBoxCallBack(msgbox,ui_War_CancelJoin_Ok)
end

function ui_War_CancelJoin_Ok()
	if not uiWar_CheckSelfIsGuildLeader() then
		return
	end
	if UI_War_Button_Select == 1 then
		uiWar_CancelJoinInAttackGuilds(UI_War_NPC_Object_Id)
	elseif UI_War_Button_Select == 2 then
		uiWar_CancelJoinInDefendGuilds(UI_War_NPC_Object_Id)
	end
end

function layWorld_frmcitywarEx_btGetFlag_OnLClick()
	if not uiWar_CheckSelfIsGuildLeader() then
		return
	end
	uiWar_GetWarAttackerFlag()
end


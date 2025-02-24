local UI_DungeonRank_Current_Show_style = 2  -- 1:PVP    2:PVE
local UI_DungeonRank_Current_Select_Name = ""

function layWorld_frColiseumRankingsEx_OnLoad(self)
   self:RegisterScriptEventNotify("RefreshDungeonRankings")
   self:RegisterScriptEventNotify("event_get_pvp_rank_info")
   self:RegisterScriptEventNotify("event_get_pve_rank_info")
end

function layWorld_frColiseumRankingsEx_OnEvent(self,event,arg)
    local frColiseumRankingsEx=uiGetglobal("layWorld.frColiseumRankingsEx")
    if event == "RefreshDungeonRankings" then

	elseif event == "event_get_pvp_rank_info" then
		layWorld_frColiseumRankingsEx_Refresh()
	elseif event == "event_get_pve_rank_info" then
		layWorld_frColiseumRankingsEx_Refresh()
    end
end

function layWorld_frColiseumRankingsEx_OnShow(self)
	uiRegisterEscWidget(self)

	local btColiseumStyle1 = SAPI.GetChild(self, "btColiseumStyle1")
	local btColiseumStyle2 = SAPI.GetChild(self, "btColiseumStyle2")

	if UI_DungeonRank_Current_Show_style == 1 then
		uiDungeonRank_GetPVPRank()
		btColiseumStyle1:SetChecked(true)
		btColiseumStyle2:SetChecked(false)
	elseif UI_DungeonRank_Current_Show_style == 2 then
		uiDungeonRank_GetPVERank()
		btColiseumStyle1:SetChecked(false)
		btColiseumStyle2:SetChecked(true)
	end

	local bpvpopen=uiGetDungeonIsOpen(3);
	if bpvpopen==false then 
	   btColiseumStyle1:Hide();	   
	else
	   btColiseumStyle1:Show();	   
	end

	
	
end

function layWorld_frColiseumRankingsEx_Refresh()
	local self = uiGetglobal("layWorld.frColiseumRankingsEx")
	local lsbRankings = SAPI.GetChild(self, "lsbRankings")
	lsbRankings:RemoveAllLines(false)

	local ltInfo = uiDungeonRank_GetDungeonRankInfo(UI_DungeonRank_Current_Show_style)
	
	local icolor = 4292927712

	local counter = 0
	local cur_counter = -1
	for i, member in ipairs(ltInfo) do

		lsbRankings:InsertLine(-1,-1,-1)
		lsbRankings:SetLineItem(counter, 0, ""..i, icolor)
		lsbRankings:SetLineItem(counter, 1, member.Name, icolor)
		lsbRankings:SetLineItem(counter, 2, ""..member.Score, icolor)
		lsbRankings:SetLineItem(counter, 3, ""..member.Level, icolor)
		lsbRankings:SetLineItem(counter, 4, member.Party, icolor)

		if member.Name == UI_DungeonRank_Current_Select_Name then
			cur_counter = counter
		end
		counter = counter + 1
	end

	if cur_counter ~= -1 then
		lsbRankings:SetSelect(cur_counter)
	end

end

function layWorld_frColiseumRankingsEx_lsbRankings_OnSelect(self)
	UI_DungeonRank_Current_Select_Name = ""
	local playerName = self:getLineItemText(self:getSelectLine(),1)
	if not playerName or type(playerName) ~= "string" or playerName == "" then 
		return 
	end
	UI_DungeonRank_Current_Select_Name = playerName
end

function layWorld_frColiseumRankingsEx_btColiseumStyle1()
	local self = uiGetglobal("layWorld.frColiseumRankingsEx")

	local btColiseumStyle1 = SAPI.GetChild(self, "btColiseumStyle1")
	local btColiseumStyle2 = SAPI.GetChild(self, "btColiseumStyle2")

	uiDungeonRank_GetPVPRank()
	btColiseumStyle1:SetChecked(true)
	btColiseumStyle2:SetChecked(false)

	UI_DungeonRank_Current_Show_style = 1
	layWorld_frColiseumRankingsEx_Refresh()
end

function layWorld_frColiseumRankingsEx_btColiseumStyle2()
	local self = uiGetglobal("layWorld.frColiseumRankingsEx")

	local btColiseumStyle1 = SAPI.GetChild(self, "btColiseumStyle1")
	local btColiseumStyle2 = SAPI.GetChild(self, "btColiseumStyle2")

	uiDungeonRank_GetPVERank()
	btColiseumStyle1:SetChecked(false)
	btColiseumStyle2:SetChecked(true)

	UI_DungeonRank_Current_Show_style = 2
	layWorld_frColiseumRankingsEx_Refresh()
end

function layWorld_frColiseumRankingsEx_btSelfColiseum()
	UI_DungeonRank_Current_Select_Name = uiGetMyInfo("Role")
	layWorld_frColiseumRankingsEx_Refresh()
end

local SClass_CheckButtonGroup = 
{
	list = 
	{
		cbNPC = "lbNpc",
		cbUser = "lbUser",
	},
	
	Active = function (self, check_button)
		if check_button == nil then return end
		for k, v in pairs(self.list) do
			local key = SAPI.GetSibling(check_button, k);
			local value = SAPI.GetSibling(check_button, v);
			if SAPI.Equal(check_button, key) == true then
				key:SetChecked(true);
				value:ShowAndFocus();
			else
				key:SetChecked(false);
				value:Hide();
			end
		end
	end
};

function layWorld_FrmNearby_cbNpc_OnLClick(self)
	SClass_CheckButtonGroup:Active(self);
end

function layWorld_FrmNearby_cbUser_OnLClick(self)
	SClass_CheckButtonGroup:Active(self);
end

function layWorld_FrmNearby_lbUser_lsbUser_OnRDown(self, mouse_x, mouse_y)
	local line, col = uiGetListBoxPickItem(self, mouse_x, mouse_y);
	if line == nil then return end -- 没有这行
	self:SetSelect(line);
	local name = self:getLineItemText(line, 0);
	if name == nil or name == "" then return end
	
	uiShowPopmenuPlayer(name, true);
end

function layWorld_FrmNearby_lbNpc_OnLoad(self)
	self:RegisterScriptEventNotify("EVENT_SelfEnterWorld");
	self:RegisterScriptEventNotify("EVENT_SelfRegionChanged");
end
function layWorld_FrmNearby_lbNpc_OnEvent(self, event, args)
	if event == "EVENT_SelfRegionChanged" then
		layWorld_FrmNearby_lbNpc_Refresh(self);
	elseif event == "EVENT_SelfEnterWorld" then
		--layWorld_FrmNearby_lbNpc_Refresh(self);
	end
end

function layWorld_FrmNearby_lbNpc_OnShow(self)
	layWorld_FrmNearby_lbNpc_Refresh(self);
end

function layWorld_FrmNearby_lbUser_Refresh(self)
	if self == nil then self = uiGetglobal("layWorld.FrmNearby.lbUser") end
	if self:getVisible() == false then return end
	local lsbUser = SAPI.GetChild(self, "lsbUser");
	
	local select_name = nil;
	local select_line = lsbUser:getSelectLine();
	if select_line ~= nil and select_line ~= -1 then
		select_name = lsbUser:getLineItemText(select_line, 0);
	end
	lsbUser:RemoveAllLines();
	local UserList = uiAreaGetNearPlayerList();
	if UserList == nil then return end
	local UserInfoList = {};
	for i, v in ipairs(UserList) do
		local id, name, party, level, have_team, is_captain, team_size = uiAreaGetNearPlayerInfo(v);
		if id ~= nil then
			table.insert(UserInfoList, {id = id, name = name, party = party, level = level, have_team = have_team, is_captain = is_captain, team_size = team_size});
		end
	end
	
	table.sort(UserInfoList, function (arg1, arg2) return arg1.level > arg2.level end);
	
	for i, v in ipairs(UserInfoList) do
		lsbUser:InsertLine(-1, 4294967295, -1);
		lsbUser:SetLineItem(i-1, 0, v.name, 4294967295);
		lsbUser:SetLineItem(i-1, 1, tostring(v.level), 4294967295);
		local strParty = uiGetPartyInfo(v.party);
		lsbUser:SetLineItem(i-1, 2, strParty, 4294967295);
		local strTeam = "--";
		if v.have_team == true then
			if v.is_captain == true then
				strTeam = string.format(LAN("dteam_official_leader").."(%d)", v.team_size);
			else
				strTeam = string.format(LAN("dteam_official_mass"));
			end
		end
		lsbUser:SetLineItem(i-1, 3, strTeam, 4294967295);
		if v.name == select_name then
			lsbUser:SetSelect(i-1);
		end
	end
end

function layWorld_FrmNearby_lbUser_btRefresh_OnLClick(self)
	uiAreaRefreshNearPlayerData();
end

function layWorld_FrmNearby_lbUser_btClose_OnLClick(self)
	local FrmNearby = SAPI.GetParent(SAPI.GetParent(self));
	FrmNearby:Hide();
end

function layWorld_FrmNearby_lbUser_OnLoad(self)
	self:RegisterScriptEventNotify("RefreshAroundUser");
end
function layWorld_FrmNearby_lbUser_OnEvent(self, event, arg)
	if event == "RefreshAroundUser" then
		layWorld_FrmNearby_lbUser_Refresh(self);
	end
end
function layWorld_FrmNearby_lbUser_OnShow(self)
	layWorld_FrmNearby_lbUser_Refresh(self);
end

function layWorld_FrmNearby_lbNpc_Refresh(self)
	if self == nil then self = uiGetglobal("layWorld.FrmNearby.lbNpc") end
	if self:getVisible() == false then return end
	local AreaName, NpcList = uiAreaGetNearNpcList();
	if AreaName == nil then return end
	local ebNpcList = SAPI.GetChild(self, "ebNpcList");
	ebNpcList:RemoveAllLines();
	local rich_text = EvUiLuaClass_RichText:new();
	ebNpcList:SetText(AreaName);
	for i, v in ipairs(NpcList) do
		local id, name, x, y, mapid = uiAreaGetNearNpcInfo(v);
		if id ~= nil then
			local line = EvUiLuaClass_RichTextLine:new();
			local item = EvUiLuaClass_RichTextItem:new();
			item.Type = "TEXT";
			item.Text = string.format("%s [%d,%d]", name, x, y);
			item.Hlink = string.format("String:task:locate?px=%d&py=%d&hint=%s&mapid=%d", x, y, name, mapid);
			line:InsertItem(item);
			rich_text:InsertLine(line);
		end
	end
	ebNpcList:SetRichText(rich_text:ToRichString(), true);
end

function layWorld_FrmNearby_lbNpc_btRefresh_OnLClick(self)
	local lbNpc = SAPI.GetParent(self);
	layWorld_FrmNearby_lbNpc_Refresh(lbNpc);
end

function layWorld_FrmNearby_lbNpc_btClose_OnLClick(self)
	local FrmNearby = SAPI.GetParent(SAPI.GetParent(self));
	FrmNearby:Hide();
end

function layWorld_FrmNearby_lbNpc_ebNpcList_OnHyperLink(self, hypertype, hyperlink)
    if hyperlink ~= nil then
        Receive(hyperlink);
    end
end

function layWorld_FrmNearby_OnShow(self)
	uiRegisterEscWidget(self);
	uiAreaRefreshNearPlayerData();
	layWorld_FrmNearby_lbNpc_Refresh();
end

function layWorld_FrmNearby_OnLoad(self)
	local cbNPC = SAPI.GetChild(self, "cbNPC");
	SClass_CheckButtonGroup:Active(cbNPC);
end



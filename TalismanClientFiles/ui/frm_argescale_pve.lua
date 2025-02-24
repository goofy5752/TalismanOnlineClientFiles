local NeedUpdatePveInfo = true;
local NeedUpdatePveRank = true;
local NeedRefreshPveRebornArea = true;
local NeedRefreshPveBossState = true;
local NeedRefreshPveRank = true;
local PveRankSeletedName = "";
local PveRankNameList = {}
local PveCurrentPoint = 0;

local function UpdateLargescalePVERebornAreaList(self)
	if not NeedRefreshPveRebornArea then return end
	if self:getVisible() == false then return end
	self:RemoveAllLines(false);
	local list = uiPveGetRebornAreaIdList();
	if not list then return end
	local selflistcount = 0;
	for i, v in ipairs(list) do
		local id, name, usercnt =  uiPevGetRebornAreaInfo(v);
		if id and id == v then
			self:InsertLine(-1, -1, -1);
			selflistcount = selflistcount + 1;
			self:SetLineItem(selflistcount - 1, 0, name, -1);
			self:SetLineItem(selflistcount - 1, 1, tostring(usercnt), -1);
		end
	end
	NeedRefreshPveRebornArea = false;
end

local function UpdateLargescalePVEBossStateList(self)
	if not NeedRefreshPveBossState then return end
	if self:getVisible() == false then return end
	self:RemoveAllLines(false);
	local list = uiPveGetBossIdList();
	if not list then return end
	local selflistcount = 0;
	for i, v in ipairs(list) do
		local name, state =  uiPevGetBossInfo(v);
		if state then
			self:InsertLine(-1, -1, -1);
			selflistcount = selflistcount + 1;
			self:SetLineItem(selflistcount - 1, 0, name, -1);
			local statestring = LAN("msg_pve_boss_alive");
			if state == 1 then
				statestring = LAN("msg_pve_boss_dead");
			end
			self:SetLineItem(selflistcount - 1, 1, statestring, -1);
		end
	end
	NeedRefreshPveBossState = false;
end

local function UpdateLargescalePVE(self)
	-- RebornArea
	local lstAreaContent = SAPI.GetChild(self, "lstAreaContent");
	UpdateLargescalePVERebornAreaList(lstAreaContent);
	-- BossState
	local lstBossContent = SAPI.GetChild(self, "lstBossContent");
	UpdateLargescalePVEBossStateList(lstBossContent);
end

local function UpdateLargescalePVERankList(self)
	if not NeedRefreshPveRank then return end
	if self:getVisible() == false then return end
	
	self:RemoveAllLines(false);
	PveRankNameList = {};
	local count = uiPveGetRankCount();
	local selflistcount = 0;
	for i = 0, count-1 do
		local name, party, level, guild, point = uiPveGetRankRecordInfo(i);
		if name then
			self:InsertLine(-1, -1, -1);
			self:SetLineItem(selflistcount, 0, name, -1);
			self:SetLineItem(selflistcount, 1, guild, -1);
			self:SetLineItem(selflistcount, 2, tostring(level), -1);
			local partyname = uiGetPartyInfo(party);
			self:SetLineItem(selflistcount, 3, partyname, -1);
			self:SetLineItem(selflistcount, 4, tostring(point), -1);
			if name == PveRankSeletedName then
				self:SetSelect(selflistcount);
			end
			PveRankNameList[name] = selflistcount;
			selflistcount = selflistcount + 1;
		end
	end
	
	NeedRefreshPveRank = false;
end

local function UpdateLargescalePVERank(self)
	local lstuserRanking = SAPI.GetChild(self, "lstuserRanking");
	UpdateLargescalePVERankList(lstuserRanking);
	
	local lbCurrentlyIntegral = SAPI.GetChild(self, "lbCurrentlyIntegral");
	lbCurrentlyIntegral:SetText(tostring(PveCurrentPoint));
	local lbPeakIntegral = SAPI.GetChild(self, "lbPeakIntegral");
	local TopPoint = uiGetMyInfo("PvePoint");
	lbPeakIntegral:SetText(tostring(TopPoint));
	
	local lbuserpoint = uiGetglobal("layWorld.frmLargescalePVE.lbuserpoint");
	lbuserpoint:SetText(tostring(PveCurrentPoint));
end

function layWorld_btnPVE_OnLoad(self)
	self:RegisterScriptEventNotify("EVENT_SelfEnterScene");
end

function layWorld_btnPVE_OnEvent(self, event, args)
	if event == "EVENT_SelfEnterScene" then
		local SceneId = args[2];
		if SceneId == 21 then
			self:ShowAndFocus();
		else
			self:Hide();
			uiGetglobal("layWorld.frmLargescalePVE"):Hide();
		end
	end
end

function layWorld_frmLargescalePVE_OnLoad(self)
	self:RegisterScriptEventNotify("Event_UpdatePevInfo");
end

function layWorld_frmLargescalePVE_OnEvent(self, event, args)
	if event == "Event_UpdatePevInfo" then
		NeedRefreshPveRebornArea = true;
		NeedRefreshPveBossState = true;
		UpdateLargescalePVE(self);
	end
end

function layWorld_frmLargescalePVE_OnShow(self)
	UpdateLargescalePVE(self);
	if NeedUpdatePveInfo == true then
		uiPveUpdateInfo();
		NeedUpdatePveInfo = false;
	end
end

function layWorld_frmLargescalePVE_OnUpdate(self)
	NeedRefreshPveRebornArea = true;
	NeedRefreshPveBossState = true;
	UpdateLargescalePVE(self);
end

function layWorld_frmLargescalePVERank_lstuserRanking_OnSelect(self)
	local select = self:getSelectLine();
	PveRankSeletedName = "";
	if select and select >= 0 then
		PveRankSeletedName = self:getLineItemText(select, 0);
	end
end

function layWorld_frmLargescalePVERank_btnFindUser_OnLClick(self)
	local lstuserRanking = SAPI.GetSibling(self, "lstuserRanking");
	local edUserName = SAPI.GetSibling(self, "edUserName");
	lstuserRanking:SetSelect(-1);
	local name = edUserName:getText();
	if name then
		local line = PveRankNameList[name];
		if line then
			lstuserRanking:SetSelect(line);
		end
	end
end

function layWorld_frmLargescalePVERank_OnLoad(self)
	self:RegisterScriptEventNotify("Event_UpdatePveRank");
	self:RegisterScriptEventNotify("EVENT_LocalGurl");
end

function layWorld_frmLargescalePVERank_OnEvent(self, event, args)
	if event == "Event_UpdatePveRank" then
		PveCurrentPoint = args[1];
		NeedRefreshPveRank = true;
		UpdateLargescalePVERank(self);
	elseif event == "EVENT_LocalGurl" then
		local address = args[1];
		if address == "pverank" then
			self:ShowAndFocus();
		end
	end
end

function layWorld_frmLargescalePVERank_OnShow(self)
	UpdateLargescalePVERank(self);
	if NeedUpdatePveRank == true then
		uiPveUpdateRank();
		NeedUpdatePveRank = false;
	end
end




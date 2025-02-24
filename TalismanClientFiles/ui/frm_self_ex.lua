
function frmSelfEx_TemplateLabPkMode_OnLoad(self)
	self:RegisterScriptEventNotify("event_cre_pkmode_changed");
	self:RegisterScriptEventNotify("EVENT_SelfRefresh");
end

function frmSelfEx_TemplateLabPkMode_OnEvent(self, event, args)
	if event == "EVENT_SelfRefresh" or "event_cre_pkmode_changed" then
		frmSelfEx_TemplateLabPkMode_Refresh(self);
	end
end

function frmSelfEx_TemplateLabPkMode_Refresh(self)
	if self == nil then return end
	-- PK
	local pk, pkmode = uiGetMyInfo("Pk");
	local ID = self.ID;
	if ID == nil then self:Hide() return end
	if ID == pkmode then
		self:Show();
	else
		self:Hide();
	end
end
		  
		  
function layWorld_frmSelfEx_OnLoad(self)
	self:RegisterScriptEventNotify("EVENT_SelfRefresh");
end

function layWorld_frmSelfEx_OnEvent(self, event, args)
	if event == "EVENT_SelfRefresh" then
		layWorld_frmSelfEx_Refresh(self);
	end
end

function layWorld_frmSelfEx_Refresh(self)
	if self == nil then self = uiGetglobal("layWorld.frmSelfEx") end
	-- 角色信息 -- 名字 -- 门派 -- 性别 -- 头像
	local name, party, sex, headicon = uiGetMyInfo("Role");
	local lbName = SAPI.GetChild(self, "lbName");
	lbName:SetText(name);
	local btCharHead = SAPI.GetChild(self, "btCharHead")
	btCharHead:SetNormalImage(SAPI.GetImage(headicon));
	local lbComboTitle = SAPI.GetChild(self, "lbComboTitle");
	if party == EV_PARTY_QC then
		lbComboTitle:Show();
	else
		lbComboTitle:Hide();
	end
	local lbSavePoint = SAPI.GetChild(self, "lbSavePoint");
	if party == EV_PARTY_FM then
		lbSavePoint:Show();
	else
		lbSavePoint:Hide();
	end
	-- 经验 -- 等级
	local level, curexp, maxexp = uiGetMyInfo("Exp");
	local lbCharLev = SAPI.GetChild(self, "lbCharLev")
	lbCharLev:SetText(tostring(level));
	-- HP
	local pbCharHP = SAPI.GetChild(self, "pbCharHP");
	local hp, maxhp = uiGetMyInfo("Hp");
	pbCharHP:SetValue(hp/maxhp);
	pbCharHP:SetText(string.format("%d / %d", hp, maxhp));
	-- MPSP
	local mpsp, maxmpsp = uiGetMyInfo("MpSp");
	local pbCharMP = SAPI.GetChild(self, "pbCharMP");
	local pbCharSP = SAPI.GetChild(self, "pbCharSP");
	local pbCharMPSP = nil;
	if party == EV_PARTY_QC or party == EV_PARTY_FM then
		pbCharMP:Hide();
		pbCharMPSP = pbCharSP;
	else
		pbCharSP:Hide();
		pbCharMPSP = pbCharMP;
	end
	pbCharMPSP:Show();
	pbCharMPSP:SetValue(mpsp/maxmpsp);
	pbCharMPSP:SetText(string.format("%d / %d", mpsp, maxmpsp));
end

function layWorld_frmSelfEx_btCharHead_OnRClick(self)
	local name = uiGetMyInfo("Role");
	local online = true;
	uiShowPopmenuPlayer(name, online);
end

function layWorld_frmSelfEx_btCharHead_OnLClick(self)
	local id = uiGetMyInfo("ObjectId");
	if Local_Skill_UseSkillDispatcher:IsProcessing() and Local_Skill_UseSkillDispatcher:Target(id) then
	else
		uiUserSetTarget(id);
	end
end

function layWorld_frmSelfEx_lbComboTitle_OnUpdate(self)
	local CurHit = self.CurHit;
	if CurHit == nil then CurHit = 0 end
	local hit = uiGetMyInfo("Battle");
	if CurHit == hit then return end
	local scanmax = 0;
	if CurHit > hit then
		scanmax = CurHit;
	else
		scanmax = hit;
	end
	for i = 1, scanmax, 1 do
		local ckbPoint = SAPI.GetChild(self, "ckbPoint"..i);
		if ckbPoint == nil then break end
		ckbPoint:SetChecked(i <= hit);
	end
	CurHit = hit;
	self.CurHit = CurHit;
end

function layWorld_frmSelfEx_lbSavePoint_OnUpdate(self)
	local CurPoint = self.CurPoint;
	if CurPoint == nil then CurPoint = 0 end
	local hit, point = uiGetMyInfo("Battle");
	if CurPoint == point then return end
	local scanmax = 0;
	if CurPoint > point then
		scanmax = CurPoint;
	else
		scanmax = point;
	end
	for i = 1, scanmax, 1 do
		local ckbPoint = SAPI.GetChild(self, "ckbPoint"..i);
		if ckbPoint == nil then break end
		ckbPoint:SetChecked(i <= point);
	end
	CurPoint = point;
	self.CurPoint = CurPoint;
end

------------------------------------------------
---------------frmSelfBuffEx-------------------
------------------------------------------------

function frmSelfEx_TemplateBtnSelfBuff_Refresh(self)
	if not self then return end
	local ID = self.ID;
	if not ID or ID == 0 then self:Hide() return end
	local id, icon, hideicon, hidetime = uiSkill_GetEffectClassInfo(ID);
	if not id or id == 0 or hideicon == true then self:Hide() return end
	local lbIcon = SAPI.GetChild(self, "lbIcon");
	lbIcon:SetBackgroundImage(SAPI.GetImage(icon));
	lbIcon.ID = ID;
	local lbTime = SAPI.GetChild(self, "lbTime");
	if hideicon == true then
		lbTime:Hide();
	else
		lbTime.ID = ID;
		lbTime:Show();
	end
	self:Show();
end

function frmSelfEx_TemplateBtnSelfBuff_lbTime_OnUpdate(self)
	local ID = self.ID;
	if not ID or ID == 0 then self:Hide() return end
	local id, lefttime, triggercount = uiSkill_GetMyEffectInfo(ID);
	lefttime = lefttime / 1000; -- 得到的lefttime是毫秒
	if id and id > 0 then
		local h = math.floor(lefttime / 3600);
		local m = math.floor(math.mod(lefttime / 60, 60));
		local s = math.floor(math.mod(lefttime, 60));
		local text = "";
        if (h >= 24) then
			text = string.format(LAN("MSG_DAY"), math.floor(h / 24));
        elseif (h > 0) then
			text = string.format(LAN("MSG_HOUR"), h);
        elseif (m > 0) then
			text = string.format("%02d:%02d", m, s);
        elseif (s > 0) then
			text = string.format(LAN("MSG_SECONDS"), s);
		end
		self:SetText(text);
		local lbIcon = SAPI.GetSibling(self, "lbIcon");
		if triggercount > 0 then
			lbIcon:SetText(tostring(triggercount));
		else
			lbIcon:SetText("");
		end
	else
		self:Hide();
		uiError("frmSelfEx_TemplateBtnSelfBuff_lbTime_OnUpdate : Can't find self effect by ID = "..tostring(ID));
	end
end

function frmSelfEx_TemplateBtnSelfBuff_lbIcon_OnHint(self)
	local ID = self.ID;
	if not ID or ID == 0 then return end
	local hint = uiSkill_GetMyEffectHint(ID);
	self:SetHintRichText(hint);
end

function frmSelfEx_TemplateBtnSelfBuff_lbIcon_OnRClick(self)
	local ID = self.ID;
	if not ID or ID == 0 then return end
	uiSkill_RemoveMyEffect(ID);
end

function layWorld_frmSelfBuffEx_OnLoad(self)
	self:RegisterScriptEventNotify("EVENT_SelfRefresh");
end

function layWorld_frmSelfBuffEx_OnEvent(self, event, args)
	if event == "EVENT_SelfRefresh" then
		layWorld_frmSelfBuffEx_Refresh(self);
	end
end

function layWorld_frmSelfBuffEx_Refresh(self)
	if not self then return end
	local bufflist = uiGetMyInfo("EffectList");
	if not bufflist or table.getn(bufflist) <= 0 then self:Hide() return end
	for i = 1, 13, 1 do
		local btBuff = SAPI.GetChild(self, "btBuff"..i);
		btBuff.ID = bufflist[i];
		frmSelfEx_TemplateBtnSelfBuff_Refresh(btBuff);
	end
	self:Show();
end

















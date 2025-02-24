
function frmTargetEx_TemplateBtnBuf_OnHint(self)
	local ID = self.ID;
	if not ID or ID == 0 then return end
	local hint = uiSkill_GetTargetBuffHint(ID);
	self:SetHintRichText(hint);
end

function frmTargetEx_TemplateBtnBuf_Refresh(self)
	if not self then return end
	local ID = self.ID;
	if not ID or ID == 0 then self:Hide() return end
	local id, icon = uiSkill_GetEffectClassInfo(ID);
	if not id or id == 0 then self:Hide() return end
	self:SetNormalImage(SAPI.GetImage(icon));
	self:Show();
end

function layWorld_frmTargetEx_OnLoad(self)
	self:RegisterScriptEventNotify("EVENT_TargetRefresh");
	self:RegisterScriptEventNotify("TargetChanged");
end

function layWorld_frmTargetEx_OnEvent(self, event, args)
	if event == "EVENT_TargetRefresh" or event == "TargetChanged" then
		layWorld_frmTargetEx_Refresh(self);
	end
end

function layWorld_frmTargetEx_Refresh(self)
	if self == nil then self = uiGetglobal("layWorld.frmTargetEx") end
	local id, name, showname, canbeseenface, level, party, sex, icon, hp, maxhp, hpLayer, mpsp, maxmpsp, bufflist, npctitle = uiUserGetTargetInfo();
	local myLevel = uiGetMyInfo("Exp");
	if id == nil or id == 0 then self:Hide() return end
	-- 名字
	local lbName = SAPI.GetChild(self, "lbName");
	lbName:SetText(showname);
	-- 等级
	local lbTargetLev = SAPI.GetChild(self, "lbTargetLev");
	local leveltext = tostring(level);
	local levelcolor = 4294967040;--0xffffff00;
	if level >= (myLevel + 10) then
        leveltext = "??";
        levelcolor = 4294901760;--0xffff0000;
	elseif level >= (myLevel + 5) then
        levelcolor = 4294901760;--0xffff0000;
	elseif level >= (myLevel + 2) then
        levelcolor = 4293853184;--0xffef0000;
	elseif level >= (myLevel + 0) then
        levelcolor = 4294967040;--0xffffff00;
	else
		local Attenuation = uiGetAttenuation(myLevel, level);
		if Attenuation > 0.8001 then
            levelcolor = 4294967040;--0xffffff00;
		elseif Attenuation > 0.5001 then
            levelcolor = 4278255360;--0xff00ff00;
		else
            levelcolor = 4290756543;--0xffbfbfbf;
		end
	end
	lbTargetLev:SetText(leveltext);
	lbTargetLev:SetTextColor(levelcolor);
	-- 头像
	local btHead = SAPI.GetChild(self, "btHead");
	btHead:SetNormalImage(icon);
	-- HP
	local HpRateList = {[1]=maxhp};
	for i, v in ipairs(hpLayer) do
		if v > 0 then
			table.insert(HpRateList, maxhp * v);
		end
	end
	table.sort(HpRateList);
	local hpindex = 1;
	for i, v in ipairs(HpRateList) do
		local pbHP = SAPI.GetChild(self, "pbHP"..i);
		pbHP:Show();
		if hp > v then
			pbHP:SetValue(1);
		else
			local rate = nil;
			local localhp = hp;
			local localmaxhp = v;
			if i > 1 then
				localhp = hp - HpRateList[i-1];
				localmaxhp = v - HpRateList[i-1];
			end
			pbHP:SetValue(localhp / localmaxhp);
			break;
		end
		hpindex = hpindex + 1;
	end
	for i = hpindex + 1, 5, 1 do
		-- 隐藏剩余的层
		local pbHP = SAPI.GetChild(self, "pbHP"..i);
		pbHP:Hide();
	end
	-- MPSP
	local pbMP = SAPI.GetChild(self, "pbMP");
	local pbSP = SAPI.GetChild(self, "pbSP");
	local pbMPSP = nil;
	if party == EV_PARTY_QC or party == EV_PARTY_FM then
		pbMP:Hide();
		pbMPSP = pbSP;
	else
		pbSP:Hide();
		pbMPSP = pbMP;
	end
	pbMPSP:Show();
	pbMPSP:SetValue(mpsp/maxmpsp);
	-- buff
	local lbBuff = SAPI.GetChild(self, "lbBuff");
	for i = 1, 13, 1 do
		local btBuff = SAPI.GetChild(lbBuff, "btBuff"..i);
		btBuff.ID = bufflist[i];
		frmTargetEx_TemplateBtnBuf_Refresh(btBuff);
	end
	local lbNpcTitleJY = SAPI.GetChild(self, "lbNpcTitleJY");
	local lbNpcTitleYY = SAPI.GetChild(self, "lbNpcTitleYY");
	if npctitle == 1 then
		lbNpcTitleJY:Show();
		lbNpcTitleYY:Hide();
	elseif npctitle == 2 then
		lbNpcTitleYY:Show();
		lbNpcTitleJY:Hide();
	else
		lbNpcTitleJY:Hide();
		lbNpcTitleYY:Hide();
	end
	self:Show();
end

function layWorld_frmTargetEx_btHead_OnLClick(self)
	local id = uiUserGetTargetInfo();
	if Local_Skill_UseSkillDispatcher:IsProcessing() then
		Local_Skill_UseSkillDispatcher:Target(id);
	end
end

function layWorld_frmTargetEx_btHead_OnRClick(self)
	uiShowPopmenuTarget();
end







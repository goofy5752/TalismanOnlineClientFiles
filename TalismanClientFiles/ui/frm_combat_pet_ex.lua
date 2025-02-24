
function frmTargetEx_TemplateBtnSelfPetBuff_OnHint(self)
	local ID = self.ID;
	if not ID or ID == 0 then return end
	local hint = uiSkill_GetCurrentCombatPetBuffHint(ID);
	self:SetHintRichText(hint);
end

function frmTargetEx_TemplateBtnSelfPetBuff_Refresh(self)
	if not self then return end
	local ID = self.ID;
	if not ID or ID == 0 then self:Hide() return end
	local id, icon = uiSkill_GetEffectClassInfo(ID);
	if not id or id == 0 then self:Hide() return end
	self:SetNormalImage(SAPI.GetImage(icon));
	self:Show();
end

function layWorld_frmCombatPetEx_OnLoad(self)
	self:RegisterScriptEventNotify("EVENT_SelfPetRefresh");
end

function layWorld_frmCombatPetEx_OnEvent(self, event, args)
	if event == "EVENT_SelfPetRefresh" then
		layWorld_frmCombatPetEx_Refresh(self);
	end
end

function layWorld_frmCombatPetEx_Refresh(self)
	if not self then self = uiGetglobal("layWorld.frmCombatPetEx") end
	local id, name, level, icon, hp, maxhp, sp, maxsp, bufflist = uiUserGetCurrentCombatPetInfo();
	if not id or id == 0 then self:Hide() return end
	-- 头像
	local btHead = SAPI.GetChild(self, "btHead");
	btHead:SetNormalImage(SAPI.GetImage(icon));
	-- 名字
	local lbName = SAPI.GetChild(self, "lbName");
	lbName:SetText(name);
	-- 等级
	local lbLev = SAPI.GetChild(self, "lbLev");
	lbLev:SetText(tostring(level));
	-- HP
	local pbHP = SAPI.GetChild(self, "pbHP");
	pbHP:SetValue(hp / maxhp);
	pbHP:SetText(string.format("%d / %d", hp, maxhp));
	-- SP
	local pbSP = SAPI.GetChild(self, "pbSP");
	pbSP:SetValue(sp / maxsp);
	pbSP:SetText(string.format("%d / %d", sp, maxsp));
	-- bufflist
	local lbBuff = SAPI.GetChild(self, "lbBuff");
	for i = 1, 13, 1 do
		local btBuff = SAPI.GetChild(lbBuff, "btBuff"..i);
		btBuff.ID = bufflist[i];
		frmTargetEx_TemplateBtnSelfPetBuff_Refresh(btBuff);
	end
	self:Show();
end

function layWorld_frmCombatPetEx_btHead_OnLClick(self)
	local id = uiUserGetCurrentCombatPetInfo();
	if Local_Skill_UseSkillDispatcher and Local_Skill_UseSkillDispatcher:IsProcessing() then
		Local_Skill_UseSkillDispatcher:Target(id);
	else
		uiUserSetTarget(id);
	end
end

function layWorld_frmCombatPetEx_btHead_OnRClick(self)
	uiShowPopmenuCurrentCombatPet();
end






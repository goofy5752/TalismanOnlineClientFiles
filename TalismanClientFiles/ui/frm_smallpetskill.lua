function layWorld_frmSmallPetSkill_OnLoad(self)
	self:RegisterScriptEventNotify("EVENT_ItemUseIndirect");
end

function layWorld_frmSmallPetSkill_OnEvent(self, event, args)
	if event == "EVENT_ItemUseIndirect" then
		local id = args[1];
		if id == nil or id == 0 then self:Hide() return end
		local objInfo = uiItemGetBagItemInfoByObjectId(id);
		local index = objInfo.TableId; -- 道具表格id
		if index == nil or index == 0 then self:Hide() return end
		local classInfo = uiItemGetItemClassInfoByTableIndex(index);
		if classInfo == nil then self:Hide() return end
		local Type = classInfo.Type;
		if id == nil or Type == nil then
			uiError(string.format("id=%s Type=%s", tostring(id), tostring(Type)));
			self:Hide();
			return;
		end
		self.ItemId = id; -- 相当于self:Set("ItemId", id);
		if Type == EV_ITEM_TYPE_FORGETSMALLPETONESKILL then
			self:ShowAndFocus();
		end
	end
end

function layWorld_frmSmallPetSkill_OnShow(self)
	uiRegisterEscWidget(self);
	layWorld_frmSmallPetSkill_Refresh(self);
end

function layWorld_frmSmallPetSkill_Refresh(self)
	if self == nil then self = uiGetglobal("layWorld.frmSmallPetSkill") end
	local lboption = uiGetChild(self, "lboption");
	local lsbSmallPetSkilllist = uiGetChild(lboption, "lsbSmallPetSkilllist");
	layWorld_frmSmallPetSkill_lboption_lsbSmallPetSkilllist_Refresh(lsbSmallPetSkilllist);
end

function layWorld_frmSmallPetSkill_lboption_lsbSmallPetSkilllist_Refresh(self)
	if self == nil then self = uiGetglobal("layWorld.frmSmallPetSkill.lboption.lsbSmallPetSkilllist") end
	local frmSmallPetSkill = SAPI.GetParent(SAPI.GetParent(self));
	local SelectLine = self:getSelectLine();
	local SelectName = "";
	if SelectLine and SelectLine >= 0 then
		SelectName = self:getLineItemText(SelectLine, 0); -- 保存上次选中项
	end
	self:RemoveAllLines(false);
	local skills = uiPet_GetMySmallPetSkillInfo();
	if skills == nil then frmSmallPetSkill:Hide() return end
	local SkillList = {};
	local count = 0;
	for i, v in ipairs(skills) do
		if i > 1 then
			local Color = 4294967295;
			--白色 4294967295 灰色 4286611584
			self:InsertLine(-1, Color, -1);
			self:SetLineItem(count, 0, v.Name, Color);
			if SelectName == v.Name then self:SetSelect(count) end
			count = count + 1;
			SkillList[v.Name] = v.SkillIndex;
		end
	end
	frmSmallPetSkill.SkillList = SkillList;
end

function layWorld_frmSmallPetSkill_lboption_btnenter_OnLClick(self)
	local frmSmallPetSkill = SAPI.GetParent(SAPI.GetParent(self));
	local id = frmSmallPetSkill.ItemId;
	local SkillList = frmSmallPetSkill.SkillList;
	if id == nil or id <= 0 or SkillList == nil then
		frmSmallPetSkill:Hide();
		return;
	end
	local lsbSmallPetSkilllist = SAPI.GetSibling(self, "lsbSmallPetSkilllist");
	local SelectLine = lsbSmallPetSkilllist:getSelectLine();
	if SelectLine >= 0 then
		local SelectName = lsbSmallPetSkilllist:getLineItemText(SelectLine, 0);
		local skillid = SkillList[SelectName];
		if skillid ~= nil then
			uiItemReleaseItem(id, skillid);
		end
		frmSmallPetSkill:Hide();
	else
		self:Disable();
	end
end

function layWorld_frmSmallPetSkill_lboption_btnenter_OnUpdate(self)
	layWorld_frmSmallPetSkill_lboption_btnenter_Refresh(self);
end

function layWorld_frmSmallPetSkill_lboption_btnenter_Refresh(self)
	if self == nil then self = uiGetglobal("layWorld.frmSmallPetSkill.lboption.btnenter") end
	local lsbSmallPetSkilllist = SAPI.GetSibling(self, "lsbSmallPetSkilllist");
	if lsbSmallPetSkilllist:getSelectLine() >= 0 then
		self:Enable()
	else
		self:Disable();
	end
end

function layWorld_frmSmallPetSkill_lboption_btnclose_OnLClick(self)
	local frmSmallPetSkill = SAPI.GetParent(SAPI.GetParent(self));
	frmSmallPetSkill:Hide();
end

function layWorld_frmSmallPetSkill_lboption_lsbSmallPetSkilllist_OnUpdate(self)
	local now = os.clock();
	local LastUpdate = self.LastUpdate;
	if LastUpdate == nil then
		self.LastUpdate = now;
		return;
	elseif now - LastUpdate < 3 then
		return;
	end
	self.LastUpdate = now;
	layWorld_frmSmallPetSkill_lboption_lsbSmallPetSkilllist_Refresh(self);
end

















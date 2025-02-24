
UI_Skill_Current_Trump_Select = 1

function layWorld_frmSkillEx_Show(self)
	if self:getVisible() then	
		self:Hide()
	else
		self:ShowAndFocus()
		layWorld_frmSkillEx_Refresh()
	end
end

function layWorld_frmSkillEx_Refresh()
	layWorld_frmSkillEx_frmTrumps_Refresh()
	layWorld_frmSkillEx_frmOtherSkills_Refresh()
end

function layWorld_frmSkillEx_frmTrumps_Refresh()
	local self = uiGetglobal("layWorld.frmSkillEx")

	local frmTrumps = SAPI.GetChild(self, "frmTrumps")
	local lbLastPoint = SAPI.GetChild(frmTrumps, "lbLastPoint")
	lbLastPoint:SetText("0")
	lbLastPoint:SetTextColorEx( 51,238,51,255)

	for i=1,3,1 do
		local btnWeapon = SAPI.GetChild(frmTrumps, "btnWeapon"..i)
		btnWeapon:SetNormalImage(0)
		btnWeapon:Delete("ObjectId")
	end

	local labSkills = SAPI.GetChild(frmTrumps, "labSkills")
	for i=1,5,1 do
		local btnSkill = SAPI.GetChild(labSkills,"btnSkill"..i)
		btnSkill:SetNormalImage(0)
		btnSkill:Delete(EV_UI_SHORTCUT_CLASSID_KEY)
		btnSkill:Delete(EV_UI_SHORTCUT_TYPE_KEY)
		btnSkill:Delete(EV_UI_SHORTCUT_OWNER_KEY)
		btnSkill:ModifyFlag("DragOut_RightButton", false)
		btnSkill:ModifyFlag("DragOut_MouseMove", false)
	end

	local lbItemTalent = SAPI.GetChild(frmTrumps,"lbItemTalent")
	for i=1,10,1 do
		local btnTalent = SAPI.GetChild(lbItemTalent,"btnTalent"..i)
		btnTalent:SetNormalImage(0)
		btnTalent:Delete(EV_UI_SHORTCUT_CLASSID_KEY)
		btnTalent:Delete(EV_UI_SHORTCUT_TYPE_KEY)
		btnTalent:Delete(EV_UI_SHORTCUT_OWNER_KEY)
		btnTalent:Delete("itemUpdateLevel")
		btnTalent:ModifyFlag("DragOut_RightButton", false)
		btnTalent:ModifyFlag("DragOut_MouseMove", false)
		btnTalent:SetUltraTextShortcut("")
	end

	local lbFinalSkill = SAPI.GetChild(frmTrumps, "lbFinalSkill")
	for i=1,5,1 do
		local btnSkillTill = SAPI.GetChild(lbFinalSkill,"btnSkillTill"..i)
		btnSkillTill:SetNormalImage(0)
		btnSkillTill:Delete(EV_UI_SHORTCUT_CLASSID_KEY)
		btnSkillTill:Delete(EV_UI_SHORTCUT_TYPE_KEY)
		btnSkillTill:Delete(EV_UI_SHORTCUT_OWNER_KEY)
		btnSkillTill:ModifyFlag("DragOut_RightButton", false)
		btnSkillTill:ModifyFlag("DragOut_MouseMove", false)
	end

	local ltTrump = uiSkill_GetMyTrumpItemInfo()
	if ltTrump == nil then return end

	if ltTrump.Main ~= nil then
		local btnWeapon = SAPI.GetChild(frmTrumps, "btnWeapon1")
		local imgbag = SAPI.GetImage(ltTrump.Main.StrImage, 2, 2, -2, -2)
		if imgbag ~= nil then
			btnWeapon:SetNormalImage(imgbag)
		end
		btnWeapon:Set("ObjectId", ltTrump.Main.ObjectId)

		if btnWeapon:IsHovered() then
			layWorld_frmSkillEx_frmTrumps_btnWeapon_OnHint(btnWeapon)
		end

	end

	if ltTrump.Sub1 ~= nil then
		local btnWeapon = SAPI.GetChild(frmTrumps, "btnWeapon2")
		local imgbag = SAPI.GetImage(ltTrump.Sub1.StrImage, 2, 2, -2, -2)
		if imgbag ~= nil then
			btnWeapon:SetNormalImage(imgbag)
		end
		btnWeapon:Set("ObjectId", ltTrump.Sub1.ObjectId)
		if btnWeapon:IsHovered() then
			layWorld_frmSkillEx_frmTrumps_btnWeapon_OnHint(btnWeapon)
		end
	end

	if ltTrump.Sub2 ~= nil then
		local btnWeapon = SAPI.GetChild(frmTrumps, "btnWeapon3")
		local imgbag = SAPI.GetImage(ltTrump.Sub2.StrImage, 2, 2, -2, -2)
		if imgbag ~= nil then
			btnWeapon:SetNormalImage(imgbag)
		end
		btnWeapon:Set("ObjectId", ltTrump.Sub2.ObjectId)
		if btnWeapon:IsHovered() then
			layWorld_frmSkillEx_frmTrumps_btnWeapon_OnHint(btnWeapon)
		end
	end

	local ltTrumpSkill
	local itemUpdateLevel
	local itemObjectId
	if UI_Skill_Current_Trump_Select == 1 then
		ltTrumpSkill = uiSkill_GetMyTrumpSkillIndexInfo("Main")
		itemUpdateLevel = ltTrump.Main 
	elseif UI_Skill_Current_Trump_Select == 2 then
		ltTrumpSkill = uiSkill_GetMyTrumpSkillIndexInfo("Sub1")
		itemUpdateLevel = ltTrump.Sub1 
	elseif UI_Skill_Current_Trump_Select == 3 then
		ltTrumpSkill = uiSkill_GetMyTrumpSkillIndexInfo("Sub2")
		itemUpdateLevel = ltTrump.Sub2 
	end

	if itemUpdateLevel ~= nil then
		itemObjectId = itemUpdateLevel.ObjectId
		itemUpdateLevel = itemUpdateLevel.UpdateLevel
	else
		return
	end

	if ltTrumpSkill == nil then return end

	lbLastPoint:SetText(""..ltTrumpSkill.SpareTalentPoint)

	local _idx = 1
	for i, _skill in ipairs(ltTrumpSkill.Skill) do
		if _skill.SkillIndex ~= nil then
			local skillBaseInfo = uiSkill_GetSkillBaseInfoByIndex(_skill.SkillIndex)
			if skillBaseInfo ~= nil then
				local btnSkill = SAPI.GetChild(labSkills,"btnSkill".._idx)
				btnSkill:Set(EV_UI_SHORTCUT_CLASSID_KEY, _skill.SkillIndex) 
				btnSkill:Set(EV_UI_SHORTCUT_TYPE_KEY, EV_SHORTCUT_OBJECT_SKILL)
				btnSkill:Set(EV_UI_SHORTCUT_OWNER_KEY, EV_UI_SHORTCUT_OWNER_SKILL)

				local _sImage = SAPI.GetImage(skillBaseInfo.StrImage, 2, 2, -2, -2)
				if _sImage ~= nil then
					btnSkill:SetNormalImage(_sImage)
				end
				
				if itemUpdateLevel >= skillBaseInfo.ActiveTrumpLevel and not skillBaseInfo.IsPassive then
					btnSkill:ModifyFlag("DragOut_RightButton", true)
					btnSkill:ModifyFlag("DragOut_MouseMove", true) 
				end

				if btnSkill:IsHovered() then
					layWorld_frmSkillEx_frmTrumps_labSkills_btnSkill_OnHint(btnSkill)
				end

				_idx = _idx + 1
			end
		end
	end

	_idx = 1
	for i, _skill in ipairs(ltTrumpSkill.FinalSkill) do
		if _skill.SkillIndex ~= nil then
			local skillBaseInfo = uiSkill_GetSkillBaseInfoByIndex(_skill.SkillIndex)
			if skillBaseInfo ~= nil then
				local btnSkillTill = SAPI.GetChild(lbFinalSkill,"btnSkillTill".._idx)
				btnSkillTill:Set(EV_UI_SHORTCUT_CLASSID_KEY, _skill.SkillIndex)
				btnSkillTill:Set(EV_UI_SHORTCUT_TYPE_KEY, EV_SHORTCUT_OBJECT_SKILL)
				btnSkillTill:Set(EV_UI_SHORTCUT_OWNER_KEY, EV_UI_SHORTCUT_OWNER_SKILL)
				local _sImage = SAPI.GetImage(skillBaseInfo.StrImage, 2, 2, -2, -2)
				if _sImage ~= nil then
					btnSkillTill:SetNormalImage(_sImage)
				end
				
				if itemUpdateLevel >= skillBaseInfo.ActiveTrumpLevel and not skillBaseInfo.IsPassive then
					btnSkillTill:ModifyFlag("DragOut_RightButton", true)
					btnSkillTill:ModifyFlag("DragOut_MouseMove", true) 
				end

				--if btnSkillTill:IsHovered() then
					--layWorld_frmSkillEx_frmTrumps_lbFinalSkill_btnSkillTill_OnHint(btnSkillTill)
				--end

				_idx = _idx + 1
			end
		end
	end

	_idx = 1
	for i, _skill in ipairs(ltTrumpSkill.Talent) do
		if _skill.SkillIndex ~= nil then
			local skillBaseInfo = uiSkill_GetSkillBaseInfoByIndex(_skill.SkillIndex)
			if skillBaseInfo ~= nil then
				local btnTalent = SAPI.GetChild(lbItemTalent,"btnTalent".._idx)
				btnTalent:Set(EV_UI_SHORTCUT_CLASSID_KEY, _skill.SkillIndex)
				btnTalent:Set(EV_UI_SHORTCUT_TYPE_KEY, EV_SHORTCUT_OBJECT_SKILL)
				btnTalent:Set(EV_UI_SHORTCUT_OWNER_KEY, EV_UI_SHORTCUT_OWNER_SKILL)
				btnTalent:Set("itemUpdateLevel", itemUpdateLevel)
				local _sImage = SAPI.GetImage(skillBaseInfo.StrImage, 2, 2, -2, -2)
				if _sImage ~= nil then
					btnTalent:SetNormalImage(_sImage)
				end

				if itemUpdateLevel >= skillBaseInfo.ActiveTrumpLevel and not skillBaseInfo.IsPassive then
					btnTalent:ModifyFlag("DragOut_RightButton", true)
					btnTalent:ModifyFlag("DragOut_MouseMove", true) 
				end

				local _slev = uiSkill_GetWeaponTalentLevelInItem(itemObjectId, _skill.SkillIndex)
				
				if _slev > 0 then
					btnTalent:SetUltraTextShortcut("".._slev)
					btnTalent:SetUltraTextBkColorShortcut(17,17,17,238)
				else
					btnTalent:SetUltraTextShortcut("")
				end

				--if btnTalent:IsHovered() then
					--layWorld_frmSkillEx_frmTrumps_lbItemTalent_btnTalent_OnHint(btnTalent)
				--end

				_idx = _idx + 1
			end
		end
	end
end

function layWorld_frmSkillEx_frmTrumps_btnWeapon_OnHint(self)
	local frmSkillEx = uiGetglobal("layWorld.frmSkillEx")

	local frmTrumps = SAPI.GetChild(frmSkillEx, "frmTrumps")

	for i=1,3,1 do
		local btnWeapon = SAPI.GetChild(frmTrumps, "btnWeapon"..i)
		if SAPI.Equal(self, btnWeapon) then
			local richText
			if i == 1 then
				richText = uiSkill_GetMyTrumpItemRichText("Main")
			elseif i == 2 then
				richText = uiSkill_GetMyTrumpItemRichText("Sub1")
			elseif i == 3 then
				richText = uiSkill_GetMyTrumpItemRichText("Sub2")
			end

			if richText ~= nil then
				self:SetHintRichText(richText)
			else
				self:SetHintRichText(0)
			end
			return
		end
	end
end

function layWorld_frmSkillEx_frmTrumps_labSkills_btnSkill_OnHint(self)
	local skillIndex = self:Get(EV_UI_SHORTCUT_CLASSID_KEY)
	if skillIndex == nil then
		self:SetHintRichText(0)
		return
	end
	local richText = uiSkill_GetMyTrumpSkillRichText("Skill", skillIndex)
	if richText ~= nil then
		self:SetHintRichText(richText)
	else
		self:SetHintRichText(0)
	end
end

function layWorld_frmSkillEx_frmTrumps_lbItemTalent_btnTalent_OnHint(self)
	local skillIndex = self:Get(EV_UI_SHORTCUT_CLASSID_KEY)
	if skillIndex == nil then
		self:SetHintRichText(0)
		return
	end
	local richText = uiSkill_GetMyTrumpSkillRichText("Talent",skillIndex)
	if richText ~= nil then
		self:SetHintRichText(richText)
	else
		self:SetHintRichText(0)
	end
end

function layWorld_frmSkillEx_frmTrumps_lbFinalSkill_btnSkillTill_OnHint(self)
	local skillIndex = self:Get(EV_UI_SHORTCUT_CLASSID_KEY)
	if skillIndex == nil then
		self:SetHintRichText(0)
		return
	end
	local richText = uiSkill_GetMyTrumpSkillRichText("FinalSkill",skillIndex)
	if richText ~= nil then
		self:SetHintRichText(richText)
	else
		self:SetHintRichText(0)
	end
end

function layWorld_frmSkillEx_frmTrumps_btnWeapon_OnLClick(self)
	local frmSkillEx = uiGetglobal("layWorld.frmSkillEx")

	local frmTrumps = SAPI.GetChild(frmSkillEx, "frmTrumps")

	for i=1,3,1 do
		local btnWeapon = SAPI.GetChild(frmTrumps, "btnWeapon"..i)
		btnWeapon:SetChecked(false)
		if SAPI.Equal(btnWeapon, self) then
			UI_Skill_Current_Trump_Select = i
		end
	end

	self:SetChecked(true)
	layWorld_frmSkillEx_frmTrumps_Refresh()
end

function layWorld_frmSkillEx_Player_EnterWorld()
	local frmSkillEx = uiGetglobal("layWorld.frmSkillEx")

	local frmTrumps = SAPI.GetChild(frmSkillEx, "frmTrumps")
	local frmOtherSkills = SAPI.GetChild(frmSkillEx, "frmOtherSkills")

	local btnWeapon = SAPI.GetChild(frmTrumps, "btnWeapon1")
	btnWeapon:SetChecked(true)
	UI_Skill_Current_Trump_Select = 1

	local btnSkills = SAPI.GetChild(frmSkillEx, "btnSkills")
	local btnOtherSkills = SAPI.GetChild(frmSkillEx, "btnOtherSkills")

	btnSkills:SetChecked(true)
	btnOtherSkills:SetChecked(false)

	frmTrumps:Show()
	frmOtherSkills:Hide()
	layWorld_frmSkillEx_Refresh()

	local btNormal2 = SAPI.GetChild(frmTrumps, "btNormal2")
	local btBlend = SAPI.GetChild(frmTrumps, "btBlend")

	btNormal2:ModifyFlag("DragOut_MouseMove", true)
	btBlend:ModifyFlag("DragOut_MouseMove", true)

	btNormal2:Set(EV_UI_SHORTCUT_TYPE_KEY, EV_SHORTCUT_OBJECT_MISC)
	btNormal2:Set(EV_UI_SHORTCUT_OWNER_KEY, EV_UI_SHORTCUT_OWNER_MISC)
	btNormal2:Set(EV_UI_SHORTCUT_OBJECTID_KEY, EV_UI_SHORTCUT_OBJECTID_MISC_PRACTICE)

	btBlend:Set(EV_UI_SHORTCUT_TYPE_KEY, EV_SHORTCUT_OBJECT_MISC)
	btBlend:Set(EV_UI_SHORTCUT_OWNER_KEY, EV_UI_SHORTCUT_OWNER_MISC)
	btBlend:Set(EV_UI_SHORTCUT_OBJECTID_KEY, EV_UI_SHORTCUT_OBJECTID_MISC_ITEMFUSE)


	local richtext1 = uiSkill_StringToRichText(uiLanString("hint_practice"), uiLanString("font_title"), tonumber(uiLanString("font_s_17")), 4292927712)
	if richtext1 ~= nil then
		btNormal2:SetHintRichText(richtext1)
	end

	richtext1 = uiSkill_StringToRichText(uiLanString("MSG_ITEMFUSE"), uiLanString("font_title"), tonumber(uiLanString("font_s_17")), 4292927712)
	if richtext1 ~= nil then
		btBlend:SetHintRichText(richtext1)
	end
end

function layWorld_frmSkillEx_btnSkills_OnLClick()
	local frmSkillEx = uiGetglobal("layWorld.frmSkillEx")
	local frmTrumps = SAPI.GetChild(frmSkillEx, "frmTrumps")
	local frmOtherSkills = SAPI.GetChild(frmSkillEx, "frmOtherSkills")

	local btnSkills = SAPI.GetChild(frmSkillEx, "btnSkills")
	local btnOtherSkills = SAPI.GetChild(frmSkillEx, "btnOtherSkills")

	btnSkills:SetChecked(true)
	btnOtherSkills:SetChecked(false)

	frmTrumps:Show()
	frmOtherSkills:Hide()

	layWorld_frmSkillEx_Refresh()
end

function layWorld_frmSkillEx_btnOtherSkills_OnLClick()
	local frmSkillEx = uiGetglobal("layWorld.frmSkillEx")
	local frmTrumps = SAPI.GetChild(frmSkillEx, "frmTrumps")
	local frmOtherSkills = SAPI.GetChild(frmSkillEx, "frmOtherSkills")

	local btnSkills = SAPI.GetChild(frmSkillEx, "btnSkills")
	local btnOtherSkills = SAPI.GetChild(frmSkillEx, "btnOtherSkills")

	btnSkills:SetChecked(false)
	btnOtherSkills:SetChecked(true)

	frmTrumps:Hide()
	frmOtherSkills:Show()

	layWorld_frmSkillEx_Refresh()
end

function layWorld_frmSkillEx_OnUpdate(self)
	if not self:getVisible() then return end
	
	local frmTrumps = SAPI.GetChild(self, "frmTrumps")
	local labSkills = SAPI.GetChild(frmTrumps, "labSkills")
	for i=1,5,1 do
		local btnSkill = SAPI.GetChild(labSkills,"btnSkill"..i)
		local skillIndex = btnSkill:Get(EV_UI_SHORTCUT_CLASSID_KEY)
		if skillIndex == nil then
			btnSkill:SetMaskValue(0)
		else
			btnSkill:SetMaskValue(uiSkill_GetMyTrumpSkillMaskValue(skillIndex))
		end
	end

	local lbFinalSkill = SAPI.GetChild(frmTrumps, "lbFinalSkill")
	for i=1,5,1 do
		local btnSkillTill = SAPI.GetChild(lbFinalSkill,"btnSkillTill"..i)
		local skillIndex = btnSkillTill:Get(EV_UI_SHORTCUT_CLASSID_KEY)
		if skillIndex == nil then
			btnSkillTill:SetMaskValue(0)
		else
			btnSkillTill:SetMaskValue(uiSkill_GetMyTrumpSkillMaskValue(skillIndex))
		end
	end

	local lbItemTalent = SAPI.GetChild(frmTrumps,"lbItemTalent")
	for i=1,10,1 do
		local btnTalent = SAPI.GetChild(lbItemTalent,"btnTalent"..i)
		local skillIndex = btnTalent:Get(EV_UI_SHORTCUT_CLASSID_KEY)
		if skillIndex == nil then
			btnTalent:SetMaskValue(0)
		else
			local skillBaseInfo = uiSkill_GetSkillBaseInfoByIndex(skillIndex)
			if skillBaseInfo ~= nil then
				local itemUpdateLevel = btnTalent:Get("itemUpdateLevel")
				if itemUpdateLevel == nil then
					btnTalent:SetMaskValue(0)
				else
					if itemUpdateLevel >= skillBaseInfo.ActiveTrumpLevel then
						btnTalent:SetMaskValue(0)
					else
						btnTalent:SetMaskValue(1)
					end
				end
			else
				btnTalent:SetMaskValue(0)
			end
		end
	end
end

function layWorld_frmSkillEx_frmTrumps_labSkills_btnSkill_OnLClick(self)
	local skillIndex = self:Get(EV_UI_SHORTCUT_CLASSID_KEY)
	if skillIndex == nil then return end
	--uiSkill_UseTheSkillByIndex(skillIndex)
	Local_Skill_UseSkillDispatcher:Use(skillIndex);
end

function layWorld_frmSkillEx_frmTrumps_lbItemTalent_btnTalent_OnLClick(self)
	local skillIndex = self:Get(EV_UI_SHORTCUT_CLASSID_KEY)
	if skillIndex == nil then return end
	uiSkill_AddTalentLevelByIndex(skillIndex)
end

function layWorld_frmSkillEx_frmTrumps_lbFinalSkill_btnSkillTill_OnLClick(self)
	layWorld_frmSkillEx_frmTrumps_labSkills_btnSkill_OnLClick(self)
end

function layWorld_frmSkillEx_frmTrumps_btNormal2_OnClick(self)
	uiSkill_ShowPracticeUI()
end

function layWorld_frmSkillEx_frmTrumps_btBlend_OnClick(self)
	uiSkill_ShowItemFuseUI()
end

function layWorld_frmSkillEx_frmOtherSkills_Refresh()
	local self = uiGetglobal("layWorld.frmSkillEx.frmOtherSkills")

	for i=1,2,1 do
		local lbOtherSkillIcon = SAPI.GetChild(self, "lbOtherSkillIcon"..i)
		local lbOtherSkillName = SAPI.GetChild(self, "lbOtherSkillName"..i)
		local btLifeSkillForget = SAPI.GetChild(self, "btLifeSkillForget"..i)
		local prgOtherSkill = SAPI.GetChild(self, "prgOtherSkill"..i)

		lbOtherSkillIcon:Delete(EV_UI_SHORTCUT_CLASSID_KEY)
		lbOtherSkillIcon:Delete(EV_UI_SHORTCUT_TYPE_KEY)
		lbOtherSkillIcon:Delete(EV_UI_SHORTCUT_OWNER_KEY)
		btLifeSkillForget:Delete(EV_UI_SHORTCUT_CLASSID_KEY)

		lbOtherSkillIcon:SetNormalImage(0)
		lbOtherSkillName:SetText("")
		prgOtherSkill:SetText("")
		prgOtherSkill:SetValue(0)
		btLifeSkillForget:Disable()

		lbOtherSkillIcon:ModifyFlag("DragOut_RightButton", false)
		lbOtherSkillIcon:ModifyFlag("DragOut_MouseMove", false)
	end

	local ltLifeSkill = uiSkill_GetMyLifeSkillInfo()
	if ltLifeSkill == nil then return end

	for i, lifeSkill in ipairs(ltLifeSkill) do
		local lbOtherSkillIcon = SAPI.GetChild(self, "lbOtherSkillIcon"..i)
		local lbOtherSkillName = SAPI.GetChild(self, "lbOtherSkillName"..i)
		local btLifeSkillForget = SAPI.GetChild(self, "btLifeSkillForget"..i)
		local prgOtherSkill = SAPI.GetChild(self, "prgOtherSkill"..i)

		lbOtherSkillIcon:Set(EV_UI_SHORTCUT_CLASSID_KEY, lifeSkill.SkillIndex) 
		lbOtherSkillIcon:Set(EV_UI_SHORTCUT_TYPE_KEY, EV_SHORTCUT_OBJECT_SKILL)
		lbOtherSkillIcon:Set(EV_UI_SHORTCUT_OWNER_KEY, EV_UI_SHORTCUT_OWNER_SKILL)

		btLifeSkillForget:Set(EV_UI_SHORTCUT_CLASSID_KEY, lifeSkill.SkillIndex)

		local _sImage = SAPI.GetImage(lifeSkill.StrImage, 2, 2, -2, -2)
		if _sImage ~= nil then
			lbOtherSkillIcon:SetNormalImage(_sImage)
		end

		lbOtherSkillName:SetText(lifeSkill.Name)
		lbOtherSkillIcon:ModifyFlag("DragOut_RightButton", true)
		lbOtherSkillIcon:ModifyFlag("DragOut_MouseMove", true)
		btLifeSkillForget:Enable()

		local rate = lifeSkill.Exp / lifeSkill.MaxExp
		prgOtherSkill:SetText(string.format(uiLanString("MSG_LEVEL_SHOW"), lifeSkill.Lev, rate*100))
		prgOtherSkill:SetValue(rate)
	end


end

function layWorld_frmSkillEx_frmOtherSkills_btLifeSkillForget_OnLClick(self)
	local skillIndex = self:Get(EV_UI_SHORTCUT_CLASSID_KEY)
	if skillIndex == nil then return end

	local msgbox = uiMessageBox(uiLanString("MSG_LIFESKILL_DEL"), "", true, true, true);
	SAPI.AddDefaultMessageBoxCallBack(msgbox,ui_Skill_Delete_LifeSkill_Ok, nil, skillIndex)
end

function ui_Skill_Delete_LifeSkill_Ok(event, skillIndex)
	uiSkill_DeleteMyLifeSkillByIndex(skillIndex)
end

function layWorld_frmSkillEx_frmOtherSkills_lbOtherSkillIcon_OnLClick(self)
	local skillIndex = self:Get(EV_UI_SHORTCUT_CLASSID_KEY)
	if skillIndex == nil then return end
	--uiSkill_UseTheSkillByIndex(skillIndex)
	Local_Skill_UseSkillDispatcher:Use(skillIndex);
end
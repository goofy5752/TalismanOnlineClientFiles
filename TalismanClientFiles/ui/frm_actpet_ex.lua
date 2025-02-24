
function layWorld_frmAllPetEx_Show(self)
	layWorld_frmAllPetEx_Refresh()
	self:Show()
end

function layWorld_frmAllPetEx_Refresh()
	local self = uiGetglobal("layWorld.frmAllPetEx.frmXianqingPet")

	local labPetName = SAPI.GetChild(self, "labPetName")
	local pgbExpPet = SAPI.GetChild(self, "pgbExpPet")
	local pgbHpPet = SAPI.GetChild(self, "pgbHpPet")
	local pgbHapP = SAPI.GetChild(self, "pgbHapP")
	local pgbNickPoint = SAPI.GetChild(self, "pgbNickPoint")
	local labPhyDmgPet = SAPI.GetChild(self, "labPhyDmgPet")
	local labPhyArmorPet = SAPI.GetChild(self, "labPhyArmorPet")

	labPetName:SetText("")
	pgbExpPet:SetText("")
	pgbHpPet:SetText("")
	pgbHapP:SetText("")
	pgbNickPoint:SetText("")
	labPhyDmgPet:SetText("")
	labPhyArmorPet:SetText("")

	pgbExpPet:SetValue(0)
	pgbHpPet:SetValue(0)
	pgbHapP:SetValue(0)
	pgbNickPoint:SetValue(0)

	layWorld_frmSkillPetEx_Refresh()	
	
	local comPetInfo = uiPet_GetMyCurrentCombatPetPetDataInfo()
	if comPetInfo == nil then return end

	labPetName:SetText(comPetInfo.Name)

	labPhyArmorPet:SetText(""..comPetInfo.Armor)
	labPhyDmgPet:SetText(""..comPetInfo.MinDamage.."-"..comPetInfo.MaxDamage)

	local rate = comPetInfo.Exp/comPetInfo.MaxExp
	pgbExpPet:SetText(""..comPetInfo.Lev.."/"..string.format("%.1f%%",rate*100))
	pgbExpPet:SetValue(rate)

	pgbHpPet:SetText(""..comPetInfo.Hp.."/"..comPetInfo.MaxHp)
	pgbHpPet:SetValue(comPetInfo.Hp/comPetInfo.MaxHp)

	pgbHapP:SetText(""..comPetInfo.EnjoyRate.."/"..comPetInfo.MaxEnjoyRate)
	pgbHapP:SetValue(comPetInfo.EnjoyRate/comPetInfo.MaxEnjoyRate)

	pgbNickPoint:SetText(""..comPetInfo.CloseRate.."/"..comPetInfo.MaxCloseRate)
	pgbNickPoint:SetValue(comPetInfo.CloseRate/comPetInfo.MaxCloseRate)


end

function layWorld_frmSkillPetEx_Refresh()
	local self = uiGetglobal("layWorld.frmSkillPetEx.frmTrumps")
	local labSkills = SAPI.GetChild(self, "labSkills")

	for i=1,5,1 do
		local btnPet = SAPI.GetChild(self, "btnPet"..i)
		btnPet:Delete("skillIndex")
		btnPet:Hide()
	end

	for i=1,5,1 do
		local btnSkillPet = SAPI.GetChild(labSkills, "btnSkillPet"..i)
		btnSkillPet:Delete("skillIndex")
		btnSkillPet:Hide()
	end

	local skillInfo = uiPet_GetMyCurrentCombatPetSkillInfo()

	if skillInfo == nil then return end

	local pindex = 1
	local aindex = 1
	for i, skill in ipairs(skillInfo) do
		if skill.Passive then
			local btnPet = SAPI.GetChild(self, "btnPet"..pindex)
			btnPet:Show()
			btnPet:Set("skillIndex", skill.SkillIndex)
			local _image = SAPI.GetImage(skill.StrImage)
			if _image ~= nil then
				btnPet:SetBackgroundImage(_image)
			end
			pindex = pindex + 1
		else
			local btnSkillPet = SAPI.GetChild(labSkills, "btnSkillPet"..aindex)
			btnSkillPet:Show()
			btnSkillPet:Set("skillIndex", skill.SkillIndex)
			local _image = SAPI.GetImage(skill.StrImage)
			if _image ~= nil then
				btnSkillPet:SetBackgroundImage(_image)
			end
			aindex = aindex + 1
		end
	end
end

function layWorld_frmSkillPetEx_frmTrumps_btnPet(self)
	local skillIndex = self:Get("skillIndex")
	self:SetHintRichText(0)
	if skillIndex ~= nil then 
		local richText = uiPet_GetMyCurrentCombatPetSkillRichTextByIndex(skillIndex)
		if richText ~= nil then
			self:SetHintRichText(richText)
		end
	end
end

function layWorld_frmSkillPetEx_frmTrumps_labSkills_btnSkillPet(self)
	local skillIndex = self:Get("skillIndex")
	self:SetHintRichText(0)
	if skillIndex ~= nil then 
		local richText = uiPet_GetMyCurrentCombatPetSkillRichTextByIndex(skillIndex)
		if richText ~= nil then
			self:SetHintRichText(richText)
		end
	end
end

function layWorld_frmAllPetEx_OnHide()
	local frmSkillPetEx  = uiGetglobal("layWorld.frmSkillPetEx")
	frmSkillPetEx:Hide()
end

function layWorld_frmAllPetEx_frmXianqingPet_btnPetSkill_OnLClick()
	local frmSkillPetEx  = uiGetglobal("layWorld.frmSkillPetEx")
	if frmSkillPetEx:getVisible() then
		frmSkillPetEx:Hide()
	else
		frmSkillPetEx:Show()
	end
end
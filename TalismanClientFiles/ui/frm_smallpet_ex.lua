

function layWorld_frmSmallPetEx_Show(self)
	layWorld_frmSmallPetEx_Refresh()
	self:Show()
end

function layWorld_frmSmallPetEx_Refresh()
	local self = uiGetglobal("layWorld.frmSmallPetEx.frmTrumps")

	local lbSmallPetName = SAPI.GetChild(self, "lbSmallPetName")
	local lbSmallPetLev = SAPI.GetChild(self, "lbSmallPetLev")
	local prgSmallPetHappy = SAPI.GetChild(self, "prgSmallPetHappy")
	local prgSmallPetExp = SAPI.GetChild(self, "prgSmallPetExp")
	local lbRemainPoints = SAPI.GetChild(self, "lbRemainPoints")
	local lbRename = SAPI.GetChild(self, "lbRename")
	local lbStr = SAPI.GetChild(self, "lbStr")
	local lbDex = SAPI.GetChild(self, "lbDex")
	local lbWit = SAPI.GetChild(self, "lbWit")
	local lbCon = SAPI.GetChild(self, "lbCon")
	local btRename = SAPI.GetChild(self, "btRename");

	lbSmallPetName:SetText("")
	lbSmallPetLev:SetText("")
	prgSmallPetHappy:SetText("")
	prgSmallPetExp:SetText("")
	prgSmallPetHappy:SetValue(0)
	prgSmallPetExp:SetValue(0)
	lbRemainPoints:SetText("0")
	lbRename:SetText("0")
	lbStr:SetText("0")
	lbDex:SetText("0")
	lbWit:SetText("0")
	lbCon:SetText("0")

	local labSkills = SAPI.GetChild(self, "labSkills")
	
	for i=1,EV_PET_MAX_SMALL_PET_SKILL,1 do
		local btnSkillPet = SAPI.GetChild(labSkills ,"btnSkillPet"..i)
		btnSkillPet:Hide()
		btnSkillPet:Delete("skillIndex")
	end

	local Name, Lev, EnjoyRate, MaxEnjoyRate, Exp, MaxExp, RemainPoints, HaveRenameCnt, StrNum, DexNum, WitNum, ConNum = uiPet_GetMySmallPetData()
	if Name == nil then return end
	
	if HaveRenameCnt <= 0 then
		btRename:Disable();
	else
		btRename:Enable();
	end
	
	lbSmallPetName:SetText(Name)
	lbSmallPetLev:SetText(""..Lev)
	prgSmallPetHappy:SetText(""..EnjoyRate.."/"..MaxEnjoyRate)
	prgSmallPetHappy:SetValue(EnjoyRate/MaxEnjoyRate)
	prgSmallPetExp:SetText(""..Exp.."/"..MaxExp)
	prgSmallPetExp:SetValue(Exp/MaxExp)
	lbRemainPoints:SetText(""..RemainPoints)
	lbRename:SetText(""..HaveRenameCnt)
	lbStr:SetText(""..StrNum)
	lbDex:SetText(""..DexNum)
	lbWit:SetText(""..WitNum)
	lbCon:SetText(""..ConNum)

	local ltSkill = uiPet_GetMySmallPetSkillInfo()
	if ltSkill == nil then return end

	for i, skill in ipairs(ltSkill) do
		if skill.SkillIndex ~= nil then
			local btnSkillPet = SAPI.GetChild(labSkills ,"btnSkillPet"..i)
			btnSkillPet:Show()
			btnSkillPet:Set("skillIndex", skill.SkillIndex)
			local _image = SAPI.GetImage(skill.StrImage)
			if _image ~= nil then
				btnSkillPet:SetBackgroundImage(_image)
			end
		end
	end
end

function layWorld_frmSmallPetEx_frmTrumps_labSkills_btnSkillPet_OnHint(self)
	local skillIndex = self:Get("skillIndex")
	self:SetHintRichText(0)
	if skillIndex ~= nil then 
		local richText = uiPet_GetMySmallPetSkillRichTextByIndex(skillIndex)
		if richText ~= nil then
			self:SetHintRichText(richText)
		end
	end
end

function layWorld_frmSmallPetEx_frmTrumps_btaddpoint1_OnLClick()
	uiPet_SmallPetAddPoint("Str")
end

function layWorld_frmSmallPetEx_frmTrumps_btaddpoint2_OnLClick()
	uiPet_SmallPetAddPoint("Dex")
end

function layWorld_frmSmallPetEx_frmTrumps_btaddpoint3_OnLClick()
	uiPet_SmallPetAddPoint("Wit")
end

function layWorld_frmSmallPetEx_frmTrumps_btaddpoint4_OnLClick()
	uiPet_SmallPetAddPoint("Con")
end

function layWorld_frmSmallPetEx_frmTrumps_btRename_OnLClick()
	local inputBox, inputBox1 = uiInputBox(uiLanString("msg_pet_rename_cmd"), "", "", true, true, true)
	inputBox1:SetMaxChar(10)
	SAPI.AddDefaultInputBoxCallBack(inputBox, ui_Pet_RenameSmallPet_Ok)
end

function ui_Pet_RenameSmallPet_Ok(event, temp, name)
	uiPet_SmallPetRename(name)
end

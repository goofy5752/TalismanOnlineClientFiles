UI_Pet_NPC_Object_id = 0
UI_Pet_Current_Select = 0

function layWorld_frPetuiEx_Show(self, npcOid)
	UI_Pet_NPC_Object_id = npcOid
	layWorld_frPetuiEx_Refresh()
	self:ShowAndFocus()
end

function layWorld_frPetuiEx_Refresh()
	local self = uiGetglobal("layWorld.frPetuiEx")

	local btSavePet = SAPI.GetChild(self, "btSavePet")
	local btPetClose = SAPI.GetChild(self, "btPetClose")
	local btPetFree = SAPI.GetChild(self, "btPetFree")
	local lbPlayName = SAPI.GetChild(self, "lbPlayName")

	btSavePet:SetText(uiLanString("msg_pet_view_s_and_c"))
	btSavePet:Disable()
	btPetFree:Disable()

	local userName = uiGetMyInfo("Role")
	lbPlayName:SetText(userName)

	local frmPetList = SAPI.GetChild(self, "frmPetList")
	
	local labCarrayPet = SAPI.GetChild(frmPetList, "labCarrayPet")
	local lbPetName = SAPI.GetChild(frmPetList, "lbPetName")
	local lbPetLev = SAPI.GetChild(frmPetList, "lbPetLev")
	local prgHpPet = SAPI.GetChild(frmPetList, "prgHpPet")
	local prgMpPet = SAPI.GetChild(frmPetList, "prgMpPet")

	labCarrayPet:SetBackgroundImage(0)
	lbPetName:Hide()
	lbPetLev:Hide()
	prgHpPet:Hide()
	prgMpPet:Hide()

	for i=1, EV_PET_MAX_PET_COUNT, 1 do
		local labStoragePet = SAPI.GetChild(frmPetList, "labStoragePet"..i)
		local lbSavePetName = SAPI.GetChild(frmPetList, "lbSavePetName"..i)
		local lbSavePetLev = SAPI.GetChild(frmPetList, "lbPetLev"..i)
		local pgbSavePetHp = SAPI.GetChild(frmPetList, "pgbHpPet"..i)
		local pgbSavePetMp = SAPI.GetChild(frmPetList, "pgbMpPet"..i)

		labStoragePet:SetBackgroundImage(0)
		lbSavePetName:Hide()
		lbSavePetLev:Hide()
		pgbSavePetHp:Hide()
		pgbSavePetMp:Hide()
	end

	local ltPetData = uiPet_GetMyPetDataInfo()
	if ltPetData == nil then return end

	local idx = 1
	for i, petData in ipairs(ltPetData) do
		if petData.Name ~= nil then
			if petData.State == EV_PET_STATE_CARRYING then
				lbPetName:SetText(petData.Name)
				lbPetName:Show()
				lbPetLev:SetText(""..petData.Lev)
				lbPetLev:Show()
				prgHpPet:SetText(""..petData.Hp.."/"..petData.MaxHp)
				prgHpPet:SetValue(petData.Hp/petData.MaxHp)
				prgHpPet:Show()
				prgMpPet:SetText(""..petData.Mp.."/"..petData.MaxMp)
				prgMpPet:SetValue(petData.Mp/petData.MaxMp)
				prgMpPet:Show()
				if UI_Pet_Current_Select == 1 then
					local _image = SAPI.GetImage("tz_012")
					if _image ~= nil then
						uiSetImageSourceRect(_image, 276,10,59,21)
						labCarrayPet:SetBackgroundImage(_image)
					end
					btSavePet:Enable()
					btPetFree:Enable()
					btSavePet:SetText(uiLanString("msg_pet_view_storage"))
				end
			else
				if idx <= EV_PET_MAX_PET_COUNT then
					local labStoragePet = SAPI.GetChild(frmPetList, "labStoragePet"..idx)
					local lbSavePetName = SAPI.GetChild(frmPetList, "lbSavePetName"..idx)
					local lbSavePetLev = SAPI.GetChild(frmPetList, "lbPetLev"..idx)
					local pgbSavePetHp = SAPI.GetChild(frmPetList, "pgbHpPet"..idx)
					local pgbSavePetMp = SAPI.GetChild(frmPetList, "pgbMpPet"..idx)
					lbSavePetName:SetText(petData.Name)
					lbSavePetName:Show()
					lbSavePetLev:SetText(""..petData.Lev)
					lbSavePetLev:Show()
					pgbSavePetHp:SetText(""..petData.Hp.."/"..petData.MaxHp)
					pgbSavePetHp:SetValue(petData.Hp/petData.MaxHp)
					pgbSavePetHp:Show()
					pgbSavePetMp:SetText(""..petData.Mp.."/"..petData.MaxMp)
					pgbSavePetMp:SetValue(petData.Mp/petData.MaxMp)
					pgbSavePetMp:Show()
					
					if UI_Pet_Current_Select == idx + 1 then
						local _image = SAPI.GetImage("tz_012")
						if _image ~= nil then
							uiSetImageSourceRect(_image, 276,10,59,21)
							labStoragePet:SetBackgroundImage(_image)
						end
						btSavePet:Enable()
						btPetFree:Enable()
						btSavePet:SetText(uiLanString("msg_pet_view_carry"))
					end

					idx = idx + 1	
				end
			end
		end
	end
end	

function layWorld_frPetuiEx_frmPetList_labCarrayPet_OnLClick()
	local ltPetData = uiPet_GetMyPetDataInfo()
	if ltPetData == nil then return end

	for i, petData in ipairs(ltPetData) do
		if petData.Name ~= nil then
			if petData.State == EV_PET_STATE_CARRYING then
				UI_Pet_Current_Select = 1
				layWorld_frPetuiEx_Refresh()
				break
			end
		end
	end
end

function layWorld_frPetuiEx_frmPetList_labStoragePet_OnLClick(self)
	local frmPetList = uiGetglobal("layWorld.frPetuiEx.frmPetList")

	for i=1, EV_PET_MAX_PET_COUNT, 1 do
		local labStoragePet = SAPI.GetChild(frmPetList, "labStoragePet"..i)
		if SAPI.Equal(self, labStoragePet) then
			local ltPetData = uiPet_GetMyPetDataInfo()
			if ltPetData == nil then return end

			local petStorageCount = 0 
			for j, petData in ipairs(ltPetData) do
				if petData.Name ~= nil then
					if petData.State ~= EV_PET_STATE_CARRYING then
						petStorageCount = petStorageCount + 1
					end
				end
			end

			if i > petStorageCount then
				return
			end
			UI_Pet_Current_Select = i + 1
			layWorld_frPetuiEx_Refresh()
			break
		end
	end
end

function layWorld_frPetuiEx_btSavePet_OnLClick()
	if UI_Pet_Current_Select == 1 then
		uiPet_SavePet()
	elseif UI_Pet_Current_Select > 1 and UI_Pet_Current_Select <= EV_PET_MAX_PET_COUNT + 1 then
		local petDataId = uiGetPetDataIdByCurrentSelect()
		if petDataId ~= nil then
			uiPet_CarryPet(petDataId)
		end
	end
	UI_Pet_Current_Select = 0
end

function uiGetPetDataIdByCurrentSelect()
	local ltPetData = uiPet_GetMyPetDataInfo()
	if ltPetData == nil then return end

	local idx = 1
	for i, petData in ipairs(ltPetData) do
		if petData.Id ~= nil then
			if petData.State ~= EV_PET_STATE_CARRYING then
				if UI_Pet_Current_Select == idx + 1 then
					return petData.Id 
				end
				idx = idx + 1
			else
				if UI_Pet_Current_Select == 1 then
					return petData.Id 
				end
			end
		end
	end
end

function layWorld_frPetuiEx_btPetClose_OnLClick()
	local frPetuiEx = uiGetglobal("layWorld.frPetuiEx")
	frPetuiEx:Hide()
end

function layWorld_frPetuiEx_OnHide(self)
	UI_Pet_Current_Select = 0
end

function layWorld_frPetuiEx_btPetFree_OnLClick()
	if UI_Pet_Current_Select == 0 then return end

	local ltPetData = uiPet_GetMyPetDataInfo()
	if ltPetData == nil then return end

	local idx = 1
	for i, petData in ipairs(ltPetData) do
		if petData.Id ~= nil then
			if petData.State ~= EV_PET_STATE_CARRYING then
				if UI_Pet_Current_Select == idx + 1 then
					local msgbox = uiMessageBox(string.format(uiLanString("msg_pet_free_ask_p"), petData.Name), "", true, true, true)
					SAPI.AddDefaultMessageBoxCallBack(msgbox,ui_PetFree_OnMsgBoxOk, nil, petData.Id)
					return
				end
				idx = idx + 1
			else
				if UI_Pet_Current_Select == 1 then
					local msgbox = uiMessageBox(string.format(uiLanString("msg_pet_free_ask_p"), petData.Name), "", true, true, true)
					SAPI.AddDefaultMessageBoxCallBack(msgbox,ui_PetFree_OnMsgBoxOk, nil, petData.Id)
					return
				end
			end
		end
	end
end

function ui_PetFree_OnMsgBoxOk(event, myarg)
	uiPet_FreePet(myarg)
	UI_Pet_Current_Select = 0
end

function layWorld_frPetuiEx_OnUpdate(self)
	if not uiPet_CheckNpcShowUiDistance(UI_Pet_NPC_Object_id) then
		self:Hide()
	end
end
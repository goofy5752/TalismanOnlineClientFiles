local UI_Bank_AddBag_Item_Object_id = 0

function layWorld_frmAddbagEx_Refresh()
	local self = uiGetglobal("layWorld.frmAddbagEx")
	local bagCount = uiBank_GetUltraBagCount()
	local bagMaxCount = uiBank_GetUltraBagMaxCountLineCol()
	for i=1 , bagMaxCount, 1 do
		local bag = SAPI.GetChild(self, "bag"..i)
		local bagname = SAPI.GetChild(self, "bagname"..i)
		bag:Disable()
		bagname:SetText("")
	end

	for i=1 , bagCount, 1 do
		local bag = SAPI.GetChild(self, "bag"..i)
		local bagname = SAPI.GetChild(self, "bagname"..i)
		local bagEndTime = uiBank_GetUltraBagEndTime(i)
		if bagEndTime == 0 or bagEndTime > uiGetServerTime() then
			bag:Disable()
			bagname:SetTextColorEx(224,224,224,255)
			bagname:SetText(uiLanString("msg_ultrabank_limit_1"))
		else
			bag:Enable()
			bagname:SetTextColorEx(17,17,224,255)
			bagname:SetText(uiLanString("msg_ultrabank_limit_2"))
		end
	end

	if bagCount < bagMaxCount then
		local bag = SAPI.GetChild(self, "bag"..(bagCount+1))
		local bagname = SAPI.GetChild(self, "bagname"..(bagCount+1))
		bag:Enable()
		bagname:SetTextColorEx(224,224,224,255)
		bagname:SetText(uiLanString("msg_ultrabank_new"))
	end
end

function layWorld_frmAddbagEx_bag_OnLClick(self)
	local frmAddbagEx = uiGetglobal("layWorld.frmAddbagEx")
	local bagMaxCount = uiBank_GetUltraBagMaxCountLineCol()
	for i=1 , bagMaxCount, 1 do
		local bag = SAPI.GetChild(frmAddbagEx, "bag"..i)
		if SAPI.Equal(self, bag) then
			uiBank_UltraSelect(UI_Bank_AddBag_Item_Object_id, i)
			break
		end
	end
	frmAddbagEx:Hide()
end

function layWorld_frmAddbagEx_Show(self, arg)
	UI_Bank_AddBag_Item_Object_id = arg[1]
	self:ShowAndFocus()
	layWorld_frmAddbagEx_Refresh()
end
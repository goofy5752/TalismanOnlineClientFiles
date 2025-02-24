function layWorld_frmWareHousePassEx_OnHide(self)
	local edtWareHousePass = SAPI.GetChild(self, "edtWareHousePass")
	edtWareHousePass:SetText("")
	local btOK = SAPI.GetChild(self, "btOK")
	btOK:Enable()

end

function layWorld_frmWareHousePassEx_btOK()
	local self = uiGetglobal("layWorld.frmWareHousePassEx")
	local edtWareHousePass = SAPI.GetChild(self, "edtWareHousePass")
	local strPass = edtWareHousePass:getText()

	if strPass == "" then
		return
	end

	if not uiBank_ValidBankPass(strPass) then
		return
	end

	edtWareHousePass:SetText("")
	local btOK = SAPI.GetChild(self, "btOK")
	btOK:Disable()
	self:Hide()
end

function layWorld_frmWareHousePassSetEx_OnHide(self)
	local edtWareHouseoldPass = SAPI.GetChild(self, "edtWareHouseoldPass")
	local edtwarehouseNewPass = SAPI.GetChild(self, "edtwarehouseNewPass")
	local edtwarehousePass2 = SAPI.GetChild(self, "edtwarehousePass2")
	edtWareHouseoldPass:SetText("")
	edtwarehouseNewPass:SetText("")
	edtwarehousePass2:SetText("")
	local btOK = SAPI.GetChild(self, "btOK")
	btOK:Enable()
end

function layWorld_frmWareHousePassSetEx_btRelplay_OnLClick()
	local self = uiGetglobal("layWorld.frmWareHousePassSetEx")
	local edtWareHouseoldPass = SAPI.GetChild(self, "edtWareHouseoldPass")
	local edtwarehouseNewPass = SAPI.GetChild(self, "edtwarehouseNewPass")
	local edtwarehousePass2 = SAPI.GetChild(self, "edtwarehousePass2")
	edtWareHouseoldPass:SetText("")
	edtwarehouseNewPass:SetText("")
	edtwarehousePass2:SetText("")
end

function layWorld_frmWareHousePassSetEx_btOK_OnLClick()
	local self = uiGetglobal("layWorld.frmWareHousePassSetEx")
	local edtWareHouseoldPass = SAPI.GetChild(self, "edtWareHouseoldPass")
	local edtwarehouseNewPass = SAPI.GetChild(self, "edtwarehouseNewPass")
	local edtwarehousePass2 = SAPI.GetChild(self, "edtwarehousePass2")
	local oldPass = edtWareHouseoldPass:getText()
	local newPass1 = edtwarehouseNewPass:getText()
	local newPass2 = edtwarehousePass2:getText()

	if not uiBank_SetBankPass(oldPass, newPass1, newPass2) then
		return
	end
	edtWareHouseoldPass:SetText("")
	edtwarehouseNewPass:SetText("")
	edtwarehousePass2:SetText("")
	local btOK = SAPI.GetChild(self, "btOK")
	btOK:Disable()
end
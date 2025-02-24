function layWorld_frmBankSetmoneyEx_OnHide(self)
	local EdbGold = SAPI.GetChild(self, "EdbGold")
	local EdbAG = SAPI.GetChild(self, "EdbAG")
	local EdbCu = SAPI.GetChild(self, "EdbCu")

	EdbGold:SetText("")
	EdbAG:SetText("")
	EdbCu:SetText("")
end

function layWorld_frmBankSetmoneyEx_btSetOk_OnLClick()
	local frmBankSetmoneyEx = uiGetglobal("layWorld.frmBankSetmoneyEx")
	local EdbGold = SAPI.GetChild(frmBankSetmoneyEx, "EdbGold")
	local EdbAG = SAPI.GetChild(frmBankSetmoneyEx, "EdbAG")
	local EdbCu = SAPI.GetChild(frmBankSetmoneyEx, "EdbCu")

	local gold = tonumber(EdbGold:getText())
	local ag = tonumber(EdbAG:getText())
	local cu = tonumber(EdbCu:getText())

	if gold == nil then
		gold = 0
	end

	if ag == nil then
		ag = 0
	end

	if cu == nil then
		cu = 0
	end

	local money = gold*10000 + ag*100 + cu

	uiBank_ChangeBankMoney(money,frmBankSetmoneyEx:Get("save"))
	frmBankSetmoneyEx:Hide()
end

function layWorld_frmBankSetmoneyEx_btSetCancel_OnLClick()
	local frmBankSetmoneyEx = uiGetglobal("layWorld.frmBankSetmoneyEx")
	frmBankSetmoneyEx:Hide()
end
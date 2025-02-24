UI_Murder_MurderItem_ObjectId = 0

function layWorld_frmKillerTipEx_Use_MurderItem(self,itemOid, itemtype)
	if itemtype ~= EV_ITEM_TYPE_MURDER then return end

	UI_Murder_MurderItem_ObjectId = itemOid;
	self:ShowAndFocus();
end

function layWorld_frmKillerTipEx_InitAll(self)
	local cbGamemoney = SAPI.GetChild(self, "cbGamemoney")
	cbGamemoney:SetChecked(true)
end

function layWorld_frmKillerTipEx_btnBlackList_OnLClick()
	uiConnectionShowUiByConnection(EV_CONNECTION_ENEMY);
end

function layWorld_frmKillerTipEx_cbAcceptKill_OnLClick()
	local self = uiGetglobal("layWorld.frmKillerTipEx")

	local ebGameMoneyGold = SAPI.GetChild(self, "ebGameMoneyGold")
	local ebGameMoneyAg = SAPI.GetChild(self, "ebGameMoneyAg")
	local ebGameMoneyGoldCu = SAPI.GetChild(self, "ebGameMoneyGoldCu")

	local g = ebGameMoneyGold:getText()
	local a = ebGameMoneyAg:getText()
	local c = ebGameMoneyGoldCu:getText()

	local cbGamemoney = SAPI.GetChild(self, "cbGamemoney")
	if not cbGamemoney:getChecked() then return end

	local money = 0
	if g ~= "" then
		money = money + tonumber(g) * 10000
	end

	if a ~= "" then
		money = money + tonumber(a) * 100
	end

	if c ~= "" then
		money = money + tonumber(c)
	end

	if money == 0 then
		uiClientMsg(uiLanString("msg_murder_condition9"), false)
		return
	end

	local edbKillerName = SAPI.GetChild(self, "edbKillerName")

	local userName = edbKillerName:getText()

	if userName == "" then
		uiClientMsg(uiLanString("msg_murder_condition10"), true)
		return
	end

	local cbAddname = SAPI.GetChild(self, "cbAddname")

	if uiMurder_MurderUserByName(userName, money, cbAddname:getChecked(), UI_Murder_MurderItem_ObjectId) then
		self:Hide()
	end
end

function layWorld_frmKillerTipEx_btCancleKill_OnLClick()
	local self = uiGetglobal("layWorld.frmKillerTipEx")
	self:Hide()
end

function layWorld_frmKillerTipEx_cbGamemoney_OnLClick(self)
	self:SetChecked(true)
end

function layWorld_frmKillerTipEx_OnShow(self)
	uiRegisterEscWidget(self);
	local Authority = uiGetMyInfo("Authority");
	local CanModifyMoney = false;
	if uiGetConfigureEntry("killer_tip", "DefaultPrice") == "true" then
		CanModifyMoney = (Authority > 0) or false;
	else
		CanModifyMoney = true;
	end
	local PriceUnit =
	{
		"lbPriceBackground",
		"ebGameMoneyGold",
		"ebGameMoneyAg",
		"ebGameMoneyGoldCu",
	};
	if CanModifyMoney then
		for i, v in ipairs(PriceUnit) do
			local unit = SAPI.GetChild(self, v);
			if unit then
				unit:Show();
			end
		end
	else
		for i, v in ipairs(PriceUnit) do
			local unit = SAPI.GetChild(self, v);
			if unit then
				unit:Hide();
			end
		end
	end
end






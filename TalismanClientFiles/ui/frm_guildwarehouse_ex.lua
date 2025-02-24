UI_Guild_Bank_Npc_Object_Id = 0
UI_Guild_Bank_Current_Page = 1

function layWorld_frmGuildWarehouseEx_Refresh()
	local self = uiGetglobal("layWorld.frmGuildWarehouseEx")
	
	local lbItems = SAPI.GetChild(self, "lbItems")

	local lbGuildHouse2 = SAPI.GetChild(self, "lbGuildHouse2")
	local lbGuildWarehouse = SAPI.GetChild(self, "lbGuildWarehouse")
	lbGuildHouse2:SetText("")
	lbGuildWarehouse:SetText("")

	local maxPage, line, col = uiGuild_GetGuildBankMaxPageLineCol()


	if maxPage == nil or line ==nil or col == nil then return end

	local pageCount = uiGuild_GetGuildBankInfo()
	if pageCount == nil then
		return
	end
	
	if pageCount > maxPage then return end
	
	if UI_Guild_Bank_Current_Page < 1 or UI_Guild_Bank_Current_Page > pageCount then return end

	
	lbGuildHouse2:SetText(""..UI_Guild_Bank_Current_Page.."/"..pageCount)
	local guildName = uiGuild_GetGuildData()
	lbGuildWarehouse:SetText(guildName)

	for i=1, line, 1 do
		for j=1, col, 1 do
			local btItem = SAPI.GetChild(lbItems, "btItem"..((i - 1)*col + j))
			btItem:Delete(EV_UI_SHORTCUT_TYPE_KEY)
			btItem:Delete(EV_UI_SHORTCUT_OWNER_KEY)
			btItem:Delete(EV_UI_SHORTCUT_OBJECTID_KEY)
			local imgstr, itemCount, itemOid = uiGuild_GetGuildBankItemByLineCol(UI_Guild_Bank_Current_Page, i, j)
			if imgstr ~= nil then
				local image_item = SAPI.GetImage(imgstr)
				if image_item ~= nil then
					btItem:SetBackgroundImage(image_item)
					btItem:ModifyFlag("DragOut", true)
					btItem:Set(EV_UI_SHORTCUT_TYPE_KEY, EV_SHORTCUT_OBJECT_ITEM)
					btItem:Set(EV_UI_SHORTCUT_OWNER_KEY, EV_UI_SHORTCUT_OWNER_GUILD_BANK)
					btItem:Set(EV_UI_SHORTCUT_OBJECTID_KEY, itemOid)
					if itemCount == -1 or itemCount == nil then
						btItem:SetUltraTextNormal("")
					else
						btItem:SetUltraTextNormal(""..itemCount)
					end
				else
					btItem:SetBackgroundImage(0)
					btItem:ModifyFlag("DragOut", false)
					btItem:SetUltraTextNormal("")
				end
			else
				btItem:SetBackgroundImage(0)
				btItem:ModifyFlag("DragOut", false)
				btItem:SetUltraTextNormal("")
			end

			if btItem:IsHovered() then
				layWorld_frmGuildWarehouseEx_btItem_OnHint(btItem)
			end
		end
	end

	layWorld_frmGuildWarehouseEx_RefreshGuildBankMoney()

end

function layWorld_frmGuildWarehouseEx_RefreshGuildBankMoney()
	local self = uiGetglobal("layWorld.frmGuildWarehouseEx")

	local goldnum = SAPI.GetChild(self, "goldnum")
	local silvernum = SAPI.GetChild(self, "silvernum")
	local coppernum = SAPI.GetChild(self, "coppernum")

	local __gold,__silver,__copper = uiGuild_GetGuildBankMoney()
	goldnum:SetText(""..__gold)
	silvernum:SetText(""..__silver)
	coppernum:SetText(""..__copper)
end

function layWorld_frmGuildWarehouseEx_Guild_Recv_BankDate(self, arg)
	layWorld_frmGuildWarehouseEx_Refresh()
	UI_Guild_Bank_Npc_Object_Id = arg[1]
	if UI_Guild_Bank_Npc_Object_Id == 0 or UI_Guild_Bank_Npc_Object_Id == nil then
		return
	end
	self:MoveTo(80, 180)
	self:ShowAndFocus()
	UI_Guild_Bank_Current_Page = 1
	layWorld_frmGuildWarehouseEx_Refresh()
end

function layWorld_frmGuildWarehouseEx_btItem_OnHint(self)
	local lbItems = uiGetglobal("layWorld.frmGuildWarehouseEx.lbItems")

	local _, line, col = uiGuild_GetGuildBankMaxPageLineCol()

	if line == nil or col == nil then return end
	for i=1, line, 1 do
		for j=1, col, 1 do
			local btItem = SAPI.GetChild(lbItems, "btItem"..((i - 1)*col + j))
			if SAPI.Equal(self, btItem) then
				local _, _, _,richText = uiGuild_GetGuildBankItemByLineCol(UI_Guild_Bank_Current_Page, i, j)
				if richText ~= nil then
					self:SetHintRichText(richText)
				else
					self:SetHintRichText(0)
				end
				return
			end
			
		end
	end
end

function layWorld_frmGuildWarehouseEx_btItem_OnRClick(self)
	if self:Get(EV_UI_SHORTCUT_TYPE_KEY) ~= EV_SHORTCUT_OBJECT_ITEM then
		return
	end

	if self:Get(EV_UI_SHORTCUT_OWNER_KEY) ~= EV_UI_SHORTCUT_OWNER_GUILD_BANK then
		return
	end

	local itemOid = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	if itemOid == nil then
		return
	end

	if UI_Guild_Bank_Npc_Object_Id == 0 or UI_Guild_Bank_Npc_Object_Id == nil then
		return
	end

	uiGuild_TakeOutGuildBankItem(itemOid, UI_Guild_Bank_Npc_Object_Id)
end

function layWorld_frmGuildWarehouseEx_btItem_OnDragIn(self, drag)
	if UI_Guild_Bank_Npc_Object_Id == 0 or UI_Guild_Bank_Npc_Object_Id == nil then
		return
	end

	local lbItems = uiGetglobal("layWorld.frmGuildWarehouseEx.lbItems")
	local wDrag = uiGetglobal(drag)

	if wDrag:Get(EV_UI_SHORTCUT_TYPE_KEY) ~= EV_SHORTCUT_OBJECT_ITEM then
		return
	end

	local itemOid = wDrag:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	if itemOid == nil then
		return
	end

	local _, line, col = uiGuild_GetGuildBankMaxPageLineCol()
	for i=1, line, 1 do
		for j=1, col, 1 do
			local btItem = SAPI.GetChild(lbItems, "btItem"..((i - 1)*col + j))
			if SAPI.Equal(self, btItem) then
				if wDrag:Get(EV_UI_SHORTCUT_OWNER_KEY) == EV_UI_SHORTCUT_OWNER_ITEM then
					if uiGuild_CheckUserItemIsValued(itemOid) then
						local timeLimit = uiGuild_GetValuedItemTradeTimeLimit()
						if not uiGuild_CheckItemTimeLimit(itemOid) then 
							uiClientMsg(string.format(uiLanString("msg_item2"),math.floor(timeLimit/60),math.floor(timeLimit/60)), true)
							return
						end
						local msgbox = uiMessageBox(string.format(uiLanString("msg_item1"), math.floor(timeLimit/60)), "", true, true, true);
						local myarg = {}
						myarg[1] = itemOid
						myarg[2] = i
						myarg[3] = j
						SAPI.AddDefaultMessageBoxCallBack(msgbox,ui_Guild_ValuedItemTrade_Ok, nil, myarg)
						return
					end
				end
				uiGuild_ItemPutInGuildBank(itemOid, UI_Guild_Bank_Current_Page, i, j, UI_Guild_Bank_Npc_Object_Id)
				return
			end
		end

	end
end

function ui_Guild_ValuedItemTrade_Ok(event, myarg)
	uiGuild_ItemPutInGuildBank(myarg[1], UI_Guild_Bank_Current_Page, myarg[2], myarg[3], UI_Guild_Bank_Npc_Object_Id)
end

function layWorld_frmGuildWarehouseEx_btGuildLeft_OnLClick()
	UI_Guild_Bank_Current_Page = UI_Guild_Bank_Current_Page - 1
	if UI_Guild_Bank_Current_Page < 1 then
		UI_Guild_Bank_Current_Page = 1
	end
	layWorld_frmGuildWarehouseEx_Refresh()
end

function layWorld_frmGuildWarehouseEx_btGuildRight_OnLClick()
	UI_Guild_Bank_Current_Page = UI_Guild_Bank_Current_Page+1
	local pageCount = uiGuild_GetGuildBankInfo()
	if pageCount == nil then return end
	if UI_Guild_Bank_Current_Page > pageCount then
		UI_Guild_Bank_Current_Page = pageCount
	end
	layWorld_frmGuildWarehouseEx_Refresh()
end

function layWorld_frmGuildWarehouseEx_btnSaveMoney_OnLClick()
	if not uiGuild_CheckCanTransferItem(true) then
		return
	end

	local frmGuildBankMoneyEx = uiGetglobal("layWorld.frmGuildBankMoneyEx")
	frmGuildBankMoneyEx:Set("save", true)
	frmGuildBankMoneyEx:ShowAndFocus()
end

function layWorld_frmGuildWarehouseEx_btnLoadMoney_OnLClick()
	local frmGuildBankMoneyEx = uiGetglobal("layWorld.frmGuildBankMoneyEx")
	frmGuildBankMoneyEx:Set("save", false)
	frmGuildBankMoneyEx:ShowAndFocus()
end

function layWorld_frmGuildBankMoneyEx_OnHide(self)
	local EdbGold = SAPI.GetChild(self, "EdbGold")
	local EdbAG = SAPI.GetChild(self, "EdbAG")
	local EdbCu = SAPI.GetChild(self, "EdbCu")

	EdbGold:SetText("")
	EdbAG:SetText("")
	EdbCu:SetText("")
end

function layWorld_frmGuildBankMoneyEx_btSetOk_OnLClick()
	local frmGuildBankMoneyEx = uiGetglobal("layWorld.frmGuildBankMoneyEx")
	local EdbGold = SAPI.GetChild(frmGuildBankMoneyEx, "EdbGold")
	local EdbAG = SAPI.GetChild(frmGuildBankMoneyEx, "EdbAG")
	local EdbCu = SAPI.GetChild(frmGuildBankMoneyEx, "EdbCu")

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

	uiGuild_ChangGuildBankMoney(money,frmGuildBankMoneyEx:Get("save"))
	frmGuildBankMoneyEx:Hide()
end

function layWorld_frmGuildBankMoneyEx_btSetCancel_OnLClick()
	local frmGuildBankMoneyEx = uiGetglobal("layWorld.frmGuildBankMoneyEx")
	frmGuildBankMoneyEx:Hide()
end

function layWorld_frmGuildWarehouseEx_btGuildWareHouseHistory_OnLClick()
	local frmHistoryGuildEx = uiGetglobal("layWorld.frmHistoryGuildEx")
	if frmHistoryGuildEx:getVisible() then
		frmHistoryGuildEx:Hide()
	else
		local ckItemPage = SAPI.GetChild(frmHistoryGuildEx, "ckItemPage")
		local bItem = ckItemPage:getChecked()
		local iStart = 0
		local iEnd = 0
		if bItem == true then
			iStart = (UI_Guild_Bank_ItemHistory_Current_Page - 1) * UI_GUILDBANK_HISTORY_SHOW_COUNT;
            iEnd = UI_Guild_Bank_ItemHistory_Current_Page * UI_GUILDBANK_HISTORY_SHOW_COUNT;
		elseif bitem == false then
			iStart = (UI_Guild_Bank_MoneyHistory_Current_Page - 1) * UI_GUILDBANK_HISTORY_SHOW_COUNT;
            iEnd = UI_Guild_Bank_MoneyHistory_Current_Page * UI_GUILDBANK_HISTORY_SHOW_COUNT;
		end
		uiGuild_QueryGuildBankHistory(bItem, iStart, iEnd)
		frmHistoryGuildEx:ShowAndFocus()
	end
end

----------------------------------------------
----------------------------------------------
UI_Guild_Bank_ItemHistory_Current_Page = 1
UI_Guild_Bank_MoneyHistory_Current_Page = 1
UI_GUILDBANK_HISTORY_SHOW_COUNT = 24
UI_GUILDBANK_HISTORY_MAX_PAGE = 20


function layWorld_frmHistoryGuildEx_lstGuildHistory_OnLoad(self)
	self:InsertColumn("", 100, 256*256*256*256 - 1, -1, 0, 0)
	self:InsertColumn("", 120, 256*256*256*256 - 1, -1, 0, 0)
	self:InsertColumn("", 80, 256*256*256*256 - 1, -1, 0, 0)
	self:InsertColumn("", 140, 256*256*256*256 - 1, -1, 0, 0)
	self:getHeaderButton(0):SetTextColorEx(32,224,224,255)
	self:getHeaderButton(1):SetTextColorEx(32,224,224,255)
	self:getHeaderButton(2):SetTextColorEx(32,224,224,255)
	self:getHeaderButton(3):SetTextColorEx(32,224,224,255)
end

function layWorld_frmHistoryGuildEx_lstGuildHistoryItem_Refresh(self, iBegin)
	local frmHistoryGuildEx = uiGetglobal("layWorld.frmHistoryGuildEx") 

	if not frmHistoryGuildEx:getVisible() then	
		return
	end

	local ckItemPage = SAPI.GetChild(frmHistoryGuildEx, "ckItemPage")
	if ckItemPage:getChecked() == false then return end

	self:getHeaderButton(0):SetText(uiLanString("GUILD_BANK_COL_TIME"))
	self:getHeaderButton(1):SetText(uiLanString("GUILD_BANK_COL_USERNAME"))
	self:getHeaderButton(2):SetText(uiLanString("GUILD_BANK_COL_OP"))
	self:getHeaderButton(3):SetText(uiLanString("GUILD_BANK_COL_ITEM"))
	self:RemoveAllLines()

	UI_Guild_Bank_ItemHistory_Current_Page = math.floor(iBegin/UI_GUILDBANK_HISTORY_SHOW_COUNT) + 1
	local lbPage = SAPI.GetChild(frmHistoryGuildEx,"lbPage")
	lbPage:SetText(""..UI_Guild_Bank_ItemHistory_Current_Page)

	local gdata = uiGuild_GetGuildHistoryData()
	if gdata == nil then return end

	local icolor = 4292927712

	local counter = 0

	for i, _data in ipairs(gdata) do
		
		local _, iMonth, iDay, iHour, iMin = uiBank_TimeGetDate(_data.Time)
		local strTime = string.format(uiLanString("GUILD_BANK_HIS_TIME"), iMonth, iDay, iHour, iMin )

		local strOperate = ""
		if _data.Operate == 0 then
			strOperate = uiLanString("GUILD_BANK_SAVE")
		elseif _data.Operate == 1 then
			strOperate = uiLanString("GUILD_BANK_WITHDRAW")
		end

		local strItem = ""

		local itemInfo = uiItemGetItemClassInfoByTableIndex(_data.ItemIndex)
		
		if itemInfo ~= nil then

			if _data.ItemCount >0 then
				strItem = "(".._data.ItemCount..")"
			end

			strItem = strItem..itemInfo.Name

			self:InsertLine(-1,-1,-1)
			self:SetLineItem(counter, 0, strTime, icolor)
			self:SetLineItem(counter, 1, _data.UserName, icolor)
			self:SetLineItem(counter, 2, strOperate, icolor)
			self:SetLineItem(counter, 3, strItem, _data.ItemColor)

			counter = counter + 1
		end
		
	end

	
end

function layWorld_frmHistoryGuildEx_lstGuildHistoryMoney_Refresh(self, iBegin)
	local frmHistoryGuildEx = uiGetglobal("layWorld.frmHistoryGuildEx") 

	if not frmHistoryGuildEx:getVisible() then	
		return
	end

	local ckGoldPage = SAPI.GetChild(frmHistoryGuildEx, "ckGoldPage")
	if ckGoldPage:getChecked() == false then return end

	self:getHeaderButton(0):SetText(uiLanString("GUILD_BANK_COL_TIME"))
	self:getHeaderButton(1):SetText(uiLanString("GUILD_BANK_COL_USERNAME"))
	self:getHeaderButton(2):SetText(uiLanString("GUILD_BANK_COL_OP"))
	self:getHeaderButton(3):SetText(uiLanString("GUILD_BANK_COL_MONEY"))
	self:RemoveAllLines()

	UI_Guild_Bank_MoneyHistory_Current_Page = math.floor(iBegin/UI_GUILDBANK_HISTORY_SHOW_COUNT) + 1
	local lbPage = SAPI.GetChild(frmHistoryGuildEx,"lbPage")
	lbPage:SetText(""..UI_Guild_Bank_MoneyHistory_Current_Page)

	local gdata = uiGuild_GetGuildHistoryData()
	if gdata == nil then return end

	local icolor = 4292927712

	local counter = 0

	for i, _data in ipairs(gdata) do
		local _, iMonth, iDay, iHour, iMin = uiBank_TimeGetDate(_data.Time)
		local strTime = string.format(uiLanString("GUILD_BANK_HIS_TIME"), iMonth, iDay, iHour, iMin )

		local strOperate = ""
		if _data.Operate == 0 then
			strOperate = uiLanString("GUILD_BANK_SAVE")
		elseif _data.Operate == 1 then
			strOperate = uiLanString("GUILD_BANK_WITHDRAW")
		end

		local strMoney = "0"
		if _data.Money >= 10000 then
			strMoney = tostring(math.floor(_data.Money/10000))..uiLanString("MSG_ITEM_GOLD")
		elseif _data.Money >= 100 then
			strMoney = tostring(math.floor(_data.Money/100))..uiLanString("MSG_ITEM_SILVER")
		elseif _data.Money > 0 then
			strMoney = tostring(_data.Money)..uiLanString("MSG_ITEM_COPPER")
		end

		self:InsertLine(-1,-1,-1)
		self:SetLineItem(counter, 0, strTime, icolor)
		self:SetLineItem(counter, 1, _data.UserName, icolor)
		self:SetLineItem(counter, 2, strOperate, icolor)
		self:SetLineItem(counter, 3, strMoney, icolor)
		counter = counter + 1
	end
end

function layWorld_frmHistoryGuildEx_ckItemPage_OnLClick(self)
	local frmHistoryGuildEx = uiGetglobal("layWorld.frmHistoryGuildEx") 

	if not frmHistoryGuildEx:getVisible() then	
		return
	end

	local ckGoldPage = SAPI.GetChild(frmHistoryGuildEx, "ckGoldPage")
	
	self:SetChecked(true)
	ckGoldPage:SetChecked(false)

	local lstGuildHistoryItem = SAPI.GetChild(frmHistoryGuildEx,"lstGuildHistoryItem")
	local lstGuildHistoryMoney = SAPI.GetChild(frmHistoryGuildEx,"lstGuildHistoryMoney")

	lstGuildHistoryItem:Show()
	lstGuildHistoryMoney:Hide()

	local lbPage = SAPI.GetChild(frmHistoryGuildEx, "lbPage")
	lbPage:SetText(""..UI_Guild_Bank_ItemHistory_Current_Page)

	local iStart = (UI_Guild_Bank_ItemHistory_Current_Page - 1) * UI_GUILDBANK_HISTORY_SHOW_COUNT;
    local iEnd = UI_Guild_Bank_ItemHistory_Current_Page * UI_GUILDBANK_HISTORY_SHOW_COUNT;

	uiGuild_QueryGuildBankHistory(true, iStart, iEnd)
end

function layWorld_frmHistoryGuildEx_ckGoldPage_OnLClick(self)
	local frmHistoryGuildEx = uiGetglobal("layWorld.frmHistoryGuildEx") 

	if not frmHistoryGuildEx:getVisible() then	
		return
	end

	local ckItemPage = SAPI.GetChild(frmHistoryGuildEx, "ckItemPage")
	
	self:SetChecked(true)
	ckItemPage:SetChecked(false)

	local lstGuildHistoryItem = SAPI.GetChild(frmHistoryGuildEx,"lstGuildHistoryItem")
	local lstGuildHistoryMoney = SAPI.GetChild(frmHistoryGuildEx,"lstGuildHistoryMoney")

	lstGuildHistoryItem:Hide()
	lstGuildHistoryMoney:Show()

	local lbPage = SAPI.GetChild(frmHistoryGuildEx, "lbPage")
	lbPage:SetText(""..UI_Guild_Bank_MoneyHistory_Current_Page)

	local iStart = (UI_Guild_Bank_MoneyHistory_Current_Page - 1) * UI_GUILDBANK_HISTORY_SHOW_COUNT;
    local iEnd = UI_Guild_Bank_MoneyHistory_Current_Page * UI_GUILDBANK_HISTORY_SHOW_COUNT;

	uiGuild_QueryGuildBankHistory(false, iStart, iEnd)
end

function layWorld_frmHistoryGuildEx_btnPre_OnLClick(self)
	local frmHistoryGuildEx = uiGetglobal("layWorld.frmHistoryGuildEx") 

	if not frmHistoryGuildEx:getVisible() then	
		return
	end

	local iStart = 0
	local iEnd = 0
	
	local ckItemPage = SAPI.GetChild(frmHistoryGuildEx, "ckItemPage")

	if ckItemPage:getChecked() then
		if UI_Guild_Bank_ItemHistory_Current_Page - 1 < 1 then return end
		iStart = (UI_Guild_Bank_ItemHistory_Current_Page - 2) * UI_GUILDBANK_HISTORY_SHOW_COUNT;
        iEnd = (UI_Guild_Bank_ItemHistory_Current_Page - 1) * UI_GUILDBANK_HISTORY_SHOW_COUNT;
	else
		if UI_Guild_Bank_MoneyHistory_Current_Page - 1 < 1 then return end
		iStart = (UI_Guild_Bank_MoneyHistory_Current_Page - 2) * UI_GUILDBANK_HISTORY_SHOW_COUNT;
        iEnd = (UI_Guild_Bank_MoneyHistory_Current_Page - 1) * UI_GUILDBANK_HISTORY_SHOW_COUNT;
	end

	uiGuild_QueryGuildBankHistory(ckItemPage:getChecked(), iStart, iEnd)
end

function layWorld_frmHistoryGuildEx_btnNext_OnLClick(self)
	local frmHistoryGuildEx = uiGetglobal("layWorld.frmHistoryGuildEx") 

	if not frmHistoryGuildEx:getVisible() then	
		return
	end

	local iStart = 0
	local iEnd = 0
	
	local ckItemPage = SAPI.GetChild(frmHistoryGuildEx, "ckItemPage")

	if ckItemPage:getChecked() then
		if UI_Guild_Bank_ItemHistory_Current_Page >= UI_GUILDBANK_HISTORY_MAX_PAGE then return end
		iStart = UI_Guild_Bank_ItemHistory_Current_Page * UI_GUILDBANK_HISTORY_SHOW_COUNT;
        iEnd = (UI_Guild_Bank_ItemHistory_Current_Page + 1) * UI_GUILDBANK_HISTORY_SHOW_COUNT;
	else
		if UI_Guild_Bank_MoneyHistory_Current_Page >= UI_GUILDBANK_HISTORY_MAX_PAGE then return end
		iStart = UI_Guild_Bank_MoneyHistory_Current_Page * UI_GUILDBANK_HISTORY_SHOW_COUNT;
        iEnd = (UI_Guild_Bank_MoneyHistory_Current_Page + 1) * UI_GUILDBANK_HISTORY_SHOW_COUNT;
	end

	uiGuild_QueryGuildBankHistory(ckItemPage:getChecked(), iStart, iEnd)
end

function layWorld_frmHistoryGuildEx_OnUpdate(self)
	local now = os.clock();
	local LastUpdate = self.LastUpdate;
	if not LastUpdate then
		self.LastUpdate = now;
		return;
	end
	if LastUpdate + 5 < now then return end
	self.LastUpdate = now;

	local ckItemPage = SAPI.GetChild(self, "ckItemPage")
	local bItem = ckItemPage:getChecked()
	local iStart = 0
	local iEnd = 0
	if bItem == true then
		iStart = (UI_Guild_Bank_ItemHistory_Current_Page - 1) * UI_GUILDBANK_HISTORY_SHOW_COUNT;
        iEnd = UI_Guild_Bank_ItemHistory_Current_Page * UI_GUILDBANK_HISTORY_SHOW_COUNT;
	elseif bitem == false then
		iStart = (UI_Guild_Bank_MoneyHistory_Current_Page - 1) * UI_GUILDBANK_HISTORY_SHOW_COUNT;
        iEnd = UI_Guild_Bank_MoneyHistory_Current_Page * UI_GUILDBANK_HISTORY_SHOW_COUNT;
	end
	uiGuild_QueryGuildBankHistory(bItem, iStart, iEnd)
end


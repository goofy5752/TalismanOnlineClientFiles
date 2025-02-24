local UI_Create_Item_Object_Id = 0
local UI_Create_Smithing_Object_Id = 0
local UI_Create_Luck1_Object_Id = 0
local UI_Create_Luck2_Object_Id = 0
local UI_Create_Luck3_Object_Id = 0
local UI_Create_Luck4_Object_Id = 0
local UI_CREATE_AUTO_ADD_GEM_MAX_LEVEL = 12


local function AutoAddSmithingGem ()
	if not UI_Create_Item_Object_Id or UI_Create_Item_Object_Id == 0 then return end
	
	local itemOid = UI_Create_Item_Object_Id;
	local objInfo = uiItemGetBagItemInfoByObjectId(itemOid);
	if objInfo.SmithingLevel >= UI_CREATE_AUTO_ADD_GEM_MAX_LEVEL then return end
	local index, rate, gemTrump, gemArmor = uiItemSmithing_GetItemSmithingData(itemOid);
	local NeedGemType = nil;
	if objInfo then
		if objInfo.Type == EV_ITEM_TYPE_RIDER or objInfo.Type == EV_ITEM_TYPE_MAINTRUMP then
			NeedGemType = gemTrump;
		else
			NeedGemType = gemArmor;
		end
	end
	
	if NeedGemType then
		if UI_Create_Smithing_Object_Id and UI_Create_Smithing_Object_Id > 0 then
			local objInfo = uiItemGetBagItemInfoByObjectId(UI_Create_Smithing_Object_Id);
			if objInfo and objInfo.Type == NeedGemType then
				return;
			end
			LClass_ItemFreezeManager:Erase(UI_Create_Smithing_Object_Id); -- ½â¶³
			UI_Create_Smithing_Object_Id = 0;
		end
		
		local count, objId, classId = uiGetBagItemInfoByType(NeedGemType);
		local GemId = nil;
		if objId and objId > 0 then
			local bag, line, col = uiItemGetItemCoordByObjectId(objId);
			if bag then
				local line, col, count, istask, isOutdate = uiItemGetItemBagInfoByIndex(bag);
				if not isOutdate then
					GemId = objId;
				end
			end
		end
		if GemId and GemId > 0 then
			LClass_ItemFreezeManager:Push(GemId); -- ¶³½á
			--uiItemFreezeItem(UI_Create_Smithing_Object_Id, false)
			UI_Create_Smithing_Object_Id = GemId;
		else
			uiClientMsg(LAN("MSG_SMITHING_NO_GEM"), true);
		end
	end
end

function layWorld_frmCreateEx_Refresh()
	local self = uiGetglobal("layWorld.frmCreateEx")

	if not self:getVisible() then
		return
	end

	local btCreateItem = SAPI.GetChild(self, "btCreateItem")
	local btCreateSmithing = SAPI.GetChild(self, "btCreateSmithing")
	local btLuckyItem1 = SAPI.GetChild(self, "btLuckyItem1")
	local btLuckyItem2 = SAPI.GetChild(self, "btLuckyItem2")
	local btLuckyItem3 = SAPI.GetChild(self, "btLuckyItem3")
	local btLuckyItem4 = SAPI.GetChild(self, "btLuckyItem4")

	local lbCreateTip = SAPI.GetChild(self, "lbCreateTip")
	lbCreateTip:SetText(uiLanString("MSG_SMITHING_HINT"))

	local edtMoney = SAPI.GetChild(self, "edtMoney")
	edtMoney:SetText("")

	local SuccessRate2 = SAPI.GetChild(self, "SuccessRate2")
	SuccessRate2:SetText("0")

	local SuccessRate = SAPI.GetChild(self, "SuccessRate")
	SuccessRate:SetText("0")

	btCreateItem:SetNormalImage(0)
	btCreateItem:ModifyFlag("DragOut", false)

	btCreateSmithing:SetNormalImage(0)
	btCreateSmithing:ModifyFlag("DragOut", false)

	btLuckyItem1:SetNormalImage(0)
	btLuckyItem1:ModifyFlag("DragOut", false)

	btLuckyItem2:SetNormalImage(0)
	btLuckyItem2:ModifyFlag("DragOut", false)

	btLuckyItem3:SetNormalImage(0)
	btLuckyItem3:ModifyFlag("DragOut", false)

	btLuckyItem4:SetNormalImage(0)
	btLuckyItem4:ModifyFlag("DragOut", false)
	
	if UI_Create_Item_Object_Id == nil or UI_Create_Item_Object_Id == 0 then
		UI_Create_Item_Object_Id = 0
	else
		local imgstr = uiItemSmithing_GetItemInfo(UI_Create_Item_Object_Id)
		if imgstr ~= nil then
			local image_item = SAPI.GetImage(imgstr, 2, 2, -2, -2)
			if image_item ~= nil then
				btCreateItem:SetNormalImage(image_item)
				btCreateItem:ModifyFlag("DragOut", true)
			end
			
			local moneyStr, failRate = uiItemSmithing_GetSmithingItemInfo(UI_Create_Item_Object_Id,UI_Create_Luck1_Object_Id,UI_Create_Luck2_Object_Id,UI_Create_Luck3_Object_Id,UI_Create_Luck4_Object_Id)
			edtMoney:SetRichText(moneyStr, false)
			SuccessRate2:SetText(""..math.floor(failRate * 100))

		else
			UI_Create_Item_Object_Id = 0
		end
	end
	
	local lbSmithingLevel = SAPI.GetChild(self, "lbSmithingLevel");
	if UI_Create_Item_Object_Id and UI_Create_Item_Object_Id > 0 then
		local objInfo = uiItemGetBagItemInfoByObjectId(UI_Create_Item_Object_Id);
		if objInfo then
			lbSmithingLevel:Show();
			lbSmithingLevel:SetText("+"..objInfo.SmithingLevel);
		end
	else
		lbSmithingLevel:Hide();
	end

	if UI_Create_Smithing_Object_Id == nil or UI_Create_Smithing_Object_Id == 0 then
		UI_Create_Smithing_Object_Id = 0
	else
		local imgstr = uiItemSmithing_GetItemInfo(UI_Create_Smithing_Object_Id)
		if imgstr ~= nil then
			local image_item = SAPI.GetImage(imgstr, 2, 2, -2, -2)
			if image_item ~= nil then
				btCreateSmithing:SetNormalImage(image_item)
				btCreateSmithing:ModifyFlag("DragOut", true)
			end
		else
			UI_Create_Smithing_Object_Id = 0
		end
	end

	if UI_Create_Luck1_Object_Id == nil or UI_Create_Luck1_Object_Id == 0 then
		UI_Create_Luck1_Object_Id = 0
	else
		local imgstr = uiItemSmithing_GetItemInfo(UI_Create_Luck1_Object_Id)
		if imgstr ~= nil then
			local image_item = SAPI.GetImage(imgstr, 2, 2, -2, -2)
			if image_item ~= nil then
				btLuckyItem1:SetNormalImage(image_item)
				btLuckyItem1:ModifyFlag("DragOut", true)
			end
		else
			UI_Create_Luck1_Object_Id = 0
		end
	end

	if UI_Create_Luck2_Object_Id == nil or UI_Create_Luck2_Object_Id == 0 then
		UI_Create_Luck2_Object_Id = 0
	else
		local imgstr = uiItemSmithing_GetItemInfo(UI_Create_Luck2_Object_Id)
		if imgstr ~= nil then
			local image_item = SAPI.GetImage(imgstr, 2, 2, -2, -2)
			if image_item ~= nil then
				btLuckyItem2:SetNormalImage(image_item)
				btLuckyItem2:ModifyFlag("DragOut", true)
			end
		else
			UI_Create_Luck2_Object_Id = 0
		end
	end

	if UI_Create_Luck3_Object_Id == nil or UI_Create_Luck3_Object_Id == 0 then
		UI_Create_Luck3_Object_Id = 0
	else
		local imgstr = uiItemSmithing_GetItemInfo(UI_Create_Luck3_Object_Id)
		if imgstr ~= nil then
			local image_item = SAPI.GetImage(imgstr, 2, 2, -2, -2)
			if image_item ~= nil then
				btLuckyItem3:SetNormalImage(image_item)
				btLuckyItem3:ModifyFlag("DragOut", true)
			end
		else
			UI_Create_Luck3_Object_Id = 0
		end
	end

	if UI_Create_Luck4_Object_Id == nil or UI_Create_Luck4_Object_Id == 0 then
		UI_Create_Luck4_Object_Id = 0
	else
		local imgstr = uiItemSmithing_GetItemInfo(UI_Create_Luck4_Object_Id)
		if imgstr ~= nil then
			local image_item = SAPI.GetImage(imgstr, 2, 2, -2, -2)
			if image_item ~= nil then
				btLuckyItem4:SetNormalImage(image_item)
				btLuckyItem4:ModifyFlag("DragOut", true)
			end
		else
			UI_Create_Luck4_Object_Id = 0
		end
	end

	local successRate = uiItemSmithing_GetSmithingItemSuccessRate(UI_Create_Item_Object_Id, UI_Create_Luck1_Object_Id, UI_Create_Luck2_Object_Id, UI_Create_Luck3_Object_Id, UI_Create_Luck4_Object_Id)
	
	SuccessRate:SetText(""..math.floor(successRate*100))

	if btCreateItem:IsHovered() then
		layWorld_frmCreateEx_btCreateItem_OnHint(btCreateItem)
	end

	if btCreateSmithing:IsHovered() then
		layWorld_frmCreateEx_btCreateSmithing_OnHint(btCreateSmithing)
	end

	if btLuckyItem1:IsHovered() then
		layWorld_frmCreateEx_btLuckyItem1_OnHint(btLuckyItem1)
	end

	if btLuckyItem2:IsHovered() then
		layWorld_frmCreateEx_btLuckyItem2_OnHint(btLuckyItem2)
	end

	if btLuckyItem3:IsHovered() then
		layWorld_frmCreateEx_btLuckyItem3_OnHint(btLuckyItem3)
	end

	if btLuckyItem4:IsHovered() then
		layWorld_frmCreateEx_btLuckyItem4_OnHint(btLuckyItem4)
	end
	
end

function layWorld_frmCreateEx_Show(self)
	self:ShowAndFocus()
	self:MoveTo(150, 200)
		
	UI_Create_Item_Object_Id = 0    
	UI_Create_Smithing_Object_Id = 0
	UI_Create_Luck1_Object_Id = 0   
	UI_Create_Luck2_Object_Id = 0   
	UI_Create_Luck3_Object_Id = 0   
	UI_Create_Luck4_Object_Id = 0   


	layWorld_frmCreateEx_Refresh()
end

function layWorld_frmCreateEx_btCreateItem_OnHint(self)
	if UI_Create_Item_Object_Id == nil or UI_Create_Item_Object_Id == 0 then
		self:SetHintRichText(uiItemSmithing_GetStringChangeFont_RichText(uiLanString("MSG_SMITHING_HINT_ITEM")))
		return
	end

	local _,_,richtext = uiItemSmithing_GetItemInfo(UI_Create_Item_Object_Id)
	if richtext == nil then
		self:SetHintRichText(uiItemSmithing_GetStringChangeFont_RichText(uiLanString("MSG_SMITHING_HINT_ITEM")))
	else
		self:SetHintRichText(richtext)
	end
end

function layWorld_frmCreateEx_btCreateSmithing_OnHint(self)
	if UI_Create_Smithing_Object_Id == nil or UI_Create_Smithing_Object_Id == 0 then
		self:SetHintRichText(uiItemSmithing_GetStringChangeFont_RichText(uiLanString("MSG_SMITHING_HINT_GEM")))
		return
	end

	local _,_,richtext = uiItemSmithing_GetItemInfo(UI_Create_Smithing_Object_Id)
	if richtext == nil then
		self:SetHintRichText(uiItemSmithing_GetStringChangeFont_RichText(uiLanString("MSG_SMITHING_HINT_GEM")))
	else
		self:SetHintRichText(richtext)
	end
end

function layWorld_frmCreateEx_btLuckyItem1_OnHint(self)
	if UI_Create_Luck1_Object_Id == nil or UI_Create_Luck1_Object_Id == 0 then
		self:SetHintRichText(uiItemSmithing_GetStringChangeFont_RichText(uiLanString("MSG_SMITHING_HINT_LUCK")))
		return
	end

	local _,_,richtext = uiItemSmithing_GetItemInfo(UI_Create_Luck1_Object_Id)
	if richtext == nil then
		self:SetHintRichText(uiItemSmithing_GetStringChangeFont_RichText(uiLanString("MSG_SMITHING_HINT_LUCK")))
	else
		self:SetHintRichText(richtext)
	end
end

function layWorld_frmCreateEx_btLuckyItem2_OnHint(self)
	if UI_Create_Luck2_Object_Id == nil or UI_Create_Luck2_Object_Id == 0 then
		self:SetHintRichText(uiItemSmithing_GetStringChangeFont_RichText(uiLanString("MSG_SMITHING_HINT_LUCK")))
		return
	end

	local _,_,richtext = uiItemSmithing_GetItemInfo(UI_Create_Luck2_Object_Id)
	if richtext == nil then
		self:SetHintRichText(uiItemSmithing_GetStringChangeFont_RichText(uiLanString("MSG_SMITHING_HINT_LUCK")))
	else
		self:SetHintRichText(richtext)
	end
end

function layWorld_frmCreateEx_btLuckyItem3_OnHint(self)
	if UI_Create_Luck3_Object_Id == nil or UI_Create_Luck3_Object_Id == 0 then
		self:SetHintRichText(uiItemSmithing_GetStringChangeFont_RichText(uiLanString("MSG_SMITHING_HINT_LUCK")))
		return
	end

	local _,_,richtext = uiItemSmithing_GetItemInfo(UI_Create_Luck3_Object_Id)
	if richtext == nil then
		self:SetHintRichText(uiItemSmithing_GetStringChangeFont_RichText(uiLanString("MSG_SMITHING_HINT_LUCK")))
	else
		self:SetHintRichText(richtext)
	end
end

function layWorld_frmCreateEx_btLuckyItem4_OnHint(self)
	if UI_Create_Luck4_Object_Id == nil or UI_Create_Luck4_Object_Id == 0 then
		self:SetHintRichText(uiItemSmithing_GetStringChangeFont_RichText(uiLanString("MSG_SMITHING_HINT_LUCK")))
		return
	end

	local _,_,richtext = uiItemSmithing_GetItemInfo(UI_Create_Luck4_Object_Id)
	if richtext == nil then
		self:SetHintRichText(uiItemSmithing_GetStringChangeFont_RichText(uiLanString("MSG_SMITHING_HINT_LUCK")))
	else
		self:SetHintRichText(richtext)
	end
end

function layWorld_frmCreateEx_OnDragIn(drag)

	local w = uiGetglobal(drag);
	if w == nil then
		return
	end
	--local itemOid = uiItemSmithing_GetItemObjectIdByWidget(w)

	if w:Get(EV_UI_SHORTCUT_OWNER_KEY) == EV_UI_SHORTCUT_OWNER_EQUIP then
		uiClientMsg(LAN("MSG_UPDATE_ERROR1"), true)
		return
	end

	if w:Get(EV_UI_SHORTCUT_OWNER_KEY) ~= EV_UI_SHORTCUT_OWNER_ITEM or w:Get(EV_UI_SHORTCUT_TYPE_KEY) ~= EV_SHORTCUT_OBJECT_ITEM then
		return
	end

	local itemOid = w:Get(EV_UI_SHORTCUT_OBJECTID_KEY)

	if itemOid == nil or itemOid == 0 then
		return
	end
	
	local _, isSmithingItem = uiItemSmithing_GetItemInfo(itemOid)

	if isSmithingItem == nil then
		return
	end

	if isSmithingItem then
		layWorld_frmCreateEx_btCreateSmithing_OnDragIn(drag)
	else
		layWorld_frmCreateEx_btCreateItem_OnDragIn(drag)
	end
end

function layWorld_frmCreateEx_btCreateItem_OnDragIn(drag)
	local w = uiGetglobal(drag);
	if w == nil then
		return
	end
	--local itemOid = uiItemSmithing_GetItemObjectIdByWidget(w)

	if w:Get(EV_UI_SHORTCUT_OWNER_KEY) == EV_UI_SHORTCUT_OWNER_EQUIP then
		uiClientMsg(LAN("MSG_UPDATE_ERROR1"), true)
		return
	end

	if w:Get(EV_UI_SHORTCUT_OWNER_KEY) ~= EV_UI_SHORTCUT_OWNER_ITEM or w:Get(EV_UI_SHORTCUT_TYPE_KEY) ~= EV_SHORTCUT_OBJECT_ITEM then
		return
	end

	local itemOid = w:Get(EV_UI_SHORTCUT_OBJECTID_KEY)

	if itemOid == nil or itemOid == 0 then
		return
	end

	if uiItemSmithing_CheckItemToSmithing(itemOid) then
		if UI_Create_Item_Object_Id ~= nil then
			LClass_ItemFreezeManager:Erase(UI_Create_Item_Object_Id); -- ½â¶³
			--uiItemFreezeItem(UI_Create_Item_Object_Id, false)
		end
		UI_Create_Item_Object_Id = itemOid
		
		if UI_Create_Smithing_Object_Id ~= 0 then
			LClass_ItemFreezeManager:Erase(UI_Create_Smithing_Object_Id); -- ½â¶³
			--uiItemFreezeItem(UI_Create_Smithing_Object_Id, false)
			UI_Create_Smithing_Object_Id = 0
		end
		
		AutoAddSmithingGem ();

		if UI_Create_Luck1_Object_Id ~= 0 then
			LClass_ItemFreezeManager:Erase(UI_Create_Luck1_Object_Id); -- ½â¶³
			--uiItemFreezeItem(UI_Create_Luck1_Object_Id, false)
			UI_Create_Luck1_Object_Id = 0
		end

		if UI_Create_Luck2_Object_Id ~= 0 then
			LClass_ItemFreezeManager:Erase(UI_Create_Luck2_Object_Id); -- ½â¶³
			--uiItemFreezeItem(UI_Create_Luck2_Object_Id, false)
			UI_Create_Luck2_Object_Id = 0
		end

		if UI_Create_Luck3_Object_Id ~= 0 then
			LClass_ItemFreezeManager:Erase(UI_Create_Luck3_Object_Id); -- ½â¶³
			--uiItemFreezeItem(UI_Create_Luck3_Object_Id, false)
			UI_Create_Luck3_Object_Id = 0
		end

		if UI_Create_Luck4_Object_Id ~= 0 then
			LClass_ItemFreezeManager:Erase(UI_Create_Luck4_Object_Id); -- ½â¶³
			--uiItemFreezeItem(UI_Create_Luck4_Object_Id, false)
			UI_Create_Luck4_Object_Id = 0
		end 
	
		LClass_ItemFreezeManager:Push(UI_Create_Item_Object_Id); -- ¶³½á
		--uiItemFreezeItem(UI_Create_Item_Object_Id, true)
		layWorld_frmCreateEx_Refresh()
	end
end

function layWorld_frmCreateEx_btCreateSmithing_OnDragIn(drag)
	local w = uiGetglobal(drag);
	if w == nil then
		return
	end
	--local itemOid = uiItemSmithing_GetItemObjectIdByWidget(w)

	if w:Get(EV_UI_SHORTCUT_OWNER_KEY) == EV_UI_SHORTCUT_OWNER_EQUIP then
		uiClientMsg(LAN("MSG_UPDATE_ERROR1"), true)
		return
	end

	if w:Get(EV_UI_SHORTCUT_OWNER_KEY) ~= EV_UI_SHORTCUT_OWNER_ITEM or w:Get(EV_UI_SHORTCUT_TYPE_KEY) ~= EV_SHORTCUT_OBJECT_ITEM then
		return
	end

	local itemOid = w:Get(EV_UI_SHORTCUT_OBJECTID_KEY)

	if itemOid == nil or itemOid == 0 then
		return
	end

	local objInfo = uiItemGetBagItemInfoByObjectId(itemOid)
	if objInfo.Type == 40 or objInfo.Type == 41 or objInfo.Type == 42 or objInfo.Type == 43 or objInfo.Type == 44 or objInfo.Type == 45 or objInfo.Type == 46 or objInfo.Type == 47 then
		if UI_Create_Smithing_Object_Id ~= nil then
			LClass_ItemFreezeManager:Erase(UI_Create_Smithing_Object_Id); -- ½â¶³
			--uiItemFreezeItem(UI_Create_Smithing_Object_Id, false)
		end
		UI_Create_Smithing_Object_Id = itemOid
		LClass_ItemFreezeManager:Push(UI_Create_Smithing_Object_Id); -- ¶³½á
		--uiItemFreezeItem(UI_Create_Smithing_Object_Id, true)
		layWorld_frmCreateEx_Refresh()
	end
end

function layWorld_frmCreateEx_btLuckyItem1_OnDragIn(drag)
	local w = uiGetglobal(drag);
	if w == nil then
		return
	end
	--local itemOid = uiItemSmithing_GetItemObjectIdByWidget(w)

	if w:Get(EV_UI_SHORTCUT_OWNER_KEY) == EV_UI_SHORTCUT_OWNER_EQUIP then
		uiClientMsg(LAN("MSG_UPDATE_ERROR1"), true)
		return
	end

	if w:Get(EV_UI_SHORTCUT_OWNER_KEY) ~= EV_UI_SHORTCUT_OWNER_ITEM or w:Get(EV_UI_SHORTCUT_TYPE_KEY) ~= EV_SHORTCUT_OBJECT_ITEM then
		return
	end

	local itemOid = w:Get(EV_UI_SHORTCUT_OBJECTID_KEY)

	if itemOid == nil or itemOid == 0 then
		return
	end

	if UI_Create_Item_Object_Id == nil or UI_Create_Item_Object_Id == 0 then
		return
	end

	if itemOid == UI_Create_Item_Object_Id or itemOid == UI_Create_Luck2_Object_Id or itemOid == UI_Create_Luck3_Object_Id or itemOid == UI_Create_Luck4_Object_Id then
		return
	end

	if uiItemSmithing_CheckLuckItem(UI_Create_Item_Object_Id, itemOid, UI_Create_Luck1_Object_Id, UI_Create_Luck2_Object_Id, UI_Create_Luck3_Object_Id, UI_Create_Luck4_Object_Id) then
		if UI_Create_Luck1_Object_Id ~= nil then
			LClass_ItemFreezeManager:Erase(UI_Create_Luck1_Object_Id); -- ½â¶³
			--uiItemFreezeItem(UI_Create_Luck1_Object_Id, false)
		end
		UI_Create_Luck1_Object_Id = itemOid
		LClass_ItemFreezeManager:Push(UI_Create_Luck1_Object_Id); -- ¶³½á
		--uiItemFreezeItem(UI_Create_Luck1_Object_Id, true)
		layWorld_frmCreateEx_Refresh()
	end
end

function layWorld_frmCreateEx_btLuckyItem2_OnDragIn(drag)
	local w = uiGetglobal(drag);
	if w == nil then
		return
	end
	--local itemOid = uiItemSmithing_GetItemObjectIdByWidget(w)

	if w:Get(EV_UI_SHORTCUT_OWNER_KEY) == EV_UI_SHORTCUT_OWNER_EQUIP then
		uiClientMsg(LAN("MSG_UPDATE_ERROR1"), true)
		return
	end

	if w:Get(EV_UI_SHORTCUT_OWNER_KEY) ~= EV_UI_SHORTCUT_OWNER_ITEM or w:Get(EV_UI_SHORTCUT_TYPE_KEY) ~= EV_SHORTCUT_OBJECT_ITEM then
		return
	end

	local itemOid = w:Get(EV_UI_SHORTCUT_OBJECTID_KEY)

	if itemOid == nil or itemOid == 0 then
		return
	end

	if UI_Create_Item_Object_Id == nil or UI_Create_Item_Object_Id == 0 then
		return
	end

	if itemOid == UI_Create_Item_Object_Id or itemOid == UI_Create_Luck1_Object_Id or itemOid == UI_Create_Luck3_Object_Id or itemOid == UI_Create_Luck4_Object_Id then
		return
	end

	if uiItemSmithing_CheckLuckItem(UI_Create_Item_Object_Id, itemOid, UI_Create_Luck1_Object_Id, UI_Create_Luck2_Object_Id, UI_Create_Luck3_Object_Id, UI_Create_Luck4_Object_Id) then
		if UI_Create_Luck2_Object_Id ~= nil then
			LClass_ItemFreezeManager:Erase(UI_Create_Luck2_Object_Id); -- ½â¶³
			--uiItemFreezeItem(UI_Create_Luck2_Object_Id, false)
		end
		UI_Create_Luck2_Object_Id = itemOid
		LClass_ItemFreezeManager:Push(UI_Create_Luck2_Object_Id); -- ¶³½á
		--uiItemFreezeItem(UI_Create_Luck2_Object_Id, true)
		layWorld_frmCreateEx_Refresh()
	end
end

function layWorld_frmCreateEx_btLuckyItem3_OnDragIn(drag)
	local w = uiGetglobal(drag);
	if w == nil then
		return
	end
	--local itemOid = uiItemSmithing_GetItemObjectIdByWidget(w)

	if w:Get(EV_UI_SHORTCUT_OWNER_KEY) == EV_UI_SHORTCUT_OWNER_EQUIP then
		uiClientMsg(LAN("MSG_UPDATE_ERROR1"), true)
		return
	end

	if w:Get(EV_UI_SHORTCUT_OWNER_KEY) ~= EV_UI_SHORTCUT_OWNER_ITEM or w:Get(EV_UI_SHORTCUT_TYPE_KEY) ~= EV_SHORTCUT_OBJECT_ITEM then
		return
	end

	local itemOid = w:Get(EV_UI_SHORTCUT_OBJECTID_KEY)

	if itemOid == nil or itemOid == 0 then
		return
	end

	if UI_Create_Item_Object_Id == nil or UI_Create_Item_Object_Id == 0 then
		return
	end

	if itemOid == UI_Create_Item_Object_Id or itemOid == UI_Create_Luck1_Object_Id or itemOid == UI_Create_Luck2_Object_Id or itemOid == UI_Create_Luck4_Object_Id then
		return
	end

	if uiItemSmithing_CheckLuckItem(UI_Create_Item_Object_Id, itemOid, UI_Create_Luck1_Object_Id, UI_Create_Luck2_Object_Id, UI_Create_Luck3_Object_Id, UI_Create_Luck4_Object_Id) then
		if UI_Create_Luck3_Object_Id ~= nil then
			LClass_ItemFreezeManager:Erase(UI_Create_Luck3_Object_Id); -- ½â¶³
			--uiItemFreezeItem(UI_Create_Luck3_Object_Id, false)
		end
		UI_Create_Luck3_Object_Id = itemOid
		LClass_ItemFreezeManager:Push(UI_Create_Luck3_Object_Id); -- ¶³½á
		--uiItemFreezeItem(UI_Create_Luck3_Object_Id, true)
		layWorld_frmCreateEx_Refresh()
	end
end

function layWorld_frmCreateEx_btLuckyItem4_OnDragIn(drag)
	local w = uiGetglobal(drag);
	if w == nil then
		return
	end
	--local itemOid = uiItemSmithing_GetItemObjectIdByWidget(w)

	if w:Get(EV_UI_SHORTCUT_OWNER_KEY) == EV_UI_SHORTCUT_OWNER_EQUIP then
		uiClientMsg(LAN("MSG_UPDATE_ERROR1"), true)
		return
	end

	if w:Get(EV_UI_SHORTCUT_OWNER_KEY) ~= EV_UI_SHORTCUT_OWNER_ITEM or w:Get(EV_UI_SHORTCUT_TYPE_KEY) ~= EV_SHORTCUT_OBJECT_ITEM then
		return
	end

	local itemOid = w:Get(EV_UI_SHORTCUT_OBJECTID_KEY)

	if itemOid == nil or itemOid == 0 then
		return
	end

	if UI_Create_Item_Object_Id == nil or UI_Create_Item_Object_Id == 0 then
		return
	end

	if itemOid == UI_Create_Item_Object_Id or itemOid == UI_Create_Luck1_Object_Id or itemOid == UI_Create_Luck2_Object_Id or itemOid == UI_Create_Luck3_Object_Id then
		return
	end

	if uiItemSmithing_CheckLuckItem(UI_Create_Item_Object_Id, itemOid, UI_Create_Luck1_Object_Id, UI_Create_Luck2_Object_Id, UI_Create_Luck3_Object_Id, UI_Create_Luck4_Object_Id) then
		if UI_Create_Luck4_Object_Id ~= nil then
			LClass_ItemFreezeManager:Erase(UI_Create_Luck4_Object_Id); -- ½â¶³
			--uiItemFreezeItem(UI_Create_Luck4_Object_Id, false)
		end
		UI_Create_Luck4_Object_Id = itemOid
		LClass_ItemFreezeManager:Push(UI_Create_Luck4_Object_Id); -- ¶³½á
		--uiItemFreezeItem(UI_Create_Luck4_Object_Id, true)
		layWorld_frmCreateEx_Refresh()
	end
end

function layWorld_frmCreateEx_btCreateItem_OnDragNull(self)
	if UI_Create_Item_Object_Id ~= 0 then
		LClass_ItemFreezeManager:Erase(UI_Create_Item_Object_Id); -- ½â¶³
		--uiItemFreezeItem(UI_Create_Item_Object_Id, false)
	end
	UI_Create_Item_Object_Id = 0
	layWorld_frmCreateEx_Refresh()
end

function layWorld_frmCreateEx_btCreateSmithing_OnDragNull(self)
	if UI_Create_Smithing_Object_Id ~= 0 then
		LClass_ItemFreezeManager:Erase(UI_Create_Smithing_Object_Id); -- ½â¶³
		--uiItemFreezeItem(UI_Create_Smithing_Object_Id, false)
	end
	UI_Create_Smithing_Object_Id = 0
	layWorld_frmCreateEx_Refresh()
end

function layWorld_frmCreateEx_btLuckyItem1_OnDragNull(self)
	if UI_Create_Luck1_Object_Id ~= 0 then
		LClass_ItemFreezeManager:Erase(UI_Create_Luck1_Object_Id); -- ½â¶³
		--uiItemFreezeItem(UI_Create_Luck1_Object_Id, false)
	end
	UI_Create_Luck1_Object_Id = 0
	layWorld_frmCreateEx_Refresh()
end

function layWorld_frmCreateEx_btLuckyItem2_OnDragNull(self)
	if UI_Create_Luck2_Object_Id ~= 0 then
		LClass_ItemFreezeManager:Erase(UI_Create_Luck2_Object_Id); -- ½â¶³
		--uiItemFreezeItem(UI_Create_Luck2_Object_Id, false)
	end
	UI_Create_Luck2_Object_Id = 0
	layWorld_frmCreateEx_Refresh()
end

function layWorld_frmCreateEx_btLuckyItem3_OnDragNull(self)
	if UI_Create_Luck3_Object_Id ~= 0 then
		LClass_ItemFreezeManager:Erase(UI_Create_Luck3_Object_Id); -- ½â¶³
		--uiItemFreezeItem(UI_Create_Luck3_Object_Id, false)
	end
	UI_Create_Luck3_Object_Id = 0
	layWorld_frmCreateEx_Refresh()
end

function layWorld_frmCreateEx_btLuckyItem4_OnDragNull(self)
	if UI_Create_Luck4_Object_Id ~= 0 then
		LClass_ItemFreezeManager:Erase(UI_Create_Luck4_Object_Id); -- ½â¶³
		--uiItemFreezeItem(UI_Create_Luck4_Object_Id, false)
	end
	UI_Create_Luck4_Object_Id = 0
	layWorld_frmCreateEx_Refresh()
end

function layWorld_frmCreateEx_OnEventItemUpDate(self, arg)
	local itemOid = uiItemUpdate_GetItemObjectIdByCoord(arg[2], arg[3], arg[4])
	if itemOid == UI_Create_Item_Object_Id or itemOid == UI_Create_Smithing_Object_Id or itemOid == UI_Create_Luck1_Object_Id or itemOid == UI_Create_Luck2_Object_Id or itemOid == UI_Create_Luck3_Object_Id or itemOid == UI_Create_Luck4_Object_Id  then
		if itemOid == UI_Create_Item_Object_Id then
			AutoAddSmithingGem ();
		end
		layWorld_frmCreateEx_Refresh()
	end
end

function layWorld_frmCreateEx__Result(arg)
	layWorld_frmCreateEx_Refresh()
	uiItemSmithing_ItemSmithing_Resultmsg(arg[1])
end

function layWorld_frmCreateEx_btOKCreate_OnLClick()
	uiItemSmithing_ItemSureSmithing(UI_Create_Item_Object_Id, UI_Create_Smithing_Object_Id, UI_Create_Luck1_Object_Id, UI_Create_Luck2_Object_Id, UI_Create_Luck3_Object_Id, UI_Create_Luck4_Object_Id)
end

function layWorld_frmCreateEx_btCancelCreate_OnLClick()
	local self = uiGetglobal("layWorld.frmCreateEx")
	self:Hide()
end

function layWorld_frmCreateEx_OnHide()
	if UI_Create_Item_Object_Id ~= 0 then
		--uiItemFreezeItem(UI_Create_Item_Object_Id, false)
		LClass_ItemFreezeManager:Erase(UI_Create_Item_Object_Id); -- ½â¶³
	end
	if UI_Create_Smithing_Object_Id ~= 0 then
		--uiItemFreezeItem(UI_Create_Smithing_Object_Id, false)
		LClass_ItemFreezeManager:Erase(UI_Create_Smithing_Object_Id); -- ½â¶³
	end
	if UI_Create_Luck1_Object_Id ~= 0 then
		--uiItemFreezeItem(UI_Create_Luck1_Object_Id, false)
		LClass_ItemFreezeManager:Erase(UI_Create_Luck1_Object_Id); -- ½â¶³
	end
	if UI_Create_Luck2_Object_Id ~= 0 then
		--uiItemFreezeItem(UI_Create_Luck2_Object_Id, false)
		LClass_ItemFreezeManager:Erase(UI_Create_Luck2_Object_Id); -- ½â¶³
	end
	if UI_Create_Luck3_Object_Id ~= 0 then
		--uiItemFreezeItem(UI_Create_Luck3_Object_Id, false)
		LClass_ItemFreezeManager:Erase(UI_Create_Luck3_Object_Id); -- ½â¶³
	end
	if UI_Create_Luck4_Object_Id ~= 0 then
		--uiItemFreezeItem(UI_Create_Luck4_Object_Id, false)
		LClass_ItemFreezeManager:Erase(UI_Create_Luck4_Object_Id); -- ½â¶³
	end
end

function layWorld_frmCreateEx_OnLoad(self)
	self:RegisterScriptEventNotify("CEV_ITEM_SMITHING_RESULT")
	self:RegisterScriptEventNotify("CEV_ITEM_SMITHING_SHOW")
	self:RegisterScriptEventNotify("bag_item_update")
	self:RegisterScriptEventNotify("bag_item_removed")
end

function layWorld_frmCreateEx_OnEvent(self, event, args)
	if event == "CEV_ITEM_SMITHING_RESULT" then
		layWorld_frmCreateEx__Result(args)
	elseif event == "CEV_ITEM_SMITHING_SHOW" then
		if self:getVisible() then
			return
		end
		layWorld_frmCreateEx_Show(self)
	elseif event == "bag_item_update" then
		layWorld_frmCreateEx_OnEventItemUpDate(self, args)
	elseif event == "bag_item_removed" then
		layWorld_frmCreateEx_Refresh()
	end
end


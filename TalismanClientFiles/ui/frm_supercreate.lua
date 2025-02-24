local UI_SuperCreate_Item_Object_Id = 0
local UI_SuperCreate_Can_Smith_cnt = 0

function layWorld_frmSuperCreate_ToShow(self)
	self:ShowAndFocus()
	layWorld_frmSuperCreate_Refresh()
end

function layWorld_frmSuperCreate_Refresh()
	local self = uiGetglobal("layWorld.frmSuperCreate")
	if not self:getVisible() then
		return
	end

	UI_SuperCreate_Can_Smith_cnt = 0

	local btCreateItem = SAPI.GetChild(self, "btCreateItem")
	local lbGem1 = SAPI.GetChild(self, "lbGem1")
	local lbGem2 = SAPI.GetChild(self, "lbGem2")
	local lbGem3 = SAPI.GetChild(self, "lbGem3")

	local lbGemAmount1 = SAPI.GetChild(self, "lbGemAmount1")
	local lbGemAmount2 = SAPI.GetChild(self, "lbGemAmount2")
	local lbGemAmount3 = SAPI.GetChild(self, "lbGemAmount3")

	local edtMoney = SAPI.GetChild(self, "edtMoney")
	local lbResidueDegree = SAPI.GetChild(self, "lbResidueDegree")

	local btOKCreate = SAPI.GetChild(self, "btOKCreate")
	btOKCreate:Disable()

	btCreateItem:SetNormalImage(0)
	btCreateItem:ModifyFlag("DragOut", false)

	lbGem1:SetNormalImage(0)
	lbGem2:SetNormalImage(0)
	lbGem3:SetNormalImage(0)
	lbGem1:SetUltraTextNormal("")
	lbGem2:SetUltraTextNormal("")
	lbGem3:SetUltraTextNormal("")
	lbGem1:SetMaskValue(0)
	lbGem2:SetMaskValue(0)
	lbGem3:SetMaskValue(0)
	
	lbGemAmount1:SetText("")
	lbGemAmount2:SetText("")
	lbGemAmount3:SetText("")

	

	edtMoney:SetText("")
	lbResidueDegree:SetText("")

	if UI_SuperCreate_Item_Object_Id == 0 then
		return
	end

	local itemInfo = uiItemGetBagItemInfoByObjectId(UI_SuperCreate_Item_Object_Id)
	if itemInfo == nil then 
		LClass_ItemFreezeManager:Erase(UI_SuperCreate_Item_Object_Id) -- 解冻
		UI_SuperCreate_Item_Object_Id = 0
		return 
	end

	local itemClassInfo = uiItemGetItemClassInfoByTableIndex(itemInfo.TableId)
	if itemClassInfo == nil then
		LClass_ItemFreezeManager:Erase(UI_SuperCreate_Item_Object_Id) -- 解冻
		UI_SuperCreate_Item_Object_Id = 0
		return 
	end

	local wantLev = itemInfo.SmithingLevel + 1
	if wantLev ~= 8 then
		LClass_ItemFreezeManager:Erase(UI_SuperCreate_Item_Object_Id) -- 解冻
		UI_SuperCreate_Item_Object_Id = 0
		return
	end

	local smithType = 1

	if itemClassInfo.Type == EV_ITEM_TYPE_MAINTRUMP or itemClassInfo.Type == EV_ITEM_TYPE_RIDER then
		smithType = 1
	elseif itemClassInfo.Type >= EV_ITEM_TYPE_CLOTHING and itemClassInfo.Type <= EV_ITEM_TYPE_SASH then
		smithType = 2
	elseif itemClassInfo.Type >= EV_ITEM_TYPE_PANTS and itemClassInfo.Type <= EV_ITEM_TYPE_SHIELD then
		smithType = 2
	else
		LClass_ItemFreezeManager:Erase(UI_SuperCreate_Item_Object_Id) -- 解冻
		UI_SuperCreate_Item_Object_Id = 0
		return
	end

	local ltSmithInfo = uiItemSafeSmithing_GetSafeSmithInfo(smithType, wantLev, UI_SuperCreate_Item_Object_Id)

	if ltSmithInfo == nil then
		LClass_ItemFreezeManager:Erase(UI_SuperCreate_Item_Object_Id) -- 解冻
		UI_SuperCreate_Item_Object_Id = 0
		return 
	end

	local image_item = SAPI.GetImage(itemClassInfo.Icon, 2, 2, -2, -2)
	if image_item ~= nil then
		btCreateItem:SetNormalImage(image_item)
		btCreateItem:ModifyFlag("DragOut", true)
	end

----------
	local image_small = SAPI.GetImage(ltSmithInfo.smallIcon, 2, 2, -2, -2)
	if image_small ~= nil then
		lbGem1:SetNormalImage(image_small)
	end
	lbGem1:SetUltraTextNormal(""..ltSmithInfo.smallHaveCnt)
	if ltSmithInfo.smallHaveCnt < ltSmithInfo.smallNeedCnt then
		lbGem1:SetMaskValue(1)
	end
	lbGemAmount1:SetText(string.format(LAN("msg_item_safesmith_need_cnt"), ltSmithInfo.smallNeedCnt))
-----------
	local image_big = SAPI.GetImage(ltSmithInfo.bigIcon, 2, 2, -2, -2)
	if image_big ~= nil then
		lbGem2:SetNormalImage(image_big)
	end
	lbGem2:SetUltraTextNormal(""..ltSmithInfo.bigHaveCnt)
	if ltSmithInfo.bigHaveCnt < ltSmithInfo.bigNeedCnt then
		lbGem2:SetMaskValue(1)
	end
	lbGemAmount2:SetText(string.format(LAN("msg_item_safesmith_need_cnt"), ltSmithInfo.bigNeedCnt))
-----------
	local image_full = SAPI.GetImage(ltSmithInfo.fullIcon, 2, 2, -2, -2)
	if image_full ~= nil then
		lbGem3:SetNormalImage(image_full)
	end
	lbGem3:SetUltraTextNormal(""..ltSmithInfo.fullHaveCnt)
	if ltSmithInfo.fullHaveCnt < ltSmithInfo.fullNeedCnt then
		lbGem3:SetMaskValue(1)
	end
	lbGemAmount3:SetText(string.format(LAN("msg_item_safesmith_need_cnt"), ltSmithInfo.fullNeedCnt))
----------

	edtMoney:SetRichText(ltSmithInfo.needMoneyStr, false)

	UI_SuperCreate_Can_Smith_cnt = ___UI___GetCanSmithCnt____(ltSmithInfo)
	
	lbResidueDegree:SetText(""..UI_SuperCreate_Can_Smith_cnt)

	if UI_SuperCreate_Can_Smith_cnt >= 1 then
		btOKCreate:Enable()
	end

	if btCreateItem:IsHovered() then
		layWorld_frmSuperCreate_btCreateItem_OnHint(btCreateItem)
	end
end

function ___UI___GetCanSmithCnt____(ltSmithInfo)
	if ltSmithInfo == nil then
		return 0
	end

	local cnt = math.floor(ltSmithInfo.smallHaveCnt/ltSmithInfo.smallNeedCnt)

	local temp = math.floor(ltSmithInfo.bigHaveCnt/ltSmithInfo.bigNeedCnt)

	if cnt > temp then
		cnt = temp
	end

	temp = math.floor(ltSmithInfo.fullHaveCnt/ltSmithInfo.fullNeedCnt)

	if cnt > temp then
		cnt = temp
	end

	temp = math.floor(ltSmithInfo.haveMoney/ltSmithInfo.needMoney)

	if cnt > temp then
		cnt = temp
	end

	return cnt
end

function layWorld_frmSuperCreate_btOKCreate_OnLClick()
	if UI_SuperCreate_Can_Smith_cnt == 0 then return end

	uiItemSafeSmithing_SureSafeSmith(UI_SuperCreate_Item_Object_Id)
end

function layWorld_frmSuperCreate_btCancelCreate_OnLClick()
	local self = uiGetglobal("layWorld.frmSuperCreate")
	self:Hide()
end

function layWorld_frmSuperCreate_btCreateItem_OnHint(self)
	self:SetHintRichText(0)
	if UI_SuperCreate_Item_Object_Id == nil or UI_SuperCreate_Item_Object_Id == 0 then
		return
	end

	local _,_,richtext = uiItemSmithing_GetItemInfo(UI_SuperCreate_Item_Object_Id)
	if richtext == nil then
		self:SetHintRichText(0)
	else
		self:SetHintRichText(richtext)
	end
end

function layWorld_frmSuperCreate_btCreateItem_OnDragIn(drag)
	local w = uiGetglobal(drag);
	if w == nil then
		return
	end

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

	if uiItemSafeSmithing_CheckSmith(itemOid) then
		if UI_SuperCreate_Item_Object_Id ~= nil and UI_SuperCreate_Item_Object_Id ~= 0 then
			LClass_ItemFreezeManager:Erase(UI_SuperCreate_Item_Object_Id) -- 解冻
		end

		UI_SuperCreate_Item_Object_Id = itemOid

		LClass_ItemFreezeManager:Push(UI_SuperCreate_Item_Object_Id) -- 冻结
		layWorld_frmSuperCreate_Refresh()
	end
end

function layWorld_frmSuperCreate_btCreateItem_OnDragNull(self)
	if UI_SuperCreate_Item_Object_Id ~= 0 then
		LClass_ItemFreezeManager:Erase(UI_SuperCreate_Item_Object_Id) -- 解冻
	end
	UI_SuperCreate_Item_Object_Id = 0
	layWorld_frmSuperCreate_Refresh()
end

function layWorld_frmSuperCreate_OnDragIn(drag)
	layWorld_frmSuperCreate_btCreateItem_OnDragIn(drag)
end

function layWorld_frmSuperCreate_OnHide()
	if UI_SuperCreate_Item_Object_Id ~= 0 then
		LClass_ItemFreezeManager:Erase(UI_SuperCreate_Item_Object_Id) -- 解冻
	end
	UI_SuperCreate_Item_Object_Id = 0
end

function layWorld_frmSuperCreate_OnEventItemUpDate(self, arg)
	layWorld_frmSuperCreate_Refresh()
	--local itemOid = uiItemUpdate_GetItemObjectIdByCoord(arg[2], arg[3], arg[4])
	--if itemOid == UI_SuperCreate_Item_Object_Id then
		
	--end
end
UI_ItemPoints_Item_Object_ID = 0

function layWorld_frmItemPointEx_OnHide(self)
	local btItemPoint = SAPI.GetChild(self, "btItemPoint")
	btItemPoint:SetNormalImage(0)
	UI_ItemPoints_Item_Object_ID = 0
	btItemPoint:SetUltraTextNormal("")
end

function layWorld_frmItemPointEx_btItemPoint_OnDragIn(self, drag)
	local w = uiGetglobal(drag);
	if w == nil then
		return
	end

	if w:Get(EV_UI_SHORTCUT_OWNER_KEY) ~= EV_UI_SHORTCUT_OWNER_ITEM then return end

	if w:Get(EV_UI_SHORTCUT_TYPE_KEY) ~= EV_SHORTCUT_OBJECT_ITEM then return end

	local itemOid = w:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	if itemOid == nil or itemOid == 0 then
		return
	end

	if not uiItemPoints_CheckItemPointsByItemObjectId(itemOid, true) then
		return
	end

	UI_ItemPoints_Item_Object_ID = itemOid

	local itemInsInfo = uiItemGetBagItemInfoByObjectId(itemOid)
	if itemInsInfo == nil then return end

	local itemClsInfo = uiItemGetItemClassInfoByTableIndex(itemInsInfo.TableId)
	if itemClsInfo == nil then return end

	local image_item = SAPI.GetImage(itemClsInfo.Icon)
	if image_item ~= nil then
		self:SetNormalImage(image_item)
	end

	if itemClsInfo.IsCountable then
		self:SetUltraTextNormal(""..itemInsInfo.Count)
	end
end

function layWorld_frmItemPointEx_btItemPoint_OnHint(self)

	self:SetHintRichText(0)
	if UI_ItemPoints_Item_Object_ID == 0 then return end

	local richText = uiItemGetBagItemHintByObjectId(UI_ItemPoints_Item_Object_ID)

	if richText == nil then return end

	self:SetHintRichText(richText)
end

function layWorld_frmItemPointEx_btOK_OnLClick()

	local self = uiGetglobal("layWorld.frmItemPointEx")

	local ckbShowPoint = SAPI.GetChild(self, "ckbShowPoint")
	local ckbShowName = SAPI.GetChild(self, "ckbShowName")
	local ckbHidePoint = SAPI.GetChild(self, "ckbHidePoint")

	uiItemPoints_DoItemPointsItemByObjectid(UI_ItemPoints_Item_Object_ID, ckbHidePoint:getChecked(), ckbShowName:getChecked(), ckbShowPoint:getChecked())

	self:Hide()
end

function layWorld_frmItemPointEx_btCancel_OnLClick()
	local self = uiGetglobal("layWorld.frmItemPointEx")
	self:Hide()
end
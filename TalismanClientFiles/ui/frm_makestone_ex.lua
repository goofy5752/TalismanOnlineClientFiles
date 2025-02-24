UI_ItemEnchant_Item_ObjectId = 0
UI_ItemEnchant_Accompany_ObjectId = 0
UI_ItemEnchant_Crystal_ObjectId = 0

function layWorld_frmMakeStoneEx_Refresh()
	local self = uiGetglobal("layWorld.frmMakeStoneEx")

	if not self:getVisible() then
		return
	end

	local lbMakeStoneTip = SAPI.GetChild(self, "lbMakeStoneTip")
	lbMakeStoneTip:SetText(uiLanString("MSG_ENCHANT_HINT"))

	local btStoneLeft = SAPI.GetChild(self, "btStoneLeft")
	btStoneLeft:SetNormalImage(0)
	btStoneLeft:ModifyFlag("DragOut", false)

	local btStoneCenter1 = SAPI.GetChild(self, "btStoneCenter1")
	btStoneCenter1:SetNormalImage(0)
	btStoneCenter1:ModifyFlag("DragOut", false)

	local btStoneRight = SAPI.GetChild(self, "btStoneRight")
	btStoneRight:SetNormalImage(0)
	btStoneRight:ModifyFlag("DragOut", false)
	
	if UI_ItemEnchant_Item_ObjectId ~= 0 then
		local _item = uiItemGetBagItemInfoByObjectId(UI_ItemEnchant_Item_ObjectId)
		if _item ~= nil then
			local itemClass = uiItemGetItemClassInfoByTableIndex(_item.TableId)
			if itemClass ~= nil then
				local image_item = SAPI.GetImage(itemClass.Icon, 2, 2, -2, -2)
				if image_item ~= nil then
					btStoneLeft:SetNormalImage(image_item)
					btStoneLeft:ModifyFlag("DragOut", true)
				end
			end
		end
	end

	if UI_ItemEnchant_Accompany_ObjectId ~= 0 then
		local _item = uiItemGetBagItemInfoByObjectId(UI_ItemEnchant_Accompany_ObjectId)
		if _item ~= nil then
			local itemClass = uiItemGetItemClassInfoByTableIndex(_item.TableId)
			if itemClass ~= nil then
				local image_item = SAPI.GetImage(itemClass.Icon, 2, 2, -2, -2)
				if image_item ~= nil then
					btStoneCenter1:SetNormalImage(image_item)
					btStoneCenter1:ModifyFlag("DragOut", true)
				end
			end
		end
	end

	if UI_ItemEnchant_Crystal_ObjectId ~= 0 then
		local _item = uiItemGetBagItemInfoByObjectId(UI_ItemEnchant_Crystal_ObjectId)
		if _item ~= nil then
			local itemClass = uiItemGetItemClassInfoByTableIndex(_item.TableId)
			if itemClass ~= nil then
				local image_item = SAPI.GetImage(itemClass.Icon, 2, 2, -2, -2)
				if image_item ~= nil then
					btStoneRight:SetNormalImage(image_item)
					btStoneRight:ModifyFlag("DragOut", true)
				end
			end
		end
	end

	if btStoneLeft:IsHovered() then
		layWorld_frmMakeStoneEx_btStoneLeft_OnHint(btStoneLeft)
	end

	if btStoneCenter1:IsHovered() then
		layWorld_frmMakeStoneEx_btStoneCenter1_OnHint(btStoneCenter1)
	end

	if btStoneRight:IsHovered() then
		layWorld_frmMakeStoneEx_btStoneRight_OnHint(btStoneRight)
	end

	local btStoneCenter2 = SAPI.GetChild(self, "btStoneCenter2")
	btStoneCenter2:SetNormalImage(0)
	
	if UI_ItemEnchant_Crystal_ObjectId ~= 0 and UI_ItemEnchant_Accompany_ObjectId ~= 0 and UI_ItemEnchant_Item_ObjectId ~= 0 then
		local _strImg = uiItemEnchant_GetEnchantResultItemInfo(UI_ItemEnchant_Item_ObjectId,UI_ItemEnchant_Accompany_ObjectId,UI_ItemEnchant_Crystal_ObjectId)
		if _strImg ~= nil then
			local image_item = SAPI.GetImage(_strImg, 2, 2, -2, -2)
			if image_item ~= nil then
				btStoneCenter2:SetNormalImage(image_item)
			end
		end
	end

	if btStoneCenter2:IsHovered() then
		layWorld_frmMakeStoneEx_btStoneCenter2_OnHint(btStoneCenter2)
	end

end

function layWorld_frmMakeStoneEx_btStoneRight_OnHint(self)
	self:SetHintRichText(0)
	local richtext1 = uiSkill_StringToRichText(uiLanString("MSG_ENCHANT_ITEM3"), uiLanString("font_title"), tonumber(uiLanString("font_s_18")), 4294967295)
	if richtext1 ~= nil then
		self:SetHintRichText(richtext1)
	end
	if UI_ItemEnchant_Crystal_ObjectId ~= 0 then
		local richText = uiItemGetBagItemHintByObjectId(UI_ItemEnchant_Crystal_ObjectId)
		if richText ~= nil then
			self:SetHintRichText(richText)
		end
	end
end

function layWorld_frmMakeStoneEx_btStoneLeft_OnHint(self)
	self:SetHintRichText(0)
	local richtext1 = uiSkill_StringToRichText(uiLanString("MSG_ENCHANT_ITEM1"), uiLanString("font_title"), tonumber(uiLanString("font_s_18")), 4294967295)
	if richtext1 ~= nil then
		self:SetHintRichText(richtext1)
	end
	if UI_ItemEnchant_Item_ObjectId ~= 0 then
		local richText = uiItemGetBagItemHintByObjectId(UI_ItemEnchant_Item_ObjectId)
		if richText ~= nil then
			self:SetHintRichText(richText)
		end
	end
end

function layWorld_frmMakeStoneEx_btStoneCenter1_OnHint(self)
	self:SetHintRichText(0)
	local richtext1 = uiSkill_StringToRichText(uiLanString("MSG_ENCHANT_ITEM2"), uiLanString("font_title"), tonumber(uiLanString("font_s_18")), 4294967295)
	if richtext1 ~= nil then
		self:SetHintRichText(richtext1)
	end
	if UI_ItemEnchant_Accompany_ObjectId ~= 0 then
		local richText = uiItemGetBagItemHintByObjectId(UI_ItemEnchant_Accompany_ObjectId)
		if richText ~= nil then
			self:SetHintRichText(richText)
		end
	end
end

function layWorld_frmMakeStoneEx_btStoneCenter2_OnHint(self)
	self:SetHintRichText(0)
	if UI_ItemEnchant_Crystal_ObjectId ~= 0 and UI_ItemEnchant_Accompany_ObjectId ~= 0 and UI_ItemEnchant_Item_ObjectId ~= 0 then
		local _,richText = uiItemEnchant_GetEnchantResultItemInfo(UI_ItemEnchant_Item_ObjectId,UI_ItemEnchant_Accompany_ObjectId,UI_ItemEnchant_Crystal_ObjectId)
		if richText ~= nil then
			self:SetHintRichText(richText)
		end
	end
end

function layWorld_frmMakeStoneEx_btOK_OnLClick()
	uiItemEnchant_EnchantTheItem(UI_ItemEnchant_Item_ObjectId,UI_ItemEnchant_Accompany_ObjectId,UI_ItemEnchant_Crystal_ObjectId)
end

function layWorld_frmMakeStoneEx_btCancel_OnLClick()
	local self = uiGetglobal("layWorld.frmMakeStoneEx")
	self:Hide()
end

function layWorld_frmMakeStoneEx_btStoneLeft_OnDragIn(drag)
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

	if not uiItemEnchant_CheckEnchantItem(itemOid, true) then
		return
	end
	UI_ItemEnchant_Item_ObjectId = itemOid
	layWorld_frmMakeStoneEx_Refresh()
end

function layWorld_frmMakeStoneEx_btStoneLeft_OnDragNull(self)
	UI_ItemEnchant_Item_ObjectId = 0
	layWorld_frmMakeStoneEx_Refresh()
end

function layWorld_frmMakeStoneEx_btStoneCenter1_OnDragIn(drag)
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

	if not uiItemEnchant_CheckAccompanyItem(itemOid) then
		return
	end
	UI_ItemEnchant_Accompany_ObjectId = itemOid
	layWorld_frmMakeStoneEx_Refresh()
end

function layWorld_frmMakeStoneEx_btStoneCenter1_OnDragNull(self)
	UI_ItemEnchant_Accompany_ObjectId = 0
	layWorld_frmMakeStoneEx_Refresh()
end

function layWorld_frmMakeStoneEx_btStoneRight_OnDragIn(drag)
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

	if not uiItemEnchant_CheckCrystalItem(itemOid) then
		return
	end
	UI_ItemEnchant_Crystal_ObjectId = itemOid
	layWorld_frmMakeStoneEx_Refresh()
end

function layWorld_frmMakeStoneEx_btStoneRight_OnDragNull(self)
	UI_ItemEnchant_Crystal_ObjectId = 0
	layWorld_frmMakeStoneEx_Refresh()
end

function layWorld_frmMakeStoneEx_OnDragIn(drag)
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

	
	if uiItemEnchant_CheckAccompanyItem(itemOid) then
		layWorld_frmMakeStoneEx_btStoneCenter1_OnDragIn(drag)
	elseif uiItemEnchant_CheckCrystalItem(itemOid) then
		layWorld_frmMakeStoneEx_btStoneRight_OnDragIn(drag)
	elseif uiItemEnchant_CheckEnchantItem(itemOid, true) then
		layWorld_frmMakeStoneEx_btStoneLeft_OnDragIn(drag)
	end
end


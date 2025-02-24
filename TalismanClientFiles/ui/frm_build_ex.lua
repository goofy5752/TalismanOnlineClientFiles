local UI_Build_Item_Left_Object_Id = 0
local UI_Build_Item_Right_Object_Id = 0


function layWorld_frmBuildEx_Refresh()
	local self = uiGetglobal("layWorld.frmBuildEx")

	if not self:getVisible() then
		return
	end
	
	local btBuildLeft = SAPI.GetChild(self, "btBuildLeft")
	local btBuildRight = SAPI.GetChild(self, "btBuildRight")
	local lbBuildTip = SAPI.GetChild(self, "lbBuildTip")

	btBuildLeft:SetNormalImage(0)
	btBuildLeft:ModifyFlag("DragOut", false)
	btBuildRight:SetNormalImage(0)
	btBuildRight:ModifyFlag("DragOut", false)
	lbBuildTip:SetText(uiLanString("MSG_FUSE_ERROR1"))


	if UI_Build_Item_Left_Object_Id == nil or UI_Build_Item_Left_Object_Id == 0 then
	else
		local imgstr = uiItemIdentify_GetItemInfo(UI_Build_Item_Left_Object_Id)
		if imgstr ~= nil then
			local image_item = SAPI.GetImage(imgstr, 2, 2, -2, -2)
			if image_item ~= nil then
				btBuildLeft:SetNormalImage(image_item)
				btBuildLeft:ModifyFlag("DragOut", true)
			end
		else
			UI_Build_Item_Left_Object_Id = 0
		end
	end

	if UI_Build_Item_Right_Object_Id == nil or UI_Build_Item_Right_Object_Id == 0 then
	else
		local imgstr = uiItemIdentify_GetItemInfo(UI_Build_Item_Right_Object_Id)
		if imgstr ~= nil then
			local image_item = SAPI.GetImage(imgstr, 2, 2, -2, -2)
			if image_item ~= nil then
				btBuildRight:SetNormalImage(image_item)
				btBuildRight:ModifyFlag("DragOut", true)
			end
		else
			UI_Build_Item_Right_Object_Id = 0
		end
	end

	
	if btBuildLeft:IsHovered() then
		layWorld_frmBuildEx_btBuildLeft_OnHint(btBuildLeft)
	end

	if btBuildRight:IsHovered() then
		layWorld_frmBuildEx_btBuildRight_OnHint(btBuildRight)
	end

end

function layWorld_frmBuildEx_Show(self)
	self:ShowAndFocus()
	self:MoveTo(150, 200)
	UI_Build_Item_Left_Object_Id = 0
	UI_Build_Item_Right_Object_Id = 0
	layWorld_frmBuildEx_Refresh()
end

function layWorld_frmBuildEx_btBuildLeft_OnHint(self)
	if UI_Build_Item_Left_Object_Id == nil or UI_Build_Item_Left_Object_Id == 0 then
		self:SetHintRichText(0)
		return
	end

	local _, _,richtext = uiItemIdentify_GetItemInfo(UI_Build_Item_Left_Object_Id)
	if richtext == nil then
		self:SetHintRichText(0)
	else
		self:SetHintRichText(richtext)
	end
end

function layWorld_frmBuildEx_btBuildRight_OnHint(self)
	if UI_Build_Item_Right_Object_Id == nil or UI_Build_Item_Right_Object_Id == 0 then
		self:SetHintRichText(0)
		return
	end

	local _, _,richtext = uiItemIdentify_GetItemInfo(UI_Build_Item_Right_Object_Id)
	if richtext == nil then
		self:SetHintRichText(0)
	else
		self:SetHintRichText(richtext)
	end
end

function layWorld_frmBuildEx_btBuildLeft_OnDragIn(drag)

	local w = uiGetglobal(drag);
	if w == nil then
		return
	end
	--local itemOid = uiItemIdentify_GetItemObjectIdByWidget(w)

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

	if uiItemIdentify_CheckItemToIdentify(itemOid) then
		UI_Build_Item_Left_Object_Id = itemOid
		layWorld_frmBuildEx_Refresh()
	end
end

function layWorld_frmBuildEx_btBuildRight_OnDragIn(drag)

	local w = uiGetglobal(drag);
	if w == nil then
		return
	end
	--local itemOid = uiItemIdentify_GetItemObjectIdByWidget(w)

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

	local info = uiItemGetBagItemInfoByObjectId(itemOid)
	if info == nil then
		return
	end

	if info.Type >= EV_ITEM_TYPE_GEM_GREEN_1 and info.Type <= EV_ITEM_TYPE_GEM_WHITE_PLUS then

		UI_Build_Item_Right_Object_Id = itemOid
		layWorld_frmBuildEx_Refresh()
	else
		uiClientMsg(LAN("MSG_UPDATE_ERROR2"), true)
	end
end

function layWorld_frmBuildEx_btBuildLeft_OnDragNull(self)
	UI_Build_Item_Left_Object_Id = 0
	layWorld_frmBuildEx_Refresh()
end

function layWorld_frmBuildEx_btBuildRight_OnDragNull(self)
	UI_Build_Item_Right_Object_Id = 0
	layWorld_frmBuildEx_Refresh()
end

function layWorld_frmBuildEx_OnDragIn(drag)

	local w = uiGetglobal(drag);
	if w == nil then
		return
	end
	--local itemOid = uiItemIdentify_GetItemObjectIdByWidget(w)

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
	
	local _, isIdentifyItem = uiItemIdentify_GetItemInfo(itemOid)

	if isIdentifyItem == nil then
		return
	end

	if isIdentifyItem then
		layWorld_frmBuildEx_btBuildRight_OnDragIn(drag)
	else
		layWorld_frmBuildEx_btBuildLeft_OnDragIn(drag)
	end
end

function layWorld_frmBuildEx_btOK_OnLClick()
	uiItemIdentify_ItemSureIdentify(UI_Build_Item_Left_Object_Id, UI_Build_Item_Right_Object_Id)
end

function layWorld_frmBuildEx_btCancel_OnLClick()
	local self = uiGetglobal("layWorld.frmBuildEx")
	self:Hide()
end

function layWorld_frmBuildEx_OnEventItemUpDate(self, arg)
	local itemOid = uiItemUpdate_GetItemObjectIdByCoord(arg[2], arg[3], arg[4])
	if itemOid == UI_Build_Item_Left_Object_Id or itemOid == UI_Build_Item_Right_Object_Id then
		layWorld_frmBuildEx_Refresh()
	end
end

function layWorld_frmBuildEx__Result(arg)
	layWorld_frmBuildEx_Refresh()
	uiItemIdentify_ItemIdentify_Resultmsg(arg[1])
end
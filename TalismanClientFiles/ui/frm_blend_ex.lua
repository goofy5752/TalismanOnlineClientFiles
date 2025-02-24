local UI_Blend_Item_Left_Object_Id = 0
local UI_Blend_Item_Right_Object_Id = 0

function layWorld_frmBlendEx_Refresh()
	local self = uiGetglobal("layWorld.frmBlendEx")

	if not self:getVisible() then
		return
	end

	local btPracticePic = SAPI.GetChild(self, "btPracticePic")
	local btPracticeLeft = SAPI.GetChild(self, "btPracticeLeft")
	local btPracticeRight = SAPI.GetChild(self, "btPracticeRight")
	local lbPracticeTip = SAPI.GetChild(self, "lbPracticeTip")
	lbPracticeTip:SetText(uiLanString("MSG_ITEM_UPDATE_HINT"))

	btPracticeLeft:SetNormalImage(0)
	btPracticeLeft:ModifyFlag("DragOut", false)
	btPracticeRight:SetNormalImage(0)
	btPracticeRight:ModifyFlag("DragOut", false)
	btPracticePic:SetNormalImage(0)

	if UI_Blend_Item_Left_Object_Id == nil or UI_Blend_Item_Left_Object_Id == 0 then
	else
		local imgstr = uiItemFuse_GetItemInfo(UI_Blend_Item_Left_Object_Id)
		if imgstr ~= nil then
			local image_item = SAPI.GetImage(imgstr, 2, 2, -2, -2)
			if image_item ~= nil then
				btPracticeLeft:SetNormalImage(image_item)
				btPracticeLeft:ModifyFlag("DragOut", true)
			end
		end
	end
	
	if UI_Blend_Item_Right_Object_Id == nil or UI_Blend_Item_Right_Object_Id == 0 then
	else
		local imgstr = uiItemFuse_GetItemInfo(UI_Blend_Item_Right_Object_Id)
		if imgstr ~= nil then
			local image_item = SAPI.GetImage(imgstr, 2, 2, -2, -2)
			if image_item ~= nil then
				btPracticeRight:SetNormalImage(image_item)
				btPracticeRight:ModifyFlag("DragOut", true)
			end
		end
	end

	layWorld_frmBlendEx_Refresh_ResultItem(btPracticePic)

	if btPracticePic:IsHovered() then
		layWorld_frmBlendEx_btPracticePic_OnHint(btPracticePic)
	end

	if btPracticeLeft:IsHovered() then
		layWorld_frmBlendEx_btPracticeLeft_OnHint(btPracticeLeft)
	end

	if btPracticeRight:IsHovered() then
		layWorld_frmBlendEx_btPracticeRight_OnHint(btPracticeRight)
	end

end

function layWorld_frmBlendEx_Refresh_ResultItem(btPracticePic)
	if UI_Blend_Item_Left_Object_Id == nil or UI_Blend_Item_Left_Object_Id == 0 or UI_Blend_Item_Right_Object_Id == nil or UI_Blend_Item_Right_Object_Id == 0 then
		return
	end
	local imgstr = uiItemFuse_GetResultItemInfo(UI_Blend_Item_Left_Object_Id, UI_Blend_Item_Right_Object_Id)
	if imgstr ~= nil then
		local image_item = SAPI.GetImage(imgstr, 2, 2, -2, -2)
		if image_item ~= nil then
			btPracticePic:SetNormalImage(image_item)
		end
	end
end

function layWorld_frmBlendEx_Show(self)
	self:MoveTo(150, 200)
	self:ShowAndFocus()
	layWorld_frmBlendEx_Refresh()
end

function layWorld_frmBlendEx_btPracticePic_OnHint(self)
	if UI_Blend_Item_Left_Object_Id == nil or UI_Blend_Item_Left_Object_Id == 0 or UI_Blend_Item_Right_Object_Id == nil or UI_Blend_Item_Right_Object_Id == 0 then
		self:SetHintRichText(0)
		return
	end
	local _, richtext = uiItemFuse_GetResultItemInfo(UI_Blend_Item_Left_Object_Id, UI_Blend_Item_Right_Object_Id)
	if richtext == nil then
		self:SetHintRichText(0)
	else
		self:SetHintRichText(richtext)
	end

end

function layWorld_frmBlendEx_btPracticeLeft_OnHint(self)
	if UI_Blend_Item_Left_Object_Id == nil or UI_Blend_Item_Left_Object_Id == 0 then
		self:SetHintRichText(0)
		return
	end

	local _, richtext = uiItemFuse_GetItemInfo(UI_Blend_Item_Left_Object_Id)
	if richtext == nil then
		self:SetHintRichText(0)
	else
		self:SetHintRichText(richtext)
	end
end

function layWorld_frmBlendEx_btPracticeRight_OnHint(self)
	if UI_Blend_Item_Right_Object_Id == nil or UI_Blend_Item_Right_Object_Id == 0 then
		self:SetHintRichText(0)
		return
	end

	local _, richtext = uiItemFuse_GetItemInfo(UI_Blend_Item_Right_Object_Id)
	if richtext == nil then
		self:SetHintRichText(0)
	else
		self:SetHintRichText(richtext)
	end
end

function layWorld_frmBlendEx_OnDragIn(drag)

	if UI_Blend_Item_Left_Object_Id == nil or UI_Blend_Item_Left_Object_Id == 0 or UI_Blend_Item_Right_Object_Id == nil or UI_Blend_Item_Right_Object_Id == 0 then
	else
		return
	end

	if UI_Blend_Item_Left_Object_Id == nil or UI_Blend_Item_Left_Object_Id == 0 then
		layWorld_frmBlendEx_btPracticeLeft_OnDragIn(drag)
	elseif UI_Blend_Item_Right_Object_Id == nil or UI_Blend_Item_Right_Object_Id == 0 then
		layWorld_frmBlendEx_btPracticeRight_OnDragIn(drag)
	end

end

function layWorld_frmBlendEx_btPracticeLeft_OnDragIn(drag)
	
	local w = uiGetglobal(drag);
	if w == nil then
		return
	end
	--local itemOid = uiItemFuse_GetItemObjectIdByWidget(w)

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

	if uiItemFuse_Check_Item_IsTrump(itemOid) == false then
		return
	end
	
	UI_Blend_Item_Left_Object_Id = itemOid
	
	layWorld_frmBlendEx_Refresh()
end

function layWorld_frmBlendEx_btPracticeRight_OnDragIn(drag)

	local w = uiGetglobal(drag);
	if w == nil then
		return
	end

	if w:Get(EV_UI_SHORTCUT_OWNER_KEY) == EV_UI_SHORTCUT_OWNER_EQUIP then
		uiClientMsg(LAN("MSG_UPDATE_ERROR1"), true)
		return
	end

	--local itemOid = uiItemFuse_GetItemObjectIdByWidget(w)
	if w:Get(EV_UI_SHORTCUT_OWNER_KEY) ~= EV_UI_SHORTCUT_OWNER_ITEM or w:Get(EV_UI_SHORTCUT_TYPE_KEY) ~= EV_SHORTCUT_OBJECT_ITEM then
		return
	end

	local itemOid = w:Get(EV_UI_SHORTCUT_OBJECTID_KEY)

	if itemOid == nil or itemOid == 0 then
		return
	end

	if uiItemFuse_Check_Item_IsTrump(itemOid) == false then
		return
	end

	UI_Blend_Item_Right_Object_Id = itemOid
	
	layWorld_frmBlendEx_Refresh()
end

function layWorld_frmBlendEx_btPracticeLeft_OnDragNull(self)
	UI_Blend_Item_Left_Object_Id = 0
	layWorld_frmBlendEx_Refresh()
end

function layWorld_frmBlendEx_btPracticeRight_OnDragNull(self)
	UI_Blend_Item_Right_Object_Id = 0
	layWorld_frmBlendEx_Refresh()
end

function layWorld_frmBlendEx_OnEventItemUpDate(self, arg)
	local itemOid = uiItemUpdate_GetItemObjectIdByCoord(arg[2], arg[3], arg[4])
	if itemOid == UI_Blend_Item_Right_Object_Id or itemOid == UI_Blend_Item_Left_Object_Id then
		layWorld_frmPracticeEx_Refresh()
	end
end

function layWorld_frmBlendEx_btOK_OnLClick()

	if not uiItemFuse_Check_Item_Fuse(UI_Blend_Item_Left_Object_Id, UI_Blend_Item_Right_Object_Id) then
		return 
	end
	
	local TrumpNimbusLock = uiGetConfigureEntry("game","TrumpNimbusLock")

	if TrumpNimbusLock == "true" then

		local bindType = uiItemUpdate_GetItemBindType(UI_Blend_Item_Right_Object_Id)

		if bindType == -1 then
			return
		end

		if bindType ~= EV_ITEM_BINDTYPE_BINDED then
			
			local msgbox = uiMessageBox(uiLanString("MSG_ITEM_FUSE_CONFIRM"), "", true, true, true);
			SAPI.AddDefaultMessageBoxCallBack(msgbox,layWorld_frmBlendEx_btOK_OnMsgOk)
		else
			uiItemFuse_Item_Fuse(UI_Blend_Item_Left_Object_Id, UI_Blend_Item_Right_Object_Id)
		end

	else
		uiItemFuse_Item_Fuse(UI_Blend_Item_Left_Object_Id, UI_Blend_Item_Right_Object_Id)
	end
end

function layWorld_frmBlendEx_btOK_OnMsgOk()
	uiItemFuse_Item_Fuse(UI_Blend_Item_Left_Object_Id, UI_Blend_Item_Right_Object_Id)
end

function layWorld_frmBlendEx_btCancel_OnLClick()
	local self = uiGetglobal("layWorld.frmBlendEx")
	self:Hide()
end

function layWorld_frmBlendEx_Fuse_Result(arg)
	UI_Blend_Item_Left_Object_Id = 0
	UI_Blend_Item_Right_Object_Id = 0
	layWorld_frmBlendEx_Refresh()
	uiItemFuse_Item_Fuse_ResultMsg(arg[1])
end
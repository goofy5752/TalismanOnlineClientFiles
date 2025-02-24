local UI_Practice_Item_Object_Id = 0
local UI_Practice_Running = false

function layWorld_frmPracticeEx_Refresh()
	local self = uiGetglobal("layWorld.frmPracticeEx")

	if not self:getVisible() then
		return
	end

	local btItemPic = SAPI.GetChild(self, "btItemPic")
	local lbItemName = SAPI.GetChild(self, "lbItemName")
	local prgItem = SAPI.GetChild(self, "prgItem")
	local lbItemNumber = SAPI.GetChild(prgItem, "lbItemNumber")
	local prgMan = SAPI.GetChild(self, "prgMan")
	local lbManNumber = SAPI.GetChild(prgMan, "lbManNumber")

	local btOK = SAPI.GetChild(self, "btOK")
	local btCancel = SAPI.GetChild(self, "btCancel")

	btItemPic:SetNormalImage(0)
	btItemPic:ModifyFlag("DragOut", false)
	lbItemName:SetText("")
	prgItem:SetValue(0)
	lbItemNumber:SetText("0/0")

	local curNp,maxNp = uiGetMyInfo("Np")
	prgMan:SetValue(curNp/maxNp)
	lbManNumber:SetText(curNp.."/"..maxNp)

	if UI_Practice_Running then
		btOK:Disable()
		btCancel:Enable()
	else
		btOK:Enable()
		btCancel:Disable()
	end

	if UI_Practice_Item_Object_Id == nil or UI_Practice_Item_Object_Id == 0 then
		return
	end

	local item_name, item_icon, item_lev, item_Nimbus, item_MaxNimbus = uiItemUpdate_GetItemInfo(UI_Practice_Item_Object_Id)

	if item_name == nil or item_icon == nil or item_lev == nil or item_Nimbus == nil or item_MaxNimbus == nil then
		return
	end

	local image_item = SAPI.GetImage(item_icon, 2, 2, -2, -2)
	if image_item == nil then
		return
	end
	btItemPic:SetNormalImage(image_item)
	btItemPic:ModifyFlag("DragOut", true)
	lbItemName:SetText(item_name.."("..uiLanString("msg_level")..item_lev..")")
	prgItem:SetValue(item_Nimbus/item_MaxNimbus)
	lbItemNumber:SetText(item_Nimbus.."/"..item_MaxNimbus)

	if UI_Practice_Running then
		btItemPic:ModifyFlag("DragOut", false)
	end

	if btItemPic:IsHovered() then
		layWorld_frmPracticeEx_btItemPic_OnHint(btItemPic)
	end
end

function layWorld_frmPracticeEx_OnDragIn(drag)
	if UI_Practice_Running then
		return
	end
	
	local w = uiGetglobal(drag);
	if w == nil then
		return
	end
	--local itemOid = uiItemUpdate_GetItemObjectIdByWidget(w)
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

	if uiItemUpdate_CheckUpdateWeaponItem(itemOid) == false then
		return
	end

	UI_Practice_Item_Object_Id = itemOid

	layWorld_frmPracticeEx_Refresh()
end

function layWorld_frmPracticeEx_btItemPic_OnHint(self)

	if UI_Practice_Item_Object_Id == nil or UI_Practice_Item_Object_Id == 0 then
		self:SetHintRichText(0)
		return
	end

	local _,_,_,_,_,richText   = uiItemUpdate_GetItemInfo(UI_Practice_Item_Object_Id)
	if richText == nil then
		self:SetHintRichText(0)
	else
		self:SetHintRichText(richText)
	end
end

function layWorld_frmPracticeEx_btItemPic_OnDragNull(self)
	if UI_Practice_Running then
		return
	end
	UI_Practice_Item_Object_Id = 0
	layWorld_frmPracticeEx_Refresh()
end

function layWorld_frmPracticeEx_btOK_OnLClick()
	local TrumpNimbusLock = uiGetConfigureEntry("game","TrumpNimbusLock")

	if TrumpNimbusLock == "true" then

		local bindType = uiItemUpdate_GetItemBindType(UI_Practice_Item_Object_Id)

		if bindType == -1 then
			return
		end

		if bindType ~= EV_ITEM_BINDTYPE_BINDED then
			
			local msgbox = uiMessageBox(uiLanString("MSG_ITEM_UPDATE_CONFIRM"), "", true, true, true);
			SAPI.AddDefaultMessageBoxCallBack(msgbox, layWorld_frmPracticeEx_btOK_OnMsgOk)
		else
			uiItemUpdate_ItemUpdateStart(UI_Practice_Item_Object_Id)
		end

	else
		uiItemUpdate_ItemUpdateStart(UI_Practice_Item_Object_Id)
	end
end

function layWorld_frmPracticeEx_btOK_OnMsgOk(event)
	if event == "Ok" then
		uiItemUpdate_ItemUpdateStart(UI_Practice_Item_Object_Id)
	end
end

function layWorld_frmPracticeEx_btCancel_OnLClick()
	uiItemUpdate_ItemUpdateStop(UI_Practice_Item_Object_Id)
end

function layWorld_frmPracticeEx_OnHide()
	uiItemUpdate_ItemUpdateStop(UI_Practice_Item_Object_Id)
end

function layWorld_frmPracticeEx_OnEvent(self, event, arg)
	if event == "Practice" then
		if (arg[1] ~= EV_EXCUTE_EVENT_KEY_DOWN) and (arg[1] ~= EV_EXCUTE_EVENT_ON_LCLICK) then
			return
		end
		if self:getVisible() then
		
			self:Hide()
		else
			self:ShowAndFocus()
			self:MoveTo(150, 200)
		end
	elseif event == "CEV_ITEM_UPTATE_WEAPON_BEGIN" then
		UI_Practice_Running = true
		layWorld_frmPracticeEx_Refresh()
	elseif event == "CEV_ITEM_UPTATE_WEAPON_END" then
		UI_Practice_Running = false
		layWorld_frmPracticeEx_Refresh()
	elseif event == "bag_item_update" then
		local itemOid = uiItemUpdate_GetItemObjectIdByCoord(arg[2], arg[3], arg[4])
		if itemOid == UI_Practice_Item_Object_Id then
			layWorld_frmPracticeEx_Refresh()
		end
	elseif event == "bag_item_removed" then
		layWorld_frmPracticeEx_Refresh()
	elseif event ==  "Cre ShowAttrib Changed" then
		layWorld_frmPracticeEx_Refresh()
	end
end
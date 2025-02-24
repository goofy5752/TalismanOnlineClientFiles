local UI_Bank_Ware_Bag_Current_Open = 0

local UI_BANKBAG_ALLOWED_MAX_GRID_COUNT = 12

local UI_BANKBAG_ALLOWED_MAX_BAG_COUNT = 12

--[[
function layWorld_frmWarebagEx_Restructuring()
	local self = uiGetglobal("layWorld.frmWarebagEx")
	for i=1, UI_BANKBAG_ALLOWED_MAX_GRID_COUNT, 1 do 
		local BtWbag = SAPI.GetChild(self, "BtWbag"..i)
		BtWbag:Hide()
	end

	local info = uiBank_GetBankSystemInfo()
	local slot = info.BankSlot.UltraBank

	for i=1, slot.Line, 1 do
		for j=1, slot.Col, 1 do
			local BtWbag = SAPI.GetChild(self, "BtWbag"..((i - 1)*slot.Col + j))
			BtWbag:Show()
			local left = slot.Left + slot.OffsetLeft + (j-1)*slot.Width
			local top = slot.Top + slot.OffsetTop + (i-1)*slot.Height
			local width = slot.OffsetRight - slot.OffsetLeft + 1
			local height = slot.OffsetRight - slot.OffsetLeft + 1
			BtWbag:MoveSize(left, top, width, height)
		end
	end
end
]]

function layWorld_frmWarebagEx_BtWbag_OnLoad(self)
	self:Set(EV_UI_SHORTCUT_OWNER_KEY, EV_UI_SHORTCUT_OWNER_BANK);
end

function layWorld_frmWarebagEx_Item_Refresh(id, line, col)
	local bOutOfDate = false;
	local bagEndTime = uiBank_GetUltraBagEndTime(id);
	if bagEndTime ~= 0 then
		if uiGetServerTime() >= bagEndTime then
			bOutOfDate = true;
		end
	end
	local _, MaxLine, MaxCol = uiBank_GetUltraBagMaxCountLineCol();
	local bag = uiGetglobal("layWorld.frmWarebagEx.wtWbag"..id);
	local self = SAPI.GetChild(bag, "BtWbag"..((line - 1)*MaxCol + col))
	self:Delete(EV_UI_SHORTCUT_TYPE_KEY)
	self:Delete(EV_UI_SHORTCUT_OBJECTID_KEY)
	local imgstr, itemCount, itemOid = uiBank_GetBankUltraItemInfoByLineCol(id, line, col)
	if imgstr ~= nil then
		local image_item = SAPI.GetImage(imgstr, 2, 2, -2, -2)
		if image_item ~= nil then
			self:SetNormalImage(image_item)
			if bOutOfDate then
				self:ModifyFlag("DragOut", false)
			else
				self:ModifyFlag("DragOut", true)
			end
			
			self:Set(EV_UI_SHORTCUT_TYPE_KEY, EV_SHORTCUT_OBJECT_ITEM)
			self:Set(EV_UI_SHORTCUT_OBJECTID_KEY, itemOid)
			if itemCount == -1 or itemCount == nil then
				self:SetUltraTextNormal("")
			else
				self:SetUltraTextNormal(""..itemCount)
			end
		else
			self:SetNormalImage(0)
			self:ModifyFlag("DragOut", false)
			self:SetUltraTextNormal("")
		end
	else
		self:SetNormalImage(0)
		self:ModifyFlag("DragOut", false)
		self:SetUltraTextNormal("")
	end

	if bOutOfDate then
		self:ModifyFlag("DragIn", false)
	else
		self:ModifyFlag("DragIn", true)
	end
end

function layWorld_frmWarebagEx_Refresh(id)
	if id == nil or id == 0 then
		for i = 1, UI_BANKBAG_ALLOWED_MAX_BAG_COUNT, 1 do
			layWorld_frmWarebagEx_Refresh(i);
		end
		return;
	end
	
	local self = uiGetglobal("layWorld.frmWarebagEx.wtWbag"..id)
	
	if id > uiBank_GetUltraBagCount() then
		SAPI.GetChild(self, "lbLock"):Show();
		return;
	else
		SAPI.GetChild(self, "lbLock"):Hide();
	end

	local bagEndTime = uiBank_GetUltraBagEndTime(id)

	local lbTimeLimit = SAPI.GetChild(self, "lbTimeLimit")

	local bOutOfDate = false

	if bagEndTime == 0 then
		lbTimeLimit:Hide();
	else
		if uiGetServerTime() >= bagEndTime then
			lbTimeLimit:SetTextColorEx(17,17,224,255)
			bOutOfDate = true
		else
			lbTimeLimit:SetTextColorEx(224,224,224,255)
		end
		local _year,_month,_day,_hour,_min = uiBank_TimeGetDate(bagEndTime)
		lbTimeLimit:SetText(string.format(uiLanString("msg_leasingtime"), _year,_month,_day,_hour,_min))
		lbTimeLimit:Show();
	end
	
	local _, line, col = uiBank_GetUltraBagMaxCountLineCol()

	for i=1, line, 1 do
		for j=1, col, 1 do
			layWorld_frmWarebagEx_Item_Refresh(id, i, j);
		end
	end
end

function layWorld_frmWarebagEx_Show(number)
	UI_Bank_Ware_Bag_Current_Open = number
	local self = uiGetglobal("layWorld.frmWarebagEx")
	self:ShowAndFocus()
	layWorld_frmWarebagEx_Refresh()
end

function layWorld_frmWarebagEx_Hide()
	local frmWarebagEx = uiGetglobal("layWorld.frmWarebagEx")
	frmWarebagEx:Hide()
end

function layWorld_frmWarebagEx_BtWbag_OnHint(self)
	local _;
	local hinttext = 0;
	for i = 1, 1, 1 do
		if self:Get(EV_UI_SHORTCUT_TYPE_KEY) ~= EV_SHORTCUT_OBJECT_ITEM then
			break;
		end
		if self:Get(EV_UI_SHORTCUT_OWNER_KEY) ~= EV_UI_SHORTCUT_OWNER_BANK then
			break;
		end
		local itemOid = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
		if itemOid == nil then
			break;
		end
		
		local line, col = self:Get("line"), self:Get("column");
		local bagid = SAPI.GetParent(self):Get("ID");
		
		_, _, _, hinttext = uiBank_GetBankUltraItemInfoByLineCol(bagid, line, col)
	end
	self:SetHintRichText(hinttext);
end

function layWorld_frmWarebagEx_BtWbag_OnRClick(self)
	if self:Get(EV_UI_SHORTCUT_TYPE_KEY) ~= EV_SHORTCUT_OBJECT_ITEM then
		return
	end

	if self:Get(EV_UI_SHORTCUT_OWNER_KEY) ~= EV_UI_SHORTCUT_OWNER_BANK then
		return
	end

	local itemOid = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	if itemOid == nil then
		return
	end

	if UI_Bank_Npc_Object_Id == 0 or UI_Bank_Npc_Object_Id == nil then
		return
	end

	uiBank_TakeOutBankItem(itemOid, UI_Bank_Npc_Object_Id)
end

function layWorld_frmWarebagEx_BtWbag_OnDragIn(self, drag)
	if UI_Bank_Npc_Object_Id == 0 or UI_Bank_Npc_Object_Id == nil then
		return
	end
	
	local wDrag = uiGetglobal(drag)
	if wDrag:Get(EV_UI_SHORTCUT_OWNER_KEY) ~= EV_UI_SHORTCUT_OWNER_BANK and wDrag:Get(EV_UI_SHORTCUT_OWNER_KEY) ~= EV_UI_SHORTCUT_OWNER_ITEM then
		return
	end
	if wDrag:Get(EV_UI_SHORTCUT_TYPE_KEY) ~= EV_SHORTCUT_OBJECT_ITEM then
		return
	end
	local itemOid = wDrag:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	if itemOid == nil then
		return
	end
	if self:Get(EV_UI_SHORTCUT_OWNER_KEY) ~= EV_UI_SHORTCUT_OWNER_BANK then
		return;
	end
	
	local line, col = self:Get("line"), self:Get("column");
	local bagid = SAPI.GetParent(self):Get("ID");
	
	uiBank_ItemPutInUltraBank(itemOid, bagid, line, col, UI_Bank_Npc_Object_Id);
end

function layWorld_frmWarebagEx_OnShow(self)
	uiRegisterEscWidget(self);
	local frmWarehouseEx = uiGetglobal("layWorld.frmWarehouseEx")

	for i = 1, UI_BANKBAG_ALLOWED_MAX_BAG_COUNT, 1 do
		local BtBag = SAPI.GetChild(frmWarehouseEx, "BtBag"..i)
		print(BtBag:getName())
		BtBag:SetChecked(true)
	end
end

function layWorld_frmWarebagEx_OnHide()
	local frmWarehouseEx = uiGetglobal("layWorld.frmWarehouseEx")

	for i = 1, UI_BANKBAG_ALLOWED_MAX_BAG_COUNT, 1 do
		local BtBag = SAPI.GetChild(frmWarehouseEx, "BtBag"..i)
		BtBag:SetChecked(false)
	end
end

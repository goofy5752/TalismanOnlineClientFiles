
function layWorld_frmSign_OnLoad(self)
	self:RegisterScriptEventNotify("EVENT_LocalGurl");
end

function layWorld_frmSign_OnEvent(self, event, args)
	if event == "EVENT_LocalGurl" then
		local address = args[1];
		if address == "sign" then
			self:ShowAndFocus();
		end
	end
end

function layWorld_frmSign_btItem_OnLoad(self)
	self:Set(EV_UI_SHORTCUT_OWNER_KEY, EV_UI_SHORTCUT_OWNER_SIGN);
end

function layWorld_frmSign_btItem_Clear(self)
	local shortcut_owner = self:Get(EV_UI_SHORTCUT_OWNER_KEY);
	if shortcut_owner == nil or shortcut_owner ~= EV_UI_SHORTCUT_OWNER_SIGN then return end
	local objectid = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
	if objectid and objectid ~= 0 then
		LClass_ItemFreezeManager:Erase(objectid);
	end
	self:Delete(EV_UI_SHORTCUT_TYPE_KEY);
	self:Delete(EV_UI_SHORTCUT_OBJECTID_KEY);
	self:Delete(EV_UI_SHORTCUT_CLASSID_KEY);
	layWorld_frmSign_btItem_Refresh(self);
end

function layWorld_frmSign_btItem_Refresh(self)
	local shortcut_owner = self:Get(EV_UI_SHORTCUT_OWNER_KEY);
	if shortcut_owner == nil or shortcut_owner ~= EV_UI_SHORTCUT_OWNER_SIGN then return end
	local shortcut_type = self:Get(EV_UI_SHORTCUT_TYPE_KEY);
	local shortcut_objectid = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
	local shortcut_classid = self:Get(EV_UI_SHORTCUT_CLASSID_KEY);
	
	local icon = 0; -- 图标地址 -- 指针地址
	local bModifyFlag = false;
	if shortcut_type == nil or shortcut_type == EV_SHORTCUT_OBJECT_NONE then
		shortcut_type = EV_SHORTCUT_OBJECT_NONE;
	elseif shortcut_classid == nil or shortcut_classid == 0 then
	elseif shortcut_type == EV_SHORTCUT_OBJECT_ITEM then
		local tableInfo = uiItemGetItemClassInfoByTableIndex(shortcut_classid); -- 道具的静态信息
		if tableInfo then
			icon = SAPI.GetImage(tableInfo.Icon, 2, 2, -2, -2);
		end
		bModifyFlag = true;
	end
	-- 操作按钮
	self:ModifyFlag("DragOut_MouseMove", bModifyFlag);
	self:SetNormalImage(icon);
end

function layWorld_frmSign_OnShow(self)
	uiRegisterEscWidget(self);
end

function layWorld_frmSign_OnHide(self)
	local btItem = SAPI.GetChild(self, "btItem");
	layWorld_frmSign_btItem_Clear(btItem);
end

function layWorld_frmSign_btItem_OnDragIn(self, drag)
	local allow_owners = 
	{
		EV_UI_SHORTCUT_OWNER_ITEM,
		IsAllowed = function(self, owner)
			if owner == nil then return false end
			for i, v in ipairs(self) do
				if v == owner then return true end
			end
			return false;
		end
	}
	local drag_out = uiGetglobal(drag);
	if drag_out == nil then return end
	local shortcut_owner = drag_out:Get(EV_UI_SHORTCUT_OWNER_KEY);
	if shortcut_owner == nil then return end
	if allow_owners:IsAllowed(shortcut_owner) == false then return end
	local shortcut_type = drag_out:Get(EV_UI_SHORTCUT_TYPE_KEY);
	if shortcut_type == nil or shortcut_type ~= EV_SHORTCUT_OBJECT_ITEM then return end
	local shortcut_objectid = drag_out:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
	if shortcut_objectid == nil or shortcut_objectid == 0 then return end
	local shortcut_classid = drag_out:Get(EV_UI_SHORTCUT_CLASSID_KEY);
	if shortcut_classid == nil or shortcut_classid == 0 then return end
	-- 如果当前按钮有东西，先dragout
	
	-- 检查 是否可以签名
	if uiItemCanSigned(shortcut_objectid, true) ~= true then return end
	
	-- 检查通过,可以放进来
	layWorld_frmSign_btItem_Clear(self); -- 先把旧的清除掉
	LClass_ItemFreezeManager:Push(shortcut_objectid);
	self:Set(EV_UI_SHORTCUT_TYPE_KEY, shortcut_type);
	self:Set(EV_UI_SHORTCUT_OBJECTID_KEY, shortcut_objectid);
	self:Set(EV_UI_SHORTCUT_CLASSID_KEY, shortcut_classid);
	layWorld_frmSign_btItem_Refresh(self);
end

function layWorld_frmSign_btItem_OnDragNull(self)
	layWorld_frmSign_btItem_Clear(self);
end

function layWorld_frmSign_btItem_OnRClick(self)
	layWorld_frmSign_btItem_Clear(self);
end

function layWorld_frmSign_btItem_OnHint(self)
	local hint = 0;
	local shortcut_type = self:Get(EV_UI_SHORTCUT_TYPE_KEY);
	if shortcut_type == nil then
	elseif shortcut_type == EV_SHORTCUT_OBJECT_ITEM then
		local shortcut_objectid = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
		if shortcut_objectid == nil or shortcut_objectid == 0 then
		else
			hint = uiItemGetBagItemHintByObjectId(shortcut_objectid);
		end
	end
	self:SetHintRichText(hint);
end

function layWorld_frmSign_btOK_OnLClick(self)
	-- 执行签名操作
	local btItem = SAPI.GetSibling(self, "btItem");
	local objectid = btItem:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
	if not objectid or objectid == 0 then return end
	if uiItemSigned(objectid) == true then
		layWorld_frmSign_btItem_Clear(btItem);
	end
end

function layWorld_frmSign_btCancel_OnLClick(self)
	local frame = SAPI.GetParent(self);
	frame:Hide();
end




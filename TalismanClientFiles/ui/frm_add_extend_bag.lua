
function frmAddExtendBag_TemplateAddItemBagLabel_btAdd_OnLClick(self)
	local TemplateAddItemBagLabel = SAPI.GetParent(self);
	local frmAddExtendBag = SAPI.GetParent(TemplateAddItemBagLabel);
	local ID = TemplateAddItemBagLabel.ID;
	if not ID or ID == 0 then frmAddExtendBag:Hide() return end
	local ItemObjectId = frmAddExtendBag.ItemObjectId;
	if not ItemObjectId or ItemObjectId == 0 then frmAddExtendBag:Hide() return end
	if uiItemReleaseItem(ItemObjectId, ID) == true then
		frmAddExtendBag:Hide();
	end
end

function frmAddExtendBag_TemplateAddItemBagLabel_OnLoad(self)
	local BagButtonMap =
	{
		[1] = "1", -- 第一个扩展包
		[2] = "2", -- 第二个扩展包
		default = "unknown",
		GetName = function (self, index)
			local name = self.default;
			if index and type(index) == "number" and self[index] then
				name = self[index];
			end
			return name;
		end,
	};
	
	local ID = self.ID;
	if not ID or ID == 0 then self:Hide() return end
	local btAdd = SAPI.GetChild(self, "btAdd");
	btAdd:SetText(BagButtonMap:GetName(ID));
end

function frmAddExtendBag_TemplateAddItemBagLabel_Refresh(self)
	if not self then return end
	local ID = self.ID;
	if not ID or ID == 0 then self:Hide() return end
	local btAdd = SAPI.GetChild(self, "btAdd");
	local line, col, count, IsOutDate, OutDateTime = uiItemGetItemCommonBagInfoByIndex(ID);
	local btAdd = SAPI.GetChild(self, "btAdd");
	local lbBagDesc = SAPI.GetChild(self, "lbBagDesc");
	local CanAdd = false;
	local Desc = "";
	local DescColor = {255,255,255,255};
	if line == nil then
		-- 没有这个道具包
		if uiItemGetItemBagCount() < ID + 1 then
			CanAdd = false;
		else
			CanAdd = true;
		end
		Desc = string.format(LAN("msg_extend_bag_no_active")); -- 未扩展
		DescColor = { 17, 17,224,255}; -- 未扩展颜色
	elseif OutDateTime and OutDateTime > 0 then
		local year, month, day, hour, minute, second, millisecond = uiFormatTime(OutDateTime);
		Desc = string.format(LAN("msg_leasingtime"), year, month, day, hour, minute);
		if IsOutDate then
			DescColor = { 17, 17,224,255}; -- 过期颜色
			CanAdd = true;
		else
			DescColor = {17,224,17,255}; -- 未过期颜色
			CanAdd = false;
		end
	else
		Desc = string.format(LAN("msg_extend_bag_active")); -- 已扩展
		DescColor = {17,224,17,255}; -- 已扩展颜色
		CanAdd = false;
	end
	if CanAdd then
		btAdd:Enable()
	else
		btAdd:Disable();
	end
	lbBagDesc:SetTextColorEx(DescColor[1], DescColor[2], DescColor[3], DescColor[4]);
	lbBagDesc:SetText(Desc);
end

function layWorld_frmAddExtendBag_OnLoad(self)
	self:RegisterScriptEventNotify("EVENT_ItemUseIndirect");
end

function layWorld_frmAddExtendBag_OnEvent(self, event, args)
    if event=="EVENT_ItemUseIndirect" then
		local itemobjectid = args[1]; -- 道具ObjectId
		local itemtype = args[2]; -- 道具类型

        if itemtype == EV_ITEM_TYPE_ULTRABAG then -- 额外道具包
			if self:getVisible() == true then return end
			self.ItemObjectId = itemobjectid;
			self:ShowAndFocus();
		end
    end
end

function layWorld_frmAddExtendBag_Refresh(self)
	if not self then self = uiGetglobal("layWorld.frmAddExtendBag") end
	local info = uiItemGetItemSystemInfo();
	if info == nil then self:Hide() return end
	local MaxPage = info.ItemSlot.Item.Page;
	for i = 1, MaxPage, 1 do
		local lbAddItemBag = SAPI.GetChild(self, "lbAddItemBag"..i);
		if lbAddItemBag then
			frmAddExtendBag_TemplateAddItemBagLabel_Refresh(lbAddItemBag);
		end
	end
end

function layWorld_frmAddExtendBag_OnShow(self)
	local ItemObjectId = self.ItemObjectId;
	if ItemObjectId == nil or ItemObjectId == 0 then self:Hide() return end
	LClass_ItemFreezeManager:Push(ItemObjectId);
	layWorld_frmAddExtendBag_Refresh(self);
end

function layWorld_frmAddExtendBag_OnHide(self)
	local ItemObjectId = self.ItemObjectId;
	if ItemObjectId == nil or ItemObjectId == 0 then return end
	LClass_ItemFreezeManager:Erase(ItemObjectId);
end










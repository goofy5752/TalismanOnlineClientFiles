
local PointShopItemDisplayMaxCount = {
	TYPE = 7, -- [物品类型]在界面上显示的上限数量
	ITEM = 12, -- [物品]在界面上显示的上限数量
	ITEMLINK = 4, -- [促销物品链接]在界面上显示的上限数量
	ITEMCOL = 3,
};
local PointShopPromotionLabel = nil;
--点数类型列表
local PointShopPointTypes =
{
	0, -- 钻石
	1, -- 水晶
	---1, -- 全部
	namelist =
	{
		"msg_point_shop_crystal_enter",
		"msg_point_shop_point_enter",
		--"$全部$",
	},
	SelectedIndex = nil,
	GetCurPointType = function (self)
		return self[self.SelectedIndex];
	end,
	GetCurPointTypeName = function (self)
		return self.namelist[self.SelectedIndex];
	end,
	IsValid = function (self, type)
		if self.SelectedIndex == nil then return false end
		if self[self.SelectedIndex] == -1 then return true end
		return type == self[self.SelectedIndex];
	end
};
--物品类型UI实例列表
PointShopXMLTypes = {
	SelectedIndex = nil,
	SelectedHistory = {},
	Save = function (self)
		self.SelectedHistory[PointShopPointTypes.SelectedIndex] = self.SelectedIndex;
	end,
	Load = function (self)
		self.SelectedIndex = self.SelectedHistory[PointShopPointTypes.SelectedIndex];
	end,
	TypeList =
	{
		Clear = function (self)
			for i = 1, table.getn(self), 1 do
				table.remove(self, 1);
			end
		end,
	},
	GetTypeIndex = function (self, index)
		return self.TypeList[index];
	end,
	GetSelectedTypeIndex = function (self)
		if self.SelectedIndex == nil then return nil end
		return self.TypeList[self.SelectedIndex];
	end,
	FindTypeIndex = function (self, typeindex)
		for i, v in ipairs(self.TypeList) do
			if v == typeindex then return i end
		end
	end
};
--物品UI实例列表
PointShopXMLItems = {
	SelectedIndex = nil,
	SelectedHistory = {},
	Save = function (self)
		self.SelectedHistory[PointShopPointTypes.SelectedIndex] = self.SelectedIndex;
	end,
	Load = function (self)
		self.SelectedIndex = self.SelectedHistory[PointShopPointTypes.SelectedIndex];
	end,
};
--物品UI实例列表
local PointShopXMLItemLinks = {
	SelectedIndex = nil,
	SelectedHistory = {},
	Save = function (self)
		self.SelectedHistory[PointShopPointTypes.SelectedIndex] = self.SelectedIndex;
	end,
	Load = function (self)
		self.SelectedIndex = self.SelectedHistory[PointShopPointTypes.SelectedIndex];
	end,
	LinkList =
	{
		Clear = function (self)
			for i = 1, table.getn(self), 1 do
				table.remove(self, 1);
			end
		end,
	},
};
-- 宣传图片列表
local PointShopXMLPromotionImages = {
	ITEM_AREA = nil;
	PROMOTION_AREA = nil;
	ITEM_MODEL = nil;
};
--滚动条
local PointShopXMLScrolls = {
	TYPE_V = nil,
	ITEM_V = nil,
	SelectedHistory_TYPE_V = {},
	SelectedHistory_ITEM_V = {},
	Save = function (self)
		if self.TYPE_V then
			self.SelectedHistory_TYPE_V[PointShopPointTypes.SelectedIndex] = self.TYPE_V:getValue();
		end
		if self.ITEM_V then
			self.SelectedHistory_ITEM_V[PointShopPointTypes.SelectedIndex] = self.ITEM_V:getValue();
		end
	end,
	Load = function (self)
		if self.TYPE_V and self.SelectedHistory_TYPE_V[PointShopPointTypes.SelectedIndex] then
			self.TYPE_V:SetValue(self.SelectedHistory_TYPE_V[PointShopPointTypes.SelectedIndex]);
		end
		if self.ITEM_V then
			self.ITEM_V:SetValue(self.SelectedHistory_ITEM_V[PointShopPointTypes.SelectedIndex]);
		end
	end,
};

-- 商城界面被加载的时候[物品类型窗口] (把XML对应的UI实例放入相应的table中)
function PointShop_frmShopTypes_OnLoad(self)
	self:SetAutoScrollV(true, false, false);
	for i = 0, PointShopItemDisplayMaxCount.TYPE-1 do
		PointShopXMLTypes[i+1] = uiGetChild(self, "ItemType"..i); -- lua的table序号是从1开始的
		if (PointShopXMLTypes[i+1] == nil) then
			uiError("global PointShopXMLTypes["..(i+1).."] nil error!!!");
		end
	end
	PointShopXMLScrolls.TYPE_V = self:getAutoScrollV();
	PointShopXMLScrolls.TYPE_V:Hide();
end

-- 商城界面被显示的时候
function PointShop_frmPointShop_OnShow(self)
	uiRegisterEscWidget(self);
	self:SetFocus();
	PointShopAPI.GetDate();
	if PointShopPointTypes.SelectedIndex == nil then
		layWorld_frmPointShop1_SetPointType(1);
	else
		PointShop_UpdateAllFrame();
	end
end

-- 商城界面被加载的时候[物品窗口] (把XML对应的UI实例放入相应的table中)
function PointShop_frmItems_OnLoad(self)
	self:SetAutoScrollV(true, false, false);
	for i = 0, PointShopItemDisplayMaxCount.ITEM-1 do
		PointShopXMLItems[i+1] = uiGetChild(self, "Item"..i);
		if (PointShopXMLItems[i+1] == nil) then
			uiError("global PointShopXMLItems["..(i+1).."] nil error!!!");
		end
	end
	PointShopXMLPromotionImages.ITEM_AREA = uiGetChild(self, "PromotionImage");
	PointShopXMLScrolls.ITEM_V = self:getAutoScrollV();
	PointShopXMLScrolls.ITEM_V:Hide();
end

-- 商城界面被加载的时候[促销窗口] (把XML对应的UI实例放入相应的table中)
function PointShop_frmPromotion_OnLoad(self)
	for i = 0, PointShopItemDisplayMaxCount.ITEMLINK-1 do
		PointShopXMLItemLinks[i+1] = uiGetChild(self, "ItemLink"..i);
		if (PointShopXMLItemLinks[i+1] == nil) then
			uiError("global PointShopXMLItemLinks["..(i+1).."] nil error!!!");
		end
	end
	PointShopXMLPromotionImages.PROMOTION_AREA = uiGetChild(self, "Image");
	PointShopXMLPromotionImages.ITEM_MODEL = uiGetChild(self, "Model");
	PointShopPromotionLabel = uiGetChild(self, "Promotion");
end

function PointShop_UpdateAllFrame ()
	PointShopItemType_Update();
	PointShopItemPromotion_Update();
	local frmPointShop1 = uiGetglobal("layWorld.frmPointShop1");
	local PayUrl = uiGetConfigureEntry("point_shop", "PayUrl");
	local btPay = uiGetglobal("layWorld.frmPointShop1.btPay");
	if not PayUrl or PayUrl == "" then
		btPay:Disable();
	else
		btPay:Enable();
		btPay:Set("url", PayUrl);
		btPay:SetHintText(PayUrl);
	end
	local MarkUrl = uiGetConfigureEntry("point_shop", "MarkUrl");
	local btMark = uiGetglobal("layWorld.frmPointShop1.btMark");
	if not MarkUrl or MarkUrl == "" then
		btMark:Disable();
	else
		btMark:Enable();
		btMark:Set("url", MarkUrl);
		btMark:SetHintText(MarkUrl);
	end
	local btSwitchShop = SAPI.GetChild(frmPointShop1, "btSwitchShop");
	local labelPoint = SAPI.GetChild(frmPointShop1, "labelPoint");
	PointShop_UpdatePoint(labelPoint);
	if uiIsCrystalShopOpen() then
		btSwitchShop:Show();
		uiInfo("PointShopPointTypes.SelectedIndex = "..tostring(PointShopPointTypes.SelectedIndex));
		local name = PointShopPointTypes:GetCurPointTypeName();
		if name == nil then
			name = "XXX";
		else
			name = LAN(name);
		end
		btSwitchShop:SetText(name);
	else
		btSwitchShop:Hide();
	end
end

function PointShop_UpdatePoint (self)
	local pointdesc = "XXX";
	local point = 0;
	local labelPointDesc = SAPI.GetSibling(self, "labelPointDesc");
	if PointShopPointTypes.SelectedIndex == 1 then -- 钻石
		pointdesc = LAN("msg_point_shop_point_count");
		point = uiPointShopGetCurPoint();
	elseif PointShopPointTypes.SelectedIndex == 2 then -- 水晶
		pointdesc = LAN("msg_point_shop_crystal_count");
		point = uiPointShopGetCurCrystal();
	end
	labelPointDesc:SetText(pointdesc);
	self:SetText(tostring(point));
end

--**************
-- ItemType
--**************

-- 用户选择了一个[物品类型]
function PointShopItemType_OnLClick(self)
	local scrollV = PointShopXMLScrolls.TYPE_V;
	local offset = 0;
	--if (scrollV:getVisible() == true) then
		offset = scrollV:getValue();
	--end
	if (PointShopXMLTypes.SelectedIndex ~= nil and tostring(PointShopXMLTypes[PointShopXMLTypes.SelectedIndex - offset]) == tostring(self)) then
		self:SetChecked(true); -- C代码可能会把checked置为false
		return; -- 这就是当前的选项,不需要做额外的事情
	end
	-- 点击了其它类型,把Item区域的滚动条设置到0
	if PointShopXMLScrolls.ITEM_V then
		PointShopXMLScrolls.ITEM_V:SetValue(0);
	end
	PointShopXMLTypes.SelectedIndex = nil;
	PointShopXMLItems.SelectedIndex = nil;
	PointShopXMLItemLinks.SelectedIndex = nil;
	for i = 1, PointShopItemDisplayMaxCount.TYPE do
		if tostring(PointShopXMLTypes[i]) == tostring(self) then
			PointShopXMLTypes[i]:SetChecked(true);
			PointShopXMLTypes.SelectedIndex = i + offset;
		else
			PointShopXMLTypes[i]:SetChecked(false);
		end
	end
	PointShopItemType_Update();
	PointShopItemPromotion_Update();
end

-- 鼠标进入了一个[物品类型]
function PointShopItemType_OnEnter(self)
end

-- 更新商城界面 [物品类型列表] 的显示
function PointShopItemType_Update()
--[[
	local scrollV = PointShopXMLScrolls.TYPE_V;
	local itemTypeCount = tonumber(uiPointShopGetTypeCount());
	if itemTypeCount > 0 and PointShopXMLTypes.SelectedIndex == nil then
		PointShopXMLTypes.SelectedIndex = 1;
	end
	if itemTypeCount == nil then
		itemTypeCount = 0;
	end
	-- 更新 [物品类型列表] 的滚动条状态
	if (itemTypeCount <= PointShopItemDisplayMaxCount.TYPE) then
		--if scrollV:getVisible() == true then
			scrollV:SetData(0, 0, 0, 0);
			scrollV:Hide();
		--end
	else
		scrollV:SetData(	0,
							itemTypeCount - PointShopItemDisplayMaxCount.TYPE,
							scrollV:getValue(),
							PointShopItemDisplayMaxCount.TYPE/itemTypeCount);
		scrollV:SetStep(1);
		scrollV:SetValuePerPage(PointShopItemDisplayMaxCount.TYPE - 1);
		scrollV:Show();
	end
	local typePromotionImage = nil;
	if PointShopXMLTypes.SelectedIndex then
		_, _, typePromotionImage = uiPointShopGetTypeInfo(PointShopXMLTypes.SelectedIndex - 1);
	end
	PointShopItemShow_SetPromotionImage(typePromotionImage);
	-- 更新 [物品类型列表] 的按钮状态
	local offset = 0;
	--if scrollV:getVisible() == true then
		offset = scrollV:getValue();
	--end
	-- 查找选中的项
	local selectedIndexInTypeTable = nil;
	if (PointShopXMLTypes.SelectedIndex ~= nil) then
		selectedIndexInTypeTable = PointShopXMLTypes.SelectedIndex - offset;
	end
	
	for i = 1, PointShopItemDisplayMaxCount.TYPE do
		local itemTypeObj = PointShopXMLTypes[i];
		local nameLabel = uiGetChild(itemTypeObj, "Name");
		local iconLabel = uiGetChild(itemTypeObj, "Image");
		if (i + offset > itemTypeCount) then
			nameLabel:SetText("");
			itemTypeObj:Hide();
		else
			local typeName, typeIcon = uiPointShopGetTypeInfo(i + offset - 1);
			nameLabel:SetText(typeName);
			if typeIcon then
				iconLabel:SetBackgroundImage(SAPI.GetImage(typeIcon));
			else
				iconLabel:SetBackgroundImage(0);
			end
			if (i == selectedIndexInTypeTable) then
				itemTypeObj:SetChecked(true);
			else
				itemTypeObj:SetChecked(false);
			end
			itemTypeObj:Show();
		end
	end
	PointShopItemShow_Update();
	]]
	local scrollV = PointShopXMLScrolls.TYPE_V;
	local itemTypeCount = tonumber(uiPointShopGetTypeCount());
	if itemTypeCount == nil then
		itemTypeCount = 0;
	end
	if itemTypeCount > 0 and PointShopXMLTypes.SelectedIndex == nil then
		PointShopXMLTypes.SelectedIndex = 1;
	end
	-- 筛选
	PointShopXMLTypes.TypeList:Clear(); -- 清空旧的列表
	for i = 1, itemTypeCount, 1 do
		local a, b, c, group = uiPointShopGetTypeInfo(i - 1);
		if PointShopPointTypes:IsValid(group) then
			table.insert(PointShopXMLTypes.TypeList, i);
		end
	end
	itemTypeCount = table.getn(PointShopXMLTypes.TypeList);
	-- 更新 [物品类型列表] 的滚动条状态
	if (itemTypeCount <= PointShopItemDisplayMaxCount.TYPE) then
		--if scrollV:getVisible() == true then
			scrollV:SetData(0, 0, 0, 0);
			scrollV:Hide();
		--end
	else
		scrollV:SetData(	0,
							itemTypeCount - PointShopItemDisplayMaxCount.TYPE,
							scrollV:getValue(),
							PointShopItemDisplayMaxCount.TYPE/itemTypeCount);
		scrollV:SetStep(1);
		scrollV:SetValuePerPage(PointShopItemDisplayMaxCount.TYPE - 1);
		scrollV:Show();
	end
	
	-- 更新 [物品类型列表] 的按钮状态
	local offset = 0;
	--if scrollV:getVisible() == true then
		offset = scrollV:getValue();
	--end
	-- 查找选中的项
	local selectedIndexInTypeTable = nil;
	if (PointShopXMLTypes.SelectedIndex ~= nil) then
		selectedIndexInTypeTable = PointShopXMLTypes.SelectedIndex - offset;
	end
	
	for i = 1, PointShopItemDisplayMaxCount.TYPE do
		local itemTypeObj = PointShopXMLTypes[i];
		local nameLabel = uiGetChild(itemTypeObj, "Name");
		local iconLabel = uiGetChild(itemTypeObj, "Image");
		if (i + offset > itemTypeCount) then
			nameLabel:SetText("");
			itemTypeObj:Hide();
		else
			local typeName, typeIcon = uiPointShopGetTypeInfo(PointShopXMLTypes:GetTypeIndex(i + offset) - 1);
			nameLabel:SetText(typeName);
			if typeIcon then
				iconLabel:SetBackgroundImage(SAPI.GetImage(typeIcon));
			else
				iconLabel:SetBackgroundImage(0);
			end
			if (i == selectedIndexInTypeTable) then
				itemTypeObj:SetChecked(true);
			else
				itemTypeObj:SetChecked(false);
			end
			itemTypeObj:Show();
		end
	end
	PointShopItemShow_Update();
end

function PointShopItemType_RollToSelected()
	if (PointShopXMLTypes.SelectedIndex == nil) then
		return;
	end
	local scrollV = PointShopXMLScrolls.TYPE_V;
	local value = scrollV:getValue();
	if PointShopXMLTypes.SelectedIndex ~= nil then
		if PointShopXMLTypes.SelectedIndex > (value + PointShopItemDisplayMaxCount.TYPE) then
			value = PointShopXMLTypes.SelectedIndex + 1 - PointShopItemDisplayMaxCount.TYPE;
		elseif PointShopXMLTypes.SelectedIndex <= value then
			value = PointShopXMLTypes.SelectedIndex - 1;
		end
	end
	scrollV:SetValue(value);
	PointShopItemType_Update();
end

--**************
-- ItemShow
--**************

-- 用户选择了一个[物品]
function PointShopItem_OnLClick(self)
	local scrollV = PointShopXMLScrolls.ITEM_V;
	local offset = 0;
	--if scrollV:getVisible() == true then
		offset = scrollV:getValue() * PointShopItemDisplayMaxCount.ITEMCOL;
	--end
	if (PointShopXMLItems.SelectedIndex ~= nil and tostring(PointShopXMLItems[PointShopXMLItems.SelectedIndex - offset]) == tostring(self)) then
		self:SetChecked(true); -- C代码可能会把checked置为false
		return; -- 这就是当前的选项,不需要做额外的事情
	end
	PointShopXMLItems.SelectedIndex = nil;
	PointShopXMLItemLinks.SelectedIndex = nil;
	for i = 1, PointShopItemDisplayMaxCount.ITEM do
		if tostring(PointShopXMLItems[i]) == tostring(self) then
			PointShopXMLItems[i]:SetChecked(true);
			PointShopXMLItems.SelectedIndex = i + offset;
		else
			PointShopXMLItems[i]:SetChecked(false);
		end
	end
	PointShopItemShow_Update();
	PointShopItemPromotion_Update();
end

-- 鼠标进入了一个[显示物品]
function PointShopItem_OnEnter(self)
	local scrollV = PointShopXMLScrolls.ITEM_V;
	local offset = 0;
	--if scrollV:getVisible() == true then
		offset = scrollV:getValue() * PointShopItemDisplayMaxCount.ITEMCOL;
	--end
	local itemIndex = nil;
	for i = 1, PointShopItemDisplayMaxCount.ITEM do
		if tostring(PointShopXMLItems[i]) == tostring(self) then
			uiPointShopItemHint(PointShopXMLTypes:GetSelectedTypeIndex() - 1, offset + i - 1, self);
			--_, itemIndex = uiPointShopGetItemInfo(PointShopXMLTypes.SelectedIndex - 1, offset + i - 1);
			break;
		end
	end
	if itemIndex == nil then
		return;
	end
	--uiSetGenerateItemHint(itemIndex, self);
	--self:SetHintText("ItemHint");
end

-- 更新已选择类型的所有[显示物品]
function PointShopItemShow_Update()
	local scrollV = PointShopXMLScrolls.ITEM_V;
	if PointShopXMLTypes.SelectedIndex == nil then
		-- 没有选择物品类型,则隐藏所有物品显示
		for i = 1, PointShopItemDisplayMaxCount.ITEM do
			if PointShopXMLItems[i] == nil then
				uiMessage(tostring(i));
			end
			PointShopXMLItems[i]:Hide();
		end
		--if (scrollV:getVisible() == true) then
			scrollV:SetData(0, 0, 0, 0);
			scrollV:Hide();
		--end
		return;
	end
	local itemCount = uiPointShopGetItemCountInType(PointShopXMLTypes:GetSelectedTypeIndex() - 1);
	if (itemCount <= PointShopItemDisplayMaxCount.ITEM) then
		--if (scrollV:getVisible() == true) then
			scrollV:SetData(0, 0, 0, 0);
			scrollV:Hide();
		--end
	else
		scrollV:SetData(	0,
							(itemCount + 1)/PointShopItemDisplayMaxCount.ITEMCOL, -- 两排按钮
							scrollV:getValue(),
							PointShopItemDisplayMaxCount.ITEM/itemCount);
		scrollV:SetStep(1);
		scrollV:SetValuePerPage(PointShopItemDisplayMaxCount.ITEM/PointShopItemDisplayMaxCount.ITEMCOL - 1);
		--scrollV:Show();
	end
	-- 更新 翻页 控制区
	local frmPointShop1 = uiGetglobal("layWorld.frmPointShop1");
	local frmItems = SAPI.GetChild(frmPointShop1, "frmItems");
	local lbItemPageControl = SAPI.GetChild(frmItems, "lbItemPageControl");
	local lbPageText = SAPI.GetChild(lbItemPageControl, "lbPageText");
	local btPageUp = SAPI.GetChild(lbItemPageControl, "btPageUp");
	local btPageDown = SAPI.GetChild(lbItemPageControl, "btPageDown");
	local value = scrollV:getValue();
	local page = math.floor(value * PointShopItemDisplayMaxCount.ITEMCOL / PointShopItemDisplayMaxCount.ITEM);
	local maxpage = math.floor((itemCount-0.5) / PointShopItemDisplayMaxCount.ITEM);
	lbPageText:SetText(string.format("%d / %d", page + 1, maxpage + 1));
	if page > 0 then
		btPageUp:Enable();
	else
		btPageUp:Disable();
	end
	if page < maxpage then
		btPageDown:Enable();
	else
		btPageDown:Disable();
	end
	-- 更新 [物品列表] 的按钮状态
	local offset = 0;
	--if scrollV:getVisible() == true then
		offset = scrollV:getValue() * PointShopItemDisplayMaxCount.ITEMCOL;
	--end
	-- 查找选中的项
	local selectedIndexInItemTable = nil;
	if (PointShopXMLItems.SelectedIndex ~= nil) then
		selectedIndexInItemTable = PointShopXMLItems.SelectedIndex - offset;
	end
	-- 刷新所有按钮的显示
	for i = 1, PointShopItemDisplayMaxCount.ITEM do
		local itemObj = PointShopXMLItems[i];
		local nameLabel = uiGetChild(itemObj, "Name");
		local iconLabel = uiGetChild(itemObj, "Image");
		local proIconLabel = uiGetChild(itemObj, "Icon");
		local pointEditBox = uiGetChild(itemObj, "Point");
		local PointLebal = uiGetChild(itemObj, "PointLebal");
		if (i + offset > itemCount) then
			nameLabel:SetText("");
			pointEditBox:SetText("");
			itemObj:Hide();
		else
			--local name, pointDel, point = PointShop_GetItemInfo(PointShopXMLTypes.SelectedIndex, i + offset);
			local id, itemId, pointtype, point, pointDel, proIcon = uiPointShopGetItemInfo(PointShopXMLTypes:GetSelectedTypeIndex() - 1, i + offset - 1);
			local name, icon, _, cing = uiGetItemInfo(itemId); -- name, icon, description, cing (cing = count in group)
			if name == nil then
				itemObj:Hide();
				if (selectedIndexInItemTable and i == selectedIndexInItemTable) then
					PointShopXMLItems.SelectedIndex = nil;
					selectedIndexInItemTable = nil;
				end
			else
				nameLabel:SetText(name);
				if icon == nil then
					iconLabel:SetBackgroundImage(0);
				else
					iconLabel:SetBackgroundImage(SAPI.GetImage(icon));
				end
				if cing and cing > 0 then
					iconLabel:SetUltraTextNormal(tostring(cing));
				else
					iconLabel:SetUltraTextNormal("");
				end
				if pointtype == 0 then
					PointLebal:SetText(LAN("msg_point_shop_point_type_0"));
				elseif pointtype == 1 then
					PointLebal:SetText(LAN("msg_point_shop_point_type_1"));
				else
					PointLebal:SetText("XXX");
				end

				if point == nil then
					pointEditBox:SetText("unknown");
				elseif pointDel == nil or pointDel <= 0 then
					pointEditBox:SetText(tostring(point));
				else
					pointEditBox:SetRichText("<UiRichText><Line><Items><Item type=\"TEXT\" centerline=\"true\" text=\""..pointDel.."\" color=\"#ffff0000\"/><Item type=\"TEXT\" text=\" \"/><Item type=\"TEXT\" text=\""..point.."\" color=\"#ff00ff00\"/></Items></Line></UiRichText>", false);
				end
				if (selectedIndexInItemTable and i == selectedIndexInItemTable) then
					itemObj:SetChecked(true);
				else
					itemObj:SetChecked(false);
				end
				if proIcon then
					local image = SAPI.GetImage(proIcon);
					proIconLabel:SetBackgroundImage(image);
					proIconLabel:Show();
				else
					proIconLabel:Hide();
				end
				itemObj:Show();
			end
		end
	end
end

function PointShop_frmItems_lbItemPageControl_btPageUp_OnLClick(self)
	local scrollV = PointShopXMLScrolls.ITEM_V;
	local value = scrollV:getValue();
	value = value - PointShopItemDisplayMaxCount.ITEM / PointShopItemDisplayMaxCount.ITEMCOL;
	scrollV:SetValue(value);
	PointShopItemShow_Update();
end

function PointShop_frmItems_lbItemPageControl_btPageDown_OnLClick(self)
	local scrollV = PointShopXMLScrolls.ITEM_V;
	local value = scrollV:getValue();
	value = value + PointShopItemDisplayMaxCount.ITEM / PointShopItemDisplayMaxCount.ITEMCOL;
	scrollV:SetValue(value);
	PointShopItemShow_Update();
end

-- 设置[物品区]的宣传图片
function PointShopItemShow_SetPromotionImage(_image)
	local image = nil;
	if _image ~= nil then
		image = SAPI.GetImage(_image);
	end
	local imageLabel = PointShopXMLPromotionImages.ITEM_AREA;
	if image == nil then
		imageLabel:Hide();
		PointShopXMLItems[1]:MoveTo(14,14);
		--[[
		if PointShopItemDisplayMaxCount.ITEM == 6 then
			PointShopItemDisplayMaxCount.ITEM = 8;
			for i = 1, 6 do
				PointShopXMLItems[i]:MoveTo_Offset(0, -83);
			end
		end
		]]
	else
		imageLabel:Show();
		PointShopXMLItems[1]:MoveTo(14, 99);
		--[[
		if PointShopItemDisplayMaxCount.ITEM == 8 then
			PointShopItemDisplayMaxCount.ITEM = 6;
			for i = 1, 6 do
				PointShopXMLItems[i]:MoveTo_Offset(0, 83);
			end
			PointShopXMLItems[7]:Hide();
			PointShopXMLItems[8]:Hide();
		end
		]]
	end
	if imageLabel ~= nil then
		imageLabel:SetBackgroundImage(image);
	end
	PointShopItemShow_Update();
	PointShopItemShow_RollToSelected();
end

-- 设置[物品区]的滚动条到当前选中项
function PointShopItemShow_RollToSelected()
	if (PointShopXMLItems.SelectedIndex == nil) then
		return;
	end
	local scrollV = PointShopXMLScrolls.ITEM_V;
	local value = scrollV:getValue();
	if PointShopXMLItems.SelectedIndex ~= nil then
		--value = value * PointShopItemDisplayMaxCount.ITEMCOL;
		local page = math.floor((PointShopXMLItems.SelectedIndex-0.5) / PointShopItemDisplayMaxCount.ITEM);
		--[[
		if PointShopXMLItems.SelectedIndex > (value + PointShopItemDisplayMaxCount.ITEM) then
			value = (PointShopXMLItems.SelectedIndex - PointShopItemDisplayMaxCount.ITEM);
		elseif PointShopXMLItems.SelectedIndex <= value then
			value = PointShopXMLItems.SelectedIndex - 1;
		end
		]]
		--value = value / PointShopItemDisplayMaxCount.ITEMCOL;
		value = page * PointShopItemDisplayMaxCount.ITEM / PointShopItemDisplayMaxCount.ITEMCOL;
	end
	scrollV:SetValue(value);
	PointShopItemShow_Update();
end

--**************
-- ItemPromotion
--**************

function PointShopItemLink_OnLClick(self)
	local lastSelectedIndex = PointShopXMLItemLinks.SelectedIndex;
	PointShopXMLItemLinks.SelectedIndex = nil;
	for i = 1, (PointShopItemDisplayMaxCount.ITEMLINK)  do
		if (tostring(PointShopXMLItemLinks[i]) == tostring(self)) then
			self:SetChecked(true); -- 按钮有可能被C代码设置为false
			PointShopXMLItemLinks.SelectedIndex = i;
			if (i == lastSelectedIndex) then
				-- 用户点击了同一个链接,不需要做额外的工作
				return;
			end
			local linkArray = PointShopXMLItemLinks.LinkList; -- 四个链接
			if linkArray[i] == nil then return end
			PointShopAPI.SelectItem(linkArray[i].Type + 1, linkArray[i].Item + 1);
			--[[
			-- 激活链接的物品
			local _, _, _, link = uiPointShopGetInfo();
			local bSuccess = false;
			if link ~= nil then
				link = link..";";
				local index = 1;
				for _iType, _iItem in string.gfind(link, "(.-),(.-);") do
					if index == i then
						PointShopAPI.SelectItem(_iType + 1, _iItem + 1);
						bSuccess = true;
						break;
					end
					index = index + 1;
				end
			end
			if bSuccess == false then
				self:Hide();
			end
			]]
		else
			PointShopXMLItemLinks[i]:SetChecked(false);
		end
	end
	PointShopItemPromotion_Update();
end

-- 更新已选择类型的关联内容 (包括:商品链接)
function PointShopItemPromotion_Update()
	if (PointShopXMLItemLinks.SelectedIndex == nil) then
		for i = 1, PointShopItemDisplayMaxCount.ITEMLINK  do
			PointShopXMLItemLinks[i]:SetChecked(false);
		end
	end
	local imageLabel = PointShopXMLPromotionImages.PROMOTION_AREA;
	
	local _, image, text, link = uiPointShopGetInfo();
	-- 设置 链接
	local linkArray = PointShopXMLItemLinks.LinkList; -- 四个链接
	linkArray:Clear();
	if link then
		link = link..";";
		local index = 1;
		for _iType, _iItem in string.gfind(link, "(.-),(.-);") do
			local _iType = tonumber(_iType)
			local _iItem = tonumber(_iItem)
			if PointShopXMLTypes:FindTypeIndex(_iType + 1) then
				table.insert(linkArray, {Type=_iType, Item=_iItem});
				if index >= PointShopItemDisplayMaxCount.ITEMLINK then
					break;
				end
				index = index + 1;
			end
		end
	end
	for i = 1, PointShopItemDisplayMaxCount.ITEMLINK  do
		local nameLabel = uiGetChild(PointShopXMLItemLinks[i], "Name");
		local iconLabel = uiGetChild(PointShopXMLItemLinks[i], "Image");
		local typeIndex, itemIndex = nil, nil;
		if linkArray[i] then
			typeIndex = linkArray[i].Type;
			itemIndex = linkArray[i].Item;
		end
		if typeIndex == nil or itemIndex == nil then
			if (PointShopXMLItemLinks[i]:getVisible() == true) then
				nameLabel:SetText("");
				PointShopXMLItemLinks[i]:Hide();
			end
		else
			local _, itemId, _, _ = uiPointShopGetItemInfo(typeIndex, itemIndex);
			local name, icon, _ = uiGetItemInfo(itemId);
			if name then
				nameLabel:SetText(name);
				if iconLabel then
					if icon then
						local image = SAPI.GetImage(icon);
						iconLabel:SetBackgroundImage(image);
					else
						iconLabel:SetBackgroundImage(0);
					end
				end
				PointShopXMLItemLinks[i]:Show();
			else
				PointShopXMLItemLinks[i]:Hide();
			end
		end
	end
	-- 刷新公告文字区域 ( 如果有物品选中,则显示物品信息;否则显示公告)
	if (PointShopXMLTypes.SelectedIndex == nil or PointShopXMLItems.SelectedIndex == nil) then
		PointShopPromotionLabel:SetText(text);
		PointShopXMLPromotionImages.ITEM_MODEL:Hide();
		if image ~= nil then
			image = SAPI.GetImage(image);
		end
		if image == nil then
			PointShopPromotionLabel:MoveTo(10, 15);
			PointShopPromotionLabel:SetSize(170, 170);
			imageLabel:Hide();
		else
			PointShopPromotionLabel:MoveTo(10, 110);
			PointShopPromotionLabel:SetSize(170, 75);
			uiSetImageSourceRect(image, 0, 0, 221, 96);
			imageLabel:SetBackgroundImage(image);
			imageLabel:Show();
		end
	else
		local id, itemId, pointtype, point, pointDel, _, image, bkImage, descEx, noPreview = uiPointShopGetItemInfo(PointShopXMLTypes:GetSelectedTypeIndex() - 1, PointShopXMLItems.SelectedIndex - 1);
		local name, icon, description, cing, nameColor = uiGetItemInfo(itemId); -- name, icon, description, cing (cing = count in group)
		text = "<UiRichText><Line><Items><Item type=\"TEXT\" text=\""..name.."\" color=\"#"..nameColor.."\" font=\""..LAN("font_title").."\" fontsize=\""..LAN("font_s_18").."\"/>";
		if cing and cing > 0 then
			text = text.."<Item type=\"TEXT\" text=\" \"/><Item type=\"TEXT\" text=\"["..string.format(LAN("msg_item_count_in_group"), cing).."]\" color=\"#ff00ff00\"/>";
		end
		text = text.."</Items></Line><Line><Items><Item type=\"TEXT\" text=\""..description.."\" color=\"#ff00aadd\"/></Items></Line>";
		if (descEx and descEx ~= "") then -- 道具的额外描述文字
			text = text.."<Line></Line><Line><Items><Item type=\"TEXT\" text=\""..descEx.."\"/></Items></Line>";
		end
		text = text.."</UiRichText>";
		PointShopPromotionLabel:SetRichText(text, false);
		
		if noPreview == false then
			if PointShopXMLPromotionImages.ITEM_MODEL and id and uiPointShopSetModelView(PointShopXMLPromotionImages.ITEM_MODEL, id) == true then
				PointShopPromotionLabel:MoveTo(10, 110);
				PointShopPromotionLabel:SetSize(170, 75);
				PointShopXMLPromotionImages.ITEM_MODEL:Show();
				image = bkImage;
			else
				PointShopXMLPromotionImages.ITEM_MODEL:Hide();
			end
			if image ~= nil then
				image = SAPI.GetImage(image);
			end
			if image == nil then
				if PointShopXMLPromotionImages.ITEM_MODEL:getVisible() == false then
					PointShopPromotionLabel:MoveTo(10, 15);
					PointShopPromotionLabel:SetSize(170, 170);
				end
				imageLabel:Hide();
			else
				PointShopPromotionLabel:MoveTo(10, 110);
				PointShopPromotionLabel:SetSize(170, 75);
				uiSetImageSourceRect(image, 0, 0, 221, 96);
				imageLabel:SetBackgroundImage(image);
				imageLabel:Show();
			end
		else
			PointShopPromotionLabel:MoveTo(10, 15);
			PointShopPromotionLabel:SetSize(170, 170);
			PointShopXMLPromotionImages.ITEM_MODEL:Hide();
			imageLabel:Hide();
		end
	end
	--[[
	if (PointShopXMLPromotionImages.ITEM_MODEL:getVisible() == false) then
		if image ~= nil then
			image = SAPI.GetImage(image);
		end
		-- 如果没有图片,则editbox顶置
		if image == nil then
			PointShopPromotionLabel:MoveTo(10, 15);
			PointShopPromotionLabel:SetSize(170, 170);
			imageLabel:Hide();
		else
			PointShopPromotionLabel:MoveTo(10, 110);
			PointShopPromotionLabel:SetSize(170, 75);
			imageLabel:SetBackgroundImage(image);
			imageLabel:Show();
		end
	end
	]]
	--[[
	if imageLabel:getVisible() == true then
		if image == nil then
			PointShopPromotionLabel:MoveTo(10, 15);
			PointShopPromotionLabel:SetSize(170, 183);
			imageLabel:Hide();
		end
		imageLabel:SetBackgroundImage(image);
	else
		if image ~= nil then
			PointShopPromotionLabel:MoveTo(10, 110);
			PointShopPromotionLabel:SetSize(170, 80);
			imageLabel:SetBackgroundImage(image);
			imageLabel:Show();
		end
	end
	]]
	-- 调整editbox的大小 以填充没有显示的链接按钮
	local _FillLinkCount = 0;
	for i = PointShopItemDisplayMaxCount.ITEMLINK, 1, -1  do
		if PointShopXMLItemLinks[i] == nil or PointShopXMLItemLinks[i]:getVisible() == false then
			_FillLinkCount = _FillLinkCount + 1;
		else
			break;
		end
	end
	if _FillLinkCount ~= 0 then
		PointShopPromotionLabel:SetSize_Offset(0, _FillLinkCount * 40);
	end
end

--**************
-- Buy Input
--**************
function PointShopItemBuy_OnLClick(self)
	PointShopItem_OnLClick(self:getParent());
	if PointShopXMLTypes.SelectedIndex == nil or PointShopXMLItems.SelectedIndex == nil then
		return;
	end
	local inputBox = uiGetglobal("layWorld.PointShopBuyInputBox");
	local messageLabel = uiGetChild(inputBox, "Message");
	--local name, id, pointDel, point = PointShop_GetItemInfo(PointShopXMLTypes.SelectedIndex, PointShopXMLItems.SelectedIndex);
	
	
	local id, itemId, pointtype, point, pointDel = uiPointShopGetItemInfo(PointShopXMLTypes:GetSelectedTypeIndex() - 1, PointShopXMLItems.SelectedIndex - 1);
	local name, icon, description, cing = uiGetItemInfo(itemId); -- name, icon, description, cing (cing = count in group)

	local text = "<UiRichText><Line><Items><Item type=\"TEXT\" text=\"["..name.."]\" color=\"#ff00ff00\"/>";
	if cing and cing > 0 then
		text = text.."<Item type=\"TEXT\" text=\" \"/><Item type=\"TEXT\" text=\"["..string.format(LAN("msg_item_count_in_group"), cing).."]\" color=\"#ff00ff00\"/>";
	end
	local dlgMsgText = LAN("msg_point_shop_buy3");
	text = text.."</Items></Line><Line><Items><Item type=\"TEXT\" text=\""..dlgMsgText.."\"/></Items></Line></UiRichText>";
		
	
	--local id, itemId, pointtype, point, pointDel = uiPointShopGetItemInfo(PointShopXMLTypes.SelectedIndex - 1, PointShopXMLItems.SelectedIndex - 1);
	--local name, icon, _, cing = uiGetItemInfo(itemId); -- name, icon, description, cing (cing = count in group)
	--messageLabel:SetRichText("<UiRichText><Line><Items><Item type=\"TEXT\" text=\"您确认要购买\"/><Item type=\"TEXT\" text=\"["..name.."]\" color=\"#ff00ff00\"/><Item type=\"TEXT\" text=\"吗?\n可以在下面输入框中输入您需要购买的数量.\"/></Items></Line></UiRichText>", false);
	--messageLabel:SetRichText("<UiRichText><Line><Items><Item type=\"TEXT\" text=\"["..name.."]\" color=\"#ff00ff00\"/></Items></Line><Line><Items><Item type=\"TEXT\" text=\""..dlgMsgText.."\"/></Items></Line></UiRichText>", false);
	messageLabel:SetRichText(text, false);
	if inputBox then
		inputBox:Show();
		uiSetToModal(inputBox);
	end
end

function PointShopItemBuy_OnTextChanged(self)
	local inputBox = self:getParent();
	local count = tonumber(uiGetChild(inputBox, "Edit"):getText());
	local pointEditBox = uiGetChild(inputBox, "Point");
	if count == nil or count == 0 then
		pointEditBox:SetText("-");
	else
		local id, itemId, pointtype, point, pointDel = uiPointShopGetItemInfo(PointShopXMLTypes:GetSelectedTypeIndex() - 1, PointShopXMLItems.SelectedIndex - 1);
		local name, _, _ = uiGetItemInfo(itemId); -- name, icon, description
		if pointDel == nil or pointDel <= 0 then
			pointEditBox:SetText(tostring(point*count));
		else
			pointEditBox:SetRichText("<UiRichText><Line><Items><Item type=\"TEXT\" centerline=\"true\" text=\""..pointDel*count.."\" color=\"#ffff0000\"/><Item type=\"TEXT\" text=\" \"/><Item type=\"TEXT\" text=\""..point*count.."\" color=\"#ff00ff00\"/></Items></Line></UiRichText>", false);
		end
	end
end

function PointShop_frmPointShop_OnLoad(self)
	self:RegisterScriptEventNotify("point_shop_update");
	self:RegisterScriptEventNotify("EVENT_TogglePointShop");
	self:RegisterScriptEventNotify("EVENT_ToggleCrystalShop");
	self:RegisterScriptEventNotify("EVENT_LocalGurl");
end

function PointShop_frmPointShop_OnEvent(self, event, args)
	if event == "point_shop_update" then
		-- 数据更新了,调整 PointShopXMLTypes.SelectedIndex 和 PointShopXMLItems.SelectedIndex,指向有效的位置
		while (PointShopXMLTypes.SelectedIndex) do
			local name = uiPointShopGetTypeInfo(PointShopXMLTypes:GetSelectedTypeIndex() - 1);
			if name then
				break;
			end
			PointShopXMLItems.SelectedIndex = nil;
			PointShopXMLTypes.SelectedIndex = PointShopXMLTypes.SelectedIndex - 1;
			if PointShopXMLTypes.SelectedIndex <= 0 then
				PointShopXMLTypes.SelectedIndex = nil;
				PointShopXMLItems.SelectedIndex = nil;
			end
		end
		while (PointShopXMLTypes.SelectedIndex and PointShopXMLItems.SelectedIndex) do
			local id = uiPointShopGetItemInfo(PointShopXMLTypes:GetSelectedTypeIndex() - 1, PointShopXMLItems.SelectedIndex - 1);
			if id then
				break;
			end
			PointShopXMLItems.SelectedIndex = PointShopXMLItems.SelectedIndex - 1;
			if PointShopXMLItems.SelectedIndex <= 0 then
				PointShopXMLItems.SelectedIndex = nil;
			end
		end
		if self:getVisible() == true then
			PointShop_UpdateAllFrame();
		end
	elseif event == "EVENT_TogglePointShop" then -- 钻石
		if self:getVisible() then
			if PointShopPointTypes.SelectedIndex == 1 then -- 钻石
				self:Hide();
			elseif PointShopPointTypes.SelectedIndex == 2 then -- 水晶
				layWorld_frmPointShop1_SetPointType(1);
			end
		elseif uiPointShopIsActive() then
			layWorld_frmPointShop1_SetPointType(1);
			self:ShowAndFocus();
		end
	elseif event == "EVENT_ToggleCrystalShop" then -- 水晶
		if self:getVisible() then
			if PointShopPointTypes.SelectedIndex == 1 then -- 钻石
				layWorld_frmPointShop1_SetPointType(2);
			elseif PointShopPointTypes.SelectedIndex == 2 then -- 水晶
				self:Hide();
			end
		elseif uiPointShopIsActive() then
			layWorld_frmPointShop1_SetPointType(2);
			self:ShowAndFocus();
		end
	elseif event == "EVENT_LocalGurl" then
		local address = args[1];
		if address == "crystalshop" then
			if self:getVisible() then
				if PointShopPointTypes.SelectedIndex == 1 then -- 钻石
					layWorld_frmPointShop1_SetPointType(2);
				elseif PointShopPointTypes.SelectedIndex == 2 then -- 水晶
					self:Hide();
				end
			elseif uiPointShopIsActive() then
				layWorld_frmPointShop1_SetPointType(2);
				self:ShowAndFocus();
			end
		end
	end
end

function layWorld_frmPointShop1_btSwitchShop_OnLClick(self)
	local select = 1;
	if PointShopPointTypes.SelectedIndex == 1 then
		select = 2;
	elseif PointShopPointTypes.SelectedIndex == 2 then
		select = 1;
	end
	layWorld_frmPointShop1_SetPointType(select);
end

function layWorld_frmPointShop1_SetPointType(select)
	if PointShopPointTypes.SelectedIndex == nil then
		PointShopPointTypes.SelectedIndex = select;
		PointShop_UpdateAllFrame();
	elseif PointShopPointTypes.SelectedIndex ~= select then
		PointShopXMLTypes:Save();
		PointShopXMLItemLinks:Save();
		PointShopXMLItems:Save();
		PointShopXMLScrolls:Save();
		PointShopPointTypes.SelectedIndex = select;
		PointShopXMLTypes:Load();
		PointShopXMLItemLinks:Load();
		PointShopXMLItems:Load();
		PointShop_UpdateAllFrame();
		PointShopXMLScrolls:Load();
	end
end

function PointShop_BuyInputBox_Ok_OnLClick(self)
	self:getParent():Hide();
	if PointShopXMLTypes.SelectedIndex == nil or PointShopXMLItems.SelectedIndex == nil then
		return;
	end
	local buyCount = tonumber(SAPI.GetSibling(self, "Edit"):getText());
	if buyCount and buyCount > 0 then
		uiPointShopOnBuy(PointShopXMLTypes:GetSelectedTypeIndex() - 1, PointShopXMLItems.SelectedIndex - 1, buyCount);
	end
end

function layWorld_PointShopBuyInputBox_OnShow(self)
	local Edit = uiGetChild(self, "Edit");
	local lbNoModifyCount = uiGetChild(self, "lbNoModifyCount");
	local NoModifyCount = uiGetConfigureEntry("point_shop", "NoModifyCount");
	if NoModifyCount and NoModifyCount == "true" then
		Edit:Hide();
		lbNoModifyCount:Show();
		lbNoModifyCount:SetText("1");
	else
		Edit:Show();
		lbNoModifyCount:Hide();
	end
	Edit:SetText("1");
	uiRegisterEscWidget(self);
end




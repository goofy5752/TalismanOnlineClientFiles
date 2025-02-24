function layWorld_frmBlessingsCard_OnLoad(self)
	self:RegisterScriptEventNotify("EVENT_ItemUseIndirect");
end

function layWorld_frmBlessingsCard_OnEvent(self, event, args)
	if event == "EVENT_ItemUseIndirect" then
		local id = args[1];
		if id == nil or id == 0 then self:Hide() return end
		local objInfo = uiItemGetBagItemInfoByObjectId(id);
		local index = objInfo.TableId; -- 道具表格id
		if index == nil or index == 0 then self:Hide() return end
		local classInfo = uiItemGetItemClassInfoByTableIndex(index);
		if classInfo == nil then self:Hide() return end
		local Type = classInfo.Type;
		if id == nil or Type == nil then
			uiError(string.format("id=%s Type=%s", tostring(id), tostring(Type)));
			self:Hide();
			return;
		end
		self.ItemId = id; -- 相当于self:Set("ItemId", id);
		if Type == EV_ITEM_TYPE_BULLETINTOUSER then
			self:ShowAndFocus();
		end
	end
end

function layWorld_frmBlessingsCard_OnShow(self)
	uiRegisterEscWidget(self);
	layWorld_frmBlessingsCard_Refresh(self);
end

function layWorld_frmBlessingsCard_Refresh(self)
	if self == nil then self = uiGetglobal("layWorld.frmBlessingsCard") end
	local lboption = uiGetChild(self, "lboption");
	local lsbfriendslist = uiGetChild(lboption, "lsbfriendslist");
	layWorld_frmBlessingsCard_lboption_lsbfriendslist_Refresh(lsbfriendslist);
end

function layWorld_frmBlessingsCard_lboption_lsbfriendslist_Refresh(self)
	if self == nil then self = uiGetglobal("layWorld.frmBlessingsCard.lboption.lsbfriendslist") end
	local SelectLine = self:getSelectLine();
	local SelectName = "";
	if SelectLine and SelectLine >= 0 then
		SelectName = self:getLineItemText(SelectLine, 0); -- 保存上次选中好友的名字
	end
	self:RemoveAllLines(false);
	local friends = uiConnectionGetConnectionList(EV_CONNECTION_FRIEND);
	if friends == nil then return end
	local FriendList = {};
	for i, evid in ipairs(friends) do
		local name, _, _, _, online  = uiConnectionGetConnectionInfoByEvId(evid);
		local friend = {name=name, online=online};
		table.insert(FriendList, friend);
	end
	table.sort(FriendList, function (first, second) return first.online == true and second.online == false end);
	for i, friend in ipairs(FriendList) do
		local Color = 4294967295;
		--白色 4294967295 灰色 4286611584
		if friend.online == false then
			Color = 4286611584;
		end
		self:InsertLine(-1, Color, -1);
		self:SetLineItem(i-1, 0, friend.name, Color);
		if SelectName == friend.name then self:SetSelect(i-1) end
	end
end

function layWorld_frmBlessingsCard_lboption_btnenter_OnLClick(self)
	local frmBlessingsCard = SAPI.GetParent(SAPI.GetParent(self));
	local id = frmBlessingsCard.ItemId;
	if id == nil or id <= 0 then
		frmBlessingsCard:Hide();
		return;
	end
	if self == nil then self = uiGetglobal("layWorld.frmBlessingsCard.lboption.btnenter") end
	local lsbfriendslist = SAPI.GetSibling(self, "lsbfriendslist");
	local SelectLine = lsbfriendslist:getSelectLine();
	if SelectLine >= 0 then
		local SelectName = lsbfriendslist:getLineItemText(SelectLine, 0);
		uiItemReleaseItem(id, SelectName);
		frmBlessingsCard:Hide();
	else
		self:Disable();
	end
end

function layWorld_frmBlessingsCard_lboption_btnenter_OnUpdate(self)
	layWorld_frmBlessingsCard_lboption_btnenter_Refresh(self);
end

function layWorld_frmBlessingsCard_lboption_btnenter_Refresh(self)
	if self == nil then self = uiGetglobal("layWorld.frmBlessingsCard.lboption.btnenter") end
	local lsbfriendslist = SAPI.GetSibling(self, "lsbfriendslist");
	if lsbfriendslist:getSelectLine() >= 0 then
		self:Enable()
	else
		self:Disable();
	end
end

function layWorld_frmBlessingsCard_lboption_btnclose_OnLClick(self)
	local frmBlessingsCard = SAPI.GetParent(SAPI.GetParent(self));
	frmBlessingsCard:Hide();
end







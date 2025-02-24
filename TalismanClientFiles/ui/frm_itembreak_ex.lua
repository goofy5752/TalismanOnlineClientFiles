
function layWorld_frmItemBreakEx_btOk_OnLClick(self)
	local form = SAPI.GetParent(self);
	local id = form:Get(EV_UI_ITEM_DIVIDE_ID_KEY);
	if id == nil or id == 0 then return end
	local ebCount = SAPI.GetSibling(self, "ebCount");
	local count = tonumber(ebCount:getText());
	TemplateBtnUserItem_API_DragOutToDivide(id, count);
	SAPI.GetParent(self):Hide();
end

function layWorld_frmItemBreakEx_btCancel_OnLClick(self)
	SAPI.GetParent(self):Hide();
end

function layWorld_frmItemBreakEx_ebCount_OnUpdate(self)
	local text = self:getText();
	if text == "" then return end
	local count = tonumber(text);
	if count == nil then self:SetText("1") return end
	if count == 0 then return end
	
	local form = SAPI.GetParent(self);
	local id = form:Get(EV_UI_ITEM_DIVIDE_ID_KEY);
	if id == nil or id == 0 then return end
	local iteminfo = uiItemGetBagItemInfoByObjectId(id);
	if iteminfo == nil then return end
	if count == nil then count = 1 end
	if count > iteminfo.Count-1 then count = iteminfo.Count-1 end
	if count < 1 then count = 1 end
	if text == tostring(count) then return end
	self:SetText(tostring(count));
end

function layWorld_frmItemBreakEx_btMinus_OnLClick(self)
	local form = SAPI.GetParent(self);
	local id = form:Get(EV_UI_ITEM_DIVIDE_ID_KEY);
	if id == nil or id == 0 then return end
	local ebCount = SAPI.GetSibling(self, "ebCount");
	local count = tonumber(ebCount:getText());
	count = count - 1;
	if count < 1 then count = 1 end
	ebCount:SetText(tostring(count));
end

function layWorld_frmItemBreakEx_btPlus_OnLClick(self)
	local form = SAPI.GetParent(self);
	local id = form:Get(EV_UI_ITEM_DIVIDE_ID_KEY);
	if id == nil or id == 0 then return end
	local iteminfo = uiItemGetBagItemInfoByObjectId(id);
	if iteminfo == nil then return end
	local ebCount = SAPI.GetSibling(self, "ebCount");
	local count = tonumber(ebCount:getText());
	count = count + 1;
	if count > iteminfo.Count-1 then count = iteminfo.Count-1 end
	ebCount:SetText(tostring(count));
end

function layWorld_frmItemBreakEx_OnShow(self)
	local ID = self:Get(EV_UI_ITEM_DIVIDE_ID_KEY);
	if not ID or ID == 0 then self:Hide() return end
	LClass_ItemFreezeManager:Push(ID);
	local ebCount = SAPI.GetChild(self, "ebCount");
	ebCount:SetText("1");
end

function layWorld_frmItemBreakEx_OnHide(self)
	local ID = self:Get(EV_UI_ITEM_DIVIDE_ID_KEY);
	if not ID or ID == 0 then self:Hide() return end
	LClass_ItemFreezeManager:Erase(ID);
	self:Delete(EV_UI_ITEM_DIVIDE_ID_KEY);
end










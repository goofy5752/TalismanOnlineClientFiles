local HelpWidgetMaxCount = 5;

local HelpWidgetList =
{
	list = {},
	Insert = function(self, t)
		table.insert(self.list, t);
		--table.sort(self.list, function (first, second) return first.Wait > second.Wait end)
	end,
}

local HelpHintList =
{
	list = {},
	Insert = function(self, t)
		table.insert(self.list, t);
		--table.sort(self.list, function (first, second) return first.Wait > second.Wait end)
		return self:Size();
	end,
	Tick = function (self, delta)
		local size = table.getn(self.list);
		local v = nil;
		local i = 1;
		while i <= size do
			v = self.list[i];
			if v.Run == nil then v.Run = 0 end
			v.Run = v.Run + delta;
			v.Wait = v.Wait - delta;
			if v.Wait <= 0 then
				table.remove(self.list, i);
				size = table.getn(self.list);
			else
				i = i + 1;
			end
		end
	end,
	Size = function (self)
		return table.getn(self.list);
	end,
	FindByWidget = function (self, Widget)
		for i, v in ipairs(self.list) do
			if v.Widget:getName() == Widget:getName() then return v end
		end
		return nil;
	end,
};

function layWorld_lbHelp_OnLoad(self)
	self:RegisterScriptEventNotify("EVENT_ShowUiHelpHint");
	self:RegisterScriptEventNotify("EVENT_UserHelpDataChenged");
	for i = 1, HelpWidgetMaxCount, 1 do
		HelpWidgetList:Insert({Kuang=SAPI.GetChild(self, "Kuang"..i), Hint=SAPI.GetChild(self, "Hint"..i)});
	end
	uiSetToTop(self);
end

function layWorld_lbHelp_OnEvent(self, event, args)
	if event == "EVENT_ShowUiHelpHint" then
		local name = args[1];
		local hint = args[2];
		local wait = args[3];
		local id = uiUserHelpGetCurrentCaptureId();
		local widget = uiGetglobal(name);
		if HelpHintList:Size() >= HelpWidgetMaxCount then uiInfo(">"..tostring(HelpWidgetMaxCount)) return end
		if widget then
			local HelpHint = HelpHintList:FindByWidget(widget);
			if HelpHint then
				HelpHint.Wait = wait;
				HelpHint.Text = hint;
				HelpHint.BindIndex = nil;
			else
				local newHelpHint = {Widget=widget,Wait=wait,Text=hint,Id=id};
				local size = HelpHintList:Insert(newHelpHint);
				--HelpWidgetList.list[size].Hint:SetText(hint);
				--local rect = EvUiLuaClass_Rect:new(uiGetWidgetRect(HelpWidgetList.list[size].Hint));
				--newHelpHint.HintRect = rect;
			end
		else
			uiError("Can't find widget with name = '"..tostring(name).."'");
		end
	elseif event == "EVENT_UserHelpDataChenged" then
		local SysPtr = uiUserHelpGetSystemPtr();
		if not SysPtr or not SysPtr:IsOpen() then
			self:Hide();
		else
			self:Show();
		end
	end
end

function layWorld_lbHelp_OnUpdate(self, delta)
	HelpHintList:Tick(delta);
	local rectView = EvUiLuaClass_Rect:new(uiGetGameViewRect());
	for i = 1, HelpWidgetMaxCount, 1 do
		local HelpWidget = HelpWidgetList.list[i];
		if i <= HelpHintList:Size() then
			local Temp = HelpHintList.list[i];
			HelpWidget.Kuang:Show();
			HelpWidget.Hint:Show();
			if Temp.Widget:getVisible() == false then
				HelpWidget.Kuang:Hide();
				HelpWidget.Hint:Hide();
			else
				local t = math.floor(math.mod(Temp.Run / 250, 20))
				if t == 0 or t == 2 or t == 4 then
					HelpWidget.Kuang:Hide();
					HelpWidget.Hint:Show();
				else
					HelpWidget.Kuang:Show();
					HelpWidget.Hint:Show();
				end
				if Temp.BindIndex == nil or Temp.BindIndex ~= i then
					HelpWidget.Hint:SetText(Temp.Text);
					Temp.BindIndex = i;
					Temp.HintRect = EvUiLuaClass_Rect:new(uiGetWidgetRect(HelpWidget.Hint));
				end
				local x, y, w, h = uiGetWidgetRect(Temp.Widget);
				HelpWidget.Kuang:MoveSize(x-5, y-5, w+10, h+10);
				local rectHint = Temp.HintRect;
				rectHint.x = x - 5--[[ - rectHint.width]];
				if rectHint.x < 0 then rectHint.x = 0 end
				rectHint.y = y - rectHint.height - 15;
				if rectHint.y < 0 then
					if w > rectView.height * 0.5 then
						rectHint.y = 0;
					else
						rectHint.y = y + h + 6;
					end
				end
				--if rectHint.y < 0 then rectHint.y = 0 end
				if rectHint:GetRight() > rectView:GetRight() then rectHint.x = rectHint.x - (rectHint:GetRight() - rectView:GetRight()) end
				if rectHint:GetBottom() > rectView:GetBottom() - 10 then rectHint.y = rectHint.y - (rectHint:GetBottom() - rectView:GetBottom() + 10) end
				HelpWidget.Hint:MoveSize(rectHint.x, rectHint.y, rectHint.width, rectHint.height);
			end
		else
			HelpWidget.Kuang:Hide();
			HelpWidget.Hint:Hide();
		end
	end
	if HelpHintList:Size() == 0 then
		local CurCaptureId = uiUserHelpGetCurrentCaptureId();
		if CurCaptureId and CurCaptureId > 0 then
			SAPI.GetChild(self, "bgButton"):Show();
		else
			SAPI.GetChild(self, "bgButton"):Hide();
		end
	else
		SAPI.GetChild(self, "bgButton"):Show();
	end
end

function layWorld_lbHelp_bgButton_ebStepDesc_OnUpdate(self)
	local EntryTitle = "";
	local EntryDesc = "";
	local FocusEntryId = self.FocusEntryId;
	local CurEntryId = nil;
	local SysPtr = uiUserHelpGetSystemPtr();
	if SysPtr then
		CurEntryId = SysPtr:GetCurrentEntryId(); -- 找出当前的科目ID
	end
	if CurEntryId and FocusEntryId == CurEntryId then return end
	FocusEntryId = CurEntryId;
	local Id, Title, Description = uiUserHelpGetEntryInfo(FocusEntryId);
	if Id then
		EntryTitle = Title;
		EntryDesc = Description;
	end
	--RichText
	local rich_text = EvUiLuaClass_RichText:new();
	if EntryTitle and EntryTitle ~= "" then
		local line = EvUiLuaClass_RichTextLine:new();
		local item = EvUiLuaClass_RichTextItem:new();
		item.Type = "TEXT";
		item.Color = "#FF00FF00";
		item.Text = "["..EntryTitle.."]";
		line:InsertItem(item);
		rich_text:InsertLine(line);
	end
	if EntryDesc and EntryDesc ~= "" then
		local line = EvUiLuaClass_RichTextLine:new();
		local item = EvUiLuaClass_RichTextItem:new();
		item.Type = "TEXT";
		item.Color = "#FFFFFF00";
		item.Text = EntryDesc;
		line:InsertItem(item);
		rich_text:InsertLine(line);
	end
	
	self:SetRichText(rich_text:ToRichString(), false);
	self.FocusEntryId = FocusEntryId;
end

local CaptureIdList = {};
local CaptureList = {};
local function RefreshHelpTest(self)
	CaptureIdList = {};
	CaptureIdList = uiUserHelpGetCaptureList();
	local Id, Active, Finish, Title, Description, StepCount, Step = nil;
	local Capture = nil;
	for i, v in ipairs(CaptureIdList) do
		if CaptureList[v] == nil then CaptureList[v] = {} end
		Capture = CaptureList[v];
		Id, Active, Finish, Title, Description, StepCount, Step = uiUserHelpGetCaptureInfo(v);
		Capture.Id = Id;
		Capture.Active = Active;
		Capture.Finish = Finish;
		Capture.Title = Title;
		Capture.Description = Description;
		Capture.StepCount = StepCount;
		Capture.Step = Step;
	end
	
	local lsCaptureList = SAPI.GetChild(self, "lsCaptureList");
	local SelectedId = 0;
	local selectline = lsCaptureList:getSelectLine();
	if selectline and selectline >= 0 then
		SelectedId = tonumber(lsCaptureList:getLineItemText(selectline, 0));
	end
	lsCaptureList:RemoveAllLines(false);
	local Capture = nil;
	for i, v in ipairs(CaptureIdList) do
		local line = i - 1;
		local col = 0;
		local value = "";
		local color = 4294967295;
		Capture = CaptureList[v];
		if Capture.Active then
			color = 4294967040;
		elseif Capture.Finish then
			color = 4278255360;
		end
		lsCaptureList:InsertLine(-1,-1,-1);
		if SelectedId == Capture.Id then lsCaptureList:SetSelect(line) end
		value = tostring(Capture.Id);
		lsCaptureList:SetLineItem(line, col, value, color);
		col = col + 1;
		value = Capture.Title;
		lsCaptureList:SetLineItem(line, col, value, color);
		col = col + 1;
		if Capture.Active then
			value = "激活"
		elseif Capture.Finish then
			if Capture.Step ~= Capture.StepCount then
				value = "跳过";
			else
				value = "完成"
			end
		else
			value = "正常"
		end
		lsCaptureList:SetLineItem(line, col, value, color);
		col = col + 1;
		value = Capture.Description;
		lsCaptureList:SetLineItem(line, col, value, color);
		col = col + 1;
		value = string.format("%d/%d", Capture.Step, Capture.StepCount);
		lsCaptureList:SetLineItem(line, col, value, color);
	end
end
function layWorld_frmHelpTest_OnShow(self)
	RefreshHelpTest(self);
end

function layWorld_frmHelpTest_OnUpdate(self, delta)
	RefreshHelpTest(self);
end

function layWorld_frmHelpTest_btActive_OnLClick(self)
	local lsCaptureList = SAPI.GetSibling(self, "lsCaptureList");
	local select = lsCaptureList:getSelectLine();
	local id = nil;
	if select >= 0 then	
		id = CaptureIdList[select+1];
	end
	if id then
		uiUserHelpActiveCapture(id);
	end
	layWorld_frmHelpTest_OnShow(SAPI.GetParent(self))
end

function layWorld_frmHelpTest_btSkip_OnLClick(self)
	local lsCaptureList = SAPI.GetSibling(self, "lsCaptureList");
	local select = lsCaptureList:getSelectLine();
	local id = nil;
	if select >= 0 then	
		id = CaptureIdList[select+1];
	end
	if id then
		uiUserHelpCloseCapture(id);
	end
	layWorld_frmHelpTest_OnShow(SAPI.GetParent(self))
end

function layWorld_frmHelpTest_btRefresh_OnLClick(self)
	RefreshHelpTest(SAPI.GetParent(self));
end


--------------------


NewPlayerAPI = {};
function NewPlayerAPI:Close()
	for i, v in ipairs(HelpHintList.list) do
		v.Wait = 0;
	end
	local SysPtr = uiUserHelpGetSystemPtr();
	if SysPtr then
		SysPtr:Close();
	end
end
function NewPlayerAPI:Open()
	local SysPtr = uiUserHelpGetSystemPtr();
	if SysPtr then
		SysPtr:Open();
	end
end
function NewPlayerAPI:Skip()
	for i, v in ipairs(HelpHintList.list) do
		v.Wait = 0;
		uiUserHelpCloseCapture(v.Id);
	end
	local id = uiUserHelpGetCurrentCaptureId();
	if id and id > 0 then
		uiUserHelpCloseCapture(id);
	end
end

function layWorld_lbFirstPlayShow_btOpenUserHelp_OnLClick(self)
	NewPlayerAPI:Open();
	SAPI.GetParent(self):Hide();
	local frmFirstPlayGuide = uiGetglobal("layWorld.frmFirstPlayGuide");
	frmFirstPlayGuide:ShowAndFocus();
	frmFirstPlayGuide.LeftTime = 15000;
	uiUserHelpInteractiveByClassId(3103);
end

function layWorld_lbFirstPlayShow_btCloseUserHelp_OnLClick(self)
	NewPlayerAPI:Close();
	SAPI.GetParent(self):Hide();
end

function layWorld_lbHelp_frmBackground_btResizeV_OnLDown(self, mouse_x, mouse_y)
	local x, y = uiGetWidgetRect(self);
	self:Set("MouseOffset", {x = mouse_x - x, y = mouse_y - y});
end

function layWorld_lbHelp_frmBackground_btResizeV_OnMouseMove(self, mouse_x, mouse_y, delta_x, delta_y)
	if self:IsCaptured() then
		local target = SAPI.GetParent(self);
		local rcOld = EvUiLuaClass_Rect:new(uiGetWidgetRect(target));
		local rcOldSelf = EvUiLuaClass_Rect:new(uiGetWidgetRect(self));
		local offset = self:Get("MouseOffset");
		local _y = mouse_y - (rcOldSelf.y + offset.y);
		target:SetSize_Offset(0, -_y);
		local rcNew = EvUiLuaClass_Rect:new(uiGetWidgetRect(target));
		target:MoveTo_Offset(0, rcOld:GetHeight() - rcNew:GetHeight());
		local ebStepDesc = SAPI.GetSibling(target, "ebStepDesc");
		ebStepDesc:ScrollToTop();
		--SClass_ChannelGroup:OnChannelFrameResize(target); 
	end
end

function layWorld_lbHelp_frmBackground_OnLDown(self, mouse_x, mouse_y)
	local x, y = uiGetWidgetRect(self);
	self:Set("MouseOffset", {x = mouse_x - x, y = mouse_y - y});
end

function layWorld_lbHelp_frmBackground_OnMouseMove(self, mouse_x, mouse_y, delta_x, delta_y)
	if self:IsCaptured() then
		local x, y, width, height = uiGetWidgetRect(self);
		local offset = self:Get("MouseOffset");
		local _x = mouse_x - (x + offset.x);
		local _y = mouse_y - (y + offset.y);
		local bgButton = SAPI.GetParent(self);
		x, y, width, height = uiGetWidgetRect(bgButton);
		local rectView = EvUiLuaClass_Rect:new(uiGetGameViewRect());
		if x + width + _x > rectView:GetRight() then
			_x = rectView:GetRight() - x - width;
		elseif x + _x < 0 then
			_x = -x;
		end
		if y + height + _y > rectView:GetBottom() then
			_y = rectView:GetBottom() - y - height;
		elseif y + _y - 50 < 0 then
			_y = 50 - y;
		end
		bgButton:MoveTo_Offset(_x, _y);
	end
end















local LOCAL_CHAT_CHANNEL_BUTTON_WIDTH = 54;
local LOCAL_CHAT_CHANNEL_BUTTON_HEIGHT = 20;
local LOCAL_CHAT_MAX_LINE_COUNT = 500;
local LOCAL_CHAT_DEL_LINE_COUNT = 100;
local LOCAL_CHAT_MAX_VISIBLE_LINE = 40;

local AutoScrollLeft = 0;
local AutoScrollLeftMax = 10000;

local LOCAL_CHAT_CHANNEL_SHORTCUT = 
{
};

local LOCAL_CHAT_CHANNEL_SWITCHSHORTCUT =
{
};

local LOCAL_CHAT_SYSTEM_HISTORY =
{
};

local SClass_Doskey = 
{
	History = {},
	SeekIndex = 0,
	BreakValue = nil,
	MatchValue = nil,
};

---///////////////////////
--      SClass_Doskey functions
--///////////////////////

function SClass_Doskey:new()
	local newObject = {};
	EvUiLuaClassAssistant_SetSuperClass(newObject, SClass_Doskey);
	newObject.History = {};
	newObject.SeekIndex = 0;
	newObject.BreakValue = nil;
	newObject.MatchValue = nil;
	return newObject;
end

function SClass_Doskey:Seek(index)
	if index == nil or type(index) ~= "number" then return end
	self.SeekIndex = index;
	if self.SeekIndex > self:Size() then
		self.SeekIndex = self:Size() + 1
	end
	if self.SeekIndex < 1 then
		self.SeekIndex = 1;
	end
end

function SClass_Doskey:Begin()
	self:Seek(0);
end

function SClass_Doskey:End()
	self:Seek(self:Size() + 1);
end

function SClass_Doskey:SetMatchValue(value)
	self.MatchValue = value;
end

function SClass_Doskey:Match()
	local value = self.History[self.SeekIndex];
	if value ~= nil then
		local MatchValue = self.MatchValue;
		local iFind = string.find(value, "^"..MatchValue);
		if iFind ~= nil then
			return;
		end
	end
	self:Previous();
end

function SClass_Doskey:GetMatchValue()
	return self.MatchValue;
end

function SClass_Doskey:Next(check)
	local index = nil;
	local MatchValue = "";
	local begin = self.SeekIndex;
	if self:Size() == 0 then self:End() return end
	if self.MatchValue ~= nil then
		local MatchValue = self.MatchValue;
		for i = self.SeekIndex + 1, self:Size(), 1 do
			local iFind = string.find(self.History[i], "^"..MatchValue);
			if iFind ~= nil then
				index = i;
				break;
			end
		end
	else
		index = self.SeekIndex + 1;
	end
	if index == nil then
		self:End();
	else
		self:Seek(index);
	end
end

function SClass_Doskey:Previous()
	local index = nil;
	local MatchValue = "";
	if self:Size() == 0 then self:End() return end
	if self.MatchValue ~= nil then
		local MatchValue = self.MatchValue;
		for i = self.SeekIndex - 1, 1, -1 do
			local iFind = string.find(self.History[i], "^"..MatchValue);
			if iFind ~= nil then
				index = i;
				break;
			end
		end
		if index == nil then
			for i = self.SeekIndex, self:Size(), 1 do
				local iFind = string.find(self.History[i], "^"..MatchValue);
				if iFind ~= nil then
					index = i;
					break;
				end
			end
		end
	else
		index = self.SeekIndex - 1;
	end
	if index == nil then
		self:End();
	else
		self:Seek(index);
	end
end

function SClass_Doskey:Size()
	return table.getn(self.History);
end

function SClass_Doskey:SetBreakValue(value)
	self.BreakValue = value;
end

function SClass_Doskey:GetBreakValue()
	return self.BreakValue;
end

function SClass_Doskey:Value()
	local res = nil;
	if self.SeekIndex > 0 and self.SeekIndex <= self:Size() then
		res = self.History[self.SeekIndex];
	else
		res = self:GetBreakValue();
	end
	return res;
end

function SClass_Doskey:AppendHistory(value)
	if value == nil then return end
	local exist, index = SAPI.ExistInTable(self.History, value);
	if exist == true then
		table.remove(self.History, index);
	end
	table.insert(self.History, value);
end

local LOCAL_ChatDoskey_Name = SClass_Doskey:new();
local LOCAL_ChatDoskey_Content = SClass_Doskey:new();


--///////////////////////////////////////////
--///////////////////////////////////////////
--///////////////////////////////////////////
--///////////////////////////////////////////



local SClass_Channel = -- ChannelPage
{
	CurrentChannel = nil, -- ChannelPage
	SendChannelId = 1,
	SendName = "";
	DefaultChannel = nil,
};

local SClass_ChannelHint =
{
	HintFrame = nil,
	HintOwner = nil,
	RelativeData = nil, -- 关联数据 用于判断两次显示的是否同一个hint
};

local SClass_ChannelFilter = -- ChannelPage
{
	FilterFrame = nil,
	FilterOwner = nil,
};

local SClass_ChannelGroup =  -- ChannelPage
{
	bChanged = false,
	list = {},
	CurrentChannel = nil, -- ChannelPage
	GroupArea = nil,	-- 一个widget
	MainFrame = nil,
	LockChannelPage = nil,
};

---///////////////////////
--      SClass_Channel
--///////////////////////

function SClass_Channel:Reset()
	self.CurrentChannel = nil;
	self.SendChannelId = 1;
	self.SendName = "";
	LockChannelPage = nil;
end

function SClass_Channel:SetSendName(name)
	self.SendName = name;
end

function SClass_Channel:GetSendName()
	return self.SendName;
end

function SClass_Channel:SetCurrentChannel(channel)
	self.CurrentChannel = channel;
	SClass_ChannelGroup:SetCurrentChannel(channel);
	self:SetSendChannelIdByChannelPage(channel);
end

function SClass_Channel:GetCurrentChannel()
	return self.CurrentChannel;
end

function SClass_Channel:SetSendChannelIdByChannelPage(channel)
	if channel ~= nil then
		local pageid = channel:Get("ID");
		if pageid == nil or uiChatIsValidChannelPage(pageid) == false then return end
		local _pageid, channelid, _, send_channel = uiChatGetChannelPageInfo(pageid);
		if pageid ~= _pageid then return end
		self:SetSendChannelId(send_channel);
	end
end

function SClass_Channel:SetSendChannelId(id)
	if id == nil then
		id = 1; -- 默认值是1
	elseif uiChatIsValidChannel(id) == false then
		return;
	elseif id == 7 then -- 系统频道
		return;
	end
	self.SendChannelId = id;
	uiChatSetSendChannel(self.SendChannelId);
end

function SClass_Channel:GetCurrentChannelId()
	if self.SendChannelId == nil or uiChatIsValidChannel(self.SendChannelId) == false then return 1 end
	return self.SendChannelId;
end

function SClass_Channel:SetDefaultChannel(channel)
	self.DefaultChannel = channel;
end

function SClass_Channel:GetDefaultChannel()
	return self.DefaultChannel;
end

---///////////////////////
--      SClass_ChannelHint
--///////////////////////

function SClass_ChannelHint:Reset()
	HintOwner = nil;
end

function SClass_ChannelHint:SetHintFrame(frame)
	self.HintFrame = frame;
end

function SClass_ChannelHint:GetHintFrame(frame)
	return self.HintFrame;
end

function SClass_ChannelHint:SetHintRichText(rich_text, relative_data)
	local HintFrame = self.HintFrame;
	if HintFrame == nil then return end
	local CurRelativeData = self.RelativeData;
	self.RelativeData = relative_data;
	if self.HintFrame:getVisible() == true and relative_data ~= nil and SAPI.Equal(relative_data, CurRelativeData) == true then
		self.RelativeData = nil;
		self:ClearHintOwner();
		return;
	end
	if rich_text == nil or type(rich_text) ~= "userdata" then
		self:ClearHintOwner();
		return;
	end
	HintFrame:SetRichTextEx(rich_text);
end

function SClass_ChannelHint:SetHintOwner(channel)
	if channel == nil then self:ClearHintOwner() return end
	self.HintOwner = channel;
end

function SClass_ChannelHint:ClearHintOwner()
	local HintFrame = self.HintFrame;
	self.HintOwner = nil;
	if HintFrame == nil or HintFrame:getVisible() ~= true then return end
	HintFrame:Hide();
end

function SClass_ChannelHint:GetHintOwner()
	return self.HintOnwer;
end

function SClass_ChannelHint:ShowHintFrame()
	local HintFrame = self.HintFrame;
	local HintOwner = self.HintOwner;
	if HintFrame == nil then return end
	if HintOwner == nil then HintFrame:Hide() return end
	
	self:HintFrameAutoFollow();
	HintFrame:ShowAndFocus();
end

function SClass_ChannelHint:HintFrameAutoFollow()
	local HintFrame = self.HintFrame;
	local HintOwner = self.HintOwner;
	if HintFrame == nil then return end
	if HintOwner == nil then HintFrame:Hide() return end
	
	local xOwner, yOwner, wOwner, hOwner = uiGetWidgetRect(HintOwner);
	local _, _, wHint, hHint = uiGetWidgetRect(HintFrame);
	local xView, yView, wView, hView = uiGetGameViewRect();
	local x = xOwner + wOwner + 5;
	local y = yOwner + hOwner - hHint;
	if x + wHint > wView then x = xOwner - wHint - 5 end
	if y < 0 then y = 0 end
	HintFrame:MoveTo(x, y);
end

---///////////////////////
--      SClass_ChannelFilter
--///////////////////////

function SClass_ChannelFilter:Reset()
	FilterOwner = nil;
end

function SClass_ChannelFilter:SetFilterFrame(frame)
	self.FilterFrame = frame;
end

function SClass_ChannelFilter:ClearFilterOwner()
	self.FilterOwner = nil;
	local FilterFrame = self.FilterFrame;
	if FilterFrame == nil then return end
	FilterFrame:Hide();
end

function SClass_ChannelFilter:SetFilterOwner(channel)
	if SAPI.Equal(channel, SClass_ChannelGroup.MainFrame) == true then channel = SClass_ChannelGroup.CurrentChannel end
	if channel == nil then self:ClearFilterOwner() return end
	self.FilterOwner = channel;
	local FilterFrame = self.FilterFrame;
	if FilterFrame:getVisible() == true then
		self:UpdateFilter();
		self:FilterFrameAutoFollow();
	end
end

function SClass_ChannelFilter:ShowFilterFrame()
	local FilterFrame = self.FilterFrame;
	local FilterOwner = self.FilterOwner;
	if FilterFrame == nil then return end
	if FilterOwner == nil then FilterFrame:Hide() return end
	
	self:UpdateFilter();
	self:FilterFrameAutoFollow();
	FilterFrame:ShowAndFocus();
end

function SClass_ChannelFilter:SwitchFilterFrame()
	local FilterFrame = self.FilterFrame;
	if FilterFrame == nil then return end
	
	if FilterFrame:getVisible() == true then
		self:HideFilterFrame();
	else
		self:ShowFilterFrame();
	end
end

function SClass_ChannelFilter:HideFilterFrame()
	local FilterFrame = self.FilterFrame;
	local FilterOwner = self.FilterOwner;
	if FilterFrame == nil then return end
	if FilterOwner == nil then FilterFrame:Hide() return end
	
	self:ClearFilterOwner();
end

function SClass_ChannelFilter:IsOwner(channel)
	if channel == nil then return false end
	if SAPI.Equal(channel, SClass_ChannelGroup.MainFrame) == true then
		return SClass_ChannelGroup:Contain(self.FilterOwner);
	else
		return SAPI.Equal(channel, self.FilterOwner);
	end
end

function SClass_ChannelFilter:UpdateFilter()
	local FilterFrame = self.FilterFrame;
	local FilterOwner = self.FilterOwner;
	if FilterFrame == nil then return end
	if FilterOwner == nil then FilterFrame:Hide() return end
	
	local pageid = FilterOwner:Get("ID");
	if pageid == nil or pageid == 0 then self:ClearFilterOwner() return end
	
	for i = 1,14,1 do
		local ckFilter = SAPI.GetChild(FilterFrame, ("cbChannelFilter"..i));
		if ckFilter ~= nil then
			TemplateChannelFilterCheckButton_Refresh(ckFilter);
		end
	end
end

function SClass_ChannelFilter:FilterFrameAutoFollow()
	local FilterFrame = self.FilterFrame;
	local FilterOwner = self.FilterOwner;
	if FilterFrame == nil then return end
	if FilterOwner == nil then FilterFrame:Hide() return end
	
	if SClass_ChannelGroup.Contain(FilterOwner) == true then FilterOwner = SClass_ChannelGroup.MainFrame end
	
	local xOwner, yOwner, wOwner, hOwner = uiGetWidgetRect(FilterOwner);
	local _, _, wFilter, hFilter = uiGetWidgetRect(FilterFrame);
	local xView, yView, wView, hView = uiGetGameViewRect();
	local x = xOwner + 25;
	local y = yOwner + hOwner - 25 - hFilter;
	if x + wFilter > wView then x = wView - wFilter end
	if y < 0 then y = 0 end
	FilterFrame:MoveTo(x, y);
end

function SClass_ChannelFilter:GetFilterOwner()
	return self.FilterOwner;
end

---///////////////////////
--      SClass_ChannelGroup
--///////////////////////

function SClass_ChannelGroup:Reset()
	self.bChanged = false;
	self.list = {};
	self.CurrentChannel = nil;
	self.GroupArea = nil;	-- 一个widget
	self.MainFrame = nil;
end

function SClass_ChannelGroup:SetGroupArea(GroupArea)
	self.GroupArea = GroupArea;
end

function SClass_ChannelGroup:SetMainFrame(MainFrame)
	self.MainFrame = MainFrame;
end

function SClass_ChannelGroup:CheckIn(channel_button)
	if channel_button == nil then return false end
	if self.GroupArea == nil then return false end
	
	local x, y, width, height = uiGetWidgetRect(self.GroupArea);
	local rcGroup = EvUiLuaClass_Rect:new(x, y, width, height);
	x, y, width, height = uiGetWidgetRect(channel_button);
	local rcChannel = EvUiLuaClass_Rect:new(x, y, width, height);
	
	local isIntersect = rcGroup:IsIntersect(rcChannel);
	
	return isIntersect;
end

function SClass_ChannelGroup:Add(channel)
	if channel == nil then return false end
	local indexFind = SAPI.GetIndexInTable(self.list, channel);
	if indexFind ~= 0 then table.remove(self.list, indexFind) end
	local rcMainFrame = EvUiLuaClass_Rect:new(uiGetWidgetRect(self.MainFrame));
	local rcChannel = EvUiLuaClass_Rect:new(uiGetWidgetRect(channel));
	
	local lbMainPageButtons = SAPI.GetChild(self.MainFrame, "lbPageButtons");
	local rcLocalMainPageButtons = EvUiLuaClass_Rect:new(uiGetWidgetLocalRect(lbMainPageButtons)); -- 取得相对父控件的坐标
	
	local lbSubPageButtons = SAPI.GetChild(channel, "lbPageButtons");
	local rcLocalSubPageButtons = EvUiLuaClass_Rect:new(uiGetWidgetLocalRect(lbSubPageButtons)); -- 取得相对父控件的坐标
	
	local PageButtonsOffsetX = rcLocalSubPageButtons.x - rcLocalMainPageButtons.x; -- 计算主窗口和子窗口同一控件"lbPageButtons"之间的偏移量
	
	local ChannelButton = SAPI.GetChild(lbSubPageButtons, "cbHistory");
	local rcChannelButton = EvUiLuaClass_Rect:new(uiGetWidgetLocalRect(ChannelButton));
	local index = (rcChannel.x - rcMainFrame.x + rcChannelButton.x + PageButtonsOffsetX) / LOCAL_CHAT_CHANNEL_BUTTON_WIDTH + 1;
	if index < 1 then
		index = 1;
	elseif index > table.getn(self.list) + 1 then
		index = table.getn(self.list) + 1;
	elseif index - math.floor(index) < 0.5 then
		index = math.floor(index);
	else
		index = math.ceil(index);
	end
	
	table.insert(self.list, index, channel);
	SAPI.GetChild(channel, "wtBgDisplay"):HideDirect();
	SAPI.GetChild(channel, "wtBgDisplayEx"):HideDirect();
	SAPI.GetChild(channel, "ebDisplay"):HideDirect();
	SAPI.GetChild(channel, "wtToolsBottom"):HideDirect();
	SAPI.GetChild(channel, "wtToolsTop"):HideDirect();
	SClass_ChannelGroup.bChanged = true;
	
	if self.CurrentChannel == nil then
		self:SetCurrentChannel(channel);
	end
	
	local wtToolsTop = SAPI.GetChild(self.MainFrame, "wtToolsTop");
	local wtBgDisplayEx = SAPI.GetChild(self.MainFrame, "wtBgDisplayEx");
	if table.getn(self.list) == 0 then
		wtToolsTop:HideDirect();
		wtBgDisplayEx:ShowDirect();
	else
		wtToolsTop:Show();
		wtBgDisplayEx:HideDirect();
	end
	
	self:ShowDirect();
	
	return true;
end

function SClass_ChannelGroup:Erase(channel)
	if channel == nil then return false end
	local index = SAPI.GetIndexInTable(self.list, channel);
	if index == 0 then return false end
	table.remove(self.list, index);
	SAPI.GetChild(channel, "wtBgDisplay"):ShowDirect();
	--SAPI.GetChild(channel, "wtBgDisplayEx"):ShowDirect();
	SAPI.GetChild(channel, "ebDisplay"):ShowDirect();
	SAPI.GetChild(channel, "wtToolsBottom"):ShowDirect();
	--SAPI.GetChild(channel, "wtToolsTop"):ShowDirect();
	
	if SAPI.Equal(channel, self.CurrentChannel) then
		self:SetCurrentChannel(nil);
		if table.getn(self.list) > 0 then
			self:SetCurrentChannel(self.list[1]); -- 默认使用第一个
		end
	end
	SClass_ChannelGroup.bChanged = true;
	
	local wtToolsTop = SAPI.GetChild(self.MainFrame, "wtToolsTop");
	local wtBgDisplayEx = SAPI.GetChild(self.MainFrame, "wtBgDisplayEx");
	if table.getn(self.list) == 0 then
		wtToolsTop:HideDirect();
		wtBgDisplayEx:ShowDirect();
	else
		wtToolsTop:ShowDirect();
		wtBgDisplayEx:HideDirect();
	end
	
	self:ShowDirect();
	
	return true;
end

function SClass_ChannelGroup:Contain(channel)
	if channel == nil then return false end
	local index = SAPI.GetIndexInTable(self.list, channel);
	if index == 0 then return false end
	return true;
end

function SClass_ChannelGroup:SetCurrentChannel(channel)
	if channel ~= nil then
		local index = SAPI.GetIndexInTable(self.list, channel);
		if index == 0 then return false end
	end
	self.CurrentChannel = channel;
	
	self.bChanged = true;
	
	return true;
end

function SClass_ChannelGroup:OnChannelFrameMove(main_channel)
	if main_channel == nil or self.MainFrame == nil then return end
	
	if SAPI.Equal(self.MainFrame, main_channel) then
		for i, v in ipairs(self.list) do
			local x, y, w, h = uiGetWidgetLocalRect(main_channel)
			v:MoveSize(x, y, w, h);
			local ebDisplay = SAPI.GetChild(v, "ebDisplay");
			if uiGetConfigureEntry("chat", "ScrollToBottom") == "true" then
				ebDisplay:ScrollToBottom();
			end
		end
	end
	
	SClass_ChannelFilter:FilterFrameAutoFollow();
	SClass_ChannelHint:HintFrameAutoFollow();
end
--[[
function SClass_ChannelGroup:OnChannelFrameResize(main_channel)
	if main_channel == nil or self.MainFrame == nil then return end
	
	if SAPI.Equal(self.MainFrame, main_channel) then
		for i, v in ipairs(self.list) do
			local x, y, w, h = uiGetWidgetLocalRect(main_channel)
			v:MoveSize(x, y, w, h);
			local ebDisplay = SAPI.GetChild(v, "ebDisplay");
			if uiGetConfigureEntry("chat", "ScrollToBottom") == "true" then
			ebDisplay:ScrollToBottom();
			end
		end
	end
end
]]

function SClass_ChannelGroup:Hide(--[[main_channel]]) -- 隐藏多余的界面
	if self.MainFrame == nil then return end
	if self.CurrentChannel == nil then return end
	--SAPI.GetChild(self.CurrentChannel, "wtBgDisplay"):Hide();
	--SAPI.GetChild(self.MainFrame, "wtToolsTop"):Hide();
	if not self.AutoHide then return end
	--if main_channel == nil or self.MainFrame == nil then return end
	--if SAPI.Equal(self.MainFrame, main_channel) then
		for i, v in ipairs(self.list) do
			local lbPageButtons = SAPI.GetChild(v, "lbPageButtons");
			lbPageButtons:Hide();
		end
	--end
	
	if table.getn(self.list) == 0 then	-- 已经没有子窗口了,把自己的工具Show出来
		SAPI.GetChild(self.MainFrame, "wtToolsBottom"):Show();
		SAPI.GetChild(self.MainFrame, "wtToolsTop"):HideDirect();
		SAPI.GetChild(self.MainFrame, "wtBgDisplayEx"):Show();
		return
	end
	SAPI.GetChild(self.MainFrame, "wtToolsBottom"):Hide();
	--SAPI.GetChild(self.MainFrame, "wtToolsTop"):Hide();
	
	--SAPI.GetChild(self.CurrentChannel, "wtBgDisplay"):Hide();
end

function SClass_ChannelGroup:Show(--[[main_channel]]) -- 显示多余的界面
	if self.MainFrame == nil then return end
	if self.CurrentChannel == nil then return end
	--SAPI.GetChild(self.CurrentChannel, "wtBgDisplay"):Show();
	--SAPI.GetChild(self.MainFrame, "wtToolsTop"):Show();
	if not self.AutoHide then return end
	--if main_channel == nil or self.MainFrame == nil then return end
	--if SAPI.Equal(self.MainFrame, main_channel) then
		for i, v in ipairs(self.list) do
			local lbPageButtons = SAPI.GetChild(v, "lbPageButtons");
			lbPageButtons:Show();
		end
	--end
	if table.getn(self.list) == 0 then	-- 已经没有子窗口了,把自己的工具Show出来
		SAPI.GetChild(self.MainFrame, "wtToolsBottom"):Show();
		SAPI.GetChild(self.MainFrame, "wtToolsTop"):HideDirect();
		SAPI.GetChild(self.MainFrame, "wtBgDisplayEx"):Show();
		return
	end
	
	SAPI.GetChild(self.MainFrame, "wtToolsBottom"):Show();
	--SAPI.GetChild(self.MainFrame, "wtToolsTop"):Show();
	
	--SAPI.GetChild(self.CurrentChannel, "wtBgDisplay"):Show();
end

function SClass_ChannelGroup:ShowDirect(--[[main_channel]]) -- 立即显示多余的界面
	if self.MainFrame == nil then return end
	if self.CurrentChannel == nil then return end
	--SAPI.GetChild(self.CurrentChannel, "wtBgDisplay"):ShowDirect();
	--SAPI.GetChild(self.MainFrame, "wtToolsTop"):ShowDirect();
	if not self.AutoHide then return end
	--if main_channel == nil or self.MainFrame == nil then return end
	--if SAPI.Equal(self.MainFrame, main_channel) then
		for i, v in ipairs(self.list) do
			local lbPageButtons = SAPI.GetChild(v, "lbPageButtons");
			lbPageButtons:ShowDirect();
		end
	--end
	if table.getn(self.list) == 0 then	-- 已经没有子窗口了,把自己的工具Show出来
		SAPI.GetChild(self.MainFrame, "wtToolsBottom"):Show();
		SAPI.GetChild(self.MainFrame, "wtToolsTop"):HideDirect();
		SAPI.GetChild(self.MainFrame, "wtBgDisplayEx"):Show();
		return
	end
	
	SAPI.GetChild(self.MainFrame, "wtToolsBottom"):ShowDirect();
	--SAPI.GetChild(self.MainFrame, "wtToolsTop"):ShowDirect();
	
	--SAPI.GetChild(self.CurrentChannel, "wtBgDisplay"):ShowDirect();
end

--========================================================
--========================================================
--========================================================


function TemplateSendChannelButton_OnLoad(self)
	self:RegisterScriptEventNotify("EVENT_SelfEnterWorld");
end

function TemplateSendChannelButton_OnEvent(self, event, args)
	local id = self:Get("ID");
	if event == "EVENT_SelfEnterWorld" then
		local AutoScrollLeftMax_Entry = tonumber(uiGetConfigureEntry("chat", "AutoScrollLeftMax"));
		if AutoScrollLeftMax_Entry ~= nil then
			AutoScrollLeftMax = AutoScrollLeftMax_Entry;
		end
		if id ~= nil and id ~= 0 and uiChatIsValidChannel(id) == true then
			local _id, color, name = uiChatGetChannelInfo(id);
			self:SetText(name);
		else
			self:SetText("unknown");
		end
	end
end

function TemplateSendChannelButton_OnLClick(self)
	SAPI.GetParent(self):Hide();
	local id = self:Get("ID");
	if id == nil or id == 0 then return end
	if id == 5 then
		local ebInput = uiGetglobal("layWorld.frmChatInput.ebInput");
		local text = ebInput:getText();
		local i, _, name, content = string.find(text, "([^ ][^ ][^ ]+)(.*)$");
		if i then
			SClass_Channel:SetSendName(name);
			ebInput:SetText(content);
		else
			ebInput:SetText("/");
			return;
		end
	elseif id == 7 then	-- 系统频道
		return;
	end
	SClass_Channel:SetSendChannelId(id);
end

function TemplateChannelFilterCheckButton_OnLoad(self)
	self:RegisterScriptEventNotify("EVENT_SelfEnterWorld");
end

function TemplateChannelFilterCheckButton_OnEvent(self, event, args)
	local id = self:Get("ID");
	if event == "EVENT_SelfEnterWorld" then
		if id ~= nil and id ~= 0 and uiChatIsValidChannel(id) == true then
			local _id, color, name, switchshortcut1, switchshortcut2, shortcut1, shortcut2 = uiChatGetChannelInfo(id);
			if not _id or _id ~= id then
				self:Hide();
				local parent = SAPI.GetParent(self);
				for i = 1, 14, 1 do
					local cbChannelFilter = SAPI.GetChild(parent, "cbChannelFilter"..i);
					if cbChannelFilter and self:getShortName() ~= ("cbChannelFilter"..i) then
						local _, top = uiGetWidgetRect(cbChannelFilter);
						local _, top1 = uiGetWidgetRect(self);
						if top > top1 then
							cbChannelFilter:MoveTo_Offset(0, -20);
						end
					end
				end
				parent:SetSize_Offset(0, -20);
			else
				self:SetText(name);
				LOCAL_CHAT_CHANNEL_SHORTCUT[shortcut1] = id;
				LOCAL_CHAT_CHANNEL_SHORTCUT[shortcut2] = id;
				LOCAL_CHAT_CHANNEL_SWITCHSHORTCUT[switchshortcut1] = id;
				LOCAL_CHAT_CHANNEL_SWITCHSHORTCUT[switchshortcut1] = id;
			end
		else
			self:SetText("unknown");
		end
	end
end

function TemplateChannelFilterCheckButton_OnLClick(self)
	local id = self:Get("ID");
	if id == nil or id == 0 then return end
	local FilterOwner = SClass_ChannelFilter:GetFilterOwner();
	if FilterOwner == nil then return end
	local pageid = FilterOwner:Get("ID");
	if self:getChecked() == true then
		uiChatDelFilter(pageid, id);
	else
		uiChatAddFilter(pageid, id);
	end
	TemplateChannelFilterCheckButton_Refresh(self);
end

function TemplateChannelFilterCheckButton_Refresh(self)
	local id = self:Get("ID");
	if id == nil or id == 0 then return end
	local FilterOwner = SClass_ChannelFilter:GetFilterOwner();
	if FilterOwner == nil then return end
	local pageid = FilterOwner:Get("ID");
	if pageid == nil or pageid == 0 then return end
	local _id, bind_channel_id, _, _, filter_list, no_change_filter_list = uiChatGetChannelPageInfo(pageid);
	if _id ~= pageid then return end
	local IsFilter = SAPI.ExistInTable(filter_list, id);
	if IsFilter == true then
		self:SetChecked(false);
	else
		self:SetChecked(true);
	end
	local IsNoChangeFilter = SAPI.ExistInTable(no_change_filter_list, id);
	if IsNoChangeFilter == true then
		self:SetTextColor(4287598479); -- 0xff8f8f8f
		self:Disable();
	else
		self:SetTextColor(4294967295); -- 0xffffffff
		self:Enable();
	end
end

function TemplateChatChannelPageMain_OnLoad(self)
	SClass_ChannelGroup:Reset();
	SClass_ChannelFilter:Reset();
	SClass_ChannelGroup:SetGroupArea(SAPI.GetChild(self, "lbPageButtons"));
	SClass_ChannelGroup:SetMainFrame(self);
end

function TemplateChatChannelPageMain_OnUpdate(self, delta)
	local IsCaptured = false;
	if SClass_ChannelGroup.bChanged == true then
		local pos =
		{
			x=0,
			y=0,
			offset_x = 0,
			offset_y = 0,
			GetX = function(self)
				local offset_x = self.offset_x;
				return self.x + offset_x;
			end,
			GetY = function(self)
				local offset_y = self.offset_y;
				return self.y + offset_y;
			end,
			SetX = function(self, x) self.x = x; end,
			SetY = function(self, y) self.y = y; end,
			SetOffsetX = function(self, x) self.offset_x = x; end,
			SetOffsetY = function(self, y) self.offset_y = y; end,
		};
		local rcMainFrame = EvUiLuaClass_Rect:new(uiGetWidgetRect(self));
		SClass_ChannelGroup.bChanged = false;
		
		local lbMainPageButtons = SAPI.GetChild(self, "lbPageButtons");
		local rcMainLocalPageButtons = EvUiLuaClass_Rect:new(uiGetWidgetLocalRect(lbMainPageButtons)); -- 取得相对父控件的坐标
		
		for i, v in ipairs(SClass_ChannelGroup.list) do
		
			local lbSubPageButtons = SAPI.GetChild(v, "lbPageButtons");
			local rcSubLocalPageButtons = EvUiLuaClass_Rect:new(uiGetWidgetLocalRect(lbSubPageButtons)); -- 取得相对父控件的坐标
			
			local PageButtonsOffsetX = rcMainLocalPageButtons.x - rcSubLocalPageButtons.x; -- 计算父窗口和子窗口的"lbPageButtons"偏移量
			
			pos:SetOffsetX((i - 1) * LOCAL_CHAT_CHANNEL_BUTTON_WIDTH + PageButtonsOffsetX);
			local cbHistory = SAPI.GetChild(lbSubPageButtons, "cbHistory");
			IsCaptured = cbHistory:IsCaptured();
			if IsCaptured then
				SClass_ChannelGroup.bChanged = true;
			end
			cbHistory:MoveSize(pos:GetX(), pos:GetY(), LOCAL_CHAT_CHANNEL_BUTTON_WIDTH, LOCAL_CHAT_CHANNEL_BUTTON_HEIGHT);
			v:MoveSize(rcMainFrame.x, rcMainFrame.y, rcMainFrame.width, rcMainFrame.height);
			local ebDisplay = SAPI.GetChild(v, "ebDisplay");
			local wtBgDisplay = SAPI.GetChild(v, "wtBgDisplay");
			if SClass_ChannelGroup.CurrentChannel ~= nil and SAPI.Equal(SClass_ChannelGroup.CurrentChannel, v) then
				ebDisplay:Show();
				wtBgDisplay:ShowDirect();
				cbHistory:SetChecked(true);
			else
				ebDisplay:Hide();
				wtBgDisplay:HideDirect();
				cbHistory:SetChecked(false);
			end
		end
		SClass_ChannelFilter:FilterFrameAutoFollow();
		SClass_ChannelHint:HintFrameAutoFollow();
	end
	
	if AutoScrollLeft > delta then
		AutoScrollLeft = AutoScrollLeft - delta;
	else
		AutoScrollLeft = 0;
	end
	
	local now = os.clock();
	local LastUpdate = self.LastUpdate;
	if LastUpdate == nil then self.LastUpdate = now return end
	if now - LastUpdate < 5 then return end
	self.LastUpdate = now;
	
	local x, y = uiGetMousePosition();
	local rcFrame = EvUiLuaClass_Rect:new(uiGetWidgetRect(self));
	if IsCaptured or rcFrame:ContainPos(x, y) == true then return end
	SClass_ChannelGroup:Hide() -- 隐藏多余的界面
end

function TemplateChatChannelPage_lbPageButtons_cbHistory_OnLDown(self, mouse_x, mouse_y)
	SClass_ChannelFilter:HideFilterFrame();
	local x, y = uiGetWidgetRect(self);
	self:Set("MouseOffset", {x = mouse_x - x, y = mouse_y - y});
end

function TemplateChatChannelPage_lbPageButtons_cbHistory_OnMouseMove(self, mouse_x, mouse_y, delta_x, delta_y)
	if self:IsCaptured() then
	
		local lbPageButtons = SAPI.GetParent(self);
		local frame = SAPI.GetParent(lbPageButtons);
		if SClass_ChannelGroup:Contain(frame) and SClass_ChannelGroup.LockChannelPage then return end
		
		local target = SAPI.GetParent(SAPI.GetParent(self));
		local channel = target;
		local rcOld = EvUiLuaClass_Rect:new(uiGetWidgetRect(self));
		local rcView = EvUiLuaClass_Rect:new(uiGetGameViewRect());
		local offset = self:Get("MouseOffset");
		local _x = mouse_x - (rcOld.x + offset.x);
		local _y = mouse_y - (rcOld.y + offset.y);

		if _x > 0 then
			if rcOld:GetRight() + _x > rcView:GetRight() then
				_x = rcView:GetRight() - rcOld:GetRight();
			end
		elseif _x < 0 then
			if rcOld.x + _x < rcView.x then
				_x = rcView.x - rcOld.x;
			end
		end
		if _y > 0 then
			if rcOld:GetBottom() + _y > rcView:GetBottom() then
				_y = rcView:GetBottom() - rcOld:GetBottom();
			end
		elseif _y < 0 then
			if rcOld.y + _y < rcView.y then
				_y = rcView.y - rcOld.y;
			end
		end

		target:MoveTo_Offset(_x, _y);
		local channel = SAPI.GetParent(SAPI.GetParent(self));
		if SClass_ChannelGroup:CheckIn(self) then
			if not SClass_ChannelGroup.LockChannelPage then
				SClass_ChannelGroup:Add(channel);
				TemplateChatChannelPageMain_OnUpdate(SClass_ChannelGroup.MainFrame, 0);
			end
		else
			if SClass_ChannelGroup:Erase(channel) then
				local x, y = uiGetWidgetLocalRect(self);
				channel:MoveTo_Offset(x, y);
				self:MoveTo(0, 0);
			end
		end
		SClass_ChannelGroup:OnChannelFrameMove(channel);
	end
end

function TemplateChatChannelPage_lbPageButtons_cbHistory_OnLCLick(self)
	self:SetChecked(true);
	local channel = SAPI.GetParent(SAPI.GetParent(self));
	SClass_Channel:SetCurrentChannel(channel);
	if SClass_ChannelFilter:IsOwner(channel) == false then
		SClass_ChannelFilter:HideFilterFrame();
	end
end

function TemplateChatChannelPage_lbPageButtons_cbHistory_OnRCLick(self)
	TemplateChatChannelPage_lbPageButtons_cbHistory_OnLCLick(self);
	local frmChatInput = uiGetglobal("layWorld.frmChatInput");
	frmChatInput:ShowAndFocus();
	local ebInput = SAPI.GetChild(frmChatInput, "ebInput");
	ebInput:SetFocus();
end

function TemplateChatChannelPage_lbPageButtons_cbHistory_OnEnter(self)
	local lbPageButtons = SAPI.GetParent(self);
	local ebDisplay = SAPI.GetSibling(lbPageButtons, "ebDisplay");
	TemplateChatChannelPage_ebDisplay_OnEnter(ebDisplay);
end

function TemplateChatChannelPage_ebDisplay_OnLDown(self, mouse_x, mouse_y)
	local item = self:PickItem(mouse_x, mouse_y);
	if item == nil or uiChatIsEmptyItem(item) == true then
		uiSetEventProcessed(false)
	end
end

function TemplateChatChannelPage_ebDisplay_OnLUp(self, mouse_x, mouse_y)
	local item = self:PickItem(mouse_x, mouse_y);
	if item == nil or uiChatIsEmptyItem(item) == true then
		uiSetEventProcessed(false)
	end
end

function TemplateChatChannelPage_ebDisplay_OnRDown(self, mouse_x, mouse_y)
	local item = self:PickItem(mouse_x, mouse_y);
	if item == nil or uiChatIsEmptyItem(item) == true then
		uiSetEventProcessed(false)
	end
end

function TemplateChatChannelPage_ebDisplay_OnRUp(self, mouse_x, mouse_y)
	local item = self:PickItem(mouse_x, mouse_y);
	if item == nil or uiChatIsEmptyItem(item) == true then
		uiSetEventProcessed(false)
	end
end

function TemplateChatChannelPage_ebDisplay_OnLClick(self, mouse_x, mouse_y)
	local channel = SAPI.GetParent(self);
	local item = self:PickItem(mouse_x, mouse_y);
	if item == nil then uiSetEventProcessed(false) return end
	local name, id, info = uiChatGetParam(item);
	local hint = uiChatGetItemHintByRichItem(item);
	if name ~= nil and name ~= "" then
		if info and info.Channel == EV_CHANNEL_NPC then
		else
			uiChatSetPrivateName(name);
		end
	elseif id ~= nil and id ~= 0 and hint ~= nil then
		SClass_ChannelHint:SetHintOwner(channel);
		SClass_ChannelHint:SetHintRichText(hint, item);
		SClass_ChannelHint:ShowHintFrame();
	else
		uiSetEventProcessed(false);
	end
end

function TemplateChatChannelPage_ebDisplay_OnRClick(self, mouse_x, mouse_y)
	local channel = SAPI.GetParent(self);
	local item = self:PickItem(mouse_x, mouse_y);
	if item == nil then uiSetEventProcessed(false) return end
	local name, id, info = uiChatGetParam(item);
	local hint = uiChatGetItemHintByRichItem(item);
	if name ~= nil and name ~= "" then
		if info and info.Channel == EV_CHANNEL_NPC then
			uiShowPopmenuNpc(name, info.Id, true);
		else
			uiShowPopmenuPlayer(name, true);
		end
	else
		uiSetEventProcessed(false);
	end
end

function TemplateChatChannelPage_ebDisplay_OnEnter(self)
	local frame = SAPI.GetParent(self);
	if SClass_ChannelGroup:Contain(frame) == true then
		SClass_ChannelGroup:Show() -- 隐藏多余的界面
		return
	end
	-- 如果当前聊天窗口是独立的,那么当鼠标进来时,把工具栏都Show出来
	local OpList =
	{
		"wtBgDisplay",
		"lbPageButtons",
		"wtToolsBottom",
		"wtToolsTop",
	};
	for i, v in ipairs(OpList) do
		local OpWidget = SAPI.GetChild(frame, v);
		OpWidget:Show();
	end
	frame.ToolsVisible = true; -- 所有工具栏都已经Show出来了,将窗口标记修正为true
end

function TemplateChatChannelPage_ebDisplay_OnUpdate(self, delta)
	local now = os.clock();
	local linecount = self:getLineCount();
	local LineFadeOutDelayTime = self.LineFadeOutDelayTime;
	if self.LineFadeOutDelayTime then
		local InsertTimeList = self.InsertTimeList;
		if InsertTimeList ~= nil then
			local scroll = self:getScrollBarV();
			if scroll:IsMouseControled() == true then
				for i = 1, table.getn(InsertTimeList) do
					InsertTimeList[i] = now;
				end
			end
			local count = table.getn(InsertTimeList);
			local startindex = linecount - count;
			local delcount = count - LOCAL_CHAT_MAX_VISIBLE_LINE;
			if delcount < 0 then delcount = 0 end
			for i = startindex, startindex + delcount - 1, 1 do
				local line = self:getLine(i);
				if line then
					line:SetAlpha(255);
				end
				table.remove(InsertTimeList, 1);
			end
			local count = table.getn(InsertTimeList);
			local startindex = linecount - count;
			local index = 1;
			for i = startindex + delcount, startindex + count - 1, 1 do
				local line = self:getLine(i);
				local inserttime = InsertTimeList[index] + LineFadeOutDelayTime;
				if line and inserttime then
					local t = now - inserttime;
					if t > 5 then
						t = 5;
					elseif t < 0 then
						t = 0;
					end
					line:SetAlpha((5 - t) * 51);
				end
				index = index + 1;
			end
		end
		self.InsertTimeList = InsertTimeList;
	end
end

function TemplateChatChannelPage_ebDisplay_OnScrollV(self)
	local scroll = self:getScrollBarV();
	if scroll:IsMouseControled() then
		AutoScrollLeft = AutoScrollLeftMax;
	end
end

function TemplateChatChannelPage_OnLoad(self)
	--local id = self:Get("ID");
	--local cbHistory = SAPI.GetChild(SAPI.GetChild(self, "lbPageButtons"), "cbHistory");
	--local ebDisplay = SAPI.GetChild(self, "ebDisplay");
	if self.DefaultInGroup then SClass_ChannelGroup:Add(self) end
	self:RegisterScriptEventNotify("EVENT_SelfEnterWorld");
	self:RegisterScriptEventNotify("event_chat_received");
end

function TemplateChatChannelPage_OnEvent(self,event,args)
	local id = self:Get("ID");
	if event == "EVENT_SelfEnterWorld" then
		if uiChatIsValidChannelPage(id) == true then
			local _id, _, name = uiChatGetChannelPageInfo(id);
			if _id ~= id then name = "unknown" end
			local cbHistory = SAPI.GetChild(SAPI.GetChild(self, "lbPageButtons"), "cbHistory");
			cbHistory:SetText(name);
			if id == 1 then SClass_Channel:SetDefaultChannel(self) end
		else
			SClass_ChannelGroup:Erase(self);
			self:Hide();
		end
	elseif event == "event_chat_received" then
		TemplateChatChannelPage_OnEvent_ChatReceived(self, args);
	end
end

function TemplateComicButton_OnLoad(self)
	self:RegisterScriptEventNotify("EVENT_SelfEnterWorld");
end

function TemplateComicButton_OnEvent(self, event, args)
	if event == "EVENT_SelfEnterWorld" then
		local facelist = uiChatGetFaceList();
		local id = self:Get("ID");
		if SAPI.ExistInTable(facelist, id) == true then
			local image = uiChatCreateFace(id);
			local _id, file, width, height, btX, btY = uiChatGetFaceInfo(id);
			if _id~= nil and image ~= nil then
				self:SetImageSequence(image);
				self:MoveSize(btX, btY, width, height);
				self:Show();
			else
				self:Hide();
			end
		else
			self:Hide();
		end
	end
end

function TemplateComicButton_OnLClick(self)
	local id = self:Get("ID");
	if id == nil or id == 0 then return end
	local frmComic = SAPI.GetParent(self);
	local frmChatInput = uiGetglobal("layWorld.frmChatInput");--SAPI.GetSibling(frmComic, "frmChatInput");
	local ebInput = SAPI.GetChild(frmChatInput, "ebInput");
	
	ebInput:InsertTextToCursor(string.format("#%d", id));
	
	ebInput:SetFocus();
	
	frmComic:Hide();
end

function TemplateChatChannelPage_OnEvent_ChatReceived(self, args)
	local channel_id = args[1];
	local id = self:Get("ID");
	if id == nil or id == 0 then return end
	local _id, bind_channel_id, _, send_channel, filter_list = uiChatGetChannelPageInfo(id);
	if _id == nil or _id ~= id then return end
	local exist = SAPI.ExistInTable(filter_list, channel_id);
	if exist == true then return end
	local ebDisplay = SAPI.GetChild(self, "ebDisplay");
	local messageLineList = uiChatGetLastChatMessage(bind_channel_id); -- 使用send_channel来获取
	for i, messageLine in ipairs(messageLineList) do
		local scrollBarV = ebDisplay:getScrollBarV();
		local bScrollToBottom = scrollBarV:IsBottom();
		local oldlinecount = ebDisplay:getLineCount();
		ebDisplay:InsertLine(messageLine, -1);
		local newlinecount = ebDisplay:getLineCount();
		local lineadd = newlinecount - oldlinecount;
		if newlinecount > LOCAL_CHAT_MAX_LINE_COUNT then
			ebDisplay:RemoveLine(0, LOCAL_CHAT_DEL_LINE_COUNT);
		end
		local curlinecount = ebDisplay:getLineCount();
		local dellinecount = newlinecount - curlinecount;
		local scroll = ebDisplay:getScrollBarV();
		
		if uiGetConfigureEntry("chat", "ScrollToBottom") == "1" then
			if scroll:IsMouseControled() ~= true and AutoScrollLeft == 0 then
				bScrollToBottom = true;
			end
		end
		
		if bScrollToBottom then
			ebDisplay:ScrollToBottom();
		end
		
		if ebDisplay.LineFadeOutDelayTime then
			local now = os.clock();
			local InsertTimeList = ebDisplay.InsertTimeList;
			if InsertTimeList == nil then
				InsertTimeList = {};
				for i = 1, curlinecount, 1 do
					table.insert(InsertTimeList, now);
				end
			else
				for i = 1, lineadd, 1 do
					table.insert(InsertTimeList, now);
				end
			end
			local count = table.getn(InsertTimeList);
			local startindex = newlinecount - count;
			local delcount = count - LOCAL_CHAT_MAX_VISIBLE_LINE;
			if delcount < 0 then delcount = 0 end
			for i = startindex, startindex + delcount - 1, 1 do
				local line = ebDisplay:getLine(i);
				if line then
					line:SetAlpha(255); -- 把离开视野的行设置为可见
				end
				table.remove(InsertTimeList, 1);
			end
			ebDisplay.InsertTimeList = InsertTimeList;
		end
	end
end

	--[[
function TemplateChatChannelFrame_wtTools_OnUpdate(self, delta)
	local rcMousePos = EvUiLuaClass_Rect:new(uiGetMousePosition());
	local rcSelf = EvUiLuaClass_Rect:new(uiGetWidgetRect(self));
	if rcMousePos:IsIntersect(rcSelf) then
		self:Show();
	else
		self:Hide();
	end
end
	]]

function TemplateChatChannelFrame_wtToolsTop_btResizeV_OnLDown(self, mouse_x, mouse_y)
	local x, y = uiGetWidgetRect(self);
	self:Set("MouseOffset", {x = mouse_x - x, y = mouse_y - y});
end

function TemplateChatChannelFrame_wtToolsTop_btResizeV_OnMouseMove(self, mouse_x, mouse_y, delta_x, delta_y)
	if self:IsCaptured() then
		local target = SAPI.GetParent(SAPI.GetParent(self));
		local rcOld = EvUiLuaClass_Rect:new(uiGetWidgetRect(target));
		local rcOldSelf = EvUiLuaClass_Rect:new(uiGetWidgetRect(self));
		local offset = self:Get("MouseOffset");
		local _y = mouse_y - (rcOldSelf.y + offset.y);
		target:SetSize_Offset(0, -_y);
		local rcNew = EvUiLuaClass_Rect:new(uiGetWidgetRect(target));
		target:MoveTo_Offset(0, rcOld:GetHeight() - rcNew:GetHeight());
		local ebDisplay = SAPI.GetChild(target, "ebDisplay");
		if ebDisplay then
			ebDisplay:ScrollToBottom();
		end
		--SClass_ChannelGroup:OnChannelFrameResize(target); 
	end
end

function TemplateChatChannelFrame_wtToolsBottom_btChannel_OnLClick(self)
	local channel = SAPI.GetParent(SAPI.GetParent(self));
	if SClass_ChannelFilter:IsOwner(channel) == true then
		SClass_ChannelFilter:SwitchFilterFrame();
	else
		SClass_ChannelFilter:SetFilterOwner(channel);
		SClass_ChannelFilter:ShowFilterFrame();
	end
end

function TemplateChatChannelFrame_wtToolsBottom_btMove_OnLDown(self, mouse_x, mouse_y)
	local x, y = uiGetWidgetRect(self);
	self:Set("MouseOffset", {x = mouse_x - x, y = mouse_y - y});
end

function TemplateChatChannelFrame_wtToolsBottom_btMove_OnMouseMove(self, mouse_x, mouse_y, delta_x, delta_y)
	if self:IsCaptured() then
		local target = SAPI.GetParent(SAPI.GetParent(self));
		local rcOld = EvUiLuaClass_Rect:new(uiGetWidgetRect(self));
		local rcView = EvUiLuaClass_Rect:new(uiGetGameViewRect());
		local offset = self:Get("MouseOffset");
		local _x = mouse_x - (rcOld.x + offset.x);
		local _y = mouse_y - (rcOld.y + offset.y);

		if _x > 0 then
			if rcOld:GetRight() + _x > rcView:GetRight() then
				_x = rcView:GetRight() - rcOld:GetRight();
			end
		elseif _x < 0 then
			if rcOld.x + _x < rcView.x then
				_x = rcView.x - rcOld.x;
			end
		end
		if _y > 0 then
			if rcOld:GetBottom() + _y > rcView:GetBottom() then
				_y = rcView:GetBottom() - rcOld:GetBottom();
			end
		elseif _y < 0 then
			if rcOld.y + _y < rcView.y then
				_y = rcView.y - rcOld.y;
			end
		end

		local target = SAPI.GetParent(SAPI.GetParent(self));
		target:MoveTo_Offset(_x, _y);
		local ebDisplay = SAPI.GetChild(target, "ebDisplay");
		--SClass_ChannelGroup:OnChannelFrameMove(target);
	end
end

function TemplateChatChannelFrame_OnLoad(self)
	self:RegisterScriptEventNotify("EVENT_SelfEnterWorld");
end

function TemplateChatChannelFrame_OnEvent(self, event, args)
	if event == "EVENT_SelfEnterWorld" then
		--self:RemoveAnchors();
	end
end

function TemplateChatChannelFrame_OnUpdate(self, delta)
	if self.ToolsVisible == true then
		if SClass_ChannelGroup:Contain(self) == true then return end
		local x, y = uiGetMousePosition();
		local rcFrame = EvUiLuaClass_Rect:new(uiGetWidgetRect(self));
		if rcFrame:ContainPos(x, y) == true then return end
		-- 如果当前聊天窗口是独立的,那么当鼠标不在窗口区域内时,把工具栏都Hide掉
		local OpList =
		{
			"wtBgDisplay",
			"lbPageButtons",
			"wtToolsBottom",
			"wtToolsTop",
		};
		for i, v in ipairs(OpList) do
			local OpWidget = SAPI.GetChild(self, v);
			OpWidget:Hide();
		end
		self.ToolsVisible = false; -- 所有工具栏都已经Hide掉了,将窗口标记修正为false
	end
end

function TemplateChatChannelFrame_OnOffset(self)
	SClass_ChannelGroup:OnChannelFrameMove(self);
end

function TemplateChatChannelPageMain_wtToolsBottom_cbLock(self)
	SClass_ChannelGroup.LockChannelPage = self:getChecked();
end

function layWorld_wtLayerChatEx_frmChannelFilter_OnLoad(self)
	SClass_ChannelFilter:SetFilterFrame(self);
	uiSetToTop(self);
end

function layWorld_wtLayerChatEx_frmChannelFilter_OnHide(self)
	SClass_ChannelFilter:ClearFilterOwner();
end

function layWorld_wtLayerChatEx_frmChannelFilter_OnShow(self)
	uiRegisterEscWidget(self);
end

function layWorld_wtLayerChatEx_hntChatHint_OnLoad(self)
	SClass_ChannelHint:SetHintFrame(self);
end

function layWorld_wtLayerChatEx_hntChatHint_OnShow(self)
	uiRegisterEscWidget(self);
end

function layWorld_wtLayerChatEx_frmChatInput_btCartoon_OnLClick(self)
	local frmChatInput = SAPI.GetParent(self);
	local frmComic = uiGetglobal("layWorld.frmComic");--SAPI.GetSibling(frmChatInput, "frmComic");
	if frmComic:getVisible() == true then
		frmComic:Hide();
	else
		frmComic:Show();
	end
end

function layWorld_wtLayerChatEx_frmChatInput_lbInputPrefix_OnLoad(self)
	self:RegisterScriptEventNotify("EVENT_SendChannelChanged");
end
function layWorld_wtLayerChatEx_frmChatInput_lbInputPrefix_OnEvent(self, event, args)
	if event == "EVENT_SendChannelChanged" then
		layWorld_wtLayerChatEx_frmChatInput_lbInputPrefix_OnEvent_SendChannelChanged(self, event, args);
	end
end

function layWorld_wtLayerChatEx_frmChatInput_lbInputPrefix_OnEvent_SendChannelChanged(self, event, args)
	-- 频道变更
	local channelid = args[1]; -- 频道ID
	local _id, color, _, _, _, _, _, prifix_text = uiChatGetChannelInfo(channelid);
	self:SetTextColor(color);
	if channelid == 5 then
		prifix_text = string.format(prifix_text, SClass_Channel:GetSendName());
	end
	local width = uiGetStringWidth(prifix_text);
	local leftspace = self:getLeftSpace();
	local _, _, _, height = uiGetWidgetRect(self);
	self:SetSize(width + leftspace * 2, height);
	self:SetText(prifix_text);
end

function layWorld_wtLayerChatEx_frmChatInput_ebInput_OnLoad(self)
	self:RegisterScriptEventNotify("EVENT_SendChannelChanged");
end
function layWorld_wtLayerChatEx_frmChatInput_ebInput_OnEvent(self, event, args)
	if event == "EVENT_SendChannelChanged" then
		layWorld_wtLayerChatEx_frmChatInput_ebInput_OnEvent_SendChannelChanged(self, event, args);
	end
end

function layWorld_wtLayerChatEx_frmChatInput_ebInput_OnEvent_SendChannelChanged(self, event, args)
	-- 频道变更
	local channelid = args[1]; -- 频道ID
	local _id, color = uiChatGetChannelInfo(channelid);
	self:SetTextColor(color);
end

function layWorld_wtLayerChatEx_frmChatInput_ebInput_OnUpdateText(self)
	local Shortcut = LOCAL_CHAT_CHANNEL_SHORTCUT;
	local line = self:getLine(0);
	local channelid = SClass_Channel:GetCurrentChannelId();
	if line ~= nil and channelid ~= nil and channelid ~= 0 then
		local message = self:getText();
		for i, v in pairs(Shortcut) do
			local i, _, content = string.find(message, "^"..i.." (.*)$");
			if i then
				channelid = v;
				message = content;
				break;
			end
		end
		local i, _, name = string.find(message, "^/([^ ][^ ][^ ]+)$");
		if i ~= nil then
			SClass_Channel:SetSendName(name);
			SClass_Channel:SetSendChannelId(5);
			self:SetText("");
			return;
		end
		
		local sendname = "";
		if channelid == 5 then
			sendname = SClass_Channel:GetSendName();
		end
		if message ~= "" then
			local bResult = uiChatSendChatMessage(channelid, sendname, message, line);
			if bResult == true then
				if sendname ~= "" then
					LOCAL_ChatDoskey_Name:AppendHistory(sendname);
				end
				LOCAL_ChatDoskey_Content:AppendHistory(message);
				LOCAL_ChatDoskey_Content:End();
				LOCAL_ChatDoskey_Content:SetBreakValue("");
				self:RemoveAllLines();
			end	
		end
	end
	local frmChatInput = SAPI.GetParent(self):Hide();
end

function layWorld_wtLayerChatEx_frmChatInput_btChannel_OnLClick(self)
	local frmChannel = uiGetglobal("layWorld.frmChannel");
	if frmChannel:getVisible() == true then
		frmChannel:Hide();
	else
		frmChannel:ShowAndFocus();
	end
end

function layWorld_wtLayerChatEx_frmChatInput_OnLoad(self)
	self:RegisterScriptEventNotify("BeginChat");
	self:RegisterScriptEventNotify("EVENT_SelfEnterWorld");
	self:RegisterScriptEventNotify("EVENT_SetPrivySendName");
	self:RegisterScriptEventNotify("EVENT_SetSendChannel");
end

function layWorld_wtLayerChatEx_frmChatInput_OnEvent(self, event, args)
	if event == "BeginChat" then
		layWorld_wtLayerChatEx_frmChatInput_OnEvent_BeginChat(self, event, args);
	elseif event == "EVENT_SelfEnterWorld" then
		layWorld_wtLayerChatEx_frmChatInput_OnEvent_SelfEnterWorld(self, event, args);
	elseif event == "EVENT_SetPrivySendName" then
		local name = args[1];
		if not name then return end
		SClass_Channel:SetSendName(name);
	elseif event == "EVENT_SetSendChannel" then
		local channelid = args[1];
		if not channelid then return end
		SClass_Channel:SetSendChannelId(channelid);
	end
end

function layWorld_wtLayerChatEx_frmChatInput_OnHide(self)
	local frmComic = uiGetglobal("layWorld.frmComic");--SAPI.GetSibling(self, "frmComic");
	if frmComic:getVisible() == true then
		frmComic:Hide();
	end
end

function layWorld_wtLayerChatEx_frmChatInput_OnEvent_BeginChat(self, event, args)
	if self:getVisible() == true then return end
	local param = args[1];
	if param == EV_EXCUTE_EVENT_KEY_DOWN then
		self:Set("EV_EXCUTE_EVENT_KEY_DOWN", true);
	end
    if param == EV_EXCUTE_EVENT_POP_MENU or (param == EV_EXCUTE_EVENT_KEY_UP and self:Get("EV_EXCUTE_EVENT_KEY_DOWN") == true) then
        self:ShowAndFocus();
		local ebInput = SAPI.GetChild(self, "ebInput");
		ebInput:SetFocus();
		self:Delete("EV_EXCUTE_EVENT_KEY_DOWN");
	else
	end
end

function layWorld_wtLayerChatEx_frmChatInput_OnEvent_SelfEnterWorld(self, event, args)
	SClass_Channel:SetCurrentChannel(SClass_Channel:GetDefaultChannel());
end

function layWorld_wtLayerChatEx_frmChatInput_ebInput_OnDragIn(self, drag)
	local line = self:getLine(0);
	if line ~= nil then
		local itemcount = uiChatGetSendItemCount(line);
		if itemcount >= 5 then -- 发送的道具不能超过5个
			return;
		end
	end
	local Drag = uiGetglobal(drag);
	local Owner = Drag:Get(EV_UI_SHORTCUT_OWNER_KEY);
	local Type = Drag:Get(EV_UI_SHORTCUT_TYPE_KEY);
	local Id = Drag:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
	if Owner ~= EV_UI_SHORTCUT_OWNER_ITEM or Type ~= EV_SHORTCUT_OBJECT_ITEM or Id == nil or Id == 0 then return end
	
	local ObjInfo = uiItemGetBagItemInfoByObjectId(Id);
	if ObjInfo == nil then return end
	local ClassInfo = uiItemGetItemClassInfoByTableIndex(ObjInfo.TableId);
	if ClassInfo == nil then return end
	
	local item = EvUiLuaClass_RichTextItem:new();
	
	item.Param1 = Id;
	item.Type = "TEXT";
	item.Color = string.format("#%8.x", ObjInfo.ColorShow);
	item.Text = "["..ClassInfo.Name.."]";
	item.UnDetachable = true;
	
	local line = EvUiLuaClass_RichTextLine:new();
	line:InsertItem(item);
	local rich_text = EvUiLuaClass_RichText:new();
	rich_text:InsertLine(line);
	
	self:InsertRichTextToCursor(rich_text:ToRichString());
end

function layWorld_wtLayerChatEx_frmChatInput_ebInput_OnKeyDown(self, key)
	local key_name = uiGetKeyName(key);
	if key_name == "ENTER" then
		-- 发送消息已经在OnUpdateText中处理
	elseif key_name == "UP" then
		local text = self:getText();
		local i, iEnd = string.find(text, "^/([^ ]*)$");
		if i == nil then
			LOCAL_ChatDoskey_Content:Previous();
			local ReplaceContent = LOCAL_ChatDoskey_Content:Value();
			if ReplaceContent ~= nil then
				self:SetText(ReplaceContent);
			end
		else
			LOCAL_ChatDoskey_Name:Previous();
			local ReplaceName = LOCAL_ChatDoskey_Name:Value();
			if ReplaceName ~= nil then
				self:SetText("/"..ReplaceName);
				local colStart, colEnd = string.len(LOCAL_ChatDoskey_Name:GetMatchValue())+1, string.len(ReplaceName)+1;
				self:SetSelection(0, colStart, 0, colEnd);
			end
		end
	elseif key_name == "DOWN" then
		local text = self:getText();
		local i = string.find(text, "^/([^ ]*)$");
		if i == nil then
			LOCAL_ChatDoskey_Content:Next();
			local ReplaceContent = LOCAL_ChatDoskey_Content:Value();
			if ReplaceContent ~= nil then
				self:SetText(ReplaceContent);
			end
		else
			LOCAL_ChatDoskey_Name:Next();
			local ReplaceName = LOCAL_ChatDoskey_Name:Value();
			if ReplaceName ~= nil then
				self:SetText("/"..ReplaceName);
				local colStart, colEnd = string.len(LOCAL_ChatDoskey_Name:GetMatchValue())+1, string.len(ReplaceName)+1;
				self:SetSelection(0, colStart, 0, colEnd);
			end
		end
	elseif key_name == "ESCAPE" then
		SAPI.GetParent(self):Hide();
	end
end

function layWorld_wtLayerChatEx_frmChatInput_ebInput_OnKeyChar(self, key)
	local key_name = uiGetKeyName(key);
	local text = self:getText();
	
	local i, _, name, content = string.find(text, "^/([^ ][^ ][^ ]+) (.*)$");
	if i ~= nil then
		SClass_Channel:SetSendName(name);
		SClass_Channel:SetSendChannelId(5);
		self:SetText(content);
		text = content;
	end
	
	local SwitchShortcut = LOCAL_CHAT_CHANNEL_SWITCHSHORTCUT;
	
	for k, v in pairs(SwitchShortcut) do
		local i, _, content = string.find(text, "^"..k.." (.*)$");
		if i then
			SClass_Channel:SetSendChannelId(v);
			text = content;
			self:SetText(content);
			break;
		end
	end
	
	local i, _, name = string.find(text, "^/([^ ]*)$");
	if i == nil then
		-- 正常内容
	else
		-- 私聊名字输入
		local BreakValue = LOCAL_ChatDoskey_Name:GetBreakValue();
		LOCAL_ChatDoskey_Name:SetBreakValue(name);
		if key_name == "BACK" then
			return;
		end
		if BreakValue ~= nil and name ~= "" and string.find(BreakValue, "^"..name) ~= nil then
			local MatchValue = LOCAL_ChatDoskey_Name:GetMatchValue();
			if MatchValue ~= nil then
				if string.find(MatchValue, "^"..name) ~= nil then
					return;
				end
			end
		end
		LOCAL_ChatDoskey_Name:SetMatchValue(name);
		LOCAL_ChatDoskey_Name:Match();
		local ReplaceName = LOCAL_ChatDoskey_Name:Value();
		if ReplaceName ~= nil then
			self:SetText("/"..ReplaceName);
			local colStart, colEnd = string.len(LOCAL_ChatDoskey_Name:GetMatchValue())+1, string.len(ReplaceName)+1;
			self:SetSelection(0, colStart, 0, colEnd);
		end
	end
	LOCAL_ChatDoskey_Content:SetBreakValue(text);
end

function layWorld_wtLayerChatEx_frmChatInput_ebInput_OnShow(self)
	--LOCAL_ChatDoskey_Name:End();
	--LOCAL_ChatDoskey_Content:End();
end




















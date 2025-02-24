-- EVENT_CalendarNewDay

local FocusCalendarDay = nil;
local FocusYear = nil;
local FocusMonth = nil;
local FocusDayInMonth = nil;
local FocusEventList = {};
local FocusUserEventList = {};
local ClickShortcutId = 0;
local ClickShortcutName = "";

local DAY_COUNT_IN_WEEK = 7;
local USER_CALENDAR_NAME = "user";

local EventDetailsTypeInfoList = 
{
	List={},
	GetImage = function (self, _type)
		if _type == nil then return nil end
		if self.List[_type] == nil then
			local texture = uiCalendarGetEventDetailsTypeInfo(_type)
			if texture == nil then return nil end
			local image = SAPI.GetImage(texture);
			self.List[_type] = {image = image};
		end
		return self.List[_type].image;
	end
};
local EventTypeList =
{
	[1] = "1457",		-- 日常活动
	[2] = "1458",		-- 每周活动
	[3] = "1459",		-- 节日活动
	[4] = "1461",		-- 全部
	DoSelect = function (self, select)
		if select == nil then self.Select = 4 return end
		if type(select) == "number" then
			if self[select] == nil then
				self.Select = 4;
			else
				self.Select = select;
			end
		else
			self.Select = 4;
		end
	end,
	Select = 4,
	Allowed = function (self, index)
		if self.Select == 4 then return true end
		return index == self.Select;
	end,
}

local TimeFormatDataPool =
{
	FindFormatData = function (self, timeformat)
		if not timeformat then return nil end
		return self[timeformat];
	end,
	CreateFormatData = function (self, timeformat, calendarname, eventid)
		if not timeformat then return false end
		if self[timeformat] ~= nil then return true end -- 已经有了,不用再创建了
		if calendarname and eventid then
			local create = {};
			create.Minute, create.Hour, create.Day, create.Month, create.Week = uiCalendarGetScheduleData(calendarname, eventid);
			if create.Minute then
				self[timeformat] = create;
				return true;
			end
		end
		return false;
	end,
};
--------------------   EvUiLuaClass_CalendarEvent  --------------
local EvUiLuaClass_CalendarEvent = {};
EvUiLuaClassAssistant_SetSuperClass(EvUiLuaClass_CalendarEvent, EvUiLuaClass_Base);
function EvUiLuaClass_CalendarEvent:new()
	local newObject = {};
	EvUiLuaClassAssistant_SetSuperClass(newObject, EvUiLuaClass_CalendarEvent);
	newObject.Id = 0;
	newObject.Name = "";
	newObject.StartTime = {};
	newObject.StopTime = {};
	newObject.DurationTime = 0;
	newObject.Type = 0;
	newObject.DetailsType = 0;
	newObject.TimeFormat = "* * * * *";
	newObject.Desc = "";
	newObject.Recever = "";
	return newObject;
end
function EvUiLuaClass_CalendarEvent:SetId(id)
	if not id then id = 0 end
	self.Id = id;
end
function EvUiLuaClass_CalendarEvent:GetId()
	return self.Id;
end
function EvUiLuaClass_CalendarEvent:SetName(name)
	if not name then name = "" end
	self.Name = name;
end
function EvUiLuaClass_CalendarEvent:GetName()
	return self.Name;
end
function EvUiLuaClass_CalendarEvent:SetStartTime(start)
	if not start or start == 0 then start = {} return end
	self.StartTime.year, self.StartTime.month, self.StartTime.day, self.StartTime.hour, self.StartTime.minute, self.StartTime.second, self.StartTime.millisecond, self.StartTime.dayofweek = uiFormatTime(start);
end
function EvUiLuaClass_CalendarEvent:GetStartTime()
	return self.StartTime;
end
function EvUiLuaClass_CalendarEvent:SetStopTime(stop)
	if not stop or stop == 0 then stop = {} return end
	self.StopTime.year, self.StopTime.month, self.StopTime.day, self.StopTime.hour, self.StopTime.minute, self.StopTime.second, self.StopTime.millisecond, self.StopTime.dayofweek = uiFormatTime(stop);
end
function EvUiLuaClass_CalendarEvent:GetStopTime()
	return self.StopTime;
end
function EvUiLuaClass_CalendarEvent:SetDurationTime(duration)
	if not duration then duration = 0 end
	self.DurationTime = duration;
end
function EvUiLuaClass_CalendarEvent:GetDurationTime()
	return self.DurationTime;
end
function EvUiLuaClass_CalendarEvent:SetType(_type)
	if not _type then _type = 0 end
	self.Type = _type;
end
function EvUiLuaClass_CalendarEvent:GetType()
	return self.Type;
end
function EvUiLuaClass_CalendarEvent:SetDetailsType(_type)
	if not _type then _type = 0 end
	self.DetailsType = _type;
end
function EvUiLuaClass_CalendarEvent:GetDetailsType()
	return self.DetailsType;
end
function EvUiLuaClass_CalendarEvent:SetTimeFormat(_format)
	if not _format then _format = "* * * * *" end
	self.TimeFormat = _format;
end
function EvUiLuaClass_CalendarEvent:GetTimeFormat()
	return self.TimeFormat;
end
function EvUiLuaClass_CalendarEvent:SetDesc(desc)
	if not desc then desc = "" end
	self.Desc = desc;
end
function EvUiLuaClass_CalendarEvent:GetDesc()
	return self.Desc;
end
function EvUiLuaClass_CalendarEvent:SetRecever(recever)
	if not recever then recever = "" end
	self.Recever = recever;
end
function EvUiLuaClass_CalendarEvent:GetRecever()
	return self.Recever;
end
function EvUiLuaClass_CalendarEvent:ContainDay(year, month, day, dayinweek)
	local start = self:GetStartTime();
	local stop = self:GetStopTime();
	local result = true;
	if start.year ~= nil then
		if start.year > year then return false end
		if start.year == year then
			if start.month > month then return false end
			if start.month == month then
				if start.day > day then return false end
			end
		end
	end
	if stop.year ~= nil then
		if stop.year < year then return false end
		if stop.year == year then
			if stop.month < month then return false end
			if stop.month == month then
				if stop.day < day then return false end
			end
		end
	end
	local FormatData = TimeFormatDataPool:FindFormatData(self:GetTimeFormat());
	if FormatData.Month[month-1] == false then  -- TODO:需要新的ev_calendar.h
		result = false;
	elseif FormatData.Day[day] == false then
		result = false;
	elseif FormatData.Week[dayinweek + 1] == false then
		result = false;
	end
	return result;
end
function EvUiLuaClass_CalendarEvent:GetFirstActiveTime()
	local hour, minute = 0, 0;
	local FormatData = TimeFormatDataPool:FindFormatData(self:GetTimeFormat());
	local hour = SAPI.GetIndexInTable(FormatData.Hour, true) - 1;
	local minute = SAPI.GetIndexInTable(FormatData.Minute, true) - 1;
	local endhour = nil;
	local endminute = nil;
	if self.DurationTime ~= 0 then
		endminute = minute + math.floor(self.DurationTime/60);
		endhour = hour + math.floor(endminute / 60);
		endminute = math.mod(endminute, 60);
	end
	return hour, minute, endhour, endminute;
end
--------------------  ..EvUiLuaClass_CalendarEvent  --------------

--------------------   EvUiLuaClass_Calendar  --------------
local EvUiLuaClass_Calendar = {};
EvUiLuaClassAssistant_SetSuperClass(EvUiLuaClass_Calendar, EvUiLuaClass_Base);
function EvUiLuaClass_Calendar:new()
	local newObject = {};
	EvUiLuaClassAssistant_SetSuperClass(newObject, EvUiLuaClass_Calendar);
	newObject.Name = "";
	newObject.EventList = {};
	return newObject;
end
function EvUiLuaClass_Calendar:SetName(name)
	self.Name = name;
end
function EvUiLuaClass_Calendar:GetName()
	return self.Name;
end
function EvUiLuaClass_Calendar:ClearEvent()
	self.EventList = {};
end
function EvUiLuaClass_Calendar:CreateEvent(id, _type, _detailstype, start, stop, duration, _format, name, desc, recever)
	if not self.EventList[id] then self.EventList[id] = EvUiLuaClass_CalendarEvent:new() end
	local event = self.EventList[id];
	event:SetId(id);
	event:SetType(_type);
	event:SetDetailsType(_detailstype);
	event:SetStartTime(start);
	event:SetStopTime(stop);
	event:SetDurationTime(duration);
	event:SetName(name);
	event:SetTimeFormat(_format);
	event:SetDesc(desc);
	event:SetRecever(recever);
	
	local success = TimeFormatDataPool:CreateFormatData(_format, self:GetName(), id);
	
	return event;
end
--------------------  ..EvUiLuaClass_Calendar  --------------

--------------------   EvUiLuaClass_DayInMonth  --------------
local EvUiLuaClass_DayInMonth = {};
EvUiLuaClassAssistant_SetSuperClass(EvUiLuaClass_DayInMonth, EvUiLuaClass_Base);
function EvUiLuaClass_DayInMonth:new()
	local newObject = {};
	EvUiLuaClassAssistant_SetSuperClass(newObject, EvUiLuaClass_DayInMonth);
	newObject.DayInMonth = 0;
	newObject.DayInWeek = 0;
	newObject.EventList = {}; -- 以日历名字为索引进行分类
	return newObject;
end
function EvUiLuaClass_DayInMonth:LoadFromEventCalendar(name, Calendar, year, month)
	local EventList = {};
	for i, Event in pairs(Calendar.EventList) do
		if Event:ContainDay(year, month, self.DayInMonth, self.DayInWeek) then
			table.insert(EventList, Event);
		end
	end
	self.EventList[name] = EventList;
end
function EvUiLuaClass_DayInMonth:FindEventById(id)
	for k, v in pairs(self.EventList) do
		for i, v in ipairs(v) do
			if v:GetId() == id then return v end
		end
	end
end
--------------------  ..EvUiLuaClass_DayInMonth  --------------

local CalendarList =
{
	List = {},
	GetCalendar = function (self, name)
		if self.List[name] == nil then
			self.List[name] = EvUiLuaClass_Calendar:new();
		end
		return self.List[name];
	end,
	FindCalendar = function (self, name)
		return self.List[name];
	end,
	DeleteCalendar = function (self, name)
		self.List[name] = nil;
	end,
};

local DayListInMonth =
{
	DayList = {},
	FirstDayWeek = 0,
	DayCount = 0,
	Today = {Year=2009,Month=11,Day=5},
	LoadToday = function (self)
		local now = uiGetServerTime();
		local year, month, day, _, _, _, _, dayinweek = uiFormatTime(now);
		self.Today.Year = year;
		self.Today.Month = month;
		self.Today.Day=day;
		self.Today.DayInWeek = dayinweek;
	end,
	ClearDayList = function (self)
		self.DayList = {};
	end,
	LoadDayList = function (self, year, month)
		self.Year = year;
		self.Month = month;
		self.DayCount, self.FirstDayWeek = uiGetMonthInfo(year, month);
		self:ClearDayList();
		for day = 1, 6*7 do
			if day < self.FirstDayWeek + 1 or day >= (self.FirstDayWeek + 1 + self.DayCount) then
				self.DayList[day] = nil;
			else
				local newDay = EvUiLuaClass_DayInMonth:new();
				newDay.DayInMonth = day - self.FirstDayWeek;
				newDay.DayInWeek = math.mod(day - 1, 7);
				self.DayList[day] = newDay;
			end
		end
	end,
	LoadNextMonth = function (self)
		if self.Month == 12 then
			self:LoadDayList(self.Year+1, 1);
		else
			self:LoadDayList(self.Year, self.Month+1);
		end
	end,
	LoadPreMonth = function (self)
		if self.Month == 1 then
			self:LoadDayList(self.Year-1, 12);
		else
			self:LoadDayList(self.Year, self.Month-1);
		end
	end,
	LoadCurMonth = function (self)
		local now = uiGetServerTime();
		local year, month = uiFormatTime(now);
		self:LoadDayList(year, month);
	end,
	LoadEvent = function (self, name, Calendar)
		if not Calendar then Calendar = CalendarList:FindCalendar(name) end
		if Calendar then
			for day = 1, 6*7 do
				local Day = self.DayList[day];
				if Day then
					Day:LoadFromEventCalendar(name, Calendar, self.Year, self.Month);
				end
			end
		end
	end,
	LoadAllEvent = function (self)
		for name, calendar in pairs (CalendarList.List) do
			self:LoadEvent(name, calendar);
		end
	end,
	FindDay = function (self, weekid, dayid)
		return self.DayList[(weekid-1)*DAY_COUNT_IN_WEEK+dayid];
	end,
	FindToday = function (self)
		return self.DayList[self.FirstDayWeek + self.Today.Day];
	end,
	FindDayByDayInMonth = function (self, day)
		local weekid = math.floor((day + self.FirstDayWeek) / 7) + 1;
		local dayid = math.mod((day + self.FirstDayWeek), 7);
		return self:FindDay(weekid, dayid);
	end,
};

local function RefreshCalendarEventShortcut(self, Event, CalendarName)
	if Event == nil then self:Hide() return end
	local lbTimeDesc = SAPI.GetChild(self, "lbTimeDesc");
	local btIcon = SAPI.GetChild(self, "btIcon");
	local starthour, startminute, endhour, endminute = Event:GetFirstActiveTime();
	if endhour then
		lbTimeDesc:SetText(string.format("%02d:%02d-%02d:%02d", starthour, startminute, endhour, endminute));
	else
		lbTimeDesc:SetText(string.format("%02d:%02d", starthour, startminute));
	end
	btIcon.EventId = Event:GetId(); -- TODO:点击事件的处理
	btIcon.CalendarName = CalendarName;
	
	local image = EventDetailsTypeInfoList:GetImage(Event:GetDetailsType());
	btIcon:SetNormalImage(image);
	btIcon:SetPushedImage(image);
	btIcon:SetHintText(Event:GetName());
	
	self:Show();
end

local function RefreshCalendarDay(self, week)
	local weekid = week.ID;
	local dayid = self.ID;
	local dayinmonth = DayListInMonth:FindDay(weekid, dayid);
	if dayinmonth == nil then
		-- 这天不存在
		self:Hide();
		return;
	end
	local lbDayInMonth = SAPI.GetChild(self, "lbDayInMonth");
	if DayListInMonth.Today.Year == DayListInMonth.Year and DayListInMonth.Today.Month == DayListInMonth.Month and DayListInMonth.Today.Day == dayinmonth.DayInMonth then
		lbDayInMonth:SetTextColorEx(0, 255, 0, 255);
	else
		lbDayInMonth:SetTextColorEx(255, 255, 255, 255);
	end
	lbDayInMonth:SetText(tostring(dayinmonth.DayInMonth));
	
	if FocusYear == DayListInMonth.Year and FocusMonth == DayListInMonth.Month and FocusDayInMonth.DayInMonth == dayinmonth.DayInMonth then
		self:SetChecked(true);
		FocusCalendarDay = self;
	else
		self:SetChecked(false);
	end

	self:Show();
	local count = 0;
	local hint = "";
	for name, v in pairs(dayinmonth.EventList) do
		if name == USER_CALENDAR_NAME then -- 玩家提醒
			for i, v in ipairs (v) do
				hint = hint..v:GetName().."\n";
			end
		else
			for i, v in ipairs (v) do
				if EventTypeList:Allowed(v:GetType()) == true then
					count = count + 1;
					local lbShortcut = SAPI.GetChild(self, "lbShortcut"..count);
					RefreshCalendarEventShortcut(lbShortcut, v, name);
					if count >= 3 then break end
				end
			end
		end
		if count >= 3 then break end
	end
	for i = count + 1, 3 do
		local lbShortcut = SAPI.GetChild(self, "lbShortcut"..i);
		RefreshCalendarEventShortcut(lbShortcut);
	end
	local btUserEvent = SAPI.GetChild(self, "btUserEvent");
	if hint == "" then
		btUserEvent:Hide();
	else
		btUserEvent:Show();
		btUserEvent:SetHintText(hint);
	end
	self:SetHintText(hint);
end

local function RefreshCalendarWeek(self)
	for i = 1, 7 do
		local cbCalendarDay = SAPI.GetChild(self, "cbCalendarDay"..i);
		RefreshCalendarDay(cbCalendarDay, self);
	end
end

local function RefreshMonthText(self)
	if self == nil then self = uiGetglobal("layWorld.frmCalendar.btMonthText") end
	--btMonthText:SetText(tostring(DayListInMonth.Month));
	if FocusYear and FocusMonth and FocusCalendarDay then
		self:SetText(string.format("%04d/%02d/%02d", FocusYear, FocusMonth, FocusDayInMonth.DayInMonth))
	end
end

local function RefreshCalendarMonth(self)
	FocusYear = DayListInMonth.Year;
	FocusMonth = DayListInMonth.Month;
	if FocusDayInMonth == nil then
		FocusDayInMonth = DayListInMonth:FindToday();
	elseif FocusDayInMonth.DayInMonth > DayListInMonth.DayCount then
		FocusDayInMonth = DayListInMonth:FindDayByDayInMonth(DayListInMonth.DayCount);
	else
		FocusDayInMonth = DayListInMonth:FindDayByDayInMonth(FocusDayInMonth.DayInMonth);
	end
	for i = 1, 6 do
		local lbCalendarWeek = SAPI.GetChild(self, "lbCalendarWeek"..i);
		RefreshCalendarWeek(lbCalendarWeek);
	end
	
	local btMonthText = SAPI.GetSibling(self, "btMonthText");
	RefreshMonthText(btMonthText);
end

local init = false;
local function Init()
	if init == false then
		local now = uiGetServerTime();
		local year, month, day, hour, minute, second, millisecond, dayofweek = uiFormatTime(now);
		DayListInMonth:LoadToday();
		DayListInMonth:LoadDayList(year, month);
		init = true;
	end
end

-- 刷新日历数据
local function RefreshCalendarData(name)
	if not name then return end
	local Name, EventCount = uiCalendarGetCalendarInfo(name);
	if Name == nil or Name ~= name then CalendarList:DeleteCalendar(name) return end
	local Calendar = CalendarList:GetCalendar(name);
	Calendar:SetName(name);
	local idlist = uiCalendarGetEventIdList(name);
	Calendar:ClearEvent();
	if not idlist then return end
	for i, v in ipairs(idlist) do
		local ID, Type, DetailsType, StartTime, StopTime, DurationTime, TimeFormat, Name, Desc, Recever = uiCalendarGetEventInfo(name, v);
		if ID then
			Calendar:CreateEvent(ID, Type, DetailsType, StartTime, StopTime, DurationTime, TimeFormat, Name, Desc, Recever);
		end
	end
	Init();
	DayListInMonth:LoadEvent(name);
	RefreshCalendarMonth(uiGetglobal("layWorld.frmCalendar.lbCalendarMonth"));
end

function layWorld_frmCalendar_OnShow(self)
	Init();
	local lbCalendarMonth = SAPI.GetChild(self, "lbCalendarMonth");
	DayListInMonth:LoadToday();
	DayListInMonth:LoadCurMonth();
	FocusCalendarDay = nil;
	FocusYear = nil;
	FocusMonth = nil;
	FocusDayInMonth = nil;
	DayListInMonth:LoadAllEvent();
	RefreshCalendarMonth(lbCalendarMonth);
	uiGetglobal("layWorld.btShowCalendar"):Hide();
end


function layWorld_frmCalendar_OnLoad(self)
	self:RegisterScriptEventNotify("EVENT_CalendarUpdateOne");
	self:RegisterScriptEventNotify("EVENT_CalendarEventSyncFromOther");
	self:RegisterScriptEventNotify("EVENT_CalendarNewDay");
	self:RegisterScriptEventNotify("EVENT_ToggleCalendar");
end

function layWorld_frmCalendar_OnEvent(self, event, args)
	if event == "EVENT_CalendarUpdateOne" then
		local name = args[1];
		RefreshCalendarData(name);
		if self:getVisible() == false then
			uiGetglobal("layWorld.btShowCalendar"):ShowAndFocus();
		end
	elseif event == "EVENT_CalendarEventSyncFromOther" then
		local event_name = args[1];
		local desc = args[2];
		local user_name = args[4];
		local event_id = args[5];
		local msgbox = uiMessageBox(string.format(LAN("msg_calendar_event_sync_from_other_ask"), user_name, event_name, desc), "", true, true, true);
		SAPI.AddDefaultMessageBoxCallBack(msgbox,function (_, args) uiCalendarSyncEventFromOther(args.name, args.id) end, nil, {id=event_id,name=user_name});
	elseif event == "EVENT_CalendarNewDay" then
		DayListInMonth:LoadToday();
		RefreshCalendarMonth(SAPI.GetChild(self, "lbCalendarMonth"));
	elseif event == "EVENT_ToggleCalendar" then
		if self:getVisible() then
			self:Hide();
		else
			self:ShowAndFocus();
		end
	end
end

function layWorld_frmCalendar_btNextMonth_OnLClick(self)
	DayListInMonth:LoadNextMonth();
	DayListInMonth:LoadAllEvent();
	RefreshCalendarMonth(SAPI.GetSibling(self, "lbCalendarMonth"));
end

function layWorld_frmCalendar_btPreMonth_OnLClick(self)
	DayListInMonth:LoadPreMonth();
	DayListInMonth:LoadAllEvent();
	RefreshCalendarMonth(SAPI.GetSibling(self, "lbCalendarMonth"));
end

function layWorld_frmCalendar_btCurMonth_OnLClick(self)
	DayListInMonth:LoadCurMonth();
	DayListInMonth:LoadAllEvent();
	RefreshCalendarMonth(SAPI.GetSibling(self, "lbCalendarMonth"));
end


------------------------------------------------

local function UpdateCalendarEventList(self)
	local edbDesc = SAPI.GetSibling(self, "edbDesc");
	local Desc = "";
	edbDesc:SetText(Desc);
	self:RemoveAllLines(false);
	FocusEventList = {};
	if FocusDayInMonth then
		local count = 0;
		for name, v in pairs(FocusDayInMonth.EventList) do
			for i, v in ipairs(v) do
				self:InsertLine(-1, -1, -1);
				self:SetLineItem(count, 0, v:GetName(), -1);
				table.insert(FocusEventList, v);
				if ClickShortcutId == v:GetId() and ClickShortcutName == name then
					self:SetSelect(count);
				end
				count = count + 1;
			end
		end
	end
	ClickShortcutId = 0;
end
local function UpdateCalendarEventView(self)
	if not self then self = uiGetglobal("layWorld.frmCalenderEventView") end
	if self:getVisible() == false then return end
	local lsbEventName = SAPI.GetChild(self, "lsbEventName");
	UpdateCalendarEventList(lsbEventName);
end
local function UpdateCalendarUserEventList(self)
	local edbDesc = SAPI.GetSibling(self, "edbDesc");
	local Desc = "";
	edbDesc:SetText(Desc);
	self:RemoveAllLines(false);
	FocusUserEventList = {};
	if FocusDayInMonth then
		local count = 0;
		local v = FocusDayInMonth.EventList[USER_CALENDAR_NAME];
		if v then
			for i, v in ipairs(v) do
				self:InsertLine(-1, -1, -1);
				self:SetLineItem(count, 0, v:GetName(), -1);
				table.insert(FocusUserEventList, v);
				count = count + 1;
			end
		end
	end
	ClickShortcutId = 0;
end
local function UpdateCalendarUserEventView(self)
	if not self then self = uiGetglobal("layWorld.frmCalenderUserEventView") end
	if self:getVisible() == false then return end
	local lsbEventName = SAPI.GetChild(self, "lsbEventName");
	UpdateCalendarUserEventList(lsbEventName);
end
function frmCalendar_TemplateCalendarDay_OnLClick(self)
	if FocusCalendarDay then FocusCalendarDay:SetChecked(false) end
	self:SetChecked(true);
	FocusCalendarDay = self;
	local dayid = self.ID;
	local weekid = SAPI.GetParent(self).ID;
	FocusDayInMonth = DayListInMonth:FindDay(weekid, dayid);
	FocusYear = DayListInMonth.Year;
	FocusMonth = DayListInMonth.Month;
	UpdateCalendarEventView();
	UpdateCalendarUserEventView();
	RefreshMonthText();
end
function frmCalendar_TemplateLabelEventShortcut_OnLClick(self)
	ClickShortcutId = self.EventId;
	ClickShortcutName = self.CalendarName;
	frmCalendar_TemplateCalendarDay_OnLClick(SAPI.GetParent(SAPI.GetParent(self)));
	local frmCalenderEventView = uiGetglobal("layWorld.frmCalenderEventView");
	if frmCalenderEventView:getVisible() == false then
		frmCalenderEventView:ShowAndFocus();
	end
end
function frmCalendar_TemplateCalendarDay_btUserEvent_OnLClick(self)
	frmCalendar_TemplateCalendarDay_OnLClick(SAPI.GetParent(self));
	uiGetglobal("layWorld.frmCalenderUserEventView"):ShowAndFocus();
end
function layWorld_frmCalendarEventView_lsbEventName_OnSelect(self)
	local edbDesc = SAPI.GetSibling(self, "edbDesc");
	local select = self:getSelectLine();
	if select == -1 then
		edbDesc:SetText("");
	else
		edbDesc:SetText(FocusEventList[select + 1]:GetDesc());
	end
end

function layWorld_frmCalendarEventView_OnShow(self)
	UpdateCalendarEventView(self);
end

function layWorld_frmCalenderUserEventView_lsbEventName_OnSelect(self)
	local edbDesc = SAPI.GetSibling(self, "edbDesc");
	local select = self:getSelectLine();
	if select == -1 then
		edbDesc:SetText("");
	else
		edbDesc:SetText(FocusUserEventList[select + 1]:GetDesc());
		edbDesc:AppendText("\n");
		if FocusUserEventList[select + 1]:GetRecever() ~= "" then
			edbDesc:AppendText(LAN("msg_calendar_event_recever").." : ");
			edbDesc:AppendText(FocusUserEventList[select + 1]:GetRecever());
		end
	end
end

function layWorld_frmCalenderUserEventView_OnShow(self)
	UpdateCalendarUserEventView(self);
end

function layWorld_frmCalendarUserEventView_btDelete_OnLClick(self)
	local lsbEventName = SAPI.GetSibling(self, "lsbEventName");
	local select = lsbEventName:getSelectLine();
	if select == -1 then
		return; -- 请选中
	else
		uiCalendarDeleteUserEvent(FocusUserEventList[select + 1]:GetId());
	end
end

function layWorld_frmCalenderUserEventCreate_btCreate_OnLClick(self)
	if not FocusDayInMonth then uiClientMsg(LAN("msg_calendar_create_event_error5"), true) return end
	local edbName = SAPI.GetSibling(self, "edbName");
	local edbDesc = SAPI.GetSibling(self, "edbDesc");
	local edbRecever = SAPI.GetSibling(self, "edbRecever");
	if uiCalendarCreateUserEvent(edbName:getText(), edbDesc:getText(), edbRecever:getText(), DayListInMonth.Year, DayListInMonth.Month, FocusDayInMonth.DayInMonth) == true then
		-- 成功发送到服务器,等待服务器返回
		self:Disable();
	end
end
function layWorld_frmCalendar_cbxCalendarEventFilter_OnLoad(self)
	self:RemoveAllItems();
	for i, v in ipairs(EventTypeList) do
		self:AddItem(uiLanString(v), 0);
	end
	self:SelectItem(3);
end
function layWorld_frmCalendar_cbxCalendarEventFilter_OnUpdateText(self)
	local index = self:getSelectItemIndex();
	EventTypeList:DoSelect(index + 1);
	RefreshCalendarMonth(uiGetglobal("layWorld.frmCalendar.lbCalendarMonth"));
end
function layWorld_frmCalendar_btCreateUserEvent_OnLClick(self)
	local frmCalenderUserEventCreate = uiGetglobal("layWorld.frmCalenderUserEventCreate");
	frmCalenderUserEventCreate:ShowAndFocus();
end

function layWorld_frmCalenderUserEventCreate_OnLoad(self)
	self:RegisterScriptEventNotify("EVENT_CalendarEventCreateRep");
end

function layWorld_frmCalenderUserEventCreate_OnEvent(self, event, args)
	if event == "EVENT_CalendarEventCreateRep" then
		local result = args[2];
		local btCreate = SAPI.GetChild(self, "btCreate");
		if result == 0 then
			-- 创建事件成功
			local edbName = SAPI.GetChild(self, "edbName");
			edbName:SetText("");
			local edbDesc = SAPI.GetChild(self, "edbDesc");
			edbDesc:SetText("");
			local edbRecever = SAPI.GetChild(self, "edbRecever");
			edbRecever:SetText("");
			UpdateCalendarEventView();
			UpdateCalendarUserEventView();
		else
			-- 创建事件失败
		end
		btCreate:Enable();
	end
end

function layWorld_frmCalenderUserEventView_OnLoad(self)
	self:RegisterScriptEventNotify("EVENT_CalendarEventDeleteRep");
end

function layWorld_frmCalenderUserEventView_OnEvent(self, event, args)
	if event == "EVENT_CalendarEventDeleteRep" then
		local result = args[1];
		local btDelete = SAPI.GetChild(self, "btDelete");
		if result == 0 then
			-- 删除事件成功
			UpdateCalendarEventView();
			UpdateCalendarUserEventView();
		else
			-- 创建事件失败
		end
		btDelete:Enable();
	end
end








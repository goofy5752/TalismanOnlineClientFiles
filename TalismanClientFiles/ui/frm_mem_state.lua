
function layWorld_hntMemState_OnLoad(self)
	self:RegisterScriptEventNotify("EVENT_TargetRefresh");
	self:RegisterScriptEventNotify("TargetChanged");
end

function layWorld_hntMemState_OnEvent(self, event, args)
	if event == "EVENT_TargetRefresh" or event == "TargetChanged" then
		layWorld_hntMemState_Refresh(self);
	end
end

function layWorld_hntMemState_Refresh(self)
	if not self then self = uiGetglobal("layWorld.hntMemState") end
	local size, attrlist, valuelist = uiDebugShowMemoryUsed();
	
	if not attrlist or not valuelist then self:Hide() return end
	if table.getn(attrlist) ~= table.getn(valuelist) then self:Hide() return end
	
	
	local result = 
	{
		GetTotleValue = function (self)
			local total = 0;
			for i, v in ipairs(self) do
				total = total + v.Value;
			end
			return total;
		end
	};
	for i, v in ipairs(attrlist) do
		local _, _, FileName = string.find(v, "[/\\]([^/\\]-[/\\][^/\\]-[/\\][^/\\]-)$")
		if not FileName then FileName = v end
		table.insert(result, {FileName=FileName, Value=valuelist[i]});
	end
	
	local sortfunc = function (v1, v2)
		return v1.Value > v2.Value;
	end
	table.sort(result, sortfunc);
	
	local rich_text = EvUiLuaClass_RichText:new();
	
	local line = EvUiLuaClass_RichTextLine:new();
	local item = EvUiLuaClass_RichTextItem:new();
	item.Color = string.format("#FFFF0000");
	
	local Totle = result:GetTotleValue();
	local M = math.floor(Totle / (1000*1000));
	local K = math.floor(math.mod(Totle / 1000, 1000));
	local B = math.floor(math.mod(Totle, 1000));
	if M > 0 then
		item.Text = string.format("Totle : %d,%03d,%03d B", M, K, B);
	elseif K > 0 then
		item.Text = string.format("Totle : %d,%03d B", K, B);
	else
		item.Text = string.format("Totle : %d B", B);
	end
	line:InsertItem(item);
	rich_text:InsertLine(line);
	
	for i, v in ipairs(result) do
		local line = EvUiLuaClass_RichTextLine:new();
		
		
		local item = EvUiLuaClass_RichTextItem:new();
		item.Color = string.format("#FFFFFF00");
		item.Text = tostring(i).." ";
		line:InsertItem(item);
		
		local item = EvUiLuaClass_RichTextItem:new();
		item.Color = string.format("#FFFFFF00");
		item.Text = tostring(v.FileName);
		line:InsertItem(item);
		
		local item = EvUiLuaClass_RichTextItem:new();
		item.Color = string.format("#FFFFFFFF");
		item.Text = " = ";
		line:InsertItem(item);
		
		local item = EvUiLuaClass_RichTextItem:new();
		item.Color = string.format("#FF80FFFF");

		local M = math.floor(v.Value / (1000*1000));
		local K = math.floor(math.mod(v.Value / 1000, 1000));
		local B = math.floor(math.mod(v.Value, 1000));
		if M > 0 then
			item.Text = string.format("%d,%03d,%03d B", M, K, B);
		elseif K > 0 then
			item.Text = string.format("%d,%03d B", K, B);
		else
			item.Text = string.format("%d B", B);
		end
		line:InsertItem(item);
		
		
		rich_text:InsertLine(line);
	end
	--uiInfo(rich_text:ToRichString());
	self:SetRichText(rich_text:ToRichString());
	if self:getVisible() ~= true then
		self:ShowAndFocus();
	end
end






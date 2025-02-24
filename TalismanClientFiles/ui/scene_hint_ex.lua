
function layWorld_hntScreneHint_OnLoad(self)
	self:RegisterScriptEventNotify("EVENT_MouseMoveOnCreature");
	self:RegisterScriptEventNotify("EVENT_MouseMoveLeaveCreature");
end

function layWorld_hntScreneHint_OnEvent(self, event, args)
	if event == "EVENT_MouseMoveOnCreature" then
		layWorld_hntScreneHint_OnEvent_MouseMoveOnCreature(self, event, args);
	elseif event == "EVENT_MouseMoveLeaveCreature" then
		layWorld_hntScreneHint_OnEvent_MouseMoveLeaveCreature(self, event, args);
	end
end

function layWorld_hntScreneHint_OnEvent_MouseMoveOnCreature(self, event, args)
	local id = args[1];
	local name = uiCreatureGetDataByObjectId(id);
	if name == nil then return end
	
	local rtext = EvUiLuaClass_RichText:new();
	local line = EvUiLuaClass_RichTextLine:new();
	local item = EvUiLuaClass_RichTextItem:new();
	item.Text = name;
	item.Font = LAN("font_title");
	item.FontSize = tonumber(LAN("font_s_17"));
	item.Color = "#ff33d058";
	line:InsertItem(item);
	rtext:InsertLine(line);
	
	self:SetRichText(rtext:ToRichString());
	self:ActiveAnchor();
	self:ShowAndFocus();
end
function layWorld_hntScreneHint_OnEvent_MouseMoveLeaveCreature(self, event, args)
	self:Hide();
end





local HelpList = {};

function layWorld_frmEventReview_OnLoad(self)
	self:RegisterScriptEventNotify("EVENT_NewHelpPrompt");
end

function layWorld_frmEventReview_OnEvent(self, event, args)
	if event == "EVENT_NewHelpPrompt" then
		local ltEvent = SAPI.GetChild(self, "ltEvent");
		local Type, Content, Readed = args[1], args[2], false;
		local Title = "";
		if Type == "text" then
			Title = Content;
		elseif Type == "richtext" then
			local level = uiGetMyInfo("Exp")
			Title = "Lev."..level.."提示";
		elseif Type == "file" then
			local level = uiGetMyInfo("Exp")
			Title = "Lev."..level.."提示";
		else
			return;
		end
		table.insert(HelpList, {Title=Title, Type=Type, Content=Content, Readed=Readed, });
		ltEvent:InsertLine(-1, -1, -1);
		ltEvent:SetLineItem(ltEvent:getLineCount() - 1, 0, tostring(ltEvent:getLineCount()), -1);
		ltEvent:SetLineItem(ltEvent:getLineCount() - 1, 1, Title, -1);
	end
end

local function OnEventSelect(self)
	local ebxEventDescription = SAPI.GetSibling(self, "ebxEventDescription");
	local line = self:getSelectLine();
	HelpLine = HelpList[line+1];
	if HelpLine == nil then return end
	if not HelpLine.Readed then
		self:SetLineItem(line, 0, tostring(line+1), 4286611584);
		self:SetLineItem(line, 1, HelpLine.Title, 4286611584);
		HelpLine.Readed = true;
	end
	local Type = HelpLine.Type;
	local Content = HelpLine.Content;
	if Type == "text" then
		ebxEventDescription:SetText(Content);
	elseif Type == "richtext" then
		ebxEventDescription:SetRichText(Content, false);
	elseif Type == "file" then
		local bShow, filepath = uiHelpGetHelpConfig();
		ebxEventDescription:SetRichTextFile(filepath..Content, false);
	else
		ebxEventDescription:SetText("...");
	end
end

function layWorld_ltEvent_OnLDown(self)
	OnEventSelect(self);
end

function layWorld_btUpPage_OnLClick(self)
	local ltEvent = SAPI.GetSibling(self, "ltEvent");
	local line = ltEvent:getSelectLine();
	if not line or line < 0 then
		line = 0;
	elseif line > 0 then
		line = line - 1;
	else
		return;
	end
	
	ltEvent:SetSelect(line);
	OnEventSelect(ltEvent);
end

function layWorld_btDownPage_OnLClick(self)
	local ltEvent = SAPI.GetSibling(self, "ltEvent");
	local count = ltEvent:getLineCount();
	if not count or count <= 0 then return end
	local line = ltEvent:getSelectLine();
	if not line or line < 0 then
		line = 0;
	elseif line < count - 1 then
		line = line + 1;
	else
		return;
	end
	
	ltEvent:SetSelect(line);
	OnEventSelect(ltEvent);
end









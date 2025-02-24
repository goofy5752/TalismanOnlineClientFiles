
function layWorld_frmDeadEx_OnLoad(self)
	self:RegisterScriptEventNotify("EVENT_SelfDie");
	self:RegisterScriptEventNotify("EVENT_SelfRevive");
	self:RegisterScriptEventNotify("EVENT_SelfEnterWorld");
end

function layWorld_frmDeadEx_OnEvent(self, event, args)
	if event == "EVENT_SelfDie" then
		layWorld_frmDeadEx_OnEvent_SelfDie(self, event, args);
	elseif event == "EVENT_SelfRevive" then
		layWorld_frmDeadEx_OnEvent_SelfRevive(self, event, args);
	elseif event == "EVENT_SelfEnterWorld" then
		if uiUserIsDead() == true then
			self:Set("CheckItemRevive", false);
			self:ShowAndFocus();
		end
	end
end

function layWorld_frmDeadEx_OnEvent_SelfDie(self, event, args)
	self:Set("CheckItemRevive", false);
	self:ShowAndFocus();
end

function layWorld_frmDeadEx_OnEvent_SelfRevive(self, event, args)
	self:Hide();
end


function layWorld_frmDeadEx_btRewardOk_OnLCLick(self)
	uiUserRevive();
end

function layWorld_frmDeadEx_OnUpdate(self, delta)
	local ebRewardMessage = SAPI.GetChild(self, "ebRewardMessage");
	local btRewardOk = SAPI.GetChild(self, "btRewardOk");
	if uiUserIsDead() == false then self:Hide() return end
	local message = "you dead";
	if uiUserCanRevive() == true then		-- 允许复活
		local left = uiGetAutoReviveTimeLeft();		-- 自动复活剩余时间
		local h = math.floor(left / 3600);
		local m = math.floor(math.mod(left / 60, 60));
		local s = math.floor(math.mod(left, 60));
		if m > 0 then
			message = string.format("%d%s%s", m, LAN("user_dead_dialog1"), LAN("user_dead_dialog3"));
		else
			message = string.format("%d%s%s", s, LAN("user_dead_dialog2"), LAN("user_dead_dialog3"));
		end
		btRewardOk:Enable();
		local CheckItemRevive = self:Get("CheckItemRevive");
		if CheckItemRevive == false then
			self.CheckItemRevive = true;
			local nExp, nNimbus, nMoney = uiUserGetDeadPunish();
			--[[ 放到服务器上做
			if nExp > 0.5 or nNimbus > 0.5 then
				uiClientMsg(LAN("msg_dead_punish_prompt1"), false);
			else
				uiClientMsg(LAN("msg_dead_punish_prompt2"), false);
			end
			]]
			if (uiUserCanReviveWithItem(EV_ITEM_TYPE_NODEAD)) == true then
				if nExp and nExp > 0.5 then
					local frame = uiMessageBox(LAN("msg_no_dead_request"), "", true, true, false);
					SAPI.AddDefaultMessageBoxCallBack(frame, function() uiUserReviveWithItem(EV_ITEM_TYPE_NODEAD) end, function() uiUserExcludeItemTypeForAutoRevive(EV_ITEM_TYPE_NODEAD) end, nil, function(event, arg1, arg2, box, frame) if uiUserIsDead() ~= true then frame:Hide() end end);
				end
			end
			if (uiUserCanReviveWithItem(EV_ITEM_TYPE_NODEAD_SUPER)) == true then
				local frame = uiMessageBox(LAN("msg_super_no_dead_request"), "", true, true, false);
				SAPI.AddDefaultMessageBoxCallBack(frame, function() uiUserReviveWithItem(EV_ITEM_TYPE_NODEAD_SUPER) end, function() uiUserExcludeItemTypeForAutoRevive(EV_ITEM_TYPE_NODEAD_SUPER) end, nil, function(event, arg1, arg2, box, frame) if uiUserIsDead() ~= true then frame:Hide() end end);
			end
		end
	else									-- 不允许复活
		local left = uiGetCanReviveTimeLeft();		-- 允许复活剩余时间
		message = string.format(LAN("user_dead_dialog8"), left);
		btRewardOk:Disable();
	end
	ebRewardMessage:SetText(message);
end







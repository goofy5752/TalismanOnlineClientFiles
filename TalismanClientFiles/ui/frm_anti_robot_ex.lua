
function frmAntiRobotEx_TemplateAnswerSelect_OnLClick(self)
	local btOk = SAPI.GetSibling(self, "btOk");
	for i = 1,4,1 do
		local ckb = SAPI.GetSibling(self, "ckb"..i);
		local isSelf = SAPI.Equal(ckb, self);
		ckb:SetChecked(isSelf);
	end
	btOk:Enable();
end

function layWorld_frmAntiRobotEx_OnLoad(self)
	self:RegisterScriptEventNotify("EVENT_AntiRobotRefreshQuestion");
	self:RegisterScriptEventNotify("EVENT_LockUser");
end

function layWorld_frmAntiRobotEx_OnEvent(self, event, args)
	if event == "EVENT_AntiRobotRefreshQuestion" then
		layWorld_frmAntiRobotEx_OnEvent_RefreshQuestion(self, event, args);
	elseif event == "EVENT_LockUser" then
		self:Hide();
	end
end

function layWorld_frmAntiRobotEx_OnEvent_RefreshQuestion(self, event, args)
	local text, image, answer1, answer2, answer3, answer4, duration = uiAntiRobotGetData();
	local edtBulletin = SAPI.GetChild(self, "edtBulletin");
	local lbundoImg = SAPI.GetChild(self, "lbundoImg");
	local ckb1 = SAPI.GetChild(self, "ckb1");
	local ckb2 = SAPI.GetChild(self, "ckb2");
	local ckb3 = SAPI.GetChild(self, "ckb3");
	local ckb4 = SAPI.GetChild(self, "ckb4");
	local btOk = SAPI.GetChild(self, "btOk");
	
	edtBulletin:SetText(text);
	if image == nil then image = 0 end
	lbundoImg:SetBackgroundImage(image);
	ckb1:SetText(answer1);
	ckb2:SetText(answer2);
	ckb3:SetText(answer3);
	ckb4:SetText(answer4);
	ckb1:SetChecked(false);
	ckb2:SetChecked(false);
	ckb3:SetChecked(false);
	ckb4:SetChecked(false);
	btOk:Disable();
	
	local End = os.clock() + duration;
	self:Set("End", End);
	
	self:ActiveAnchor();
	self:ShowAndFocus();
end

function layWorld_frmAntiRobotEx_OnUpdate(self,delta)
	local End = self:Get("End");
	local LeftTime = End - os.clock();
	if LeftTime < 0 then LeftTime = 0 end
	local m = math.floor(math.mod(LeftTime / 60, 60));
	local s = math.floor(math.mod(LeftTime, 60));
	local timestring = string.format(LAN("msg_anti_robot1"), m, s);
	lbTime = SAPI.GetChild(self, "lbTime");
	lbTime:SetText(timestring);
end

function layWorld_frmAntiRobotEx_OnShow(self)
	local rcView = EvUiLuaClass_Rect:new(uiGetGameViewRect());
	local rcSelf = EvUiLuaClass_Rect:new(uiGetWidgetRect(self));
	local rcRandom = rcView:Clone();
	rcRandom:Inflate(0, -145, -200, -87);
	rcRandom:Inflate(0, 0, -rcSelf:GetWidth(), -rcSelf:GetHeight());
	if rcRandom.width < 1 then rcRandom.width = 1 end
	if rcRandom.height < 1 then rcRandom.height = 1 end
	local random_x = math.random(rcRandom.x, rcRandom:GetRight());
	local random_y = math.random(rcRandom.y, rcRandom:GetBottom());
	self:MoveTo(random_x, random_y);
	--self:MoveSize(rcRandom.x, rcRandom.y, rcRandom.width, rcRandom.height);
	local btHint = uiGetglobal("layWorld.frmAntiRobotAlertEx.btHint");
	btHint:SetFlicker(false);
end

function layWorld_frmAntiRobotEx_OnHide(self)
	local btHint = uiGetglobal("layWorld.frmAntiRobotAlertEx.btHint");
	btHint:SetFlicker(true);
end

function layWorld_frmAntiRobotEx_btOk_OnLClick(self)
	for i = 1,4,1 do
		local ckb = SAPI.GetSibling(self, "ckb"..i);
		if ckb:getChecked() == true then
			if uiAntiRobotAnswer(i) == true then
				local form = SAPI.GetParent(self);
				form:Hide();
				local frmAntiRobotAlertEx = uiGetglobal("layWorld.frmAntiRobotAlertEx");
				frmAntiRobotAlertEx:Hide();
			end
			return;
		end
	end
end

--------------------------------------
----  frmAntiRobotAlertEx   ---
--------------------------------------

function layWorld_frmAntiRobotAlertEx_OnLoad(self)
	self:RegisterScriptEventNotify("RefreshAntiRobotQuestion");
	self:RegisterScriptEventNotify("EVENT_LockUser");
end
function layWorld_frmAntiRobotAlertEx_OnEvent(self,event,arg)
	if event == "RefreshAntiRobotQuestion" then
		layWorld_frmAntiRobotAlertEx_OnEvent_RefreshAntiRobotQuestion(self, event, args);
	elseif event == "EVENT_LockUser" then
		self:Hide();
	end
end
function layWorld_frmAntiRobotAlertEx_OnEvent_RefreshAntiRobotQuestion(self, event, args)
	local text, image, answer1, answer2, answer3, answer4, duration = uiAntiRobotGetData();
	local End = os.clock() + duration;
	self:Set("End", End);
	
	self:ShowAndFocus();
end
function layWorld_frmAntiRobotAlertEx_OnUpdate(self,delta)
	local End = self:Get("End");
	local LeftTime = End - os.clock();
	if LeftTime < 0 then LeftTime = 0 end
	local m = math.floor(math.mod(LeftTime / 60, 60));
	local s = math.floor(math.mod(LeftTime, 60));
	local message = string.format(LAN("msg_anti_robot1"), m, s);
	lbTimeLeft = SAPI.GetChild(self, "lbTimeLeft");
	lbTimeLeft:SetText(message);
end

function layWorld_frmAntiRobotAlertEx_btHint_OnLClick(self)
	local frmAntiRobotEx = uiGetglobal("layWorld.frmAntiRobotEx");
	--frmAntiRobotEx:ActiveAnchor();
	frmAntiRobotEx:ShowAndFocus();
end
		
--------------------------------------
----        frmLockUserEx      ---
--------------------------------------
function layWorld_frmLockUserEx_OnLoad(self)
	self:RegisterScriptEventNotify("EVENT_LockUser");
	self:RegisterScriptEventNotify("EVENT_UnlockUser");
end

function layWorld_frmLockUserEx_OnEvent(self,event,args)
	if event == "EVENT_LockUser" then
		layWorld_frmLockUserEx_OnEvent_LockUser(self, event, args);
	elseif event == "EVENT_UnlockUser" then
		layWorld_frmLockUserEx_OnEvent_UnlockUser(self, event, args);
	end
end

function layWorld_frmLockUserEx_OnEvent_LockUser(self, event, args)
	local LockDuration = args[1]; -- 延时
	self:Set("End", os.clock() + LockDuration);
	self:ShowAndFocus();
	layWorld_frmLockUserEx_OnUpdate(self, 0); -- update一次 刷新文本内容
end

function layWorld_frmLockUserEx_OnEvent_UnlockUser(self, event, args)
	self:Hide();
end

function layWorld_frmLockUserEx_OnUpdate(self,delta)
	local End = self:Get("End");
	local LeftTime = End - os.clock();
	if LeftTime < 0 then LeftTime = 0 end
	local h = math.floor(LeftTime / 3600);
	local m = math.floor(math.mod(LeftTime / 60, 60));
	local s = math.floor(math.mod(LeftTime, 60));
	local message = string.format(LAN("msg_anti_robot2"), h, m, s);
	edbLockReason = SAPI.GetChild(self, "edbLockReason");
	edbLockReason:SetText(message);
end












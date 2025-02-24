local LOCAL_RELEASE_PROGRESS_END = "LOCAL_RELEASE_PROGRESS_END";
local LOCAL_RELEASE_PROGRESS_START = "LOCAL_RELEASE_PROGRESS_START";

function layWorld_lbReleaseProgressEx_OnLoad(self)
	self:RegisterScriptEventNotify("EVENT_ReleaseProgressBegin");
	self:RegisterScriptEventNotify("EVENT_ReleaseProgressEnd");
	self:RegisterScriptEventNotify("EVENT_ReleaseProgressSynchronizRate");
end

function layWorld_lbReleaseProgressEx_OnEvent(self, event, _arg)
	if event == "EVENT_ReleaseProgressBegin" then
		layWorld_lbReleaseProgressEx_OnEvent_ReleaseProgressBegin(self, _arg);
	elseif event == "EVENT_ReleaseProgressEnd" then
		layWorld_lbReleaseProgressEx_OnEvent_ReleaseProgressEnd(self, _arg);
	elseif event == "EVENT_ReleaseProgressSynchronizRate" then
		layWorld_lbReleaseProgressEx_OnEvent_ReleaseProgressSynchronizRate(self, _arg);
	end
end

function layWorld_lbReleaseProgressEx_OnEvent_ReleaseProgressBegin(self, _arg)
	local pgbPreAct = SAPI.GetChild(self, "pgbPreAct");
	local pgbLoading = SAPI.GetChild(self, "pgbLoading");
	local pgbFail = SAPI.GetChild(self, "pgbFail");
	
	local Type = _arg[1];
	local StartTime = os.clock();
	local EndTime = StartTime + _arg[2]/1000;
	
	self:Set(LOCAL_RELEASE_PROGRESS_START, StartTime);
	self:Set(LOCAL_RELEASE_PROGRESS_END, EndTime);
	--[[
	pgbPreAct:Set(LOCAL_RELEASE_PROGRESS_START, StartTime);
	pgbLoading:Set(LOCAL_RELEASE_PROGRESS_START, StartTime);
	pgbPreAct:Set(LOCAL_RELEASE_PROGRESS_END, EndTime);
	pgbLoading:Set(LOCAL_RELEASE_PROGRESS_END, EndTime);
	]]
	
	if Type == EV_RELEASE_PROGRESS_TYPE_ACT then				-- 前置
		pgbPreAct:Show();
		pgbLoading:Hide();
		pgbFail:Hide();
		self:ShowAndFocus();
	elseif Type == EV_RELEASE_PROGRESS_TYPE_LOADING then		-- 引导
		pgbPreAct:Hide();
		pgbLoading:Show();
		pgbFail:Hide();
		self:ShowAndFocus();
	else														-- 无效
		pgbFail:Show();
		self:Hide();
	end
end

function layWorld_lbReleaseProgressEx_OnEvent_ReleaseProgressEnd(self, _arg)
	local pgbPreAct = SAPI.GetChild(self, "pgbPreAct");
	local pgbLoading = SAPI.GetChild(self, "pgbLoading");
	local pgbFail = SAPI.GetChild(self, "pgbFail");
	
	local Result = _arg[1];
	
	if Result == EV_RELEASE_PROGRESS_RESULT_SUCCESS then		-- 成功
	else														-- 失败
		pgbPreAct:Hide();
		pgbLoading:Hide();
		pgbFail:Show();
	end
	
	self:Hide();
end

function layWorld_lbReleaseProgressEx_OnEvent_ReleaseProgressSynchronizRate(self, _arg)
	local Rate = _arg[1] / 100;
	local StartTime = self:Get(LOCAL_RELEASE_PROGRESS_START);
	local EndTime = self:Get(LOCAL_RELEASE_PROGRESS_END);
	local Now = os.clock();
	
	local TotleTime = EndTime - StartTime;
	if TotleTime <= 0 then return end
	
	StartTime = Now - TotleTime * Rate;
	EndTime = StartTime + TotleTime;
	
	self:Set(LOCAL_RELEASE_PROGRESS_START, StartTime);
	self:Set(LOCAL_RELEASE_PROGRESS_END, EndTime);
end

function layWorld_lbReleaseProgressEx_pgbPreAct_OnUpdate(self, delta)
	local Parent = SAPI.GetParent(self);
	local StartTime = Parent:Get(LOCAL_RELEASE_PROGRESS_START);
	local EndTime = Parent:Get(LOCAL_RELEASE_PROGRESS_END);
	local Now = os.clock();
	
	local TotleTime = EndTime - StartTime;
	if TotleTime <= 0 then return end
	
	local PassTime = Now - StartTime;
	if PassTime < 0 then return end
	if PassTime >= TotleTime then PassTime = TotleTime end
	
	local rate = PassTime / TotleTime;
	
	self:SetValue(rate);
end

function layWorld_lbReleaseProgressEx_pgbLoading_OnUpdate(self, delta)
	local Parent = SAPI.GetParent(self);
	local StartTime = Parent:Get(LOCAL_RELEASE_PROGRESS_START);
	local EndTime = Parent:Get(LOCAL_RELEASE_PROGRESS_END);
	local Now = os.clock();
	
	local TotleTime = EndTime - StartTime;
	if TotleTime <= 0 then return end
	
	local PassTime = Now - StartTime;
	if PassTime < 0 then return end
	if PassTime >= TotleTime then PassTime = TotleTime end
	
	local rate = 1 - (PassTime / TotleTime);
	
	self:SetValue(rate);
end






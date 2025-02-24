
function layWorld_frmCountDown_OnLoad(self)
	self:Delete("End");
	self:ActiveAnchor();
end

function layWorld_frmCountDown_OnUpdate(self, delta)
	if self:Get("End")==nil then
		self:Set("End",os.clock() + self:Get("Left"));
		
		local message = self:Get("Msg");
		local edbMessage = SAPI.GetChild(self, "edbMessage");
		edbMessage:SetText(message);
	end

	local left = self:Get("End")-os.clock();
	if left < 0 then
		self:Hide();
		return;
	end
	local h = math.floor(left / 3600);
	local m = math.floor(math.mod(left / 60, 60));
	local s = math.floor(math.mod(left, 60));
	local timeformat = string.format("%02d:%02d:%02d", h, m, s);
	local lbTime = SAPI.GetChild(self, "lbTime");
	lbTime:SetText(timeformat);
end

















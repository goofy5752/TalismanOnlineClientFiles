function layWorld_frmPointCardEx_OnLoad(self)
    self:RegisterScriptEventNotify("EVENT_UserCardSave");
    self:RegisterScriptEventNotify("EVENT_UserUseCardRep");
end

function layWorld_frmPointCardEx_OnEvent(self,event,arg)
    local edbCardNumber=SAPI.GetChild(self,"edbCardNumber");
    local edbCardPsWord=SAPI.GetChild(self,"edbCardPsWord");

    if event=="EVENT_UserCardSave" then          
        edbCardNumber:SetText("");
        edbCardPsWord:SetText("");
        self:ShowAndFocus();   
	elseif event=="EVENT_UserUseCardRep" then
		local ret = arg[1];
		local btRewardOk=SAPI.GetChild(self,"btRewardOk");
		local edbCardNumber=SAPI.GetChild(self,"edbCardNumber");
		local edbCardPsWord=SAPI.GetChild(self,"edbCardPsWord");
		btRewardOk:Enable();
		if ret == 1 then
			-- ³É¹¦
			edbCardNumber:SetText("");
			edbCardPsWord:SetText("");
		else
			-- Ê§°Ü
		end
    end
end

function layWorld_frmPointCardEx_OnShow(self)
	local btRewardOk=SAPI.GetChild(self,"btRewardOk");
	btRewardOk:Enable();
end

function layWorld_frmPointCardEx_OnUpdate(self,delta)
	local bInside = uiPointCardCheckDistance();
	if bInside == false then
		self:Hide();
	end   
end

function layWorld_frmPointCardEx_btRewardOk_OnLClick(self)
    local frmPointCardEx=uiGetglobal("layWorld.frmPointCardEx");
    local edbCardNumber=SAPI.GetChild(frmPointCardEx,"edbCardNumber");
    local edbCardPsWord=SAPI.GetChild(frmPointCardEx,"edbCardPsWord");
    local btRewardOk=SAPI.GetChild(frmPointCardEx,"btRewardOk");
    local stredbCardNumber=edbCardNumber:getText();
    local stredbCardPsWord=edbCardPsWord:getText();
    local ret=uiPointCardUsePointCard(stredbCardNumber,stredbCardPsWord);
    if ret then
		btRewardOk:Disable();   
	end
end

function layWorld_frmPointCardEx_btRewardClose_OnLClick(self)
    local frmPointCardEx=uiGetglobal("layWorld.frmPointCardEx");
    frmPointCardEx:Hide();
end
function layWorld_frmTeachpointEx_OnLoad(self)
     self:RegisterScriptEventNotify("EVENT_OpenTeacherPointChange");
end

function layWorld_frmTeachpointEx_OnEvent(self,event,arg)
    local frmTeachpointEx=uiGetglobal("layWorld.frmTeachpointEx");
    local edbTeachpointNumber=SAPI.GetChild(frmTeachpointEx,"edbTeachpointNumber");
    
    if event=="EVENT_OpenTeacherPointChange" then
        if frmTeachpointEx:getVisible()==true then
             frmTeachpointEx:Hide();
        else
             edbTeachpointNumber:SetText("0");
             layWorld_frmTeachpointEx_Show();
             frmTeachpointEx:ShowAndFocus();
        end
    end
end

function layWorld_frmTeachpointEx_OnShow(self)
	uiRegisterEscWidget(self);
end

function layWorld_frmTeachpointEx_Show()
     local frmTeachpointEx=uiGetglobal("layWorld.frmTeachpointEx"); 
    local lbCurTeachPoint=SAPI.GetChild(frmTeachpointEx,"lbCurTeachPoint");
    local lbGetCredit=SAPI.GetChild(frmTeachpointEx,"lbGetCredit");
    local edbTeachpointNumber=SAPI.GetChild(frmTeachpointEx,"edbTeachpointNumber");

    local myshidaozhi=uiSchoolGetMySchoolInfo();
    local useshidaozhi=edbTeachpointNumber:getText();
    local iuseshidaozhi=tonumber(useshidaozhi);
    local iChange=uiSchoolGetTeacherPointChangeInfo();

    lbCurTeachPoint:SetText(tostring(myshidaozhi));

    if tonumber(useshidaozhi)>tonumber(myshidaozhi) then
        edbTeachpointNumber:SetText(tostring(myshidaozhi));
        return 0;
    end
    if iuseshidaozhi and tonumber(iuseshidaozhi)>=0 and tonumber(iuseshidaozhi)<=tonumber(myshidaozhi) then
        lbGetCredit:SetText(tostring(iChange*iuseshidaozhi));
    end
end

function layWorld_frmTeachpointEx_edbTeachpointNumber_OnTextChanged(self)
    if self:getText() == "" then return end
    layWorld_frmTeachpointEx_Show();
end

function layWorld_frmTeachpointEx_OnUpdate(self,delta)
	-- 每秒检查一次与NPC之间的距离
	local bInside = uiSchoolCheckPointChangeDistance();
	if bInside == false then
		self:Hide();
	end   
end

function layWorld_frmTeachpointEx_btTeachpointOk_OnLClick(self)
    local frmTeachpointEx=uiGetglobal("layWorld.frmTeachpointEx");   
    local edbTeachpointNumber=SAPI.GetChild(frmTeachpointEx,"edbTeachpointNumber");
    local changeNumber=edbTeachpointNumber:getText();
    local ichangeNumber=tonumber(changeNumber);
    if ichangeNumber then
        uiSchoolChangeTeacherPoint(ichangeNumber);
        edbTeachpointNumber:SetText("0");
        layWorld_frmTeachpointEx_Show();
    end
end

function layWorld_frmTeachpointEx_btTeachpointClose_OnLClick(self)
    local frmTeachpointEx=uiGetglobal("layWorld.frmTeachpointEx");
    frmTeachpointEx:Hide();
end
function layWorld_frmNeedTeachEx_OnLoad(self)
     self:RegisterScriptEventNotify("RefreshRequestTeacherList");
end

function layWorld_frmNeedTeachEx_OnEvent(self,event,arg)
      if event=="RefreshRequestTeacherList" then
         self:ShowAndFocus();
		 layWorld_frmNeedTeachEx_Refresh(self);
      end
end

function layWorld_frmNeedTeachEx_OnShow(self)
	uiRegisterEscWidget(self);
end

function layWorld_frmNeedTeachEx_Refresh(self)
    local btAddteacher=SAPI.GetChild(self,"btAddteacher");
	btAddteacher:Disable();
    local btcheckin=SAPI.GetChild(self,"btcheckin");
    local btcheckout=SAPI.GetChild(self,"btcheckout");
    local lstNeedTeach=SAPI.GetChild(self,"lstNeedTeach");
	
    local inum = uiSchoolGetRegisterSchoolCount();
    local iCount = 0;

    local myLev = uiGetMyInfo("Exp");
    local myName = uiGetMyInfo("Role");
    local bContainSelf = false;
    local iSel = -1;

    lstNeedTeach:RemoveAllLines(true);

    for idx = 1, inum, 1 do
        --[[
        1.名字
        2.等级
        3.门派索引
        4.徒弟数量
        5.登记时间
        --]]
        local sname, level, party, teachnum, tm = uiSchoolGetRegisterSchoolInfo(iCount);
        local col = 4294967295;
        
        lstNeedTeach:InsertLine(12,col,-1);
        lstNeedTeach:SetLineItem(iCount,0,tostring(sname),col);
        lstNeedTeach:SetLineItem(iCount,1,tostring(level),col);
        lstNeedTeach:SetLineItem(iCount,2,tostring(uiGetPartyInfo(party)),col);

        lstNeedTeach:SetLineItem(iCount,3,tostring(teachnum),col);
       
        local yeah1, mon1, day1 = uiFormatTime(tm);       
        local ymd1 = string.format(uiLanString("msg_school16"), yeah1, mon1, day1);
        lstNeedTeach:SetLineItem(iCount, 4, tostring(ymd1), col);

        if tonumber(myLev) >= 30 and tostring(myName) == sname then
            bContainSelf = true;
            iSel = iCount;
        end
        iCount = iCount+1;
    end
    lstNeedTeach:SetSelect(iSel);
	
	if bContainSelf then
		btcheckin:Disable();
		btcheckout:Enable();
	else
		btcheckin:Enable();
		btcheckout:Disable();
	end
end

function layWorld_frmNeedTeachEx_lstNeedTeach_OnSelect(self)
    local myLev = uiGetMyInfo("Exp");
    local myName = uiGetMyInfo("Role");
	local sname = layWorld_frmNeedTeachEx_lstNeedTeach_getSelectName();
	local hasTeacher = uiSchoolGetTeacherSchoolInfo();
	local frmNeedTeachEx = SAPI.GetParent(self);
    local btAddteacher=SAPI.GetChild(frmNeedTeachEx,"btAddteacher");
	if myName ~= sname and not hasTeacher then
		btAddteacher:Enable();
	else
		btAddteacher:Disable();
	end
end

function layWorld_frmNeedTeachEx_lstNeedTeach_getSelectName()
    local frmNeedTeachEx=uiGetglobal("layWorld.frmNeedTeachEx");   
    local lstNeedTeach=SAPI.GetChild(frmNeedTeachEx,"lstNeedTeach");
    local seline;
    local sname="";
    seline=lstNeedTeach:getSelectLine();
    if seline>=0 then
        sname=lstNeedTeach:getLineItemText(seline,0);
    end
    return sname;
end

function layWorld_frmNeedTeachEx_btAddteacher_OnLClick(self)
    local sname=layWorld_frmNeedTeachEx_lstNeedTeach_getSelectName();
    if sname~="" then
        uiSchoolRequestEnterSchool(sname);
    end
end

function layWorld_frmNeedTeachEx_btcheckin_OnLClick(self)
    uiSchoolRegisterSchool();
end

function layWorld_frmNeedTeachEx_btcheckout_OnLClick(self)
    uiSchoolUnregisterSchool();
end
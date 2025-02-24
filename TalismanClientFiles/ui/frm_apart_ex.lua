--wj

local frm_apart_ex_objid;
function layWorld_frmApartEx_OnLoad(self)
    self:RegisterScriptEventNotify("EVENT_ItemUseIndirect");
end

function layWorld_frmApartEx_OnEvent(self,event,arg)
    if event=="EVENT_ItemUseIndirect" then
    --道具ObjectId  1
    --道具类型      2
        uiInfo("frmApart:"..tostring(arg[1]));
        uiInfo("frmApart:"..tostring(arg[2]));

        if tonumber(arg[2]) == EV_ITEM_TYPE_ENDTEACHERRELATION then
        local frmApartEx=uiGetglobal("layWorld.frmApartEx");
            frm_apart_ex_objid=arg[1];            
            frmApartEx:Show();
        end
    end
end

function layWorld_frmApartEx_OnShow(self)
    
    local frmApartEx=uiGetglobal("layWorld.frmApartEx");

    uiInfo("layWorld_frmApartEx_OnShow!");
    local lbTeacherName=uiGetglobal("layWorld.frmApartEx.lbteacher.lbTeacherName"); --SAPI.GetChild(frmApartEx,"lbTeacherName");
    local ltStudentName=uiGetglobal("layWorld.frmApartEx.lbStudent.ltstudent.ltStudentName");--frmApartEx,"ltStudentName");

    --Button State
    local btApart1=uiGetglobal("layWorld.frmApartEx.lbteacher.btApart");
    local btApart2=uiGetglobal("layWorld.frmApartEx.lbStudent.btApart");

    --获取师傅名字
    local bTeacher,strTeacher,_,_,_,iShixiongCnt=uiSchoolGetTeacherSchoolInfo();
    if bTeacher == false then
        btApart1:Disable();
        lbTeacherName:SetText("");
    else
        local playname,_,_=uiGetMyInfo("Role");
        for iSx=0,iShixiongCnt-1,1 do
            local myname,_,_,_,mystate,_,_,_=uiSchoolGetTeacherSchoolStudentInfo(iSx);
            if tostring(myname)==tostring(playname) then
                if mystate == 1 then
                    btApart1:Enable();
                    lbTeacherName:SetText(tostring(strTeacher));        
                else
                    btApart1:Disable();
                    lbTeacherName:SetText("");
                end
            end
        end
    end

    --获取徒弟名字
    ltStudentName:RemoveAllLines(true);    

    local _,_,tudinum=uiSchoolGetMySchoolInfo();
    local col=4294967295;
    uiInfo("tudinum:"..tudinum);

    btApart2:Disable();
    local iCount=0;

    for i=0,tudinum-1,1 do
        local strtname,itlev,_,_,bState,_,_,lastreporttm=uiSchoolGetMySchoolStudentInfo(i);       

        if bState == 1 then
            btApart2:Enable(); 
            ltStudentName:InsertLine(-1,col,-1);
            ltStudentName:SetLineItem(iCount,0,tostring(strtname),col);
            ltStudentName:SetLineItem(iCount,1,tostring(itlev),col);             
            local yeah1,mon1,day1=uiFormatTime(lastreporttm);       
            local ymd1=string.format(uiLanString("msg_school16"),yeah1,mon1,day1);
            ltStudentName:SetLineItem(iCount,2,tostring(ymd1),col);
            uiInfo("na:"..tostring(strtname).."lev:"..tostring(itlev).."reporttm:"..tostring(ymd1));
            iCount=iCount+1;
        end
        
    end
    ltStudentName:SetSelect(0);

end


function layWorld_frmApartEx_lbteacher_btApart_OnLClick(self)
    local _,strTeacher,_,_,_,_=uiSchoolGetTeacherSchoolInfo();
    local wordmess = string.format(uiLanString("msg_school_leave"),tostring(strTeacher));
    local msgBox = uiMessageBox(wordmess,"",true,true,true);
    SAPI.AddDefaultMessageBoxCallBack(msgBox,layWorld_frmApartEx_lbteacher_btApart_Yes,layWorld_frmApartEx_lbteacher_btApart_No,nil);    
end

function layWorld_frmApartEx_lbteacher_btApart_Yes(_,iParam)    
    uiInfo("uiSchoolLeaveSchoolbyItem:"..tostring(frm_apart_ex_objid));
    uiSchoolLeaveSchoolbyItem(frm_apart_ex_objid);
    local frmApartEx=uiGetglobal("layWorld.frmApartEx");
    frmApartEx:Hide();
end

function layWorld_frmApartEx_lbteacher_btApart_No(_,iParam)

end

function layWorld_frmApartEx_lbStudent_btApart_OnLClick(self)
    local ltStudentName=uiGetglobal("layWorld.frmApartEx.lbStudent.ltstudent.ltStudentName");
    local line=ltStudentName:getSelectLine();
    if line>=0 then
        local studiname=ltStudentName:getLineItemText(line,0);
        if studiname then
            local wordmess =  string.format(uiLanString("msg_school_leave"),tostring(studiname));
            local msgBox = uiMessageBox(wordmess,"",true,true,true);
            SAPI.AddDefaultMessageBoxCallBack(msgBox,layWorld_frmApartEx_lbStudent_btApart_Yes,layWorld_frmApartEx_lbStudent_btApart_No,studiname);   
        end
    end

   
end

function layWorld_frmApartEx_lbStudent_btApart_Yes(_,studiname)
    uiInfo("layWorld_frmApartEx_lbStudent_btApart_Yes");
    uiSchoolKickStudentbyItem(tostring(studiname),frm_apart_ex_objid);  
    local frmApartEx=uiGetglobal("layWorld.frmApartEx");
    frmApartEx:Hide();
end

function layWorld_frmApartEx_lbStudent_btApart_No(_,iParam)

end
frmTaskListEx={};--DATA REV
frmTaskListExTreeName={};--Left and Right Tree Name




function layWorld_frmTaskListEx_OnLoad(self)
    self:RegisterScriptEventNotify("ToggleTask");
    self:RegisterScriptEventNotify("event_update_task");
    self:RegisterScriptEventNotify("EVENT_SelfLevelUp");
    --BindCallBack("task", "locate", "default", tasklocatefun);    
end

function layWorld_frmTaskListEx_OnEvent(self,event,arg)
--开关任务界面（T）
    if event =="ToggleTask" then
        if arg[1] == EV_EXCUTE_EVENT_KEY_DOWN or arg[1] == EV_EXCUTE_EVENT_ON_LCLICK then
            if self:getVisible()==false then    
                local ebTaskText=uiGetglobal("layWorld.frmTaskListEx.ebTaskText");
                ebTaskText:ScrollToTop();
                self:ShowAndFocus();                               
            else
                self:Hide();
            end
        end 
    elseif event == "event_update_task"  or "EVENT_SelfLevelUp" then
        local tlTask=uiGetglobal("layWorld.frmTaskListEx.tlTask");
        layWorld_frmTaskListEx_Show(self);
        layWorld_frmTaskListEx_tlTask_OnSelect(tlTask);
        layWorld_lbTrackTaskEx_Show();
    end --ToggleTask
    
end

function layWorld_frmTaskListEx_ckbAcceptTask_OnLClick(self)
    local frmTaskListEx=uiGetglobal("layWorld.frmTaskListEx");    
    local tlTask=uiGetglobal("layWorld.frmTaskListEx.tlTask");
    layWorld_frmTaskListEx_Show(frmTaskListEx); 
    layWorld_frmTaskListEx_tlTask_OnSelect(tlTask);
end

function layWorld_frmTaskListEx_ebTaskText_OnHyperLink(self, hypertype, hyperlink)
    if hyperlink ~= nil then
        Receive(hyperlink);
    end
end

function layWorld_frmTaskListEx_ebTaskText_OnMouseMove(self,x,y)
	self:SetAutoHintPosition(false);
	local pHint=uiGetDefaultHint();
    local Item;
	local ItemHint = 0;
    if x ~=nil and y ~= nil then
        Item=self:PickItem(x,y);
        if Item ~= nil then
            ItemHint=uiTaskGetRewardItemHint(Item);
            if ItemHint then
                --postion not ok yet
                local ItemRc=Item:GetRect();
				pHint:MoveTo(ItemRc.Right+60,ItemRc.Top); 
                pHint:HintAutoSize(0);
            end
        end
    end
	self:SetHintRichText(ItemHint);
	self:UpdateHint();
end



function layWorld_frmTaskListEx_Show(self)
    local TempTab={};
    local TempSubhead={};

    local tlTask; --LEFT TREE CONTROL
    local ebTaskText; --RIGHT TASK DETAIL     
    local ckbAcceptTask;    
    local head;
    tlTask =  SAPI.GetChild(self,"tlTask");
    ebTaskText = SAPI.GetChild(self,"ebTaskText");
    ckbAcceptTask = SAPI.GetChild(self,"ckbAcceptTask");

    --------------------------------------------------------------------------
    --DATA FEEDS
    local bIgnore;

    local strall_t=uiLanString("msg_task_can_accept_list");
    local streveryday_t=uiLanString("msg_task_can_accept_day_list");
    local strhighreward_t=uiLanString("msg_task_can_accept_day_high_list");


    --只显示等级接近的任务 
    bIgnore=ckbAcceptTask:getChecked();

    local CurSelect = nil;

    local selId = tlTask:Get("CurSelect");
    
    local strall=uiTaskGetCanAcceptTaskInfo(0,EV_LIST_TASK_ALL,bIgnore);
    local streveryday=uiTaskGetCanAcceptTaskInfo(0,EV_LIST_TASK_EVERYDAT,bIgnore);
    local strhighreward=uiTaskGetCanAcceptTaskInfo(0,EV_LIST_TASK_HIGHREWARD,bIgnore);

    tlTask:DeleteAllItems();
    head=tlTask:InsertItem(strall_t,0,0);    
    head:Set("TaskId", -1);
    head:Set("TaskDetail", strall);
    if not CurSelect and selId and selId == -1 then
        CurSelect = head;
    end
    head=tlTask:InsertItem(streveryday_t,0,head);  
    head:Set("TaskId", -2);
    head:Set("TaskDetail", streveryday);
    if not CurSelect and selId and selId == -2 then
        CurSelect = head;
    end
    head=tlTask:InsertItem(strhighreward_t,0,head);   
    head:Set("TaskId", -3);   
    head:Set("TaskDetail", strhighreward);
    if not CurSelect and selId and selId == -3 then
        CurSelect = head;
    end
    
    
    frmTaskListEx=uiTaskGetTaskList();
    local subhead=head;
    if frmTaskListEx~=nil then
        for key,value in pairs(frmTaskListEx) do
            subhead=tlTask:InsertItem(tostring(key),0,subhead);   --"成都城"            
            tlTask:Set(tostring(subhead),"");  
            TempSubhead[tostring(key)]=subhead;
            for kkey,kvalue in ipairs(value) do
                local Id=kvalue["Id"];
                local Title=kvalue["Name"];
                
                local isFinish=uiTaskCanFinishTask(Id);
                if isFinish==true then
                    Title=Title..uiLanString("msg_task_finished");
                end

                if kvalue["SpecialFlag"]~=nil then
                      local iSpecialFlag=tonumber(kvalue["SpecialFlag"]);
                      if iSpecialFlag==1 then --精英
                          Title=Title..uiLanString("msg_task_dif_1");
                      elseif iSpecialFlag==2 then --传说
                          Title=Title..uiLanString("msg_task_dif_2");
                      elseif iSpecialFlag==11 then --副本
                          Title=Title..uiLanString("msg_task_dif_3");
                      end
                end

                if kvalue["LimitPerDay"]~=nil and kvalue["LimitPerDay"]["Max"]~=nil and kvalue["LimitPerDay"]["Current"]~=nil then
                    Title=Title.."("..tostring(kvalue["LimitPerDay"]["Current"]).."/"..tostring(kvalue["LimitPerDay"]["Max"])..")";
                end

                if kvalue["RatePerDay"]~=nil and kvalue["RatePerDay"]["max"]~=nil and kvalue["RatePerDay"]["Current"]~=nil and kvalue["RatePerDay"]["Rate"]~=nil then
                    if tonumber(kvalue["RatePerDay"]["Current"])<=tonumber(kvalue["RatePerDay"]["max"]) then
                        Title=Title.."("..tostring(kvalue["RatePerDay"]["Rate"]).."%"..")";
                    end
                end

                local subnod=tlTask:InsertItem(Title,subhead,0);

                local ExpJibie;
                ExpJibie,_,_=uiGetMyInfo("Exp");
                local PlayerLevel=tonumber(ExpJibie);
                local TaskLevel=tonumber(kvalue["Level"]);

                if TaskLevel-PlayerLevel>=2 then
                    subnod:SetTextColor(0,0,255,255);
                elseif TaskLevel-PlayerLevel>=0 then
                    subnod:SetTextColor(0,255,255,255);
                elseif TaskLevel-PlayerLevel>=-5 then
                    subnod:SetTextColor(0,255,0,255);
                else
                    subnod:SetTextColor(170,170,170,255);
                end
                    

                -------------------------------------
                --通过id 获得Detail String
                TempTab=uiTaskGetTaskInfo(Id);
                subnod:Set("TaskId", Id);
                if TempTab then
					local Detail = TempTab.Detail;
					local TaskDetail = string.format("%s%s%s%s%s%s%s", Detail["begin"] , Detail["target"] , Detail["request"] , Detail["reward"] , Detail["title"] , Detail["desc"] , Detail["end"]);
                    subnod:Set("TaskDetail", TaskDetail);   
                end
                if selId and selId == Id then
                    CurSelect = subnod;
                end

            end
        end
    end
    --扩展开
    for k,v in pairs(TempSubhead) do
        tlTask:Expand(TempSubhead[k]);
    end
    if CurSelect then
        tlTask:Select(CurSelect);
    end

    

    
    tlTask:Refresh();  
end


function layWorld_frmTaskListEx_ShowRightEditSingle()    
    local self = uiGetglobal("layWorld.frmTaskListEx.tlTask");
    local ebTaskText = uiGetglobal("layWorld.frmTaskListEx.ebTaskText");
    local sel=self:getSelectItem();
    if sel then
        local id = sel:Get("TaskId");
        local TempTab={};
        if id == -1 or id == -2 or id == -3 then
            local richcontent = sel:Get("TaskDetail");
            if richcontent and richcontent ~= "" then
                ebTaskText:SetRichText(richcontent,false);
            else
                ebTaskText:SetText("");
            end
        end

        TempTab=uiTaskGetTaskInfo(id); 
        if TempTab ~=nil then
			local Detail = TempTab.Detail;
			local TaskDetail = string.format("%s%s%s%s%s%s%s", Detail["begin"] , Detail["target"] , Detail["request"] , Detail["reward"] , Detail["title"] , Detail["desc"] , Detail["end"]);
            local richcontent = TaskDetail;
            if richcontent and richcontent ~= "" then
                ebTaskText:SetRichText(richcontent,false);
            else
                ebTaskText:SetText("");
            end
        end
    else
        ebTaskText:SetText("");
    end
end

function layWorld_frmTaskListEx_tlTask_OnSelect(self)
   
    
    local ebTaskText; --RIGHT TASK DETAIL
    ebTaskText = uiGetglobal("layWorld.frmTaskListEx.ebTaskText");
    local sel=self:getSelectItem();
    self:Delete("CurSelect");
    if sel then
        local id = sel:Get("TaskId");
        if id then
            self:Set("CurSelect", id);
        end
        local richcontent = sel:Get("TaskDetail");

        if richcontent and richcontent ~= "" then
            ebTaskText:SetRichText(richcontent,false);
        else
            ebTaskText:SetText("");
        end
    else
        ebTaskText:SetText("");
    end    
    
    layWorld_frmTaskListEx_ShowRightEditSingle();
   
    local iid=self:Get("CurSelect");
    local ckbTrace=uiGetglobal("layWorld.frmTaskListEx.ckbTrace");
    if iid and iid ~= -1 and iid ~=-2 and iid ~=-3 then
         local bfind=false;
         local traceList={};
         traceList=uiTaskGetTraceTaskList();

         for k,v in pairs(traceList) do
             if tostring(v)==tostring(iid) then
                 --已经被追踪
                 ckbTrace:SetChecked(true); 
                 return 0;
             end
         end       
         --没有早到
         ckbTrace:SetChecked(false);
    end
end --end select func()



--电击取消标记按钮
function layWorld_frmTaskListEx_btCancelMapPoint_OnLClick(self)
    uiTaskClearLocatePoint();
end

--点击放弃任务
function layWorld_frmTaskListEx_btnCancelTask_OnLClick(self)
    tlTask = uiGetglobal("layWorld.frmTaskListEx.tlTask");
    local sel=tlTask:getSelectItem();
    local id=tlTask:Get("CurSelect");
    if id and id ~= -1 and id ~=-2 and id ~=-3 then
        local msgBox = uiMessageBox(uiLanString("msg_task_warn_abort"),"",true,true,false);
        SAPI.AddDefaultMessageBoxCallBack(msgBox, layWorld_frmTaskListEx_btCancelMapPoint_Yes,frmTaskListEx_btCancelMapPoint_No,id);    
    end
end

function layWorld_frmTaskListEx_btCancelMapPoint_Yes(_,param)
    if param ~= nil then
    uiTaskCancelTask(param);
    end
end

function frmTaskListEx_btCancelMapPoint_No(_,param)
end

function layWorld_lbTrackTaskEx_Show()
    ebTask = uiGetglobal("layWorld.lbTrackTaskEx.ebTask");
    local TaskContent=uiTaskGetTraceTaskContent();
    if TaskContent~=nil then
        ebTask:Show();
        ebTask:SetRichText(TaskContent,false);
    else 
        --
        --ebTask:Hide();
        --ebTask:SetText("");
		ebTask:SetRichText(0,false);
    end
end

--追踪任务
function layWorld_frmTaskListEx_ckbTrace_OnLClick(self)
    tlTask = uiGetglobal("layWorld.frmTaskListEx.tlTask");
 
    local sel=tlTask:getSelectItem();
    local id=tlTask:Get("CurSelect");
    --"成都城" id 为nil
    if id and id ~= -1 and id ~=-2 and id ~=-3 then
         local bfind=false;
         local traceList={};
         traceList=uiTaskGetTraceTaskList();

         for k,v in pairs(traceList) do
             if tostring(v)==tostring(id) then
                 --已经被追踪
                 self:SetChecked(false);
                 uiTaskRemoveTraceTask(tonumber(id));
                 bfind=true;
                 layWorld_lbTrackTaskEx_Show();

                 return 0;
             end
         end

         if bfind == false then 
         --没有早到             
             local bRes = uiTaskAddTraceTask(tonumber(id));
             self:SetChecked(bRes);
             layWorld_lbTrackTaskEx_Show();
         end
    end

end

function layWorld_lbTrackTaskEx_ebTask_OnUpdate(self,delta)
    layWorld_lbTrackTaskEx_Show();
end

function layWorld_frmTaskListEx_ebTaskText_OnUpdate(self,delta)
	layWorld_frmTaskListEx_Show(uiGetglobal("layWorld.frmTaskListEx"));
	local scroll = self:getScrollBarV();
	local value = scroll:getValue();
	layWorld_frmTaskListEx_ShowRightEditSingle();
	scroll:SetValue(value);
end
-------------------------------

local ItemSelect = nil;


function layWorld_frmTaskEx_OnHide(self)
	ItemSelect = nil;
end

--NPC 任务详细对话框
--不接受任务
function layWorld_frmTaskEx_btClose_OnLClick(self)
    local frmTaskEx = SAPI.GetParent(self);
    frmTaskEx:Hide();
end

--接受任务
function layWorld_frmTaskEx_btAction_OnLClick(self)
    local frmTaskEx = SAPI.GetParent(self);
    local taskid=frmTaskEx:Get("TaskID");
    local DailogID=frmTaskEx:Get("DailogID");

    if  DailogID and DailogID=="EV_TASK_DLG_TRYACCEPT" then
       uiTaskAcceptTask(taskid);
    end

    if  DailogID and DailogID=="EV_TASK_DLG_TRYFINISH" then
       local info=uiTaskGetTaskInfo(taskid);
       local edtTest= SAPI.GetChild(frmTaskEx, "edtTest");
       if info ~=nil then
           local bNeedSelectReward=info.NeedSelectReward;
           if bNeedSelectReward == true then
               local ItemSelect = uiTaskGetSelectedRewardItem(edtTest);
               if ItemSelect == nil then
                   uiMessageBox(uiLanString("msg_task_warn_select"),"",true,false,true);
                   return;
               end
           end
           local ret=uiTaskFinishTask(taskid);
           if ret==false then 
               return;
           end
       end -- info ~=nil
    end
    frmTaskEx:Hide();
end

function layWorld_frmTaskEx_OnLoad(self)
    self:RegisterScriptEventNotify("event_show_task_dialog");
end

function layWorld_frmTaskEx_edtTest_OnLClick(self,x,y)
   local Item=self:PickItem(x,y);
   if Item ~= nil then   
       local ItemIndex=uiTaskGetRewardItemIndex(self,Item);
       uiTaskSelectRewardItem(ItemIndex);
       ItemSelect = uiTaskGetSelectedRewardItem(self);
       if ItemSelect ~= nil then
			local parentX = 0;
			local parentY = 0;
			--[[
			local parent = SAPI.GetParent(self);
			parentX, parentY = uiGetWidgetRect(parent);
			local lbchoose= SAPI.GetChild(parent, "lbchoose");
			lbchoose:Show();
			local tabRect=ItemSelect:GetRect();
			lbchoose:MoveSize(tabRect.Left - parentX,tabRect.Top - parentY, tabRect.Width,tabRect.Height);
			]]
			parentX, parentY = uiGetWidgetRect(self);
			local lbchoose= SAPI.GetChild(self, "lbchoose");
			lbchoose:Show();
			local tabRect=ItemSelect:GetRect();
			lbchoose:MoveSize(tabRect.Left - parentX,tabRect.Top - parentY, tabRect.Width,tabRect.Height);
       end
    end
end

function layWorld_frmTaskEx_edtTest_OnScrollV(self)
   if ItemSelect ~= nil then
		local parentX = 0;
		local parentY = 0;
		--[[
		local parent = SAPI.GetParent(self);
		parentX, parentY = uiGetWidgetRect(parent);
		local lbchoose= SAPI.GetChild(parent, "lbchoose");
		lbchoose:Show();
		local tabRect=ItemSelect:GetRect();
		lbchoose:MoveSize(tabRect.Left - parentX,tabRect.Top - parentY, tabRect.Width,tabRect.Height);
		]]
		parentX, parentY = uiGetWidgetRect(self);
		local lbchoose= SAPI.GetChild(self, "lbchoose");
		lbchoose:Show();
		local tabRect=ItemSelect:GetRect();
		lbchoose:MoveSize(tabRect.Left - parentX,tabRect.Top - parentY, tabRect.Width,tabRect.Height);
   end
end

function layWorld_frmTaskEx_edtTest_OnMouseMove(self, x, y)
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

function layWorld_frmTaskEx_OnEvent(self,event,arg) 
--arg[2] 为任务ID
    if event == "event_show_task_dialog" then
		-- 检查与NPC之间的距离
		local bInside = uiTaskCheckDistance();
		if bInside == false then
			self:Hide();
			return;
		end
		
        local DailogStyle = arg[1];
        local NpcWord = arg[3];
        --Get Current Interactive NPC's Information
        local NpcObjectId, NpcName, NpcImg = uiTaskGetTaskDialogNpcInfo();

        local lbDailogerNpcName;
        local btDailogerImg;
        local edtDailogerTest;
        local btAction,btClose,btClose1,lbchoose;

        lbDailogerNpcName = SAPI.GetChild(self,"lbNpcName");
        btDailogerImg = SAPI.GetChild(self,"btTaskImg");
        edtDailogerTest = SAPI.GetChild(self,"edtTest");
        btAction = SAPI.GetChild(self,"btAction");
        btClose = SAPI.GetChild(self,"btClose");
        btClose1 = SAPI.GetChild(self,"btClose1");
		lbchoose = SAPI.GetChild(edtDailogerTest,"lbchoose");

        lbchoose:Hide();
        --arg[1] Dialog style
        if DailogStyle == EV_TASK_DLG_ACCEPT then
            btAction:Hide();
            btClose1:Show();
            btClose:Hide();
            btClose1:SetText(uiLanString("msg_task_dlg_bt_close"));
            self:Set("DailogID","EV_TASK_DLG_ACCEPT");
        elseif DailogStyle == EV_TASK_DLG_TRYACCEPT then
            btAction:Show();
            btClose:Show();
            btClose1:Hide();

            btAction:SetText(uiLanString("msg_task_dlg_bt_accept"));
            btClose:SetText(uiLanString("msg_task_dlg_bt_close"));

            self:Set("DailogID","EV_TASK_DLG_TRYACCEPT");
        elseif DailogStyle == EV_TASK_DLG_TRYFINISH then 
            btAction:Show();
            btClose:Show();
            btClose1:Hide();

            btAction:SetText(uiLanString("msg_task_dlg_bt_finish"));
            btClose:SetText(uiLanString("msg_task_dlg_bt_close"));

            self:Set("DailogID","EV_TASK_DLG_TRYFINISH");
		else
			uiError("UnknownType DailogStyle["..tostring(DailogStyle).."] for TaskDialog");
			self:Hide();
			return;
        end
        
        self:ShowAndFocus();
        if NpcName ~= nil then
            lbDailogerNpcName:SetText(NpcName);
		else
			lbDailogerNpcName:SetText("")
        end
        if NpcImg ~= nil then
            btDailogerImg:SetBackgroundImage(SAPI.GetImage(NpcImg));
		else
			btDailogerImg:SetBackgroundImage(SAPI.GetImage("ic_default_face"));
        end
        if NpcWord ~= nil then                     
            edtDailogerTest:SetRichText(NpcWord,false);
        end
        self:Set("TaskID",arg[2]);
    end
end

function layWorld_frmTaskEx_OnUpdate(self, delta)
	-- 每秒检查一次与NPC之间的距离
	local bInside = uiTaskCheckDistance();
	if bInside == false then
		self:Hide();
	end
end



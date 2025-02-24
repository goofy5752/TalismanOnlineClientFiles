MailExItems={}
--local ifmAcceptMailCount=0 --总mail Count
--local ifmAcceptMailPage=1  --当前page
local MailExItemsDefaultAutoDel = false
local MailExCurrentItem = {}

function layWorld_frmMailEx_OnHide(self)
--隐藏layWorld_frmMailTexts
    layWorld_MailTextsEx_Hide();
    layWorld_frmMailEx_frmSendMail_btnItem_Hide(false);
end

function layWorld_frmMailEx_OnUpdate(self)
	if uiMailDialogCheckDistance() ~= true then
		layWorld_MailTextsEx_Hide();
		layWorld_frmMailEx_frmSendMail_btnItem_Hide(false);
		self:Hide();
	end
end

function layWorld_frmMailEx_OnLoad( self )
	local btnAutoDel = uiGetglobal("layWorld.frmMailEx.btnAutoDelete")
	if btnAutoDel then
		btnAutoDel:SetChecked( MailExItemsDefaultAutoDel )
	end
end

function layWorld_frmMailEx_OnShow(self)
	uiRegisterEscWidget(self);
	local frmSendMail = SAPI.GetChild(self, "frmSendMail");
	local MoneyUnit = 
	{
		"lbGoldIcon",
		"lbAgIcon",
		"lbCuIcon",
		"edtMailGold",
		"edtMailAg",
		"edtMailCu",
		["Init"] = {
			["edtMailGold"] = 0,
			["edtMailAg"] = 0,
			["edtMailCu"] = 0,
		},
	};
	
	local CanMailMoney = false;
	local Authority = uiGetMyInfo("Authority");
	if uiGetConfigureEntry("mail", "CanMailMoney") == "true" then
		CanMailMoney = true;
	else
		local CanMailMoneyGMLevel = tonumber(uiGetConfigureEntry("mail", "CanMailMoneyGMLevel"));
		if CanMailMoneyGMLevel == nil then
			CanMailMoneyGMLevel = 0;
		end
		CanMailMoney = (Authority >= CanMailMoneyGMLevel);
	end
	
	for i, v in ipairs(MoneyUnit) do
		local unit = SAPI.GetChild(frmSendMail, v);
		if CanMailMoney then
			unit:Show();
		else
			unit:Hide();
		end
		local init_value = MoneyUnit.Init[v];
		if init_value then
			unit:SetText(tostring(init_value));
		end
	end
end

function layWorld_frmMailEx_fmAcceptMail_OnLoad(self)
   self:Set("ifmAcceptMailCount",0);
   self:Set("ifmAcceptMailPage",1);
   self:RegisterScriptEventNotify("EVENT_ViewMail");
   self:RegisterScriptEventNotify("EVENT_UpdateMail");
   self:RegisterScriptEventNotify("EVENT_SendMailResult");
end

function layWorld_frmmailEx_fmAcceptMail_OnEvent(self,event,argList)
    local frmMailEx = uiGetglobal("layWorld.frmMailEx");
    local fmAcceptMail = SAPI.GetChild(frmMailEx,"fmAcceptMail");
    local frmSendMail = SAPI.GetChild(frmMailEx,"frmSendMail");

    if event == "EVENT_ViewMail" then     
        local MailEx = uiGetglobal("layWorld.frmMailEx");
        frmSendMail:Hide();   
        fmAcceptMail:Hide();
        MailEx:ShowAndFocus();            
        self:Show();
    elseif event == "EVENT_UpdateMail" then
        layWorld_frmMailEx_GetAllMail(self);
        layWorld_frmMailEx_fmAcceptMail_OnShowMail(self);
        local MailTestEx = uiGetglobal("layWorld.frmMailTextsEx"); 
        if MailTestEx:getVisible()==true then
        layWorld_MailTextsEx_OnShow(MailTestEx);
        end
    elseif event == "EVENT_SendMailResult" then
        if argList[1] == 1 then 
        --Send Mail OK
           layWorld_frmMailEx_frmSendMail_OK();
        else
        --
        end
    
    end
end


function layWorld_frmMailEx_GetAllMail(self)
    local m_ifmAcceptMailCount;
    m_ifmAcceptMailCount,MailExItems=uiMailGetList();
    if MailExItems ~= nil then
       self:Set("ifmAcceptMailCount",m_ifmAcceptMailCount);   
       return 1;
    else
       self:Set("ifmAcceptMailCount",0);
       uiError("uiMailGetList() error!");
       return 0;
    end
end

function layWorld_frmMailEx_fmAcceptMail_OnShow(self)
    local frmMailEx = uiGetglobal("layWorld.frmMailEx")
	local btnRecv = SAPI.GetChild(frmMailEx,"btnRecv")
    local btnSend = SAPI.GetChild(frmMailEx,"btnSend")
    btnRecv:SetChecked(true)
    btnSend:SetChecked(false)
    layWorld_frmMailEx_GetAllMail(self);
    layWorld_frmMailEx_fmAcceptMail_OnShowMail(self);
end
--点向左翻页
function layWorld_frmMailEx_fmAcceptMail_btMailLeft_OnLClick()
    local m_ifmAcceptMailPage,m_ifmAcceptMailCount,m_maxpage,fmAcceptMail;
    fmAcceptMail =  uiGetglobal("layWorld.frmMailEx.fmAcceptMail");
    m_ifmAcceptMailPage = fmAcceptMail:Get("ifmAcceptMailPage");

    if m_ifmAcceptMailPage>1 then
        m_ifmAcceptMailPage=m_ifmAcceptMailPage-1;
        fmAcceptMail:Set("ifmAcceptMailPage",m_ifmAcceptMailPage);
        layWorld_frmMailEx_fmAcceptMail_OnShow(fmAcceptMail);
        layWorld_MailTextsEx_Hide();
    end
end

--点向右翻页
function layWorld_frmMailEx_fmAcceptMail_btMailRight_OnLClick()
    local m_ifmAcceptMailPage,m_ifmAcceptMailCount,m_maxpage,fmAcceptMail;
    fmAcceptMail =  uiGetglobal("layWorld.frmMailEx.fmAcceptMail");
    m_ifmAcceptMailPage = fmAcceptMail:Get("ifmAcceptMailPage");
    m_ifmAcceptMailCount =fmAcceptMail:Get("ifmAcceptMailCount");

    if math.mod(m_ifmAcceptMailCount,6) >0 or m_ifmAcceptMailCount==0 then
    m_maxpage = math.floor(m_ifmAcceptMailCount/6)+1;
    else
    m_maxpage = math.floor(m_ifmAcceptMailCount/6);
    end
    

    if m_ifmAcceptMailPage<m_maxpage then
        m_ifmAcceptMailPage=m_ifmAcceptMailPage+1;
        fmAcceptMail:Set("ifmAcceptMailPage",m_ifmAcceptMailPage);
        layWorld_frmMailEx_fmAcceptMail_OnShow(fmAcceptMail);
        layWorld_MailTextsEx_Hide();
    end
end

function layWorld_frmSendMail_ebdMailText_OnLoad(self)
	self:RegisterScriptEventNotify("EVENT_SelfEnterWorld");
end

function layWorld_frmSendMail_ebdMailText_OnEvent(self, event, args)
	if event == "EVENT_SelfEnterWorld" then
		if uiMailCanWriteContent() == true then
			self:SetEnableInput(true)
		elseif uiGetConfigureEntry("mail", "CanWriteContent") == "false" then
			self:SetEnableInput(false)
		else
			self:SetEnableInput(true)
		end
	end
end

local function layWorld_frmMailEx_isDelEnclosure( )
	uiInfo("layWorld_frmMailEx_isDelEnclosure Begin......")
	if nil == MailExCurrentItem then
		uiInfo("layWorld_frmMailEx_isDelEnclosure End1......")
		return 0
	end
	
	local m_idx = 0
	local bFind = false
	for idx=1,table.getn(MailExItems) do
		local mailItem = MailExItems[idx]
		if MailExCurrentItem["SenderName"] == mailItem["SenderName"] and MailExCurrentItem["Title"] == mailItem["Title"] and MailExCurrentItem["Content"] == mailItem["Content"] and MailExCurrentItem["StartTime"] == mailItem["StartTime"] then
			bFind = true
			m_idx = idx
			break
		end
	end
	uiInfo( "layWorld_frmMailEx_isDelEnclosure idx "..tostring(m_idx) )
	if bFind then
		local m_bLockHasItem = ( ( nil~=MailExCurrentItem["Item"] and MailExItems[m_idx]["Item"]["ObjectId"]~=nil ) or nil~=MailExCurrentItem["Money"] )
		local m_bNowNoMoney = ( MailExItems[m_idx]["Money"] == nil or MailExItems[m_idx]["Money"]["Icon"]==nil )
		local m_bNowNoItem = ( MailExItems[m_idx]["Item"]==nil or MailExItems[m_idx]["Item"]["ObjectId"]==nil )
		uiInfo( "LockItem has item "..tostring(m_bLockHasItem) )
		uiInfo( "NowItem has Money "..tostring(m_bNowNoMoney) )
		uiInfo( "NowItem has item "..tostring(m_bNowNoItem) )
		if m_bLockHasItem and m_bNowNoMoney and  m_bNowNoItem then
			uiInfo("layWorld_frmMailEx_isDelEnclosure End2......")
			return m_idx
		end
	end
	uiInfo("layWorld_frmMailEx_isDelEnclosure End3......")
	return 0
end

function layWorld_frmMailEx_process_autoDelMailItem()
	uiInfo("layWorld_frmMailEx_process_autoDelMailItem Begin......")
	local bAutoDel = uiGetglobal("layWorld.frmMailEx.btnAutoDelete"):getChecked()
	if bAutoDel then
		uiInfo("Btn AutoDel checked......")
		local m_iIdx = layWorld_frmMailEx_isDelEnclosure()
		if m_iIdx>0 then
			uiInfo("Judge to del mail......")
			uiMailDeleteMail( m_iIdx-1 );
		end
	end
	uiInfo("layWorld_frmMailEx_process_autoDelMailItem End......")	
end

function layWorld_frmMailEx_fmAcceptMail_btMailName_OnLClick(self)
  local name = "layWorld.frmMailEx.fmAcceptMail.lbMailTeam";
  local m_iMailCurrent;
  local m_ifmAcceptMailPage,fmAcceptMail;
    fmAcceptMail =  uiGetglobal("layWorld.frmMailEx.fmAcceptMail");
    m_ifmAcceptMailPage = fmAcceptMail:Get("ifmAcceptMailPage");   
     for i = 1, 6, 1 do
        local button = uiGetglobal(name..i..".btMailName"..i);
        if tostring(button) == tostring(self) then  
            m_iMailCurrent=(m_ifmAcceptMailPage-1)*6+i;--Calc current pos          
            --对于未读mail标记
            if  MailExItems[m_iMailCurrent].IsReaded==false then
                uiMailSetReaded(m_iMailCurrent-1); --安全性问题，如果这些代码被屏蔽~也就是剩余时间不会缩短。。。               
             
            end
            local MailTestEx = uiGetglobal("layWorld.frmMailTextsEx");    
            MailTestEx:Set("ifmAcceptMailCurrent",m_iMailCurrent);
            MailTestEx:Hide();
            MailTestEx:ShowAndFocus();
            button:SetChecked(true);
			layWorld_frmMailEx_process_autoDelMailItem()
			MailExCurrentItem = MailExItems[m_iMailCurrent]
            --uiMessage(tostring(m_iMailCurrent));
        else
            button:SetChecked(false);
             
        end
    end
end

function layWorld_frmMailEx_fmAcceptMail_UnCheckAllButton()
    local name = "layWorld.frmMailEx.fmAcceptMail.lbMailTeam"; 
     for i = 1, 6, 1 do
        local button = uiGetglobal(name..i..".btMailName"..i);
        button:SetChecked(false);
     end    
end


--接收邮件画面6个的CheckBox的 OnHint
function layWorld_frmMailEx_fmAcceptMail_btMailName_OnHint(self)
 local name = "layWorld.frmMailEx.fmAcceptMail.lbMailTeam";
 local m_iMailCurrent;
 local m_ifmAcceptMailPage,fmAcceptMail;
 local m_strRichTemplate="<UiRichText><Line><Items><Item type=\"TEXT\" text=\"%s\"color=\"#ff75a600\" font=\"title\" fontsize=\"17\"/></Items></Line></UiRichText>";
    fmAcceptMail =  uiGetglobal("layWorld.frmMailEx.fmAcceptMail");
    m_ifmAcceptMailPage = fmAcceptMail:Get("ifmAcceptMailPage");   

    for i = 1, 6, 1 do
        local button = uiGetglobal(name..i..".btMailName"..i);        

        if tostring(button) == tostring(self) then
            --选择到了当前Button
            --uiMessage(tostring(button).."vs".. tostring(self));  
            
            m_iMailCurrent=(m_ifmAcceptMailPage-1)*6+i;
            if  MailExItems[m_iMailCurrent]["Item"]~=nil and MailExItems[m_iMailCurrent]["Item"]["ObjectId"]~=nil then 
                button:SetHintRichText(uiMailGreateHint(MailExItems[m_iMailCurrent]["Item"]["ObjectId"]));    
            else            
                m_strRichTemplate=string.format(m_strRichTemplate,MailExItems[m_iMailCurrent].Title);                
                button:SetHintRichText(uiCreateRichText("String",m_strRichTemplate)); 
                --button:SetHintText(MailExItems[m_iMailCurrent].Title);
            end
            
        else
            --未选择到当前的Button   
            -- uiMessage(tostring(button)..tostring(self));
             
        end
    end
end


function layWorld_frmMailEx_fmAcceptMail_OnShowMail(self) 
    local m_ifmAcceptMailPage;
    local m_ifmAcceptMailCount;
    local m_maxpage; --最大页数 >=1
    local m_maxitem; --当前页最大数目
    
    local lbMailTeam; --root 
    local lbMailInfo; --Mail标题
    local lbMailPlayer;--发Mail人
    local lbMailTime;--时间
    local btMailName;--附件
    local idx;

    local r,g,b;

    local m_index,m_day;   
   
    
    m_ifmAcceptMailPage =  self:Get("ifmAcceptMailPage");   
    m_ifmAcceptMailCount = self:Get("ifmAcceptMailCount");
    
    if math.mod(m_ifmAcceptMailCount,6) >0 or m_ifmAcceptMailCount==0 then
    m_maxpage = math.floor(m_ifmAcceptMailCount/6)+1;
    else
    m_maxpage = math.floor(m_ifmAcceptMailCount/6);
    end
    
    --uiMessage("m_maxpage"..m_maxpage.."m_ifmAcceptMailPage"..tostring(m_ifmAcceptMailPage).."m_ifmAcceptMailCount"..tostring(m_ifmAcceptMailCount));
   

    if m_ifmAcceptMailPage<m_maxpage and m_ifmAcceptMailPage>=1 then 
    m_maxitem = 6;
    elseif m_ifmAcceptMailPage==m_maxpage then    
    m_maxitem = math.mod(m_ifmAcceptMailCount,6);     
        if m_maxitem ==0 then
        m_maxitem=6;
        end   
    else 
    m_maxitem = 0;     
    end
  
    

    for idx =1 , 6 do
        lbMailTeam = uiGetglobal("layWorld.frmMailEx.fmAcceptMail.lbMailTeam"..idx);
        lbMailInfo = SAPI.GetChild(lbMailTeam,"lbMailInfo"..idx);
        lbMailPlayer = SAPI.GetChild(lbMailTeam,"lbMailPlayer"..idx);
        lbMailTime = SAPI.GetChild(lbMailTeam,"lbMailTime"..idx);
        btMailName = SAPI.GetChild(lbMailTeam,"btMailName"..idx);
        
        if idx<=m_maxitem and m_ifmAcceptMailCount >0 and m_ifmAcceptMailPage<=m_maxpage and m_ifmAcceptMailPage>=0 then
            m_index=(m_ifmAcceptMailPage-1)*6+idx;
            --m_day = math.floor((MailExItems[m_index].LimitTime-MailExItems[m_index].StartTime)/(3600*24))-1;
            m_day = math.floor((MailExItems[m_index].LimitTime-uiGetServerTime())/(3600*24));
            --uiInfo("ServerTm:"..tostring(uiGetServerTime()));
            --uiInfo("MailExItems[m_index].LimitTime:"..tostring(MailExItems[m_index].LimitTime));
            --uiInfo("MailExItems[m_index].StartTime:"..tostring(MailExItems[m_index].StartTime));
            

            --Mail's Title
            if MailExItems[m_index]["IsReaded"]==true then
                r=153;g=170;b=187; 
            else
                r=255;g=255;b=255;
            end

            lbMailInfo:SetTextColorEx(b,g,r,255);
            lbMailInfo:SetText(MailExItems[m_index].Title);
            --mail Sender's name
            lbMailPlayer:SetTextColorEx(b,g,r,255);
            if MailExItems[m_index].SenderName~="" then
            lbMailPlayer:SetText(MailExItems[m_index].SenderName);
            else
            lbMailPlayer:SetText(uiLanString("gm_name"));
            end
            --Remain Days
            lbMailTime:SetTextColorEx(b,g,r,255);
            local rdaysremail=string.format(uiLanString("msg_auc_remain_days"),m_day);
            lbMailTime:SetText(tostring(rdaysremail));
            --ICON
            btMailName:SetUltraTextNormal("");
            if MailExItems[m_index]["Item"]~=nil and MailExItems[m_index]["Item"]["Icon"]~=nil then                 
                btMailName:SetBackgroundImage(SAPI.GetImage(MailExItems[m_index]["Item"]["Icon"]));
                if MailExItems[m_index]["Item"]["Count"]~=nil then 
                    btMailName:SetUltraTextNormal(tostring(MailExItems[m_index]["Item"]["Count"]));
                end
            elseif MailExItems[m_index]["Money"]~=nil and MailExItems[m_index]["Money"]["Icon"]~=nil then 
                btMailName:SetBackgroundImage(SAPI.GetImage(MailExItems[m_index]["Money"]["Icon"]));
            else
                btMailName:SetBackgroundImage(SAPI.GetImage(MailExItems[m_index].Icon));
            end

            lbMailInfo:Show();
            lbMailPlayer:Show();
            lbMailTime:Show();
            btMailName:Show();           
        elseif idx>m_maxitem then 
            lbMailInfo:Hide();
            lbMailPlayer:Hide();
            lbMailTime:Hide();
            btMailName:Hide();            
        elseif m_ifmAcceptMailCount ==0 then
            lbMailInfo:Hide();
            lbMailPlayer:Hide();
            lbMailTime:Hide();
            btMailName:Hide();   
            
        end
    end    
end

--选择收Email还是发Email
function layWorld_frmMailEx_CheckButton_OnLClick(index)
    local frmMailEx = uiGetglobal("layWorld.frmMailEx")
	local btnRecv = SAPI.GetChild(frmMailEx,"btnRecv")
    local btnSend = SAPI.GetChild(frmMailEx,"btnSend")
    local fmAcceptMail = SAPI.GetChild(frmMailEx,"fmAcceptMail")
    local frmSendMail = SAPI.GetChild(frmMailEx,"frmSendMail")
	local btnAutoDelete = SAPI.GetChild(frmMailEx,"btnAutoDelete")
    if index == 0 then
        btnRecv:SetChecked(true)
        btnSend:SetChecked(false)
		btnAutoDelete:Show()
        fmAcceptMail:Show()   
        frmSendMail:Hide()		
    elseif index == 1 then
		btnSend:SetChecked(true);
        btnRecv:SetChecked(false);
		btnAutoDelete:Hide();
        fmAcceptMail:Hide();   
        frmSendMail:Show();
        layWorld_MailTextsEx_Hide();
	end

end

function layWorld_frmMailEx_frmSendMail_btnItem_OnDragIn(self, drag)
	local allow_owners = 
	{
		EV_UI_SHORTCUT_OWNER_ITEM,
		IsAllowed = function(self, owner)
			if owner == nil then return false end
			for i, v in ipairs(self) do
				if v == owner then return true end
			end
			return false;
		end
	}
	local drag_out = uiGetglobal(drag);
	if drag_out == nil then return end
	local shortcut_owner = drag_out:Get(EV_UI_SHORTCUT_OWNER_KEY);
	if shortcut_owner == nil then return end
	if allow_owners:IsAllowed(shortcut_owner) == false then return end
	local shortcut_type = drag_out:Get(EV_UI_SHORTCUT_TYPE_KEY);
	if shortcut_type == nil then shortcut_type = 0 end
	local shortcut_objectid = drag_out:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
	if shortcut_objectid == nil then shortcut_objectid = 0 end
	local shortcut_classid = drag_out:Get(EV_UI_SHORTCUT_CLASSID_KEY);
	if shortcut_classid == nil then shortcut_classid = 0 end
    if uiMailCanSendItem(shortcut_objectid) ~= true then return end
	local ItemId = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
	if ItemId and ItemId > 0 then
		LClass_ItemFreezeManager:Erase(ItemId); -- 解冻
	end
	self:Set(EV_UI_SHORTCUT_TYPE_KEY, shortcut_type);
	self:Set(EV_UI_SHORTCUT_OBJECTID_KEY, shortcut_objectid);
	self:Set(EV_UI_SHORTCUT_CLASSID_KEY, shortcut_classid);
	LClass_ItemFreezeManager:Push(shortcut_objectid); -- 冻结
	layWorld_frmMailEx_frmSendMail_btnItem_Refresh(self);
	
	--修改金币图标 邮资不同
	local lbsenditem = uiGetglobal("layWorld.frmMailEx.frmSendMail.lbsenditem");
	local lbsendtongitem = uiGetglobal("layWorld.frmMailEx.frmSendMail.lbsendtongitem");
    local MailItemExtraMoney = tonumber(uiGetConfigureEntry("mail","MailItemExtraMoney"));
    if MailItemExtraMoney then
        -- 10 ying
        lbsenditem:Show();
        lbsendtongitem:Hide();

    else
        -- 10 tong
        lbsenditem:Hide();
        lbsendtongitem:Show();
    end
	--lbsenditem:Show();
	--lbsendtongitem:Hide();
end

function layWorld_frmMailEx_frmSendMail_btnItem_OnDragNull(self)
	local ItemId = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
	if ItemId and ItemId > 0 then
		LClass_ItemFreezeManager:Erase(ItemId); -- 解冻
	end
	self:Set(EV_UI_SHORTCUT_TYPE_KEY, 0);
	self:Set(EV_UI_SHORTCUT_OBJECTID_KEY, 0);
	self:Set(EV_UI_SHORTCUT_CLASSID_KEY, 0);
	layWorld_frmMailEx_frmSendMail_btnItem_Refresh(self);
	--修改金币图标 邮资不同
	local lbsenditem = uiGetglobal("layWorld.frmMailEx.frmSendMail.lbsenditem");
	local lbsendtongitem = uiGetglobal("layWorld.frmMailEx.frmSendMail.lbsendtongitem");
	lbsenditem:Hide();
	lbsendtongitem:Show();
end

function layWorld_frmMailEx_frmSendMail_btnItem_OnHint(self)
	local hint = 0;
	local shortcut_type = self:Get(EV_UI_SHORTCUT_TYPE_KEY);
	if shortcut_type == nil then
	elseif shortcut_type == EV_SHORTCUT_OBJECT_ITEM then
		local shortcut_objectid = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
		if shortcut_objectid == nil or shortcut_objectid == 0 then
		else
			hint = uiItemGetBagItemHintByObjectId(shortcut_objectid);
		end
	end
	self:SetHintRichText(hint);
end

function layWorld_frmMailEx_frmSendMail_btnItem_Refresh(self)
	local shortcut_dbid = self:Get(LOCAL_SHORTCUT_DBID_KEY);
	local shortcut_owner = self:Get(EV_UI_SHORTCUT_OWNER_KEY);
	if shortcut_owner == nil or shortcut_owner ~= EV_UI_SHORTCUT_OWNER_MAIL then return end
	local shortcut_type = self:Get(EV_UI_SHORTCUT_TYPE_KEY);
	local shortcut_objectid = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
	local shortcut_classid = self:Get(EV_UI_SHORTCUT_CLASSID_KEY);
	
	local icon = 0; -- 图标地址 -- 指针地址
	local itemCount = 0; -- 道具的当前数量
	local countText = ""; -- 道具的当前数量文本
	local bModifyFlag = false;
	
	if shortcut_type == nil or shortcut_type == EV_SHORTCUT_OBJECT_NONE then
		shortcut_type = EV_SHORTCUT_OBJECT_NONE;
	elseif not shortcut_objectid or shortcut_objectid == 0 or shortcut_classid == nil or shortcut_classid == 0 then
	elseif shortcut_type == EV_SHORTCUT_OBJECT_ITEM then
		local tableInfo = uiItemGetItemClassInfoByTableIndex(shortcut_classid); -- 道具的静态信息
		icon = SAPI.GetImage(tableInfo.Icon, 2, 2, -2, -2);
		if tableInfo.IsCountable == true then
			local objInfo = uiItemGetBagItemInfoByObjectId(shortcut_objectid); -- 道具的动态信息
			if objInfo then
				itemCount = objInfo.Count;
				if itemCount > 0 then
					countText = tostring(itemCount);
				end
			end
		end
		bModifyFlag = true;
	end
	-- 操作按钮
	self:ModifyFlag("DragOut_MouseMove", bModifyFlag);
	self:SetNormalImage(icon);
	self:SetUltraTextNormal(countText);
end


function layWorld_frmMailEx_frmSendMail_btnItem_OnLoad(self)
	self:Set(EV_UI_SHORTCUT_OWNER_KEY, EV_UI_SHORTCUT_OWNER_MAIL);
end


--电击发送
function layWorld_frmMailEx_frmSendMail_btMailSend_OnLClick(self)
    local frmSendMail = uiGetglobal("layWorld.frmMailEx.frmSendMail");
    local edbSendMailName = SAPI.GetChild(frmSendMail,"edbSendMailName"); --收件人
    local edbMailTitle = SAPI.GetChild(frmSendMail,"edbMailTitle"); --邮件标题
    local edbMailText = SAPI.GetChild(frmSendMail,"edbMailText"); --邮件内容
    local btnItem =  SAPI.GetChild(frmSendMail,"btnItem");
    local btnItemObjectid = btnItem:Get(EV_UI_SHORTCUT_OBJECTID_KEY);

    local lbsenditem = uiGetglobal("layWorld.frmMailEx.frmSendMail.lbsenditem");
	local lbsendtongitem = uiGetglobal("layWorld.frmMailEx.frmSendMail.lbsendtongitem");

	
	local edtMailGold = SAPI.GetChild(frmSendMail, "edtMailGold");
	local edtMailAg = SAPI.GetChild(frmSendMail, "edtMailAg");
	local edtMailCu = SAPI.GetChild(frmSendMail, "edtMailCu");
	local g = tonumber(edtMailGold:getText());
	local a = tonumber(edtMailAg:getText())
	local c = tonumber(edtMailCu:getText())
	if not g or g < 0 then g = 0 end
	if not a or a < 0 then a = 0 end
	if not c or c < 0 then c = 0 end
	local mail_money = g * 10000 + a * 100 + c;
	
    local stredbSendMailName,stredbMailTitle,stredbMailText;

    stredbSendMailName=edbSendMailName:getText();
    stredbMailTitle=edbMailTitle:getText();
    stredbMailText=edbMailText:getText();


    --发送邮件对话框的出错情况
   
    --没写收件人姓名
    if stredbSendMailName == "" then 
        uiClientMsg(uiLanString("msg_mail_recv_null"),false);
    return 0;
    end
     --没写邮件标题
    if stredbMailTitle =="" then 
        uiClientMsg(uiLanString("msg_mail_title_null"),false);
    return 0;
    end
    --[[没写邮件内容
    if stredbMailText == "" then
        uiClientMsg(uiLanString("msg_mail_content_null"),false);
    return 0;
    end
	]]
    --金钱不够
    local iMoney1,iMoney2=uiGetMyInfo("Money");
    uiInfo("Money:"..iMoney1.."  "..iMoney2);
   

    if lbsenditem:getVisible()==true then
       if (iMoney1+iMoney2)<1000 then
            uiClientMsg(uiLanString("msg_mail_notenough_postage"),false);
            return 0;
       end
    else
        if lbsendtongitem:getVisible()==true then
            if (iMoney1+iMoney2)<10 then
                uiClientMsg(uiLanString("msg_mail_notenough_postage"),false);
                return 0;
            end
         end
    end

           

    
    --if uiGetMyInfo("Money")<=10   and btnItemObjectid==nil or
    --   uiGetMyInfo("Money")<=1000 and btnItemObjectid~=nil then  

    --   uiClientMsg(uiLanString("msg_mail_notenough_postage"),false);
    --return 0;
    --end
	
	local haveFuJian = (btnItemObjectid and btnItemObjectid > 0) or (mail_money and mail_money > 0); -- 是否有附件
       
---------------------------------------------


    if haveFuJian then   --and btnItemObjectid~=0
       --在发送邮件附件时，。。。。需要进入Message.cvs ,目前没有
       local tagPack={};
	   --发送邮件如果有附件要提示
	   tagPack[1]=stredbMailTitle;
	   tagPack[2]=stredbSendMailName;
	   tagPack[3]=stredbMailText;
	   tagPack[4]=btnItemObjectid;
	   tagPack[5]=mail_money;
       
       local strask=string.format(uiLanString("msg_mail_ask_ack"),stredbSendMailName);
       local msgBox = uiMessageBox(strask,"",true,true,true);
       SAPI.AddDefaultMessageBoxCallBack(msgBox, layWorld_frmMailEx_frmSendMail_btMailSend_MailAttachYES,layWorld_frmMailEx_frmSendMail_btMailSend_MailAttachNO,tagPack);
    else
       uiInfo("没有附件发送");
       uiMailSendMail(stredbMailTitle,stredbSendMailName,stredbMailText,btnItemObjectid,mail_money);
    end
end

function layWorld_frmMailEx_frmSendMail_btMailSend_MailAttachYES(_,tagPack)
    uiInfo("you附件发送");
    uiMailSendMail(tagPack[1],tagPack[2],tagPack[3],tagPack[4],tagPack[5]);
end

function layWorld_frmMailEx_frmSendMail_btMailSend_MailAttachNO(_,tagPack)
end

--------------------------------------------------------------

function layWorld_frmMailEx_frmSendMail_OK()
     layWorld_frmMailEx_frmSendMail_btnItem_Hide(true);
end


--电击取消发送Mail
function layWorld_frmMailEx_frmSendMail_btMailCancel_OnLClick(self)
   local frmMailEx = uiGetglobal("layWorld.frmMailEx");
   frmMailEx:Hide();
end


function  layWorld_frmMailEx_frmSendMail_btnItem_Hide(isSendOK)
   local frmSendMail = uiGetglobal("layWorld.frmMailEx.frmSendMail");
   local edbSendMailName = SAPI.GetChild(frmSendMail,"edbSendMailName"); --收件人
   local edbMailTitle = SAPI.GetChild(frmSendMail,"edbMailTitle"); --邮件标题
   local edbMailText = SAPI.GetChild(frmSendMail,"edbMailText"); --邮件内容
   local btnItem = SAPI.GetChild(frmSendMail,"btnItem");
   
   local edtMailGold = SAPI.GetChild(frmSendMail, "edtMailGold");
   local edtMailAg = SAPI.GetChild(frmSendMail, "edtMailAg");
   local edtMailCu = SAPI.GetChild(frmSendMail, "edtMailCu");

   edbMailText:SetText("");
   edbMailTitle:SetText("");
   edbSendMailName:SetText("");
   
   edtMailGold:SetText("0");
   edtMailAg:SetText("0");
   edtMailCu:SetText("0");
   
   layWorld_frmMailEx_frmSendMail_btnItem_OnDragNull(btnItem);

   local lbsenditem= uiGetglobal("layWorld.frmMailEx.frmSendMail.lbsenditem");
   lbsenditem:Hide();
   local lbsendtongitem= uiGetglobal("layWorld.frmMailEx.frmSendMail.lbsendtongitem");
   lbsendtongitem:Show();
end











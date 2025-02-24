----------------------
--用户之间交易UI
--WJ 2009.5.4

local OtherShop={};

function layWorld_frmBPToPEx_OnLoad(self)
     self:RegisterScriptEventNotify("event_request_trade");--"d" <玩家id> //被邀请交易[邀请人ObjectID]
     self:RegisterScriptEventNotify("event_begin_trade");  --"d" <玩家id> //开始交易[交易对象ObjectID]
     self:RegisterScriptEventNotify("event_change_trade_money"); --"d" <金钱量> //交易的金钱改变[金钱数量 DWORD]
     self:RegisterScriptEventNotify("event_change_trade_point"); --"d" <点数量> //交易的钻石改变[钻石数量 DWORD]
     self:RegisterScriptEventNotify("event_add_trade_item");
     self:RegisterScriptEventNotify("event_del_trade_item");
     self:RegisterScriptEventNotify("event_lock_trade");
     self:RegisterScriptEventNotify("event_other_lock_trade"); --对方锁定交易
     self:RegisterScriptEventNotify("event_unlock_trade");
     self:RegisterScriptEventNotify("event_other_unlock_trade");
     self:RegisterScriptEventNotify("event_cancel_trade");
     self:RegisterScriptEventNotify("event_finish_trade");
     self:RegisterScriptEventNotify("event_add_self_trade_item_res");

     self:Delete("OBJID");

end

function layWorld_frmBPToPEx_OnEvent(self,event,arg)
    if event == "event_request_trade" then 
       --被邀请交易 弹出提示框       
       local tradeusrInfo=uiUserTradGetOtherInfo(arg[1]);
       if tradeusrInfo then
           local usrname=tradeusrInfo.Name;
           local msgcontent = string.format(uiLanString("msg_trade_affirm"),usrname);
           local msgBox = uiMessageBox(msgcontent,"",true,true,true);
           SAPI.AddDefaultMessageBoxCallBack(msgBox,layWorld_frmBPToPEx_Trade_YES,layWorld_frmBPToPEx_Trade_No,tradeusrInfo);
       end
    elseif event == "event_begin_trade" then
       --打开交易画面
       self:Set("OBJID",arg[1]);
		if self:getVisible() == true then
			self:Hide();
		end
       self:ShowAndFocus();
    elseif event == "event_add_trade_item" or event == "event_del_trade_item" then
        --对方添加或者删除道具
        if self:getVisible() == true then
            --显示上面的对方交易物品列表
            layWorld_frmBPToPEx_ShowNpcShop();
        end    
    elseif event == "event_other_lock_trade" then
         local lbLockState1 = SAPI.GetChild(self,"lbLockState1");
         local lbLockState2 = SAPI.GetChild(self,"lbLockState2");
         if lbLockState1:getVisible()==false then
             lbLockState1:Show();
         end
         if lbLockState1:getVisible()==true and lbLockState2:getVisible()==true then
             local btBuy = SAPI.GetChild(self,"btBuy");
             btBuy:Enable();
         end
    elseif event == "event_change_trade_money" then
        --arg[1] 为 对方输入的金币数量
        local lbPlayergoldnum = SAPI.GetChild(self,"lbPlayergoldnum");
        local lbPlayersilvernum = SAPI.GetChild(self,"lbPlayersilvernum");
        local lbPlayercoppernum = SAPI.GetChild(self,"lbPlayercoppernum");
        if arg[1] and arg[1]>=0 then
            local ilbNpcgoldnum,ilbNpcsilvernum,ilbNpccoppernum = layWorld_Helper_GoldConvert(arg[1]);        
            lbPlayergoldnum:SetText(tostring(ilbNpcgoldnum));
            lbPlayersilvernum:SetText(tostring(ilbNpcsilvernum));
            lbPlayercoppernum:SetText(tostring(ilbNpccoppernum));
        end
    elseif event == "event_finish_trade" then        
        self:Hide();
    elseif event == "event_cancel_trade" then
        uiUserTradeCancel();
        self:Hide();
	elseif event == "event_add_self_trade_item_res" then
		local ObjectId = arg[1];
		local bSuccess = arg[2];
		if bSuccess == true then
			local usrItem=uiBusinessGetUserItemInfoByObjectId(ObjectId);
			local btnTable=uiItemGetItemClassInfoByTableIndex(usrItem.TableId);
			local DCOUNT=self:Get("DCount")+1;
			local button=SAPI.GetChild(self,"btnCustom_D"..DCOUNT);
            button:SetNormalImage(SAPI.GetImage(btnTable.Icon));
            --显示数目
            if usrItem["Count"]~=nil and usrItem["Count"]>0  then
               --显示数字
                button:SetUltraTextNormal(tostring(usrItem["Count"]));
            else
                button:SetUltraTextNormal("");
            end 
            button:Set("dragObjectid",ObjectId);
            self:Set("DCount",DCOUNT);
		else
			-- 解冻指定道具
			local FreezeItemList = self.FreezeItemList;
			if FreezeItemList then
				local index = SAPI.GetIndexInTable(FreezeItemList, ObjectId);
				if index > 0 then -- 找到了
					table.remove(FreezeItemList, index);
					LClass_ItemFreezeManager:Erase(ObjectId);
					self.FreezeItemList = FreezeItemList;
				end
			end
		end
    end

end

function layWorld_frmBPToPEx_Trade_YES(_,tradeusrInfo)
    local frmBPToPEx=uiGetglobal("layWorld.frmBPToPEx");
    --CALL 接口
    frmBPToPEx:Set("OBJID",tradeusrInfo.ObjectId);
    local res=uiUserTradAgree(tradeusrInfo.ObjectId);
    if res==true then
		if frmBPToPEx:getVisible() == true then
			frmBPToPEx:Hide();
		end
    end
end

function layWorld_frmBPToPEx_Trade_No(_,tradeusrInfo)
     local frmBPToPEx=uiGetglobal("layWorld.frmBPToPEx");
     local res=uiUserTradRefuse(tradeusrInfo.ObjectId);
     if res==true then
         frmBPToPEx:Hide();
     end
end
-------------------------------------------------------------------------

--显示更新金钱信息
function layWorld_frmBPToPEx_ShowMoney(upmoney,dnmoney)    
    local frmBPToPEx;    
    frmBPToPEx=uiGetglobal("layWorld.frmBPToPEx");
   
    local lbPlayergoldnum = SAPI.GetChild(frmBPToPEx,"lbPlayergoldnum");
    local lbPlayersilvernum = SAPI.GetChild(frmBPToPEx,"lbPlayersilvernum");
    local lbPlayercoppernum = SAPI.GetChild(frmBPToPEx,"lbPlayercoppernum");
    local lbUsergoldnum = SAPI.GetChild(frmBPToPEx,"lbUsergoldnum");
    local lbUsersilvernum = SAPI.GetChild(frmBPToPEx,"lbUsersilvernum");
    local lbUsercoppernum = SAPI.GetChild(frmBPToPEx,"lbUsercoppernum");

    local ilbNpcgoldnum,ilbNpcsilvernum,ilbNpccoppernum = layWorld_Helper_GoldConvert(tonumber(upmoney));
    local igoldnum,isilvernum,icoppernum = layWorld_Helper_GoldConvert(tonumber(dnmoney)); 

    lbPlayergoldnum:SetText(tostring(ilbNpcgoldnum));
    lbPlayersilvernum:SetText(tostring(ilbNpcsilvernum));
    lbPlayercoppernum:SetText(tostring(ilbNpccoppernum));

    lbUsergoldnum:SetText(tostring(igoldnum));
    lbUsersilvernum:SetText(tostring(isilvernum));
    lbUsercoppernum:SetText(tostring(icoppernum));
end


function layWorld_frmBPToPEx_OnShow(self)
    local shopinfo=uiUserTradeGetUserTradeInfo();
    if shopinfo then
        self:Set("Left",shopinfo.ItemSlot.Other.Left);
        self:Set("Top",shopinfo.ItemSlot.Other.Top);
        self:Set("Right",shopinfo.ItemSlot.Other.Right);
        self:Set("Bottom",shopinfo.ItemSlot.Other.Bottom);
        self:Set("OffsetLeft",shopinfo.ItemSlot.Other.OffsetLeft);
        self:Set("OffsetTop",shopinfo.ItemSlot.Other.OffsetTop);
        self:Set("OffsetRight",shopinfo.ItemSlot.Other.OffsetRight);
        self:Set("OffsetBottom",shopinfo.ItemSlot.Other.OffsetBottom);
        self:Set("Width",shopinfo.ItemSlot.Other.Width);
        self:Set("Height",shopinfo.ItemSlot.Other.Height);
        self:Set("Line",shopinfo.ItemSlot.Other.Line);
        self:Set("Col",shopinfo.ItemSlot.Other.Col);
        self:Set("Page",shopinfo.ItemSlot.Other.Page);

        self:Set("DLeft",shopinfo.ItemSlot.Self.Left);
        self:Set("DTop",shopinfo.ItemSlot.Self.Top);
        self:Set("DRight",shopinfo.ItemSlot.Self.Right);
        self:Set("DBottom",shopinfo.ItemSlot.Self.Bottom);
        self:Set("DOffsetLeft",shopinfo.ItemSlot.Self.OffsetLeft);
        self:Set("DOffsetTop",shopinfo.ItemSlot.Self.OffsetTop);
        self:Set("DOffsetRight",shopinfo.ItemSlot.Self.OffsetRight);
        self:Set("DOffsetBottom",shopinfo.ItemSlot.Self.OffsetBottom);
        self:Set("DWidth",shopinfo.ItemSlot.Self.Width);
        self:Set("DHeight",shopinfo.ItemSlot.Self.Height);
        self:Set("DLine",shopinfo.ItemSlot.Self.Line);
        self:Set("DCol",shopinfo.ItemSlot.Self.Col);
        self:Set("DPage",shopinfo.ItemSlot.Self.Page);

        local location_x = tonumber(self:Get("Left"));
        local location_y = tonumber(self:Get("Top"));
        local count_x = tonumber(self:Get("Col"));--列数
        local count_y = tonumber(self:Get("Line"));--行数
        local Total = tonumber(tonumber(count_x)*tonumber(count_y));
        local Width = tonumber(self:Get("Width"));
        local Height = tonumber(self:Get("Height"));
        local offset_x = tonumber(self:Get("OffsetLeft"));
        local offset_y = tonumber(self:Get("OffsetTop"));
        local offset_xx = tonumber(self:Get("OffsetRight"));
        local offset_yy = tonumber(self:Get("OffsetBottom"));

        local dlocation_x = tonumber(self:Get("DLeft"));
        local dlocation_y = tonumber(self:Get("DTop"));
        local dcount_x = tonumber(self:Get("DCol"));--列数
        local dcount_y = tonumber(self:Get("DLine"));--行数
        local dTotal = tonumber(tonumber(count_x)*tonumber(count_y));
        local dWidth = tonumber(self:Get("DWidth"));
        local dHeight = tonumber(self:Get("DHeight"));
        local doffset_x = tonumber(self:Get("DOffsetLeft"));
        local doffset_y = tonumber(self:Get("DOffsetTop"));
        local doffset_xx = tonumber(self:Get("DOffsetRight"));
        local doffset_yy = tonumber(self:Get("DOffsetBottom")); 

        local rWidth,rHeight;
        local drWidth,drHeight;

        --初始交易 显示都是0
        layWorld_frmBPToPEx_ShowMoney(0,0);

        --交易按钮为DISABLE 状态
        local btBuy = SAPI.GetChild(self,"btBuy");
        btBuy:Disable();

        --锁定按钮为Enable状态
        local btCheck = SAPI.GetChild(self,"btCheck");
        btCheck:Enable();

        --隐藏上下绿色小板板
        local lbLockState1 = SAPI.GetChild(self,"lbLockState1");
        local lbLockState2 = SAPI.GetChild(self,"lbLockState2");
        lbLockState1:Hide();
        lbLockState2:Hide();

        --允许改变金钱数量
      
        local lbUsergoldnum = SAPI.GetChild(self,"lbUsergoldnum");
        local lbUsersilvernum = SAPI.GetChild(self,"lbUsersilvernum");
        local lbUsercoppernum = SAPI.GetChild(self,"lbUsercoppernum");  
        lbUsergoldnum:Enable();
        lbUsersilvernum:Enable();
        lbUsercoppernum:Enable();


        --显示玩家姓名
        -- tradeusrInfo.Name
        local objid=self:Get("OBJID");
        if not objid then
            return ;
        end
        local tradeusrInfo=uiUserTradGetOtherInfo(objid);
        local usrInfo,_,_=uiGetMyInfo("Role");
        local _usrInfo=string.format(uiLanString("msg_trade_self_label"),usrInfo);
        local _tradeusrInfoNA=string.format(uiLanString("msg_trade_other_label"),tradeusrInfo.Name);

        local lbPlayername = SAPI.GetChild(self,"lbPlayername");
        local lbUsername = SAPI.GetChild(self,"lbUsername");
       
        lbUsername:SetText(_usrInfo);
        lbPlayername:SetText(_tradeusrInfoNA); 
        
        self:Set("DCount",0);
        if dTotal<30 then
            for idx=1,dTotal,1 do
                local dbutton = SAPI.GetChild(self,"btnCustom_D"..idx);
                local dx=math.mod((idx-1),dcount_x);
                local dy=math.floor((idx-1)/dcount_x);

                dbutton:MoveTo(dlocation_x+dx*dWidth+doffset_x,dlocation_y+dy*dHeight+doffset_y); 
                dbutton:SetNormalImage("");
                dbutton:SetUltraTextNormal("");

                dbutton:Set("COUNT",-1);
                dbutton:Delete("dragObjectid");

                drWidth=doffset_xx-doffset_x+1;
                drHeight=doffset_yy-doffset_y+1;
                dbutton:SetSize(drWidth,drHeight);

                dbutton:Show();
            end
        end

        if Total<30 then
            for idx=1,Total,1 do
                local button = SAPI.GetChild(self,"btnCustom"..idx);
                local dx=math.mod((idx-1),count_x);
                local dy=math.floor((idx-1)/count_x);

                button:MoveTo(location_x+dx*Width+offset_x,location_y+dy*Height+offset_y); 
                button:SetNormalImage("");
                button:SetUltraTextNormal("");

                button:Set("COUNT",-1);
                button:Delete("dragObjectid");

                rWidth=offset_xx-offset_x+1;
                rHeight=offset_yy-offset_y+1;
                button:SetSize(rWidth,rHeight);

                button:Show();
            end
        end

    end --shopinfo not nil
end

function layWorld_frmBPToPEx_btnCustom_D_OnDragIn(self,drag,index)
    local frmBPToPEx = uiGetglobal("layWorld.frmBPToPEx");
    --local NpcId=frmSaleShopEx:Get("NpcId"); 
--[[	-- 等返回
    local DCOUNT=frmBPToPEx:Get("DCount")+1;
    local button=SAPI.GetSibling(self,"btnCustom_D"..DCOUNT);
]]
    local pdrag = uiGetglobal(drag);
    local dragObjectid = 0;--uiMailGetItemObjectIdByWidget(pdrag);

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
	
	dragObjectid = shortcut_objectid;
	
    --是否已经锁定
    
    local lbLockState2 = SAPI.GetChild(frmBPToPEx,"lbLockState2");
    if lbLockState2:getVisible()==true then
        return 0;
    end


    if dragObjectid ~= nil then 
         local usrItem=uiBusinessGetUserItemInfoByObjectId(dragObjectid);
         local btnTable=uiItemGetItemClassInfoByTableIndex(usrItem.TableId); 

         if  uiUserTradeAddItem(dragObjectid) == true then
		 --[[ -- 等返回
             button:SetNormalImage(SAPI.GetImage(btnTable.Icon));
			 ]]
             --uiItemFreezeItem(dragObjectid,true);
			 -- 冻结
			 local FreezeItemList = frmBPToPEx.FreezeItemList;
			 if FreezeItemList == nil then FreezeItemList = {} end
			 table.insert(FreezeItemList, dragObjectid);
			 LClass_ItemFreezeManager:Push(dragObjectid);
			 frmBPToPEx.FreezeItemList = FreezeItemList;
			 --[[ -- 等返回
             --显示数目
             local tUsrItem=uiBusinessGetUserItemInfoByObjectId(dragObjectid);
             if tUsrItem["Count"]~=nil and tUsrItem["Count"]>0  then
                --显示数字
                 button:SetUltraTextNormal(tostring(tUsrItem["Count"]));
             else
                 button:SetUltraTextNormal("");
             end 
             --local PRICE =tUsrItem.SalePrice;
             --local SpendMoney,UsrMoney=layWorld_frmNpcShopEx_ModifyMoney(PRICE,true,1);
             --layWorld_frmNpcShopEx_ShowMoney(SpendMoney,UsrMoney,1);
             button:Set("dragObjectid",dragObjectid);
             frmBPToPEx:Set("DCount",DCOUNT);
			 ]]
         end


     end

end

-- 点击取消 不交易了
function layWorld_frmBPToPEx_btnCustom_D_OnLClick(self,mouse_x,mouse_y,index)
    local frmBPToPEx = uiGetglobal("layWorld.frmBPToPEx");
    --local NpcId = frmSaleShopEx:Get("NpcId");
    --local NpcObjectId = frmSaleShopEx:Get("NpcObjectId"); 
    local DCount = frmBPToPEx:Get("DCount");  --下面目前总数

    --是否已经锁定
    
    local lbLockState2 = SAPI.GetChild(frmBPToPEx,"lbLockState2");
    if lbLockState2:getVisible()==true then
        return 0;
    end


  
    if DCount and index<=DCount then 
        local button=SAPI.GetSibling(self,"btnCustom_D"..index);
        local dragObjectid = button:Get("dragObjectid");

        if dragObjectid then
                local RemoveRes=uiUserTradeRemoveItem(dragObjectid);
                if RemoveRes==true then
                --移走成功      
					-- 解冻指定道具
					local FreezeItemList = frmBPToPEx.FreezeItemList;
					if FreezeItemList then
						local index = SAPI.GetIndexInTable(FreezeItemList, dragObjectid);
						if index > 0 then -- 找到了
							table.remove(FreezeItemList, index);
							LClass_ItemFreezeManager:Erase(dragObjectid);
							frmBPToPEx.FreezeItemList = FreezeItemList;
						end
					end
					
					button:Delete("dragObjectid");
					uiInfo("button:Delete = "..button:getName());
					
                    frmBPToPEx:Set("DCount",DCount-1);
                    --往前平移
                    for idx = index ,DCount,1 do
                        local btnCustom_D = uiGetglobal("layWorld.frmBPToPEx.btnCustom_D"..idx);
                        local btnCustom_D_next = uiGetglobal("layWorld.frmBPToPEx.btnCustom_D"..idx+1);

                        local nextImage=btnCustom_D_next:getNormalImage();
                        local resImage=btnCustom_D:SetNormalImage(nextImage);

                        if idx == index then                         
                            --uiItemFreezeItem(btnCustom_D:Get("dragObjectid"),false);    

                            --计算价格变化
                            local tUsrItem=uiBusinessGetUserItemInfoByObjectId(btnCustom_D:Get("dragObjectid"));
                            if tUsrItem then
                              --  local PRICE =tUsrItem.SalePrice;                             
                              --  local SpendMoney,UsrMoney=layWorld_frmNpcShopEx_ModifyMoney(PRICE,false,1);
                              --  layWorld_frmNpcShopEx_ShowMoney(SpendMoney,UsrMoney,1);
                            end           

                        end   

                        btnCustom_D:Set("dragObjectid",btnCustom_D_next:Get("dragObjectid"));

                        local tUsrItem=uiBusinessGetUserItemInfoByObjectId(btnCustom_D:Get("dragObjectid"));
                        if tUsrItem and tUsrItem["Count"]~=nil and tUsrItem["Count"]>0  then
                            --显示数字
                            btnCustom_D:SetUltraTextNormal(tostring(tUsrItem["Count"]));
                        else
                            btnCustom_D:SetUltraTextNormal("");
                        end                       
                       
                            --btnCustom_D:Set("PRICE",btnCustom_D_next:Get("PRICE"));
                    end
                    --清空最后一个
                    
                    local btnCustom_D_last=uiGetglobal("layWorld.frmBPToPEx.btnCustom_D"..DCount);
                    btnCustom_D_last:SetNormalImage("");                   
                    btnCustom_D_last:SetUltraTextNormal("");
                    
                    
					uiInfo("button:Delete = "..button:Get("dragObjectid"));

                end
        end --if dragObjectid then
       
    end 

end

function layWorld_frmBPToPEx_btnCustom_D_OnRClick(self,mouse_x,mouse_y,index)
    layWorld_frmBPToPEx_btnCustom_D_OnLClick(self,mouse_x,mouse_y,index);
end


function layWorld_frmBPToPEx_ShowNpcShop()
    local frmBPToPEx=uiGetglobal("layWorld.frmBPToPEx");   
    
    local index=1;
    
    OtherShop=uiUserTradeGetOtherTradeItemList();


    local normal_Item_count = tonumber(table.getn(OtherShop));

    local count_x = tonumber(frmBPToPEx:Get("Col"));--列数
    local count_y = tonumber(frmBPToPEx:Get("Line"));--行数
    local Total = tonumber(tonumber(count_x)*tonumber(count_y)); 
    

   
    while index<=Total do          
        local button=uiGetglobal("layWorld.frmBPToPEx.btnCustom"..(index));
        local dx=math.mod((index-1),count_x);
        local dy=math.floor((index-1)/count_x);

		button:Delete("dragObjectid");
        button:SetNormalImage("");
        button:SetUltraTextNormal("");
        button:SetUltraTextShortcut("");
        button:Set("COUNT",-1);
        button:Set("NUMBER",-1);
        --button:Set("LEFTNUMBER",-1); --假设稀有物品不能交易
        --button:Set("TYPE","");

       

        if index<=normal_Item_count and OtherShop[index] then
            local Item_Info = uiUserTradeGetItemInfoByObjectId(OtherShop[index].ObjectId);

            local n_info_TableID=Item_Info.TableId;
            local n_info_RealCount=Item_Info.Count;
           
            --if bAutoSort==false or bAutoSort==true and bNotAutoSortShow==true then
                 local n_table=uiItemGetItemClassInfoByTableIndex(n_info_TableID);   
                 
                 if n_table~=nil then
                      
                      button:Set("COUNT",tonumber(n_info_RealCount));       
                      button:Set("NUMBER",-1);
                      --button:Set("LEFTNUMBER",-1);

                      button:SetNormalImage(SAPI.GetImage(n_table.Icon));
                     if  Item_Info.Count and Item_Info.Count>0 then 
                         button:SetUltraTextNormal(tostring(Item_Info.Count));
                         button:Set("NUMBER",Item_Info.Count);
                     end
                     --if n_info_RealType == "Limit" then 
                     --    button:SetUltraTextShortcut(tostring(n_info_Limit_Count));
                     --    button:Set("LEFTNUMBER",tonumber(n_info_Limit_Count));
                     --end
                 end
               
            
        end --if NNpcShopExInfo[ishopindex] then
        index=index+1;
       
    end

        

end


function layWorld_frmBPToPEx_btnCustom_OnHint(self,index)
    --上面按钮可以不再显示，下面代码可屏蔽
    local frmBPToPEx = uiGetglobal("layWorld.frmBPToPEx");    
    local n_info_TableIDCount=table.getn(OtherShop);
	local sellHint = 0;
    if index<=n_info_TableIDCount then 
        local n_info_TableID=OtherShop[index].ObjectId;
         if n_info_TableID~= nil then
            sellHint=uiUserTradeGetItemHintByObjectId(n_info_TableID);
         end
    end
    self:SetHintRichText(sellHint);    

end

function layWorld_frmBPToPEx_btnCustom_D_OnHint(self,index)
	uiInfo("layWorld_frmBPToPEx_btnCustom_D_OnHint = "..self:getName());
    local frmBPToPEx = uiGetglobal("layWorld.frmBPToPEx");
    local DCOUNT=frmBPToPEx:Get("DCount")+1;
	uiInfo("DCOUNT = "..tostring(DCOUNT));
	uiInfo("index = "..tostring(index));
	local sellHint = 0;
    if index<=DCOUNT then
        local objectid=self:Get("dragObjectid");
		uiInfo("objectid = "..tostring(objectid));
        if objectid then
            sellHint=uiUserTradeGetItemHintByObjectId(objectid);
			uiInfo("sellHint = "..tostring(sellHint));
        end
    end
    self:SetHintRichText(sellHint);    
end

function layWorld_frmBPToPEx_btCheck_OnLClick(self)    
    local frmBPToPEx = uiGetglobal("layWorld.frmBPToPEx");
    local lbUsergoldnum = SAPI.GetChild(frmBPToPEx,"lbUsergoldnum");
    local lbUsersilvernum = SAPI.GetChild(frmBPToPEx,"lbUsersilvernum");
    local lbUsercoppernum = SAPI.GetChild(frmBPToPEx,"lbUsercoppernum"); 
    local igoldnum,isilvernum,icoppernum ;
    local totalmoney;
    igoldnum=tonumber(lbUsergoldnum:getText());
    isilvernum=tonumber(lbUsersilvernum:getText());
    icoppernum=tonumber(lbUsercoppernum:getText());
    totalmoney=layWorld_Helper_TotalConvert(igoldnum,isilvernum,icoppernum);

    local resMoney=uiUserTradeSetMoney(totalmoney);
    if resMoney == false then
        return 0;
    else 
        lbUsergoldnum:Disable();
        lbUsersilvernum:Disable();
        lbUsercoppernum:Disable();
    end

    local res=uiUserTradeLock();
    if res == true then
        --显示绿色小板板 只锁定自己
        local lbLockState1 = SAPI.GetSibling(self,"lbLockState1");
        local lbLockState2 = SAPI.GetSibling(self,"lbLockState2");
        --lbLockState1:Show();
        lbLockState2:Show();

        --按钮颜色便灰       
        self:Disable();
         --交易按钮为ENABLE 状态 (是否要2边都锁定?)
        if lbLockState1:getVisible()==true and lbLockState2:getVisible()==true then
            local btBuy = SAPI.GetSibling(self,"btBuy");
            btBuy:Enable();
        end
       
    end
end

function layWorld_frmBPToPEx_btBuy_OnLClick(self)
    local frmBPToPEx = uiGetglobal("layWorld.frmBPToPEx");

    local res=uiUserTradeConfirm();
    if res==true then
        --成功交易 隐藏窗口
        self:Disable();
    end
end

function layWorld_frmBPToPEx_Gold_OnTextChanged(self)
    local frmBPToPEx = uiGetglobal("layWorld.frmBPToPEx");
    local lbUsergoldnum = SAPI.GetChild(frmBPToPEx,"lbUsergoldnum");
    local lbUsersilvernum = SAPI.GetChild(frmBPToPEx,"lbUsersilvernum");
    local lbUsercoppernum = SAPI.GetChild(frmBPToPEx,"lbUsercoppernum"); 

    local igoldnum,isilvernum,icoppernum ;
    local irgoldnum,irsilvernum,ircoppernum ; --实际MAX
    igoldnum=tonumber(lbUsergoldnum:getText());
    isilvernum=tonumber(lbUsersilvernum:getText());
    icoppernum=tonumber(lbUsercoppernum:getText());
   
    local totalmoney;
    local usrMoney=uiGetMyInfo("Money");

    totalmoney=layWorld_Helper_TotalConvert(igoldnum,isilvernum,icoppernum);

    irgoldnum,irsilvernum,ircoppernum = layWorld_Helper_GoldConvert(usrMoney);

    if totalmoney>usrMoney then
        --重新刷新可以交易最大金钱
        lbUsergoldnum:SetText(tostring(irgoldnum));
        lbUsersilvernum:SetText(tostring(irsilvernum));
        lbUsercoppernum:SetText(tostring(ircoppernum));
        --左下方显示金钱不足信息

    end

end

function layWorld_frmBPToPEx_OnHide(self)
    uiUserTradeCancel();
	
	-- 解冻全部
	local FreezeItemList = self.FreezeItemList;
	if FreezeItemList == nil then return end
	for i, v in ipairs(FreezeItemList) do
		LClass_ItemFreezeManager:Erase(v);
	end
	self.FreezeItemList = nil;
end


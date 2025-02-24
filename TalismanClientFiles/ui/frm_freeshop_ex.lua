--[[
uiBank_TimeGetDate(number)
7个返回值
年，月，日，时，分，秒，毫秒
--]]

local LastShopItemList =
{
	ActiveList = {},
};

local MainFrame = nil;

local function InsertStallItem (objectid, money)
	if LClass_ItemFreezeManager:IsFreezed(objectid) == true then return false end
	if  uiStallAddStallItem(objectid,money) then
		local ItemInfo = uiItemGetBagItemInfoByObjectId(objectid);
		if ItemInfo.Count == 0 then
			LastShopItemList[objectid] = {Count=ItemInfo.Count, Price=money};
		else
			LastShopItemList[objectid] = {Count=ItemInfo.Count, Price=money/ItemInfo.Count};
		end
		local DCOUNT=MainFrame:Get("DCount")+1;
		local button=SAPI.GetChild(MainFrame,"btnCustom_D"..DCOUNT);
		button:Set("dragObjectid",objectid);
		MainFrame:Set("DCount",DCOUNT);
		-- 冻结
		local FreezeItemList = MainFrame.FreezeItemList;
		if FreezeItemList == nil then FreezeItemList = {} end
		table.insert(FreezeItemList, objectid);
		LClass_ItemFreezeManager:Push(objectid);
		MainFrame.FreezeItemList = FreezeItemList;
	end
end

function layWorld_frmFreeShopEx_OnLoad(self)
	MainFrame = self;
    self:RegisterScriptEventNotify("ToggleStall"); --摆摊界面开关
    self:RegisterScriptEventNotify("RefreshStall"); --刷新自己摊位界面
    self:RegisterScriptEventNotify("RefreshOtherStall"); --刷新目标摊位界面
    self:RegisterScriptEventNotify("RefreshStallTalk"); --刷新摊位聊天内容
    self:RegisterScriptEventNotify("RefreshOtherStallTalk"); --刷新目标摊位聊天内容
    self:RegisterScriptEventNotify("EVENT_StallTradeRecordBuy");--"ssd"			摊位交易记录(购买者)		<对方名字,商品名字,金钱>
    self:RegisterScriptEventNotify("EVENT_StallTradeRecordSell");--"ssd"			摊位交易记录(贩卖者)		<对方名字,商品名字,金钱>
    self:RegisterScriptEventNotify("EVENT_RefreshStallSlogan");      --刷新自己摊位招牌
    self:RegisterScriptEventNotify("EVENT_RefreshOtherStallSlogan"); --刷新目标摊位招牌
    self:RegisterScriptEventNotify("EVENT_SelfStallStateChanged"); --自己摊位状态改变
    self:RegisterScriptEventNotify("EVENT_OtherStallStateChanged"); --目标摊位状态改变
    self:Set("SellCount",0);
    self:Set("SellTotalMoney",0);
    --self:Set("SellTotalMoneyj",0);
    --self:Set("SellTotalMoneyk",0);
    self:Set("Selling",0); --是否在摆摊
end



function layWorld_frmFreeShopEx_OnEvent(self,event,arg)
    if event == "ToggleStall" then
        if self:getVisible() == false and uiStallIsOpen() == true then
			self:ShowAndFocus();
        else
            self:Hide();
        end        
    elseif event == "RefreshStall" then
         layWorld_frmFreeShopEx_Show();
    elseif event =="RefreshOtherStall" then
         local frmLookFreeShopEx= uiGetglobal("layWorld.frmLookFreeShopEx");
         frmLookFreeShopEx:ShowAndFocus();
         layWorld_frmLookFreeShopEx_Show();         
    elseif event =="RefreshStallTalk" then
         local frmStallTalkEx=uiGetglobal("layWorld.frmStallTalkEx");
         local edbBusinessHistory=SAPI.GetChild(frmStallTalkEx,"edbBusinessHistory");
         local TalkList=uiStallGetTalkList();
         edbBusinessHistory:SetText("");
         for idx =1 ,table.getn(TalkList) ,1 do
			  local line = EvUiLuaClass_RichTextLine:new();
			
			  local item = EvUiLuaClass_RichTextItem:new();
			  item.Type = "TEXT";
			  item.Text = TalkList[idx].Talker;
			  item.Hlink = "String:"..TalkList[idx].Talker;
			  line:InsertItem(item);
			
			  local item = EvUiLuaClass_RichTextItem:new();
			  item.Type = "TEXT";
			  item.Text = " "..TalkList[idx].Content;
			  line:InsertItem(item);
			
			  local rich_text = EvUiLuaClass_RichText:new();
			  rich_text:InsertLine(line);
			
              edbBusinessHistory:SetRichText(rich_text:ToRichString(), true);
         end
         edbBusinessHistory:ScrollToBottom();
    
    elseif event =="RefreshOtherStallTalk" then
        local frmOtherStallTalkEx=uiGetglobal("layWorld.frmOtherStallTalkEx");
         local edbBusinessHistory=SAPI.GetChild(frmOtherStallTalkEx,"edbBusinessHistory");
         local TalkList=uiStallGetOtherTalkList();
         edbBusinessHistory:SetText("");
		 local _, othername = uiStallGetOtherStallOwnerInfo();
		 local selfname = uiGetMyInfo("Role");
         for idx =1 ,table.getn(TalkList) ,1 do
		      if othername == TalkList[idx].Talker or selfname == TalkList[idx].Talker then
				  local line = EvUiLuaClass_RichTextLine:new();
				
				  local item = EvUiLuaClass_RichTextItem:new();
				  item.Type = "TEXT";
				  item.Text = TalkList[idx].Talker;
				  item.Hlink = "String:"..TalkList[idx].Talker;
				  line:InsertItem(item);
				
				  local item = EvUiLuaClass_RichTextItem:new();
				  item.Type = "TEXT";
				  item.Text = " "..TalkList[idx].Content;
				  line:InsertItem(item);
				
				  local rich_text = EvUiLuaClass_RichText:new();
				  rich_text:InsertLine(line);
				
				  edbBusinessHistory:SetRichText(rich_text:ToRichString(), true);
			end
         end
         edbBusinessHistory:ScrollToBottom();

    elseif event =="EVENT_RefreshStallSlogan" then
         layWorld_frmFreeShopEx_RefreshStallSlogan(self);
    elseif event =="EVENT_RefreshOtherStallSlogan" then
         layWorld_frmLookFreeShopEx_RefreshOtherStallSlogan();

    elseif event =="EVENT_StallTradeRecordSell" then
         --拍卖成功
         --计算总计数目增加
         self:Set("SellCount",self:Get("SellCount")+1);
         local i,j,k=layWorld_Helper_GoldConvert(arg[3]);
         self:Set("SellTotalMoney",self:Get("SellTotalMoney")+arg[3]);
         --self:Set("SellTotalMoneyj",self:Get("SellTotalMoneyj")+tonumber(j));
         --self:Set("SellTotalMoneyk",self:Get("SellTotalMoneyk")+tonumber(k));
         --frmBussinessHistory editbox添加内容
         local frmBussinessHistoryEx=uiGetglobal("layWorld.frmBussinessHistoryEx");
         local edbBusinessHistory=SAPI.GetChild(frmBussinessHistoryEx,"edbBusinessHistory");
         local ye,mo,da,ho,mi,_,_=uiBank_TimeGetDate(uiGetServerTime());
         local stredb=string.format(uiLanString("msg_stall9").."("..uiLanString("msg_stall10")..")",arg[1],tostring(i),tostring(j),tostring(k),arg[2],tostring(ye),tostring(mo),tostring(da),tostring(ho),tostring(mi));
         edbBusinessHistory:AppendText(stredb);
         edbBusinessHistory:ScrollToBottom();
    elseif event =="EVENT_SelfStallStateChanged" then --自己摊位状态改变
		local btCancelStall = SAPI.GetChild(self, "btCancelStall");
		if uiStallIsStall() == true then
             btCancelStall:SetText(uiLanString("msg_stall27")); --取消摆摊
		else
             btCancelStall:SetText(uiLanString("msg_stall26")); --开始
		end
    elseif event =="EVENT_OtherStallStateChanged" then --目标摊位状态改变
        local frmLookFreeShopEx=uiGetglobal("layWorld.frmLookFreeShopEx");
		if uiStallOtherIsStall() ~= true then
			frmLookFreeShopEx:Hide();
		end
    end
end

function layWorld_frmFreeShopEx_RefreshStallSlogan(self)
    if not self then self = uiGetglobal("layWorld.frmFreeShopEx") end
    local lbShopAD = SAPI.GetChild(self,"lbShopAD");
    local strAD=uiStallGetSlogan();
    lbShopAD:SetText(strAD);
end

function layWorld_frmSetmoneyEx_btSetCancel_OnLClick(self)
    local frmSetmoneyEx = uiGetglobal("layWorld.frmSetmoneyEx");
    frmSetmoneyEx:Hide();
end

function layWorld_frmSetmoneyEx_OnShow(self)
	local EdbGold = SAPI.GetChild(self, "EdbGold");
	local EdbAg = SAPI.GetChild(self, "EdbAg");
	local EdbCu = SAPI.GetChild(self, "EdbCu");
	EdbGold:SetText("0");
	EdbAg:SetText("0");
	EdbCu:SetText("0");
	EdbGold:SetFocus();
end

function layWorld_frmFreeShopEx_OnShow(self)
    local frmStallTalkEx=uiGetglobal("layWorld.frmStallTalkEx");
    frmStallTalkEx:ShowAndFocus();

    --XXX的摊点
    local lbStallOwner=SAPI.GetChild(self,"lbStallOwner");
    local myname,_,_=uiGetMyInfo("Role");
    local OwnerText=string.format(uiLanString("msg_stall2"),myname);
    lbStallOwner:SetText(OwnerText);

    --开始摆摊/取消摆摊
    local btCancelStall=SAPI.GetChild(self,"btCancelStall");
    btCancelStall:SetText(uiLanString("msg_stall26")); --开始

    local shopinfo=uiStallGetStallInfo();

    if shopinfo then
        self:Set("DLeft",shopinfo.ItemSlot.Stall.Left);
        self:Set("DTop",shopinfo.ItemSlot.Stall.Top);
        self:Set("DRight",shopinfo.ItemSlot.Stall.Right);
        self:Set("DBottom",shopinfo.ItemSlot.Stall.Bottom);
        self:Set("DOffsetLeft",shopinfo.ItemSlot.Stall.OffsetLeft);
        self:Set("DOffsetTop",shopinfo.ItemSlot.Stall.OffsetTop);
        self:Set("DOffsetRight",shopinfo.ItemSlot.Stall.OffsetRight);
        self:Set("DOffsetBottom",shopinfo.ItemSlot.Stall.OffsetBottom);
        self:Set("DWidth",shopinfo.ItemSlot.Stall.Width);
        self:Set("DHeight",shopinfo.ItemSlot.Stall.Height);
        self:Set("DLine",shopinfo.ItemSlot.Stall.Line);
        self:Set("DCol",shopinfo.ItemSlot.Stall.Col);
        self:Set("DPage",shopinfo.ItemSlot.Stall.Page);

        local dlocation_x = tonumber(self:Get("DLeft"));
        local dlocation_y = tonumber(self:Get("DTop"));
        local dcount_x = tonumber(self:Get("DCol"));--列数
        local dcount_y = tonumber(self:Get("DLine"));--行数
        local dTotal = tonumber(tonumber(dcount_x)*tonumber(dcount_y));
        local dWidth = tonumber(self:Get("DWidth"));
        local dHeight = tonumber(self:Get("DHeight"));
        local doffset_x = tonumber(self:Get("DOffsetLeft"));
        local doffset_y = tonumber(self:Get("DOffsetTop"));
        local doffset_xx = tonumber(self:Get("DOffsetRight"));
        local doffset_yy = tonumber(self:Get("DOffsetBottom")); 

        local drWidth,drHeight;

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
    end
	layWorld_frmFreeShopEx_RefreshStallSlogan(self);
	
	if LastShopItemList.ActiveList then
		for i, ObjectId in ipairs(LastShopItemList.ActiveList) do
			local info = LastShopItemList[ObjectId];
			if info then
				local Item = uiItemGetBagItemInfoByObjectId(ObjectId);
				if Item then
					if info.Count == 0 then
						-- 不可数
						InsertStallItem(ObjectId, info.Price);
					else
						-- 可数
						InsertStallItem(ObjectId, info.Price * Item.Count);
					end
				end
			end
		end
	end
	LastShopItemList.ActiveList = {};
end



function layWorld_frmSetmoneyEx_btSetOk_OnLClick(self)
     local frmSetmoneyEx=uiGetglobal("layWorld.frmSetmoneyEx");

     local frmFreeShopEx = uiGetglobal("layWorld.frmFreeShopEx");
     local dragObjectid=frmSetmoneyEx:Get("dragObjectid");  
     local DCOUNT=frmSetmoneyEx:Get("DCOUNT");
     local button=SAPI.GetChild(frmFreeShopEx,"btnCustom_D"..DCOUNT);
     local usrItem=uiBusinessGetUserItemInfoByObjectId(dragObjectid);
     local btnTable=uiItemGetItemClassInfoByTableIndex(usrItem.TableId); 

     --获得贩卖价格   
     local EdbGold=SAPI.GetChild(frmSetmoneyEx,"EdbGold");
     local EdbAg=SAPI.GetChild(frmSetmoneyEx,"EdbAg");
     local EdbCu=SAPI.GetChild(frmSetmoneyEx,"EdbCu");
     local totalmoney=SAPI.GetMoneyFromShowStyle(EdbGold:getText(),EdbAg:getText(),EdbCu:getText());     

	 InsertStallItem(tonumber(dragObjectid),tonumber(totalmoney));
	 --[[
     if  uiStallAddStallItem(tonumber(dragObjectid),tonumber(totalmoney)) then
         button:Set("dragObjectid",dragObjectid);
         frmFreeShopEx:Set("DCount",DCOUNT);
		 
		 -- 冻结
		 local FreezeItemList = frmFreeShopEx.FreezeItemList;
		 if FreezeItemList == nil then FreezeItemList = {} end
		 table.insert(FreezeItemList, dragObjectid);
		 LClass_ItemFreezeManager:Push(dragObjectid);
		 frmFreeShopEx.FreezeItemList = FreezeItemList;
		 
     end
	 ]]
     frmSetmoneyEx:Hide();
end


function layWorld_frmFreeShopEx_Show()  
    local self=uiGetglobal("layWorld.frmFreeShopEx");
    local objlist=uiStallGetSaleItemList();
    --DCOUNT 下面总数
    --每个dbutton:Set("dragObjectid")
    local number=table.getn(objlist);
    self:Set("DCount",number);
	
	FreezeItemList = self.FreezeItemList;
	if FreezeItemList then
		local index = 1;
		while index <= table.getn(FreezeItemList) do
			if SAPI.ExistInTable(objlist, FreezeItemList[index]) == false then
				LClass_ItemFreezeManager:Erase(FreezeItemList[index]);
				table.remove(FreezeItemList, index);
			else
				index = index + 1;
			end
		end
		self.FreezeItemList = FreezeItemList;
	end
    
    for idx=1,24,1 do
        local dbutton = SAPI.GetChild(self,"btnCustom_D"..idx);
        dbutton:SetNormalImage(0);
        dbutton:SetUltraTextNormal("");
        dbutton:Set("COUNT",-1);
        dbutton:Delete("dragObjectid");
        dbutton:Show();
        if idx<=number then
            local usrItem=uiBusinessGetUserItemInfoByObjectId(objlist[idx]);
            local btnTable=uiItemGetItemClassInfoByTableIndex(usrItem.TableId); 
            dbutton:SetNormalImage(SAPI.GetImage(btnTable.Icon));
            local tUsrItem=uiBusinessGetUserItemInfoByObjectId(objlist[idx]);
            if tUsrItem["Count"]~=nil and tUsrItem["Count"]>0  then
               --显示数字
                dbutton:SetUltraTextNormal(tostring(tUsrItem["Count"]));
            else
                dbutton:SetUltraTextNormal("");
            end 
            dbutton:Set("dragObjectid",objlist[idx]);            
        end
    end
end

function layWorld_frmFreeShopEx_btnCustom_D_OnDragIn(self,drag,index)
    local frmFreeShopEx = uiGetglobal("layWorld.frmFreeShopEx");
    --local NpcId=frmSaleShopEx:Get("NpcId");  
    local DCOUNT=frmFreeShopEx:Get("DCount")+1;
    local button=SAPI.GetSibling(self,"btnCustom_D"..DCOUNT);
	
	

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
	
	if uiCheckCanStallItem(shortcut_objectid) ~= true then return end
	
    local dragObjectid = shortcut_objectid;

    local frmSetmoneyEx = uiGetglobal("layWorld.frmSetmoneyEx");
    if dragObjectid ~= nil then 
         frmSetmoneyEx:Set("dragObjectid",dragObjectid);
         frmSetmoneyEx:Set("DCOUNT",DCOUNT);
		 frmSetmoneyEx:Hide();
         frmSetmoneyEx:ShowAndFocus();
    end
end

function layWorld_frmFreeShopEx_btnCustom_D_OnHint(self,index)
    local frmFreeShopEx = uiGetglobal("layWorld.frmFreeShopEx");
    local DCOUNT=frmFreeShopEx:Get("DCount")+1;
    self:SetHintRichText(0);   
    if index<=DCOUNT then
        local objectid=self:Get("dragObjectid");
        if objectid then
            local sellHint=uiStallGetItemHint(objectid);
            self:SetHintRichText(sellHint);    
        end
    end
end





-- 点击取消 不放到摆摊栏目里面了
function layWorld_frmFreeShopEx_btnCustom_D_OnLClick(self,mouse_x,mouse_y,index)
    local frmFreeShopEx = uiGetglobal("layWorld.frmFreeShopEx");
    --local NpcId = frmSaleShopEx:Get("NpcId");
    --local NpcObjectId = frmSaleShopEx:Get("NpcObjectId"); 
    local DCount = frmFreeShopEx:Get("DCount");  --下面目前总数
   
    if DCount and index<=DCount then 
        local button=SAPI.GetSibling(self,"btnCustom_D"..index);
        local dragObjectid = button:Get("dragObjectid");

        if dragObjectid then
                local RemoveRes=uiStallRemoveStallItem(tonumber(dragObjectid));
                if RemoveRes then
                --移走成功      
					-- 解冻指定道具
					local FreezeItemList = frmFreeShopEx.FreezeItemList;
					if FreezeItemList then
						local index = SAPI.GetIndexInTable(FreezeItemList, dragObjectid);
						if index > 0 then -- 找到了
							table.remove(FreezeItemList, index);
							LClass_ItemFreezeManager:Erase(dragObjectid);
							frmFreeShopEx.FreezeItemList = FreezeItemList;
						end
					end
					
					
                    frmFreeShopEx:Set("DCount",DCount-1);
                    --往前平移
                    for idx = index ,DCount,1 do
                        local btnCustom_D = uiGetglobal("layWorld.frmFreeShopEx.btnCustom_D"..idx);
                        local btnCustom_D_next = uiGetglobal("layWorld.frmFreeShopEx.btnCustom_D"..idx+1);

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
                    local btnCustom_D_last=uiGetglobal("layWorld.frmFreeShopEx.btnCustom_D"..DCount);
                    btnCustom_D_last:SetNormalImage("");                   
                    btnCustom_D_last:SetUltraTextNormal("");
                    
                    

                end
        end --if dragObjectid then
       
    end 

end

function layWorld_frmFreeShopEx_btnCustom_D_OnRClick(self,mouse_x,mouse_y,index)
    layWorld_frmFreeShopEx_btnCustom_D_OnLClick(self,mouse_x,mouse_y,index);
end

function layWorld_frmFreeShopEx_OnHide(self)
	for i, v in ipairs(uiStallGetSaleItemList()) do
		table.insert(LastShopItemList.ActiveList, uiStallGetSaleItemInfo(v).ObjectId);
	end
	
    uiStallClose();
	uiStallClear();

    local frmBussinessHistoryEx = uiGetglobal("layWorld.frmBussinessHistoryEx");
    frmBussinessHistoryEx:Hide();
    local frmStallTalkEx = uiGetglobal("layWorld.frmStallTalkEx");
    frmStallTalkEx:Hide();
	
	
	-- 解冻全部
	local FreezeItemList = self.FreezeItemList;
	if FreezeItemList == nil then return end
	for i, v in ipairs(FreezeItemList) do
		LClass_ItemFreezeManager:Erase(v);
	end
	self.FreezeItemList = nil;


end
--开始摆摊
function layWorld_frmFreeShopEx_btCancelStall_OnLClick(self)
    local isBT=uiStallIsStall(); --true ing ,false no ing
    if isBT ==true then
		uiStallClose();
    else
		uiStallOpen();
    end

end

--设置摊点AD
function layWorld_frmFreeShopEx_btSetAD_OnLClick(self)
     local msgBox = uiInputBox(uiLanString("msg_stall1"),"","",true,true,true);
     SAPI.AddDefaultInputBoxCallBack(msgBox,layWorld_frmFreeShopEx_btSetAD_Yes,layWorld_frmFreeShopEx_btSetAD_No,0);
end

function layWorld_frmFreeShopEx_btSetAD_Yes(_,_,content)
    --获得content
    local res=uiStallSetSlogan(content);
end

function layWorld_frmFreeShopEx_btSetAD_No(_,content,_)
end

--摆摊历史
function layWorld_frmFreeShopEx_btHistory_OnLClick(self)
     local frmBussinessHistoryEx=uiGetglobal("layWorld.frmBussinessHistoryEx");
     frmBussinessHistoryEx:ShowAndFocus();
end

--摆摊留言
function layWorld_frmFreeShopEx_btStallTalk_OnLClick(self)
    local frmStallTalkEx=uiGetglobal("layWorld.frmStallTalkEx");
    frmStallTalkEx:ShowAndFocus();
end

-------------------------------------------------------------------------------------------
--frmBussinessHistory
--总计交易情况
function layWorld_frmBussinessHistoryEx_btTotalStat_OnLClick(self)
    --获取已卖出数量，和对应数量的金钱价值
    local frmFreeShopEx=uiGetglobal("layWorld.frmFreeShopEx");
    local SellCount=frmFreeShopEx:Get("SellCount");
    local SellTotalMoney=frmFreeShopEx:Get("SellTotalMoney");
    --local SellTotalMoneyj=frmFreeShopEx:Get("SellTotalMoneyj");
    --local SellTotalMoneyk=frmFreeShopEx:Get("SellTotalMoneyk");
	
	local SellTotalMoneyi,SellTotalMoneyj,SellTotalMoneyk = layWorld_Helper_GoldConvert(SellTotalMoney);

    local strSell=string.format(uiLanString("msg_stall19"),SellCount,SellTotalMoneyi,SellTotalMoneyj,SellTotalMoneyk);
    --弹出MessageBox 显示总计信息
     uiMessageBox(strSell,"",true,false,true);
end

--关闭按钮
function layWorld_frmBussinessHistoryEx_btBusinessClose_OnLClick(self)
    local frmBussinessHistoryEx=uiGetglobal("layWorld.frmBussinessHistoryEx");
    frmBussinessHistoryEx:Hide();

end

--清除editbox里面内容
function layWorld_frmBussinessHistoryEx_btBusinessClear_OnLClick(self)
    --清除editbox 

    local frmBussinessHistoryEx=uiGetglobal("layWorld.frmBussinessHistoryEx");
    local edbBusinessHistory=SAPI.GetChild(frmBussinessHistoryEx,"edbBusinessHistory");
    edbBusinessHistory:SetText("");
    
    --清除全局计数内容
    local frmFreeShopEx=uiGetglobal("layWorld.frmFreeShopEx");
    frmFreeShopEx:Set("SellCount",0);
    frmFreeShopEx:Set("SellTotalMoney",0);
    --frmFreeShopEx:Set("SellTotalMoneyj",0);
    --frmFreeShopEx:Set("SellTotalMoneyk",0);


end

---------------------------------------------------------------------------------
--frm_StallTalk_ex.xml
--拍卖留言
function layWorld_frmStallTalkEx_btBusinessClose_OnLClick(self)
    local frmStallTalkEx=uiGetglobal("layWorld.frmStallTalkEx");
    frmStallTalkEx:Hide();
end

--清除拍卖留言的editbox里面内容
function layWorld_frmStallTalkEx_btBusinessClear_OnLClick(self)
    --清除editbox 
    local frmStallTalkEx=uiGetglobal("layWorld.frmStallTalkEx");
    local edbBusinessHistory=SAPI.GetChild(frmStallTalkEx,"edbBusinessHistory");
	if edbBusinessHistory:getText() ~= "" then
		uiStallClearTalkList();
	end
	--[[
    local frmStallTalkEx=uiGetglobal("layWorld.frmStallTalkEx");
    local edbBusinessHistory=SAPI.GetChild(frmStallTalkEx,"edbBusinessHistory");
    edbBusinessHistory:SetText("");
	]]
end

function layWorld_frmStallTalkEx_edbBusinessHistory(self, hypertype, hyperlink)
	if not hyperlink then return end
	local name = hyperlink;
	local online = true;
	uiShowPopmenuPlayer(hyperlink, online);
end

--卖方进行拍卖留言
function layWorld_frmStallTalkEx_btStallTalk_OnLClick(self)
  local msgBox = uiInputBox(uiLanString("msg_stall21"),"","",true,false,true);
     SAPI.AddDefaultInputBoxCallBack(msgBox,layWorld_frmStallTalkEx_btStallTalk_Yes,nil,0);
end

function layWorld_frmStallTalkEx_btStallTalk_Yes(_,_,content)
    --获得content
    if uiStallIsStall()==true then
        if content~="" then
            uiStallAddTalk(content);
        end
    end

end

---------------------------------------------------------------------------------------------------------------------
--购买者
--frm_LookFreeShop_ex.xml

function layWorld_frmLookFreeShopEx_OnLoad(self)

end

function layWorld_frmLookFreeShopEx_RefreshOtherStallSlogan()
    local frmLookFreeShopEx = uiGetglobal("layWorld.frmLookFreeShopEx");
    local lbShopAD = SAPI.GetChild(frmLookFreeShopEx,"lbShopAD");
    local strAD=uiStallGetOtherSlogan();
    lbShopAD:SetText(strAD);
end

function layWorld_frmLookFreeShopEx_OnShow(self)
	uiRegisterEscWidget(self);
    local frmOtherStallTalkEx=uiGetglobal("layWorld.frmOtherStallTalkEx");
    frmOtherStallTalkEx:ShowAndFocus();

  --XXX的摊点
    local lbStallOwner=SAPI.GetChild(self,"lbStallOwner");
    
    local _,hisname=uiStallGetOtherStallOwnerInfo();
    local OwnerText=string.format(uiLanString("msg_stall2"),hisname);
    lbStallOwner:SetText(OwnerText);


    local shopinfo=uiStallGetStallInfo();
    if shopinfo then
        self:Set("DLeft",shopinfo.ItemSlot.OtherStall.Left);
        self:Set("DTop",shopinfo.ItemSlot.OtherStall.Top);
        self:Set("DRight",shopinfo.ItemSlot.OtherStall.Right);
        self:Set("DBottom",shopinfo.ItemSlot.OtherStall.Bottom);
        self:Set("DOffsetLeft",shopinfo.ItemSlot.OtherStall.OffsetLeft);
        self:Set("DOffsetTop",shopinfo.ItemSlot.OtherStall.OffsetTop);
        self:Set("DOffsetRight",shopinfo.ItemSlot.OtherStall.OffsetRight);
        self:Set("DOffsetBottom",shopinfo.ItemSlot.OtherStall.OffsetBottom);
        self:Set("DWidth",shopinfo.ItemSlot.OtherStall.Width);
        self:Set("DHeight",shopinfo.ItemSlot.OtherStall.Height);
        self:Set("DLine",shopinfo.ItemSlot.OtherStall.Line);
        self:Set("DCol",shopinfo.ItemSlot.OtherStall.Col);
        self:Set("DPage",shopinfo.ItemSlot.OtherStall.Page);

        local dlocation_x = tonumber(self:Get("DLeft"));
        local dlocation_y = tonumber(self:Get("DTop"));
        local dcount_x = tonumber(self:Get("DCol"));--列数
        local dcount_y = tonumber(self:Get("DLine"));--行数
        local dTotal = tonumber(tonumber(dcount_x)*tonumber(dcount_y));
        local dWidth = tonumber(self:Get("DWidth"));
        local dHeight = tonumber(self:Get("DHeight"));
        local doffset_x = tonumber(self:Get("DOffsetLeft"));
        local doffset_y = tonumber(self:Get("DOffsetTop"));
        local doffset_xx = tonumber(self:Get("DOffsetRight"));
        local doffset_yy = tonumber(self:Get("DOffsetBottom")); 

        local drWidth,drHeight;

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
    end
	uiStallViewOtherTalkList();
end

function layWorld_frmLookFreeShopEx_Show()
    local self=uiGetglobal("layWorld.frmLookFreeShopEx");
    local objlist=uiStallGetOtherSaleItemList();
    --DCOUNT 下面总数
    --每个dbutton:Set("dragObjectid")
    local number=table.getn(objlist);
    self:Set("DCount",number);
    
    for idx=1,24,1 do
        local dbutton = SAPI.GetChild(self,"btnCustom_D"..idx);
        dbutton:SetNormalImage("");
        dbutton:SetUltraTextNormal("");
        dbutton:Set("COUNT",-1);
        dbutton:Delete("dragObjectid");
        dbutton:Show();
        if idx<=number then
            --local usrItem=uiItemGetItemInfoByObjectId(objlist[idx]);
            local usrItem=uiStallGetOtherSaleItemInfo(objlist[idx]);
            local btnTable=uiItemGetItemClassInfoByTableIndex(usrItem.TableId); 
            dbutton:SetNormalImage(SAPI.GetImage(btnTable.Icon));
            local tUsrItem=usrItem;
            if tUsrItem["Count"]~=nil and tUsrItem["Count"]>0  then
               --显示数字
                dbutton:SetUltraTextNormal(tostring(tUsrItem["Count"]));
            else
                dbutton:SetUltraTextNormal("");
            end 
            dbutton:Set("dragObjectid",objlist[idx]);            
        end
    end
	layWorld_frmLookFreeShopEx_RefreshOtherStallSlogan();
end

function layWorld_frmLookFreeShopEx_btnCustom_D_OnHint(self,index)
    local frmLookFreeShopEx = uiGetglobal("layWorld.frmLookFreeShopEx");
    local DCOUNT=frmLookFreeShopEx:Get("DCount")+1;
    self:SetHintRichText(0);   
    if index<=DCOUNT then
        local objectid=self:Get("dragObjectid");
        if objectid then
            local sellHint=uiStallGetItemHint(objectid);
            self:SetHintRichText(sellHint);    
        end
    end
end

--买东西
function layWorld_frmLookFreeShopEx_btnCustom_D_OnLClick(self,mouse_x,mouse_y,index)    
    local frmLookFreeShopEx = uiGetglobal("layWorld.frmLookFreeShopEx");    
    
    local button=SAPI.GetSibling(self,"btnCustom_D"..index);
    
    local dragObjectid = button:Get("dragObjectid");
	
	if uiCheckCanBuyStallItem(dragObjectid) ~= true then return end

    --local ItemInfo=uiItemGetItemInfoByObjectId(dragObjectid);
    local ItemInfo=uiStallGetOtherSaleItemInfo(dragObjectid);
    local Count=ItemInfo.Count;

    if Count>1 then
        local frmFreeBuyBreakEx = uiGetglobal("layWorld.frmFreeBuyBreakEx");
        if dragObjectid ~= nil then
            frmFreeBuyBreakEx:Set("dragObjectid",dragObjectid);
            frmFreeBuyBreakEx:Set("DCOUNT",DCOUNT);
            frmFreeBuyBreakEx:ShowAndFocus();
        end
    else
         local SaleItem=uiStallGetOtherSaleItemInfo(dragObjectid);
         local SaleItemPrice=SaleItem.Price;
         local i,j,k=layWorld_Helper_GoldConvert(SaleItemPrice); 
         --local ItemInfo=uiItemGetItemInfoByObjectId(dragObjectid);
         local ItemInfo=uiStallGetOtherSaleItemInfo(dragObjectid);
         local TableInfo=uiItemGetItemClassInfoByTableIndex(ItemInfo.TableId);
         local ItemName=TableInfo.Name;
         local msgstr=string.format(uiLanString("msg_stall4"),i,j,k,ItemName);
         local msgBox =uiMessageBox(msgstr,"",true,true,true);
         SAPI.AddDefaultMessageBoxCallBack(msgBox,layWorld_frmLookFreeShopEx_btnCustom_D_YES,layWorld_frmLookFreeShopEx_btnCustom_D_No,dragObjectid);
    end
end

function layWorld_frmLookFreeShopEx_btnCustom_D_YES(_,dragObjectid)
     uiStallBuyStallItem(tonumber(dragObjectid),0);
end

function layWorld_frmLookFreeShopEx_btnCustom_D_No(_,dragObjectid)
end



function layWorld_frmLookFreeShopEx_btnCustom_D_OnRClick(self,mouse_x,mouse_y,index)
    layWorld_frmLookFreeShopEx_btnCustom_D_OnLClick(self,mouse_x,mouse_y,index);
end

--关闭
function layWorld_frmLookFreeShopEx_btClose_OnLClick(self)
    local frmLookFreeShopEx= uiGetglobal("layWorld.frmLookFreeShopEx");
    frmLookFreeShopEx:Hide();
end

--留言内容
function layWorld_frmLookFreeShopEx_btStallTalk_OnLClick(self)
    local frmOtherStallTalkEx=uiGetglobal("layWorld.frmOtherStallTalkEx");
    frmOtherStallTalkEx:ShowAndFocus();
	uiStallViewOtherTalkList();
end
-----------------------------------------------------------------------
--frm_OtherStallTalk_ex.xml
function layWorld_frmOtherStallTalkEx_btBusinessClose_OnLClick(self)
    local frmOtherStallTalkEx=uiGetglobal("layWorld.frmOtherStallTalkEx");
    frmOtherStallTalkEx:Hide();
end

function layWorld_frmOtherStallTalkEx_edbBusinessHistory(self, hypertype, hyperlink)
	if not hyperlink then return end
	local name = hyperlink;
	local online = true;
	uiShowPopmenuPlayer(hyperlink, online);
end

--进行留言
function layWorld_frmOtherStallTalkEx_btStallTalk_OnLClick(self)
     local msgBox = uiInputBox(uiLanString("msg_stall21"),"","",true,false,true);
     SAPI.AddDefaultInputBoxCallBack(msgBox,layWorld_frmOtherStallTalkEx_btStallTalk_Yes,nil,0);
end

function layWorld_frmOtherStallTalkEx_btStallTalk_Yes(_,_,content)
    --获得content
    if content~="" then
        local res=uiStallAddOtherTalk(content);
    end
end

------------------------------------------------------------------------
--frm_FreeBuyBreak_ex.xml
function layWorld_frmFreeBuyBreakEx_btFBBClose_OnLClick(self)
    local frmFreeBuyBreakEx=uiGetglobal("layWorld.frmFreeBuyBreakEx");
    frmFreeBuyBreakEx:Hide();
end

function layWorld_frmFreeBuyBreakEx_edbNumCount_OnUpdate(self)
	local count = 0;
	local form = SAPI.GetParent(self);
	for i = 1, 1, 1 do
		local text = self:getText();
		if text == "" then break end
		if count == nil then count = 1; self:SetText("1") break end
		count = tonumber(text);
		if count == 0 then break end
		
		local id = form:Get("dragObjectid");
		if id == nil or id == 0 then form:Hide() break end
		local iteminfo = uiStallGetOtherSaleItemInfo(id);
		if iteminfo == nil then form:Hide() break end
		if count == nil then count = 1 end
		if count > iteminfo.Count then count = iteminfo.Count end
		if count < 1 then count = 1 end
		if text == tostring(count) then break end
		self:SetText(tostring(count));
	end
	form:Set("BUYCOUNT",count);
	local i,j,k = 0,0,0;
	if count > 0 then
		local SaleItemPrice=layWorld_frmFreeBuyBreakEx_CountPrice(count);
		i,j,k=layWorld_Helper_GoldConvert(SaleItemPrice);
	end
	local strFreebuy=string.format(uiLanString("msg_stall29"),tonumber(count),tostring(i),tostring(j),tostring(k));
	local FreebuyIndex=SAPI.GetChild(form,"FreebuyIndex");
	FreebuyIndex:SetText(strFreebuy);
end

function layWorld_frmFreeBuyBreakEx_CountPrice(buycount)
    local frmFreeBuyBreakEx=uiGetglobal("layWorld.frmFreeBuyBreakEx");
    local dragObjectid=frmFreeBuyBreakEx:Get("dragObjectid");
    local SaleItem=uiStallGetOtherSaleItemInfo(dragObjectid);
    local SaleItemPrice=SaleItem.Price;
    --local usrItem=uiItemGetItemInfoByObjectId(dragObjectid);
    local usrItem=uiStallGetOtherSaleItemInfo(dragObjectid);
    local tCount=usrItem.Count;
    local retprice=math.floor(SaleItemPrice/tCount*buycount);
    if retprice<=0 then
        retprice=1;
    end
    return retprice;
end

function layWorld_frmFreeBuyBreakEx_maxcount()
    local frmFreeBuyBreakEx=uiGetglobal("layWorld.frmFreeBuyBreakEx");
    local dragObjectid=frmFreeBuyBreakEx:Get("dragObjectid");
    --local usrItem=uiItemGetItemInfoByObjectId(dragObjectid);
    local usrItem=uiStallGetOtherSaleItemInfo(dragObjectid);
    local tCount=usrItem.Count;
    return tCount;
end

function layWorld_frmFreeBuyBreakEx_OnShow(self)
	uiRegisterEscWidget(self);
	
    local dragObjectid=self:Get("dragObjectid");
   
    local edbNumCount=SAPI.GetChild(self,"edbNumCount");
    local FreebuyIndex=SAPI.GetChild(self,"FreebuyIndex");
    edbNumCount:SetText("1");
    self:Set("BUYCOUNT",1);

    local SaleItemPrice=layWorld_frmFreeBuyBreakEx_CountPrice(1);    
    local i,j,k=layWorld_Helper_GoldConvert(SaleItemPrice);

    local strFreebuy=string.format(uiLanString("msg_stall29"),tonumber(1),tostring(i),tostring(j),tostring(k));
    FreebuyIndex:SetText(strFreebuy);
end

--左移(数量-1)
function layWorld_frmFreeBuyBreakEx_btItemb1_OnLClick(self)
    local frmFreeBuyBreakEx=uiGetglobal("layWorld.frmFreeBuyBreakEx");
    local BUYCOUNT=frmFreeBuyBreakEx:Get("BUYCOUNT");
    if BUYCOUNT >=2 then
        frmFreeBuyBreakEx:Set("BUYCOUNT",BUYCOUNT-1);
        local SaleItemPrice=layWorld_frmFreeBuyBreakEx_CountPrice(BUYCOUNT-1);
        local i,j,k=layWorld_Helper_GoldConvert(SaleItemPrice);
        local strFreebuy=string.format(uiLanString("msg_stall29"),tonumber(BUYCOUNT-1),tostring(i),tostring(j),tostring(k));
        local FreebuyIndex=SAPI.GetChild(frmFreeBuyBreakEx,"FreebuyIndex");
        FreebuyIndex:SetText(strFreebuy);
        local edbNumCount=SAPI.GetChild(frmFreeBuyBreakEx,"edbNumCount");
        edbNumCount:SetText(tostring(BUYCOUNT-1));
    end
end

--右移(数量+1)
function layWorld_frmFreeBuyBreakEx_btItemb2_OnLClick(self)
    local frmFreeBuyBreakEx=uiGetglobal("layWorld.frmFreeBuyBreakEx");
    local BUYCOUNT=frmFreeBuyBreakEx:Get("BUYCOUNT");
     if BUYCOUNT <layWorld_frmFreeBuyBreakEx_maxcount() then
        frmFreeBuyBreakEx:Set("BUYCOUNT",BUYCOUNT+1);
        local SaleItemPrice=layWorld_frmFreeBuyBreakEx_CountPrice(BUYCOUNT+1);
        local i,j,k=layWorld_Helper_GoldConvert(SaleItemPrice);
        local strFreebuy=string.format(uiLanString("msg_stall29"),tonumber(BUYCOUNT+1),tostring(i),tostring(j),tostring(k));
        local FreebuyIndex=SAPI.GetChild(frmFreeBuyBreakEx,"FreebuyIndex");
        FreebuyIndex:SetText(strFreebuy);
        local edbNumCount=SAPI.GetChild(frmFreeBuyBreakEx,"edbNumCount");
        edbNumCount:SetText(tostring(BUYCOUNT+1));
    end
end

function layWorld_frmFreeBuyBreakEx_btFBBOk_OnLClick(self)
     local frmFreeBuyBreakEx=uiGetglobal("layWorld.frmFreeBuyBreakEx");
     local dragObjectid=frmFreeBuyBreakEx:Get("dragObjectid");   
     local BUYCOUNT=frmFreeBuyBreakEx:Get("BUYCOUNT");   
		
	 if BUYCOUNT <= 0 then frmFreeBuyBreakEx:Hide(); return end
     if  uiStallBuyStallItem(tonumber(dragObjectid),tonumber(BUYCOUNT)) then
         frmFreeBuyBreakEx:Hide();
     end
end




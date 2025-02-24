----和NPC交易对话框
NNpcShopPage1={};
NNpcShopPage2={};
NNpcShopPage3={};
NNpcShopExInfo={NNpcShopPage1,NNpcShopPage2,NNpcShopPage3};

SaleShopExPage1={};
SaleShopExPage2={};
SaleShopExPage3={};
SaleShopExInfo={SaleShopExPage1,SaleShopExPage2,SaleShopExPage3};

function layWorld_frmNpcShopEx_OnLoad(self)
      self:RegisterScriptEventNotify("event_open_npc_shop");
      self:RegisterScriptEventNotify("event_open_sale_shop");
      self:RegisterScriptEventNotify("event_pvp_point_update");
      -----is here ok?
      self:RegisterScriptEventNotify("bag_item_removed");
      self:RegisterScriptEventNotify("bag_item_update");
      self:RegisterScriptEventNotify("bag_item_added");
      self:RegisterScriptEventNotify("bag_item_exchange_grid");


      self:Set("TimeCount",0);
      self:Set("normal_Item_count",0);
      self:Set("limit_Item_count",0);
      self:Delete("NpcId");
      self:Delete("NpcObjectId");
end

function layWorld_frmNpcShopEx_OnEvent(self,event,arg)
    if event == "event_open_npc_shop" then 
        local frmNpcShopEx = self;
        layWorld_frmNpcShopEx_Show(arg[1],arg[2]);
        frmNpcShopEx:Hide();
        frmNpcShopEx:ShowAndFocus();
    elseif event == "event_open_sale_shop" then
        local frmSaleShopEx = uiGetglobal("layWorld.frmSaleShopEx");
        layWorld_frmSaleShopEx_Show(arg[1],arg[2]);
        frmSaleShopEx:Hide();
        frmSaleShopEx:ShowAndFocus();
    elseif event == "event_pvp_point_update" then
        local jjdshu=uiGetglobal("layWorld.frmNpcShopEx.2103");
        jjdshu:SetText(tostring(arg[1]));
    elseif event =="bag_item_removed" or event =="bag_item_update"  or event =="bag_item_added" or event=="bag_item_exchange_grid" then
         local frmSaleShopEx=uiGetglobal("layWorld.frmSaleShopEx");
         if frmSaleShopEx:getVisible()==true then
             local curpage=frmSaleShopEx:Get("CurPage");
             layWorld_frmSaleShopEx_ShowNpcShop(curpage);
         end
    end
end


-------------------------------------------
---金银铜数值转换
function layWorld_Helper_GoldConvert(total)
	return SAPI.GetMoneyShowStyle(total);
end

function layWorld_Helper_TotalConvert(j,y,t)
    local total;
    if j and y and t then
        total=10000*j+100*y+t;
        return total;
    else 
        return 0;
    end

end

--显示更新金钱信息
function layWorld_frmNpcShopEx_ShowMoney(upmoney,dnmoney,bindmoney,page)    
    local frmNpcShopEx;
    if page==0 then
    frmNpcShopEx=uiGetglobal("layWorld.frmNpcShopEx");
    else 
    frmNpcShopEx=uiGetglobal("layWorld.frmSaleShopEx");
    end

    --up money
    local lbNpcgoldnum = SAPI.GetChild(frmNpcShopEx,"lbNpcgoldnum");
    local lbNpcsilvernum = SAPI.GetChild(frmNpcShopEx,"lbNpcsilvernum");
    local lbNpccoppernum = SAPI.GetChild(frmNpcShopEx,"lbNpccoppernum");
    --dn money
    local goldnum = SAPI.GetChild(frmNpcShopEx,"goldnum");
    local silvernum = SAPI.GetChild(frmNpcShopEx,"silvernum");
    local coppernum = SAPI.GetChild(frmNpcShopEx,"coppernum");
    
    local bindgoldnum = SAPI.GetChild(frmNpcShopEx,"bindgoldnum");
    local bindsilvernum = SAPI.GetChild(frmNpcShopEx,"bindsilvernum");
    local bindcoppernum = SAPI.GetChild(frmNpcShopEx,"bindcoppernum");

    local ilbNpcgoldnum,ilbNpcsilvernum,ilbNpccoppernum = layWorld_Helper_GoldConvert(tonumber(upmoney));
    local igoldnum,isilvernum,icoppernum = layWorld_Helper_GoldConvert(tonumber(dnmoney)); 
    
    local ibindgoldnum,ibindsilvernum,ibindcoppernum = layWorld_Helper_GoldConvert(tonumber(bindmoney)); 
    
    lbNpcgoldnum:SetText(tostring(ilbNpcgoldnum));
    lbNpcsilvernum:SetText(tostring(ilbNpcsilvernum));
    lbNpccoppernum:SetText(tostring(ilbNpccoppernum));
    goldnum:SetText(tostring(igoldnum));
    silvernum:SetText(tostring(isilvernum));
    coppernum:SetText(tostring(icoppernum));
    
    bindgoldnum:SetText(tostring(ibindgoldnum));
    bindsilvernum:SetText(tostring(ibindsilvernum));
    bindcoppernum:SetText(tostring(ibindcoppernum));
end

--Update金钱信息
function layWorld_frmNpcShopEx_ModifyMoney(shopitemmoney,bbuy,page)
    local frmNpcShopEx;
    if page==0 then
        frmNpcShopEx=uiGetglobal("layWorld.frmNpcShopEx");
    else
        frmNpcShopEx=uiGetglobal("layWorld.frmSaleShopEx");
    end

    local SpentMoney;
    local UsrMoney;
    local BindMoney;
    
    SpentMoney=frmNpcShopEx:Get("SpentMoney");
    UsrMoney=frmNpcShopEx:Get("UsrMoney");
    BindMoney=frmNpcShopEx:Get("BindMoney");
   
    if page==0 then
        if bbuy == true then    
            SpentMoney=SpentMoney+shopitemmoney;
            --UsrMoney=UsrMoney-shopitemmoney;
        else
            SpentMoney=SpentMoney-shopitemmoney;
            --UsrMoney=UsrMoney+shopitemmoney;
        end

        local usrMoneyReal,usrBindMoneyReal=uiGetMyInfo("Money");
        
        BindMoney=usrBindMoneyReal-SpentMoney;
        
        if BindMoney<0 then
            UsrMoney=usrMoneyReal+BindMoney;
        else
            UsrMoney=usrMoneyReal;
        end
        
        

    else
        if bbuy == true then    
            SpentMoney=SpentMoney+shopitemmoney;
            UsrMoney=UsrMoney+shopitemmoney;
        else
            SpentMoney=SpentMoney-shopitemmoney;
            UsrMoney=UsrMoney-shopitemmoney;
        end
    end
	
	if UsrMoney < 0 then UsrMoney = 0 end
	if BindMoney < 0 then BindMoney = 0 end
  

    frmNpcShopEx:Set("SpentMoney",SpentMoney);
    frmNpcShopEx:Set("UsrMoney",UsrMoney);
    frmNpcShopEx:Set("BindMoney",BindMoney);
    return frmNpcShopEx:Get("SpentMoney"),frmNpcShopEx:Get("UsrMoney"),frmNpcShopEx:Get("BindMoney");

end

--确定买入按钮
function layWorld_frmNpcShopEx_btBuy(self)    
    local bBuyOK;
    local frmNpcShopEx = uiGetglobal("layWorld.frmNpcShopEx");
    local NpcObjectId=frmNpcShopEx:Get("NpcObjectId");
    bBuyOK = uiBusinessBuy(NpcObjectId);
    if bBuyOK ==true then
        frmNpcShopEx:Hide();                
    end
end

function layWorld_frmNpcShopEx_btCancel(self)    
     local frmNpcShopEx = uiGetglobal("layWorld.frmNpcShopEx");
     frmNpcShopEx:Hide();
end

function layWorld_frmNpcShopEx_btnPage_OnLClick(self,index)
    local frmNpcShopEx = uiGetglobal("layWorld.frmNpcShopEx");  
    local page = tonumber(frmNpcShopEx:Get("Page"));
    local curpage = tonumber(frmNpcShopEx:Get("CurPage"));
    local labPage = SAPI.GetChild(frmNpcShopEx,"labPage");
    if index ==0 then
    curpage=curpage-1; --往前翻页
    else
    curpage=curpage+1; --往后翻页
    end

    if curpage>page then
    curpage=page;
    end
    if curpage<=0 then
    curpage=1;
    end
    frmNpcShopEx:Set("CurPage",curpage);
    labPage:SetText(curpage.."/"..tostring(page));
    layWorld_frmNpcShopEx_ShowNpcShop(curpage);
end

function layWorld_frmNpcShopEx_ShowNpcShop(currentpage)
    local frmNpcShopEx=uiGetglobal("layWorld.frmNpcShopEx");
    local bAutoSort;   
    local iShopCount=0;
    local index=1;
    local bNotAutoSortShow;
    local normal_Item_count = tonumber(frmNpcShopEx:Get("normal_Item_count"));
    local limit_Item_count  = tonumber(frmNpcShopEx:Get("limit_Item_count"));
    local count_x = tonumber(frmNpcShopEx:Get("Col"));--列数
    local count_y = tonumber(frmNpcShopEx:Get("Line"));--行数
    local Total = tonumber(tonumber(count_x)*tonumber(count_y));
  
    while index<=Total do          
        local button=uiGetglobal("layWorld.frmNpcShopEx.btnCustom"..(index));
        local dx=math.mod((index-1),count_x);
        local dy=math.floor((index-1)/count_x);

        button:SetNormalImage("");
        button:SetUltraTextNormal("");
        button:SetUltraTextShortcut("");
        button:Set("COUNT",-1);
        button:Set("PRICE",0);
        button:Set("NUMBER",-1);
        button:Set("LEFTNUMBER",-1);
        button:Set("TYPE","");
        button:Delete(EV_UI_SHORTCUT_OBJECTID_KEY);
        button:ModifyFlag("DragOut_MouseMove",false);

        local ishopindex=iShopCount+1;

        if NNpcShopExInfo[currentpage][ishopindex] then

            local n_info_TableID=NNpcShopExInfo[currentpage][ishopindex].TableID;
            local n_info_Line = NNpcShopExInfo[currentpage][ishopindex].Line;
            local n_info_Col = NNpcShopExInfo[currentpage][ishopindex].Col;
            local n_info_Price = NNpcShopExInfo[currentpage][ishopindex].Price;
            local n_info_RealCount=NNpcShopExInfo[currentpage][ishopindex].RealCount;
            local n_info_RealType =NNpcShopExInfo[currentpage][ishopindex].RealType;
            local n_info_Limit_Count=nil;            
            if n_info_RealType == "Limit" then
               n_info_Limit_Count=NNpcShopExInfo[currentpage][ishopindex].Count;                         
            end


            --n_info_Col = math.floor(math.mod(n_info_Col-1,count_x)+1);
            n_info_Line =  math.floor(math.mod(n_info_Line-1,count_y)+1);

            if n_info_Line~=0 and n_info_Col~=0 then
                --按照要求排列
                bAutoSort=true;
                if  n_info_Col== dx+1 and n_info_Line == dy+1 then
                    bNotAutoSortShow=true;
                else
                    bNotAutoSortShow=false;
                end
            else
                bAutoSort=false;
            end
            if bAutoSort==false or bAutoSort==true and bNotAutoSortShow==true then
                 local n_table=uiItemGetItemClassInfoByTableIndex(n_info_TableID);   
                 
                 if n_table~=nil then  
                      button:Set(EV_UI_SHORTCUT_OBJECTID_KEY,n_info_TableID);
                      button:Set("PRICE",tonumber(n_info_Price));
                      button:Set("COUNT",tonumber(n_info_RealCount));       
                      button:Set("TYPE",tostring(n_info_RealType));
                      button:Set("NUMBER",-1);
                      button:Set("LEFTNUMBER",-1);

                      button:ModifyFlag("DragOut_MouseMove",true);
                     

                      button:SetNormalImage(SAPI.GetImage(n_table.Icon));
                     if  n_table.InitCount and n_table.InitCount>0 then 
                         button:SetUltraTextNormal(tostring(n_table.InitCount));
                         button:Set("NUMBER",n_table.InitCount);
                     end
                     if n_info_RealType == "Limit" then 
                         button:SetUltraTextShortcut(tostring(n_info_Limit_Count));
                         button:Set("LEFTNUMBER",tonumber(n_info_Limit_Count));
                     end
                 end
                iShopCount=iShopCount+1;  
                
            end
        end --if NNpcShopExInfo[ishopindex] then
        index=index+1;       
    end    
end

function layWorld_frmNpcShopEx_OnUpdate(self,delta)
    local iCount=self:Get("TimeCount")+delta;
    local count_x = tonumber(self:Get("Col"));--列数
    local count_y = tonumber(self:Get("Line"));--行数
    local Total = tonumber(tonumber(count_x)*tonumber(count_y));
    local NpcId=self:Get("NpcId");
    local NpcObjectId=self:Get("NpcObjectId");

    if iCount>1000 and NpcId and NpcObjectId then 
    --do something
        self:Set("TimeCount",0);
        for idx=1,Total,1 do
            local btnCustom = uiGetglobal("layWorld.frmNpcShopEx.btnCustom"..idx); 
            if btnCustom:Get("TYPE")=="Limit" then
                --获得当前persent                
                local COUNT=btnCustom:Get("COUNT");
                if COUNT ~=-1 then
                    local temp=uiBusinessGetItemInfo(NpcId,NpcObjectId,EV_NPC_SHOP_ITEM_LIMIT,COUNT);
                    local IntervalTime=temp.LimitItemList.IntervalTime;
                    local Time = temp.LimitItemList.Time;
                    local LEFTNUMBER = temp.LimitItemList.Count;
                    if temp.LimitItemList.Count~=temp.LimitItemList.MaxCount then
                        btnCustom:SetMaskValue(1-Time / IntervalTime);
                    else
                        btnCustom:SetMaskValue(0);
                    end
                    btnCustom:SetUltraTextShortcut(tostring(LEFTNUMBER));
                end
            else
                btnCustom:SetMaskValue(0);
                btnCustom:SetUltraTextShortcut("");
            end
        end        
    else
        self:Set("TimeCount",iCount);
    end
	
	local d = self:Get(EV_UI_DELTA);
	if d == nil then d = 0 end -- init  the value of EV_UI_DELTA
	d = d + delta;
	if d < 1000 then self:Set(EV_UI_DELTA, d) return end
	self:Delete(EV_UI_DELTA);
	-- 每秒检查一次与NPC之间的距离
	local bInside = uiBusinessCheckBuyDistance();
	if bInside == false then
		self:Hide();
	end
end

function layWorld_frmNpcShopEx_OnShow(self)
	uiRegisterEscWidget(self);
--排Button 位置
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
   
    local page = tonumber(self:Get("Page"));
    local curpage = tonumber(self:Get("CurPage"));

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
    --还未处理商店里面物品超过24个的情况
    --这个是需要点击分页按钮实现
    local labPage = SAPI.GetChild(self,"labPage");
    labPage:SetText(tostring(curpage).."/"..tostring(page));
    self:Set("DCount",0);
    if dTotal<30 then
        for idx=1,dTotal,1 do
            local dbutton = SAPI.GetChild(self,"btnCustom_D"..idx);
            local dx=math.mod((idx-1),dcount_x);
            local dy=math.floor((idx-1)/dcount_x);
            dbutton:ModifyFlag("DragOut_MouseMove", false);
            dbutton:ModifyFlag("DragOut_LeftButton", false);
            dbutton:ModifyFlag("DragOut_RightButton", false);
            dbutton:Set(EV_UI_SHORTCUT_OWNER_KEY,EV_UI_SHORTCUT_OWNER_NPC_SHOP_BUY_SHOP);


            dbutton:MoveTo(dlocation_x+dx*dWidth+doffset_x,dlocation_y+dy*dHeight+doffset_y); 
            dbutton:SetNormalImage("");
            dbutton:SetUltraTextNormal("");
            dbutton:SetUltraTextShortcut("");
            dbutton:Set("COUNT",-1);
            drWidth=doffset_xx-doffset_x+1;
            drHeight=doffset_yy-doffset_y+1;
            dbutton:SetSize(drWidth,drHeight);
            dbutton:Show();
        end
    end    

    if Total<30 then --安全判断
       ---Total为当页最大显示数量       
       
        for idx=1,Total,1 do
            local button= SAPI.GetChild(self,"btnCustom"..idx);           
            local dx=math.mod((idx-1),count_x);
            local dy=math.floor((idx-1)/count_x);
            button:ModifyFlag("DragOut_MouseMove", false);
            button:ModifyFlag("DragOut_LeftButton", false);
            button:ModifyFlag("DragOut_RightButton", false);
            button:Set(EV_UI_SHORTCUT_OWNER_KEY,EV_UI_SHORTCUT_OWNER_NPC_SHOP_BUY_SELF);

            button:MoveTo(location_x+dx*Width+offset_x,location_y+dy*Height+offset_y); 
            button:SetNormalImage("");
            button:SetUltraTextNormal("");
            button:SetUltraTextShortcut("");
            button:Set("COUNT",-1);
            rWidth=offset_xx-offset_x+1;
            rHeight=offset_yy-offset_y+1;
            button:SetSize(rWidth,rHeight);
            button:Show();
            --需要处理多页情况
        end
        layWorld_frmNpcShopEx_ShowNpcShop(curpage);           
    end    
end



function layWorld_frmNpcShopEx_Show(NpcId,NpcObjectId)
    local frmNpcShopEx=uiGetglobal("layWorld.frmNpcShopEx");
    local usrMoney,usrBindMoney=uiGetMyInfo("Money");

    frmNpcShopEx:Set("SpentMoney",0);
    frmNpcShopEx:Set("UsrMoney",tonumber(usrMoney));
    frmNpcShopEx:Set("BindMoney",tonumber(usrBindMoney));
    layWorld_frmNpcShopEx_ShowMoney(frmNpcShopEx:Get("SpentMoney"),frmNpcShopEx:Get("UsrMoney"),frmNpcShopEx:Get("BindMoney"),0);
    
    if NpcId ~= nil and NpcObjectId ~= nil then
        local shopinfo=uiBusinessGetNpcShopInfo(NpcId,NpcObjectId);       
        if shopinfo~=nil then
            local normal_Item_count=shopinfo.ItemCount.NormalItem;
            local limit_Item_count=shopinfo.ItemCount.LimitItem;

            local jjdshu=uiGetglobal("layWorld.frmNpcShopEx.2103");            
            jjdshu:SetText(tostring(shopinfo.PvpPoint));

            frmNpcShopEx:Set("normal_Item_count",normal_Item_count);
            frmNpcShopEx:Set("limit_Item_count",limit_Item_count);

            frmNpcShopEx:Set("Left",shopinfo.ItemSlot.Shop.Left);
            frmNpcShopEx:Set("Top",shopinfo.ItemSlot.Shop.Top);
            frmNpcShopEx:Set("Right",shopinfo.ItemSlot.Shop.Right);
            frmNpcShopEx:Set("Bottom",shopinfo.ItemSlot.Shop.Bottom);
            frmNpcShopEx:Set("OffsetLeft",shopinfo.ItemSlot.Shop.OffsetLeft);
            frmNpcShopEx:Set("OffsetTop",shopinfo.ItemSlot.Shop.OffsetTop);
            frmNpcShopEx:Set("OffsetRight",shopinfo.ItemSlot.Shop.OffsetRight);
            frmNpcShopEx:Set("OffsetBottom",shopinfo.ItemSlot.Shop.OffsetBottom);
            frmNpcShopEx:Set("Width",shopinfo.ItemSlot.Shop.Width);
            frmNpcShopEx:Set("Height",shopinfo.ItemSlot.Shop.Height);
            frmNpcShopEx:Set("Line",shopinfo.ItemSlot.Shop.Line);
            frmNpcShopEx:Set("Col",shopinfo.ItemSlot.Shop.Col);
            frmNpcShopEx:Set("Page",shopinfo.ItemSlot.Shop.Page);
            frmNpcShopEx:Set("CurPage",1);

            frmNpcShopEx:Set("DLeft",shopinfo.ItemSlot.Buyer.Left);
            frmNpcShopEx:Set("DTop",shopinfo.ItemSlot.Buyer.Top);
            frmNpcShopEx:Set("DRight",shopinfo.ItemSlot.Buyer.Right);
            frmNpcShopEx:Set("DBottom",shopinfo.ItemSlot.Buyer.Bottom);
            frmNpcShopEx:Set("DOffsetLeft",shopinfo.ItemSlot.Buyer.OffsetLeft);
            frmNpcShopEx:Set("DOffsetTop",shopinfo.ItemSlot.Buyer.OffsetTop);
            frmNpcShopEx:Set("DOffsetRight",shopinfo.ItemSlot.Buyer.OffsetRight);
            frmNpcShopEx:Set("DOffsetBottom",shopinfo.ItemSlot.Buyer.OffsetBottom);
            frmNpcShopEx:Set("DWidth",shopinfo.ItemSlot.Buyer.Width);
            frmNpcShopEx:Set("DHeight",shopinfo.ItemSlot.Buyer.Height);
            frmNpcShopEx:Set("DLine",shopinfo.ItemSlot.Buyer.Line);
            frmNpcShopEx:Set("DCol",shopinfo.ItemSlot.Buyer.Col);
            frmNpcShopEx:Set("DPage",shopinfo.ItemSlot.Buyer.Page);

            frmNpcShopEx:Set("NpcId",NpcId);
            frmNpcShopEx:Set("NpcObjectId",NpcObjectId);

            local pagecount=1;
            local pageindex=1;
            local prepagecount=1;
            local count_x = tonumber(frmNpcShopEx:Get("Col"));--列数
            local count_y = tonumber(frmNpcShopEx:Get("Line"));--行数
            local Total = tonumber(tonumber(count_x)*tonumber(count_y));

           NNpcShopExInfo[1]={};
           NNpcShopExInfo[2]={};
           NNpcShopExInfo[3]={};
           
            for n_Item=0 , normal_Item_count-1 ,1 do
                   local temp={};                 
                   temp=uiBusinessGetItemInfo(NpcId,NpcObjectId,EV_NPC_SHOP_ITEM_NORMAL,n_Item);                                  
                   if temp.NormalItemList.Line == 0 then
                       if n_Item+1>(Total*pagecount) then
                           pagecount=pagecount+1;
                           pageindex=1;
                       end
                   else                      
                       --按照给定坐标排位置
                       pagecount=math.floor((temp.NormalItemList.Line-1)/count_y)+1;
                       if pagecount ~= prepagecount  then
                           pageindex=1;
                       end
                       prepagecount=pagecount;
                       
                   end
                   NNpcShopExInfo[pagecount][pageindex]=temp.NormalItemList;
                   NNpcShopExInfo[pagecount][pageindex].RealCount=n_Item;
                   NNpcShopExInfo[pagecount][pageindex].RealType = "Normal";
                   pageindex=pageindex+1; 
            end

            for l_Item=normal_Item_count,  normal_Item_count+limit_Item_count-1 ,1 do
                  local temp={};
                  temp=uiBusinessGetItemInfo(NpcId,NpcObjectId,EV_NPC_SHOP_ITEM_LIMIT,l_Item-normal_Item_count);

                  if temp.LimitItemList.Line == 0 then
                       if l_Item+1>(Total*pagecount) then
                           pagecount=pagecount+1;
                           pageindex=1;
                       end                  
                  else
                      pagecount=math.floor((temp.LimitItemList.Line-1)/count_y)+1;
                      if pagecount ~= prepagecount  then
                           pageindex=1;
                       end
                      prepagecount=pagecount;
                  end
                  NNpcShopExInfo[pagecount][pageindex]=temp.LimitItemList;
                  NNpcShopExInfo[pagecount][pageindex].RealCount=l_Item-normal_Item_count;
                  NNpcShopExInfo[pagecount][pageindex].RealType="Limit";
                  pageindex=pageindex+1;   

                  -- LNpcShopExInfo[l_Item+1]=uiBusinessGetItemInfo(NpcId,NpcObjectId,EV_NPC_SHOP_ITEM_LIMIT,l_Item);
            end
        end
    end
end


function layWorld_frmNpcShopEx_btnCustom_OnHint(self,index)
    local frmNpcShopEx =  uiGetglobal("layWorld.frmNpcShopEx");
    local NpcId=frmNpcShopEx:Get("NpcId");
    local NpcObjectId=frmNpcShopEx:Get("NpcObjectId");
    local COUNT = self:Get("COUNT");
    if NpcId and NpcObjectId and COUNT~= -1 then  
        local shoptype=self:Get("TYPE");
        local ShopHint;
        if shoptype =="Normal" then
            ShopHint=uiBusinessGetShopItemHint(NpcId,NpcObjectId,EV_NPC_SHOP_ITEM_NORMAL,COUNT);
        elseif shoptype=="Limit" then
            ShopHint=uiBusinessGetShopItemHint(NpcId,NpcObjectId,EV_NPC_SHOP_ITEM_LIMIT,COUNT);
        end       
        self:SetHintRichText(ShopHint);
    else
        self:SetHintRichText(0);
    end


end


--下面按钮的OnHint
function layWorld_frmNpcShopEx_btnCustom_D_OnHint(self,index)
    local frmNpcShopEx =  uiGetglobal("layWorld.frmNpcShopEx");
    local NpcId=frmNpcShopEx:Get("NpcId");
    local NpcObjectId=frmNpcShopEx:Get("NpcObjectId");
    local COUNT = self:Get("COUNT");
    
    if NpcId and NpcObjectId and COUNT~= -1 then
        local shoptype=self:Get("TYPE");
        local ShopHint;
        if shoptype =="Normal" then
            ShopHint=uiBusinessGetShopItemHint(NpcId,NpcObjectId,EV_NPC_SHOP_ITEM_NORMAL,COUNT);
        elseif shoptype=="Limit" then
            ShopHint=uiBusinessGetShopItemHint(NpcId,NpcObjectId,EV_NPC_SHOP_ITEM_LIMIT,COUNT);
        end
        self:SetHintRichText(ShopHint);
    else
        self:SetHintRichText(0);
    end
end

function layWorld_frmNpcShopEx_btnCustom_OnRClick(self,mouse_x,mouse_y,index)
    layWorld_frmNpcShopEx_btnCustom_OnLClick(self,mouse_x,mouse_y,index);
end

function layWorld_frmNpcShopEx_btnCustom_OnDragOut(self,index)
    local frmNpcShopEx = uiGetglobal("layWorld.frmNpcShopEx");
    frmNpcShopEx:Set("DRAGOUTID",index);
end

function layWorld_frmNpcShopEx_btnCustom_D_OnDragOut(self,index)
    local frmNpcShopEx = uiGetglobal("layWorld.frmNpcShopEx");
    frmNpcShopEx:Set("DRAGOUT_DID",index);
end

function layWorld_frmNpcShopEx_btnCustom_D_OnDragIn(self,drag,index)
    local frmNpcShopEx = uiGetglobal("layWorld.frmNpcShopEx");
    local pdrag = uiGetglobal(drag);
    local dragObjectid = pdrag:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
    local DRAGOUTID= frmNpcShopEx:Get("DRAGOUTID");
    local btnCustom=uiGetglobal("layWorld.frmNpcShopEx.btnCustom"..tostring(DRAGOUTID));
    local owner = pdrag:Get(EV_UI_SHORTCUT_OWNER_KEY);
    if  owner == EV_UI_SHORTCUT_OWNER_NPC_SHOP_BUY_SELF then
        if dragObjectid ~= nil then 
            frmNpcShopEx:Delete("DRAGOUTID");
            layWorld_frmNpcShopEx_btnCustom_OnLClick(btnCustom,0,0,tonumber(DRAGOUTID));
        end
    end
end

function layWorld_frmNpcShopEx_btnCustom_OnDragIn(self,drag,index)
    local frmNpcShopEx = uiGetglobal("layWorld.frmNpcShopEx");
    local pdrag = uiGetglobal(drag);
    local dragObjectid = pdrag:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
    local DRAGOUT_DID= frmNpcShopEx:Get("DRAGOUT_DID");

    
    local btnCustom=uiGetglobal("layWorld.frmNpcShopEx.btnCustom_D"..tostring(DRAGOUT_DID));

    local owner = pdrag:Get(EV_UI_SHORTCUT_OWNER_KEY);
    if  owner == EV_UI_SHORTCUT_OWNER_NPC_SHOP_BUY_SHOP then
        if dragObjectid ~= nil then 
            frmNpcShopEx:Delete("DRAGOUT_DID");
            layWorld_frmNpcShopEx_btnCustom_D_OnLClick(btnCustom,0,0,tonumber(DRAGOUT_DID));            
        end
    end

end

function layWorld_frmNpcShopEx_btnCustom_OnLClick(self,mouse_x,mouse_y,index)       
    local frmNpcShopEx =  uiGetglobal("layWorld.frmNpcShopEx");
    local NpcId=frmNpcShopEx:Get("NpcId");
    local NpcObjectId=frmNpcShopEx:Get("NpcObjectId");
    local COUNT = self:Get("COUNT");    --商品在上面的序号
    local TYPE = self:Get("TYPE");
    local bPut;
    if NpcId and NpcObjectId and COUNT~= -1 then
        if TYPE =="Normal" then
            bPut=uiBusinessAddBuyItem(NpcId,NpcObjectId,EV_NPC_SHOP_ITEM_NORMAL,COUNT);
        elseif TYPE=="Limit" then
            bPut=uiBusinessAddBuyItem(NpcId,NpcObjectId,EV_NPC_SHOP_ITEM_LIMIT,COUNT);
        end
        if bPut then 
            local DCount=frmNpcShopEx:Get("DCount"); --在下面的序号
            local btnCustom_D = uiGetglobal("layWorld.frmNpcShopEx.btnCustom_D"..DCount+1);
            local btnCustom_D_next = uiGetglobal("layWorld.frmNpcShopEx.btnCustom_D"..DCount+2);

            --计算价格变化
            local PRICE = self:Get("PRICE");
            local SpendMoney,UsrMoney,BindMoney=layWorld_frmNpcShopEx_ModifyMoney(PRICE,true,0);
            layWorld_frmNpcShopEx_ShowMoney(SpendMoney,UsrMoney,BindMoney,0);

            --UI表现
            frmNpcShopEx:Set("DCount",DCount+1); --自动++
            btnCustom_D:SetNormalImage(self:getNormalImage());
            btnCustom_D:Set("COUNT",COUNT); --init -1??? --下面的在上面的序号
            btnCustom_D:Set("PRICE",PRICE);
            btnCustom_D:Set("TYPE",TYPE);
            local NUMBER=self:Get("NUMBER"); --数量
            local LEFTNUMBER=self:Get("LEFTNUMBER");
            btnCustom_D:Set("NUMBER",NUMBER);
            btnCustom_D:Set("LEFTNUMBER",LEFTNUMBER);

            btnCustom_D:ModifyFlag("DragOut_MouseMove", true);

            btnCustom_D:Set(EV_UI_SHORTCUT_OBJECTID_KEY,tostring(self));

            if NUMBER and NUMBER~=-1 then
                btnCustom_D:SetUltraTextNormal(tostring(NUMBER)); 
            else 
                btnCustom_D:SetUltraTextNormal(""); 
            end     

           if LEFTNUMBER and LEFTNUMBER~=-1 then
                btnCustom_D:SetUltraTextShortcut(tostring(LEFTNUMBER)); 
            else 
                btnCustom_D:SetUltraTextShortcut(""); 
            end             
            btnCustom_D_next:SetNormalImage("");
            btnCustom_D_next:Set("COUNT",-1);
            btnCustom_D_next:Set("NUMBER",-1);
            btnCustom_D_next:Set("LEFTNUMBER",-1);
            btnCustom_D_next:Set("PRICE",0);
            btnCustom_D_next:Set("TYPE","");
            btnCustom_D_next:Delete(EV_UI_SHORTCUT_OBJECTID_KEY);
            btnCustom_D_next:ModifyFlag("DragOut_MouseMove", false);

        end
        
    end
    
end

-----------------------------------------------
-- 点击取消 不购买
function layWorld_frmNpcShopEx_btnCustom_D_OnLClick(self,mouse_x,mouse_y,index)
    local frmNpcShopEx = uiGetglobal("layWorld.frmNpcShopEx");
    local NpcId = frmNpcShopEx:Get("NpcId");
    local NpcObjectId = frmNpcShopEx:Get("NpcObjectId"); 
    local DCount = frmNpcShopEx:Get("DCount");  --下面目前总数
    if DCount and index<=DCount and NpcId and NpcObjectId then 
        local RemoveRes=uiBusinessRemoveBuyItem(NpcId,NpcObjectId,index-1);
        if RemoveRes==true then
        --移走成功
            --计算价格变化
            local PRICE = self:Get("PRICE");
            local SpendMoney,UsrMoney,BindMoney=layWorld_frmNpcShopEx_ModifyMoney(PRICE,false,0);
            layWorld_frmNpcShopEx_ShowMoney(SpendMoney,UsrMoney,BindMoney,0);
            frmNpcShopEx:Set("DCount",DCount-1);
            --往前平移
            for idx = index ,DCount,1 do
                local btnCustom_D = uiGetglobal("layWorld.frmNpcShopEx.btnCustom_D"..idx);
                local btnCustom_D_next = uiGetglobal("layWorld.frmNpcShopEx.btnCustom_D"..idx+1);
                btnCustom_D:Set(EV_UI_SHORTCUT_OBJECTID_KEY,tostring(self));
                btnCustom_D:SetNormalImage(btnCustom_D_next:getNormalImage());

                btnCustom_D:Set("PRICE",btnCustom_D_next:Get("PRICE"));
                btnCustom_D:Set("COUNT",btnCustom_D_next:Get("COUNT")); --init -1??? --下面的在上面的序号
                local NUMBER=btnCustom_D_next:Get("NUMBER"); --数量
                btnCustom_D:Set("NUMBER",NUMBER);
                local LEFTNUMBER=btnCustom_D_next:Get("LEFTNUMBER");
                btnCustom_D:Set("LEFTNUMBER",LEFTNUMBER);

                btnCustom_D:ModifyFlag("DragOut_MouseMove", true);

                if NUMBER and NUMBER~=-1 then
                    btnCustom_D:SetUltraTextNormal(tostring(NUMBER));
                else 
                    btnCustom_D:SetUltraTextNormal("");
                end
                if LEFTNUMBER and LEFTNUMBER~=-1 then
                    btnCustom_D:SetUltraTextShortcut(tostring(LEFTNUMBER));
                else
                    btnCustom_D:SetUltraTextShortcut("");
                end
            end
            --清空最后一个
            local btnCustom_D_last=uiGetglobal("layWorld.frmNpcShopEx.btnCustom_D"..DCount);
            btnCustom_D_last:SetNormalImage("");
            btnCustom_D_last:Set("COUNT",-1);
            btnCustom_D_last:Set("NUMBER",-1);
            btnCustom_D_last:Set("PRICE",0);
            btnCustom_D_last:SetUltraTextNormal("");
            btnCustom_D_last:SetUltraTextShortcut("");
            btnCustom_D_last:SetHintRichText(0);
            btnCustom_D_last:Delete(EV_UI_SHORTCUT_OBJECTID_KEY);
            btnCustom_D_last:ModifyFlag("DragOut_MouseMove", false);

        end
       
    end 

end

function layWorld_frmNpcShopEx_btnCustom_D_OnRClick(self,mouse_x,mouse_y,index)
    layWorld_frmNpcShopEx_btnCustom_D_OnLClick(self,mouse_x,mouse_y,index);
end


---------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
--frmSaleShopEx
----------------------------------------------------------------------
function layWorld_frmSaleShopEx_btnPage_OnLClick(self,index)
    local frmSaleShopEx = uiGetglobal("layWorld.frmSaleShopEx");  
    local page = tonumber(frmSaleShopEx:Get("Page"));
    local curpage = tonumber(frmSaleShopEx:Get("CurPage"));
    local labPage = SAPI.GetChild(frmSaleShopEx,"labPage");
    if index ==0 then
    curpage=curpage-1; --往前翻页
    else
    curpage=curpage+1; --往后翻页
    end

    if curpage>page then
    curpage=page;
    end
    if curpage<=0 then
    curpage=1;
    end
    frmSaleShopEx:Set("CurPage",curpage);
    labPage:SetText(curpage.."/"..tostring(page));

    layWorld_frmSaleShopEx_ShowNpcShop(curpage);
end

function layWorld_frmSaleShopEx_Show(NpcId,NpcObjectId)
    local frmSaleShopEx = uiGetglobal("layWorld.frmSaleShopEx");
    local usrMoney,usrBindMoney=uiGetMyInfo("Money");
    frmSaleShopEx:Set("SpentMoney",0);
    frmSaleShopEx:Set("UsrMoney",tonumber(usrMoney));
    frmSaleShopEx:Set("BindMoney",tonumber(usrBindMoney));
    layWorld_frmNpcShopEx_ShowMoney(frmSaleShopEx:Get("SpentMoney"),frmSaleShopEx:Get("UsrMoney"),frmSaleShopEx:Get("BindMoney"),1);

    if NpcId ~= nil and NpcObjectId ~= nil then
            local shopinfo=uiBusinessGetNpcShopInfo(NpcId,NpcObjectId);
            if shopinfo~=nil then
                frmSaleShopEx:Set("Left",shopinfo.ItemSlot.SaleSelf.Left);
                frmSaleShopEx:Set("Top",shopinfo.ItemSlot.SaleSelf.Top);
                frmSaleShopEx:Set("Right",shopinfo.ItemSlot.SaleSelf.Right);
                frmSaleShopEx:Set("Bottom",shopinfo.ItemSlot.SaleSelf.Bottom);
                frmSaleShopEx:Set("OffsetLeft",shopinfo.ItemSlot.SaleSelf.OffsetLeft);
                frmSaleShopEx:Set("OffsetTop",shopinfo.ItemSlot.SaleSelf.OffsetTop);
                frmSaleShopEx:Set("OffsetRight",shopinfo.ItemSlot.SaleSelf.OffsetRight);
                frmSaleShopEx:Set("OffsetBottom",shopinfo.ItemSlot.SaleSelf.OffsetBottom);
                frmSaleShopEx:Set("Width",shopinfo.ItemSlot.SaleSelf.Width);
                frmSaleShopEx:Set("Height",shopinfo.ItemSlot.SaleSelf.Height);
                frmSaleShopEx:Set("Line",shopinfo.ItemSlot.SaleSelf.Line);
                frmSaleShopEx:Set("Col",shopinfo.ItemSlot.SaleSelf.Col);
                frmSaleShopEx:Set("Page",shopinfo.ItemSlot.SaleSelf.Page);
                frmSaleShopEx:Set("CurPage",1);
                frmSaleShopEx:Set("DLeft",shopinfo.ItemSlot.Sale.Left);
                frmSaleShopEx:Set("DTop",shopinfo.ItemSlot.Sale.Top);
                frmSaleShopEx:Set("DRight",shopinfo.ItemSlot.Sale.Right);
                frmSaleShopEx:Set("DBottom",shopinfo.ItemSlot.Sale.Bottom);
                frmSaleShopEx:Set("DOffsetLeft",shopinfo.ItemSlot.Sale.OffsetLeft);
                frmSaleShopEx:Set("DOffsetTop",shopinfo.ItemSlot.Sale.OffsetTop);
                frmSaleShopEx:Set("DOffsetRight",shopinfo.ItemSlot.Sale.OffsetRight);
                frmSaleShopEx:Set("DOffsetBottom",shopinfo.ItemSlot.Sale.OffsetBottom);
                frmSaleShopEx:Set("DWidth",shopinfo.ItemSlot.Sale.Width);
                frmSaleShopEx:Set("DHeight",shopinfo.ItemSlot.Sale.Height);
                frmSaleShopEx:Set("DLine",shopinfo.ItemSlot.Sale.Line);
                frmSaleShopEx:Set("DCol",shopinfo.ItemSlot.Sale.Col);
                frmSaleShopEx:Set("DPage",shopinfo.ItemSlot.Sale.Page);

                frmSaleShopEx:Set("NpcId",NpcId);
                frmSaleShopEx:Set("NpcObjectId",NpcObjectId);
                          
                --local count_x=tonumber(frmSaleShopEx:Get("Col"));--列数
                --local count_y = tonumber(frmSaleShopEx:Get("Line"));--行数
                --local Total = tonumber(tonumber(count_x)*tonumber(count_y));
                SaleShopExInfo[1]={};
                SaleShopExInfo[2]={};
                SaleShopExInfo[3]={};              


                --frmSaleShopEx:Set("MAXSELLCOUNT",-1);
                --[[
                if SaleShopExInfo then
                    frmSaleShopEx:Set("MAXSELLCOUNT",table.getn(SaleShopExInfo));             
                end
                --]]
                --end
            end


    end --end NpcId~=nil and ...


end

function layWorld_frmSaleShopEx_ShowNpcShop(currentpage)
         local frmSaleShopEx=uiGetglobal("layWorld.frmSaleShopEx");
         local iShopCount=0;
         local index=1;
         local count_x = tonumber(frmSaleShopEx:Get("Col"));--列数
         local count_y = tonumber(frmSaleShopEx:Get("Line"));--行数
         local Total = tonumber(tonumber(count_x)*tonumber(count_y));
         
        local pagecount=1;
        local pageindex=1;
        local prepagecount=1;      

        local temp=uiBusinessGetCanSaleItems(); --获得所有可卖物品
        local salelist_temp = uiBusinessGetSaleItems();
        --------
        local cansaleList = {};
        local salelist = {};
        for j, item in ipairs(temp) do
			local iFind = SAPI.GetIndexInTable(salelist_temp, item.ObjectId);
			if iFind == 0 then
				table.insert(cansaleList, item);
			else
				salelist[iFind] = item;
				salelist_temp[iFind] = 0;
			end
		end
		salelist = SAPI.SortToArrty(salelist);
		for i, o in ipairs(salelist_temp) do
			if o ~= 0 then
				uiBusinessRemoveSaleItem(o);
			end
        end


        local normal_Item_count=table.getn(cansaleList);
        SaleShopExInfo[1]={};
        SaleShopExInfo[2]={};
        SaleShopExInfo[3]={};
        for n_Item=1 ,normal_Item_count,1 do           
           if n_Item>(Total*pagecount) then
                   pagecount=pagecount+1;
                   pageindex=1;
           end
           SaleShopExInfo[pagecount][pageindex]=cansaleList[n_Item];
           --SaleShopExInfo[pagecount][pageindex].RealCount=n_Item;
           pageindex=pageindex+1;
        end

         local usrMoney,usrBindMoney=uiGetMyInfo("Money");
         frmSaleShopEx:Set("SpentMoney",0);
         frmSaleShopEx:Set("UsrMoney",tonumber(usrMoney));
         layWorld_frmNpcShopEx_ShowMoney(0,usrMoney,usrBindMoney,1);



         while index<=Total do
             local button=uiGetglobal("layWorld.frmSaleShopEx.btnCustom"..(index));
             local dx=math.mod((index-1),count_x);
             local dy=math.floor((index-1)/count_x);
             button:SetNormalImage("");
             button:SetUltraTextNormal("");
             button:SetUltraTextShortcut("");
             button:Set("COUNT",-1);
             button:Set("PRICE",0);
             button:Set("NUMBER",-1);
             button:Delete(EV_UI_SHORTCUT_OBJECTID_KEY);
             local ishopindex=iShopCount+1;
             button:ModifyFlag("DragOut_MouseMove", false);


             if SaleShopExInfo[currentpage][ishopindex] then
                 local n_info_TableID=SaleShopExInfo[currentpage][ishopindex].ObjectId;
                 local n_table=uiItemGetBagItemInfoByObjectId(n_info_TableID);
                 local n_table_id=uiItemGetItemClassInfoByTableIndex(n_table.TableId);
                 if n_table~=nil then                      
                      button:Set(EV_UI_SHORTCUT_OBJECTID_KEY,n_info_TableID);
                      button:Set("PRICE",tonumber(n_info_Price));                           
                      --button:Set("TYPE",tostring(n_info_RealType));
                      button:Set("NUMBER",-1);
                      button:ModifyFlag("DragOut_MouseMove", true);
                      --button:Set("LEFTNUMBER",-1);
                      button:SetNormalImage(SAPI.GetImage(n_table_id.Icon));
                      if  n_table.Count and n_table.Count>0 then 
                         button:SetUltraTextNormal(tostring(n_table.Count));
                         button:Set("NUMBER",n_table.Count);
                     end
                 end
                 iShopCount=iShopCount+1;
              end
              index=index+1;       
                 
         end
         

         local btnCustom=uiGetglobal("layWorld.frmSaleShopEx.btnCustom1");

         
         for DCOUNT=1,24,1 do
             local button=SAPI.GetSibling(btnCustom,"btnCustom_D"..DCOUNT);    
             if salelist[DCOUNT] and salelist[DCOUNT].ObjectId then
                 local dragObjectid =salelist[DCOUNT].ObjectId;--pdrag:Get(EV_UI_SHORTCUT_OBJECTID_KEY);    
                 local usrItem=uiBusinessGetUserItemInfoByObjectId(dragObjectid);
                 local btnTable=uiItemGetItemClassInfoByTableIndex(usrItem.TableId);                        
                --允许放入
                    button:SetNormalImage(SAPI.GetImage(btnTable.Icon));
                    --uiItemFreezeItem(dragObjectid,true);                
                    local tUsrItem=uiBusinessGetUserItemInfoByObjectId(dragObjectid);
                    button:ModifyFlag("DragOut_MouseMove", true);
                    if tUsrItem["Count"]~=nil and tUsrItem["Count"]>0  then
                        --显示数字
                        button:SetUltraTextNormal(tostring(tUsrItem["Count"]));
                    else
                        button:SetUltraTextNormal("");
                    end 
                    
                    local PRICE =tUsrItem.SalePrice;
                              
                    local SpendMoney,UsrMoney,BindMoney=layWorld_frmNpcShopEx_ModifyMoney(PRICE,true,1);
                    layWorld_frmNpcShopEx_ShowMoney(SpendMoney,UsrMoney,BindMoney,1);
                    --]]
                    button:Set("dragObjectid",dragObjectid);
                    button:Set(EV_UI_SHORTCUT_OBJECTID_KEY,dragObjectid);
                    frmSaleShopEx:Set("DCount",DCOUNT);

                          

              else

                  button:SetNormalImage("");
                  button:SetUltraTextNormal("");                 
                  button:SetUltraTextNormal("");
                  button:SetUltraTextShortcut("");
                  button:Set("COUNT",-1);
                  button:Set("PRICE",0);
                  button:Set("NUMBER",-1);
                  button:Delete("dragObjectid");
                  button:SetHintRichText(0);
                  button:ModifyFlag("DragOut_MouseMove", false);


              end
                     
          end
            

         --[[
         local n_info_ObjectId=SaleShopExInfo[iShopCount+1].ObjectId;
         if n_info_ObjectId~=nil then
             local n_info_UsrTable=uiBusinessGetUserItemInfoByObjectId(n_info_ObjectId);
             local n_info_Table=n_info_UsrTable.TableId;
             local n_table=uiItemGetItemClassInfoByTableIndex(n_info_Table);
             if n_table~=nil then
                  button:Set("COUNT",tonumber(iShopCount));
                  button:SetNormalImage(SAPI.GetImage(n_table.Icon));
                 if n_table.InitCount and n_table.InitCount>0 then 
                     button:SetUltraTextNormal(tostring(n_info_UsrTable.Count));
                     button:Set("NUMBER",n_info_UsrTable.Count);
                 else
                     button:Set("NUMBER",-1);
                 end
             end
         end
        iShopCount=iShopCount+1;                 
        else
        --剩余按钮
            button:Show(); 
            --是否隐藏
            --button:Hide();
        end
    end
    --]]
end

function layWorld_frmSaleShopEx_OnShow(self)
	uiRegisterEscWidget(self);
--排上下button位置
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

    local page = tonumber(self:Get("Page"));
    local curpage = tonumber(self:Get("CurPage"));

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
    --local MAXSELLCOUNT = tonumber(self:Get("MAXSELLCOUNT"));
    local rWidth,rHeight;
    local drWidth,drHeight;

    --还未处理商店里面物品超过24个的情况
    --这个是需要点击分页按钮实现
    local labPage = SAPI.GetChild(self,"labPage");
    labPage:SetText(tostring(curpage).."/"..tostring(page));

    self:Set("DCount",0);
    if dTotal<30 then
        for idx=1,dTotal,1 do
            local dbutton = SAPI.GetChild(self,"btnCustom_D"..idx);
            local dx=math.mod((idx-1),dcount_x);
            local dy=math.floor((idx-1)/dcount_x);

            dbutton:ModifyFlag("DragOut_MouseMove", false);
            dbutton:ModifyFlag("DragOut_LeftButton", false);
            dbutton:ModifyFlag("DragOut_RightButton", false);

            dbutton:MoveTo(dlocation_x+dx*dWidth+doffset_x,dlocation_y+dy*dHeight+doffset_y); 

            dbutton:Set(EV_UI_SHORTCUT_OWNER_KEY,EV_UI_SHORTCUT_OWNER_NPC_SHOP_SALE_SHOP);
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
    

    if Total<30 then --安全判断
       ---Total为当页最大显示数量       
        --local iShopCount=0;
        for idx=1,Total,1 do
            local button= SAPI.GetChild(self,"btnCustom"..idx);           
            local dx=math.mod((idx-1),count_x);
            local dy=math.floor((idx-1)/count_x);

            button:ModifyFlag("DragOut_MouseMove", false);
            button:ModifyFlag("DragOut_LeftButton", false);
            button:ModifyFlag("DragOut_RightButton", false);
            button:MoveTo(location_x+dx*Width+offset_x,location_y+dy*Height+offset_y); 
            button:SetNormalImage("");
            button:SetUltraTextNormal("");
            button:Set("COUNT",-1);
            button:Set(EV_UI_SHORTCUT_OWNER_KEY,EV_UI_SHORTCUT_OWNER_NPC_SHOP_SALE_SELF);
            rWidth=offset_xx-offset_x+1;
            rHeight=offset_yy-offset_y+1;
            button:SetSize(rWidth,rHeight);
            --需要处理多页情况            
            --if iShopCount<MAXSELLCOUNT then
            button:Show();
        end
        layWorld_frmSaleShopEx_ShowNpcShop(curpage);       
    end    
end

function layWorld_frmSaleShopEx_btnCustom_OnHint(self,index)
    --上面按钮可以不再显示，下面代码可屏蔽
    local frmSaleShopEx = uiGetglobal("layWorld.frmSaleShopEx");
    local NpcId=frmSaleShopEx:Get("NpcId");  
    local curpage=frmSaleShopEx:Get("CurPage");
    local n_info_TableIDCount=table.getn(SaleShopExInfo[curpage]);

    if index<=n_info_TableIDCount then 
        local n_info_TableID=SaleShopExInfo[curpage][index].ObjectId;         
         if n_info_TableID~= nil and NpcId then
            local sellHint=uiBusinessGetSaleItemHint(n_info_TableID);
            self:SetHintRichText(sellHint);    
         else
            self:SetHintRichText(0);   --wj add  
         end
    else
       self:SetHintRichText(0);     --wj add
    end

end

function layWorld_frmSaleShopEx_btnCustom_D_OnHint(self,index)
    local frmSaleShopEx = uiGetglobal("layWorld.frmSaleShopEx");
    local DCOUNT=frmSaleShopEx:Get("DCount")+1;
    if index<=DCOUNT then
        local objectid=self:Get("dragObjectid");
        if objectid then
            local sellHint=uiBusinessGetSaleItemHint(objectid);
            self:SetHintRichText(sellHint);    
        else 
           self:SetHintRichText(0);  --wj add
        end
    else 
        self:SetHintRichText(0);  --wj add
    end
end

function layWorld_frmSaleShopEx_btnCustom_D_YES(_,dragObjectid)
     local frmSaleShopEx = uiGetglobal("layWorld.frmSaleShopEx");
     local NpcId=frmSaleShopEx:Get("NpcId");  
     local DCOUNT=frmSaleShopEx:Get("DCount")+1;
     local button=uiGetglobal("layWorld.frmSaleShopEx.".."btnCustom_D"..DCOUNT);

    
     local curpage=frmSaleShopEx:Get("CurPage");
     
     local usrItem=uiBusinessGetUserItemInfoByObjectId(dragObjectid);
     local btnTable=uiItemGetItemClassInfoByTableIndex(usrItem.TableId);  
     
     if uiBusinessAddSaleItem(dragObjectid) == true then
        --允许放入          
           
           
           -- button:SetNormalImage(SAPI.GetImage(btnTable.Icon));
           -- uiItemFreezeItem(dragObjectid,true);           

            --显示数目
            local tUsrItem=uiBusinessGetUserItemInfoByObjectId(dragObjectid);
           -- if tUsrItem["Count"]~=nil and tUsrItem["Count"]>0  then
                --显示数字
           --     button:SetUltraTextNormal(tostring(tUsrItem["Count"]));
           -- else
           --     button:SetUltraTextNormal("");
           -- end 

            --local PRICE =tUsrItem.SalePrice;
            --local SpendMoney,UsrMoney=layWorld_frmNpcShopEx_ModifyMoney(PRICE,true,1);
            --layWorld_frmNpcShopEx_ShowMoney(SpendMoney,UsrMoney,1);


            --button:Set("dragObjectid",dragObjectid);

            --frmSaleShopEx:Set("DCount",DCOUNT);

            --]]
            layWorld_frmSaleShopEx_ShowNpcShop(curpage);

      end
end

function layWorld_frmSaleShopEx_btnCustom_D_No(_,Param)

end

function layWorld_frmSaleShopEx_btnCustom_OnDragIn(self, drag,index)
     local frmSaleShopEx = uiGetglobal("layWorld.frmSaleShopEx");
     local button=SAPI.GetSibling(self,"btnCustom"..index);
    local pdrag = uiGetglobal(drag);
    local curpage=frmSaleShopEx:Get("CurPage");
    local dragObjectid = pdrag:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
    local owner = pdrag:Get(EV_UI_SHORTCUT_OWNER_KEY);
    if  owner == EV_UI_SHORTCUT_OWNER_NPC_SHOP_SALE_SHOP then
        if dragObjectid ~= nil then 
           -- local usrItem=uiBusinessGetUserItemInfoByObjectId(dragObjectid);
            --local btnTable=uiItemGetItemClassInfoByTableIndex(usrItem.TableId);         
            --if btnTable and btnTable.Type == EV_ITEM_TYPE_MAINTRUMP then
             --   local msgBox =uiMessageBox(uiLanString("msg_sale_item_conform"),"",true,true,true);
              --  SAPI.AddDefaultMessageBoxCallBack(msgBox,layWorld_frmSaleShopEx_btnCustom_D_YES,layWorld_frmSaleShopEx_btnCustom_D_No,dragObjectid);
              --  return 0;
            --end
            if uiBusinessRemoveSaleItem(dragObjectid) == true then 
             layWorld_frmSaleShopEx_ShowNpcShop(curpage);
           end
       end


    end


end

function layWorld_frmSaleShopEx_btnCustom_D_OnDragIn(self,drag,index)
    local frmSaleShopEx = uiGetglobal("layWorld.frmSaleShopEx");
    local NpcId=frmSaleShopEx:Get("NpcId");  
    local DCOUNT=frmSaleShopEx:Get("DCount")+1;

    local button=SAPI.GetSibling(self,"btnCustom_D"..DCOUNT);
    local pdrag = uiGetglobal(drag);
    local curpage=frmSaleShopEx:Get("CurPage");
    local dragObjectid = pdrag:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
    local owner = pdrag:Get(EV_UI_SHORTCUT_OWNER_KEY);

    if  owner == EV_UI_SHORTCUT_OWNER_NPC_SHOP_SALE_SELF then
        if dragObjectid ~= nil then 
            local usrItem=uiBusinessGetUserItemInfoByObjectId(dragObjectid);
            local btnTable=uiItemGetItemClassInfoByTableIndex(usrItem.TableId);       
            if btnTable and btnTable.Type == EV_ITEM_TYPE_MAINTRUMP then
                local msgBox =uiMessageBox(uiLanString("msg_sale_item_conform"),"",true,true,true);
                SAPI.AddDefaultMessageBoxCallBack(msgBox,layWorld_frmSaleShopEx_btnCustom_D_YES,layWorld_frmSaleShopEx_btnCustom_D_No,dragObjectid);
                return 0;
            end
            if uiBusinessAddSaleItem(dragObjectid) == true then
            --允许放入
                 --local dragObjectidlast=self:Get("CUR_ObjectID");
                 --if dragObjectidlast~=nil then 
                 --uiItemFreezeItem(dragObjectidlast,false);
                 --uiDragNull(self);
                 --end

                --self:SetUltraTextNormal("");
                --self:Set("CUR_ObjectID",dragObjectid);
                --local DragRes=uiDragIn(button, pdrag,false);
               
                --button:SetNormalImage(SAPI.GetImage(btnTable.Icon));
                --uiItemFreezeItem(dragObjectid,true);
                

                --显示数目
                --local tUsrItem=uiBusinessGetUserItemInfoByObjectId(dragObjectid);
                --if tUsrItem["Count"]~=nil and tUsrItem["Count"]>0  then
                    --显示数字
                --   button:SetUltraTextNormal(tostring(tUsrItem["Count"]));
                --else
                --    button:SetUltraTextNormal("");
                --end 

                --local PRICE =tUsrItem.SalePrice;
                --local SpendMoney,UsrMoney=layWorld_frmNpcShopEx_ModifyMoney(PRICE,true,1);
                --layWorld_frmNpcShopEx_ShowMoney(SpendMoney,UsrMoney,1);


                --button:Set("dragObjectid",dragObjectid);
                --frmSaleShopEx:Set("DCount",DCOUNT);
                layWorld_frmSaleShopEx_ShowNpcShop(curpage);
           end
       end


    end


    
   --]]

end


function layWorld_frmSaleShopEx_OnHide(self)
    --解除背包所有咚咚
    local DCOUNT=self:Get("DCount")+1; 
    for idx=1,DCOUNT,1 do
        local button=SAPI.GetChild(self,"btnCustom_D"..idx);
        local dragObjectid=button:Get("dragObjectid");
        if dragObjectid then
            button:SetUltraTextNormal("");
            button:SetNormalImage("");
            --local res=uiItemFreezeItem(dragObjectid,false);
            --uiDragNull(button);
        end
    end
end

function layWorld_frmSaleShopEx_OnUpdate(self, delta)
	local d = self:Get(EV_UI_DELTA);
	if d == nil then d = 0 end -- init  the value of EV_UI_DELTA
	d = d + delta;
	if d < 1000 then self:Set(EV_UI_DELTA, d) return end
	self:Delete(EV_UI_DELTA);
	-- 每秒检查一次与NPC之间的距离
	local bInside = uiBusinessCheckSaleDistance();
	if bInside == false then
		self:Hide();
	end
end

function layWorld_frmSaleShopEx_btnCustom_OnLClick(self,mouse_x,mouse_y,index)
    local frmSaleShopEx = uiGetglobal("layWorld.frmSaleShopEx");
    local NpcId=frmSaleShopEx:Get("NpcId");  
    local DCOUNT=frmSaleShopEx:Get("DCount")+1;
    local n_info_TableIDCount=table.getn(SaleShopExInfo);
    local curpage=frmSaleShopEx:Get("CurPage");
    --[[
    if index<=n_info_TableIDCount then 
        local n_info_TableID=SaleShopExInfo[index].ObjectId;         
        if n_info_TableID~= nil and NpcId then
            local sellHint=uiBusinessGetSaleItemHint(n_info_TableID);
            self:SetHintRichText(sellHint);
        end
    end
    --]]
    local button=SAPI.GetSibling(self,"btnCustom_D"..DCOUNT);
    --local pdrag = uiGetglobal(drag);
    if SaleShopExInfo[curpage][index] then

        local dragObjectid = SaleShopExInfo[curpage][index].ObjectId;--pdrag:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
        if dragObjectid ~= nil then 
            local usrItem=uiBusinessGetUserItemInfoByObjectId(dragObjectid);
            local btnTable=uiItemGetItemClassInfoByTableIndex(usrItem.TableId);     
            if btnTable and btnTable.Type == EV_ITEM_TYPE_MAINTRUMP then
                local msgBox =uiMessageBox(uiLanString("msg_sale_item_conform"),"",true,true,true);
                SAPI.AddDefaultMessageBoxCallBack(msgBox,layWorld_frmSaleShopEx_btnCustom_D_YES,layWorld_frmSaleShopEx_btnCustom_D_No,dragObjectid);
                return 0;
            end
            if uiBusinessAddSaleItem(dragObjectid) == true then
            --允许放入
                
                
                --button:SetNormalImage(SAPI.GetImage(btnTable.Icon));
                --uiItemFreezeItem(dragObjectid,true);
                
                local tUsrItem=uiBusinessGetUserItemInfoByObjectId(dragObjectid);
                --if tUsrItem["Count"]~=nil and tUsrItem["Count"]>0  then
                    --显示数字
                --    button:SetUltraTextNormal(tostring(tUsrItem["Count"]));
                --else
                --    button:SetUltraTextNormal("");
                --end 
               -- local PRICE =tUsrItem.SalePrice;
               -- local SpendMoney,UsrMoney=layWorld_frmNpcShopEx_ModifyMoney(PRICE,true,1);
                --layWorld_frmNpcShopEx_ShowMoney(SpendMoney,UsrMoney,1);
                --button:Set("dragObjectid",dragObjectid);

                --frmSaleShopEx:Set("DCount",DCOUNT);
                --]]
                layWorld_frmSaleShopEx_ShowNpcShop(curpage);
            end 
       end
   end
end

function layWorld_frmSaleShopEx_btnCustom_OnRClick(self,mouse_x,mouse_y,index)
    layWorld_frmSaleShopEx_btnCustom_OnLClick(self,mouse_x,mouse_y,index);
end

-- 点击取消 不卖了
function layWorld_frmSaleShopEx_btnCustom_D_OnLClick(self,mouse_x,mouse_y,index)
    local frmSaleShopEx = uiGetglobal("layWorld.frmSaleShopEx");
    --local NpcId = frmSaleShopEx:Get("NpcId");
    --local NpcObjectId = frmSaleShopEx:Get("NpcObjectId"); 
    local DCount = frmSaleShopEx:Get("DCount");  --下面目前总数
    local curpage=frmSaleShopEx:Get("CurPage");
   
    if DCount and index<=DCount then 
        local button=SAPI.GetSibling(self,"btnCustom_D"..index);
        local dragObjectid = button:Get("dragObjectid");

        if dragObjectid then
                local RemoveRes=uiBusinessRemoveSaleItem(dragObjectid);
                if RemoveRes==true then
                --移走成功
                  --  frmSaleShopEx:Set("DCount",DCount-1);
                    --往前平移
                    for idx = index ,DCount,1 do
                        local btnCustom_D = uiGetglobal("layWorld.frmSaleShopEx.btnCustom_D"..idx);
                        local btnCustom_D_next = uiGetglobal("layWorld.frmSaleShopEx.btnCustom_D"..idx+1);
                       -- local nextImage=btnCustom_D_next:getNormalImage();
                        --local resImage=btnCustom_D:SetNormalImage(nextImage);

                        --if idx == index then                         
                        --    uiItemFreezeItem(btnCustom_D:Get("dragObjectid"),false);    

                            --计算价格变化
                            --local tUsrItem=uiBusinessGetUserItemInfoByObjectId(btnCustom_D:Get("dragObjectid"));
                            --if tUsrItem then
                                --local PRICE =tUsrItem.SalePrice;
                                --local SpendMoney,UsrMoney=layWorld_frmNpcShopEx_ModifyMoney(PRICE,false,1);
                                --layWorld_frmNpcShopEx_ShowMoney(SpendMoney,UsrMoney,1);
                           -- end           

                       --- end   

                        --btnCustom_D:Set("dragObjectid",btnCustom_D_next:Get("dragObjectid"));

                        --local tUsrItem=uiBusinessGetUserItemInfoByObjectId(btnCustom_D:Get("dragObjectid"));
                        --if tUsrItem and tUsrItem["Count"]~=nil and tUsrItem["Count"]>0  then
                            --显示数字
                        --    btnCustom_D:SetUltraTextNormal(tostring(tUsrItem["Count"]));
                        --else
                        --    btnCustom_D:SetUltraTextNormal("");
                        --end                        
                       
                            --btnCustom_D:Set("PRICE",btnCustom_D_next:Get("PRICE"));
                    end
                    --清空最后一个
                    
                    --local btnCustom_D_last=uiGetglobal("layWorld.frmSaleShopEx.btnCustom_D"..DCount);
                    --btnCustom_D_last:SetNormalImage("");
                    --btnCustom_D_last:Set("PRICE",0);
                    --btnCustom_D_last:SetUltraTextNormal("");

                    --]]
                    

                    layWorld_frmSaleShopEx_ShowNpcShop(curpage);
                    
                    

                end
        end --if dragObjectid then
       
    end 

end

function layWorld_frmSaleShopEx_btnCustom_D_OnRClick(self,mouse_x,mouse_y,index)
    layWorld_frmSaleShopEx_btnCustom_D_OnLClick(self,mouse_x,mouse_y,index);
end

--确定卖出按钮
function layWorld_frmSaleShopEx_btSell(self)    
    local bSellOK;
    local frmSaleShopEx = uiGetglobal("layWorld.frmSaleShopEx");
    local NpcObjectId=frmSaleShopEx:Get("NpcObjectId");
    bSellOK = uiBusinessSale(NpcObjectId);   
    if bSellOK ==true then
        frmSaleShopEx:Hide();                
    end
end

function layWorld_frmSaleShopEx_btCancel(self)    
     local frmSaleShopEx = uiGetglobal("layWorld.frmSaleShopEx");
     frmSaleShopEx:Hide();
end

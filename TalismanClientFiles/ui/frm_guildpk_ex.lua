--帮会战UI
--wj

local frmGuildPKEx_DetailName="";
function layWorld_frmGuildPKEx_OnLoad(self)
    --0 :Event_SendCanDeclareGuild
    --1 :Event_RefreshDeclareGuildList
    --2 :Event_GetGuildWarKillRecord
    --3 :Event_GetGuildWarMemberKillRecord    
    self:RegisterScriptEventNotify("RefreshGuildWarData");
   
end

function layWorld_frmGuildPKEx_Refresh0()
   local frmGuildPKEx = uiGetglobal("layWorld.frmGuildPKEx");
   local lbList = SAPI.GetChild(frmGuildPKEx,"lbList");
   --local etPKTime = SAPI.GetChild(lbList,"etPKTime");
   --local lstPKList = SAPI.GetChild(lbList,"lstPKList");
   --local lstRanking = SAPI.GetChild(lbList,"lstRanking");
   local lstApplyPK = SAPI.GetChild(lbList,"lstApplyPK"); 
   local data=uiGuildWar_GetCanDeclareGuildList();

   local num=table.getn(data);

   lstApplyPK:RemoveAllLines(true);   
   local col=4294967295;
   local iCount=0;
   for i=1,num,1 do       
        lstApplyPK:InsertLine(-1,col,-1);
        lstApplyPK:SetLineItem(iCount,0,tostring(data[i]["GuildName"]),col);
        lstApplyPK:SetLineItem(iCount,1,tostring(data[i]["Lev"]),col);             
        lstApplyPK:SetLineItem(iCount,2,tostring(data[i]["LeaderName"]),col);             
        iCount=iCount+1;
   end
   lstApplyPK:SetSelect(0);
end

function layWorld_frmPKDetailedEx_Refresh(guildname)
   local frmPKDetailedEx = uiGetglobal("layWorld.frmPKDetailedEx");
   local lbList = SAPI.GetChild(frmPKDetailedEx,"lbList");  
   local lbGuildName =SAPI.GetChild(frmPKDetailedEx,"lbGuildName");  
   local lsbDetailedPK = SAPI.GetChild(lbList,"lsbDetailedPK");

   if frmPKDetailedEx:getVisible()==false then
       return ;
   end

   if tostring(frmGuildPKEx_DetailName)==tostring(guildname) then  
       lbGuildName:SetText(tostring(guildname));
       local data=uiGuildWar_GetGuildWarMemberKillRecord();


       local num=table.getn(data);

       table.sort(data, function (arg1, arg2) return arg1.KillUserCnt > arg2.KillUserCnt end);

       lsbDetailedPK:RemoveAllLines(true);   
       local col=4294967295;
       local iCount=0;
       for i=1,num,1 do       
            lsbDetailedPK:InsertLine(-1,col,-1);
            lsbDetailedPK:SetLineItem(iCount,0,tostring(data[i]["PlayerName"]),col);
            lsbDetailedPK:SetLineItem(iCount,1,tostring(data[i]["PlayerLev"]),col);      
            local party=data[i]["PlayerParty"];
            local partystr;
            if party==EV_PARTY_EM then
                partystr=uiLanString("party_em");
            elseif party==EV_PARTY_FM then
                partystr=uiLanString("party_fm");
            elseif party==EV_PARTY_QC then
                partystr=uiLanString("party_qc");
            elseif party==EV_PARTY_BH then
                partystr=uiLanString("party_bh");
            elseif party==EV_PARTY_XQ then
                partystr=uiLanString("party_xq");
            end

            lsbDetailedPK:SetLineItem(iCount,2,tostring(partystr),col);             
            lsbDetailedPK:SetLineItem(iCount,3,tostring(data[i]["KillUserCnt"]),col);             
            lsbDetailedPK:SetLineItem(iCount,4,tostring(data[i]["BeKilledUserCnt"]),col);             
            iCount=iCount+1;
       end
       lsbDetailedPK:SetSelect(-1);
   end
end

function layWorld_frmGuildPKEx_Refresh1()
   local frmGuildPKEx = uiGetglobal("layWorld.frmGuildPKEx");
   local lbList = SAPI.GetChild(frmGuildPKEx,"lbList");
   --local etPKTime = SAPI.GetChild(lbList,"etPKTime");
   local lstPKList = SAPI.GetChild(lbList,"lstPKList");
   --local lstRanking = SAPI.GetChild(lbList,"lstRanking");
   --local lstApplyPK = SAPI.GetChild(lbList,"lstApplyPK"); 
   local data=uiGuildWar_GetDeclareGuildList();

   local num=table.getn(data);

   table.sort(data, function (arg1, arg2) return arg1.DeclareTime < arg2.DeclareTime end);

   lstPKList:RemoveAllLines(true);   
   local col=4294967295;
   local iCount=0;
   for i=1,num,1 do       
        lstPKList:InsertLine(-1,col,-1);
        lstPKList:SetLineItem(iCount,0,tostring(data[i]["GuildName"]),col);
        lstPKList:SetLineItem(iCount,1,tostring(data[i]["GuildLev"]),col);             
        lstPKList:SetLineItem(iCount,2,tostring(data[i]["DeclareGuildName"]),col);             
        lstPKList:SetLineItem(iCount,3,tostring(data[i]["DeclareGuildLev"]),col);             
        iCount=iCount+1;
   end
   lstPKList:SetSelect(0);
end

function layWorld_frmGuildPKEx_lbList_lstRanking_OnSelect(self)
   local frmGuildPKEx = uiGetglobal("layWorld.frmGuildPKEx");
   local lbList = SAPI.GetChild(frmGuildPKEx,"lbList");   
   local lstRanking = SAPI.GetChild(lbList,"lstRanking");

   local frmPKDetailedEx = uiGetglobal("layWorld.frmPKDetailedEx");

   local line=lstRanking:getSelectLine();
    if line>=0 then
        local guildname=lstRanking:getLineItemText(line,0);
        if guildname then
            uiInfo("uiGuildWar_SendGuildWarMemberKillRecord:"..tostring(guildname));
            uiGuildWar_SendGuildWarMemberKillRecord(tostring(guildname));
            frmGuildPKEx_DetailName=tostring(guildname); --            
        end
    end
end


function layWorld_frmPKDetailedEx_OnShow(self)
    uiRegisterEscWidget(self);
end

function layWorld_frmPKDetailedEx_btClose_OnLClick(self)
    local frmPKDetailedEx = uiGetglobal("layWorld.frmPKDetailedEx");
    frmPKDetailedEx:Hide();
end

function layWorld_frmGuildPKEx_Refresh2()
    local frmGuildPKEx = uiGetglobal("layWorld.frmGuildPKEx");
   local lbList = SAPI.GetChild(frmGuildPKEx,"lbList");
   --local etPKTime = SAPI.GetChild(lbList,"etPKTime");
   --local lstPKList = SAPI.GetChild(lbList,"lstPKList");
   local lstRanking = SAPI.GetChild(lbList,"lstRanking");
   --local lstApplyPK = SAPI.GetChild(lbList,"lstApplyPK"); 
   local data=uiGuildWar_GetGuildWarKillRecord();

   local num=table.getn(data);

   table.sort(data, function (arg1, arg2) return arg1.KillUserCnt > arg2.KillUserCnt end);   

   lstRanking:RemoveAllLines(true);   
   local col=4294967295;
   local iCount=0;
   for i=1,num,1 do       
        lstRanking:InsertLine(-1,col,-1);
        lstRanking:SetLineItem(iCount,0,tostring(data[i]["GuildName"]),col);
        lstRanking:SetLineItem(iCount,1,tostring(data[i]["KillUserCnt"]),col);             
        lstRanking:SetLineItem(iCount,2,tostring(data[i]["BeKilledUserCnt"]),col);             
        lstRanking:SetLineItem(iCount,3,tostring(data[i]["AgainstGuildName"]),col);             
            
        iCount=iCount+1;
   end
   lstRanking:SetSelect(0);
end


function layWorld_frmGuildPKEx_Refresh4_sort(arg1, arg2) 
   if arg1.KillUserCnt==arg2.KillUserCnt then
       if arg1.BeKilledUserCnt==arg2.BeKilledUserCnt then
           return tostring(arg1.PlayerName)<tostring(arg2.PlayerName) ;
       else
           return arg1.BeKilledUserCnt < arg2.BeKilledUserCnt; 
       end
   else
       return arg1.KillUserCnt > arg2.KillUserCnt ;
   end
end


function layWorld_frmGuildPKEx_Refresh4()
   local frmGuildPKEx = uiGetglobal("layWorld.frmGuildPKEx");
   local lbList = SAPI.GetChild(frmGuildPKEx,"lbList");
   --local etPKTime = SAPI.GetChild(lbList,"etPKTime");
   --local lstPKList = SAPI.GetChild(lbList,"lstPKList");
   local LstUserRanking = SAPI.GetChild(lbList,"LstUserRanking");
   --local lstApplyPK = SAPI.GetChild(lbList,"lstApplyPK"); 
   local data=uiGuildWar_GetGuildWarTopKillRecord();

   local num=table.getn(data);
   local topnumber=uiGuildWar_GetTopKillerNum();
   uiInfo("topnumber:"..tostring(topnumber));
   local rnum=0;

   if num <= topnumber then
       rnum=num;
   else
       rnum=topnumber;
   end




   table.sort(data, layWorld_frmGuildPKEx_Refresh4_sort);


   LstUserRanking:RemoveAllLines(true);   
       local col=4294967295;
       local iCount=0;
       for i=1,rnum,1 do       
            LstUserRanking:InsertLine(-1,col,-1);
            LstUserRanking:SetLineItem(iCount,0,tostring(data[i]["PlayerName"]),col);
            LstUserRanking:SetLineItem(iCount,1,tostring(data[i]["GuildName"]),col);
            LstUserRanking:SetLineItem(iCount,2,tostring(data[i]["PlayerLev"]),col);      
            local party=data[i]["PlayerParty"];
            local partystr;
            if party==EV_PARTY_EM then
                partystr=uiLanString("party_em");
            elseif party==EV_PARTY_FM then
                partystr=uiLanString("party_fm");
            elseif party==EV_PARTY_QC then
                partystr=uiLanString("party_qc");
            elseif party==EV_PARTY_BH then
                partystr=uiLanString("party_bh");
            elseif party==EV_PARTY_XQ then
                partystr=uiLanString("party_xq");
            end

            LstUserRanking:SetLineItem(iCount,3,tostring(partystr),col);             
            LstUserRanking:SetLineItem(iCount,4,tostring(data[i]["KillUserCnt"]),col);             
            LstUserRanking:SetLineItem(iCount,5,tostring(data[i]["BeKilledUserCnt"]),col);             
            iCount=iCount+1;
       end
       LstUserRanking:SetSelect(-1);

end

function layWorld_frmGuildPKEx_OnEvent(self,event,arg)
    if event == "RefreshGuildWarData" then
        if arg[1]==0 then
        layWorld_frmGuildPKEx_Refresh0();

        elseif arg[1]==1 then
        layWorld_frmGuildPKEx_Refresh1();

        elseif arg[1]==2 then
        layWorld_frmGuildPKEx_Refresh2();

        elseif arg[1]==3 then
        uiInfo("Refresh:"..tostring(arg[2]));
        layWorld_frmPKDetailedEx_Refresh(tostring(arg[2]));

        elseif arg[1]==4 then
        layWorld_frmGuildPKEx_Refresh4();
        end
    end
end

function layWorld_frmGuildPKEx_OnShow(self)
    uiRegisterEscWidget(self);
    local frmGuildPKEx=uiGetglobal("layWorld.frmGuildPKEx");
    layWorld_frmGuildPKEx_Show(0);
    if uiGuildWar_IsOpen()==false then
    local strPKTm=string.format(uiLanString("MSG_GUILDWAR_NOTOPEN"));
    uiClientMsg(strPKTm,true);
    frmGuildPKEx:Hide();
    
    end
end


function layWorld_frmGuildPKEx_Show(index)
    local frmGuildPKEx = uiGetglobal("layWorld.frmGuildPKEx");
    local BtnPKTime    = SAPI.GetChild(frmGuildPKEx,"BtnPKTime");
    local BtnPKList    = SAPI.GetChild(frmGuildPKEx,"BtnPKList");
    local BtnRanking   = SAPI.GetChild(frmGuildPKEx,"BtnRanking");
    local BtnApplyPK   = SAPI.GetChild(frmGuildPKEx,"BtnApplyPK");
    local BtnUserRanking=SAPI.GetChild(frmGuildPKEx,"BtnUserRanking");

    local lbList = SAPI.GetChild(frmGuildPKEx,"lbList");

    local etPKTime = SAPI.GetChild(lbList,"etPKTime");
    local lstPKList = SAPI.GetChild(lbList,"lstPKList");
    local lstRanking = SAPI.GetChild(lbList,"lstRanking");
    local lstApplyPK = SAPI.GetChild(lbList,"lstApplyPK");
    local LstUserRanking=SAPI.GetChild(lbList,"LstUserRanking");

    local btDetailed = SAPI.GetChild(frmGuildPKEx,"btDetailed");
    local BtnRefresh = SAPI.GetChild(frmGuildPKEx,"BtnRefresh");
    local btRanking = SAPI.GetChild(frmGuildPKEx,"btRanking");

    local lbSearch = SAPI.GetChild(frmGuildPKEx,"lbSearch");
    local ebGuildName = SAPI.GetChild(lbSearch,"ebGuildName");
    local BtSearch = SAPI.GetChild(lbSearch,"BtSearch");

    local lbLastTime = SAPI.GetChild(frmGuildPKEx,"lbLastTime");

    local frmPKDetailedEx=uiGetglobal("layWorld.frmPKDetailedEx");

    if index == 0 then
    etPKTime:Show();
    lstPKList:Hide();
    lstRanking:Hide();
    lstApplyPK:Hide();
    LstUserRanking:Hide();

    btDetailed:Hide();
    BtnRefresh:Hide();
    btRanking:Hide();
    lbSearch:Hide();
    frmPKDetailedEx:Hide();
    lbLastTime:Hide();

    local strPKTm;
    if uiGuildWar_IsOpen()==true then
    strPKTm=string.format(uiLanString("MSG_GUILD_NEXTTM"),tostring(uiGuildWar_GetNextGuildWarTime()));
    else
    strPKTm=string.format(uiLanString("MSG_GUILDWAR_NOTOPEN"));
    end
    etPKTime:SetText(tostring(strPKTm));
    
    elseif index == 1 then
    --宣战列表
    etPKTime:Hide();
    lstPKList:Show();
    lstRanking:Hide();
    lstApplyPK:Hide();
    LstUserRanking:Hide();

    btDetailed:Hide();
    BtnRefresh:Show();
    btRanking:Hide();
    lbSearch:Hide();
    frmPKDetailedEx:Hide();
    lbLastTime:Hide();
    uiGuildWar_SendDeclareGuildList();

    

    elseif index == 2 then
    --击倒排名
    etPKTime:Hide();
    lstPKList:Hide();
    lstRanking:Show();
    lstApplyPK:Hide();
    LstUserRanking:Hide();

    btDetailed:Show();
    BtnRefresh:Show();
    btRanking:Hide();
    lbSearch:Show();
    lbLastTime:Hide();
    

    uiGuildWar_SendGuildWarKillRecord();    

    elseif index == 3 then
    --申请帮站
    etPKTime:Hide();
    lstPKList:Hide();
    lstRanking:Hide();
    lstApplyPK:Show();
    LstUserRanking:Hide();

    btDetailed:Hide();
    BtnRefresh:Hide();
    btRanking:Show();
    lbSearch:Hide();
    frmPKDetailedEx:Hide();   
    lbLastTime:Hide();
    uiGuildWar_SendCanDeclareGuild(); 
    elseif index == 4 then
    --申请总排行
    etPKTime:Hide();
    lstPKList:Hide();
    lstRanking:Hide();
    lstApplyPK:Hide();
    LstUserRanking:Show();



    btDetailed:Hide();
    BtnRefresh:Show();
    btRanking:Hide();
    lbSearch:Hide();
    frmPKDetailedEx:Hide();   
    lbLastTime:Show();

    local strPKTm=uiGuildWar_GetLastGuildWarTime();    
    uiInfo("LastTm:"..strPKTm);
    lbLastTime:SetText(strPKTm);


    uiGuildWar_SendGuildWarTopKillRecord();   

    end
end


--电击 帮战时间按钮
function layWorld_GuildPKEx_BtnPKTime_OnLClick(self)
    layWorld_frmGuildPKEx_Show(0);

end

--宣战列表按钮
function layWorld_GuildPKEx_BtnPKList_OnLClick(self)
    layWorld_frmGuildPKEx_Show(1);
end

--击倒排名按钮
function layWorld_GuildPKEx_BtnRanking_OnLClick(self)
    layWorld_frmGuildPKEx_Show(2);
end

--申请帮战按钮
function layWorld_GuildPKEx_BtnApplyPK_OnLClick(self)
    layWorld_frmGuildPKEx_Show(3);
end

--总排行按钮
function layWorld_GuildPKEx_BtnUserRanking_OnLClick(self)
    layWorld_frmGuildPKEx_Show(4);
end


--击倒排名详细
function layWorld_GuildPKEx_btDetailed_OnLClick(self)
   local frmGuildPKEx = uiGetglobal("layWorld.frmGuildPKEx");
   local lbList = SAPI.GetChild(frmGuildPKEx,"lbList");   
   local lstRanking = SAPI.GetChild(lbList,"lstRanking");

   local frmPKDetailedEx = uiGetglobal("layWorld.frmPKDetailedEx");

   local line=lstRanking:getSelectLine();
    if line>=0 then
        local guildname=lstRanking:getLineItemText(line,0);
        if guildname then
            uiInfo("uiGuildWar_SendGuildWarMemberKillRecord:"..tostring(guildname));
            uiGuildWar_SendGuildWarMemberKillRecord(tostring(guildname));
            frmGuildPKEx_DetailName=tostring(guildname); --
            frmPKDetailedEx:Show();
        end
    end
end

--申请帮战
function layWorld_GuildPKEx_btRanking_OnLClick(self)
   local frmGuildPKEx = uiGetglobal("layWorld.frmGuildPKEx");
   local lbList = SAPI.GetChild(frmGuildPKEx,"lbList");   
   local lstApplyPK = SAPI.GetChild(lbList,"lstApplyPK");   

   local line=lstApplyPK:getSelectLine();
   
    if line>=0 then
        local guildname=lstApplyPK:getLineItemText(line,0);
        local guildlev=lstApplyPK:getLineItemText(line,1);
        if guildname then        
           local _,myguildlev=uiGuild_GetGuildData();          
           if myguildlev then
               local moneycost=uiGuildWar_GetDeclareGuildWarMoney(tonumber(myguildlev),tonumber(guildlev));
               moneycost=moneycost/10000;
               uiInfo("myguildlev:"..tostring(myguildlev).."otherlev:"..tostring(guildlev));
               local wordmess=string.format(uiLanString("MSG_GUILDWAR_ASK"),guildname,tostring(moneycost));
               local msgBox = uiMessageBox(wordmess,"",true,true,true);
               SAPI.AddDefaultMessageBoxCallBack(msgBox,layWorld_GuildPKEx_btRanking_Yes,layWorld_GuildPKEx_btRanking_No,guildname);            
           else
               uiClientMsg(uiLanString("MSG_GUILDWAR_ERROR2"),true);               
           end
        end
    end
end

function layWorld_GuildPKEx_btRanking_Yes(_,iParam)
   uiInfo("uiGuildWar_DeclareGuildWar:"..tostring(iParam));
   uiGuildWar_DeclareGuildWar(tostring(iParam));      
   uiGuildWar_SendCanDeclareGuild();
end

function layWorld_GuildPKEx_btRanking_No(_,iParam)
   
end

--刷新 宣战列表 击倒排名（详细）
function layWorld_GuildPKEx_BtnRefresh_OnLClick(self)
    local frmGuildPKEx = uiGetglobal("layWorld.frmGuildPKEx");

    local lbList = SAPI.GetChild(frmGuildPKEx,"lbList");
    
    local lstPKList = SAPI.GetChild(lbList,"lstPKList");
    local lstRanking = SAPI.GetChild(lbList,"lstRanking");
    local LstUserRanking = SAPI.GetChild(lbList,"LstUserRanking");
    --判断调用C刷新接口
    --宣战列表
    if lstPKList:getVisible()==true then
         uiGuildWar_SendDeclareGuildList(); 
    end

    --击倒排名
    if lstRanking:getVisible()==true then
        uiGuildWar_SendGuildWarKillRecord();
    end

    if LstUserRanking:getVisible()==true then
        uiGuildWar_SendGuildWarTopKillRecord();
    end
    

end


--击倒排名查找
function layWorld_frmGuildPKEx_lbSearch_BtSearch_OnLClick(self)
    local frmGuildPKEx = uiGetglobal("layWorld.frmGuildPKEx");
    local lbList = SAPI.GetChild(frmGuildPKEx,"lbList");
    local lstRanking = SAPI.GetChild(lbList,"lstRanking");
    local ebGuildName = uiGetglobal("layWorld.frmGuildPKEx.lbSearch.ebGuildName");

    local GuildName = ebGuildName:getText();
    local num=lstRanking:getLineCount();

    for i =1 , num ,1 do
        local strguild=lstRanking:getLineItemText(i-1,0);
        if tostring(strguild) == tostring(GuildName) then
            lstRanking:SetSelect(i-1);
            return;
        end
    end
    lstRanking:SetSelect(-1);   
    uiClientMsg(uiLanString("MSG_GUILDWAR_ERROR1"),true);
end

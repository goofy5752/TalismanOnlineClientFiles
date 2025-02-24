function layWorld_frmRankEx_OnLoad(self)
    self:RegisterScriptEventNotify("RefreshRankResult");
    self:RegisterScriptEventNotify("sev_rank_error_code"); --"i" <原因> 获取排行数据出错
	self:RegisterScriptEventNotify("ToggleRank");  -- "i"  <原因> 键盘或快捷键
    --[[
    // 1 - rank_error_server_busy - msg_rank_err1 - 亲爱的，服务器现在忙，请稍后再试！
    // 2 - rank_error_can_not_find_user - msg_rank_err2 - 找不到要求排名的玩家。
    // 3 - rank_error_not_in_the_rank - msg_rank_err3 - 当前没有所要求的排名。
    // 4 - rank_error_can_not_find_the_ret_page - msg_rank_err4 - 找不到要求的排名。
    // 5 - rank_error_the_user_has_no_rank - msg_rank_err5 - 该玩家没有排名。
    // 6 - rank_error_over_max_lev_rank - msg_rank_err6 - 排行榜只显示等级位列当前服务器的前
    // 7 - rank_error_over_max_god_lev_rank - msg_rank_err8 - 排行榜只显示元神等级位列当前服务器的前
    --]]
    self:Set("PAGE",0); --开始显示第一页
    self:Set("PAGE1",0);        
    self:Set("PAGE2",0);       
    self:Set("PAGE3",0);        
    self:Set("PAGE4",0);      
    self:Set("PAGE5",0); 

  

    self:Set("QUERY",0); --1 查登记 2 查名字
    self:Set("QUERYSTR",0);
end



function layWorld_frmRankEx_OnEvent(self,event,arg)
    if event == "RefreshRankResult" then
		if self:getVisible()==true then
            local index=self:Get("PAGE");
            layWorld_frmRankEx_ListData(index);
        end
	elseif event == "ToggleRank" then
        if arg[1] == EV_EXCUTE_EVENT_KEY_DOWN or arg[1] == EV_EXCUTE_EVENT_ON_LCLICK then
            if self:getVisible() == false then
                self:ShowAndFocus();
            else
                self:Hide();
            end
        end
	elseif event == "sev_rank_error_code" then
    
		local reason_index = arg[1];
		local reason_list = { 
			"msg_rank_err1",	--// 1 - rank_error_server_busy - msg_rank_err1 - 亲爱的，服务器现在忙，请稍后再试！
			"msg_rank_err2",	--// 2 - rank_error_can_not_find_user - msg_rank_err2 - 找不到要求排名的玩家。
			"msg_rank_err3",	--// 3 - rank_error_not_in_the_rank - msg_rank_err3 - 当前没有所要求的排名。
			"msg_rank_err4",	--// 4 - rank_error_can_not_find_the_ret_page - msg_rank_err4 - 找不到要求的排名。
			"msg_rank_err5",	--// 5 - rank_error_the_user_has_no_rank - msg_rank_err5 - 该玩家没有排名。
			"msg_rank_err6",	--// 6 - rank_error_over_max_lev_rank - msg_rank_err6 - 排行榜只显示等级位列当前服务器的前
			"msg_rank_err8",	--// 7 - rank_error_over_max_god_lev_rank - msg_rank_err8 - 排行榜只显示元神等级位列当前服务器的前
		};
		local reason = reason_list[reason_index];
		if reason == nil then return end
		if reason_index == 6 then
			local rank_info = uiRankGetRankInfo();
			if rank_info == nil then return end
			uiMessageBox(LAN(reason)..rank_info.MaxLevelRank, "", true, false, true);
		elseif reason_index == 7 then
			local rank_info = uiRankGetRankInfo();
			if rank_info == nil then return end
			uiMessageBox(LAN(reason)..rank_info.MaxGodLevelRank, "", true, false, true);
		else
			uiMessageBox(LAN(reason), "", true, false, true);
		end
        
    end
end

function layWorld_frmRankEx_btnTitle_OnLClick(self,index)
    local frmRankEx=uiGetglobal("layWorld.frmRankEx");
    frmRankEx:Set("PAGE",tonumber(index));
    layWorld_frmRankEx_SwitchPage(0);
end


function layWorld_frmRankEx_btPrePage_OnLClick(self)
    local frmRankEx=uiGetglobal("layWorld.frmRankEx");
    local iPage=frmRankEx:Get("PAGE");
    local iPage1=frmRankEx:Get("PAGE1");
    local iPage2=frmRankEx:Get("PAGE2");
    local iPage3=frmRankEx:Get("PAGE3");
    local iPage4=frmRankEx:Get("PAGE4");
    local iPage5=frmRankEx:Get("PAGE5");
    if iPage==0 and iPage1>=1 then
        uiRankUpdateLevelRank(iPage1-1); --need wj  
    elseif iPage==1 and iPage2>=1 then
        uiRankUpdateGodLevelRank(iPage2-1); --need wj  
    elseif iPage==2 and iPage3>=1 then
        --uiRankUpdateGuildRank(); --need wj  
    elseif iPage==3 and iPage4>=1 then
        uiRankUpdateMainTrumpRank(iPage4-1); --need wj  
    elseif iPage==4 and iPage5>=1 then
        uiRankUpdateDefendEquipRank(iPage5-1); --need wj  
    end
end

function layWorld_frmRankEx_btNextPage_OnLClick(self)
   local frmRankEx=uiGetglobal("layWorld.frmRankEx");
    local iPage=frmRankEx:Get("PAGE");
    local iPage1=frmRankEx:Get("PAGE1");
    local iPage2=frmRankEx:Get("PAGE2");
    local iPage3=frmRankEx:Get("PAGE3");
    local iPage4=frmRankEx:Get("PAGE4");
    local iPage5=frmRankEx:Get("PAGE5");
    if iPage==0  then
         uiRankUpdateLevelRank(iPage1+1); --need wj
    elseif iPage==1  then
        uiRankUpdateGodLevelRank(iPage2+1); --need wj  
    elseif iPage==2  then
        --uiRankUpdateGuildRank();
    elseif iPage==3  then
        uiRankUpdateMainTrumpRank(iPage4+1);--need wj
    elseif iPage==4  then  
        uiRankUpdateDefendEquipRank(iPage5+1);--need wj
    end

end

--点击查找
function layWorld_frmRankEx_btFind_OnLClick(self)
    local frmRankEx=uiGetglobal("layWorld.frmRankEx");
    local edtRank = SAPI.GetChild(frmRankEx,"edtRank");
    local edtName = SAPI.GetChild(frmRankEx,"edtName");
    local stredtRank = edtRank:getText();
    local stredtName = edtName:getText();

	local iRank = tonumber(stredtRank);
	if edtName:IsKeyInput() == true and stredtName ~= "" then
        if uiRankUpdateLevelRankByName(stredtName) then
            frmRankEx:Set("QUERY",2);
            frmRankEx:Set("QUERYSTR", stredtName);
        end
    elseif iRank ~= nil and iRank ~= 0 then
        if uiRankUpdateLevelRankByRank(iRank) then
            frmRankEx:Set("QUERY",1);
            frmRankEx:Set("QUERYSTR",iRank);
        end
	else
        frmRankEx:Set("QUERY",0);
        frmRankEx:Set("QUERYSTR",0);
        uiRankUpdateLevelRank(0);
    end
end

function layWorld_frmRankEx_ListData(index)
    local frmRankEx=uiGetglobal("layWorld.frmRankEx");
    local frmRanklist=SAPI.GetChild(frmRankEx,"frmRanklist");

    local ltRank=SAPI.GetChild(frmRanklist,"ltRank");
    local ltRankGod=SAPI.GetChild(frmRanklist,"ltRankGod");
    local ltRankGuild=SAPI.GetChild(frmRanklist,"ltRankGuild");
    local ltRankFaBao=SAPI.GetChild(frmRanklist,"ltRankFaBao");
    local ltRankFangju=SAPI.GetChild(frmRanklist,"ltRankFangju");  
    local lb16212= SAPI.GetChild(frmRankEx,"16212");


    local tableData;
    local count;
    local pageye;
    if index==0 then
        tableData=uiRankGetLevelRankData();
        count=table.getn(tableData.List);        
        pageye=tonumber(tableData.Page);

        ltRank:RemoveAllLines(true);
        for idx=1 ,count,1 do
            local col;
            if tableData.List[idx].IsOnline==true then
                col=4294967295;
            else
                col=4286611584;
            end
            ltRank:InsertLine(-1,col,-1);

            local party=tableData.List[idx].Party;
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
            ltRank:SetLineItem(idx-1,0,tostring(pageye*29+idx),col);
            ltRank:SetLineItem(idx-1,1,tableData.List[idx].Name,col);
            ltRank:SetLineItem(idx-1,2,tostring(tableData.List[idx].Level),col);
            ltRank:SetLineItem(idx-1,3,tostring(partystr),col);
            ltRank:SetLineItem(idx-1,4,tableData.List[idx].Guild,col);

            local QUERY=tonumber(frmRankEx:Get("QUERY"));
            local currentIndex=pageye*29+idx;

            if QUERY==1 then--1 查paiming 2 查名字
                if currentIndex == tonumber(frmRankEx:Get("QUERYSTR")) then
                     ltRank:SetSelect(idx-1);
                     frmRankEx:Set("QUERY",0);
                end
            elseif QUERY==2 then
                if tostring(frmRankEx:Get("QUERYSTR")) == tableData.List[idx].Name then
                    ltRank:SetSelect(idx-1);
                    frmRankEx:Set("QUERY",0);
                end
            end

        end
        lb16212:SetText(tostring(tableData.Page+1));
        frmRankEx:Set("PAGE1",tonumber(tableData.Page));   
        

    elseif index==1 then    
        tableData=uiRankGetGodLevelRankData();
        count=table.getn(tableData.List);
        pageye=tonumber(tableData.Page);
        ltRankGod:RemoveAllLines(true);
      
        for idx=1 ,count,1 do     
            local col;
            if tableData.List[idx].IsOnline==true then
                col=4294967295;
            else
                col=4286611584;
            end

            ltRankGod:InsertLine(-1,col,-1);
            ltRankGod:SetLineItem(idx-1,0,tostring(pageye*29+idx),col);
            ltRankGod:SetLineItem(idx-1,1,tableData.List[idx].Name,col);
            ltRankGod:SetLineItem(idx-1,2,SAPI.GetGodTitle(tableData.List[idx].GodLevel),col);
            local party=tableData.List[idx].Party;
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
            ltRankGod:SetLineItem(idx-1,3,tostring(partystr),col);
            ltRankGod:SetLineItem(idx-1,4,tableData.List[idx].Guild,col);
        end
        lb16212:SetText(tostring(tableData.Page+1));
        frmRankEx:Set("PAGE2",tonumber(tableData.Page));        
    elseif index==2 then
        tableData=uiRankGetGuildRankData();
        count=table.getn(tableData.List);      
        ltRankGuild:RemoveAllLines(true);
        local col=4294967295;

        for idx=1 ,count,1 do     
            ltRankGuild:InsertLine(-1,col,-1);
            ltRankGuild:SetLineItem(idx-1,0,tostring(idx),col);
            ltRankGuild:SetLineItem(idx-1,1,tableData.List[idx].Name,col);
            ltRankGuild:SetLineItem(idx-1,2,tostring(tableData.List[idx].Level),col);
            ltRankGuild:SetLineItem(idx-1,3,tostring(tableData.List[idx].Point),col);
            ltRankGuild:SetLineItem(idx-1,4,tableData.List[idx].Leader,col);
        end
    elseif index==3 then        
        tableData=uiRankGetMainTrumpRankData();
        count=table.getn(tableData.List);
        pageye=tonumber(tableData.Page);
        ltRankFaBao:RemoveAllLines(true);
        local col=4294967295;
        for idx=1 ,count,1 do     
            ltRankFaBao:InsertLine(-1,col,-1);
            ltRankFaBao:SetLineItem(idx-1,0,tostring(pageye*29+idx),col);
            ltRankFaBao:SetLineItem(idx-1,1,tableData.List[idx].Name,col);
            ltRankFaBao:SetLineItem(idx-1,2,tostring(tableData.List[idx].Level),col);
            if tostring(tableData.List[idx].Point)=="-1" then
                ltRankFaBao:SetLineItem(idx-1,3,tostring("--"),col);
            else
                ltRankFaBao:SetLineItem(idx-1,3,tostring(tableData.List[idx].Point),col);
            end
            
            if tostring(tableData.List[idx].Owner)=="" then
                ltRankFaBao:SetLineItem(idx-1,4,"--",col);
            else
                ltRankFaBao:SetLineItem(idx-1,4,tableData.List[idx].Owner,col);
            end
            
            local hint = uiRankGetMainTrumpHintByRank(tableData.Page * 29 + idx - 1);
            ltRankFaBao:SetLineHintRichText(idx-1, hint);
        end
        lb16212:SetText(tostring(tableData.Page+1));
        frmRankEx:Set("PAGE4",tonumber(tableData.Page));
    elseif index==4 then
        tableData=uiRankGetDefendEquipRankData();
        count=table.getn(tableData.List);
        pageye=tonumber(tableData.Page);
        ltRankFangju:RemoveAllLines(true);
        local col=4294967295;
        for idx=1 ,count,1 do     
            ltRankFangju:InsertLine(-1,col,-1);
            ltRankFangju:SetLineItem(idx-1,0,tostring(pageye*29+idx),col);
            ltRankFangju:SetLineItem(idx-1,1,tableData.List[idx].Name,col);
            ltRankFangju:SetLineItem(idx-1,2,tostring(tableData.List[idx].Level),col);

            if tostring(tableData.List[idx].Point)=="-1" then
                ltRankFangju:SetLineItem(idx-1,3,"--",col);
            else
                ltRankFangju:SetLineItem(idx-1,3,tostring(tableData.List[idx].Point),col);
            end
            
            if tostring(tableData.List[idx].Owner)=="" then
                ltRankFangju:SetLineItem(idx-1,4,"--",col);
            else
                ltRankFangju:SetLineItem(idx-1,4,tableData.List[idx].Owner,col);
            end
            local hint = uiRankGetDefendEquipHintByRank(tableData.Page * 29 + idx - 1);
            ltRankFangju:SetLineHintRichText(idx-1, hint);
        end
        lb16212:SetText(tostring(tableData.Page+1));
        frmRankEx:Set("PAGE5",tonumber(tableData.Page));        
    end
end

function layWorld_frmRankEx_ShowListBoxTitle(index,bShow)
    local frmRankEx=uiGetglobal("layWorld.frmRankEx");
    local frmRanklist=SAPI.GetChild(frmRankEx,"frmRanklist");

    local ltRank=SAPI.GetChild(frmRanklist,"ltRank");
    local ltRankFangju=SAPI.GetChild(frmRanklist,"ltRankFangju");
    local ltRankFaBao=SAPI.GetChild(frmRanklist,"ltRankFaBao");
    local ltRankGod=SAPI.GetChild(frmRanklist,"ltRankGod");
    local ltRankGuild=SAPI.GetChild(frmRanklist,"ltRankGuild");

    if index==0 then       
        if bShow==true then
            ltRank:Show();            
        else
            ltRank:Hide();
        end
    elseif index==1 then      
        if bShow==true then
            ltRankGod:Show();
        else
            ltRankGod:Hide();
        end
    elseif index==2 then          
        if bShow==true then
            ltRankGuild:Show();
        else
            ltRankGuild:Hide();
        end
    elseif index==3 then           
        if bShow==true then
            ltRankFaBao:Show();
        else
            ltRankFaBao:Hide();
        end
    elseif index==4 then
        if bShow==true then
            ltRankFangju:Show();
        else
            ltRankFangju:Hide();
        end
    end
end

function layWorld_frmRandEx_BottomState(state)
    local frmRankEx=uiGetglobal("layWorld.frmRankEx");
    local edtRank = SAPI.GetChild(frmRankEx,"edtRank");
    local edtName = SAPI.GetChild(frmRankEx,"edtName");
    local lbRank = SAPI.GetChild(frmRankEx,"lbRank");
    local lbName = SAPI.GetChild(frmRankEx,"lbName");
    local btFind = SAPI.GetChild(frmRankEx,"btFind");
    local btPrePage= SAPI.GetChild(frmRankEx,"btPrePage");
    local lb16212= SAPI.GetChild(frmRankEx,"16212");
    local btNextPage= SAPI.GetChild(frmRankEx,"btNextPage");
    if state==1 then
        edtRank:Show();
        edtName:Show();
        lbRank:Show();
        lbName:Show();
        btFind:Show();
        btPrePage:Hide();--Show();
        lb16212:Hide();--Show();
        btNextPage:Hide();--Show();
    elseif state==0 then
        edtRank:Hide();
        edtName:Hide();
        lbRank:Hide();
        lbName:Hide();
        btFind:Hide();
        btPrePage:Hide();
        lb16212:Hide();
        btNextPage:Hide();
     elseif state==2 then
        edtRank:Hide();
        edtName:Hide();
        lbRank:Hide();
        lbName:Hide();
        btFind:Hide();
        btPrePage:Show();
        lb16212:Show();
        btNextPage:Show();
    end
end

function layWorld_frmRankEx_SwitchPage(opt)
    local frmRankEx=uiGetglobal("layWorld.frmRankEx");
    local btnLev=SAPI.GetChild(frmRankEx,"btnLev");
    local btngod=SAPI.GetChild(frmRankEx,"btngod");
    local btnGuild=SAPI.GetChild(frmRankEx,"btnGuild");
    local btMainTrump=SAPI.GetChild(frmRankEx,"btMainTrump");
    local btDefendEquip=SAPI.GetChild(frmRankEx,"btDefendEquip");
    local index=frmRankEx:Get("PAGE");   

    local iPAGE1=frmRankEx:Get("PAGE1");        
    local iPAGE2=frmRankEx:Get("PAGE2");       
    local iPAGE3=frmRankEx:Get("PAGE3");        
    local iPAGE4=frmRankEx:Get("PAGE4");      
    local iPAGE5=frmRankEx:Get("PAGE5"); 
    
    if index == 0 then
        btnLev:SetChecked(true);
        btngod:SetChecked(false);
        btnGuild:SetChecked(false);
        btMainTrump:SetChecked(false);
        btDefendEquip:SetChecked(false);
        layWorld_frmRankEx_ShowListBoxTitle(0,true);
        layWorld_frmRankEx_ShowListBoxTitle(1,false);
        layWorld_frmRankEx_ShowListBoxTitle(2,false);
        layWorld_frmRankEx_ShowListBoxTitle(3,false);
        layWorld_frmRankEx_ShowListBoxTitle(4,false);
        layWorld_frmRandEx_BottomState(1);
        uiRankUpdateLevelRank(iPAGE1); --need wj      
    elseif index ==1 then
        btnLev:SetChecked(false);
        btngod:SetChecked(true);
        btnGuild:SetChecked(false);
        btMainTrump:SetChecked(false);
        btDefendEquip:SetChecked(false);
        layWorld_frmRankEx_ShowListBoxTitle(0,false);
        layWorld_frmRankEx_ShowListBoxTitle(1,true);
        layWorld_frmRankEx_ShowListBoxTitle(2,false);
        layWorld_frmRankEx_ShowListBoxTitle(3,false);
        layWorld_frmRankEx_ShowListBoxTitle(4,false);
        layWorld_frmRandEx_BottomState(0);
        uiRankUpdateGodLevelRank(iPAGE2); --need wj      
    elseif index==2 then
        btnLev:SetChecked(false);
        btngod:SetChecked(false);
        btnGuild:SetChecked(true);
        btMainTrump:SetChecked(false);
        btDefendEquip:SetChecked(false);
        layWorld_frmRandEx_BottomState(0);
        layWorld_frmRankEx_ShowListBoxTitle(0,false);
        layWorld_frmRankEx_ShowListBoxTitle(1,false);
        layWorld_frmRankEx_ShowListBoxTitle(2,true);
        layWorld_frmRankEx_ShowListBoxTitle(3,false);
        layWorld_frmRankEx_ShowListBoxTitle(4,false);
        uiRankUpdateGuildRank();
    elseif index==3 then
        btnLev:SetChecked(false);
        btngod:SetChecked(false);
        btnGuild:SetChecked(false);
        btMainTrump:SetChecked(true);
        btDefendEquip:SetChecked(false);
        layWorld_frmRandEx_BottomState(2);
        layWorld_frmRankEx_ShowListBoxTitle(0,false);
        layWorld_frmRankEx_ShowListBoxTitle(1,false);
        layWorld_frmRankEx_ShowListBoxTitle(2,false);
        layWorld_frmRankEx_ShowListBoxTitle(3,true);
        layWorld_frmRankEx_ShowListBoxTitle(4,false);
        uiRankUpdateMainTrumpRank(iPAGE4);--need wj       
    elseif index==4 then
        btnLev:SetChecked(false);
        btngod:SetChecked(false);
        btnGuild:SetChecked(false);
        btMainTrump:SetChecked(false);
        btDefendEquip:SetChecked(true);
        layWorld_frmRandEx_BottomState(2);
        layWorld_frmRankEx_ShowListBoxTitle(0,false);
        layWorld_frmRankEx_ShowListBoxTitle(1,false);
        layWorld_frmRankEx_ShowListBoxTitle(2,false);
        layWorld_frmRankEx_ShowListBoxTitle(3,false);
        layWorld_frmRankEx_ShowListBoxTitle(4,true);
        uiRankUpdateDefendEquipRank(iPAGE5);--need wj       
    end

end

function layWorld_frmRankEx_OnShow(self)
	uiRegisterEscWidget(self);
	local btnLev = SAPI.GetChild(self, "btnLev");
	layWorld_frmRankEx_btnTitle_OnLClick(btnLev, 0);
end

function layWorld_frmRankEx_frmRanklist_ltRank_OnRDown(self, mouse_x, mouse_y)
	local line, col = uiGetListBoxPickItem(self, mouse_x, mouse_y);
	if line == nil then return end -- 没有这行
	self:SetSelect(line);
	tableData = uiRankGetLevelRankData();
	if tableData == nil then return end -- 没找到数据
	local data = tableData.List[line + 1];
	if data == nil then return end -- 没找到数据
	
	uiRankShowPopmenuPlayer(data.Name, data.IsOnline);
end

function layWorld_frmRankEx_frmRanklist_ltRankGod_OnRDown(self, mouse_x, mouse_y)
	local line, col = uiGetListBoxPickItem(self, mouse_x, mouse_y);
	if line == nil then return end -- 没有这行
	self:SetSelect(line);
	tableData = uiRankGetGodLevelRankData();
	if tableData == nil then return end -- 没找到数据
	local data = tableData.List[line + 1];
	if data == nil then return end -- 没找到数据
	
	uiRankShowPopmenuPlayer(data.Name, data.IsOnline);
end

function layWorld_frmRankEx_frmRanklist_ltRankGuild_OnRDown(self, mouse_x, mouse_y)
	local line, col = uiGetListBoxPickItem(self, mouse_x, mouse_y);
	if line == nil then return end -- 没有这行
	self:SetSelect(line);
	
	local menu = uiGetPopupMenu()
	menu:Hide()
	menu:RemoveAll()
	menu:SetHeaderText(uiLanString("MSG_GUILD"));	-- 帮会
	
	menu:AddMenuItem(LAN("GUILD_COPY_GUILD_NAME"), true);	-- 复制名字
	
	menu.GuildName = self:getLineItemText(line, 1);
	--if not menu.GuildName then return end

	SAPI.AddDefaultPopupMenuCallBack(
		function (self, idx)
			local text = self:getMenuText(idx);
			if text == uiLanString("GUILD_COPY_GUILD_NAME") then
				uiCopyText(self.GuildName);
			end
		end
	);
	uiShowPopupMenu();
end







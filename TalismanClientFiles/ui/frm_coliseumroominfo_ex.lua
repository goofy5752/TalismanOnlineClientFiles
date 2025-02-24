--frm_ColiseumRoomInfo_ex.lua
--PVP 5V5 
--local frRoomInformationEx_Ready=1;



function layWorld_frRoomInformationEx_OnLoad(self)
    self:RegisterScriptEventNotify("RefreshDungeonDetail");
    self:RegisterScriptEventNotify("CloseDungeonRoom");
    self:RegisterScriptEventNotify("EnterDungeonRoom");
    self:RegisterScriptEventNotify("RefreshDungeonChat");
    self:RegisterScriptEventNotify("DungeonInvite");
    
end

function layWorld_frRoomInformationEx_GetParty(party)
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
    return partystr;
end


function layWorld_frRoomInformationEx_OnEvent(self,event,arg)
    local frRoomInformationEx = uiGetglobal("layWorld.frRoomInformationEx");
    local lbChatBox = SAPI.GetChild(frRoomInformationEx,"lbChatBox");
    local edbChatBox = SAPI.GetChild(lbChatBox,"edbChatBox");
    local temp6={};
    temp6[1],temp6[2],temp6[3],temp6[4],temp6[5],temp6[6],temp6[7]=uiInterfaceGetUserConfig("interface.advanced.messagebox");
    uiInfo("Isopen:"..tostring(temp6[7]));

    if event == "RefreshDungeonDetail" then      
        if temp6[7]==false or  frRoomInfo_Show==0 then 
            frRoomInformationEx:ShowAndFocus();
        end
        --刷新里面内容
        uiInfo("RefreshDungeonDetail");
        layWorld_frRoomInformationEx_Show(); 
        uiInfo("RefreshDungeonDetail1");
        frRoomInfo_Show=1;

    elseif event == "CloseDungeonRoom" then
         local str;
	 if arg[1]==1 then
	     str=uiLanString("msg_dungeon_room_error1"); --"你被房主踢出了房间";
	 elseif arg[1]==2 then
	     str=uiLanString("msg_dungeon_room_error2"); --"因为房主的离开，房间解散";
	 elseif arg[1]==3 then
	     str=uiLanString("msg_dungeon_room_error3"); --"你离开了房间，房间被解散";
	 elseif arg[1]==4 then
	     str=uiLanString("msg_dungeon_room_error4"); --"你离开了房间";
	 else
	     str="";
	 end
	 if str~="" then
             uiClientMsg(str,false);
	 end
	 
         uiInfo("CloseDungeonRoom");
         local frRoomInformationEx = uiGetglobal("layWorld.frRoomInformationEx");
         frRoomInformationEx:Hide();


         local frColiseumEx = uiGetglobal("layWorld.frColiseumEx");
         frColiseumEx:ShowAndFocus();   
         
         frRoomInfo_Show=0;

    elseif event =="EnterDungeonRoom" then
         --frRoomInformationEx_Ready=1;
         edbChatBox:SetEnableInput(false);
         edbChatBox:SetText("");

    elseif event == "RefreshDungeonChat" then
        --uiInfo("chatting");
        edbChatBox:SetEnableInput(false);
        edbChatBox:AppendText(tostring(arg[2])..":"..tostring(arg[3]));         
        edbChatBox:ScrollToBottom();
--        edbChatBox:InsertLine(tostring(arg[2])..":"..tostring(arg[3]));         
    
    elseif event =="DungeonInvite" then        
        local strMess=string.format(uiLanString("msg_dungeon_room_invite1"),tostring(arg[1]),tostring(arg[2]));
        local msgBox = uiMessageBox(strMess,"",true,true,false);
        SAPI.AddDefaultMessageBoxCallBack(msgBox,layWorld_frRoomInformationEx_Invite_Yes,layWorld_frRoomInformationEx_Invite_No,tostring(arg[1]));         
    end
end


function layWorld_frRoomInformationEx_Invite_Yes(_,iParam)
    --回答邀请 是
    uiDungeonAnswerInvite(iParam,true);
end

function layWorld_frRoomInformationEx_Invite_No(_,iParam)
    --回答邀请 否
    uiDungeonAnswerInvite(iParam,false);
end

function layWorld_frRoomInformationEx_OnShow(self)
   uiRegisterEscWidget(self);
end


--邀请队友进入房间
function layWorld_frRoomInformationEx_btInvite_OnLClick(self)
--    
    local msgBox = uiInputBox(uiLanString("msg_dungeon_room_invite2"),"","",true,true,false);
    SAPI.AddDefaultInputBoxCallBack(msgBox,layWorld_frRoomInformationEx_btInvite_Yes,layWorld_frRoomInformationEx_btInvite_No,0);
end

function layWorld_frRoomInformationEx_btInvite_Yes(_,_,content)
   --
   if tostring(content)~="" then
       uiInfo("Invite :"..tostring(content));
       uiDungeonInviteOtherPlayer(tostring(content));
   end
end

--查找房间ID
function layWorld_frRoomInformationEx_btInvite_No(_,content,_)
end

--自己离开房间
function layWorld_frRoomInformationEx_btLeave_OnLClick(self)
     local msgBox = uiMessageBox(uiLanString("msg_dungeon_room_invite3"),"",true,true,true);
     SAPI.AddDefaultMessageBoxCallBack(msgBox,layWorld_frRoomInformationEx_btLeave_Yes,layWorld_frRoomInformationEx_btLeave_No,0); 
end

function layWorld_frRoomInformationEx_btLeave_Yes(_,iParam)
   uiDungeonLeaveRoom();
end

function layWorld_frRoomInformationEx_btLeave_No(_,iParam)
   
end

--准备/开始 PVP/PVE 游戏
function layWorld_frRoomInformationEx_ckbReady_OnLClick(self)
    local frRoomInformationEx = uiGetglobal("layWorld.frRoomInformationEx");
    
    local lbRedTeamList =SAPI.GetChild(frRoomInformationEx,"lbRedTeamList");
    local btKickUser2 = SAPI.GetChild(lbRedTeamList,"btKickUser2");

    if btKickUser2:getEnable()==true then 
    --房主
        uiDungeonBeginRoom();
    else
        local pos=frRoomInformationEx:Get("POS");
	local playerstate=frRoomInformationEx:Get("STATE");
	if pos<=5 then
	    --左边

	else
	    --右边
	end
        uiDungeonReady(1-playerstate);
        
        
        
    end
end

--隐藏窗口
function layWorld_frRoomInformationEx_OnHide(self)
    
    
end

--加入红队
function layWorld_frRoomInformationEx_btJoinRed_OnLClick(self)
    uiInfo("Join Red");
    uiDungeonChangePos(0);
end

--加入蓝队
function layWorld_frRoomInformationEx_btJoinBlue_OnLClick(self)
    uiInfo("Join Blue");
    uiDungeonChangePos(1);
end

--房主踢出第几个玩家
function layWorld_frRoomInformationEx_btKickUser_OnLClick(idx)
    local frRoomInformationEx = uiGetglobal("layWorld.frRoomInformationEx");
    local lbRedTeamList =SAPI.GetChild(frRoomInformationEx,"lbRedTeamList");
    local lbBlueTeamList = SAPI.GetChild(frRoomInformationEx,"lbBlueTeamList");

    local lbUser;
    if idx >= 1  and idx <=5 then
        lbUser = SAPI.GetChild(lbRedTeamList,"lbUser"..tostring(idx));
    else
        lbUser = SAPI.GetChild(lbBlueTeamList,"lbUser"..tostring(idx));
    end
    local name=lbUser:Get("NAME");
    if tostring(name)=="nil" then
        return;       
    end

    local strmess=string.format(uiLanString("msg_dungeon_room_invite4"),tostring(name));
    local msgBox = uiMessageBox(strmess,"",true,true,true);
    SAPI.AddDefaultMessageBoxCallBack(msgBox,layWorld_frRoomInformationEx_btKickUser_Yes,layWorld_frRoomInformationEx_btKickUser_No,tostring(name));     
end

function layWorld_frRoomInformationEx_btKickUser_Yes(_,iParam)
   uiDungeonKickPlayer(tostring(iParam));
end

function layWorld_frRoomInformationEx_btKickUser_No(_,iParam)
   
end

function layWorld_frRoomInformationEx_edbChatEnterBox(self)
    local str=self:getText();
    --uiInfo(str);
    if tostring(str)~="" then
	uiDungeonChat(tostring(str));
	self:SetText("");
    end

end

function layWorld_frRoomInformationEx_Show()
    --获得信息
    local data_all=uiDungeonRoomDetail();
    local Team1Num=data_all["ROOMTEAM1"];
    local Team2Num=data_all["ROOMTEAM2"];
    local iType =data_all["ROOMTYPE"];

    
        --
    local frRoomInformationEx = uiGetglobal("layWorld.frRoomInformationEx");
    --标题栏目
    local lbRoomNumber = SAPI.GetChild(frRoomInformationEx,"lbRoomNumber");
    local lbRoomName = SAPI.GetChild(frRoomInformationEx,"lbRoomName");
    local lbMemberCount = SAPI.GetChild(frRoomInformationEx,"lbMemberCount");
    --地图说明
    local edbMapIntroduction =SAPI.GetChild(frRoomInformationEx,"edbMapIntroduction");

     

    --红/蓝队伍
    local lbRedTeamList =SAPI.GetChild(frRoomInformationEx,"lbRedTeamList");
    local lbBlueTeamList = SAPI.GetChild(frRoomInformationEx,"lbBlueTeamList");

    local lbUser1 = SAPI.GetChild(lbRedTeamList,"lbUser1");
    local lbUser2 = SAPI.GetChild(lbRedTeamList,"lbUser2");
    local lbUser3 = SAPI.GetChild(lbRedTeamList,"lbUser3");
    local lbUser4 = SAPI.GetChild(lbRedTeamList,"lbUser4");
    local lbUser5 = SAPI.GetChild(lbRedTeamList,"lbUser5");
    local btJoinRed = SAPI.GetChild(lbRedTeamList,"btJoinRed");
    local btKickUser1 = SAPI.GetChild(lbRedTeamList,"btKickUser1");
    local btKickUser2 = SAPI.GetChild(lbRedTeamList,"btKickUser2");
    local btKickUser3 = SAPI.GetChild(lbRedTeamList,"btKickUser3");
    local btKickUser4 = SAPI.GetChild(lbRedTeamList,"btKickUser4");
    local btKickUser5 = SAPI.GetChild(lbRedTeamList,"btKickUser5");

    local lbUser6 = SAPI.GetChild(lbBlueTeamList,"lbUser6");
    local lbUser7 = SAPI.GetChild(lbBlueTeamList,"lbUser7");
    local lbUser8 = SAPI.GetChild(lbBlueTeamList,"lbUser8");
    local lbUser9 = SAPI.GetChild(lbBlueTeamList,"lbUser9");
    local lbUser10 = SAPI.GetChild(lbBlueTeamList,"lbUser10");
    local btJoinBlue = SAPI.GetChild(lbBlueTeamList,"btJoinBlue");
    local btKickUser6 = SAPI.GetChild(lbBlueTeamList,"btKickUser6");
    local btKickUser7 = SAPI.GetChild(lbBlueTeamList,"btKickUser7");
    local btKickUser8 = SAPI.GetChild(lbBlueTeamList,"btKickUser8");
    local btKickUser9 = SAPI.GetChild(lbBlueTeamList,"btKickUser9");
    local btKickUser10 = SAPI.GetChild(lbBlueTeamList,"btKickUser10");

    local lbChatBox = SAPI.GetChild(frRoomInformationEx,"lbChatBox");
    local edbChatBox = SAPI.GetChild(lbChatBox,"edbChatBox");
    local edbChatEnterBox = SAPI.GetChild(frRoomInformationEx,"edbChatEnterBox");

    local btInvite = SAPI.GetChild(frRoomInformationEx,"btInvite");
    local ckbReady = SAPI.GetChild(frRoomInformationEx,"ckbReady");
    local btMapPreview=SAPI.GetChild(frRoomInformationEx,"btMapPreview");

    local image_pve = SAPI.GetImage("img_pve");
    local image_pvp = SAPI.GetImage("img_pvp");


    local Party;
    local myname,_,_=uiGetMyInfo("Role");


    lbRoomNumber:SetText(tostring(data_all["ROOMNO"]));
    lbRoomName:SetText(tostring(data_all["ROOMNAME"]));
    if iType == 1 then
        lbMemberCount:SetText("("..tostring(data_all["ROOMCOUNT"]).."/5)");
        edbMapIntroduction:SetText(uiLanString("msg_dungeon_map1"));
	if image_pve then
            btMapPreview:SetBackgroundImage(image_pve);
	end
    elseif iType ==3 then
        lbMemberCount:SetText("("..tostring(data_all["ROOMCOUNT"]).."/10)");
        edbMapIntroduction:SetText(uiLanString("msg_dungeon_map2"));
	if image_pvp then
            btMapPreview:SetBackgroundImage(image_pvp);
	end
    end


    frRoomInformationEx:Delete("POS");
    frRoomInformationEx:Delete("STATE");

    for ic=1,10,1 do
        if iType == 1 then
            uiInfo("iType == 1");
            local lbUser;
            local btKickUser;
            if ic<=5 then
                lbUser= SAPI.GetChild(lbRedTeamList,"lbUser"..tostring(ic));
                lbUser:SetText("");
                lbUser:Delete("NAME");
                lbUser:Delete("STATE");
            else  
                lbUser= SAPI.GetChild(lbBlueTeamList,"lbUser"..tostring(ic));
                btKickUser= SAPI.GetChild(lbBlueTeamList,"btKickUser"..ic);
                lbUser:SetText("");   
                lbUser:Delete("NAME");
                lbUser:Delete("STATE");
                btKickUser:Disable();             
            end
        elseif iType == 3 then
            uiInfo("iType == 3");
            local lbUser;
            local btKickUser;
            if ic<=5 then
                lbUser= SAPI.GetChild(lbRedTeamList,"lbUser"..tostring(ic));
                lbUser:SetText("");
                lbUser:Delete("NAME");
                lbUser:Delete("STATE");
            else  
                lbUser= SAPI.GetChild(lbBlueTeamList,"lbUser"..tostring(ic));
                btKickUser= SAPI.GetChild(lbBlueTeamList,"btKickUser"..ic);
                lbUser:SetText("");
                lbUser:Delete("NAME");
                lbUser:Delete("STATE");
                btKickUser:Enable();             
            end
        end
    end



    for i1=1,Team1Num,1 do
        local data_team1=uiDungeonRoomDetailTeam1(i1-1);
        local lbUser= SAPI.GetChild(lbRedTeamList,"lbUser"..tostring(i1));
        local sztxt ="";
        
        if data_team1["PLAYSTATE"]==1 then
           sztxt=uiLanString("msg_dungeon_ready");	   	
        end


        --找到名字
        if tostring(data_team1["PLAYNAME"])==tostring(myname) then
	    frRoomInformationEx:Set("POS",i1);   
	    frRoomInformationEx:Set("STATE",tostring(data_team1["PLAYSTATE"]));
        end

	Party=layWorld_frRoomInformationEx_GetParty(data_team1["PLAYPARTY"]);
        sztxt=sztxt.."L"..tostring(data_team1["PLAYLEV"]).."["..tostring(Party).."]"..tostring(data_team1["PLAYNAME"]);
        lbUser:SetText(tostring(sztxt));
        lbUser:Set("NAME",tostring(data_team1["PLAYNAME"]));
        lbUser:Set("STATE",tostring(data_team1["PLAYSTATE"]));

        if i1==1 then          
            local btKickUser;
            if tostring(myname) == tostring(data_team1["PLAYNAME"] ) then
                --是房主           
                btKickUser=SAPI.GetChild(lbRedTeamList,"btKickUser1");
                btKickUser:Disable();
                for idx=2 ,10 , 1 do
                    if idx<=5 then                    
                        btKickUser= SAPI.GetChild(lbRedTeamList,"btKickUser"..idx);
                    else
                        btKickUser= SAPI.GetChild(lbBlueTeamList,"btKickUser"..idx);
                    end
                    if iType == 1 and idx>5 then
                        btKickUser:Disable();
                    else
                        btKickUser:Enable();
                    end
                end
                btJoinRed:Disable();
                btJoinBlue:Disable();
		btInvite:Enable();
		ckbReady:SetText(uiLanString("msg_dungeon_kaishi"));

            else 
               --不是房主
               for idx=1 ,10 , 1 do
                    if idx<=5 then                    
                        btKickUser= SAPI.GetChild(lbRedTeamList,"btKickUser"..idx);
                    else
                        btKickUser= SAPI.GetChild(lbBlueTeamList,"btKickUser"..idx);
                    end
                    btKickUser:Disable();
                end
                if iType == 1 then
                    btJoinRed:Disable();
                    btJoinBlue:Disable();
                elseif iType == 3 then
                    btJoinRed:Enable();
                    btJoinBlue:Enable();                
                end
		btInvite:Disable();
            end
	else
	    if tostring(myname) == tostring(data_team1["PLAYNAME"] ) then
	         if data_team1["PLAYSTATE"]==1 then		    
		    ckbReady:SetText(uiLanString("msg_dungeon_qxzhunbei"));
		 else
		   ckbReady:SetText(uiLanString("msg_dungeon_zhunbei"));
		 end
	    end
        end
    
    end

    for i2=1,Team2Num,1 do
        local data_team2=uiDungeonRoomDetailTeam2(i2-1);
        local lbUser= SAPI.GetChild(lbBlueTeamList,"lbUser"..tostring(i2+5));
        local sztxt ="";

	--找到名字
        if tostring(data_team2["PLAYNAME"])==tostring(myname) then
	    frRoomInformationEx:Set("POS",5+i2);        
	    frRoomInformationEx:Set("STATE",tostring(data_team2["PLAYSTATE"]));	   

	    if data_team2["PLAYSTATE"]==1 then		    
	       ckbReady:SetText(uiLanString("msg_dungeon_qxzhunbei"));
	    else
	       ckbReady:SetText(uiLanString("msg_dungeon_zhunbei"));
	    end	   
        end

        if data_team2["PLAYSTATE"]==1 then
           sztxt=uiLanString("msg_dungeon_ready");		  
        end
	Party=layWorld_frRoomInformationEx_GetParty(data_team2["PLAYPARTY"]);
        sztxt=sztxt.."L"..tostring(data_team2["PLAYLEV"]).."["..tostring(Party).."]"..tostring(data_team2["PLAYNAME"]);
        lbUser:SetText(tostring(sztxt));
        lbUser:Set("NAME",tostring(data_team2["PLAYNAME"]));
        lbUser:Set("STATE",tostring(data_team2["PLAYSTATE"]));
    end


end


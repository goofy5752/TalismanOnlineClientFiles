--PVP System Entry
--Code by jin.Wang
local frColiseumExIdx=1;
local frColiseumEx_data={};
frRoomInfo_Show=0;

function layWorld_frColiseumEx_OnLoad(self)
     self:RegisterScriptEventNotify("ShowDungeonTeam");
     self:RegisterScriptEventNotify("RefreshDungeonRoomInfo");
     --选择房间进入
     self:RegisterScriptEventNotify("EnterDungeonRoom");
     self:RegisterScriptEventNotify("BeginDungeonRoom");
     self:RegisterScriptEventNotify("RefreshDungeonDetail");

end

function layWorld_frColiseumEx_OnEvent(self,event,arg)
    local frColiseumEx = uiGetglobal("layWorld.frColiseumEx");
    local frCreateRoomEx = uiGetglobal("layWorld.frCreateRoomEx");
    local frRoomInformationEx = uiGetglobal("layWorld.frRoomInformationEx");
    if event == "ShowDungeonTeam" then
        if  frColiseumEx:getVisible() == true then
            frColiseumEx:Hide();
        else
            frColiseumEx:ShowAndFocus();
            layWorld_frColiseumEx_Show(1);
            uiGetDungeonInfo(1);
        end
    elseif event =="RefreshDungeonRoomInfo" then

        uiInfo("RefreshDungeonRoomInfo wj:"..tostring(frColiseumExIdx).."---"..tostring(arg[1]));
        if tonumber(frColiseumExIdx) == tonumber(arg[1]) then
            layWorld_frColiseumEx_Show(frColiseumExIdx);   
        end
    elseif event =="EnterDungeonRoom" then
        frColiseumEx:Hide();
        frCreateRoomEx:Hide(); 
    elseif event =="BeginDungeonRoom" then
        frColiseumEx:Hide();
        frCreateRoomEx:Hide();
        frRoomInformationEx:Hide();
    elseif event =="RefreshDungeonDetail" then
        if  frColiseumEx:getVisible() == true then
            uiGetDungeonInfo(frColiseumExIdx);
        end
    end


end

function layWorld_frColiseumEx_OnShow(self)
   uiRegisterEscWidget(self);
   uiGetDungeonInfo(frColiseumExIdx);
end

function layWorld_frColiseumEx_btSearchRoom_OnLClick(self)    
    local msgBox = uiInputBox(uiLanString("msg_dungeon_search"),"","",true,true,true);
    SAPI.AddDefaultInputBoxCallBack(msgBox,layWorld_frColiseumEx_frColiseumStyle_btSearchRoom_Yes,layWorld_frColiseumEx_frColiseumStyle_btSearchRoom_No,0);
end

function layWorld_frColiseumEx_frColiseumStyle_btSearchRoom_Yes(_,_,content)
    --获得content
    local frColiseumEx = uiGetglobal("layWorld.frColiseumEx");
    local frRoomList = SAPI.GetChild(frColiseumEx,"frRoomList");
    local lbRoomList=SAPI.GetChild(frRoomList,"lbRoomList");

    local searchid = tostring(content);
    local num=lbRoomList:getLineCount();

    for i =1 , num ,1 do
        local strno=lbRoomList:getLineItemText(i-1,0);
        if tostring(strno) == tostring(searchid) then
            lbRoomList:SetSelect(i-1);
            return;
        end
    end
    lbRoomList:SetSelect(-1);   
    --uiClientMsg(uiLanString(""),true);    
end

--查找房间ID
function layWorld_frColiseumEx_frColiseumStyle_btSearchRoom_No(_,content,_)
end

--切换1
function layWorld_frColiseumEx_frColiseumStyle_btStyle1_OnLClick(self)    
    frColiseumExIdx=1;   
    uiGetDungeonInfo(frColiseumExIdx);
end

--切换2
function layWorld_frColiseumEx_frColiseumStyle_brStyle2_OnLClick(self)    
    frColiseumExIdx=3;
    uiGetDungeonInfo(frColiseumExIdx);
end

function layWorld_frColiseumEx_btListRefresh_OnLClick(self)
--更新按钮
    uiGetDungeonInfo(frColiseumExIdx);
    --layWorld_frColiseumEx_Show_Down(frColiseumExIdx);
end

--玩家自己开房间
function layWorld_frColiseumEx_btCreateRoom_OnLClick(self)
    local frCreateRoomEx = uiGetglobal("layWorld.frCreateRoomEx");
    layWorld_frCreateRoomEx_SetType(frColiseumExIdx);    
    frCreateRoomEx:ShowAndFocus(); 

end

--显示所在房间
function layWorld_frColiseumEx_frColiseumStyle_btShowRoom_OnLClick(self)
    --您未在任何房间中
    --直接进入所在房间
    frRoomInfo_Show=0;        
    uiDungeonEnterMyRoom();
end

--玩家选择房间进入[auto =0 手工 auto =1 自动选择] 
--进入房间 统一入口
function layWorld_frColiseumExbtEnterRoom_OnLClick(self,auto)
    local frColiseumEx = uiGetglobal("layWorld.frColiseumEx");
    local frRoomList = SAPI.GetChild(frColiseumEx,"frRoomList");
    local lbRoomList=SAPI.GetChild(frRoomList,"lbRoomList");

    if auto == 0 then
       --手工选择
        local line=lbRoomList:getSelectLine();
        if line>=0 then
            layWorld_frColiseumExbtEnterRoom_Enter(line);       
        end
    elseif auto == 1 then
       --自动选择       
        for i=0,lbRoomList:getLineCount()-1,1 do
            if frColiseumEx_data[i+1]["ROOMSTATE"]==1 then
                if frColiseumExIdx==1 and frColiseumEx_data[i+1]["ROOMCOUNT"]<5 then
                    layWorld_frColiseumExbtEnterRoom_Enter(i);
                elseif frColiseumExIdx==3 and frColiseumEx_data[i+1]["ROOMCOUNT"]<10 then
                    layWorld_frColiseumExbtEnterRoom_Enter(i);   
                end                
            end
        end
    end
end

function layWorld_frColiseumExbtEnterRoom_Enter(line)
    local frColiseumEx = uiGetglobal("layWorld.frColiseumEx");
    local frRoomList = SAPI.GetChild(frColiseumEx,"frRoomList");
    local lbRoomList=SAPI.GetChild(frRoomList,"lbRoomList");
    local linelua=line+1;


    local roomname=lbRoomList:getLineItemText(line,0);
    if roomname then            
        --判断是否有密码
        uiInfo("line:"..tostring(line));
        uiInfo("frColiseumEx_data[line]:"..tostring(frColiseumEx_data[linelua]));
	uiInfo("roomname:"..tostring(roomname));


        if frColiseumEx_data[linelua] and frColiseumEx_data[linelua]["ROOMBKEY"] and frColiseumEx_data[linelua]["ROOMBKEY"]==1 then
             --弹出MESSAGEBOX
             uiInfo("有密码！");
             local msgBox = uiInputBox(uiLanString("msg_dungeon_passwd"),"","",true,true,true);
             SAPI.AddDefaultInputBoxCallBack(msgBox,layWorld_frColiseumEx_btPass_Yes,layWorld_frColiseumEx_btPass_No,0);
        else
           --调用进入房间的接口
            --roomname ,""
            uiInfo("没有密码！");
            uiDungeonEnterRoom(tonumber(roomname),"");                 
        end            
    end
end

function layWorld_frColiseumEx_btPass_Yes(_,_,content)
    --获得content
    local frColiseumEx = uiGetglobal("layWorld.frColiseumEx");
    local frRoomList = SAPI.GetChild(frColiseumEx,"frRoomList");
    local lbRoomList=SAPI.GetChild(frRoomList,"lbRoomList");

    local line=lbRoomList:getSelectLine();
    if line>=0 then
        local roomname=lbRoomList:getLineItemText(line,0);
        if roomname then    
            --调用进入房间接口
            --roomname ,content
            uiDungeonEnterRoom(tonumber(roomname),tostring(content));
        end
    end
end

--查找房间ID
function layWorld_frColiseumEx_btPass_No(_,content,_)
end



--察看排行榜
function layWorld_btColiseumRankingm_OnLClick(self)
    local frColiseumRankingsEx=uiGetglobal("layWorld.frColiseumRankingsEx");
    frColiseumRankingsEx:ShowAndFocus();
end

--idx 选择第几个项目
function layWorld_frColiseumEx_Show(idx)
   -- 获得玩家PVP积分
   local frColiseumEx = uiGetglobal("layWorld.frColiseumEx");
   local lbPoint =uiGetglobal(frColiseumEx,"layWorld.frColiseumEx.lbColiseum.lbColiseumPoint.lbPoint");

   local pvpscore=uiGetMyInfo("PvpPoint");
   if not pvpscore then
       uiInfo("pvpscore error!!");
       --return ;
   end
   lbPoint:SetText(tostring(pvpscore));
   --选择
   local frColiseumStyle = SAPI.GetChild(frColiseumEx,"frColiseumStyle");

   local btStyle1=SAPI.GetChild(frColiseumStyle,"btStyle1");
   local brStyle2=SAPI.GetChild(frColiseumStyle,"brStyle2");
   local ebStyleInfomation=SAPI.GetChild(frColiseumStyle,"ebStyleInfomation");
   if idx == 1 then
       btStyle1:SetChecked(true);
       brStyle2:SetChecked(false);
       ebStyleInfomation:SetText(uiLanString("msg_dungeon_txt1"));
   elseif idx == 3 then
       btStyle1:SetChecked(false);
       brStyle2:SetChecked(true);
       ebStyleInfomation:SetText(uiLanString("msg_dungeon_txt2"));
   end

   local lbColiseum=SAPI.GetChild(frColiseumEx,"lbColiseum");
   local lbColiseumPoint=SAPI.GetChild(lbColiseum,"lbColiseumPoint");
   local lbColiseumPointBack=SAPI.GetChild(lbColiseum,"lbColiseumPointBack");

   local bpvpopen=uiGetDungeonIsOpen(3);
   if bpvpopen==false then
       brStyle2:Hide();
       lbColiseumPointBack:Show();
       lbColiseumPoint:Hide();
   else
       brStyle2:Show();   
       lbColiseumPointBack:Hide();
       lbColiseumPoint:Show();
   end

   layWorld_frColiseumEx_Show_Down(idx);
end


--显示更新房间(下面）的所有列表
function layWorld_frColiseumEx_Show_Down(idx)
   --获得对应房间的列表信息
   local frColiseumEx = uiGetglobal("layWorld.frColiseumEx");
   local frRoomList = SAPI.GetChild(frColiseumEx,"frRoomList");
   local lbRoomList=SAPI.GetChild(frRoomList,"lbRoomList");

   --调用接口获得内容
   

   frColiseumEx_data=uiDungeonRoomList();
   --[[
   data[1]={};
   data[1]["ROOMNO"]="0130";
   data[1]["ROOMNAME"]="小白";
   data[1]["ROOMCOUNT"]=1;
   data[1]["ROOMSTATE"]=0;
   data[1]["ROOMLEV"]=30;  
   --]]   

   --sort data here:
   table.sort(frColiseumEx_data, function (arg1, arg2) return arg1.ROOMSTATE < arg2.ROOMSTATE end);

   local num=table.getn(frColiseumEx_data);
   --显示

   lbRoomList:RemoveAllLines(true);   
   local col=4294967295;
   local iCount=0;
   for i=1,num,1 do       
        lbRoomList:InsertLine(-1,col,-1);
        lbRoomList:SetLineItem(iCount,0,tostring(frColiseumEx_data[i]["ROOMNO"]),col);
        lbRoomList:SetLineItem(iCount,1,tostring(frColiseumEx_data[i]["ROOMNAME"]),col);   
        if idx == 1 then
            lbRoomList:SetLineItem(iCount,2,tostring(frColiseumEx_data[i]["ROOMCOUNT"]).."/5",col);     
        elseif idx == 3 then
            lbRoomList:SetLineItem(iCount,2,tostring(frColiseumEx_data[i]["ROOMCOUNT"]).."/10",col);     
        end
        local rstat="";
        if frColiseumEx_data[i]["ROOMSTATE"]==1 then
            rstat=uiLanString("msg_dungeon_state0");
        elseif frColiseumEx_data[i]["ROOMSTATE"]==2 then
            rstat=uiLanString("msg_dungeon_state1");
        end        
        lbRoomList:SetLineItem(iCount,3,tostring(rstat),col);             
        lbRoomList:SetLineItem(iCount,4,tostring(frColiseumEx_data[i]["ROOMLEV"]),col);             
        iCount=iCount+1;
   end
   lbRoomList:SetSelect(0);

end






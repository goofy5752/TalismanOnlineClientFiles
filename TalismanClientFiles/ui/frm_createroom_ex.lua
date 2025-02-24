--PVP System Entry
--Code by jin.Wang
local frCreateRoomExType=1;
function layWorld_frCreateRoomEx_OnLoad(self)    
end

function layWorld_frCreateRoomEx_OnEvent(self,event,arg)
end

function layWorld_frCreateRoomEx_OnShow(self)
   uiRegisterEscWidget(self);
   layWorld_frCreateRoomEx_Show(frCreateRoomExType);
end

function layWorld_frCreateRoomEx_SetType(itype)
   frCreateRoomExType=itype;
end

--选择方式
function layWorld_frCreateRoomEx_cbChooseStyle_OnUpdateText(self)
    local frCreateRoomEx=uiGetglobal("layWorld.frCreateRoomEx");    
    local cbChooseMap=SAPI.GetChild(frCreateRoomEx,"cbChooseMap");
    if self:getSelectItemIndex()==0 then
        cbChooseMap:SelectItem(0);
        layWorld_frCreateRoomEx_cbChooseMap_content(1);

    elseif self:getSelectItemIndex()==1 then
        cbChooseMap:SelectItem(1);
        layWorld_frCreateRoomEx_cbChooseMap_content(3);
    end
end

--选择地图
function layWorld_frCreateRoomEx_cbChooseMap_OnUpdateText(self)

end

function layWorld_frCreateRoomEx_cbChooseMap_content(idx)
    local frCreateRoomEx=uiGetglobal("layWorld.frCreateRoomEx");
    local edbStyleIntroduction = SAPI.GetChild(frCreateRoomEx,"edbStyleIntroduction");
    local edbMapIntroduction = SAPI.GetChild(frCreateRoomEx,"edbMapIntroduction");
    local edbSetLevel=SAPI.GetChild(frCreateRoomEx,"edbSetLevel");
    local setting=uiGetDungeonSetting();
    local pvemin=setting["PVE_LEV"];
    local pvpmin=setting["PVP_LEV"];

     
    if idx == 1 then
        edbStyleIntroduction:SetText(uiLanString("msg_dungeon_txt1"));
        edbMapIntroduction:SetText(uiLanString("msg_dungeon_map1"));
	edbSetLevel:SetText(tostring(pvemin));
    elseif idx == 3 then
        edbStyleIntroduction:SetText(uiLanString("msg_dungeon_txt2"));
        edbMapIntroduction:SetText(uiLanString("msg_dungeon_map2"));
	edbSetLevel:SetText(tostring(pvpmin));
    end  

end

function layWorld_frCreateRoomEx_Show(idx)
    --idx 类型
    local frCreateRoomEx=uiGetglobal("layWorld.frCreateRoomEx");
    local edbEnterRoomName=SAPI.GetChild(frCreateRoomEx,"edbEnterRoomName");
    local cbChooseStyle=SAPI.GetChild(frCreateRoomEx,"cbChooseStyle");
    local cbChooseMap=SAPI.GetChild(frCreateRoomEx,"cbChooseMap");
    local edbEnterPassword=SAPI.GetChild(frCreateRoomEx,"edbEnterPassword");
    local edbSetLevel=SAPI.GetChild(frCreateRoomEx,"edbSetLevel");

    local setting=uiGetDungeonSetting();
    local pvemin=setting["PVE_LEV"];
    local pvpmin=setting["PVP_LEV"];


    --房间名字
    edbEnterRoomName:SetText("");

    cbChooseStyle:RemoveAllItems();
    cbChooseMap:RemoveAllItems();
    edbEnterPassword:SetText("");

   local bpvpopen=uiGetDungeonIsOpen(3);
   

    cbChooseStyle:SetEnableInput(false);
    cbChooseStyle:AddItem(uiLanString("msg_dungeon_type1"),0);
    if bpvpopen==true then
        cbChooseStyle:AddItem(uiLanString("msg_dungeon_type2"),0);
    end
    
    cbChooseMap:SetEnableInput(false);
    cbChooseMap:Disable();
    cbChooseMap:AddItem(uiLanString("msg_dungeon_type1"),0);
    if bpvpopen==true then
        cbChooseMap:AddItem(uiLanString("msg_dungeon_type2"),0);   
    end

    if idx == 1 then 
        edbSetLevel:SetText(tostring(pvemin));
        cbChooseStyle:SelectItem(0);
        cbChooseMap:SelectItem(0);


    elseif idx == 3 then
        edbSetLevel:SetText(tostring(pvpmin));
        cbChooseStyle:SelectItem(1);
        cbChooseMap:SelectItem(1);
    end
    layWorld_frCreateRoomEx_cbChooseMap_content(idx);
    
end

--创建房间
function layWorld_frCreateRoomEx_btConfirm_OnLClick(self)   
    local frCreateRoomEx=uiGetglobal("layWorld.frCreateRoomEx");
    local edbEnterRoomName=SAPI.GetChild(frCreateRoomEx,"edbEnterRoomName");
    local cbChooseStyle=SAPI.GetChild(frCreateRoomEx,"cbChooseStyle");
    local cbChooseMap=SAPI.GetChild(frCreateRoomEx,"cbChooseMap");
    local edbEnterPassword=SAPI.GetChild(frCreateRoomEx,"edbEnterPassword");
    local edbSetLevel=SAPI.GetChild(frCreateRoomEx,"edbSetLevel");
    local setting=uiGetDungeonSetting();
    local pvemin=setting["PVE_LEV"];
    local pvpmin=setting["PVP_LEV"];



    local itype;
    local slev=tonumber(edbSetLevel:getText());

    if cbChooseStyle:getSelectItemIndex() == 0 then
        itype=1;
    elseif cbChooseStyle:getSelectItemIndex() == 1 then
        itype=3;
    else
        return;
    end
    local strerror1=string.format(uiLanString("msg_dungeon_min_level"),tostring(pvemin));
    local strerror2=string.format(uiLanString("msg_dungeon_min_level"),tostring(pvpmin));
    
    if itype == 1 then
        if slev<tonumber(pvemin) then
	    uiClientMsg(strerror1,false);
	    return;
	end
    else
      --ityle == 3
       if slev<tonumber(pvpmin) then
	    uiClientMsg(strerror2,false);
	    return;
	end
    end
    local roomtitle=edbEnterRoomName:getText();
    if  tostring(roomtitle)~="" then
        uiDungeonCreateRoom(roomtitle,itype,tonumber(edbSetLevel:getText()),edbEnterPassword:getText());
    end
end

--关闭
function layWorld_frCreateRoomEx_btCancel_OnLClick(self)
    local frCreateRoomEx=uiGetglobal("layWorld.frCreateRoomEx");
    frCreateRoomEx:Hide();
end

local frmVedioEx_Display={};
local frmVedioEx_Display_Old={};
local frmVedioEx_Display_New={};
local frmVedioEx_Display_box=nil;

local InterfaceSettingEx_SetOld={};
local InterfaceSettingEx_SetNew={};

local ScreenUserCountMax = 60;
local ScreenUserCountMin = 50;
--[[
RemoveAllItems
SetEnableInput
AddItem
getText
SetText
getSelectItemIndex
---]]
function layWorld_frmSystemMenuEx_OnLoad(self)
   self:RegisterScriptEventNotify("ToggleSystem");
end

function layWorld_frmSystemMenuEx_OnEvent(self,event,arg)
    --uiInfo("layWorld_frmSystemMenuEx_OnEvent:"..tostring(event));
    if event == "ToggleSystem" then
        if arg[1] == EV_EXCUTE_EVENT_KEY_DOWN then
            if self:getVisible()==true then return end
            self.MouseDownEvent = true;
        end
        if arg[1] == EV_EXCUTE_EVENT_KEY_UP then
            if self:getVisible()==false and self.MouseDownEvent then
                self:ShowAndFocus();
				self.MouseDownEvent = nil;
            end
        end
        if arg[1] == EV_EXCUTE_EVENT_ON_LCLICK then
            if self:getVisible()==false then
                self:ShowAndFocus();
            else
                self:Hide();
            end
        end
    end
end

function layWorld_frmSystemMenuEx_OnShow(self)
	uiRegisterEscWidget(self);
end

function layWorld_frmSystemMenuEx_btSystemHelp_OnLClick(self)
    local frmhelpex=uiGetglobal("layWorld.frmHelpEx");
    frmhelpex:ShowAndFocus();
end

function layWorld_frmSystemMenuEx_btReturnGame_OnLClick(self)
	local frame = SAPI.GetParent(self);
	frame:Hide();
end                                      

function layWorld_frmSystemMenuEx_btVideoSetting_OnLClick(self)
    local frmVedioEx=uiGetglobal("frmVedioEx");
    if frmVedioEx:getVisible()==true then
       frmVedioEx:Hide();
    else
       local usrFull,usrw,usrh,usrdep,usrrate,usrTexture,_,usrShadow,_,usrPeople,_,usrlock;
       usrFull,usrw,usrh,usrdep,usrrate,usrTexture,_,usrShadow,_,usrPeople,_,usrlock=uiVideoGetUserConfig();
       frmVedioEx_Display_Old={};
       frmVedioEx_Display_Old={usrFull,usrw,usrh,usrdep,usrrate,usrTexture,usrShadow,usrlock,usrPeople};
       frmVedioEx_Display_New={usrFull,usrw,usrh,usrdep,usrrate,usrTexture,usrShadow,usrlock,usrPeople};

       frmVedioEx_Show();
       frmVedioEx:ShowAndFocus();
    end
end

function layWorld_frmSystemMenuEx_btSoundSetting_OnLClick(self)
    local frmAudioEx=uiGetglobal("layWorld.frmAudioEx");   
    if frmAudioEx:getVisible()==true then
       frmAudioEx:Hide();
    else
       frmAudioEx:ShowAndFocus();
    end
end



function layWorld_frmSystemMenuEx_btInterfaceSetting_OnLClick(self)
    local frmInterfaceSettingEx=uiGetglobal("layWorld.frmInterfaceSettingEx");
    if frmInterfaceSettingEx:getVisible()==true then
        frmInterfaceSettingEx:Hide();
    else
        InterfaceSettingEx_SetOld={};      

        frmInterfaceSettingEx:Set("PAGE",1);

        layWorld_frmInterfaceSettingEx_getData(true);
        layWorld_frmInterfaceSettingEx_getData(false);
        layWorld_frmInterfaceSettingEx_Show(1,InterfaceSettingEx_SetOld);
        
        frmInterfaceSettingEx:ShowAndFocus();
    end
end

function layWorld_frmSystemMenuEx_btKeySetting_OnLClick(self)
    local frmKeySettingEx=uiGetglobal("layWorld.frmKeySettingEx");
    if frmKeySettingEx:getVisible()==true then
        frmKeySettingEx:Hide();
    else
        frmKeySettingEx:ShowAndFocus();
    end
end


--------------------------------------------------------------------------------------------------------------------------------
function frmVedioEx_bstrIn(tb,str)  
   if tb then
       local length=table.getn(tb);
       for idx=1,length,1 do
           if tb[idx][str] then  
               return idx;
           end
       end
       return 0;
   else
       return 0;
   end
end

function frmVedioEx_frmSelect_cbSize_OnUpdateText(self,sel)
   --uiInfo("SEL:"..tostring(sel));
   local cbSize=SAPI.GetSibling(self,"cbSize");
   local cbColor=SAPI.GetSibling(self,"cbColor");
   local cbRefresh=SAPI.GetSibling(self,"cbRefresh");
   --cbSize
   if tostring(sel)=="cbSize" then
        local usrstrwh=self:getText();
        local usrret=frmVedioEx_bstrIn(frmVedioEx_Display,usrstrwh);
        local colortemp={};
        local ratetemp={};
        cbColor:RemoveAllItems();
        cbRefresh:RemoveAllItems();

        for i,v in pairs(frmVedioEx_Display[usrret][usrstrwh]) do --
         --cbColor:AddItem
             for m,n in ipairs(v) do
                 --uiInfo("wj add log["..tostring(m).."]:"..tostring(n));
                 if tonumber(m)==1 then
                     frmVedioEx_Display_New[2]=tonumber(n);
                 end

                 if tonumber(m)==2 then
                     frmVedioEx_Display_New[3]=tonumber(n);
                 end

                 if tonumber(m)==3 then             
                    if(not colortemp[tostring(n)])  then                  
                       local usrstrdeplist="     "..tostring(n)..tostring(uiLanString("MSG_SETTING_COLOR_FLAG"));
                       cbColor:AddItem(tostring(usrstrdeplist),0);
                       colortemp[tostring(n)]=1;
                       cbColor:SetText(tostring(usrstrdeplist));
                       frmVedioEx_Display_New[4]=tonumber(n);
                    end
                 end

                 if tonumber(m)==4 then
                    if(not ratetemp[tostring(n)]) then
                        local usrstrratelist="   "..tostring(n)..tostring(uiLanString("MSG_SETTING_REFRESH_HZ"));
                        cbRefresh:AddItem(tostring(usrstrratelist),0);
                        ratetemp[tostring(n)]=1;
                        cbRefresh:SetText(tostring(usrstrratelist));
                        frmVedioEx_Display_New[5]=tonumber(n);
                    end
                 end
             end --end m,n
         end
   end

   if tostring(sel)=="cbColor" then
       local usrstrwh=self:getText();
       local cbColornum;
       _, _, cbColornum = string.find(usrstrwh, "     (%d+)"..tostring(uiLanString("MSG_SETTING_COLOR_FLAG")));
       frmVedioEx_Display_New[4]=tonumber(cbColornum);
       --uiInfo("cbColornum:"..tostring(cbColornum));
   end

   if tostring(sel)=="cbRefresh" then
       local usrstrwh=self:getText();
       local cbRefreshnum;
       _, _, cbRefreshnum = string.find(usrstrwh, "   (%d+)"..tostring(uiLanString("MSG_SETTING_REFRESH_HZ")));
       frmVedioEx_Display_New[5]=tonumber(cbRefreshnum);
       --uiInfo("cbRefresh:"..tostring(cbRefreshnum));
   end


   --高中低
   if tostring(sel)=="cbTexture" then
       local cbTexture_str=self:getText();
       if tostring(cbTexture_str)==uiLanString("MSG_SETTING_QUALITY_HEIGHT") then
           frmVedioEx_Display_New[6]=2;
       elseif tostring(cbTexture_str)==uiLanString("MSG_SETTING_QUALITY_MIDDLE") then
           frmVedioEx_Display_New[6]=1;
       elseif tostring(cbTexture_str)==uiLanString("MSG_SETTING_QUALITY_LOW") then
           frmVedioEx_Display_New[6]=0;
       end
       --uiInfo("frmVedioEx_Display_New[6]:"..tostring(frmVedioEx_Display_New[6]));
   end

   --高中低
   if tostring(sel)=="cbShadow" then
       local cbShadow_str=self:getText();
       if tostring(cbShadow_str)==uiLanString("MSG_SETTING_QUALITY_HEIGHT") then
           frmVedioEx_Display_New[7]=2;
       elseif tostring(cbShadow_str)==uiLanString("MSG_SETTING_QUALITY_MIDDLE") then
           frmVedioEx_Display_New[7]=1;
       elseif tostring(cbShadow_str)==uiLanString("MSG_SETTING_QUALITY_LOW") then
           frmVedioEx_Display_New[7]=0;
       end
       --uiInfo("frmVedioEx_Display_New[7]:"..tostring(frmVedioEx_Display_New[7]));
   end 
end

function frmVedioEx_frmSelect_slvPeople_OnUpdateValue(self)
	frmVedioEx_Display_New[9] = self:getValue();
	local lvPeopleCount = SAPI.GetSibling(self, "lvPeopleCount");
	lvPeopleCount:SetText(tostring(frmVedioEx_Display_New[9]));
end

function frmVedioEx_frmSelect_ckbFullScreen_OnLClick(self)
    local usrFull=self:getChecked();
    local cbColor=SAPI.GetSibling(self,"cbColor");
    local cbRefresh=SAPI.GetSibling(self,"cbRefresh");
    frmVedioEx_Display_New[1]=usrFull;
    if usrFull == false then
         cbColor:Disable();
         cbRefresh:Disable();
     else
         cbColor:Enable();
         cbRefresh:Enable();     
     end
end

function frmVedioEx_frmSelect_ckbCamera_OnLClick(self)
   local usrlock=self:getChecked();
   frmVedioEx_Display_New[8]=usrlock;
end

---下面三个按钮
function frmVedioEx_btDefaultSetting_OnLClick(self)
  --默认设置   
   local usrFull,usrw,usrh,usrdep,usrrate,usrTexture,_,usrShadow,_,usrPeople,_,usrlock=uiVideoGetDefaultConfig();
   frmVedioEx_Set_Content(usrFull,usrw,usrh,usrdep,usrrate,usrTexture,usrShadow,usrlock,usrPeople);
   frmVedioEx_Display_New={usrFull,usrw,usrh,usrdep,usrrate,usrTexture,usrShadow,usrlock,usrPeople};
   frmVedioEx_Show_Content(1);
   --uiInfo("usrShadow Default:"..tostring(usrShadow));
end

function frmVedioEx_btOk_OnLClick(self)
  --按确定
    local frmVedioEx=uiGetglobal("frmVedioEx");    
    local usrFull,usrw,usrh,usrdep,usrrate,usrTexture,usrShadow,usrlock,usrPeople=frmVedioEx_get_Content(1);
    frmVedioEx_Set_Content(usrFull,usrw,usrh,usrdep,usrrate,usrTexture,usrShadow,usrlock,usrPeople);
    usrFull,usrw,usrh,usrdep,usrrate,usrTexture,usrShadow,usrlock,usrPeople=frmVedioEx_get_Content(0);
    frmVedioEx_Show_Content(0);
    if frmVedioEx_Display_New[1]~=frmVedioEx_Display_Old[1] or 
       frmVedioEx_Display_New[2]~=frmVedioEx_Display_Old[2] or 
       frmVedioEx_Display_New[3]~=frmVedioEx_Display_Old[3] or 
       frmVedioEx_Display_New[4]~=frmVedioEx_Display_Old[4] or 
       frmVedioEx_Display_New[5]~=frmVedioEx_Display_Old[5] then
       local strmess=string.format(uiLanString("msg_game_setting_text"),15);
       local msgBox;
       msgBox,frmVedioEx_Display_box =uiMessageBox(strmess,"",true,true,true);
       SAPI.AddDefaultMessageBoxCallBack(msgBox,frmVedioEx_btOk_YES,frmVedioEx_btOk_No,1,frmVedioEx_btOk_Update); --add 
    else
        frmVedioEx:Hide();     

    end
    --uiInfo("usrShadow:"..tostring(usrShadow));    
end

function frmVedioEx_btOk_Update(event, arg, _arg, self, frame)
    local END = frame:Get("END");
    if END == nil then
        END = os.clock() + 15;
        frame:Set("END", END);
    end
    local left = END - os.clock();
    if left <= 0 then
        frame:Hide();
    else
        left = math.ceil(left);
        local strmess=string.format(uiLanString("msg_game_setting_text"),left);
        self:SetMessageText(strmess);
    end
end


--是否确认设备改变
function frmVedioEx_btOk_YES(_,_)
    local frmVedioEx=uiGetglobal("frmVedioEx");
    --uiInfo("Yes");
    frmVedioEx_Display_box=nil;
    frmVedioEx:Hide();
end

function frmVedioEx_btOk_No(_,_)
    local frmVedioEx=uiGetglobal("frmVedioEx");
    frmVedioEx_btCancel_OnLClick();
    --uiInfo("No");
    frmVedioEx_Display_box=nil;
    frmVedioEx:Hide();
end
--[[
function frmVedioEx_frmSelect_OnUpdate(self, delta)
    local d = self:Get(EV_UI_DELTA);
	if d == nil then d = 0 end -- init  the value of EV_UI_DELTA
	d = d + delta;
	if d < 1000 then self:Set(EV_UI_DELTA, d) return end
	self:Delete(EV_UI_DELTA);
	-- 每秒检查一次与NPC之间的距离
    if frmVedioEx_Display_box then
       local tm=tonumber(tonumber(self:Get("TIMERM"))-1);
       local strmess=string.format(uiLanString("msg_game_setting_text"),tm);
       if tm<=1 then
           frmVedioEx_btCancel_OnLClick();
           frmVedioEx_Display_box=nil;
       else
           frmVedioEx_Display_box:SetMessageText(strmess);
       end
    else 
       self:Set("TIMERM",15);
    end
end
--]]
---------------------------------------------------------------------------------

function frmVedioEx_btCancel_OnLClick(self)
  --按取消
  local frmVedioEx=uiGetglobal("frmVedioEx");
  local usrFull,usrw,usrh,usrdep,usrrate,usrTexture,usrShadow,usrlock,usrPeople=frmVedioEx_get_Content(0);
  frmVedioEx_Set_Content(usrFull,usrw,usrh,usrdep,usrrate,usrTexture,usrShadow,usrlock,usrPeople);
  frmVedioEx_Show_Content(2);
  frmVedioEx:Hide();
end

----------------------------------------------------------------------------------

function frmVedioEx_get_Content(bnew)
    local usrFull,usrw,usrh,usrdep,usrrate,usrTexture,usrShadow,usrlock,usrPeople;
    if bnew==1 then
        usrFull=frmVedioEx_Display_New[1];
        usrw=frmVedioEx_Display_New[2];
        usrh=frmVedioEx_Display_New[3];
        usrdep=frmVedioEx_Display_New[4];
        usrrate=frmVedioEx_Display_New[5];
        usrTexture=frmVedioEx_Display_New[6];
        usrShadow=frmVedioEx_Display_New[7];
        usrlock=frmVedioEx_Display_New[8];
		usrPeople=frmVedioEx_Display_New[9];
    else
        usrFull=frmVedioEx_Display_Old[1];
        usrw=frmVedioEx_Display_Old[2];
        usrh=frmVedioEx_Display_Old[3];
        usrdep=frmVedioEx_Display_Old[4];
        usrrate=frmVedioEx_Display_Old[5];
        usrTexture=frmVedioEx_Display_Old[6];
        usrShadow=frmVedioEx_Display_Old[7];
        usrlock=frmVedioEx_Display_Old[8];
		usrPeople=frmVedioEx_Display_Old[9];
    end
    return usrFull,usrw,usrh,usrdep,usrrate,usrTexture,usrShadow,usrlock,usrPeople;
end

function frmVedioEx_Set_Content(usrFull,usrw,usrh,usrdep,usrrate,usrTexture,usrShadow,usrlock,usrPeople)
    uiVideoSetResolution(tonumber(usrw),tonumber(usrh));
    uiVideoSetColorDepth(tonumber(usrdep));
    uiVideoSetRefreshRate(tonumber(usrrate));
    uiVideoSetTextureLevel(tonumber(usrTexture));
    uiVideoSetShadowLevel(tonumber(usrShadow));
    uiVideoSetFullScreen(usrFull);
    uiVideoSetCameraLock(usrlock);
	uiVideoSetScreenUserCount(usrPeople);
    uiVideoEnsureSettings();
end


function frmVedioEx_Show_Content(bDefault)
 --[[
        全屏        屏幕宽        屏幕高        颜色深度        屏幕刷新率        贴图质量        特效质量        阴影质量        后期处理        同屏幕人数
        同屏幕模型距离        镜头锁定
     --]]
     local frmVedioEx=uiGetglobal("frmVedioEx");
     local frmSelect=SAPI.GetChild(frmVedioEx,"frmSelect");
     local cbSize=SAPI.GetChild(frmSelect,"cbSize");
     local cbColor=SAPI.GetChild(frmSelect,"cbColor");
     local cbRefresh=SAPI.GetChild(frmSelect,"cbRefresh");
     local cbTexture=SAPI.GetChild(frmSelect,"cbTexture");
     local cbShadow=SAPI.GetChild(frmSelect,"cbShadow");

     local slvPeople=SAPI.GetChild(frmSelect,"slvPeople"); --slv

     local ckbFullScreen=SAPI.GetChild(frmSelect,"ckbFullScreen"); --CheckButton
     local ckbCamera=SAPI.GetChild(frmSelect,"ckbCamera"); --CheckButton

     cbSize:RemoveAllItems();
     cbColor:RemoveAllItems();
     cbRefresh:RemoveAllItems();
     cbTexture:RemoveAllItems();
     cbShadow:RemoveAllItems();

     cbSize:SetEnableInput(false);
     cbColor:SetEnableInput(false);
     cbRefresh:SetEnableInput(false);
     cbTexture:SetEnableInput(false);
     cbShadow:SetEnableInput(false);

     for i,v in ipairs(frmVedioEx_Display) do
         for j,k in pairs(v) do
             cbSize:AddItem(tostring(j),0);
         end
     end

     local usrFull,usrw,usrh,usrdep,usrrate,usrTexture,_,usrShadow,_,usrPeople,_,usrlock;
     if bDefault==0 then 
         --用户当前配置
         usrFull,usrw,usrh,usrdep,usrrate,usrTexture,_,usrShadow,_,usrPeople,_,usrlock=uiVideoGetUserConfig();
     elseif bDefault==1 then 
         --用户缺省配置
         usrFull,usrw,usrh,usrdep,usrrate,usrTexture,_,usrShadow,_,usrPeople,_,usrlock=uiVideoGetDefaultConfig();
     elseif bDefault==2 then 
         usrFull=frmVedioEx_Display_Old[1];
         usrw=frmVedioEx_Display_Old[2];
         usrh=frmVedioEx_Display_Old[3];
         usrdep=frmVedioEx_Display_Old[4];
         usrrate=frmVedioEx_Display_Old[5];
         usrTexture=frmVedioEx_Display_Old[6];
         usrShadow=frmVedioEx_Display_Old[7];
         usrlock=frmVedioEx_Display_Old[8]; 
         usrPeople=frmVedioEx_Display_Old[9];        
     end    

     --是否全屏
     if usrFull==true then
         ckbFullScreen:SetChecked(true);
     else
         ckbFullScreen:SetChecked(false);
     end
     --是否锁定镜头
     if usrlock==true then         
         ckbCamera:SetChecked(true);
     else
         ckbCamera:SetChecked(false);
     end
	 slvPeople:SetValue(usrPeople);
     local usrstrwh="   "..tostring(usrw).."*"..tostring(usrh);
     if tonumber(usrw)/tonumber(usrh)>1.5 then
         usrstrwh=usrstrwh..tostring(uiLanString("MSG_SETTING_WIDTH_SCREEN_FLAG"));         
     end     
     --查找是否支援此模式
     local usrret=frmVedioEx_bstrIn(frmVedioEx_Display,usrstrwh);
     if usrret>0 then
         --支援

         cbSize:SetText(usrstrwh);
         local usrstrdep="     "..tostring(usrdep)..tostring(uiLanString("MSG_SETTING_COLOR_FLAG"));
         cbColor:SetText(usrstrdep);
         local usrstrrate="   "..tostring(usrrate)..tostring(uiLanString("MSG_SETTING_REFRESH_HZ"));
         cbRefresh:SetText(usrstrrate);

         local colortemp={};
         local ratetemp={};

         for i,v in pairs(frmVedioEx_Display[usrret][usrstrwh]) do --
         --cbColor:AddItem
             for m,n in ipairs(v) do
                 --uiInfo("wj add log["..tostring(m).."]:"..tostring(n));
                 if tonumber(m)==3 then             
                    if(not colortemp[tostring(n)])  then                  
                       local usrstrdeplist="     "..tostring(n)..tostring(uiLanString("MSG_SETTING_COLOR_FLAG"));
                       cbColor:AddItem(tostring(usrstrdeplist),0);
                       colortemp[tostring(n)]=1;
                    end
                 end

                 if tonumber(m)==4 then
                    if(not ratetemp[tostring(n)]) then
                        local usrstrratelist="   "..tostring(n)..tostring(uiLanString("MSG_SETTING_REFRESH_HZ"));
                        cbRefresh:AddItem(tostring(usrstrratelist),0);
                        ratetemp[tostring(n)]=1;
                    end
                 end
             end --end m,n
         end        

         if usrTexture==2 then
             cbTexture:SetText(uiLanString("MSG_SETTING_QUALITY_HEIGHT"));
         elseif usrTexture==1 then
             cbTexture:SetText(uiLanString("MSG_SETTING_QUALITY_MIDDLE"));
         elseif usrTexture==0 then
             cbTexture:SetText(uiLanString("MSG_SETTING_QUALITY_LOW"));
         end
         cbTexture:AddItem(uiLanString("MSG_SETTING_QUALITY_HEIGHT"),0);
         cbTexture:AddItem(uiLanString("MSG_SETTING_QUALITY_MIDDLE"),0);
         cbTexture:AddItem(uiLanString("MSG_SETTING_QUALITY_LOW"),0);

         if usrShadow==2 then
             cbShadow:SetText(uiLanString("MSG_SETTING_QUALITY_HEIGHT"));
         elseif usrShadow==1 then
             cbShadow:SetText(uiLanString("MSG_SETTING_QUALITY_MIDDLE"));
         elseif usrShadow==0 then
             cbShadow:SetText(uiLanString("MSG_SETTING_QUALITY_LOW"));
         end
         cbShadow:AddItem(uiLanString("MSG_SETTING_QUALITY_HEIGHT"),0);
         cbShadow:AddItem(uiLanString("MSG_SETTING_QUALITY_MIDDLE"),0);
         cbShadow:AddItem(uiLanString("MSG_SETTING_QUALITY_LOW"),0);

     end
     if usrFull == false then
         cbColor:Disable();
         cbRefresh:Disable();
     else
         cbColor:Enable();
         cbRefresh:Enable();     
     end

end

function frmVedioEx_Show()

     local frmVedioEx=uiGetglobal("frmVedioEx");
     local iCount=uiVideoGetDisplayModeCount();
     local iNumber=1;
    -- uiInfo("iCount:"..tostring(iCount));

     
     for idx =1 ,iCount,1 do
         local w,h,dp,rate=uiVideoGetDisplayModeInfo(idx-1);

        -- uiInfo("MODE:"..tostring(w).."x"..tostring(h)..tostring(dp).."  "..tostring(rate));
         
         if tonumber(w)>=800 and tonumber(h)>=600 then
             local str="   "..tostring(w).."*"..tostring(h);             
             if w/h>1.5 then
                 str=str..tostring(uiLanString("MSG_SETTING_WIDTH_SCREEN_FLAG"));
             end    

             local ret=frmVedioEx_bstrIn(frmVedioEx_Display,str);
             if ret then
                 if ret == 0 then             
                     --uiInfo("iNumber:"..tostring(iNumber).."str:"..tostring(str));
                     frmVedioEx_Display[iNumber]={};     
                     frmVedioEx_Display[iNumber][str]={};  
                     table.insert(frmVedioEx_Display[iNumber][str],{w,h,dp,rate});
                     iNumber=iNumber+1;
                 else
                     --uiInfo("ret:"..tostring(ret).."str:"..tostring(str));                 
                     table.insert(frmVedioEx_Display[ret][str],{w,h,dp,rate});
                 end                                    
             end
         end --800*600
     end
     --table.sort(frmVedioEx_Display,function(a,b) a<b end);   
     --[[
     for i,v in pairs(frmVedioEx_Display) do
          print("["..tostring(i).."]:",tostring(v));
          for j,k in pairs(v) do
              print("        --["..tostring(j).."]:",tostring(k));
              for m,n in pairs(k) do
                  print("           ----["..tostring(m).."]:",tostring(n));      
                  for p,q in pairs(n) do
                      print("               ------["..tostring(p).."]:",tostring(q));      
                  end                  
              end
          end
     end
     --]]
     frmVedioEx_Show_Content(0);    

end


---------------------------------------------------------------------
---------------------------------------------------------------------
--MUSIC
local AudioEx_SetOld={};
local AudioEx_SetNew={};

function layWorld_frmAudioEx_OnShow(self)
    local fx,vol,b3d=uiAudioGetUserConfig();
    --uiInfo("fx,vol:"..tostring(fx).."  "..tostring(vol));

    AudioEx_SetOld={fx,vol,b3d};
    AudioEx_SetNew={fx,vol,b3d};
    local frmSelect=SAPI.GetChild(self,"frmSelect");
    local slvAudio=SAPI.GetChild(frmSelect,"slvAudio");
    local slvMusic=SAPI.GetChild(frmSelect,"slvMusic");
    local ckbAroundAudio=SAPI.GetChild(frmSelect,"ckbAroundAudio");

    slvAudio:SetData(0,100,AudioEx_SetOld[1]*100);
    slvMusic:SetData(0,100,AudioEx_SetOld[2]*100);
    if AudioEx_SetOld[3] == true then
        ckbAroundAudio:SetChecked(true);
    else
        ckbAroundAudio:SetChecked(false);
    end
end


function layWorld_frmAudioEx_frmSelect_slvAudio_OnUpdateValue(self)
    AudioEx_SetNew[1]=self:getValue()/100;
    uiAudioSetSoundVolumeRate(AudioEx_SetNew[1]);
end

function layWorld_frmAudioEx_frmSelect_slvMusic_OnUpdateValue(self)
    AudioEx_SetNew[2]=self:getValue()/100;
    uiAudioSetMusicVolumeRate(AudioEx_SetNew[2]);
end

function layWorld_frmAudioEx_frmSelect_ckbAroundAudio_OnLClick(self)
    AudioEx_SetNew[3]=self:getChecked();
    uiAudioSet3DSound(AudioEx_SetNew[3]);    
end

function layWorld_frmAudioEx_Show(AudioExSet)
    local frmSelect=uiGetglobal("layWorld.frmAudioEx.frmSelect");
    local slvAudio=SAPI.GetChild(frmSelect,"slvAudio");
    local slvMusic=SAPI.GetChild(frmSelect,"slvMusic");
    local ckbAroundAudio=SAPI.GetChild(frmSelect,"ckbAroundAudio");
    uiAudioSetSoundVolumeRate(AudioExSet[1]);
    uiAudioSetMusicVolumeRate(AudioExSet[2]);
    uiAudioSet3DSound(AudioExSet[3]);   

    slvAudio:SetValue(AudioExSet[1]*100);
    slvMusic:SetValue(AudioExSet[2]*100);
    if AudioExSet[3] == true then
        ckbAroundAudio:SetChecked(true);
    else
        ckbAroundAudio:SetChecked(false);
    end
end

function layWorld_frmAudioEx_btDefaultSetting_OnLClick(self)
    local AudioExSetDef={};
    AudioExSetDef[1],AudioExSetDef[2],AudioExSetDef[3]=uiAudioGetDefaultConfig();
    layWorld_frmAudioEx_Show(AudioExSetDef);    
end

function layWorld_frmAudioEx_btOk_OnLClick(self)
    local frmAudioEx=uiGetglobal("layWorld.frmAudioEx");
    frmAudioEx:Hide();
end

function layWorld_frmAudioEx_btCancel_OnLClick(self)
   layWorld_frmAudioEx_Show(AudioEx_SetOld);    
   local frmAudioEx=uiGetglobal("layWorld.frmAudioEx");
   frmAudioEx:Hide();
end

----------------------------------------------------------------------------
----------------------------------------------------------------------------
--界面设置
function layWorld_frmInterfaceSettingEx_getData(bOld)        
    local temp1={};
    temp1[1]=uiInterfaceGetUserConfig("interface.basic.misc");

    local temp2={};
    temp2[1],temp2[2],temp2[3],temp2[4],temp2[5],temp2[6],temp2[7],temp2[8],temp2[9],temp2[10],temp2[11],temp2[12]=uiInterfaceGetUserConfig("interface.basic.display");

    local temp3={};
    temp3[1]=uiInterfaceGetUserConfig("interface.basic.help");

    local temp4={};
    temp4[1],temp4[2],temp4[3],temp4[4],temp4[5],temp4[6]=uiInterfaceGetUserConfig("interface.advanced.actionbar");

    local temp5={};
    temp5[1],temp5[2],temp5[3],temp5[4],temp5[5],temp5[6],temp5[7],temp5[8],temp5[9]=uiInterfaceGetUserConfig("interface.advanced.floatinfo");


    local temp6={};
    temp6[1],temp6[2],temp6[3],temp6[4],temp6[5],temp6[6],temp6[7]=uiInterfaceGetUserConfig("interface.advanced.messagebox");

    if bOld == true then
        InterfaceSettingEx_SetOld={temp1,temp2,temp3,temp4,temp5,temp6};
    else
        InterfaceSettingEx_SetNew={temp1,temp2,temp3,temp4,temp5,temp6};      
    end
end

function layWorld_frmInterfaceSettingEx_getDefData(index)        
    local temp1={};
    temp1[1]=uiInterfaceGetDefaultConfig("interface.basic.misc");

    local temp2={};
    temp2[1],temp2[2],temp2[3],temp2[4],temp2[5],temp2[6],temp2[7],temp2[8],temp2[9],temp2[10],temp2[11],temp2[12]=uiInterfaceGetDefaultConfig("interface.basic.display");

    local temp3={};
    temp3[1]=uiInterfaceGetDefaultConfig("interface.basic.help");

    local temp4={};
    temp4[1],temp4[2],temp4[3],temp4[4],temp4[5],temp4[6]=uiInterfaceGetDefaultConfig("interface.advanced.actionbar");

    local temp5={};
    temp5[1],temp5[2],temp5[3],temp5[4],temp5[5],temp5[6],temp5[7],temp5[8],temp5[9]=uiInterfaceGetDefaultConfig("interface.advanced.floatinfo");

    local temp6={};
    temp6[1],temp6[2],temp6[3],temp6[4],temp6[5],temp6[6],temp6[7]=uiInterfaceGetDefaultConfig("interface.advanced.messagebox");

    if index==1 then
        InterfaceSettingEx_SetNew[1]=temp1;
        InterfaceSettingEx_SetNew[2]=temp2;
        InterfaceSettingEx_SetNew[3]=temp3;
    elseif index==2 then
        InterfaceSettingEx_SetNew[4]=temp4;
        InterfaceSettingEx_SetNew[5]=temp5;
        InterfaceSettingEx_SetNew[6]=temp6;        
    else
    end
end

function layWorld_frmInterfaceSettingEx_btBasicOpt_OnClick(self)
    local frmInterfaceSettingEx=uiGetglobal("layWorld.frmInterfaceSettingEx");
    layWorld_frmInterfaceSettingEx_Show(1,InterfaceSettingEx_SetNew);
    frmInterfaceSettingEx:Set("PAGE",1);
end

function layWorld_frmInterfaceSettingEx_btSuperOpt_OnClick(self)
    local frmInterfaceSettingEx=uiGetglobal("layWorld.frmInterfaceSettingEx");
    layWorld_frmInterfaceSettingEx_Show(2,InterfaceSettingEx_SetNew);
    frmInterfaceSettingEx:Set("PAGE",2);
end

function layWorld_frmInterfaceSettingEx_Save(InterfaceSettingExSet)
     uiInterfaceSetMapVisibleRate(InterfaceSettingExSet[1][1]);

     uiInterfaceSetUse3DHud(InterfaceSettingExSet[2][1]);
     uiInterfaceSetShowName(InterfaceSettingExSet[2][2]);
     uiInterfaceSetShowSelfName(InterfaceSettingExSet[2][3]);
     uiInterfaceSetShowNpcName(InterfaceSettingExSet[2][4]);
     uiInterfaceSetShowLevel(InterfaceSettingExSet[2][5]);
     uiInterfaceSetShowBlood(InterfaceSettingExSet[2][6]);
     uiInterfaceSetShowTalk(InterfaceSettingExSet[2][7]);
     uiInterfaceSetShowPetMasterName(InterfaceSettingExSet[2][8]);
     uiInterfaceSetShowNpcBlood(InterfaceSettingExSet[2][9]);
     uiInterfaceSetShowFaction(InterfaceSettingExSet[2][10]);
     uiInterfaceSetShowFactionDuty(InterfaceSettingExSet[2][11]);
     uiInterfaceSetShowSmallPet(InterfaceSettingExSet[2][12]);


     uiInterfaceSetShowHelpPrompt(InterfaceSettingExSet[3][1]);

     uiInterfaceSetLockActionBar(InterfaceSettingExSet[4][1]);
     uiInterfaceSetAlwaysShowActionBar(InterfaceSettingExSet[4][2]);
     uiInterfaceSetShowRight1ActionBar(InterfaceSettingExSet[4][3]);
     uiInterfaceSetShowRight2ActionBar(InterfaceSettingExSet[4][4]);
     uiInterfaceSetShowLeftDownActionBar(InterfaceSettingExSet[4][5]);
     uiInterfaceSetShowRightDownActionBar(InterfaceSettingExSet[4][6]);

     uiInterfaceSetOpenUserFloatFightInfo(InterfaceSettingExSet[5][1]);
     uiInterfaceSetFightInfoFloatType(uiLanString(InterfaceSettingExSet[5][2]));
     uiInterfaceSetEffect(InterfaceSettingExSet[5][3]);
     uiInterfaceSetEffectRemove(InterfaceSettingExSet[5][4]);
     uiInterfaceSetCombat(InterfaceSettingExSet[5][5]);
     uiInterfaceSetDodgeParryMiss(InterfaceSettingExSet[5][6]);
     uiInterfaceSetHitPoint(InterfaceSettingExSet[5][7]);
     uiInterfaceSetTargetDamage(InterfaceSettingExSet[5][8]);
     uiInterfaceSetTargetPetDamage(InterfaceSettingExSet[5][9]);
     
     uiInterfaceSetTeachSmall(InterfaceSettingExSet[6][1]);
     uiInterfaceSetTeamSmall(InterfaceSettingExSet[6][2]);
     uiInterfaceSetGuildSmall(InterfaceSettingExSet[6][3]);
     uiInterfaceSetBuySmall(InterfaceSettingExSet[6][4]);
     uiInterfaceSetTouchSmall(InterfaceSettingExSet[6][5]);
     uiInterfaceSetFriendSmall(InterfaceSettingExSet[6][6]);
     uiInterfaceSetDungeonTeamSmall(InterfaceSettingExSet[6][7]);

     uiInterfaceEnsureSettings();
end

--1 ,2 ,3 页
function layWorld_frmInterfaceSettingEx_getChoose(InterfaceSettingExSet)
    local frmInterfaceSettingEx=uiGetglobal("layWorld.frmInterfaceSettingEx");
    local frmBasicOpt=SAPI.GetChild(frmInterfaceSettingEx,"frmBasicOpt");
    local frmSuperOpt=SAPI.GetChild(frmInterfaceSettingEx,"frmSuperOpt");

        local slvMapVisible=SAPI.GetChild(frmBasicOpt,"slvMapVisible");
        local ckbShowName=SAPI.GetChild(frmBasicOpt,"ckbShowName");
        local ckbShowLevel=SAPI.GetChild(frmBasicOpt,"ckbShowLevel");
        local ckbShowBlood=SAPI.GetChild(frmBasicOpt,"ckbShowBlood");
        local ckbShowFaction=SAPI.GetChild(frmBasicOpt,"ckbShowFaction");
        local ckbShowNpcName=SAPI.GetChild(frmBasicOpt,"ckbShowNpcName");
        local ckbShowSelfName=SAPI.GetChild(frmBasicOpt,"ckbShowSelfName");
        local ckbShowSmallpet=SAPI.GetChild(frmBasicOpt,"ckbShowSmallpet");
        --ckbShowFactionIcon
        local ckbShowFactionDuty=SAPI.GetChild(frmBasicOpt,"ckbShowFactionDuty");
        local ckbShowSpeak=SAPI.GetChild(frmBasicOpt,"ckbShowSpeak");
        local ckbShowPetMasterName=SAPI.GetChild(frmBasicOpt,"ckbShowPetMasterName");
        local ckbShowNpcBlood=SAPI.GetChild(frmBasicOpt,"ckbShowNpcBlood");
        local ckbShowHelpPrompt=SAPI.GetChild(frmBasicOpt,"ckbShowHelpPrompt");
        local ckb3DHud=SAPI.GetChild(frmBasicOpt,"ckb3DHud");

        InterfaceSettingExSet[1][1]=slvMapVisible:getValue()/100;     
        InterfaceSettingExSet[2][1]=ckb3DHud:getChecked();
        InterfaceSettingExSet[2][2]=ckbShowName:getChecked();        
        InterfaceSettingExSet[2][3]=ckbShowSelfName:getChecked();    
        InterfaceSettingExSet[2][4]=ckbShowNpcName:getChecked();
        InterfaceSettingExSet[2][5]=ckbShowLevel:getChecked();
        InterfaceSettingExSet[2][6]=ckbShowBlood:getChecked();
        InterfaceSettingExSet[2][7]=ckbShowSpeak:getChecked();
        InterfaceSettingExSet[2][8]=ckbShowPetMasterName:getChecked();
        InterfaceSettingExSet[2][9]=ckbShowNpcBlood:getChecked();
        InterfaceSettingExSet[2][10]=ckbShowFaction:getChecked();
        InterfaceSettingExSet[2][11]=ckbShowFactionDuty:getChecked();
        InterfaceSettingExSet[2][12]=ckbShowSmallpet:getChecked();

        InterfaceSettingExSet[3][1]=ckbShowHelpPrompt:getChecked();

        ------------------------------------------------------------------------------------------
        
        local ckbLockShortcut=SAPI.GetChild(frmSuperOpt,"ckbLockShortcut");
        local ckbAlwaysShowShortcut=SAPI.GetChild(frmSuperOpt,"ckbAlwaysShowShortcut");
        local ckbShowRightShortcut1=SAPI.GetChild(frmSuperOpt,"ckbShowRightShortcut1");
        local ckbShowLeftDownShortcut=SAPI.GetChild(frmSuperOpt,"ckbShowLeftDownShortcut");
        local ckbShowRightDownShortcut=SAPI.GetChild(frmSuperOpt,"ckbShowRightDownShortcut");
        local ckbShowRightShortcut2=SAPI.GetChild(frmSuperOpt,"ckbShowRightShortcut2");

        local ckbEffect=SAPI.GetChild(frmSuperOpt,"ckbEffect");
        local ckbEffectRemove=SAPI.GetChild(frmSuperOpt,"ckbEffectRemove");
        local ckbCombat=SAPI.GetChild(frmSuperOpt,"ckbCombat");
        local ckbDodgeParryMiss=SAPI.GetChild(frmSuperOpt,"ckbDodgeParryMiss");
        local ckbHitPoint=SAPI.GetChild(frmSuperOpt,"ckbHitPoint");
        local ckbTargetDamage=SAPI.GetChild(frmSuperOpt,"ckbTargetDamage");
        local ckbTargetPetDamage=SAPI.GetChild(frmSuperOpt,"ckbTargetPetDamage");
        local ckTeachSmall=SAPI.GetChild(frmSuperOpt,"ckTeachSmall");
        local ckTeamSmall=SAPI.GetChild(frmSuperOpt,"ckTeamSmall");
        local ckGuildSmall=SAPI.GetChild(frmSuperOpt,"ckGuildSmall");
        local ckBuySmall=SAPI.GetChild(frmSuperOpt,"ckBuySmall");
        local ckTouchSmall=SAPI.GetChild(frmSuperOpt,"ckTouchSmall");
        local ckFriendSmall=SAPI.GetChild(frmSuperOpt,"ckFriendSmall");
        local ckPvPSmall=SAPI.GetChild(frmSuperOpt,"ckPvPSmall");
        
        local cbFightInfoFloatType=SAPI.GetChild(frmSuperOpt,"cbFightInfoFloatType");
        local ckbOpenUserFloatFightInfo=SAPI.GetChild(frmSuperOpt,"ckbOpenUserFloatFightInfo");

        InterfaceSettingExSet[4][1]=ckbLockShortcut:getChecked();      --uiInterfaceSetLockActionBar
        InterfaceSettingExSet[4][2]=ckbAlwaysShowShortcut:getChecked();--uiInterfaceSetAlwaysShowActionBar
        InterfaceSettingExSet[4][3]=ckbShowRightShortcut1:getChecked();--uiInterfaceSetShowRight1ActionBar
        InterfaceSettingExSet[4][4]=ckbShowRightShortcut2:getChecked();--uiInterfaceSetShowRight2ActionBar
        InterfaceSettingExSet[4][5]=ckbShowLeftDownShortcut:getChecked();--uiInterfaceSetShowLeftDownActionBar
        InterfaceSettingExSet[4][6]=ckbShowRightDownShortcut:getChecked();--uiInterfaceSetShowRightDownActionBar

        InterfaceSettingExSet[5][1]=ckbOpenUserFloatFightInfo:getChecked();--uiInterfaceSetOpenUserFloatFightInfo               
        
        InterfaceSettingExSet[5][2]=cbFightInfoFloatType:getText();--uiInterfaceSetFightInfoFloatType();

        InterfaceSettingExSet[5][3]=ckbEffect:getChecked();--uiInterfaceSetEffect
        InterfaceSettingExSet[5][4]=ckbEffectRemove:getChecked();--uiInterfaceSetEffectRemove
        InterfaceSettingExSet[5][5]=ckbCombat:getChecked();--uiInterfaceSetCombat
        InterfaceSettingExSet[5][6]=ckbDodgeParryMiss:getChecked();--uiInterfaceSetDodgeParryMiss
        InterfaceSettingExSet[5][7]=ckbHitPoint:getChecked();--uiInterfaceSetHitPoint
        InterfaceSettingExSet[5][8]=ckbTargetDamage:getChecked();--uiInterfaceSetTargetDamage
        InterfaceSettingExSet[5][9]=ckbTargetPetDamage:getChecked();--uiInterfaceSetTargetPetDamage
        InterfaceSettingExSet[6][1]=ckTeachSmall:getChecked();--uiInterfaceSetTeachSmall
        InterfaceSettingExSet[6][2]=ckTeamSmall:getChecked();--uiInterfaceSetTeamSmall
        InterfaceSettingExSet[6][3]=ckGuildSmall:getChecked();--uiInterfaceSetGuildSmall
        InterfaceSettingExSet[6][4]=ckBuySmall:getChecked();--uiInterfaceSetBuySmall
        InterfaceSettingExSet[6][5]=ckTouchSmall:getChecked();--uiInterfaceSetTouchSmall
        InterfaceSettingExSet[6][6]=ckFriendSmall:getChecked();--uiInterfaceSetFriendSmall
        InterfaceSettingExSet[6][7]=ckPvPSmall:getChecked();--uiInterfaceSetDungeonTeamSmall
        ----------------------------------------------------------------------------------------------
end

function layWorld_frmInterfaceSettingEx_Show(index,InterfaceSettingExSet)    
    --layWorld_frmInterfaceSettingEx_Show(1,InterfaceSettingEx_SetOld)
    local frmInterfaceSettingEx=uiGetglobal("layWorld.frmInterfaceSettingEx");
    local frmBasicOpt=SAPI.GetChild(frmInterfaceSettingEx,"frmBasicOpt");
    local frmSuperOpt=SAPI.GetChild(frmInterfaceSettingEx,"frmSuperOpt");
    if index == 1 then
        frmBasicOpt:ShowAndFocus();
        frmSuperOpt:Hide();

        local slvMapVisible=SAPI.GetChild(frmBasicOpt,"slvMapVisible");
        local ckbShowName=SAPI.GetChild(frmBasicOpt,"ckbShowName");
        local ckbShowLevel=SAPI.GetChild(frmBasicOpt,"ckbShowLevel");
        local ckbShowBlood=SAPI.GetChild(frmBasicOpt,"ckbShowBlood");
        local ckbShowFaction=SAPI.GetChild(frmBasicOpt,"ckbShowFaction");
        local ckbShowNpcName=SAPI.GetChild(frmBasicOpt,"ckbShowNpcName");
        local ckbShowSelfName=SAPI.GetChild(frmBasicOpt,"ckbShowSelfName");
        local ckbShowSmallpet=SAPI.GetChild(frmBasicOpt,"ckbShowSmallpet");
        --ckbShowFactionIcon
        local ckbShowFactionDuty=SAPI.GetChild(frmBasicOpt,"ckbShowFactionDuty");
        local ckbShowSpeak=SAPI.GetChild(frmBasicOpt,"ckbShowSpeak");
        local ckbShowPetMasterName=SAPI.GetChild(frmBasicOpt,"ckbShowPetMasterName");
        local ckbShowNpcBlood=SAPI.GetChild(frmBasicOpt,"ckbShowNpcBlood");
        local ckbShowHelpPrompt=SAPI.GetChild(frmBasicOpt,"ckbShowHelpPrompt");
        local ckb3DHud=SAPI.GetChild(frmBasicOpt,"ckb3DHud");

        slvMapVisible:SetData(0,100,InterfaceSettingExSet[1][1]*100);     
        ckb3DHud:SetChecked(InterfaceSettingExSet[2][1]);
        ckbShowName:SetChecked(InterfaceSettingExSet[2][2]);        
        ckbShowSelfName:SetChecked(InterfaceSettingExSet[2][3]);    
        ckbShowNpcName:SetChecked(InterfaceSettingExSet[2][4]);
        ckbShowLevel:SetChecked(InterfaceSettingExSet[2][5]);
        ckbShowBlood:SetChecked(InterfaceSettingExSet[2][6]);
        ckbShowSpeak:SetChecked(InterfaceSettingExSet[2][7]);
        ckbShowPetMasterName:SetChecked(InterfaceSettingExSet[2][8]);
        ckbShowNpcBlood:SetChecked(InterfaceSettingExSet[2][9]);
        ckbShowFaction:SetChecked(InterfaceSettingExSet[2][10]);
        ckbShowFactionDuty:SetChecked(InterfaceSettingExSet[2][11]);
        ckbShowSmallpet:SetChecked(InterfaceSettingExSet[2][12]);

        ckbShowHelpPrompt:SetChecked(InterfaceSettingExSet[3][1]);

        
    elseif index == 2 then
        frmBasicOpt:Hide();
        frmSuperOpt:ShowAndFocus();

        local ckbLockShortcut=SAPI.GetChild(frmSuperOpt,"ckbLockShortcut");
        local ckbAlwaysShowShortcut=SAPI.GetChild(frmSuperOpt,"ckbAlwaysShowShortcut");
        local ckbShowRightShortcut1=SAPI.GetChild(frmSuperOpt,"ckbShowRightShortcut1");
        local ckbShowLeftDownShortcut=SAPI.GetChild(frmSuperOpt,"ckbShowLeftDownShortcut");
        local ckbShowRightDownShortcut=SAPI.GetChild(frmSuperOpt,"ckbShowRightDownShortcut");
        local ckbShowRightShortcut2=SAPI.GetChild(frmSuperOpt,"ckbShowRightShortcut2");

        local ckbEffect=SAPI.GetChild(frmSuperOpt,"ckbEffect");
        local ckbEffectRemove=SAPI.GetChild(frmSuperOpt,"ckbEffectRemove");
        local ckbCombat=SAPI.GetChild(frmSuperOpt,"ckbCombat");
        local ckbDodgeParryMiss=SAPI.GetChild(frmSuperOpt,"ckbDodgeParryMiss");
        local ckbHitPoint=SAPI.GetChild(frmSuperOpt,"ckbHitPoint");
        local ckbTargetDamage=SAPI.GetChild(frmSuperOpt,"ckbTargetDamage");
        local ckbTargetPetDamage=SAPI.GetChild(frmSuperOpt,"ckbTargetPetDamage");
        local ckTeachSmall=SAPI.GetChild(frmSuperOpt,"ckTeachSmall");
        local ckTeamSmall=SAPI.GetChild(frmSuperOpt,"ckTeamSmall");
        local ckGuildSmall=SAPI.GetChild(frmSuperOpt,"ckGuildSmall");
        local ckBuySmall=SAPI.GetChild(frmSuperOpt,"ckBuySmall");
        local ckTouchSmall=SAPI.GetChild(frmSuperOpt,"ckTouchSmall");
        local ckFriendSmall=SAPI.GetChild(frmSuperOpt,"ckFriendSmall");
        local ckPvPSmall=SAPI.GetChild(frmSuperOpt,"ckPvPSmall");
        
        local cbFightInfoFloatType=SAPI.GetChild(frmSuperOpt,"cbFightInfoFloatType");
        local ckbOpenUserFloatFightInfo=SAPI.GetChild(frmSuperOpt,"ckbOpenUserFloatFightInfo");

        ckbLockShortcut:SetChecked(InterfaceSettingExSet[4][1]);      --uiInterfaceSetLockActionBar(
        ckbAlwaysShowShortcut:SetChecked(InterfaceSettingExSet[4][2]);--uiInterfaceSetAlwaysShowActionBar(
        ckbShowRightShortcut1:SetChecked(InterfaceSettingExSet[4][3]);--uiInterfaceSetShowRight1ActionBar(
        ckbShowRightShortcut2:SetChecked(InterfaceSettingExSet[4][4]);--uiInterfaceSetShowRight2ActionBar
        ckbShowLeftDownShortcut:SetChecked(InterfaceSettingExSet[4][5]);--uiInterfaceSetShowLeftDownActionBar
        ckbShowRightDownShortcut:SetChecked(InterfaceSettingExSet[4][6]);--uiInterfaceSetShowRightDownActionBar

        ckbOpenUserFloatFightInfo:SetChecked(InterfaceSettingExSet[5][1]);--uiInterfaceSetOpenUserFloatFightInfo       
        
        cbFightInfoFloatType:RemoveAllItems();
        cbFightInfoFloatType:SetEnableInput(false);
        cbFightInfoFloatType:AddItem(uiLanString("msg_float_info1"),0);
        cbFightInfoFloatType:AddItem(uiLanString("msg_float_info2"),0);
        cbFightInfoFloatType:AddItem(uiLanString("msg_float_info3"),0);        
        cbFightInfoFloatType:SetText(uiLanString(InterfaceSettingExSet[5][2]));--uiInterfaceSetFightInfoFloatType();
       
        ckbEffect:SetChecked(InterfaceSettingExSet[5][3]);--uiInterfaceSetEffect
        ckbEffectRemove:SetChecked(InterfaceSettingExSet[5][4]);--uiInterfaceSetEffectRemove
        ckbCombat:SetChecked(InterfaceSettingExSet[5][5]);--uiInterfaceSetCombat
        ckbDodgeParryMiss:SetChecked(InterfaceSettingExSet[5][6]);--uiInterfaceSetDodgeParryMiss
        ckbHitPoint:SetChecked(InterfaceSettingExSet[5][7]);--uiInterfaceSetHitPoint
        ckbTargetDamage:SetChecked(InterfaceSettingExSet[5][8]);--uiInterfaceSetTargetDamage
        ckbTargetPetDamage:SetChecked(InterfaceSettingExSet[5][9]);--uiInterfaceSetTargetPetDamage
        ckTeachSmall:SetChecked(InterfaceSettingExSet[6][1]);--uiInterfaceSetTeachSmall
        ckTeamSmall:SetChecked(InterfaceSettingExSet[6][2]);--uiInterfaceSetTeamSmall
        ckGuildSmall:SetChecked(InterfaceSettingExSet[6][3]);--uiInterfaceSetGuildSmall
        ckBuySmall:SetChecked(InterfaceSettingExSet[6][4]);--uiInterfaceSetBuySmall
        ckTouchSmall:SetChecked(InterfaceSettingExSet[6][5]);--uiInterfaceSetTouchSmall
        ckFriendSmall:SetChecked(InterfaceSettingExSet[6][6]);--uiInterfaceSetFriendSmall
        ckPvPSmall:SetChecked(InterfaceSettingExSet[6][7]);--uiInterfaceSetDungeonTeamSmall
    else
        return 0;
    end
end

--按下缺省按牛
function layWorld_frmInterfaceSettingEx_btDefaultSetting_OnClick(self)    
    local frmInterfaceSettingEx=uiGetglobal("layWorld.frmInterfaceSettingEx");
    local index=frmInterfaceSettingEx:Get("PAGE");
    layWorld_frmInterfaceSettingEx_getDefData(index);
    layWorld_frmInterfaceSettingEx_Show(index,InterfaceSettingEx_SetNew);
end

--设置完成OK
function layWorld_frmInterfaceSettingEx_btOk_OnClick(self)
    local frmInterfaceSettingEx=uiGetglobal("layWorld.frmInterfaceSettingEx");
    layWorld_frmInterfaceSettingEx_getChoose(InterfaceSettingEx_SetNew);
    layWorld_frmInterfaceSettingEx_Save(InterfaceSettingEx_SetNew);
    frmInterfaceSettingEx:Hide();
end

--点击取消
function layWorld_frmInterfaceSettingEx_btCancel_OnClick(self)
    local frmInterfaceSettingEx=uiGetglobal("layWorld.frmInterfaceSettingEx");
    layWorld_frmInterfaceSettingEx_Save(InterfaceSettingEx_SetOld);
    frmInterfaceSettingEx:Hide();
end

function layWorld_frmInterfaceSettingEx_btreplay_OnClick(self)
    uiInterfaceRestore();
end

function layWorld_frmVedioEx_OnShow(self)
	uiRegisterEscWidget(self);
	local Max = tonumber(uiGetConfigureEntry("video", "ScreenUserCountMax"));
	local Min = tonumber(uiGetConfigureEntry("video", "ScreenUserCountMin"));
	if Max then ScreenUserCountMax = Max end
	if Min then ScreenUserCountMin = Min end
	local frmSelect = SAPI.GetChild(self, "frmSelect");
	local slvPeople = SAPI.GetChild(frmSelect, "slvPeople");
	slvPeople:SetData(ScreenUserCountMin, ScreenUserCountMax, slvPeople:getValue());
end



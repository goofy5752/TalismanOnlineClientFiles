function layWorld_frmGemrefineEx_OnLoad(self)
    self:RegisterScriptEventNotify("EVENT_LocalGurl");
    self:RegisterScriptEventNotify("CEV_REFRESH_REFINESTONE");
    self:RegisterScriptEventNotify("CEV_REFRESH_UPDATESTONE");

    local btgemlowlevel_0 = uiGetglobal("layWorld.frmGemrefineEx.btgemlowlevel_0");
    local btgemlowlevel_1 = uiGetglobal("layWorld.frmGemrefineEx.btgemlowlevel_1");
    local btgemlowlevel_2 = uiGetglobal("layWorld.frmGemrefineEx.btgemlowlevel_2");
    local btgemlowlevel_3 = uiGetglobal("layWorld.frmGemrefineEx.btgemlowlevel_3");
    local btgemlowlevel_4 = uiGetglobal("layWorld.frmGemrefineEx.btgemlowlevel_4");

    local btgeminvocation_0 = uiGetglobal("layWorld.frmGemrefineEx.btgeminvocation_0");
    local btgeminvocation_1 = uiGetglobal("layWorld.frmGemrefineEx.btgeminvocation_1");


    btgemlowlevel_0:Set(EV_UI_SHORTCUT_OWNER_KEY, EV_UI_SHORTCUT_OWNER_STONEREFINE); 
    btgemlowlevel_1:Set(EV_UI_SHORTCUT_OWNER_KEY, EV_UI_SHORTCUT_OWNER_STONEREFINE); 
    btgemlowlevel_2:Set(EV_UI_SHORTCUT_OWNER_KEY, EV_UI_SHORTCUT_OWNER_STONEREFINE);
    btgemlowlevel_3:Set(EV_UI_SHORTCUT_OWNER_KEY, EV_UI_SHORTCUT_OWNER_STONEREFINE); 
    btgemlowlevel_4:Set(EV_UI_SHORTCUT_OWNER_KEY, EV_UI_SHORTCUT_OWNER_STONEREFINE); 


    btgeminvocation_0:Set(EV_UI_SHORTCUT_OWNER_KEY, EV_UI_SHORTCUT_OWNER_STONEREFINE); 
    btgeminvocation_1:Set(EV_UI_SHORTCUT_OWNER_KEY, EV_UI_SHORTCUT_OWNER_STONEREFINE); 

end

function layWorld_frmGemrefineEx_OnEvent(self, event, arg)
    
    local frmGemrefineEx = uiGetglobal("layWorld.frmGemrefineEx");

    local frmCompoundEx = uiGetglobal("layWorld.frmCompoundEx");
    local frmCompoundEx_btgemlowlevel = uiGetglobal("layWorld.frmCompoundEx.btgemlowlevel");

    local frmGemrefineEx_btgemlowlevel_0 = uiGetglobal("layWorld.frmGemrefineEx.btgemlowlevel_0");
    local frmGemrefineEx_btgemlowlevel_1 = uiGetglobal("layWorld.frmGemrefineEx.btgemlowlevel_1");
    local frmGemrefineEx_btgemlowlevel_2 = uiGetglobal("layWorld.frmGemrefineEx.btgemlowlevel_2");
    local frmGemrefineEx_btgemlowlevel_3 = uiGetglobal("layWorld.frmGemrefineEx.btgemlowlevel_3");
    local frmGemrefineEx_btgemlowlevel_4 = uiGetglobal("layWorld.frmGemrefineEx.btgemlowlevel_4");
        
    local frmGemrefineEx_btgeminvocation_0 = uiGetglobal("layWorld.frmGemrefineEx.btgeminvocation_0");
    local frmGemrefineEx_btgeminvocation_1 = uiGetglobal("layWorld.frmGemrefineEx.btgeminvocation_1");
    
    if event == "EVENT_LocalGurl" then
	if tostring(arg[1])=="refinestone" then
	   frmGemrefineEx:ShowAndFocus();
	elseif tostring(arg[1])=="updatestone" then
	     frmCompoundEx:ShowAndFocus();
	end
    elseif event == "CEV_REFRESH_REFINESTONE" then
       
       layWorld_frmGemrefineEx_btgemlowlevel_Refresh(frmGemrefineEx_btgemlowlevel_0);
       layWorld_frmGemrefineEx_btgemlowlevel_Refresh(frmGemrefineEx_btgemlowlevel_1);
       layWorld_frmGemrefineEx_btgemlowlevel_Refresh(frmGemrefineEx_btgemlowlevel_2);
       layWorld_frmGemrefineEx_btgemlowlevel_Refresh(frmGemrefineEx_btgemlowlevel_3);
       layWorld_frmGemrefineEx_btgemlowlevel_Refresh(frmGemrefineEx_btgemlowlevel_4);

       layWorld_frmGemrefineEx_btgeminvocation0_Refresh(frmGemrefineEx_btgeminvocation_0);
       layWorld_frmGemrefineEx_btgeminvocation_Refresh(frmGemrefineEx_btgeminvocation_1);

    elseif event == "CEV_REFRESH_UPDATESTONE" then
       layWorld_frmCompoundEx_btgemlowlevel_Refresh(frmCompoundEx_btgemlowlevel);
    end
end

function layWorld_frmGemrefineEx_OnShow(self)
   uiRegisterEscWidget(self);    
end

function layWorld_frmGemrefineEx_OnHide(self)
    

    local btgeminvocation_0 = uiGetglobal("layWorld.frmGemrefineEx.btgeminvocation_0");
    local btgeminvocation_1 = uiGetglobal("layWorld.frmGemrefineEx.btgeminvocation_1");

    layWorld_frmGemrefineEx_btgemlowlevel_OnDragNull();
   
    

    layWorld_frmGemrefineEx_btgeminvocation_OnDragNull(btgeminvocation_0);
    layWorld_frmGemrefineEx_btgeminvocation0_OnDragNull(btgeminvocation_1);
    uiInfo("OnHide");
end

function layWorld_frmGemrefineEx_btgeminvocation_OnDragIn(self,drag)
     uiInfo("layWorld_frmGemrefineEx_btgeminvocation_OnDragIn");
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
	local drag_out = uiGetglobal(drag)
	if drag_out == nil then return end
	local shortcut_owner = drag_out:Get(EV_UI_SHORTCUT_OWNER_KEY)
	if shortcut_owner == nil then return end
	if allow_owners:IsAllowed(shortcut_owner) == false then return end
	local shortcut_type = drag_out:Get(EV_UI_SHORTCUT_TYPE_KEY)
	if shortcut_type == nil then shortcut_type = 0 end
	local shortcut_objectid = drag_out:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	if shortcut_objectid == nil then shortcut_objectid = 0 end
	local shortcut_classid = drag_out:Get(EV_UI_SHORTCUT_CLASSID_KEY)
	if shortcut_classid == nil then shortcut_classid = 0 end

	uiInfo("layWorld_frmGemrefineEx_btgeminvocation_OnDragIn 1");
	--判断宝石是否可以DragIn
	if uiItemCanStoneRUAmuletDragIn( shortcut_objectid ) == false then
	   return
	end
	local ItemId = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	if ItemId and ItemId > 0 then
		LClass_ItemFreezeManager:Erase(ItemId) -- 解冻
	end
	self:Set(EV_UI_SHORTCUT_TYPE_KEY, shortcut_type)
	self:Set(EV_UI_SHORTCUT_OBJECTID_KEY, shortcut_objectid)
	self:Set(EV_UI_SHORTCUT_CLASSID_KEY, shortcut_classid)
	LClass_ItemFreezeManager:Push(shortcut_objectid) -- 冻结
	--刷新
	uiInfo("layWorld_frmGemrefineEx_btgeminvocation_OnDragIn 2");
	layWorld_frmGemrefineEx_btgeminvocation_Refresh( self )
end



function layWorld_frmGemrefineEx_btgeminvocation0_OnDragIn(self,drag)
     uiInfo("layWorld_frmGemrefineEx_btgeminvocation0_OnDragIn");
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
	local drag_out = uiGetglobal(drag)
	if drag_out == nil then return end
	local shortcut_owner = drag_out:Get(EV_UI_SHORTCUT_OWNER_KEY)
	if shortcut_owner == nil then return end
	if allow_owners:IsAllowed(shortcut_owner) == false then return end
	local shortcut_type = drag_out:Get(EV_UI_SHORTCUT_TYPE_KEY)
	if shortcut_type == nil then shortcut_type = 0 end
	local shortcut_objectid = drag_out:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	if shortcut_objectid == nil then shortcut_objectid = 0 end
	local shortcut_classid = drag_out:Get(EV_UI_SHORTCUT_CLASSID_KEY)
	if shortcut_classid == nil then shortcut_classid = 0 end

	uiInfo("layWorld_frmGemrefineEx_btgeminvocation_OnDragIn 1");
	--判断宝石是否可以DragIn
	if uiItemCanStoneRUNimbusDragIn( shortcut_objectid ) == false then
	   return
	end
	local ItemId = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	if ItemId and ItemId > 0 then
		LClass_ItemFreezeManager:Erase(ItemId) -- 解冻
	end
	self:Set(EV_UI_SHORTCUT_TYPE_KEY, shortcut_type)
	self:Set(EV_UI_SHORTCUT_OBJECTID_KEY, shortcut_objectid)
	self:Set(EV_UI_SHORTCUT_CLASSID_KEY, shortcut_classid)
	LClass_ItemFreezeManager:Push(shortcut_objectid) -- 冻结
	--刷新
	uiInfo("layWorld_frmGemrefineEx_btgeminvocation0_OnDragIn 2");
	layWorld_frmGemrefineEx_btgeminvocation0_Refresh( self )
	layWorld_frmGemrefineEx_Cost();
end

function layWorld_frmGemrefineEx_btgeminvocation_OnDragNull(self)
        local ItemId = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	if ItemId and ItemId > 0 then
		LClass_ItemFreezeManager:Erase(ItemId) -- 解冻
	end
	self:Set(EV_UI_SHORTCUT_TYPE_KEY, 0)
	self:Set(EV_UI_SHORTCUT_OBJECTID_KEY, 0)
	self:Set(EV_UI_SHORTCUT_CLASSID_KEY, 0)
	layWorld_frmGemrefineEx_btgeminvocation_Refresh(self);
	 layWorld_frmGemrefineEx_Cost();
end

function layWorld_frmGemrefineEx_btgeminvocation0_OnDragNull(self)
        local ItemId = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	if ItemId and ItemId > 0 then
		LClass_ItemFreezeManager:Erase(ItemId) -- 解冻
	end
	self:Set(EV_UI_SHORTCUT_TYPE_KEY, 0)
	self:Set(EV_UI_SHORTCUT_OBJECTID_KEY, 0)
	self:Set(EV_UI_SHORTCUT_CLASSID_KEY, 0)
	layWorld_frmGemrefineEx_btgeminvocation0_Refresh(self);
	 layWorld_frmGemrefineEx_Cost();
end

function layWorld_frmGemrefineEx_btgeminvocation_OnHint(self)
     local hint = 0
     local shortcut_type = self:Get(EV_UI_SHORTCUT_TYPE_KEY)
     if shortcut_type == nil then
     elseif shortcut_type == EV_SHORTCUT_OBJECT_ITEM then
	local shortcut_objectid = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	if shortcut_objectid == nil or shortcut_objectid == 0 then
	else
		hint = uiItemGetBagItemHintByObjectId(shortcut_objectid)
	end
     end        
     self:SetHintRichText(hint)
end

function layWorld_frmGemrefineEx_btgeminvocation0_OnHint(self)
     local hint = 0
     local shortcut_type = self:Get(EV_UI_SHORTCUT_TYPE_KEY)
     if shortcut_type == nil then
     elseif shortcut_type == EV_SHORTCUT_OBJECT_ITEM then
	local shortcut_objectid = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	if shortcut_objectid == nil or shortcut_objectid == 0 then
	else
		hint = uiItemGetBagItemHintByObjectId(shortcut_objectid)
	end
     end        
     self:SetHintRichText(hint)
end


function layWorld_frmGemrefineEx_btgemlowlevel_OnDragIn(self,drag)
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
	local drag_out = uiGetglobal(drag)
	if drag_out == nil then return end
	local shortcut_owner = drag_out:Get(EV_UI_SHORTCUT_OWNER_KEY)
	if shortcut_owner == nil then return end
	if allow_owners:IsAllowed(shortcut_owner) == false then return end
	local shortcut_type = drag_out:Get(EV_UI_SHORTCUT_TYPE_KEY)
	if shortcut_type == nil then shortcut_type = 0 end
	local shortcut_objectid = drag_out:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	if shortcut_objectid == nil then shortcut_objectid = 0 end
	local shortcut_classid = drag_out:Get(EV_UI_SHORTCUT_CLASSID_KEY)
	if shortcut_classid == nil then shortcut_classid = 0 end

	uiInfo("abc111");
	--判断宝石是否可以DragIn
	if uiItemCanStoneRUDragIn( shortcut_objectid ) == false then
	   return
	end

	uiInfo("abc112");

	

	local objtab1,objtab2,objtab3,objtab4,objtab5=uiItemGetSameItemInBag( shortcut_objectid );
	uiInfo(tostring(objtab1).."   "..tostring(objtab2).."   "..tostring(objtab3).."   "..tostring(objtab4).."   "..tostring(objtab5));
	if objtab1==nil or objtab2==nil or objtab3==nil or objtab4==nil or objtab5==nil  then	
	    uiClientMsg(uiLanString("msg_stone4"),true);
	    return;
	end

	uiInfo("abc113");

	


	local btgemlowlevel_0=uiGetglobal("layWorld.frmGemrefineEx.btgemlowlevel_0");
	local btgemlowlevel_1=uiGetglobal("layWorld.frmGemrefineEx.btgemlowlevel_1");
	local btgemlowlevel_2=uiGetglobal("layWorld.frmGemrefineEx.btgemlowlevel_2");
	local btgemlowlevel_3=uiGetglobal("layWorld.frmGemrefineEx.btgemlowlevel_3");
	local btgemlowlevel_4=uiGetglobal("layWorld.frmGemrefineEx.btgemlowlevel_4");

        -----------1----------------
	local ItemId1 = btgemlowlevel_0:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	if ItemId1 and ItemId1 > 0 then
		LClass_ItemFreezeManager:Erase(ItemId1) -- 解冻
	end
	btgemlowlevel_0:Set(EV_UI_SHORTCUT_TYPE_KEY, shortcut_type)
	btgemlowlevel_0:Set(EV_UI_SHORTCUT_OBJECTID_KEY,objtab1)  --shortcut_objectid)
	btgemlowlevel_0:Set(EV_UI_SHORTCUT_CLASSID_KEY, shortcut_classid)
	LClass_ItemFreezeManager:Push(objtab1);      --shortcut_objectid) -- 冻结
	layWorld_frmGemrefineEx_btgemlowlevel_Refresh( btgemlowlevel_0 )

	 -----------2----------------
	local ItemId2 = btgemlowlevel_1:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	if ItemId2 and ItemId2 > 0 then
		LClass_ItemFreezeManager:Erase(ItemId2) -- 解冻
	end
	btgemlowlevel_1:Set(EV_UI_SHORTCUT_TYPE_KEY, shortcut_type)
	btgemlowlevel_1:Set(EV_UI_SHORTCUT_OBJECTID_KEY,objtab2)  --shortcut_objectid)
	btgemlowlevel_1:Set(EV_UI_SHORTCUT_CLASSID_KEY, shortcut_classid)
	LClass_ItemFreezeManager:Push(objtab2);      --shortcut_objectid) -- 冻结
	layWorld_frmGemrefineEx_btgemlowlevel_Refresh( btgemlowlevel_1 )

	 -----------3----------------
	local ItemId3= btgemlowlevel_2:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	if ItemId3 and ItemId3 > 0 then
		LClass_ItemFreezeManager:Erase(ItemId3) -- 解冻
	end
	btgemlowlevel_2:Set(EV_UI_SHORTCUT_TYPE_KEY, shortcut_type)
	btgemlowlevel_2:Set(EV_UI_SHORTCUT_OBJECTID_KEY,objtab3)  --shortcut_objectid)
	btgemlowlevel_2:Set(EV_UI_SHORTCUT_CLASSID_KEY, shortcut_classid)
	LClass_ItemFreezeManager:Push(objtab3);      --shortcut_objectid) -- 冻结
	layWorld_frmGemrefineEx_btgemlowlevel_Refresh( btgemlowlevel_2 )



	 -----------4----------------
	local ItemId4 = btgemlowlevel_3:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	if ItemId4 and ItemId4 > 0 then
		LClass_ItemFreezeManager:Erase(ItemId4) -- 解冻
	end
	btgemlowlevel_3:Set(EV_UI_SHORTCUT_TYPE_KEY, shortcut_type)
	btgemlowlevel_3:Set(EV_UI_SHORTCUT_OBJECTID_KEY,objtab4)  --shortcut_objectid)
	btgemlowlevel_3:Set(EV_UI_SHORTCUT_CLASSID_KEY, shortcut_classid)
	LClass_ItemFreezeManager:Push(objtab4);      --shortcut_objectid) -- 冻结
	layWorld_frmGemrefineEx_btgemlowlevel_Refresh( btgemlowlevel_3 )

	 -----------5----------------
	local ItemId5 = btgemlowlevel_4:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	if ItemId5 and ItemId5 > 0 then
		LClass_ItemFreezeManager:Erase(ItemId5) -- 解冻
	end
	btgemlowlevel_4:Set(EV_UI_SHORTCUT_TYPE_KEY, shortcut_type)
	btgemlowlevel_4:Set(EV_UI_SHORTCUT_OBJECTID_KEY,objtab5)  --shortcut_objectid)
	btgemlowlevel_4:Set(EV_UI_SHORTCUT_CLASSID_KEY, shortcut_classid)
	LClass_ItemFreezeManager:Push(objtab5);      --shortcut_objectid) -- 冻结
	layWorld_frmGemrefineEx_btgemlowlevel_Refresh( btgemlowlevel_4 )

	layWorld_frmGemrefineEx_Cost();


	
end

function layWorld_frmGemrefineEx_btgemlowlevel_OnDragNull()
      local btgemlowlevel_0 = uiGetglobal("layWorld.frmGemrefineEx.btgemlowlevel_0");
      local btgemlowlevel_1 = uiGetglobal("layWorld.frmGemrefineEx.btgemlowlevel_1");
      local btgemlowlevel_2 = uiGetglobal("layWorld.frmGemrefineEx.btgemlowlevel_2");
      local btgemlowlevel_3 = uiGetglobal("layWorld.frmGemrefineEx.btgemlowlevel_3");
      local btgemlowlevel_4 = uiGetglobal("layWorld.frmGemrefineEx.btgemlowlevel_4");
        ------1-------
        local ItemId1 = btgemlowlevel_0:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	if ItemId1 and ItemId1 > 0 then
		LClass_ItemFreezeManager:Erase(ItemId1) -- 解冻
	end
	btgemlowlevel_0:Set(EV_UI_SHORTCUT_TYPE_KEY, 0)
	btgemlowlevel_0:Set(EV_UI_SHORTCUT_OBJECTID_KEY, 0)
	btgemlowlevel_0:Set(EV_UI_SHORTCUT_CLASSID_KEY, 0)
	layWorld_frmGemrefineEx_btgemlowlevel_Refresh(btgemlowlevel_0);

	------2-------
        local ItemId2 = btgemlowlevel_1:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	if ItemId2 and ItemId2 > 0 then
		LClass_ItemFreezeManager:Erase(ItemId2) -- 解冻
	end
	btgemlowlevel_1:Set(EV_UI_SHORTCUT_TYPE_KEY, 0)
	btgemlowlevel_1:Set(EV_UI_SHORTCUT_OBJECTID_KEY, 0)
	btgemlowlevel_1:Set(EV_UI_SHORTCUT_CLASSID_KEY, 0)
	layWorld_frmGemrefineEx_btgemlowlevel_Refresh(btgemlowlevel_1);

	------3-------
        local ItemId3 = btgemlowlevel_2:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	if ItemId3 and ItemId3 > 0 then
		LClass_ItemFreezeManager:Erase(ItemId3) -- 解冻
	end
	btgemlowlevel_2:Set(EV_UI_SHORTCUT_TYPE_KEY, 0)
	btgemlowlevel_2:Set(EV_UI_SHORTCUT_OBJECTID_KEY, 0)
	btgemlowlevel_2:Set(EV_UI_SHORTCUT_CLASSID_KEY, 0)
	layWorld_frmGemrefineEx_btgemlowlevel_Refresh(btgemlowlevel_2);

	------4-------
        local ItemId4 = btgemlowlevel_3:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	if ItemId4 and ItemId4 > 0 then
		LClass_ItemFreezeManager:Erase(ItemId4) -- 解冻
	end
	btgemlowlevel_3:Set(EV_UI_SHORTCUT_TYPE_KEY, 0)
	btgemlowlevel_3:Set(EV_UI_SHORTCUT_OBJECTID_KEY, 0)
	btgemlowlevel_3:Set(EV_UI_SHORTCUT_CLASSID_KEY, 0)
	layWorld_frmGemrefineEx_btgemlowlevel_Refresh(btgemlowlevel_3);

	------5-------
        local ItemId5 = btgemlowlevel_4:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	if ItemId5 and ItemId5 > 0 then
		LClass_ItemFreezeManager:Erase(ItemId5) -- 解冻
	end
	btgemlowlevel_4:Set(EV_UI_SHORTCUT_TYPE_KEY, 0)
	btgemlowlevel_4:Set(EV_UI_SHORTCUT_OBJECTID_KEY, 0)
	btgemlowlevel_4:Set(EV_UI_SHORTCUT_CLASSID_KEY, 0)
	layWorld_frmGemrefineEx_btgemlowlevel_Refresh(btgemlowlevel_4);
	layWorld_frmGemrefineEx_Cost();
end

function layWorld_frmGemrefineEx_btgemlowlevel_OnHint(self)
     local hint = 0
     local shortcut_type = self:Get(EV_UI_SHORTCUT_TYPE_KEY)
     if shortcut_type == nil then
     elseif shortcut_type == EV_SHORTCUT_OBJECT_ITEM then
	local shortcut_objectid = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	if shortcut_objectid == nil or shortcut_objectid == 0 then
	else
		hint = uiItemGetBagItemHintByObjectId(shortcut_objectid)
	end
     end        
     self:SetHintRichText(hint)
end


--预览Hint
function layWorld_frmGemrefineEx_btgemhighlevel_OnHint(self)

end


function layWorld_frmGemrefineEx_btOK_OnLClick(self)
   --发服务器消息
   --uiXXXXX
   local btgemlowlevel_0 =uiGetglobal("layWorld.frmGemrefineEx.btgemlowlevel_0");
   local btgemlowlevel_1 =uiGetglobal("layWorld.frmGemrefineEx.btgemlowlevel_1");
   local btgemlowlevel_2 =uiGetglobal("layWorld.frmGemrefineEx.btgemlowlevel_2");
   local btgemlowlevel_3 =uiGetglobal("layWorld.frmGemrefineEx.btgemlowlevel_3");
   local btgemlowlevel_4 =uiGetglobal("layWorld.frmGemrefineEx.btgemlowlevel_4");

   local btgeminvocation_0 = uiGetglobal("layWorld.frmGemrefineEx.btgeminvocation_0"); --Nimbus
   local btgeminvocation_1 = uiGetglobal("layWorld.frmGemrefineEx.btgeminvocation_1"); --
   
   local shortcut_objectid_0 = btgemlowlevel_0:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
   local shortcut_objectid_1 = btgemlowlevel_1:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
   local shortcut_objectid_2 = btgemlowlevel_2:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
   local shortcut_objectid_3 = btgemlowlevel_3:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
   local shortcut_objectid_4 = btgemlowlevel_4:Get(EV_UI_SHORTCUT_OBJECTID_KEY);

   local shortcut_objectid_5 = btgeminvocation_1:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
   local shortcut_objectid_6 = btgeminvocation_0:Get(EV_UI_SHORTCUT_OBJECTID_KEY);

   if shortcut_objectid_0 ~= nil and shortcut_objectid_1 ~= 0 and shortcut_objectid_2 ~= nil and shortcut_objectid_3 ~=0 and shortcut_objectid_4 ~=0 and shortcut_objectid_5 ~=0 then
      
       
       uiItemRefineStone( shortcut_objectid_0 , shortcut_objectid_1,shortcut_objectid_2,shortcut_objectid_3,shortcut_objectid_4,shortcut_objectid_5,shortcut_objectid_6 );
       --uiItemUpdateStone(shortcut_objectid);
   else
       uiClientMsg(uiLanString("msg_stone6"),true);
   end
end

function layWorld_frmGemrefineEx_btCancel_OnLClick(self)
   --关闭界面
   local frmGemrefineEx = uiGetglobal("layWorld.frmGemrefineEx");   
   frmGemrefineEx:Hide();   
end


function layWorld_frmGemrefineEx_btgeminvocation_Refresh(self)
   --刷新
        uiInfo("layWorld_frmGemrefineEx_btgeminvocation_Refresh");
        local shortcut_dbid = self:Get(LOCAL_SHORTCUT_DBID_KEY)
	local shortcut_owner = self:Get(EV_UI_SHORTCUT_OWNER_KEY)
	if shortcut_owner == nil or shortcut_owner ~= EV_UI_SHORTCUT_OWNER_STONEREFINE then return end
	local shortcut_type = self:Get(EV_UI_SHORTCUT_TYPE_KEY)
	local shortcut_objectid = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	local shortcut_classid = self:Get(EV_UI_SHORTCUT_CLASSID_KEY)
	
	local icon = 0 -- 图标地址 -- 指针地址
	local itemCount = 0 -- 道具的当前数量
	local countText = "" -- 道具的当前数量文本
	local bModifyFlag = false

	uiInfo("layWorld_frmGemrefineEx_btgeminvocation_Refresh 1");
	
	if shortcut_type == nil or shortcut_type == EV_SHORTCUT_OBJECT_NONE then
		shortcut_type = EV_SHORTCUT_OBJECT_NONE
	elseif not shortcut_objectid or shortcut_objectid == 0 or shortcut_classid == nil or shortcut_classid == 0 then
	elseif shortcut_type == EV_SHORTCUT_OBJECT_ITEM then
	       
		local tableInfo = uiItemGetItemClassInfoByTableIndex(shortcut_classid) -- 道具的静态信息
		icon = SAPI.GetImage(tableInfo.Icon, 2, 2, -2, -2)        
        	local objInfo = uiItemGetBagItemInfoByObjectId(shortcut_objectid) -- 道具的动态信息    
		if objInfo == nil then		     
	            layWorld_frmGemrefineEx_btgeminvocation_OnDragNull(self);
		    return ;
	        end
		if tableInfo.IsCountable == true then		       
			if objInfo then
				itemCount = objInfo.Count
				--uiInfo("itemCount:"..tostring(itemCount));
				if itemCount > 0 then
					countText = tostring(itemCount)
				end
			end
		end
		bModifyFlag = true
	end
	
	uiInfo("layWorld_frmGemrefineEx_btgeminvocation_Refresh 2");
	-- 操作按钮
	self:ModifyFlag("DragOut_MouseMove", bModifyFlag)
	self:SetNormalImage(icon)
	self:SetUltraTextNormal(countText)


	-------------------------------------------

	
   

end

function layWorld_frmGemrefineEx_btgeminvocation0_Refresh(self)
   --刷新
        uiInfo("layWorld_frmGemrefineEx_btgeminvocation0_Refresh");
        local shortcut_dbid = self:Get(LOCAL_SHORTCUT_DBID_KEY)
	local shortcut_owner = self:Get(EV_UI_SHORTCUT_OWNER_KEY)
	if shortcut_owner == nil or shortcut_owner ~= EV_UI_SHORTCUT_OWNER_STONEREFINE then return end
	local shortcut_type = self:Get(EV_UI_SHORTCUT_TYPE_KEY)
	local shortcut_objectid = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	local shortcut_classid = self:Get(EV_UI_SHORTCUT_CLASSID_KEY)
	
	local icon = 0 -- 图标地址 -- 指针地址
	local itemCount = 0 -- 道具的当前数量
	local countText = "" -- 道具的当前数量文本
	local bModifyFlag = false

	uiInfo("layWorld_frmGemrefineEx_btgeminvocation0_Refresh 1");
	
	if shortcut_type == nil or shortcut_type == EV_SHORTCUT_OBJECT_NONE then
		shortcut_type = EV_SHORTCUT_OBJECT_NONE
	elseif not shortcut_objectid or shortcut_objectid == 0 or shortcut_classid == nil or shortcut_classid == 0 then
	elseif shortcut_type == EV_SHORTCUT_OBJECT_ITEM then
	       
		local tableInfo = uiItemGetItemClassInfoByTableIndex(shortcut_classid) -- 道具的静态信息
		icon = SAPI.GetImage(tableInfo.Icon, 2, 2, -2, -2)        
        	local objInfo = uiItemGetBagItemInfoByObjectId(shortcut_objectid) -- 道具的动态信息    
		if objInfo == nil then		     
	            layWorld_frmGemrefineEx_btgeminvocation0_OnDragNull(self);
		    return ;
	        end
		if tableInfo.IsCountable == true then		       
			if objInfo then
				itemCount = objInfo.Count
				--uiInfo("itemCount:"..tostring(itemCount));
				if itemCount > 0 then
					countText = tostring(itemCount)
				end
			end
		end
		bModifyFlag = true
	end

	
	uiInfo("layWorld_frmGemrefineEx_btgeminvocation0_Refresh 2");
	-- 操作按钮
	self:ModifyFlag("DragOut_MouseMove", bModifyFlag)
	self:SetNormalImage(icon)
	self:SetUltraTextNormal(countText)


	-------------------------------------------

	
   

end

function  layWorld_frmGemrefineEx_Cost()
   uiInfo("layWorld_frmGemrefineEx_Cost");
   local lbnimbus2 = uiGetglobal("layWorld.frmGemrefineEx.lbMoneyLingli.lbnimbus2");
   local edbmoney2 = uiGetglobal("layWorld.frmGemrefineEx.lbMoneyLingli.edbmoney2");

   local btgemlowlevel_0 =uiGetglobal("layWorld.frmGemrefineEx.btgemlowlevel_0");
   local btgeminvocation_0 = uiGetglobal("layWorld.frmGemrefineEx.btgeminvocation_0"); --Nimbus
   local shortcut_objectid_0 = btgemlowlevel_0:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
   local shortcut_objectid_6 = btgeminvocation_0:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
   local costnimbus,costmoney = uiItem_GetRefineCost(shortcut_objectid_0,shortcut_objectid_6);
   if costnimbus==nil or costmoney==nil then
       lbnimbus2:SetText(tostring("0"));   
       --edbmoney2:SetText(tostring("0")..uiLanString("MSG_ITEM_GOLD"));
       return;
   end

   uiInfo("layWorld_frmGemrefineEx_Cost:"..tostring(costnimbus).."   "..tostring(costmoney));
   lbnimbus2:SetText(tostring(costnimbus));   
   edbmoney2:SetRichText(costmoney, false);--SetText(tostring(SAPI.GetMoneyShowStyle(costmoney))..uiLanString("MSG_ITEM_GOLD"));
end

function layWorld_frmGemrefineEx_btgemlowlevel_Refresh(self)
   --刷新
        local shortcut_dbid = self:Get(LOCAL_SHORTCUT_DBID_KEY)
	local shortcut_owner = self:Get(EV_UI_SHORTCUT_OWNER_KEY)
	if shortcut_owner == nil or shortcut_owner ~= EV_UI_SHORTCUT_OWNER_STONEREFINE then return end
	local shortcut_type = self:Get(EV_UI_SHORTCUT_TYPE_KEY)
	local shortcut_objectid = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	local shortcut_classid = self:Get(EV_UI_SHORTCUT_CLASSID_KEY)
	
	local icon = 0 -- 图标地址 -- 指针地址
	local itemCount = 0 -- 道具的当前数量
	local countText = "" -- 道具的当前数量文本
	local bModifyFlag = false
	
	if shortcut_type == nil or shortcut_type == EV_SHORTCUT_OBJECT_NONE then
		shortcut_type = EV_SHORTCUT_OBJECT_NONE
	elseif not shortcut_objectid or shortcut_objectid == 0 or shortcut_classid == nil or shortcut_classid == 0 then
	elseif shortcut_type == EV_SHORTCUT_OBJECT_ITEM then
	       
		local tableInfo = uiItemGetItemClassInfoByTableIndex(shortcut_classid) -- 道具的静态信息
		icon = SAPI.GetImage(tableInfo.Icon, 2, 2, -2, -2)        
        	local objInfo = uiItemGetBagItemInfoByObjectId(shortcut_objectid) -- 道具的动态信息    
		if objInfo == nil then		     
	            layWorld_frmGemrefineEx_btgemlowlevel_OnDragNull();
		    return ;
	        end
		if tableInfo.IsCountable == true then		       
			if objInfo then
				itemCount = objInfo.Count
				--uiInfo("itemCount:"..tostring(itemCount));
				if itemCount > 0 then
					countText = tostring(itemCount)
				end
			end
		end
		bModifyFlag = true
	end
	-- 操作按钮
	self:ModifyFlag("DragOut_MouseMove", bModifyFlag)
	self:SetNormalImage(icon)
	self:SetUltraTextNormal(countText)


	-------------------------------------------

	local btgemhighlevel = SAPI.GetSibling(self, "btgemhighlevel")
	btgemhighlevel:SetNormalImage(0)
	
	if shortcut_objectid and shortcut_objectid ~= 0 then
		local _strImg = uiItem_GetRefineStoneResult(shortcut_objectid)
		if _strImg ~= nil then
			local image_item = SAPI.GetImage(_strImg, 2, 2, -2, -2)
			if image_item ~= nil then
				btgemhighlevel:SetNormalImage(image_item)
			end
		end

		
		local _,richText = uiItem_GetRefineStoneResult(shortcut_objectid)
		btgemhighlevel:SetHintRichText(0)
		if richText ~= nil then
			btgemhighlevel:SetHintRichText(richText)
		end
	end
	
	uiInfo("layWorld_frmGemrefineEx_btgemlowlevel_Refresh");
   

end


----------------------------------------------------------------------------------------------------------------------------------------------------------------
function layWorld_frmCompoundEx_OnLoad(self)
    
    local btgemlowlevel = uiGetglobal("layWorld.frmCompoundEx.btgemlowlevel");
    btgemlowlevel:Set(EV_UI_SHORTCUT_OWNER_KEY, EV_UI_SHORTCUT_OWNER_STONEREFINE);       
end

function layWorld_frmCompoundEx_OnShow(self)
   uiRegisterEscWidget(self);    
end

function layWorld_frmCompoundEx_OnHide(self)
    local btgemlowlevel = uiGetglobal("layWorld.frmCompoundEx.btgemlowlevel");
    layWorld_frmCompoundEx_btgemlowlevel_OnDragNull(btgemlowlevel);
    uiInfo("OnHide");
end



function layWorld_frmCompoundEx_btgemlowlevel_OnDragIn(self,drag)
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
	local drag_out = uiGetglobal(drag)
	if drag_out == nil then return end
	local shortcut_owner = drag_out:Get(EV_UI_SHORTCUT_OWNER_KEY)
	if shortcut_owner == nil then return end
	if allow_owners:IsAllowed(shortcut_owner) == false then return end
	local shortcut_type = drag_out:Get(EV_UI_SHORTCUT_TYPE_KEY)
	if shortcut_type == nil then shortcut_type = 0 end
	local shortcut_objectid = drag_out:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	if shortcut_objectid == nil then shortcut_objectid = 0 end
	local shortcut_classid = drag_out:Get(EV_UI_SHORTCUT_CLASSID_KEY)
	if shortcut_classid == nil then shortcut_classid = 0 end
	--判断宝石是否可以DragIn
	if uiItemCanStoneRUDragIn( shortcut_objectid ) == false then
	   return
	end
	local ItemId = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	if ItemId and ItemId > 0 then
		LClass_ItemFreezeManager:Erase(ItemId) -- 解冻
	end
	self:Set(EV_UI_SHORTCUT_TYPE_KEY, shortcut_type)
	self:Set(EV_UI_SHORTCUT_OBJECTID_KEY, shortcut_objectid)
	self:Set(EV_UI_SHORTCUT_CLASSID_KEY, shortcut_classid)
	LClass_ItemFreezeManager:Push(shortcut_objectid) -- 冻结
	--刷新
	layWorld_frmCompoundEx_btgemlowlevel_Refresh( self )
end

function layWorld_frmCompoundEx_btgemlowlevel_OnDragNull(self)
        local ItemId = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	if ItemId and ItemId > 0 then
		LClass_ItemFreezeManager:Erase(ItemId) -- 解冻
	end
	self:Set(EV_UI_SHORTCUT_TYPE_KEY, 0)
	self:Set(EV_UI_SHORTCUT_OBJECTID_KEY, 0)
	self:Set(EV_UI_SHORTCUT_CLASSID_KEY, 0)
	layWorld_frmCompoundEx_btgemlowlevel_Refresh(self);
end

function layWorld_frmCompoundEx_btgemlowlevel_OnHint(self)
     local hint = 0
     local shortcut_type = self:Get(EV_UI_SHORTCUT_TYPE_KEY)
     if shortcut_type == nil then
     elseif shortcut_type == EV_SHORTCUT_OBJECT_ITEM then
	local shortcut_objectid = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	if shortcut_objectid == nil or shortcut_objectid == 0 then
	else
		hint = uiItemGetBagItemHintByObjectId(shortcut_objectid)
	end
     end        
     self:SetHintRichText(hint)
end


--预览Hint
function layWorld_frmCompoundEx_btgemhighlevel_OnHint(self)

end


function layWorld_frmCompoundEx_btOK_OnLClick(self)
   --发服务器消息
   --uiXXXXX
   local btgemlowlevel =uiGetglobal("layWorld.frmCompoundEx.btgemlowlevel");
   local shortcut_objectid = btgemlowlevel:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
   if shortcut_objectid ~= nil and shortcut_objectid ~= 0 then
       --uiItemRefineStone(shortcut_objectid);
       uiItemUpdateStone(shortcut_objectid);
   end
end

function layWorld_frmCompoundEx_btCancel_OnLClick(self)
   --关闭界面
   local frmCompoundEx = uiGetglobal("layWorld.frmCompoundEx");   
   frmCompoundEx:Hide();   
end

function layWorld_frmCompoundEx_btgemlowlevel_Refresh(self)
   --刷新
        local shortcut_dbid = self:Get(LOCAL_SHORTCUT_DBID_KEY)
	local shortcut_owner = self:Get(EV_UI_SHORTCUT_OWNER_KEY)
	if shortcut_owner == nil or shortcut_owner ~= EV_UI_SHORTCUT_OWNER_STONEREFINE then return end
	local shortcut_type = self:Get(EV_UI_SHORTCUT_TYPE_KEY)
	local shortcut_objectid = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	local shortcut_classid = self:Get(EV_UI_SHORTCUT_CLASSID_KEY)
	
	local icon = 0 -- 图标地址 -- 指针地址
	local itemCount = 0 -- 道具的当前数量
	local countText = "" -- 道具的当前数量文本
	local bModifyFlag = false
	
	if shortcut_type == nil or shortcut_type == EV_SHORTCUT_OBJECT_NONE then
		shortcut_type = EV_SHORTCUT_OBJECT_NONE
	elseif not shortcut_objectid or shortcut_objectid == 0 or shortcut_classid == nil or shortcut_classid == 0 then
	elseif shortcut_type == EV_SHORTCUT_OBJECT_ITEM then
		local tableInfo = uiItemGetItemClassInfoByTableIndex(shortcut_classid) -- 道具的静态信息
		icon = SAPI.GetImage(tableInfo.Icon, 2, 2, -2, -2)
		if tableInfo.IsCountable == true then
			--local objInfo = uiItemGetBagItemInfoByObjectId(shortcut_objectid) -- 道具的动态信息
			itemCount = uiItemGetSameItemInBagCount(shortcut_objectid);
			--if objInfo then
				--itemCount = objInfo.Count
			if itemCount > 0 then
				countText = tostring(itemCount)
			else
			    icon=0;
			    layWorld_frmCompoundEx_btgemlowlevel_OnDragNull(self);
			    return
			end
		end
		bModifyFlag = true
	end
	-- 操作按钮
	self:ModifyFlag("DragOut_MouseMove", bModifyFlag)
	self:SetNormalImage(icon)
	self:SetUltraTextNormal(countText)


	-------------------------------------------

	local btgemhighlevel = SAPI.GetSibling(self, "btgemhighlevel")
	btgemhighlevel:SetNormalImage(0)
	
	if shortcut_objectid and shortcut_objectid ~= 0 then
		local _strImg = uiItem_GetUpdateStoneResult(shortcut_objectid)
		if _strImg ~= nil then
			local image_item = SAPI.GetImage(_strImg, 2, 2, -2, -2)
			if image_item ~= nil then
				btgemhighlevel:SetNormalImage(image_item)
			end
		end

		
		local _,richText = uiItem_GetUpdateStoneResult(shortcut_objectid)
		btgemhighlevel:SetHintRichText(0)
		if richText ~= nil then
			btgemhighlevel:SetHintRichText(richText)
		end
	end





	
	uiInfo("layWorld_frmCompoundEx_btgemlowlevel_Refresh");
   

end

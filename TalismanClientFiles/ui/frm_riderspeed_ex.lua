function layWorld_frmRiderSpeedEx_OnLoad(self)
    self:RegisterScriptEventNotify("EVENT_LocalGurl");
    self:RegisterScriptEventNotify("CEV_REFRESH_RIDERSPEED");
  
    local btgemlowlevel = uiGetglobal("layWorld.frmRiderSpeedEx.btgemlowlevel");
    local btgemhighlevel = uiGetglobal("layWorld.frmRiderSpeedEx.btgemhighlevel");
    btgemlowlevel:Set(EV_UI_SHORTCUT_OWNER_KEY, EV_UI_SHORTCUT_OWNER_ITEM);      
    btgemhighlevel:Set(EV_UI_SHORTCUT_OWNER_KEY, EV_UI_SHORTCUT_OWNER_ITEM);   

end

function layWorld_frmRiderSpeedEx_OnEvent(self, event, arg)
    
    local frmRiderSpeedEx = uiGetglobal("layWorld.frmRiderSpeedEx");   
    local frmRiderSpeedEx_btgemlowlevel = uiGetglobal("layWorld.frmRiderSpeedEx.btgemlowlevel");
    local frmRiderSpeedEx_btgemhighlevel = uiGetglobal("layWorld.frmRiderSpeedEx.btgemhighlevel");
       
    if event == "EVENT_LocalGurl" then
	if tostring(arg[1])=="riderspeed" then
	   frmRiderSpeedEx:ShowAndFocus();	
	end
    elseif event == "CEV_REFRESH_RIDERSPEED" then    
       --uiInfo("CEV_REFRESH_RIDERSPEED")
       layWorld_frmRiderSpeedEx_btgemlowlevel_Refresh(frmRiderSpeedEx_btgemlowlevel);
       layWorld_frmRiderSpeedEx_btgemlowlevel_Refresh(frmRiderSpeedEx_btgemhighlevel);
    end
end

function layWorld_frmRiderSpeedEx_OnShow(self)
   uiRegisterEscWidget(self);    
end

function layWorld_frmRiderSpeedEx_OnHide(self)
    local btgemlowlevel = uiGetglobal("layWorld.frmRiderSpeedEx.btgemlowlevel");
    layWorld_frmRiderSpeedEx_btgemlowlevel_OnDragNull(btgemlowlevel);

    local btgemhighlevel = uiGetglobal("layWorld.frmRiderSpeedEx.btgemhighlevel");
    layWorld_frmRiderSpeedEx_btgemhighlevel_OnDragNull(btgemhighlevel);
    --uiInfo("OnHide");
end

function layWorld_frmRiderSpeedEx_btgemlowlevel_OnDragIn(self,drag)
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
	--判断Rider是否可以DragIn
	--0 表示左边 ，1 表示右边
	if uiItemCanRiderSpeedDragIn( shortcut_objectid, 0 ) == false then
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
	layWorld_frmRiderSpeedEx_btgemlowlevel_Refresh( self )

	
end

function layWorld_frmRiderSpeedEx_btgemhighlevel_OnDragIn(self,drag)
        --uiInfo("layWorld_frmRiderSpeedEx_btgemhighlevel_OnDragIn Enter");
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
	--判断Rider是否可以DragIn
	--0 表示左边 ，1 表示右边
	if uiItemCanRiderSpeedDragIn( shortcut_objectid, 1 ) == false then
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
	layWorld_frmRiderSpeedEx_btgemhighlevel_Refresh( self )

	--uiInfo("layWorld_frmRiderSpeedEx_btgemhighlevel_OnDragIn Leave");
end

function layWorld_frmRiderSpeedEx_btgemlowlevel_OnDragNull(self)
        local ItemId = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	if ItemId and ItemId > 0 then
		LClass_ItemFreezeManager:Erase(ItemId) -- 解冻
	end
	self:Set(EV_UI_SHORTCUT_TYPE_KEY, 0)
	self:Set(EV_UI_SHORTCUT_OBJECTID_KEY, 0)
	self:Set(EV_UI_SHORTCUT_CLASSID_KEY, 0)
	layWorld_frmRiderSpeedEx_btgemlowlevel_Refresh(self);
end

function layWorld_frmRiderSpeedEx_btgemhighlevel_OnDragNull(self)
        local ItemId = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	if ItemId and ItemId > 0 then
		LClass_ItemFreezeManager:Erase(ItemId) -- 解冻
	end
	self:Set(EV_UI_SHORTCUT_TYPE_KEY, 0)
	self:Set(EV_UI_SHORTCUT_OBJECTID_KEY, 0)
	self:Set(EV_UI_SHORTCUT_CLASSID_KEY, 0)
	layWorld_frmRiderSpeedEx_btgemhighlevel_Refresh(self);
end


function layWorld_frmRiderSpeedEx_btgemlowlevel_OnHint(self)
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
function layWorld_frmRiderSpeedEx_btgemhighlevel_OnHint(self)
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


function layWorld_frmRiderSpeedEx_btOK_OnLClick(self)
   --发服务器消息
   --uiXXXXX
   local btgemlowlevel =uiGetglobal("layWorld.frmRiderSpeedEx.btgemlowlevel");
   local shortcut_objectid = btgemlowlevel:Get(EV_UI_SHORTCUT_OBJECTID_KEY);

   local btgemhighlevel = uiGetglobal("layWorld.frmRiderSpeedEx.btgemhighlevel");
   local shortcut_objectid_high = btgemhighlevel:Get(EV_UI_SHORTCUT_OBJECTID_KEY);

   if shortcut_objectid ~= nil and shortcut_objectid ~= 0 then
       uiItemRiderSpeed(shortcut_objectid,shortcut_objectid_high);      
   end
end

function layWorld_frmRiderSpeedEx_btCancel_OnLClick(self)
   --关闭界面
   local frmRiderSpeedEx = uiGetglobal("layWorld.frmRiderSpeedEx");   
   frmRiderSpeedEx:Hide();   
end

function layWorld_frmRiderSpeedEx_btgemhighlevel_Refresh(self)
     local shortcut_dbid = self:Get(LOCAL_SHORTCUT_DBID_KEY)
	local shortcut_owner = self:Get(EV_UI_SHORTCUT_OWNER_KEY)
	if shortcut_owner == nil or shortcut_owner ~= EV_UI_SHORTCUT_OWNER_ITEM then return end
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
		    layWorld_frmRiderSpeedEx_btgemhighlevel_OnDragNull(self);
		end		
		if tableInfo.IsCountable == true then	
		        
			if objInfo then
				itemCount = objInfo.Count
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

	
end

function layWorld_frmRiderSpeedEx_btgemlowlevel_Refresh(self)
   --刷新
        local shortcut_dbid = self:Get(LOCAL_SHORTCUT_DBID_KEY)
	local shortcut_owner = self:Get(EV_UI_SHORTCUT_OWNER_KEY)
	if shortcut_owner == nil or shortcut_owner ~= EV_UI_SHORTCUT_OWNER_ITEM then return end
	local shortcut_type = self:Get(EV_UI_SHORTCUT_TYPE_KEY)
	local shortcut_objectid = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	local shortcut_classid = self:Get(EV_UI_SHORTCUT_CLASSID_KEY)
	
	local icon = 0 -- 图标地址 -- 指针地址
	local itemCount = 0 -- 道具的当前数量
	local countText = "" -- 道具的当前数量文本
	local bModifyFlag = false
	
	if shortcut_type == nil or shortcut_type == EV_SHORTCUT_OBJECT_NONE then
		shortcut_type = EV_SHORTCUT_OBJECT_NONE
		--uiInfo("COME1");
	elseif not shortcut_objectid or shortcut_objectid == 0 or shortcut_classid == nil or shortcut_classid == 0 then
	        uiInfo("COME2");
	elseif shortcut_type == EV_SHORTCUT_OBJECT_ITEM then
	       
		local tableInfo = uiItemGetItemClassInfoByTableIndex(shortcut_classid) -- 道具的静态信息
		icon = SAPI.GetImage(tableInfo.Icon, 2, 2, -2, -2)        
        	local objInfo = uiItemGetBagItemInfoByObjectId(shortcut_objectid) -- 道具的动态信息    
		if objInfo == nil then		     
	            layWorld_frmRiderSpeedEx_btgemlowlevel_OnDragNull(self);
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
	

	

end


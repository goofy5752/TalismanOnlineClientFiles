--*************************************************************************************************************
-- Followed by datas and structs

local shortCutOwners =
{
	EV_UI_SHORTCUT_OWNER_ITEM,
	EV_UI_SHORTCUT_OWNER_GEMSTONEINLAY,
	isHoleAllowed = function( self, owner )
						if owner == nil then 
							return false 
						end						
						if EV_UI_SHORTCUT_OWNER_ITEM == owner or EV_UI_SHORTCUT_OWNER_GEMSTONEINLAY == owner then
							return true
						end
						return false
					end
	,
	isEquipAllowed = function( self, owner )
						if owner == nil then 
							return false 
						end						
						if EV_UI_SHORTCUT_OWNER_ITEM == owner then
							return true
						end
						return false
					end
}


local holePosition = {  { {132,175} }, 
						{ { 88,140}, {177,140} },
						{ { 88,140}, {177,140}, {132,190} },
						{ {132,142}, { 86,187}, {177,187}, {133,234} },
						{ { 86,146}, {177,146}, {132,190}, { 86,234}, {177,234} },
						{ { 82,154}, {132,154}, {179,154}, { 82,203}, {132,203}, {179,203} },
						{ {132,130}, { 82,154}, {132,178}, {179,154}, { 82,204}, {132,230}, {179,204} },
						{ { 77,154}, {132,154}, {184,154}, {105,195}, {158,195}, { 77,237}, {132,237}, {184,237} }
					 }

--*************************************************************************************************************
-- Followed by common functions

--[ Get child widget by name ]
function layWorld_frmGemstoneInlay_getWidgetByName( name )
	return SAPI.GetChild ( uiGetglobal( "layWorld.FORM_GEMSTONE_INLAY" ), name )
end

--[ Update one button by data which been binded on it ]
function layWorld_frmGemstoneInlay_btnUpdate( btnNeedUpdate )
	local shortcut_dbid = btnNeedUpdate:Get(LOCAL_SHORTCUT_DBID_KEY)
	local shortcut_owner = btnNeedUpdate:Get(EV_UI_SHORTCUT_OWNER_KEY)
	if shortcut_owner == nil or shortcut_owner ~= EV_UI_SHORTCUT_OWNER_GEMSTONEINLAY then 
		return 
	end
	local shortcut_type = btnNeedUpdate:Get(EV_UI_SHORTCUT_TYPE_KEY)
	local shortcut_objectid = btnNeedUpdate:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	local shortcut_classid = btnNeedUpdate:Get(EV_UI_SHORTCUT_CLASSID_KEY)
	
	local icon = 0 -- 图标地址 -- 指针地址
	local itemCount = 0 -- 道具的当前数量
	--local countText = "" -- 道具的当前数量文本
	local bModifyFlag = false
	
	if shortcut_type == nil or shortcut_type == EV_SHORTCUT_OBJECT_NONE then
		shortcut_type = EV_SHORTCUT_OBJECT_NONE
	elseif not shortcut_objectid or shortcut_objectid == 0 or shortcut_classid == nil or shortcut_classid == 0 then
	elseif shortcut_type == EV_SHORTCUT_OBJECT_ITEM then
		local tableInfo = uiItemGetItemClassInfoByTableIndex(shortcut_classid) -- 道具的静态信息
		icon = SAPI.GetImage(tableInfo.Icon, 2, 2, -2, -2)
		--[[if tableInfo.IsCountable == true then
			local objInfo = uiItemGetBagItemInfoByObjectId(shortcut_objectid) -- 道具的动态信息
			if objInfo then
				itemCount = objInfo.Count
				if itemCount > 0 then
					countText = tostring(itemCount)
				end
			end
		end]]
		bModifyFlag = true
	end
	-- 操作按钮
	btnNeedUpdate:ModifyFlag("DragOut_MouseMove", bModifyFlag)
	btnNeedUpdate:SetNormalImage(icon)
	--btnNeedUpdate:SetUltraTextNormal(countText)
end

--[ Refresh the gemstone hole of button ]
function layWorld_frmGemstoneInlay_btnHole_Refresh(self)
	layWorld_frmGemstoneInlay_btnUpdate( self )
end

--[ Clear the gemstone hole of button ]
function layWorld_frmGemstoneInlay_btnHole_Clear( self )
	local shortCutItemID = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	if shortCutItemID and shortCutItemID > 0 then
		LClass_ItemFreezeManager:Erase( shortCutItemID ) -- 解冻
	end
	self:Set( "OPENED", false )
	self:Set( "INLAYED", false )
	self:ModifyFlag("DragIn", true)
	self:ModifyFlag("DragOut", false)
	self:Set( "CHECKED", false )
	self:Set(EV_UI_SHORTCUT_TYPE_KEY, 0)
	self:Set(EV_UI_SHORTCUT_OBJECTID_KEY, 0)
	self:Set(EV_UI_SHORTCUT_CLASSID_KEY, 0)
	layWorld_frmGemstoneInlay_btnHole_Refresh(self)
end

--[ Reset the content ]
function layWorld_frmGemstoneInlay_reset()
	local mWidgetName = ""
	local mWidget = nil
	for i=1, 8 do
		-- Clear button holes
		mWidgetName = "BTN_HOLE_"..tostring(i)
		mWidget = layWorld_frmGemstoneInlay_getWidgetByName( mWidgetName )
		if mWidget ~= nil then
			--layWorld_frmGemstoneInlay_btnHole_OnDragNull( mWidget )			
			layWorld_frmGemstoneInlay_btnHole_Clear( mWidget )
			mWidget:Hide()
		end
		-- Show the closed mask lable
		mWidgetName = "LABLE_HOLE_MASK_CLOSED_"..tostring(i)
		mWidget = layWorld_frmGemstoneInlay_getWidgetByName( mWidgetName )
		if mWidget ~= nil then
			mWidget:Hide()
		end
		-- Hide the inlayed mask lable
		mWidgetName = "LABLE_HOLE_MASK_INLAYED_"..tostring(i)
		mWidget = layWorld_frmGemstoneInlay_getWidgetByName( mWidgetName )
		if mWidget ~= nil then
			mWidget:Hide()
		end
		-- Hide the checked mask lable
		mWidgetName = "LABLE_HOLE_MASK_CHECKED_"..tostring(i)
		mWidget = layWorld_frmGemstoneInlay_getWidgetByName( mWidgetName )
		if mWidget ~= nil then
			mWidget:Hide()
		end
		-- Show the desc info
		mWidget = layWorld_frmGemstoneInlay_getWidgetByName( "EDIT_DESCRIBE" )
		if mWidget ~= nil then
			mWidget:Show()
		end
		-- Hide the money info
		mWidget = layWorld_frmGemstoneInlay_getWidgetByName( "LABLE_NEED_MONEY" )
		if mWidget ~= nil then
			mWidget:Hide()
		end
	end
	
	-- disable the operating buttons
	--[[mWidget = layWorld_frmGemstoneInlay_getWidgetByName( "BTN_SLOT" )
	mWidget:Disable()]]
	mWidget = layWorld_frmGemstoneInlay_getWidgetByName( "BTN_INLAY" )
	mWidget:Disable()
	mWidget = layWorld_frmGemstoneInlay_getWidgetByName( "BTN_GETOUT" )
	mWidget:Disable()
	
	-- clear equip image
	mWidget = layWorld_frmGemstoneInlay_getWidgetByName( "BTN_EQUIP" )
	local shortCutItemID = mWidget:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	if shortCutItemID and shortCutItemID > 0 then
		LClass_ItemFreezeManager:Erase( shortCutItemID )
	end
	mWidget:Set(EV_UI_SHORTCUT_TYPE_KEY, 0)
	mWidget:Set(EV_UI_SHORTCUT_OBJECTID_KEY, 0)
	mWidget:Set(EV_UI_SHORTCUT_CLASSID_KEY, 0)
	layWorld_frmGemstoneInlay_btnUpdate(mWidget)
	
	-- clear some descriptors
	--[[mWidget = layWorld_frmGemstoneInlay_getWidgetByName( "LABLE_HOLE_NUM" )
	mWidget:SetText( uiLanString("gemstone_inlay_info1") )]]
	mWidget = layWorld_frmGemstoneInlay_getWidgetByName( "LABLE_NEED_MONEY" )
	mWidget:SetText( uiLanString("gemstone_inlay_info2") )
end

--[ Money ( number, monetary unit is copper ) changes to string ]
function layWorld_frmGemstoneInlay_moneyChangeToString( uMoney )
	local mGold = math.floor( uMoney/10000 )
	local mSliver = math.floor( ( uMoney - mGold*10000 )/100 )
	local mCopper = uMoney - mGold*10000 - mSliver*100
	local mRet = ""
	if mGold>0 then
		mRet = tostring(mGold)..uiLanString("gemstone_inlay_units_golden")
	end
	if mSliver>0 then
		mRet = mRet..tostring(mSliver)..uiLanString("gemstone_inlay_units_sliver")
	end
	if mCopper>0 then
		mRet = mRet..tostring(mCopper)..uiLanString("gemstone_inlay_units_copper")
	end	
	return mRet
end

--[ Set some information by equipment ]
function layWorld_frmGemstoneInlay_initInfoByEquipment()    
	--uiInfo( "layWorld_frmGemstoneInlay_initInfoByEquipment begin......" )
	local mBtnEquip = layWorld_frmGemstoneInlay_getWidgetByName("BTN_EQUIP")
	local mObjID = mBtnEquip:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	--uiInfo( "mObjID: "..tostring(mObjID) )
	if nil==mObjID or mObjID<=0 then		
		return
	end
	--[[local mCanInlayHolesNum = uiItemGetCanStickHoleCnt( mObjID ) - uiItemGetStickHoleCnt( mObjID )	
	local mLabNum = layWorld_frmGemstoneInlay_getWidgetByName("LABLE_HOLE_NUM")	
	if mCanInlayHolesNum <0 then
            mCanInlayHolesNum = 0;
	end]]
	--mLabNum:SetText( uiLanString("gemstone_inlay_info3")..tostring(mCanInlayHolesNum) )
	--[[local mNeedMoney = uiItemGetStickHoleCost( mObjID )
	if mNeedMoney>0 then
		local mLabMoney = layWorld_frmGemstoneInlay_getWidgetByName("LABLE_NEED_MONEY")
		mLabMoney:Show()
		mLabMoney:SetText( uiLanString("gemstone_inlay_info4")..layWorld_frmGemstoneInlay_moneyChangeToString(mNeedMoney) )
	end	]]
	-- Set the slot button
	--[[local mBtnSlot = layWorld_frmGemstoneInlay_getWidgetByName( "BTN_SLOT" )
	if mCanInlayHolesNum<= 0 then
		mBtnSlot:Disable()
	else
		mBtnSlot:Enable()
	end]]
	
	--uiInfo( "layWorld_frmGemstoneInlay_initInfoByEquipment End......" )	
end

--[ Set the holes state by equipment ]
function layWorld_frmGemstoneInlay_initHolesByEquipment()
	--uiInfo( "layWorld_frmGemstoneInlay_initHolesByEquipment begin......" )
	-- Traverse the holes
	local mWidget=nil
	local bOpened = false
	local bInlayed = false
	local uGemstoneClassID = 0
	local uEquipObjID = 0
	mWidget = layWorld_frmGemstoneInlay_getWidgetByName( "BTN_EQUIP" )
	if nil ~= mWidget then
		uEquipObjID = mWidget:Get( EV_UI_SHORTCUT_OBJECTID_KEY )
	end
	if nil==uEquipObjID or uEquipObjID==0 then
		return
	end
	local mCan = uiItemGetCanStickHoleCnt(uEquipObjID)
	local mAlr = uiItemGetStickHoleCnt( uEquipObjID )
	local mMaxCnt = 0
	if mCan>mAlr then
		mMaxCnt = mCan
	else
		mMaxCnt = mAlr
	end
	if mMaxCnt>0 then
		mWidget = layWorld_frmGemstoneInlay_getWidgetByName( "EDIT_DESCRIBE" )
		if mWidget ~= nil then
			mWidget:Hide()
		end
	end
	for idx=1, 8 do
		local mBtnWidget = layWorld_frmGemstoneInlay_getWidgetByName( "BTN_HOLE_"..tostring(idx) )
		local mLabCheckedMask = layWorld_frmGemstoneInlay_getWidgetByName( "LABLE_HOLE_MASK_CHECKED_"..tostring(idx) )
		local mLabInlayedMask = layWorld_frmGemstoneInlay_getWidgetByName( "LABLE_HOLE_MASK_INLAYED_"..tostring(idx) )
		local mLabClosedMask = layWorld_frmGemstoneInlay_getWidgetByName( "LABLE_HOLE_MASK_CLOSED_"..tostring(idx) )
		if idx<=mMaxCnt then
			mBtnWidget:Show()
			mLabCheckedMask:Show()
			mLabInlayedMask:Show()
			mLabClosedMask:Show()
			mBtnWidget:MoveTo( holePosition[mMaxCnt][idx][1], holePosition[mMaxCnt][idx][2] )
		else
			mLabCheckedMask:Hide()
			mLabInlayedMask:Hide()
			mLabClosedMask:Hide()
			mBtnWidget:Hide()
		end
	end
	
	for idx=1, 8 do
		bOpened, bInlayed, uGemstoneClassID = false, false, 0
		bOpened, bInlayed, uGemstoneClassID = uiItemGetHoleState( uEquipObjID, idx-1 )
		--uiInfo( "idx:"..tostring(idx) )
		--uiInfo( "bOpened:"..tostring(bOpened) )
		--uiInfo( "bInlayed:"..tostring(bInlayed) )
		--uiInfo( "uGemstoneClassID:"..tostring(uGemstoneClassID) )
		local mBtnWidget = layWorld_frmGemstoneInlay_getWidgetByName( "BTN_HOLE_"..tostring(idx) )
		if mBtnWidget:getVisible() then
			if bInlayed~=0 then
				--uiInfo( "bInlayed: true" ) 
				layWorld_frmGemstoneInlay_setHole( idx, bOpened~=0, uGemstoneClassID )
			else
				--uiInfo( "bInlayed: false" ) 
				layWorld_frmGemstoneInlay_btnHole_Refresh(mBtnWidget)
				mBtnWidget:Set( "INLAYED", false )
				mBtnWidget:Set( "OPENED",  bOpened~=0 )
				mBtnWidget:Set( "CHECKED", false )
				layWorld_frmGemstoneInlay_updateHoleMask(idx)
				--layWorld_frmGemstoneInlay_setHole( idx, bOpened~=0, mBtnWidget:Get( EV_UI_SHORTCUT_OBJECTID_KEY ) )
				--mBtnWidget:Set( "INLAYED", false )
			end
		end
	end
	--uiInfo( "layWorld_frmGemstoneInlay_initHolesByEquipment end......" )
end

--[ Set Mask lable on hole ]
function layWorld_frmGemstoneInlay_setHoleMask( iIdx, bOpened, bInlayed, bChecked )
	if iIdx<1 or iIdx>8 then
		return
	end	
	local mLabClosedMask = layWorld_frmGemstoneInlay_getWidgetByName( "LABLE_HOLE_MASK_CLOSED_"..tostring(iIdx) )
	local mLabInlayedMask = layWorld_frmGemstoneInlay_getWidgetByName( "LABLE_HOLE_MASK_INLAYED_"..tostring(iIdx) )
	local mLabCheckedMask = layWorld_frmGemstoneInlay_getWidgetByName( "LABLE_HOLE_MASK_CHECKED_"..tostring(iIdx) )
	local mBtnWidget = layWorld_frmGemstoneInlay_getWidgetByName( "BTN_HOLE_"..tostring(iIdx) )
	if bOpened == false then
		mLabClosedMask:Show()
		mLabInlayedMask:Hide()
		mLabCheckedMask:Hide()
	else
		mLabClosedMask:Hide()
		if bChecked then
			mLabCheckedMask:Show()
		else
			mLabCheckedMask:Hide()
		end
		if bInlayed then
			--uiInfo( "layWorld_frmGemstoneInlay_setHoleMask...Inlayed catched!" )
			mLabInlayedMask:Show()
		else
			mLabInlayedMask:Hide()
		end
	end
	
	if mBtnWidget:getVisible()==false then
		mLabClosedMask:Hide()
		mLabInlayedMask:Hide()
		mLabCheckedMask:Hide()		
	end
end

--[ Set holes, if in the positon iIdx has been opened, show the button, otherwise, show the check button. The parameter objectid is the gemstone's class id ]
function layWorld_frmGemstoneInlay_setHole( iIdx, bOpened, uObjClassID )
	if iIdx<1 or iIdx>8 then
		return
	end
	local bInlayed = ( nil~=uObjClassID and 0~=uObjClassID )
	--uiInfo("bOpened, bInlayed:"..tostring(bOpened)..","..tostring(bInlayed))
	layWorld_frmGemstoneInlay_setHoleMask( iIdx, bOpened, bInlayed, false )
	local mBtnWidget = layWorld_frmGemstoneInlay_getWidgetByName( "BTN_HOLE_"..tostring(iIdx) )
	mBtnWidget:Set( "OPENED", bOpened )
	mBtnWidget:Set( "INLAYED", bInlayed )
	if bOpened then
		if bInlayed then
			mBtnWidget:ModifyFlag("DragOut", false)
			mBtnWidget:ModifyFlag("DragIn", false)
		else
			mBtnWidget:ModifyFlag("DragOut", false)
			mBtnWidget:ModifyFlag("DragIn", true)
		end
	end
	mBtnWidget:Set( "CHECKED", false )
	mBtnWidget:Set(EV_UI_SHORTCUT_TYPE_KEY, EV_SHORTCUT_OBJECT_ITEM)
	if bOpened then
		-- If it has gemstone
		if bInlayed then
			-- Insert the normal image
			local tableInfo = uiItemGetItemClassInfoByTableIndex( uObjClassID )
			local mIcon = SAPI.GetImage( tableInfo.Icon, 2, 2, -2, -2 )
			mBtnWidget:SetNormalImage( mIcon )
			mBtnWidget:Set(EV_UI_SHORTCUT_CLASSID_KEY, uObjClassID)
		else
			-- clear the normal image
			mBtnWidget:SetNormalImage( nil )
		end
	end
end

--[ Get the hole's index by afford name ]
function layWorld_frmGemstoneInlay_holeNameToIndex( strName )
	for idx=1, 8 do
		if strName == "BTN_HOLE_"..tostring(idx) then
			return idx
		end
	end
	return 0
end

--[ Get checked hole's index ]
function layWorld_frmGemstoneInlay_getCheckedHoleIndex()
	local mWidget = nil
	for idx=1, 8 do
		mWidget = layWorld_frmGemstoneInlay_getWidgetByName( "BTN_HOLE_"..tostring(idx) )
		if mWidget:getVisible() and mWidget:Get( "CHECKED" ) then
			return idx
		end
	end	
	return 0
end

--[ When we put or get out gemstone from hole, we must update our inlay button ]
function layWorld_frmGemstoneInlay_updateInlayButtonState()
	local mWidget = nil
	local bEnable = false
	local mGemstoneID = nil
	for uIdx=1, 8 do
		mWidget = layWorld_frmGemstoneInlay_getWidgetByName( "BTN_HOLE_"..tostring(uIdx) )
		mGemstoneID = mWidget:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
		if mWidget:Get( "INLAYED" )==false and mGemstoneID~=nil and mGemstoneID>0 then
			bEnable = true
			break
		end
	end
	mWidget = layWorld_frmGemstoneInlay_getWidgetByName( "BTN_INLAY" )
	if bEnable then
		mWidget:Enable()
	else
		mWidget:Disable()
	end
end

--[ Update one hole's mask image by data binded on it ]
function layWorld_frmGemstoneInlay_updateHoleMask( iIdx )
	if iIdx<1 or iIdx>8 then
		return
	end
	local mWidget = nil
	mWidget = layWorld_frmGemstoneInlay_getWidgetByName( "BTN_HOLE_"..tostring(iIdx) )
	layWorld_frmGemstoneInlay_setHoleMask( iIdx, mWidget:Get("OPENED"), mWidget:Get("INLAYED"), mWidget:Get("CHECKED") )
end

--*************************************************************************************************************
-- Followed by widgets functions

function layWorld_frmGemstoneInlay_OnLoad( self )
	self:RegisterScriptEventNotify( "CEV_REFRESH_STICKHOLE" )
	self:RegisterScriptEventNotify( "CEV_REFRESH_STONE" )
	self:RegisterScriptEventNotify( "EVENT_LocalGurl" )	
end

function layWorld_frmGemstoneInlay_OnShow( self )
	uiRegisterEscWidget(self)
	self:ShowAndFocus()
	layWorld_frmGemstoneInlay_reset()
end

function layWorld_frmGemstoneInlay_OnHide( self )
	layWorld_frmGemstoneInlay_reset()
end

function layWorld_frmGemstoneInlay_OnEvent( self, event, arg )
	local mWidget = nil
	if event == "CEV_REFRESH_STICKHOLE" then
		-- Refresh holes and info
		layWorld_frmGemstoneInlay_initInfoByEquipment()
		layWorld_frmGemstoneInlay_initHolesByEquipment()
	elseif event == "CEV_REFRESH_STONE" then
		if arg[1] == -1 then
			-- Inlay successed, disable the Inlayed button
			-- Refresh holes and info
			layWorld_frmGemstoneInlay_initInfoByEquipment()
			layWorld_frmGemstoneInlay_initHolesByEquipment()
			-- Clear check state
			local mIdx = layWorld_frmGemstoneInlay_getCheckedHoleIndex()
			if mIdx~= nil and mIdx>0 then
				-- Bind checked data
				mWidget = layWorld_frmGemstoneInlay_getWidgetByName( "BTN_HOLE_"..tostring(mIdx) )
				mWidget:Set( "CHECKED", false )				
				layWorld_frmGemstoneInlay_updateHoleMask( mIdx )
				-- Hide the checked mask
				--mWidget = layWorld_frmGemstoneInlay_getWidgetByName( "LABLE_HOLE_MASK_CHECKED_"..tostring(mIdx) )
				--mWidget:Hide()
			end
			-- Update the inlayed button's state
			layWorld_frmGemstoneInlay_updateInlayButtonState()
		else
			-- Get out the gemstone, Clear data bound on the hole
			mWidget = layWorld_frmGemstoneInlay_getWidgetByName( "BTN_HOLE_"..tostring(arg[1]+1) )
			if nil~=mWidget then
				mWidget:Set( "INLAYED", false )
				mWidget:Set( "CHECKED", false )
				mWidget:Set(EV_UI_SHORTCUT_TYPE_KEY, 0)
				mWidget:Set(EV_UI_SHORTCUT_OBJECTID_KEY, 0)
				mWidget:Set(EV_UI_SHORTCUT_CLASSID_KEY, 0)
				mWidget:ModifyFlag("DragIn", true)
				mWidget:ModifyFlag("DragOut", false)
				layWorld_frmGemstoneInlay_btnHole_Refresh(mWidget)
			end
			-- Update the mask image
			layWorld_frmGemstoneInlay_updateHoleMask( arg[1]+1 )
			
			layWorld_frmGemstoneInlay_initInfoByEquipment()
			layWorld_frmGemstoneInlay_initHolesByEquipment()
			-- Disable the getout button
			mWidget = layWorld_frmGemstoneInlay_getWidgetByName( "BTN_GETOUT" )
			mWidget:Disable()
		end
	elseif event == "EVENT_LocalGurl" then
		if tostring(arg[1])=="gemstoneinlay" then
			self:ShowAndFocus()
		end	
	end
end

function layWorld_frmGemstoneInlay_OnUpdate( self )
	if uiNpcDialogCheckDistance() ~= true then
		self:Hide()
	end
end


--[[
function layWorld_frmGemstoneInlay_btnSlot_OnClicked( self )
	local mWidget = nil
	local mEquipObjID = nil
	mWidget = layWorld_frmGemstoneInlay_getWidgetByName( "BTN_EQUIP" )
	mEquipObjID = mWidget:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	if nil~=mEquipObjID and mEquipObjID>0 then
		-- Slot the hole
		uiItemStickHole( mEquipObjID )
	end
end
]]

function layWorld_frmGemstoneInlay_btnInlay_OnClicked( self )
	local mWidget = nil
	mWidget = layWorld_frmGemstoneInlay_getWidgetByName( "BTN_EQUIP" )
	local mEquipObjID = mWidget:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	if nil==mEquipObjID or mEquipObjID<=0 then
		uiClientMsg( uiLanString("gemstone_inlay_info5"), true )
		return
	end
	local mGemstoneID = nil
	local mBInlayed = false
	for i=1, 8 do
		mWidget = layWorld_frmGemstoneInlay_getWidgetByName( "BTN_HOLE_"..tostring(i) )
		if mWidget:getVisible() then
			mGemstoneID = mWidget:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
			if mWidget:getVisible() and mWidget:Get("INLAYED") == false and  mGemstoneID ~= nil and mGemstoneID>0 then
				-- Release the gemstone items
				LClass_ItemFreezeManager:Erase( mGemstoneID )
				-- Clear the button
				mWidget:ModifyFlag("DragIn", true)
				mWidget:ModifyFlag("DragOut", false)
				mWidget:Set( "CHECKED", false )
				mWidget:Set(EV_UI_SHORTCUT_TYPE_KEY, 0)
				mWidget:Set(EV_UI_SHORTCUT_OBJECTID_KEY, 0)
				mWidget:Set(EV_UI_SHORTCUT_CLASSID_KEY, 0)
				layWorld_frmGemstoneInlay_btnHole_Refresh(mWidget)
				mBInlayed = true
				uiItemSetStone( mEquipObjID, i-1, mGemstoneID )
			end
		end
	end
	if mBInlayed==false then
		uiClientMsg( uiLanString("gemstone_inlay_info6"), true )
	end
end

function layWorld_frmGemstoneInlay_btnGetout_OnClicked( self )
	local mWidget = nil
	local iIdx = 0
	local mEquipObjID = nil
	mWidget = layWorld_frmGemstoneInlay_getWidgetByName( "BTN_EQUIP" )
	mEquipObjID = mWidget:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	if nil==mEquipObjID or mEquipObjID<=0 then
		uiClientMsg( uiLanString("gemstone_inlay_info5"), true )
		return
	end	
	iIdx = layWorld_frmGemstoneInlay_getCheckedHoleIndex()
	if iIdx==0 then
		uiClientMsg( uiLanString("gemstone_inlay_info7"), true )
		return
	end
	mWidget = layWorld_frmGemstoneInlay_getWidgetByName( "BTN_HOLE_"..tostring(iIdx) )
	if mWidget:Get( "INLAYED" )==false then
		uiClientMsg( uiLanString("gemstone_inlay_info8"), true )
		return
	end
	-- Get out gemstone
	uiItemTakeOutStone( mEquipObjID, iIdx-1 )
end

function layWorld_frmGemstoneInlay_btnHole_OnLoad( self )
	self:Set(EV_UI_SHORTCUT_OWNER_KEY, EV_UI_SHORTCUT_OWNER_GEMSTONEINLAY)
	self:Set( "OPENED", false )
	self:Set( "INLAYED", false )
	self:Set( "CHECKED", false )
end

function layWorld_frmGemstoneInlay_btnHole_OnDragIn( self, drag )
	local dragOutWidget = uiGetglobal( drag )
	if dragOutWidget == nil then 
		return
	end
	
	-- if it is inlayed gemstone then do nothing
	local bInlayed = self:Get("INLAYED")
	if bInlayed then
		return
	end
	
	local shortCutOwnerType = dragOutWidget:Get(EV_UI_SHORTCUT_OWNER_KEY)
	if shortCutOwnerType == nil then 
		return
	end
	if shortCutOwners:isHoleAllowed( shortCutOwnerType ) == false then 
		return
	end
	if dragOutWidget:getName() == layWorld_frmGemstoneInlay_getWidgetByName("BTN_EQUIP"):getName() then
		return
	end
	local shortCutType = dragOutWidget:Get(EV_UI_SHORTCUT_TYPE_KEY)
	if shortCutType == nil then
		shortCutType = 0
	end
	local shortCutObjID = dragOutWidget:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	if shortCutObjID == nil then 
		shortCutObjID = 0 
	else
		local objInfo = uiItemGetBagItemInfoByObjectId(shortCutObjID)
		if objInfo.Type ~= 183 then
			return
		end
	end	
	local shortCutClassID = dragOutWidget:Get(EV_UI_SHORTCUT_CLASSID_KEY)
	if shortCutClassID == nil then 
		shortCutClassID = 0 
	end	
	local selfShortCutID = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	if selfShortCutID and selfShortCutID > 0 then
		LClass_ItemFreezeManager:Erase( selfShortCutID )
	end
	-- set self data
	self:Set(EV_UI_SHORTCUT_TYPE_KEY, shortCutType)
	self:Set(EV_UI_SHORTCUT_OBJECTID_KEY, shortCutObjID)
	self:Set(EV_UI_SHORTCUT_CLASSID_KEY, shortCutClassID)
	if shortCutOwnerType ~= EV_UI_SHORTCUT_OWNER_GEMSTONEINLAY then
		LClass_ItemFreezeManager:Push( shortCutObjID ) -- 冻结
	else
		-- If the drag_out is the same type then clear it
		layWorld_frmGemstoneInlay_btnHole_Clear( dragOutWidget )
		dragOutWidget:Set("OPENED",true)
	end
	layWorld_frmGemstoneInlay_btnHole_Refresh( self )
	layWorld_frmGemstoneInlay_updateInlayButtonState()
	
	-- Make the hole as checked hole
	local mWidget = nil
	local iCheckedIdx = layWorld_frmGemstoneInlay_getCheckedHoleIndex()
	local mSelfIdx = layWorld_frmGemstoneInlay_holeNameToIndex(self:getShortName())
	if iCheckedIdx>0 then
		if mSelfIdx~=0 and mSelfIdx~=iCheckedIdx then
			mWidget = layWorld_frmGemstoneInlay_getWidgetByName( "BTN_HOLE_"..tostring(iCheckedIdx) )
			mWidget:Set( "CHECKED", false )
			layWorld_frmGemstoneInlay_updateHoleMask(iCheckedIdx)
		end
	end
	self:Set( "CHECKED", true )
	layWorld_frmGemstoneInlay_updateHoleMask(mSelfIdx)
	
	-- The get out button must be disabled
	mWidget = layWorld_frmGemstoneInlay_getWidgetByName( "BTN_GETOUT" )
	mWidget:Disable()
end

function layWorld_frmGemstoneInlay_btnHole_OnDragNull( self )
	local shortCutItemID = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	if shortCutItemID and shortCutItemID > 0 then
		LClass_ItemFreezeManager:Erase( shortCutItemID ) -- 解冻
	end
	self:Set(EV_UI_SHORTCUT_TYPE_KEY, 0)
	self:Set(EV_UI_SHORTCUT_OBJECTID_KEY, 0)
	self:Set(EV_UI_SHORTCUT_CLASSID_KEY, 0)
	layWorld_frmGemstoneInlay_btnHole_Refresh(self)
	layWorld_frmGemstoneInlay_updateInlayButtonState()
end

function layWorld_frmGemstoneInlay_btnHole_OnHint( self )
	local hint = 0
	if self:Get("INLAYED")==false then
		local shortcut_type = self:Get(EV_UI_SHORTCUT_TYPE_KEY)
		if shortcut_type == nil then
		elseif shortcut_type == EV_SHORTCUT_OBJECT_ITEM then
			local shortcut_objectid = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
			if shortcut_objectid == nil or shortcut_objectid == 0 then
			else
				hint = uiItemGetBagItemHintByObjectId(shortcut_objectid)
			end
		end
	else
		hint = uiItemGetBagItemHintByTableId( self:Get(EV_UI_SHORTCUT_CLASSID_KEY) )
	end
	
	if hint ~= 0 then
		self:SetHintRichText( hint )
	else
		self:SetHintRichText(uiItemSmithing_GetStringChangeFont_RichText(uiLanString("hint_gemstoneinlay_stone")))
	end
end

function layWorld_frmGemstoneInlay_btnHole_OnClicked( self )
	-- Get the state of the hole
	local bOpened = self:Get( "OPENED" )
	if bOpened == false then
		return
	end
	local bChecked = self:Get( "CHECKED" )
	if bChecked then
		return
	end	
	-- Only refresh holes's appearances
	local mWidget = nil
	for idx=1, 8 do
		mWidget = layWorld_frmGemstoneInlay_getWidgetByName( "BTN_HOLE_"..tostring(idx) )
		mWidget:Set( "CHECKED", false )
		layWorld_frmGemstoneInlay_setHoleMask( idx, mWidget:Get("OPENED"), mWidget:Get("INLAYED"), false )
	end
	self:Set( "CHECKED", true )
	layWorld_frmGemstoneInlay_setHoleMask( layWorld_frmGemstoneInlay_holeNameToIndex( self:getShortName() ), self:Get("OPENED"), self:Get("INLAYED"), true )
		
	-- update the getout and inlayed button state
	local mGemstoneID = nil
	if self:Get( "INLAYED" ) then
		layWorld_frmGemstoneInlay_getWidgetByName("BTN_GETOUT"):Enable()		
		layWorld_frmGemstoneInlay_getWidgetByName("BTN_INLAY"):Disable()
	else
		layWorld_frmGemstoneInlay_getWidgetByName("BTN_GETOUT"):Disable()
		mGemstoneID = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
		--uiInfo("GemstoneID:"..tostring(mGemstoneID))
		if nil~=mGemstoneID and mGemstoneID>0 then
			layWorld_frmGemstoneInlay_getWidgetByName("BTN_INLAY"):Enable()
		else
			layWorld_frmGemstoneInlay_getWidgetByName("BTN_INLAY"):Disable()
		end
	end
end

function layWorld_frmGemstoneInlay_btnEquip_OnLoad( self )
	self:Set( EV_UI_SHORTCUT_OWNER_KEY, EV_UI_SHORTCUT_OWNER_GEMSTONEINLAY )
end

function layWorld_frmGemstoneInlay_btnEquip_OnDragIn( self, drag )
	layWorld_frmGemstoneInlay_reset()
	local dragOutWidget = uiGetglobal( drag )
	if dragOutWidget == nil then 
		return
	end
	local shortCutOwnerType = dragOutWidget:Get(EV_UI_SHORTCUT_OWNER_KEY)
	if shortCutOwnerType == nil then 
		return
	end
	if shortCutOwners:isEquipAllowed( shortCutOwnerType ) == false then 
		return
	end
	local shortCutObjID = dragOutWidget:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	
	if shortCutObjID == nil or uiItemCanItemDragIn( shortCutObjID, true )==false then 
		return
	end	
	local shortCutType = dragOutWidget:Get(EV_UI_SHORTCUT_TYPE_KEY)
	if shortCutType == nil then
		shortCutType = 0
	end	
	local shortCutClassID = dragOutWidget:Get(EV_UI_SHORTCUT_CLASSID_KEY)
	if shortCutClassID == nil then 
		shortCutClassID = 0 
	end
	local selfShortCutID = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	if selfShortCutID and selfShortCutID > 0 then
		LClass_ItemFreezeManager:Erase( selfShortCutID )
	end
	-- set self data
	self:Set(EV_UI_SHORTCUT_TYPE_KEY, shortCutType)
	self:Set(EV_UI_SHORTCUT_OBJECTID_KEY, shortCutObjID)
	self:Set(EV_UI_SHORTCUT_CLASSID_KEY, shortCutClassID)
	if shortCutOwnerType ~= EV_UI_SHORTCUT_OWNER_GEMSTONEINLAY then
		LClass_ItemFreezeManager:Push( shortCutObjID )
	else
		-- If the drag_out is the same type then clear it
		layWorld_frmGemstoneInlay_btnHole_Clear( dragOutWidget )
	end
	layWorld_frmGemstoneInlay_btnUpdate( self )
	-- Init some controls
	layWorld_frmGemstoneInlay_initInfoByEquipment()
	layWorld_frmGemstoneInlay_initHolesByEquipment()
end

function layWorld_frmGemstoneInlay_btnEquip_OnDragNull( self )
	layWorld_frmGemstoneInlay_reset()
end

function layWorld_frmGemstoneInlay_btnEquip_OnHint( self )
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
	if hint~= 0 then
		self:SetHintRichText( hint )
	else
		self:SetHintRichText(uiItemSmithing_GetStringChangeFont_RichText(uiLanString("hint_gemstoneinlay_equip")))
	end
end

function layWorld_frmGemstoneInlay_OnDragIn( drag )
	local dragOutWidget = uiGetglobal( drag )
	if dragOutWidget == nil then 
		return
	end
	local shortCutObjID = dragOutWidget:Get(EV_UI_SHORTCUT_OBJECTID_KEY)	
	local itemInfo = uiItemGetBagItemInfoByObjectId(shortCutObjID)
	-- 1 is MainTrump
	if itemInfo.Type==1 then
		layWorld_frmGemstoneInlay_btnEquip_OnDragIn( layWorld_frmGemstoneInlay_getWidgetByName("BTN_EQUIP"), drag )
	else
		local mWidget = nil
		for idx=1, 8 do
			mWidget = layWorld_frmGemstoneInlay_getWidgetByName( "BTN_HOLE_"..tostring(idx) )
			if mWidget:getVisible() and mWidget:Get("OPENED") and mWidget:Get("INLAYED")==false and mWidget:Get(EV_UI_SHORTCUT_OBJECTID_KEY)==0 then
				layWorld_frmGemstoneInlay_btnHole_OnDragIn( mWidget, drag )
				break
			end
		end
	end
end

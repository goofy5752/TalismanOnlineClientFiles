--*************************************************************************************************************
-- Followed by datas and structs

local shortCutOwners =
{
	EV_UI_SHORTCUT_OWNER_ITEM,
	isAllowed = function( self, owner )
					if owner == nil then 
							return false 
						end						
						if EV_UI_SHORTCUT_OWNER_ITEM == owner then
							return true
						end
						return false
					end
}

--*************************************************************************************************************
-- Followed by common functions

--[ Get child widget by name ]
function layWorld_frmDakong_getWidgetByName( name )
	return SAPI.GetChild ( uiGetglobal( "layWorld.frmdakongEx" ), name )
end

--[ Reset money and hole count ]
function layWorld_frmDakong_mics_clear()
	local lbNum = layWorld_frmDakong_getWidgetByName( "lbHolesNum" )
	lbNum:SetText( "" )
	layWorld_frmDakong_mics_setMoney( false, 0 )
end

--[ Money unit change ]
function layWorld_frmDakong_mics_moneyChange(uMoney )
	local mGold = math.floor( uMoney/10000 )
	local mSliver = math.floor( ( uMoney - mGold*10000 )/100 )
	local mCopper = uMoney - mGold*10000 - mSliver*100
	return mGold, mSliver, mCopper
end

--[ Set money content ]
function layWorld_frmDakong_mics_setMoney( show, money )
	local mGoldWidget 		= layWorld_frmDakong_getWidgetByName("lbStickMoneyGold")
	local mGoldWidgetSign 	= layWorld_frmDakong_getWidgetByName("lbStickMoneyGoldSign")
	local mSilverWidget		= layWorld_frmDakong_getWidgetByName("lbStickMoneySliver")
	local mSilverWidgetSign	= layWorld_frmDakong_getWidgetByName("lbStickMoneySliverSign")
	local mCopperWidget		= layWorld_frmDakong_getWidgetByName("lbStickMoneyCopper")
	local mCopperWidgetSign	= layWorld_frmDakong_getWidgetByName("lbStickMoneyCopperSign")	
	if show then
		local mGold 	= 0
		local mSliver 	= 0
		local mCopper 	= 0
		mGold, mSliver, mCopper = layWorld_frmDakong_mics_moneyChange( money )
		if mGold==0 then
			mGoldWidget:Hide()
			mGoldWidgetSign:Hide()
			if mSliver==0 then
				mSilverWidget:Hide()
				mSilverWidgetSign:Hide()
				mCopperWidget:Show()
				mCopperWidgetSign:Show()
				mCopperWidget:MoveTo(120,265)
				mCopperWidgetSign:MoveTo(150,265)
				mCopperWidget:SetText( tostring(mSliver) )
			else
				mSilverWidget:Show()
				mSilverWidgetSign:Show()
				mSilverWidget:MoveTo(120,265)
				mSilverWidgetSign:MoveTo(150,265)
				mSilverWidget:SetText( tostring(mSliver) )
				if mCopper==0 then
					mCopperWidget:Hide()
					mCopperWidgetSign:Hide()
				else					
					mCopperWidget:Show()
					mCopperWidgetSign:Show()
					mCopperWidget:MoveTo(170,265)
					mCopperWidgetSign:MoveTo(200,265)
					mCopperWidget:SetText( tostring(mSliver) )
				end
			end
		else
			mGoldWidget:Show()
			mGoldWidgetSign:Show()
			mGoldWidget:SetText( tostring(mGold) )
			if mSliver==0 then
				mSilverWidget:Hide()
				mSilverWidgetSign:Hide()
				if mCopper==0 then
					mCopperWidget:Hide()
					mCopperWidgetSign:Hide()
				else					
					mCopperWidget:Show()
					mCopperWidgetSign:Show()
					mCopperWidget:MoveTo(170,265)
					mCopperWidgetSign:MoveTo(200,265)
					mCopperWidget:SetText( tostring(mSliver) )
				end
			else
				mSilverWidget:Show()
				mSilverWidgetSign:Show()
				mSilverWidget:MoveTo(170,265)
				mSilverWidgetSign:MoveTo(200,265)
				mSilverWidget:SetText( tostring(mSliver) )
				if mCopper==0 then
					mCopperWidget:Hide()
					mCopperWidgetSign:Hide()
				else					
					mCopperWidget:Show()
					mCopperWidgetSign:Show()
					mCopperWidget:MoveTo(220,265)
					mCopperWidgetSign:MoveTo(250,265)
					mCopperWidget:SetText( tostring(mSliver) )
				end
			end
		end			
	else
		mGoldWidget:Hide()
		mGoldWidgetSign:Hide()
		mSilverWidget:Hide()
		mSilverWidgetSign:Hide()
		mCopperWidget:Hide()
		mCopperWidgetSign:Hide()
	end
end

--[ Reset money and hole count ]
function layWorld_frmDakong_mics_Refresh()
	local lbNum = layWorld_frmDakong_getWidgetByName( "lbHolesNum" )
	local btnEquip = layWorld_frmDakong_getWidgetByName( "cbtYaodakongdezhuangbei" )
	local mObjID = btnEquip:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	if nil==mObjID or mObjID<=0 then 
		lbNum:SetText( "" )
		layWorld_frmDakong_mics_setMoney( false, 0 )
		return
	end
	local mCanInlayHolesNum = uiItemGetCanStickHoleCnt( mObjID ) - uiItemGetStickHoleCnt( mObjID )	
	if mCanInlayHolesNum>0 then
		lbNum:SetText( tostring(mCanInlayHolesNum) )
		local mNeedMoney = uiItemGetStickHoleCost( mObjID )
		layWorld_frmDakong_mics_setMoney( true, mNeedMoney )
	else
		lbNum:SetText( tostring(0) )
		layWorld_frmDakong_mics_setMoney( true, 0 )
	end	
end

--[ Reset all content ]
function layWorld_frmDakong_reset()
	layWorld_frmDakong_cbtYaodakongdezhuangbei_Clear()
	layWorld_frmDakong_mics_clear()
end

--[ Clear equipment button ]
function layWorld_frmDakong_cbtYaodakongdezhuangbei_Clear( )
	local btnEquip = layWorld_frmDakong_getWidgetByName( "cbtYaodakongdezhuangbei" )
	local shortCutItemID = btnEquip:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	if shortCutItemID and shortCutItemID > 0 then
		LClass_ItemFreezeManager:Erase( shortCutItemID )
	end
	btnEquip:Set(EV_UI_SHORTCUT_TYPE_KEY, 0)
	btnEquip:Set(EV_UI_SHORTCUT_OBJECTID_KEY, 0)
	btnEquip:Set(EV_UI_SHORTCUT_CLASSID_KEY, 0)
	layWorld_frmDakong_cbtYaodakongdezhuangbei_Refresh()
end

--[ Refresh equipment button ]
function layWorld_frmDakong_cbtYaodakongdezhuangbei_Refresh()
	local btnEquip = layWorld_frmDakong_getWidgetByName( "cbtYaodakongdezhuangbei" )
	local shortcut_dbid = btnEquip:Get(LOCAL_SHORTCUT_DBID_KEY)
	local shortcut_owner = btnEquip:Get(EV_UI_SHORTCUT_OWNER_KEY)
	if shortcut_owner == nil or shortcut_owner ~= EV_UI_SHORTCUT_OWNER_STICK then 
		return
	end
	local shortcut_type = btnEquip:Get(EV_UI_SHORTCUT_TYPE_KEY)
	local shortcut_objectid = btnEquip:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	local shortcut_classid = btnEquip:Get(EV_UI_SHORTCUT_CLASSID_KEY)
	
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
	btnEquip:ModifyFlag("DragOut_MouseMove", bModifyFlag)
	btnEquip:SetNormalImage(icon)
end

--*************************************************************************************************************
-- Followed by widgets functions

function layWorld_frmDakong_OnLoad( self )
	self:RegisterScriptEventNotify( "EVENT_LocalGurl" )	
	self:RegisterScriptEventNotify( "CEV_REFRESH_STICKHOLE" )
end

function layWorld_frmDakong_OnShow( self )
	uiRegisterEscWidget(self)
	self:ShowAndFocus()
	layWorld_frmDakong_reset()
end

function layWorld_frmDakong_OnHide( self )
	layWorld_frmDakong_reset()
end

function layWorld_frmDakong_OnEvent( self, event, arg )
	if event == "CEV_REFRESH_STICKHOLE" then
		if self:getVisible() then
			layWorld_frmDakong_mics_Refresh()
		end
	elseif event == "EVENT_LocalGurl" then
		if tostring(arg[1])=="gemstonestick" then
			self:ShowAndFocus()
		end
	end
end

function layWorld_frmDakong_btok_OnClicked( self )
	local mWidget = nil
	local mEquipObjID = nil
	mWidget = layWorld_frmDakong_getWidgetByName( "cbtYaodakongdezhuangbei" )
	mEquipObjID = mWidget:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	if nil~=mEquipObjID and mEquipObjID>0 then
		-- Slot the hole
		uiItemStickHole( mEquipObjID )
	end
end

function layWorld_frmDakong_cbtYaodakongdezhuangbei_OnLoad( self )
	self:Set( EV_UI_SHORTCUT_OWNER_KEY, EV_UI_SHORTCUT_OWNER_STICK )
end

function layWorld_frmDakong_cbtYaodakongdezhuangbei_OnDragIn( self, drag )
	local dragOutWidget = uiGetglobal( drag )
	if dragOutWidget == nil then 
		return
	end
	local shortCutOwnerType = dragOutWidget:Get(EV_UI_SHORTCUT_OWNER_KEY)
	if shortCutOwnerType == nil then 
		return
	end
	if shortCutOwners:isAllowed( shortCutOwnerType ) == false then 
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
	LClass_ItemFreezeManager:Push( shortCutObjID )
	layWorld_frmDakong_cbtYaodakongdezhuangbei_Refresh()
	layWorld_frmDakong_mics_Refresh()
end

function layWorld_frmDakong_cbtYaodakongdezhuangbei_OnDragNull( self )
	layWorld_frmDakong_reset()
end

function layWorld_frmDakong_cbtYaodakongdezhuangbei_OnHint( self )
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
	if hint ~= 0 then
		self:SetHintRichText( hint )
	else
		self:SetHintRichText(uiItemSmithing_GetStringChangeFont_RichText(uiLanString("hint_gemstoneinlay_stick")))
	end
end

function layWorld_frmDakong_OnDragIn(drag)
	layWorld_frmDakong_cbtYaodakongdezhuangbei_OnDragIn( layWorld_frmDakong_getWidgetByName("cbtYaodakongdezhuangbei"), drag )
end

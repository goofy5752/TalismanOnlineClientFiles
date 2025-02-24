--*************************************************************************************************************
-- Followed by datas and structs
local COLOR_WHITE = 4294967295 					-- White Color
local COLOR_GRAY  = 4286611584					-- Gray  Color
local g_requestList = nil

--*************************************************************************************************************
-- Followed by common functions

--[ Get child widget by name ]
function layWorld_frmGuildRegisterEx_getWidgetByName( name )
	return SAPI.GetChild ( uiGetglobal( "layWorld.Frm_GuildRegister" ), name )
end

--[ Sort the request list by condition ]
function layWorld_frmGuildRegisterEx_sortList( strCondition,  bAscend, list )
	if strCondition~="Level" and strCondition~="Name" and strCondition~="Party" then
		return
	end
	local mListCount = table.getn( list )
	for i=1, mListCount do
		for j = i+1, mListCount do
			local bChange = false
			if bAscend==true and list[i][strCondition] > list[j][strCondition] then
				bChange = true
			end
			if bAscend==false and list[i][strCondition] < list[j][strCondition] then
				bChange = true
			end
			if bChange then
				local temp = list[i]
				list[i] = list[j]
				list[j] = temp
			end
		end
	end	
	return list
end

--[ Test the data is ascend by condition or not ]
function layWorld_frmGuildRegisterEx_isAscendByCondition( strCondition )
	if strCondition~="Num" and strCondition~="Level" and strCondition~="Name" and strCondition~="Party" then
		return false
	end	
	local mListCount = table.getn( g_requestList )
	for idx=1, mListCount-1 do
		if g_requestList[idx][strCondition] > g_requestList[idx+1][strCondition] then
			return false
		end
	end
	return true
end

--[ Refresh the request list ]
function layWorld_frmGuildRegisterEx_refreshRequestList( )
	g_requestList = layWorld_frmGuildRegisterEx_sortList( "Level", true, uiGuild_GetRequestList() )
	layWorld_frmGuildRegisterEx_updateList( g_requestList )
	layWorld_frmGuildRegisterEx_setButtonState()
end

--[ Set the list's content by given list ]
function layWorld_frmGuildRegisterEx_updateList( list )
	local m_list = layWorld_frmGuildRegisterEx_getWidgetByName("lstGuildRegister")
	m_list:RemoveAllLines( true )
	for idx, v in ipairs( list ) do
		--uiInfo( "Online == "..tostring( v["Online"] ) )
		local mColor = nil
		if v["Online"] == 1 then
			mColor = COLOR_WHITE
		else
			mColor = COLOR_GRAY 
		end
		m_list:InsertLine( 20, mColor, -1 )
		m_list:SetLineItem( idx-1, 0, v["Name"], mColor )
		m_list:SetLineItem( idx-1, 1, tostring(v["Level"]), mColor )
		local mParty = ""
		if v["Party"]== 0 then
			mParty = uiLanString("party_em")
		elseif v["Party"]== 1 then
			mParty = uiLanString("party_fm")
		elseif v["Party"]== 2 then
			mParty = uiLanString("party_qc")
		elseif v["Party"]== 3then
			mParty = uiLanString("party_bh")
		elseif v["Party"]== 4 then
			mParty = uiLanString("party_xq")
		end
		m_list:SetLineItem( idx-1, 2, mParty, mColor )
	end
end

--[ set button state ]
function layWorld_frmGuildRegisterEx_setButtonState()
	local mBtnRegister = layWorld_frmGuildRegisterEx_getWidgetByName( "btGuildRegister" )
	local mBtnCancel = layWorld_frmGuildRegisterEx_getWidgetByName( "btCancel" )
	local mBtnAccept = layWorld_frmGuildRegisterEx_getWidgetByName( "btRecruit" )
	local mEnableRegister = nil
	local mEnableUnregister = nil
	local mEnableAccept = nil
	mEnableRegister, mEnableUnregister, mEnableAccept = uiGuild_GetSelfAboutRegister()
	--uiInfo( "mEnableRegister"..tostring(mEnableRegister) )
	--uiInfo( "mEnableUnregister"..tostring(mEnableUnregister) )
	--uiInfo( "mEnableAccept"..tostring(mEnableAccept) )
	if mEnableRegister==1 then
		mBtnRegister:Enable()
	else
		mBtnRegister:Disable()
	end
	if mEnableUnregister==1 then
		mBtnCancel:Enable()
	else
		mBtnCancel:Disable()
	end
	if mEnableAccept==1 then
		mBtnAccept:Enable()
	else
		mBtnAccept:Disable()
	end
end

--*************************************************************************************************************
-- Followed by widgets functions

function layWorld_frmGuildRegisterEx_OnLoad( self )
	self:RegisterScriptEventNotify( "CEV_GUILD_REFRESH_REQ_LIST" )
	self:RegisterScriptEventNotify( "EVENT_LocalGurl" )
	self:Set("UPDATE", true)
end

function layWorld_frmGuildRegisterEx_OnShow( self )
	uiRegisterEscWidget(self)
	self:ShowAndFocus()
	uiGuild_ReqFreshRequestList()
end

function layWorld_frmGuildRegisterEx_OnHide( self )
	self:Set("UPDATE", true)
end

function layWorld_frmGuildRegisterEx_OnEvent( self, event, arg )
	uiInfo( "GuildRegister: Recv Event "..tostring(event) )
	if event == "CEV_GUILD_REFRESH_REQ_LIST" then
		layWorld_frmGuildRegisterEx_refreshRequestList()
	elseif event=="EVENT_LocalGurl" then
		if tostring(arg[1])=="guildregister" then
			self:ShowAndFocus()
		end	
	end
end

function layWorld_frmGuildRegisterEx_btGuildRegister_OnClicked( self )
	uiInfo( "Register self " )
	uiGuild_RegisterReqList()
end

function layWorld_frmGuildRegisterEx_btCancel_OnClicked( self )
	uiInfo( "UnRegister self " )
	uiGuild_UnRegisterReqList()
end

function layWorld_frmGuildRegisterEx_btRecruit_OnClicked( self )
	local m_list = layWorld_frmGuildRegisterEx_getWidgetByName("lstGuildRegister")
	local mSelectRow = m_list:getSelectLine()
	if mSelectRow==nil or -1==mSelectRow then
		return
	end
	local mSelectIdx = mSelectRow+1
	if mSelectIdx>table.getn(g_requestList) then
		return
	end
	--uiInfo( "Invite someone to join guild..."..tostring(g_requestList[mSelectIdx]["Id"]))
	uiGuild_InviteFromList(g_requestList[mSelectIdx]["Id"])
end

function layWorld_frmGuildRegisterEx_btRenovate_OnClicked( self )
	uiGuild_ReqFreshRequestList()
end

function layWorld_frmGuildRegisterEx_lstGuildRegister_OnSelect( self )
	local m_list = layWorld_frmGuildRegisterEx_getWidgetByName("lstGuildRegister")
	local mSelectRow = m_list:getSelectLine()
	if mSelectRow==nil or -1==mSelectRow then
		return
	end
	local mSelectIdx = mSelectRow+1
	if mSelectIdx>table.getn(g_requestList) then
		return
	end
	local mBtnAccept = layWorld_frmGuildRegisterEx_getWidgetByName( "btRecruit" )
	local mEnableRegister = nil
	local mEnableUnregister = nil
	local mEnableAccept = nil
	mEnableRegister, mEnableUnregister, mEnableAccept = uiGuild_GetSelfAboutRegister()
	if mEnableAccept==1 then
		if g_requestList[mSelectIdx]["Online"]==1 then
			mBtnAccept:Enable()
		else
			mBtnAccept:Disable()
		end
	else
		mBtnAccept:Disable()
	end
end

function layWorld_frmGuildRegisterEx_lstGuildRegister_OnHeaderClick( self, index )
	local bAscend = false
	local strCondition = nil
	if index == 0 then
		strCondition = "Name"
	elseif index == 1 then
		strCondition = "Level"
	elseif index == 2 then
		strCondition = "Party"
	end
	if nil == strCondition then
		return
	end
	if layWorld_frmGuildRegisterEx_isAscendByCondition( strCondition ) then
		g_requestList = layWorld_frmGuildRegisterEx_sortList( strCondition, false, g_requestList )
	else
		g_requestList = layWorld_frmGuildRegisterEx_sortList( strCondition, true, g_requestList )
	end
	layWorld_frmGuildRegisterEx_updateList( g_requestList )
end

function layWorld_frmGuildRegisterEx_OnUpdate( self )
	if self:Get("UPDATE") and uiNpcDialogCheckDistance() ~= true then
		self:Hide()
	end
end

function layWorld_frmGuildRegisterEx_lstGuildRegister_OnRDown(self, mouse_x, mouse_y)
	uiInfo("layWorld_frmGuildRegisterEx_lstGuildRegister_OnRDown ...")
	local line, col = uiGetListBoxPickItem(self, mouse_x, mouse_y);
	uiInfo("line..."..tostring(line) )
	if line == nil then return end -- 没有这行
	self:SetSelect(line)
	if line>=table.getn( g_requestList ) then
		return
	end
	uiInfo("ObjID"..tostring(g_requestList[line+1]["Id"]) )
	uiGuild_RegisterPopupUser( g_requestList[line+1]["Id"] )
end




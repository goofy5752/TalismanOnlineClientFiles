local m_delegateItems = {}
local COLOR_WHITE = 4294967295 					--	White Color
local m_curPage = 0

local function findDelegate( strID )
	for idx, v in ipairs( m_delegateItems ) do
		if 	v["ID"] == strID then
			return idx
		end
	end	
	return nil
end

local function addDelegate( strID, strLevel, strDifficulty, strPublisher, strName, strReward, strReputation, strState, strValiTime, strDesc )
	local m_idx = findDelegate( strID )
	if nil ~= m_idx then
		return
	end
	local newItem = {}
	newItem["ID"] = strID
	newItem["level"] = strLevel
	newItem["difficulty"] = strDifficulty
	newItem["publisher"] = strPublisher
	newItem["name"] = strName
	newItem["reward"] = strReward
	newItem["reputation"] = strReputation
	newItem["state"] = strState
	newItem["time"] = strValiTime
	newItem["desc"] = strDesc
	m_idx = table.getn( m_delegateItems )	
	m_delegateItems[m_idx+1] = newItem
end

local function updateDelegateList()
	local m_list = uiGetglobal( "layWorld.frmEntrusthall.lbxEntrust" )
	m_list:RemoveAllLines( true )
	for idx, v in ipairs( m_delegateItems ) do
		m_list:InsertLine( 20, COLOR_WHITE, -1 )
		m_list:SetLineItem( idx-1, 0, v["level"], COLOR_WHITE )
		m_list:SetLineItem( idx-1, 1, v["difficulty"], COLOR_WHITE )
		m_list:SetLineItem( idx-1, 2, v["publisher"], COLOR_WHITE )
		m_list:SetLineItem( idx-1, 3, v["name"], COLOR_WHITE )
		m_list:SetLineItem( idx-1, 4, v["reward"], COLOR_WHITE )
		m_list:SetLineItem( idx-1, 5, v["reputation"], COLOR_WHITE )
		m_list:SetLineItem( idx-1, 6, v["state"], COLOR_WHITE )
		m_list:SetLineItem( idx-1, 7, v["time"], COLOR_WHITE )
		m_list:SetLineItem( idx-1, 8, v["desc"], COLOR_WHITE )
	end
end

function layWorld_frmEntrusthall_OnLoad( self )
	self:RegisterScriptEventNotify("RefreshConsignList")	
	local m_btnPrePage = uiGetglobal( "layWorld.frmEntrusthall.btPrepage" )
	m_btnPrePage:Disable()
end

function layWorld_frmEntrusthall_OnEvent( self, event, arg )
	uiInfo( "layWorld_frmEntrusthall_OnEvent Begin..." )
	if event =="RefreshConsignList" then
		uiInfo( "layWorld_frmEntrusthall_OnEvent get message..." )
		local m_btnPrePage = uiGetglobal( "layWorld.frmEntrusthall.btPrepage" )
		local m_btnNextPage = uiGetglobal( "layWorld.frmEntrusthall.btNextpage" )
		if arg == 0 then
			if m_curPage == 0 then
				m_btnPrePage:Disable()
			else
				m_btnPrePage:Enable()
			end
			m_btnNextPage:Disable()
		else
			if m_curPage == 0 then
				m_btnPrePage:Disable()
			else
				m_btnPrePage:Enable()
			end
			m_btnNextPage:Enable()
		end		
		
		local m_consignList = uiConsignGetConsignList()
		for k, v in pairs( m_consignList ) do
			--addDelegate( strID, strLevel, strDifficulty, strPublisher, strName, strReward, strReputation, strState, strValiTime, strDesc )
			addDelegate( tostring(v["ID"]), tostring(v["ReleaserId"]), tostring(v["ReceiverId"]), v["ReleaserName"], "HHAHA", tostring(v["Money"]), tostring(v["Credit"]), "GGGG", tostring(v["RemainTm"]), v["Desc"] )
		end
		updateDelegateList()
    end
	uiInfo( "layWorld_frmEntrusthall_OnEvent End..." )
end

function layWorld_frmEntrusthall_OnShow( self )
end

function layWorld_frmEntrusthall_BtnRefresh_OnClicked( self )
	local m_maxRele = nil 
	local m_maxRecv = nil 
	m_maxRele, m_maxRecv = uiConsignGetConfig()
	local m_enaRele = nil 
	local m_enaRecv = nil 
	m_enaRele, m_enaRecv = uiConsignGetReleaseCnt(), uiConsignGetReceiveCnt()
	
	local m_labRele = uiGetglobal( "layWorld.frmEntrusthall.lbIssueTimes" )
	local m_labRecv = uiGetglobal( "layWorld.frmEntrusthall.lbReceiveTimes" )
	
	m_labRele:SetText( string.format("%d/%d", m_enaRele, m_maxRele ) )
	m_labRecv:SetText( string.format("%d/%d", m_enaRecv, m_maxRecv ) )
	
	--[ Ask for consign list ]
	uiInfo( "layWorld_frmEntrusthall_BtnRefresh_OnClicked Ask for consign, page:"..tostring(m_curPage).."..." )
	uiConsignViewConsign( m_curPage )
end

function layWorld_frmEntrusthall_BtnPrepage_OnClicked( self )
	m_curPage = m_curPage-1
	if m_curPage < 0 then
		m_curPage = 0
	end
	uiConsignViewConsign( m_curPage )
end

function layWorld_frmEntrusthall_BtnNextpage_OnClicked( self )
	m_curPage = m_curPage+1
	uiConsignViewConsign( m_curPage )
end

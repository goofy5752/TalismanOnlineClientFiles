local m_tTypeInfo = {}
local m_fDelegateFee = 10

--[ Retrive the task list ]
local function getDelegateInfo()
	m_tTypeInfo["FB"] = {}
	m_tTypeInfo["TA"] = {}
	local mTaskList = uiTaskGetTaskList()
	for idx, t in pairs( mTaskList ) do
		for k, v in ipairs(t) do
			local strID = v["Id"]
			local strFlag = v["SpecialFlag"]
            local strName = v["Name"]
			if tonumber(strFlag) == 11 then
				m_tTypeInfo["FB"][table.getn(m_tTypeInfo["FB"])+1] = {strID,strName}
			else
				m_tTypeInfo["TA"][table.getn(m_tTypeInfo["TA"])+1] = {strID,strName}
			end
		end
	end
end


--[ Task combobox update ]
local function updateTask()
	getDelegateInfo()
	local m_cbxTaskName = uiGetglobal( "layWorld.frmEntrust.cbxEntrustTaskName" )
	local m_cbxTask = uiGetglobal( "layWorld.frmEntrust.cbxEntrustTask" )	
	m_cbxTaskName:RemoveAllItems()	
	m_cbxTask:RemoveAllItems()
	
	local m_strFirstKey = nil
	for k,v in pairs(m_tTypeInfo) do
		if nil == m_strFirstKey then
			m_strFirstKey = k
		end
		m_cbxTask:AddItem( k, nil )
	end
	
	if nil ~= m_strFirstKey then		
		local m_tFirstVal = m_tTypeInfo[m_strFirstKey]
		for m, n in pairs( m_tFirstVal ) do
			m_cbxTaskName:AddItem( n[2], nil )
		end		
		if table.getn( m_tFirstVal ) > 0 then
			m_cbxTaskName:SelectItem( 0 )
		end
		m_cbxTask:SelectItem( 0 )
	end
end

--[ Do nothing, just for messagebox functor ]
local function dumbFunction( _, __ )
end

--[ Find current task id ]
local function findCurrentTaskID()
	local m_cbxTaskName = uiGetglobal( "layWorld.frmEntrust.cbxEntrustTaskName" )
	local m_cbxTask = uiGetglobal( "layWorld.frmEntrust.cbxEntrustTask" )	
	local m_taskType = m_cbxTask:getText()
	local m_taskName = m_cbxTaskName:getText()
	for k, v in pairs( m_tTypeInfo ) do
		if k == m_taskType then
			for idx, vv in pairs( v ) do
				if vv[2] == m_taskName then
					return vv[1]
				end
			end
		end
	end	
	return nil
end

function layWorld_frmEntrustissue_OnLoad( self )
	--m_tTypeInfo["FB"] = {{"0","1"},{"0","2"},{"0","3"}}
	--m_tTypeInfo["TA"] = {{"0","4"},{"0","5"},{"0","6"}}	
	self:RegisterScriptEventNotify("event_update_task")
	self:RegisterScriptEventNotify("EVENT_SelfLevelUp")
	
	local m_labFee = uiGetglobal( "layWorld.frmEntrust.lbprocedurefee" )
	m_labFee:SetText( tostring(m_fDelegateFee) )

end

function layWorld_frmEntrustissue_OnEvent( self, event, arg )
	if event =="event_update_task" or "EVENT_SelfLevelUp" then
		updateTask()
    end
end

function layWorld_frmEntrustissue_OnShow( self )
	uiRegisterEscWidget( self )
	self:ShowAndFocus()
end

function layWorld_frmEntrustissue_BtnConfirm_OnClicked( self )
	uiInfo( "layWorld_frmEntrustissue_BtnConfirm_OnClicked Begin..." )
	local m_curTaskID = findCurrentTaskID()
	if m_curTaskID == nil then
	   uiMessageBox("没有可接受委托","提示：",true,false,true)
	   return
	end
	
	local m_cbxRepuation = uiGetglobal( "layWorld.frmEntrust.ebxCreditworthiness" )
	local m_cbxTime = uiGetglobal( "layWorld.frmEntrust.ebxHours" )
	local m_cbxDesc = uiGetglobal( "layWorld.frmEntrust.ebxDescribe" )
	local m_cbxReward = uiGetglobal( "layWorld.frmEntrust.ebxGold" )
	
	local m_fRepuation = tonumber( m_cbxRepuation:getText() )
	local m_fTime = tonumber( m_cbxTime:getText() )
	local m_strDesc = m_cbxDesc:getText()
	local m_fReward = tonumber( m_cbxReward:getText() )	
	uiInfo( "ID:"..m_curTaskID.." Repuation:"..tostring(m_fRepuation).." Time:"..tostring(m_fTime).." Reward:"..tostring(m_fReward).." Desc:"..m_strDesc )
	uiConsignSendConsign( tonumber(m_curTaskID), m_fRepuation, m_fTime, m_fReward, m_strDesc )
	
	uiInfo( "layWorld_frmEntrustissue_BtnConfirm_OnClicked End..." )
end

function layWorld_frmEntrustissue_BtnClose_OnClicked( self )
	local m_form = uiGetglobal( "layWorld.frmEntrust" )
	m_form:Hide()
end

function layWorld_frmEntrustissue_CBX_EntrustTask_OnUpdateText( self )
    local m_cbxTaskName = uiGetglobal( "layWorld.frmEntrust.cbxEntrustTaskName" )
	m_cbxTaskName:RemoveAllItems()
	local m_tCurVal = m_tTypeInfo[self:getText()]
	for m, n in ipairs( m_tCurVal ) do
		m_cbxTaskName:AddItem( n[2], nil )
	end
	if table.getn( m_tCurVal ) > 0 then
		m_cbxTaskName:SelectItem( 0 )
	end
end

function layWorld_frmEntrustissue_CBX_EntrustTaskName_OnUpdateText( self )
end

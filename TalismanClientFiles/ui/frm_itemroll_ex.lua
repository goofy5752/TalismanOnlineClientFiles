local UI_ITEMROLL_FROM_COUNT = 10


function layWorld_lbLayerRollItem_OnEvent_RollItem(self, npcOid, dropId)
	for i=1, UI_ITEMROLL_FROM_COUNT, 1 do
		local frmRollItem = SAPI.GetChild(self, "frmRollItem"..i)
		if not frmRollItem:getVisible() then
			frmRollItem:Set("npcOid", npcOid)
			frmRollItem:Set("dropId", dropId)
			frmRollItem:Set("bRoll", false)
			local itemimage,itemString = uiRollItem_GetItemInfo(npcOid, dropId)
			local btItemPic = SAPI.GetChild(frmRollItem, "btItemPic")
			local lbItemName = SAPI.GetChild(frmRollItem, "lbItemName")
			if itemimage ~= nil then
				btItemPic:SetBackgroundImage(SAPI.GetImage(itemimage))

			end

			if itemString ~= nil then

				lbItemName:SetText(itemString)

			end
			frmRollItem:Show()
			break
		end
	end
	
end

function layWorld_lbLayerRollItem_frmRollItem_btItemPic_OnHint(self)
	local __Parent = self:getParent()
	local _,_,hintstring = uiRollItem_GetItemInfo(__Parent:Get("npcOid"), __Parent:Get("dropId"))
	if hintstring ~= nil then
		self:SetHintRichText(hintstring)
	end
end

function layWorld_lbLayerRollItem_frmRollItem_btRoll_OnLClick(self)
	local __Parent = self:getParent()
	__Parent:Set("bRoll", true)
	__Parent:Hide()
end

function layWorld_lbLayerRollItem_frmRollItem_btCancel_OnLClick(self)
	local __Parent = self:getParent()
	__Parent:Set("bRoll", false)
	__Parent:Hide()
end

function layWorld_lbLayerRollItem_frmRollItem_OnHide(self)
	local bRoll = self:Get("bRoll")
	local npcOid = self:Get("npcOid")
	local dropId = self:Get("dropId")

	if npcOid == nil or dropId == nil then
		return
	end

	
	if bRoll == nil then
		bRoll = false
	end

	uiRollItem_RollItem(bRoll, npcOid, dropId)

	self:Set("bRoll", false)
end

function layWorld_lbLayerRollItem_frmRollItem_prgRollItem_OnUpdate(self)
	local __Parent = self:getParent()

	if not __Parent:getVisible() then
		return
	end

	local npcOid = __Parent:Get("npcOid")
	local dropId = __Parent:Get("dropId")
	if npcOid == nil or dropId == nil then
		return
	end
	local timeLimit = uiRollItem_GetRollItemTimeLimit(npcOid, dropId)
	if timeLimit == nil then
		return
	end

	if timeLimit == 0 then
		__Parent:Set("bRoll", false)
		__Parent:Hide()
	else
		self:SetValue(timeLimit)
	end

	--未知原因，用startTime + durationTime等相互计算有不正确，不采用
	--local _, durationTime, startTime = uiRollItem_GetRollItemTimeLimit(npcOid, dropId)
	--if durationTime == nil or startTime == nil then
	--	return
	--end
	--local nowTime = uiGetNowSecond()


	
	--if startTime < nowTime - durationTime then
		
	--	__Parent:Set("bRoll", false)
	--	__Parent:Hide()
	--else
	--	self:SetValue((durationTime - (nowTime - startTime)) / durationTime)
		
	--end

	

end
UI_Item_Compose_SkillIndex = 0
UI_Current_Select_Compose_Idx = 0
UI_Item_Compose_ItemIndex = 0
UI_Compose_Count = 1

function layWorld_frMakeEx_RecvData_ToShow(self, skillIndex)
	UI_Item_Compose_SkillIndex = skillIndex

	layWorld_frMakeEx_Refresh()

	self:MoveTo(150, 200)
	self:ShowAndFocus()
end

function layWorld_frMakeEx_Refresh()
	local self = uiGetglobal("layWorld.frMakeEx")

	local lbTitle = SAPI.GetChild(self, "lbTitle")
	lbTitle:SetText("")

	local skillInfo = uiSkill_GetSkillBaseInfoByIndex(UI_Item_Compose_SkillIndex)
	if skillInfo ~= nil then
		lbTitle:SetText(skillInfo.Name)
	end

	local lstMakeItem = SAPI.GetChild(self, "lstMakeItem")
	lstMakeItem:RemoveAllLines()

	local lbMakeItemNumber = SAPI.GetChild(self, "lbMakeItemNumber")
	lbMakeItemNumber:SetText(""..UI_Compose_Count)

	local lbMakeItemName = SAPI.GetChild(self, "lbMakeItemName")
	lbMakeItemName:SetText("")

	local btMakeItem = SAPI.GetChild(self, "btMakeItem")
	btMakeItem:SetNormalImage(0)
	btMakeItem:Delete("ItemIndex")
	btMakeItem:Delete("ProductIndex")

	for i=1, 4, 1 do
		local btMake = SAPI.GetChild(self, "btMake"..i)
		local lbMake = SAPI.GetChild(self, "lbMake"..i)
		btMake:SetNormalImage(0)
		btMake:SetMaskValue(0)
		btMake:SetUltraTextNormal("")
		lbMake:SetText("")
		btMake:Delete("ItemIndex")
	end

	local btMakeAll = SAPI.GetChild(self, "btMakeAll")
	btMakeAll:Disable()

	local bt_Make = SAPI.GetChild(self, "bt_Make")
	bt_Make:Disable()
	
	local ltData = uiItemCompose_GetItemComposeInfo()
	if ltData == nil then return end

	if skillInfo == nil then return end

	local skill = uiItemCompose_GetComposeSkillInfo(UI_Item_Compose_SkillIndex)
	if skill == nil then return end

	local __name = lstMakeItem:getLineItemText(UI_Current_Select_Compose_Idx, 0)
	local counter = 0
	for i, data in ipairs(ltData) do
		local item = uiItemCompose_GetItemBaseInfo(data.ProductItemIndex)
		if item ~= nil then
			local color
			if data.NeedSkillLevel == skill.Lev then
				color = 4293980177
			elseif data.NeedSkillLevel == skill.Lev + 1 then
				color = 4288256290
			elseif data.NeedSkillLevel == skill.Lev + 2 then
				color = 4279343377
			else
				color = 4288256409
			end

			lstMakeItem:InsertLine(-1,-1,-1)
			lstMakeItem:SetLineItem(counter, 0, item.Name, color)
			if item.Name == __name then
				UI_Current_Select_Compose_Idx = counter
			end

			counter = counter + 1
			
		end
	end



	if UI_Current_Select_Compose_Idx >= counter then
		UI_Current_Select_Compose_Idx = 0
	end

	lstMakeItem:SetSelect(UI_Current_Select_Compose_Idx)

	--layWorld_frMakeEx_Refresh_Select_Compose(self)

end

function layWorld_frMakeEx_Refresh_Select_Compose(self)
	if UI_Current_Select_Compose_Idx < 0 then return end
	
	local ltData = uiItemCompose_GetItemComposeInfo()
	if ltData == nil then return end
	local counter = 0
	for i, data in ipairs(ltData) do
		local item = uiItemCompose_GetItemBaseInfo(data.ProductItemIndex)
		if item ~= nil then
			if UI_Current_Select_Compose_Idx == counter then
				local lbMakeItemName = SAPI.GetChild(self, "lbMakeItemName")
				lbMakeItemName:SetText(item.Name)
				local btMakeItem = SAPI.GetChild(self, "btMakeItem")
				btMakeItem:Set("ItemIndex", data.ProductItemIndex)
				btMakeItem:Set("ProductIndex", data.ProductIndex)
				
				local __img = SAPI.GetImage(item.StrImage, 2, 2, -2, -2)
				if __img ~= nil then
					btMakeItem:SetNormalImage(__img)
				end

				local MaxCount = 10000

				for j, material in ipairs(data.Materials) do
					local btMake = SAPI.GetChild(self, "btMake"..j)
					local lbMake = SAPI.GetChild(self, "lbMake"..j)

					btMake:Set("ItemIndex", material.ItemIndex)

					lbMake:SetText(material.Name)
					local __img1 = SAPI.GetImage(material.StrImage, 2, 2, -2, -2)
					if __img1 ~= nil then	
						btMake:SetNormalImage(__img1)
					end

					btMake:SetUltraTextNormal(""..material.HaveCount.."/"..material.MastCount)

					if material.HaveCount < material.MastCount then
						btMake:SetMaskValue(1)
					else
						btMake:SetMaskValue(0)
					end

					if MaxCount > material.HaveCount / material.MastCount then
						MaxCount = math.floor(material.HaveCount / material.MastCount)
					end
				end
				local btMakeAll = SAPI.GetChild(self, "btMakeAll")
				local bt_Make = SAPI.GetChild(self, "bt_Make")

				if MaxCount > 0 then
					btMakeAll:Enable()
					bt_Make:Enable()
				else
					btMakeAll:Disable()
					bt_Make:Disable()
				end

				return
			end
			counter = counter + 1
		end
	end
end

function layWorld_frMakeEx_lstMakeItem_OnLoad(self)
	self:InsertColumn("", 210, 256*256*256*256 - 1, -1, -1, -1)
end

function layWorld_frMakeEx_lstMakeItem_OnSelect(self)
	if self:getSelectLine() ~= UI_Current_Select_Compose_Idx then
		UI_Compose_Count = 1
	end
	UI_Current_Select_Compose_Idx = self:getSelectLine()
	local frMakeEx = uiGetglobal("layWorld.frMakeEx")
	layWorld_frMakeEx_Refresh_Select_Compose(frMakeEx)
end

function layWorld_frMakeEx_btItem_OnHint(self)
	local ItemIndex = self:Get("ItemIndex")
	if ItemIndex == nil then
		self:SetHintRichText(0)
	end

	local richtext = uiItemCompose_GetItemRichTextByIndex(ItemIndex)
	if richtext == nil then
		self:SetHintRichText(0)
	else
		self:SetHintRichText(richtext)
	end
end

function layWorld_frMakeEx_bt_Cancel_OnLClick()
	
	local frMakeEx = uiGetglobal("layWorld.frMakeEx")
	frMakeEx:Hide()
	if UI_Item_Compose_ItemIndex ~= 0 and UI_Item_Compose_ItemIndex ~= nil then
		uiItemCompose_StopComposeItem()
	end

end

function layWorld_frMakeEx_bt_Make_OnLClick()
	if UI_Item_Compose_ItemIndex == 0 then
		if UI_Compose_Count > 0 then
			local btMakeItem = uiGetglobal("layWorld.frMakeEx.btMakeItem")
			local ProductIndex = btMakeItem:Get("ProductIndex")
			
			if ProductIndex ~= nil and ProductIndex ~= 0 then
				
				--uiInfo("layWorld_frMakeEx_bt_Make_OnLClick:"..UI_Compose_Count)
				uiItemCompose_SendComposeItem(ProductIndex)
			end
		end
	end
end

function layWorld_frMakeEx_btMakeAll_OnLClick()
	if UI_Item_Compose_ItemIndex == 0 then
		UI_Compose_Count = layWorld_frMakeEx_GetMaxComposeCount()
		
		if UI_Compose_Count < 1 then
			UI_Compose_Count = 1
		end

		layWorld_frMakeEx_Refresh()

		local btMakeItem = uiGetglobal("layWorld.frMakeEx.btMakeItem")
		local ProductIndex = btMakeItem:Get("ProductIndex")
		if ProductIndex ~= nil and ProductIndex ~= 0 then
			--uiInfo("layWorld_frMakeEx_btMakeAll_OnLClick:"..UI_Compose_Count)
			uiItemCompose_SendComposeItem(ProductIndex)
		end
	end
end

function layWorld_frMakeEx_GetMaxComposeCount()
	local ltData = uiItemCompose_GetItemComposeInfo()
	if ltData == nil then return 0 end
	local counter = 0
	for i, data in ipairs(ltData) do
		local item = uiItemCompose_GetItemBaseInfo(data.ProductItemIndex)
		if item ~= nil then
			if UI_Current_Select_Compose_Idx == counter then

				local MaxCount = 10000

				for j, material in ipairs(data.Materials) do

					if MaxCount > material.HaveCount / material.MastCount then
						MaxCount = math.floor(material.HaveCount / material.MastCount)
					end
				end

				return MaxCount
			end
			counter = counter + 1
		end
	end

	return 0

end

function layWorld_frMakeEx_btMakeLeft_OnLClick()
	UI_Compose_Count = UI_Compose_Count - 1
	if UI_Compose_Count < 1 then
		UI_Compose_Count = 1
	end
	layWorld_frMakeEx_Refresh()
end

function layWorld_frMakeEx_btMakeRight_OnLClick()
	UI_Compose_Count = UI_Compose_Count + 1

	local maxcount = layWorld_frMakeEx_GetMaxComposeCount()

	if UI_Compose_Count > maxcount then
		UI_Compose_Count = maxcount 
	end
	if UI_Compose_Count < 1 then
		UI_Compose_Count = 1
	end
	layWorld_frMakeEx_Refresh()
end

function layWorld_frMakeEx_Recv_Compose_Success(iid, res)
	UI_Item_Compose_ItemIndex = 0

	if res == 0 then return end

	UI_Compose_Count = UI_Compose_Count - 1
	local maxcount = layWorld_frMakeEx_GetMaxComposeCount()

	if UI_Compose_Count > maxcount then
		UI_Compose_Count = maxcount 
	end

	if UI_Compose_Count > 0 then
		local btMakeItem = uiGetglobal("layWorld.frMakeEx.btMakeItem")
		local ProductIndex = btMakeItem:Get("ProductIndex")
		if ProductIndex ~= nil and ProductIndex ~= 0 then
			uiItemCompose_SendComposeItem(ProductIndex)
		end
	end

	if UI_Compose_Count < 1 then
		UI_Compose_Count = 1
	end

	layWorld_frMakeEx_Refresh()
end
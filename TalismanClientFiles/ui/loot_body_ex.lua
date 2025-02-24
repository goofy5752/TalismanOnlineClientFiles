local UI_LOOTBODY_SHOW_ITEM_COUNT = 4
local UI_LootBody_CurrPage = 1
local UI_LootBody_BeLootItems = {}
UI_LootBody_IsLootAll = false


function layWorld_frmLootBodyEx_OnEvent_ViewDropItem(self, npcid)

	UI_LootBody_BeLootItems = {}
	self:Set("NpcOid", npcid)

	layWorld_frmLootBodyEx_Refresh(self, npcid)
end

function layWorld_frmLootBodyEx_OnEvent_LootBodyOne(self, NpcOid, DropId)
	UI_LootBody_BeLootItems[table.getn(UI_LootBody_BeLootItems)+1] = DropId

	layWorld_frmLootBodyEx_Refresh(self, NpcOid)
end

function layWorld_frmLootBodyEx_OnPageChanged(self)
	local frmLootBodyEx = uiGetglobal("layWorld.frmLootBodyEx")
	layWorld_frmLootBodyEx_Refresh(frmLootBodyEx, frmLootBodyEx:Get("NpcOid"))
end

function layWorld_frmLootBodyEx_Refresh(self, NpcOid)
	local count, ltDropItem = uiLootBody_GetViewItemInfo(NpcOid)
	layWorld_frmLootBodyEx_OnPreShow(self, count, ltDropItem)
end

function layWorld_frmLootBodyEx_OnPreShow(self, count, ltDropItem)

	for i=1, UI_LOOTBODY_SHOW_ITEM_COUNT, 1 do
		local btnItem = SAPI.GetChild(self, "Item"..i)
		btnItem:Hide()
		local labItem = SAPI.GetChild(self, "ItemName"..i)
		labItem:Hide()
	end
	
	
	if count == 0 or ltDropItem == nil then
		self:Hide()
		return
	end

	if table.getn(UI_LootBody_BeLootItems) >= count then
		self:Hide()
		return
	end

	local btnNext = SAPI.GetChild(self, "Next")

	if count > UI_LootBody_CurrPage*UI_LOOTBODY_SHOW_ITEM_COUNT then
		btnNext:Show()
	else
		btnNext:Hide()
	end

	local btnPrevious = SAPI.GetChild(self, "Previous")

	if UI_LootBody_CurrPage > 1 then
		btnPrevious:Show()
	else
		btnPrevious:Hide()
	end


	
	for i, item in ipairs(ltDropItem) do		
		for j, dropid in pairs(UI_LootBody_BeLootItems) do
			if dropid == item.Id then
				item.IsLoot = true
				break
			end
		end
		if i > (UI_LootBody_CurrPage-1)*UI_LOOTBODY_SHOW_ITEM_COUNT and i <= UI_LootBody_CurrPage*UI_LOOTBODY_SHOW_ITEM_COUNT then
			local btnItem = SAPI.GetChild(self, "Item"..(i - (UI_LootBody_CurrPage-1)*UI_LOOTBODY_SHOW_ITEM_COUNT))
			local labItem = SAPI.GetChild(self, "ItemName"..(i - (UI_LootBody_CurrPage-1)*UI_LOOTBODY_SHOW_ITEM_COUNT))
			btnItem:Set("ShowHint", false)
			
			btnItem:Set("NpcOid", item.NpcOid)
			btnItem:Set("DropId", item.Id)
			if item.IsLoot then
				btnItem:SetBackgroundImage(0)
				btnItem:Hide()
				labItem:SetText("")
				labItem:Show()
				btnItem:Set("ShowHint", false)
			else
				local strMoney = ""
				if item.Type == EV_NPC_BODY_DROP_TYPE_GOLD then
					btnItem:Show()
					local g,s,c = uiLootBody_GetGoldString(item.Gold)
					if g ~= "0" then
						btnItem:SetBackgroundImage(SAPI.GetImage("ic_gold_1.bmp"))
						strMoney = strMoney..g..uiLanString("msg_mail_const_gold")..s..uiLanString("msg_mail_const_silver")..c..uiLanString("msg_mail_const_bronze")
					elseif s ~= "0" then
						btnItem:SetBackgroundImage(SAPI.GetImage("ic_ag_1.bmp"))
						strMoney = strMoney..s..uiLanString("msg_mail_const_silver")..c..uiLanString("msg_mail_const_bronze")
					elseif c ~= "0" then
						btnItem:SetBackgroundImage(SAPI.GetImage("Money.tga"))
						strMoney = strMoney..c..uiLanString("msg_mail_const_bronze")
					end
					labItem:SetText(strMoney)
					labItem:Show()
					btnItem:Set("ShowHint", false)
				elseif item.Type == EV_NPC_BODY_DROP_TYPE_ITEM then
					if item.Item == nil then
						uiError(string.format("error!  DropItem ItemObject is nil, id=%d", item.Id))
					else
						local itemimage,itemString = uiLootBody_GetBodyItemInfo(item.NpcOid, item.Id)
						if itemimage ~= nil then

							btnItem:SetBackgroundImage(SAPI.GetImage(itemimage))
							btnItem:Show()
							btnItem:Set("ShowHint", true)
						end

						if itemString ~= nil then

							labItem:SetText(itemString)
							labItem:Show()
						end
						
					end
					
				end
			


			end
			

		end
	end


	self:Show()
end

function layWorld_frmLootBodyEx_btItem_OnHint(self)

	if self:Get("NpcOid") == nil or self:Get("DropId") == nil then
		self:SetHintRichText(0)
		return
	end

	if not self:Get("ShowHint") then
		self:SetHintRichText(0)
	else
		local _,_,richstr = uiLootBody_GetBodyItemInfo(self:Get("NpcOid"), self:Get("DropId"))
		if richstr ~= nil then
			self:SetHintRichText(richstr)
		else
			self:SetHintRichText(0)
		end
	end

	
end

function layWorld_frmLootBodyEx_Previous_OnLClick(self)
	UI_LootBody_CurrPage = UI_LootBody_CurrPage - 1
	if UI_LootBody_CurrPage < 1 then
		UI_LootBody_CurrPage = 1
	end
	layWorld_frmLootBodyEx_OnPageChanged(self)
end

function layWorld_frmLootBodyEx_Next_OnLClick(self)
	UI_LootBody_CurrPage = UI_LootBody_CurrPage + 1

	layWorld_frmLootBodyEx_OnPageChanged(self)
end

function layWorld_frmLootBodyEx_OnHide(self)
	for i=1, UI_LOOTBODY_SHOW_ITEM_COUNT, 1 do
		local btnItem = SAPI.GetChild(self, "Item"..i)
		btnItem:Hide()
		local labItem = SAPI.GetChild(self, "ItemName"..i)
		labItem:Hide()
	end

	local btnNext = SAPI.GetChild(self, "Next")
	local btnPrevious = SAPI.GetChild(self, "Previous")
	btnNext:Hide()
	btnPrevious:Hide()
	UI_LootBody_CurrPage = 1
	UI_LootBody_BeLootItems = {}
	UI_LootBody_IsLootAll = false
	uiLootBody_CancelViewDropItem(self:Get("NpcOid"))
end

UI_layWorld_frmLootBodyEx_LootAll_next_i = 1

function layWorld_frmLootBodyEx_OnUpdate(self,delta)
	if not self:getVisible() then
		return
	end
	local NpcOid = self:Get("NpcOid")
	local count, ltDropItem = uiLootBody_GetViewItemInfo(NpcOid)

	if table.getn(UI_LootBody_BeLootItems) >= count then
		self:Hide()
	end

	if UI_LootBody_IsLootAll == true then
		if ltDropItem == nil then
			return
		end

		for i, item in ipairs(ltDropItem) do
			if UI_layWorld_frmLootBodyEx_LootAll_next_i == i then
						
				for j, dropid in pairs(UI_LootBody_BeLootItems) do
					if dropid == item.Id then
						item.IsLoot = true
						break
					end
				end
				if item.IsLoot ~= true then

					UI_LootBody_CurrPage = math.floor(i / UI_LOOTBODY_SHOW_ITEM_COUNT + 1)
					layWorld_frmLootBodyEx_OnPreShow(self, count, ltDropItem)
					uiLootBody_LootOne(NpcOid, item.Id)

					
				end
				break
			end
		end
		if UI_layWorld_frmLootBodyEx_LootAll_next_i <= count then
			UI_layWorld_frmLootBodyEx_LootAll_next_i = UI_layWorld_frmLootBodyEx_LootAll_next_i + 1
		end
	end
end


function layWorld_frmLootBodyEx_btItem_OnLClick(self)
	local NpcOid = self:Get("NpcOid")
	local DropId = self:Get("DropId")
	if NpcOid ~= nil and DropId ~= nil then

		uiLootBody_LootOne(NpcOid, DropId)
	end
end

function layWorld_frmLootBodyEx_btItem_OnRClick(self)
	local NpcOid = self:Get("NpcOid")
	local DropId = self:Get("DropId")

	local ltName =  uiLootBody_GetTeamUserNameList(NpcOid, DropId)

	if ltName == nil then
		return
	end

	if NpcOid ~= nil and DropId ~= nil then
		local menu = uiGetPopupMenu()
		menu:Hide()
		menu:RemoveAll()
		menu:SetHeaderText(uiLanString("msg_loot_body_title"))

		menu:Set("NpcOid", NpcOid)
		menu:Set("DropId", DropId)

		for i, name in ipairs(ltName) do
			menu:AddMenuItem(name, true);
		end

		SAPI.AddDefaultPopupMenuCallBack(layWorld_frmLootBodyEx_btItem_OnRClick_OnPopupMenu);
		uiShowPopupMenu();
	end
end

function layWorld_frmLootBodyEx_btItem_OnRClick_OnPopupMenu(self, idx)
	local NpcOid = self:Get("NpcOid")
	local DropId = self:Get("DropId")
	
	local arglst = {}
	arglst[1] = NpcOid
	arglst[2] = DropId
	arglst[3] = self:getMenuText(idx)

	
	local _,itemString = uiLootBody_GetBodyItemInfo(NpcOid, DropId)
	local msgbox = uiMessageBox(string.format(uiLanString("msg_loot_body_assign_item"), itemString, arglst[3]), "", true, true, true)
	SAPI.AddDefaultMessageBoxCallBack(msgbox, layWorld_frmLootBodyEx_btItem_OnPopupMenu_Ok, nil, arglst)
	
end

function layWorld_frmLootBodyEx_btItem_OnPopupMenu_Ok(event, arglst)
	if event == "Ok" then
		uiLootBody_AssignItem(arglst[1], arglst[2], arglst[3])
	end
end

function layWorld_frmLootBodyEx_btPickAll_OnLClick(self)
	UI_layWorld_frmLootBodyEx_LootAll_next_i = 1;
	UI_LootBody_IsLootAll = true
end

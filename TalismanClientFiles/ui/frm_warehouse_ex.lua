UI_Bank_Npc_Object_Id = 0

local UI_BANK_ALLOWED_MAX_GRID_COUNT = 30
local UI_ULTRABANK_ALLOWED_MAX_COUNT = 12

function layWorld_frmWarehouseEx_OnUpdate(self)
	if uiGuild_NpcDialogCheckDistance(UI_Bank_Npc_Object_Id) ~= true then self:Hide() return end
end

function layWorld_frmWarehouseEx_Bank_Recv_Date(self, arg)
	layWorld_frmWarehouseEx_Refresh()
	layWorld_frmWarebagEx_Refresh()
	UI_Bank_Npc_Object_Id = arg[1]
	if UI_Bank_Npc_Object_Id ~= 0 then
		self:MoveTo(80, 180)
		self:ShowAndFocus()
		local name = uiGetMyInfo("Role")
		local lbWarehouse = SAPI.GetChild(self, "lbWarehouse")
		lbWarehouse:SetText(string.format(uiLanString("MSG_XX_BANK"), name))
	end
end

function layWorld_frmWarehouseEx_Restructuring()
	local self = uiGetglobal("layWorld.frmWarehouseEx")
	
	local lbItems = SAPI.GetChild(self, "lbItems")

	for i = 1, UI_BANK_ALLOWED_MAX_GRID_COUNT, 1 do
		local btItem = SAPI.GetChild(lbItems, "btItem"..i)
		btItem:Hide()
	end

	for i=1, UI_ULTRABANK_ALLOWED_MAX_COUNT, 1 do
		local BtBag = SAPI.GetChild(self, "BtBag"..i)
		BtBag:Hide()
	end

	local info = uiBank_GetBankSystemInfo()
	local slot = info.BankSlot.Bank

	for i=1, info.BankSlot.UltraBank.Page, 1 do
		local BtBag = SAPI.GetChild(self, "BtBag"..i)
		BtBag:Show()
	end

	-- 初始化界面元素
	local width = slot.Right - slot.Left + 1
	local height = slot.Bottom - slot.Top + 1

	lbItems:MoveSize(slot.Left, slot.Top, width, height)

	for i=1, slot.Line, 1 do
		for j=1, slot.Col, 1 do
			local btItem = SAPI.GetChild(lbItems, "btItem"..((i - 1)*slot.Col + j))
			btItem:Show()
			local left = slot.OffsetLeft + (j-1)*slot.Width
			local top = slot.OffsetTop + (i-1)*slot.Height
			local width = slot.OffsetRight - slot.OffsetLeft + 1
			local height = slot.OffsetRight - slot.OffsetLeft + 1
			btItem:MoveSize(left, top, width, height)
		end
	end

end

function layWorld_frmWarehouseEx_Refresh()
	local self = uiGetglobal("layWorld.frmWarehouseEx")
	
	local lbItems = SAPI.GetChild(self, "lbItems")

	local line, col = uiBank_GetBankDefaultLineCol()
	for i=1, line, 1 do
		for j=1, col, 1 do
			local btItem = SAPI.GetChild(lbItems, "btItem"..((i - 1)*col + j))
			btItem:Delete(EV_UI_SHORTCUT_TYPE_KEY)
			btItem:Delete(EV_UI_SHORTCUT_OWNER_KEY)
			btItem:Delete(EV_UI_SHORTCUT_OBJECTID_KEY)
			btItem:Delete(EV_UI_SHORTCUT_CLASSID_KEY)
			local imgstr, itemCount, itemOid, itemCid = uiBank_GetBankItemInfoByLineCol(i, j)
			if imgstr ~= nil then
				local image_item = SAPI.GetImage(imgstr)
				if image_item ~= nil then
					btItem:SetBackgroundImage(image_item)
					btItem:ModifyFlag("DragOut", true)
					btItem:Set(EV_UI_SHORTCUT_TYPE_KEY, EV_SHORTCUT_OBJECT_ITEM)
					btItem:Set(EV_UI_SHORTCUT_OWNER_KEY, EV_UI_SHORTCUT_OWNER_BANK)
					btItem:Set(EV_UI_SHORTCUT_OBJECTID_KEY, itemOid)
					btItem:Set(EV_UI_SHORTCUT_CLASSID_KEY, itemCid)
					if itemCount == -1 or itemCount == nil then
						btItem:SetUltraTextNormal("")
					else
						btItem:SetUltraTextNormal(""..itemCount)
					end
				else
					btItem:SetBackgroundImage(0)
					btItem:ModifyFlag("DragOut", false)
					btItem:SetUltraTextNormal("")
				end
			else
				btItem:SetBackgroundImage(0)
				btItem:ModifyFlag("DragOut", false)
				btItem:SetUltraTextNormal("")
			end

			if btItem:IsHovered() then
				layWorld_frmWarehouseEx_btItem_OnHint(btItem)
			end

		end
	end

	layWorld_frmWarehouseEx_RefreshBankMoney()

	local bagCount = uiBank_GetUltraBagMaxCountLineCol()

	for i=1, bagCount, 1 do
		local BtBag = SAPI.GetChild(self, "BtBag"..i)
		if i > uiBank_GetUltraBagCount() then
			BtBag:SetNormalImage(0)
			BtBag:Disable()
		else
			local imgbag = SAPI.GetImage("ic_it068",2, 2, -2, -2)
			if imgbag ~= nil then
				BtBag:SetNormalImage(imgbag)
			end
			BtBag:Enable()
		end
	end

end

function layWorld_frmWarehouseEx_RefreshBankMoney()
	local self = uiGetglobal("layWorld.frmWarehouseEx")

	local goldnum = SAPI.GetChild(self, "goldnum")
	local silvernum = SAPI.GetChild(self, "silvernum")
	local coppernum = SAPI.GetChild(self, "coppernum")

	local __gold,__silver,__copper = uiBank_GetBankMoney()
	goldnum:SetText(""..__gold)
	silvernum:SetText(""..__silver)
	coppernum:SetText(""..__copper)
end

function layWorld_frmWarehouseEx_btItem_OnHint(self)
	local lbItems = uiGetglobal("layWorld.frmWarehouseEx.lbItems")

	local line, col = uiBank_GetBankDefaultLineCol()
	for i=1, line, 1 do
		for j=1, col, 1 do
			local btItem = SAPI.GetChild(lbItems, "btItem"..((i - 1)*col + j))
			if SAPI.Equal(self, btItem) then
				local _, _, _, _, richText = uiBank_GetBankItemInfoByLineCol(i, j)
				if richText ~= nil then
					self:SetHintRichText(richText)
				else
					self:SetHintRichText(0)
				end
				return
			end
			
		end
	end
end

function layWorld_frmWarehouseEx_btItem_OnRClick(self)

	if self:Get(EV_UI_SHORTCUT_TYPE_KEY) ~= EV_SHORTCUT_OBJECT_ITEM then
		return
	end

	if self:Get(EV_UI_SHORTCUT_OWNER_KEY) ~= EV_UI_SHORTCUT_OWNER_BANK then
		return
	end

	local itemOid = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	if itemOid == nil then
		return
	end

	if UI_Bank_Npc_Object_Id == 0 or UI_Bank_Npc_Object_Id == nil then
		return
	end

	uiBank_TakeOutBankItem(itemOid, UI_Bank_Npc_Object_Id)
end

function layWorld_frmWarehouseEx_btItem_OnDragIn(self, drag)

	if UI_Bank_Npc_Object_Id == 0 or UI_Bank_Npc_Object_Id == nil then
		return
	end

	local lbItems = uiGetglobal("layWorld.frmWarehouseEx.lbItems")
	local wDrag = uiGetglobal(drag)

	if wDrag:Get(EV_UI_SHORTCUT_TYPE_KEY) ~= EV_SHORTCUT_OBJECT_ITEM then
		return
	end

	local itemOid = wDrag:Get(EV_UI_SHORTCUT_OBJECTID_KEY)
	if itemOid == nil then
		return
	end

	local line, col = uiBank_GetBankDefaultLineCol()
	for i=1, line, 1 do
		for j=1, col, 1 do
			local btItem = SAPI.GetChild(lbItems, "btItem"..((i - 1)*col + j))
			if SAPI.Equal(self, btItem) then
				uiBank_ItemPutInDefaultBank(itemOid, i, j, UI_Bank_Npc_Object_Id)
				return
			end
		end

	end
end

function layWorld_frmWarehouseEx_BtBag_OnLClick(self)
	local frmWarehouseEx = uiGetglobal("layWorld.frmWarehouseEx")
	for i=1, uiBank_GetUltraBagCount(), 1 do
		local BtBag = SAPI.GetChild(frmWarehouseEx, "BtBag"..i)
		if SAPI.Equal(self, BtBag) then
			if BtBag:getChecked() then
				layWorld_frmWarebagEx_Show(i)
			else
				layWorld_frmWarebagEx_Hide()
			end
		else
			--BtBag:SetChecked(false)
		end
	end
end

function layWorld_frmWarehouseEx_OnHide()
	layWorld_frmWarebagEx_Hide()
end

function layWorld_frmWarehouseEx_btnSaveMoney_OnLClick()
	local frmBankSetmoneyEx = uiGetglobal("layWorld.frmBankSetmoneyEx")
	frmBankSetmoneyEx:Set("save", true)
	frmBankSetmoneyEx:ShowAndFocus()
end

function layWorld_frmWarehouseEx_btnLoadMoney_OnLClick()
	local frmBankSetmoneyEx = uiGetglobal("layWorld.frmBankSetmoneyEx")
	frmBankSetmoneyEx:Set("save", false)
	frmBankSetmoneyEx:ShowAndFocus()
end

local function SortBagItem (queue_mode, baglist)
	-- 整理背包
	if baglist == nil then  -- 总排序
		baglist = {0}; -- 0 是 默认的仓库
		for bagindex = 1, UI_ULTRABANK_ALLOWED_MAX_COUNT, 1 do
			if bagindex > uiBank_GetUltraBagCount() then
				break;
			else
				local bagEndTime = uiBank_GetUltraBagEndTime(bagindex);
				if bagEndTime == 0 or uiGetServerTime() < bagEndTime then
					table.insert(baglist, bagindex);
				elseif uiGetServerTime() >= bagEndTime then
					--过期
				end
			end
		end
	end
	
	-- 1.数据列表变量 < 叠加 >
	local ItemList_M = {};	-- 叠加道具列表
	local ItemList_P = {};	-- 位置列表
	local ItemList_L = {};	-- 用于排序的道具列表
	
	local ExchangeItem = function (first, second)
		local Temp = {
			ObjectId = first.ObjectId,
			TableId = first.TableId,
			MaxCount = first.MaxCount,
			Count = first.Count,
			Type = first.Type,
			};
		first.ObjectId = second.ObjectId;
		first.TableId = second.TableId;
		first.MaxCount = second.MaxCount;
		first.Count = second.Count;
		first.Type = second.Type;
		
		second.ObjectId = Temp.ObjectId;
		second.TableId = Temp.TableId;
		second.MaxCount = Temp.MaxCount;
		second.Count = Temp.Count;
		second.Type = Temp.Type;
	end
	local ClearItem = function (item)
		item.ObjectId = nil;
		item.TableId = nil;
		item.MaxCount = nil;
		item.Count = nil;
		item.Type = nil;
	end
	
	-- 2.收集数据列表
	for bagindex = 0, UI_ULTRABANK_ALLOWED_MAX_COUNT, 1 do
		if SAPI.ExistInTable(baglist, bagindex) == true then
			local _, line, col, count;
			if bagindex == 0 then
				line, col = uiBank_GetBankDefaultLineCol();
			else
				_, line, col = uiBank_GetUltraBagMaxCountLineCol(bagindex);
			end
			count = uiBank_GetBagItemCount(0);
			local itembag = {maxline = line, maxcol = col};
			for l = 1, line do
				local itemline = {};
				for c = 1, col do
					local iteminfo = {};
					iteminfo.bag = bagindex;
					iteminfo.line = l;
					iteminfo.col = c;
					local ObjectId, TableId;
					if bagindex == 0 then
						_, _, ObjectId, TableId = uiBank_GetBankItemInfoByLineCol(l, c);
					else
						_, _, ObjectId, _, TableId = uiBank_GetBankUltraItemInfoByLineCol(bagindex, l, c);
					end
					if ObjectId then
						iteminfo.ObjectId = ObjectId;
						iteminfo.TableId = TableId;
						local classInfo = uiItemGetItemClassInfoByTableIndex(TableId);
						iteminfo.Type = classInfo.Type;
					end
					table.insert(itemline, iteminfo);
					table.insert(ItemList_L, iteminfo);
					if iteminfo.MaxCount then
						if ItemList_M[TableId] == nil then
							ItemList_M[TableId] = {};
						end
						table.insert(ItemList_M[TableId], iteminfo);
					end
				end
				table.insert(itembag, itemline);
			end
			ItemList_P[bagindex] = itembag;
		end
	end
	--[[
	-- 3.叠加整理 < 叠加 >
	for TableId, ItemList in pairs(ItemList_M) do
		local OpItem = nil;
		for i, v in ipairs(ItemList) do
			local MaxCount = v.MaxCount;
			if v.Count < MaxCount then
				for j = 1, i - 1 do
					OpItem = ItemList[j];
					if OpItem and uiBank_CheckSameBagItemByCoord(v.bag, v.line, v.col, OpItem.bag, OpItem.line, OpItem.col) then
						local totle = OpItem.Count + v.Count;
						if totle > MaxCount then
							--[[
							totle = MaxCount - OpItem.Count;
							uiItemDivideItem(v.bag, v.line, v.col, OpItem.bag, OpItem.line, OpItem.col, totle);
							v.Count = v.Count - totle;
							OpItem.Count = MaxCount;
							OpItem = v;
							]]
						else
							if OpItem.bag == 0 then
								uiBank_ItemPutInDefaultBank(v.ObjectId, OpItem.line, OpItem.col, UI_Bank_Npc_Object_Id)
							else
								uiBank_ItemPutInUltraBank(v.ObjectId, OpItem.bag, OpItem.line, OpItem.col, UI_Bank_Npc_Object_Id)
							end
							ClearItem(v);
							OpItem.Count = OpItem.Count + totle;
							break;
						end
					end
				end
			end
		end
	end
	]]
	
	-- 4.排序 < 移动 >
	local sortfunc = nil;
	if queue_mode == true then
		sortfunc = function (first, second)
						if first.Type == nil then return false end
						if second.Type == nil then return true end
						
						if first.Type == second.Type then
							if first.TableId == second.TableId then
								return first.ObjectId < second.ObjectId;
							end
							return first.TableId < second.TableId;
						end
						
						return first.Type < second.Type;
					end;
	else
		sortfunc = function (first, second)
						if first.Type == nil then return false end
						if second.Type == nil then return true end
						
						if first.Type == second.Type then
							if first.TableId == second.TableId then
								return first.ObjectId > second.ObjectId;
							end
							return first.TableId > second.TableId;
						end
						
						return first.Type > second.Type;
					end;
	end
	table.sort(ItemList_L, sortfunc);

	local SortList = {};
	local index = 1;
	for bagindex = 0, UI_ULTRABANK_ALLOWED_MAX_COUNT, 1 do
		local bag = ItemList_P[bagindex];
		if bag then
			for line, lineitem in ipairs(bag) do
				for col, item in ipairs(lineitem) do
					local itemL = ItemList_L[index];
					if itemL.ObjectId then
						SortList[itemL.ObjectId] = {bag=bagindex, line=line, col=col};
					end
					index = index + 1;
				end
			end
		end
	end
	
	for bagindex = 0, UI_ULTRABANK_ALLOWED_MAX_COUNT, 1 do
		local bag = ItemList_P[bagindex];
		if bag then
			for line, lineitem in ipairs(bag) do
				for col, item in ipairs(lineitem) do
					local move = true;
					while move do
						if item.ObjectId then
							-- 检查是不是需要移动
							local SortItem = SortList[item.ObjectId];
							if SortItem then
								if item.bag == SortItem.bag and item.line == SortItem.line and item.col == SortItem.col then
									move = false;
								else
									local itemto = ItemList_P[SortItem.bag][SortItem.line][SortItem.col];
									if not itemto then
										uiError(string.format("itemto nil error!!![%s][%s][%s]", tostring(SortItem.bag), tostring(SortItem.line), tostring(SortItem.col)));
										return;
									end
									uiBank_ItemPutInDefaultBankFromBank(item.bag, item.line, item.col, itemto.bag, itemto.line, itemto.col, UI_Bank_Npc_Object_Id)
									ExchangeItem(item, itemto);
								end
							else
								uiError(string.format("SortItem nil error!!![Objectid = %s]", tostring(item.ObjectId)));
								return;
							end
						else
							move = false;
						end
					end
				end
			end
		end
	end
	
	
	--[[
	-- 4.数据列表变量 < 移动 >
	local SpaceList = {};
	local ItemList = {};
	
	-- 5.收集数据列表 < 移动 >
	for bagindex = 0, Local_Item_MaxBag - 1 do
		local bag = ItemList_P[bagindex];
		if bag then
			for line, lineitem in ipairs(bag) do
				for col, item in ipairs(lineitem) do
					if item.ObjectId then
						table.insert(ItemList, item);
					else
						table.insert(SpaceList, item);
					end
				end
			end
		end
	end
	
	-- 6.位置整理 < 移动 >
	if table.getn(SpaceList) < table.getn(ItemList) then
		local curindex = table.getn(ItemList);
		-- 如果空格在道具之前，则移动之
		for i, v in ipairs(SpaceList) do
			vItem = ItemList[curindex];
			if vItem.bag < v.bag then
				break;
			elseif vItem.bag == v.bag then
				if vItem.line < v.line then
					break;
				elseif vItem.line == v.line then
					if vItem.col <= v.col then
						break;
					end
				end
			end
			uiItemMoveItem(vItem.bag, vItem.line, vItem.col, v.bag, v.line, v.col);
			curindex = curindex - 1;
		end
	else
		local curindex = 1;
		local v = nil;
		for i = table.getn(ItemList), 1, -1 do
			vSpace = SpaceList[curindex];
			v = ItemList[i];
			if vSpace.bag > v.bag then
				break;
			elseif vSpace.bag == v.bag then
				if vSpace.line > v.line then
					break;
				elseif vSpace.line == v.line then
					if vSpace.col >= v.col then
						break;
					end
				end
			end
			uiItemMoveItem(v.bag, v.line, v.col, vSpace.bag, vSpace.line, vSpace.col);
			curindex = curindex + 1;
		end
	end
	]]
end

function layWorld_frmWarehouseEx_btSort_OnLClick(self)
	SortBagItem (true);
end


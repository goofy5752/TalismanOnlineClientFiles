function hntDefaultHint_OnHintBindWidget(self, bind)
	--uiInfo("bind = "..bind);
	if not bind or bind == "" then return end
	local BindWidget = uiGetglobal(bind);
	--uiInfo("BindWidget = "..tostring(BindWidget));
	if not BindWidget then return end

	local allow_owners = 
	{
		EV_UI_SHORTCUT_OWNER_BANK,
		EV_UI_SHORTCUT_OWNER_MAIL,
		EV_UI_SHORTCUT_OWNER_NPC_SHOP_BUY_SHOP,
		EV_UI_SHORTCUT_OWNER_NPC_SHOP_SALE_SHOP,
		EV_UI_SHORTCUT_OWNER_GUILD_BANK,
		EV_UI_SHORTCUT_OWNER_ITEM,
		EV_UI_SHORTCUT_OWNER_SHORTCUT,
		EV_UI_SHORTCUT_OWNER_AUCTION,
		EV_UI_SHORTCUT_OWNER_SIGN,
		EV_UI_SHORTCUT_OWNER_UNSIGN,
		IsAllowed = function(self, owner)
			if owner == nil then return false end
			for i, v in ipairs(self) do
				if v == owner then return true end
			end
			return false;
		end
	};
	
	local Owner = BindWidget:Get(EV_UI_SHORTCUT_OWNER_KEY);
	if allow_owners:IsAllowed(Owner) == false then return end
	
	local Type = BindWidget:Get(EV_UI_SHORTCUT_TYPE_KEY);
	--uiInfo("Type = "..tostring(Type));
	if not Type or Type ~= EV_SHORTCUT_OBJECT_ITEM then return end
	local classid = BindWidget:Get(EV_UI_SHORTCUT_CLASSID_KEY);
	--uiInfo("classid = "..tostring(classid));
	if not classid or classid == 0 then return end
	
	local classinfo = uiItemGetItemClassInfoByTableIndex(classid);
	--uiInfo("classinfo = "..tostring(classinfo));
	if not classinfo then return end
	
	local itemType = classinfo.Type;
	--uiInfo("itemType = "..tostring(itemType));
	
	local AppendSubHint = function (hintwidget, hint, empty)
		if not hint or empty then return end
		local SubHint = hintwidget:GetFirstIdleSubHintWidget();
		if not SubHint then return end
		local item = EvUiLuaClass_RichTextItem:new();
		item.Type = "TEXT";
		item.Color = "#FFD00000";
		item.Text = LAN("MSG_HINT_CURRENT_EQUIP_PREFIX");
		
		local line = EvUiLuaClass_RichTextLine:new();
		line:InsertItem(item);
		local rich_text = EvUiLuaClass_RichText:new();
		rich_text:InsertLine(line);
		
		SubHint:SetRichText(rich_text:ToRichString());
		SubHint:AppendRichTextEx(hint);
	end
	
	local CreateSubHint = function (hintwidget, equiptype)
		--uiInfo("equiptype = "..tostring(equiptype));
		local hint, empty = uiItemGetEquipedItemHintByPart(equiptype);
		--uiInfo("hint = "..tostring(hint));
		--uiInfo("empty = "..tostring(empty));
		AppendSubHint(hintwidget, hint, empty);
	end
	
	if itemType == EV_ITEM_TYPE_MAINTRUMP then				--主法宝
		CreateSubHint(self, EV_EQUIP_PART_MAINTRUMP);
	elseif itemType == EV_ITEM_TYPE_SUBTRUMP then			--辅助法宝
		CreateSubHint(self, EV_EQUIP_PART_SUBTRUMP1);
		CreateSubHint(self, EV_EQUIP_PART_SUBTRUMP2);
	elseif itemType == EV_ITEM_TYPE_CLOTHING then			--盔甲
		CreateSubHint(self, EV_EQUIP_PART_CLOTHING);
	elseif itemType == EV_ITEM_TYPE_GLOVE then				--手套
		CreateSubHint(self, EV_EQUIP_PART_GLOVE);
	elseif itemType == EV_ITEM_TYPE_SHOES then				--鞋子
		CreateSubHint(self, EV_EQUIP_PART_SHOES);
	elseif itemType == EV_ITEM_TYPE_CUFF then				--护腕
		CreateSubHint(self, EV_EQUIP_PART_CUFF);
	elseif itemType == EV_ITEM_TYPE_KNEEPAD then			--护膝
		CreateSubHint(self, EV_EQUIP_PART_KNEEPAD);
	elseif itemType == EV_ITEM_TYPE_SASH then				--腰带
		CreateSubHint(self, EV_EQUIP_PART_SASH);
	elseif itemType == EV_ITEM_TYPE_RING then				--戒指
		CreateSubHint(self, EV_EQUIP_PART_RING1);
		CreateSubHint(self, EV_EQUIP_PART_RING2);
	elseif itemType == EV_ITEM_TYPE_AMULET then				--护身符
		CreateSubHint(self, EV_EQUIP_PART_AMULET1);
		CreateSubHint(self, EV_EQUIP_PART_AMULET2);
	elseif itemType == EV_ITEM_TYPE_PANTS then				--裤子
		CreateSubHint(self, EV_EQUIP_PART_PANTS);
	elseif itemType == EV_ITEM_TYPE_CLOAK then				--披风
		CreateSubHint(self, EV_EQUIP_PART_CLOAK);
	elseif itemType == EV_ITEM_TYPE_HELM then				--裤子
		CreateSubHint(self, EV_EQUIP_PART_HELM);
	elseif itemType == EV_ITEM_TYPE_SHOULDER then			--肩甲
		CreateSubHint(self, EV_EQUIP_PART_SHOULDER);
	end
end






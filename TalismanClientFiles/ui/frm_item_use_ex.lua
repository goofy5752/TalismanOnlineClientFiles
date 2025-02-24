Local_Item_UseItemDispatcher = -- 道具使用的分发器 -- 指定 某一 类型 道具 使用方式
{
	VarItemUse = 0,
	VarItemTarget = 0,
}

function Local_Item_UseItemDispatcher:Init()
	self:Reset();
	-- 注册自定义的处理函数 由分发系统来调用
	self[EV_ITEM_TYPE_CLEARTALENTS]			= Local_Item_UseItemDispatcher_EV_ITEM_TYPE_CLEARTALENTS			;		-- 法宝洗点符
	self[EV_ITEM_TYPE_GREENTOBLUE]			= Local_Item_UseItemDispatcher_EV_ITEM_TYPE_GREENTOBLUE				;		-- 绿色装备转换到蓝色
	self[EV_ITEM_TYPE_GEMMY]				= Local_Item_UseItemDispatcher_EV_ITEM_TYPE_GEMMY					;		-- 镶嵌用的魔石
	self[EV_ITEM_TYPE_GEMMYCLEAR]			= Local_Item_UseItemDispatcher_EV_ITEM_TYPE_GEMMYCLEAR				;		-- 破环魔石镶嵌
	self[EV_ITEM_TYPE_ENCHANTCLEAR]			= Local_Item_UseItemDispatcher_EV_ITEM_TYPE_ENCHANTCLEAR			;		-- 解除灵魂绑定
	self[EV_ITEM_TYPE_BULLETINTOUSER]		= Local_Item_UseItemDispatcher_EV_ITEM_TYPE_BULLETINTOUSER			;		-- 发送公告给玩家
	self[EV_ITEM_TYPE_SMALLPETPOINTSCLEAR]	= Local_Item_UseItemDispatcher_EV_ITEM_TYPE_SMALLPETPOINTSCLEAR		;		-- 小宠物洗点道具
	self[EV_ITEM_TYPE_CALLFRIEND]			= Local_Item_UseItemDispatcher_EV_ITEM_TYPE_CALLFRIEND				;		-- 召唤玩家到自己身边
	self[EV_ITEM_TYPE_CHANGESMALLPETAPPEARANCE]	= Local_Item_UseItemDispatcher_EV_ITEM_TYPE_CHANGESMALLPETAPPEARANCE				;		-- 改变小宠物外形
end

function Local_Item_UseItemDispatcher:Reset()
	self.VarItemUse = 0;
	self.VarItemTarget = 0;
	--uiSetGameCursor(EV_GAME_CURSOR_NORMAL);
end

function Local_Item_UseItemDispatcher:IsProcessing()
	if self.VarItemUse == 0 or uiGetGameCursor() == EV_GAME_CURSOR_NORMAL then
		return false;
	end
	return true;
end

function Local_Item_UseItemDispatcher:Use(id, usetoself) -- id为道具的ObjectId

	if LClass_ItemFreezeManager:IsFreezed(id) == true then
		return;
	end
	self.VarItemUse = id;
	local objInfo, classInfo = self:GetUseItemInfo();
	if objInfo == nil then
		self:Reset();
		return false;
	end
	--[[
	if usetoself then
		if classInfo["m_UseParam.TargetType"] == 1 then
			local myObjectId = uiGetMyInfo("ObjectId");
			return self:Target(myObjectId);
		end
		self:Reset();
		return false;
	end
	]]
	local Type = classInfo.Type;
	if self[Type] == nil then Type = "_Default_" end -- 如果没有注册对应的函数,则使用默认函数
	return self[Type](self, 1);
end

function Local_Item_UseItemDispatcher:Target(targetid) -- id为目标道具的ObjectId
	self.VarItemTarget = targetid;
	local objInfo, classInfo = self:GetUseItemInfo();
	if objInfo == nil or classInfo == nil or self[classInfo.Type] == nil then
		self:Reset();
		return false;
	end
	return self[classInfo.Type](self, 2);
end

function Local_Item_UseItemDispatcher:Release(param) -- param 参数 不同的调用 参数的类型和意义可能不用 只为调用uiItemReleaseItem准备
	local bResult = false;
	if param == nil then param = 0 end
	local objInfo, classInfo = self:GetUseItemInfo();
	if objInfo == nil then return false end
	local id, Type, Bind, Name = objInfo.ObjectId, classInfo.Type, objInfo.Bind, classInfo.Name;
	
	if LClass_ItemFreezeManager:IsFreezed(id) == true then
		return;
	end
	
	if Bind == EV_ITEM_BIND_EQUIP then
		-- 提示 玩家 道具 操作后将绑定
		local title = "";
		local msg = "";
		if Type == EV_ITEM_TYPE_MAINTRUMP or Type == EV_ITEM_TYPE_SUBTRUMP then
			msg = string.format(LAN("MSG_EQUIP_CONFIRM"), Name);
		else
			msg = string.format(LAN("MSG_ITEM_USE_CONFIRM"), Name);
		end
		local form = uiMessageBox(msg, title, true, true, true);
		local MsgArg = -- 生成MessageBox的临时参数
		{
			item		=	id,
			param		=	param,
		}
		SAPI.AddDefaultMessageBoxCallBack(form, function(Event, Arg) uiItemReleaseItem(Arg.item, Arg.param) end, nil, MsgArg);
		bResult = true;
	else
		bResult = uiItemReleaseItem(id, param);
	end
	self:Reset();
	return bResult;
end

function Local_Item_UseItemDispatcher:GetItemInfo(id)
	if id == nil or id == 0 then return nil end
	local objInfo = uiItemGetBagItemInfoByObjectId(id);
	if objInfo == nil then return nil end
	local index = objInfo.TableId; -- 道具表格id
	if index == nil or index == 0 then return nil end
	local classInfo = uiItemGetItemClassInfoByTableIndex(index);
	if classInfo == nil then return nil end
	return objInfo, classInfo;
end

function Local_Item_UseItemDispatcher:GetUseItemInfo()
	return self:GetItemInfo(self.VarItemUse);
end

function Local_Item_UseItemDispatcher:GetTargetItemInfo()
	return self:GetItemInfo(self.VarItemTarget);
end

-- 默认的处理
function Local_Item_UseItemDispatcher:_Default_()
	local objInfo, classInfo = self:GetUseItemInfo();
	if objInfo == nil then return false end
	if classInfo == nil then return false end
	local ItemUseMessage = classInfo.ItemUseMessage;
	if ItemUseMessage and type(ItemUseMessage) == "string" and ItemUseMessage ~= "" then
		---------------  提示玩家  -----------------
		local msg1 = string.format(LAN("item_check_use_item"), classInfo.Name);
		local msg = string.format("%s\n\n%s", msg1, ItemUseMessage);
		local title = "";
		local form = uiMessageBox(msg, title, true, true, true);
		local MsgArg = -- 生成MessageBox的临时参数
		{
			Dispatcher	=	self;
		}
		SAPI.AddDefaultMessageBoxCallBack(form, function(Event, Arg) Arg.Dispatcher:Release(Arg.param) end, nil, MsgArg);
		return false;
	end
	return self:Release();
end
-- 法宝洗点符 -- 91 -- 已测试 -- 正常
function Local_Item_UseItemDispatcher_EV_ITEM_TYPE_CLEARTALENTS (self, step) -- 第二个参数为步骤 (1:使用道具 2:选择目标)
	local UseCursor = EV_GAME_CURSOR_MINE;
	if step == 1 then -- 第一步,使用道具
		return uiSetGameCursor(UseCursor);
	elseif step == 2 then -- 第二步,选择目标
		local cursor = uiGetGameCursor();
		if cursor ~= UseCursor then return false end -- 检查当前图标状态
		local objInfo, classInfo = self:GetTargetItemInfo();
		if objInfo == nil then return false end
		---------------  开始检查  -----------------
		-- 检查目标道具类型
		if (classInfo.Type ~= EV_ITEM_TYPE_MAINTRUMP and classInfo.Type ~= EV_ITEM_TYPE_SUBTRUMP) then
			uiClientMsg(LAN("msg_talent_can_not"), true); -- 目标必须是法宝。
			return false;
		end
		-- 检查目标道具的加点情况
		if (objInfo.WeaponTalentSize == 0) then
			uiClientMsg(LAN("msg_talent_notalents"), true); -- 这个法宝没有升级过任何天赋。
			return false;
		end
		---------------  检查通过  -----------------
		local TargetName = classInfo.Name;
		local title = "";
		local msg = string.format(LAN("msg_talent_clear_sure"), TargetName); -- 你确定要重置[%s]的天赋吗？
		---------------  提示玩家  -----------------
		local form = uiMessageBox(msg, title, true, true, true);
		local MsgArg = -- 生成MessageBox的临时参数
		{
			Dispatcher	=	self;
			param		=	self.VarItemTarget,
		}
		SAPI.AddDefaultMessageBoxCallBack(form, function(Event, Arg) Arg.Dispatcher:Release(Arg.param) end, nil, MsgArg);
		uiSetGameCursor(EV_GAME_CURSOR_NORMAL);
		return true;
	end
	return false;
end
-- 绿色装备转换到蓝色 -- 53 -- 已测试 -- 正常
function Local_Item_UseItemDispatcher_EV_ITEM_TYPE_GREENTOBLUE(self, step)
	local UseCursor = EV_GAME_CURSOR_MINE;
	if step == 1 then -- 第一步,使用道具
		return uiSetGameCursor(UseCursor);
	elseif step == 2 then -- 第二步,选择目标
		local cursor = uiGetGameCursor();
		if cursor ~= UseCursor then return false end -- 检查当前图标状态
		local objInfoUse, classInfoUse = self:GetUseItemInfo();
		if objInfoUse == nil then return false end
		local objInfo, classInfo = self:GetTargetItemInfo();
		if objInfo == nil then return false end
		---------------  开始检查  -----------------
		-- 检查目标道具类型
		if (classInfo.Type < EV_ITEM_TYPE_EQUIP_MIN or classInfo.Type >= EV_ITEM_TYPE_EQUIP_MAX) then
			uiClientMsg(LAN("msg_gtob_must_weaarm"), true); -- 目标必须是法宝或装备。
			return false;
		end
		-- 检查目标道具颜色
		local list = SAPI.SplitString(classInfoUse.OtherParam2, ";");
		local index = SAPI.GetIndexInTable(list, tostring(objInfo.Color));
		if index == nil or index == 0 then
			uiClientMsg(LAN("msg_gtob_must_green"), true);
			return false;
		end
		-- 检查目标道具是否可装备
		local bCanEquip, strError = uiItemCheckBagItemEquipCondition(self.VarItemTarget);
		if bCanEquip == false then
			uiClientMsg(LAN("msg_gtob_must_canequip"), true);
			return false;
		end
		---------------  检查通过  -----------------
		local TargetName = classInfo.Name;
		local title = "";
		local msg = string.format(LAN("msg_gtob_ask"), TargetName); -- 你确定要转化[%s]的属性吗？
		---------------  提示玩家  -----------------
		local form = uiMessageBox(msg, title, true, true, true);
		local MsgArg = -- 生成MessageBox的临时参数
		{
			Dispatcher	=	self;
			param		=	self.VarItemTarget,
		}
		SAPI.AddDefaultMessageBoxCallBack(form, function(Event, Arg) Arg.Dispatcher:Release(Arg.param) end, nil, MsgArg);
		uiSetGameCursor(EV_GAME_CURSOR_NORMAL);
		return true;
	end
	return false;
end
-- 镶嵌用的魔石 -- 54 -- 已测试 -- 正常
function Local_Item_UseItemDispatcher_EV_ITEM_TYPE_GEMMY(self, step)
	local UseCursor = EV_GAME_CURSOR_MINE;
	if step == 1 then -- 第一步,使用道具
		return uiSetGameCursor(UseCursor);
	elseif step == 2 then -- 第二步,选择目标
		local cursor = uiGetGameCursor();
		if cursor ~= UseCursor then return false end -- 检查当前图标状态
		local objInfoUse, classInfoUse = self:GetUseItemInfo();
		if objInfoUse == nil then return false end
		local objInfo, classInfo = self:GetTargetItemInfo();
		if objInfo == nil then return false end
		---------------  开始检查  -----------------
		-- 检查是否可以镶嵌
		local bCanGemmy, strError = uiItemCheckBagItemGemmyItem(self.VarItemTarget, self.VarItemUse);
		if bCanGemmy == false then
			if strError ~= nil and string.len(strError) > 0 then
				uiClientMsg(strError, true);
			end
			return false;
		end
		local day = tonumber(classInfoUse.InitData) / 24;
		---------------  检查通过  -----------------
		local TargetName = classInfo.Name;
		local title = "";
		local msg = string.format(LAN("msg_gemmy_ask"), TargetName, day); -- 镶嵌后魔石将附在[%s]上，%d天之后该属性自动消失。你现在确定要这样做吗？
		---------------  提示玩家  -----------------
		local form = uiMessageBox(msg, title, true, true, true);
		local MsgArg = -- 生成MessageBox的临时参数
		{
			Dispatcher	=	self;
			param		=	self.VarItemTarget,
		}
		SAPI.AddDefaultMessageBoxCallBack(form, function(Event, Arg) Arg.Dispatcher:Release(Arg.param) end, nil, MsgArg);
		uiSetGameCursor(EV_GAME_CURSOR_NORMAL);
		return true;
	end
	return false;
end
-- 破环魔石镶嵌 -- 57 -- 已测试 -- 正常
function Local_Item_UseItemDispatcher_EV_ITEM_TYPE_GEMMYCLEAR(self, step)
	local UseCursor = EV_GAME_CURSOR_MINE;
	if step == 1 then -- 第一步,使用道具
		return uiSetGameCursor(UseCursor);
	elseif step == 2 then -- 第二步,选择目标
		local cursor = uiGetGameCursor();
		if cursor ~= UseCursor then return false end -- 检查当前图标状态
		local objInfo, classInfo = self:GetTargetItemInfo();
		if objInfo == nil then return false end
		---------------  开始检查  -----------------
		-- 检查是否可以镶嵌
		local bCanClear, strError = uiItemCheckBagItemGemmyClear(self.VarItemTarget, self.VarItemUse);
		if bCanClear == false then
			if strError ~= nil and string.len(strError) > 0 then
				uiClientMsg(strError, true);
			end
			return false;
		end
		---------------  检查通过  -----------------
		local TargetName = classInfo.Name;
		local title = "";
		local msg = string.format(LAN("msg_gemmy_clear_ask"), TargetName); -- 你确定要破环掉[%s]上的魔石的能量吗？
		---------------  提示玩家  -----------------
		local form = uiMessageBox(msg, title, true, true, true);
		local MsgArg = -- 生成MessageBox的临时参数
		{
			Dispatcher	=	self;
			param		=	self.VarItemTarget,
		}
		SAPI.AddDefaultMessageBoxCallBack(form, function(Event, Arg) Arg.Dispatcher:Release(Arg.param) end, nil, MsgArg);
		uiSetGameCursor(EV_GAME_CURSOR_NORMAL);
		return true;
	end
	return false;
end
-- 解除灵魂绑定 -- 106 -- 已测试 -- 正常
function Local_Item_UseItemDispatcher_EV_ITEM_TYPE_ENCHANTCLEAR(self, step)
	local UseCursor = EV_GAME_CURSOR_MINE;
	if step == 1 then -- 第一步,使用道具
		return uiSetGameCursor(UseCursor);
	elseif step == 2 then -- 第二步,选择目标
		local cursor = uiGetGameCursor();
		if cursor ~= UseCursor then return false end -- 检查当前图标状态
		local objInfo, classInfo = self:GetTargetItemInfo();
		if objInfo == nil then return false end
		---------------  开始检查  -----------------
		-- 检查是否可以解除灵魂绑定
		local bCanClear, strError = uiItemCheckBagItemEnchantClear(self.VarItemTarget, self.VarItemUse);
		if bCanClear == false then
			if strError ~= nil and string.len(strError) > 0 then
				uiClientMsg(strError, true);
			end
			return false;
		end
		---------------  检查通过  -----------------
		local TargetName = classInfo.Name;
		local title = "";
		local msg = string.format(LAN("msg_enchant_clear_ask"), TargetName); -- 你确定要清除掉[%s]的灵魂锁定吗？
		local form = uiMessageBox(msg, title, true, true, true);
		local MsgArg = -- 生成MessageBox的临时参数
		{
			Dispatcher	=	self;
			param		=	self.VarItemTarget,
		}
		SAPI.AddDefaultMessageBoxCallBack(form, function(Event, Arg) Arg.Dispatcher:Release(Arg.param) end, nil, MsgArg);
		uiSetGameCursor(EV_GAME_CURSOR_NORMAL);
		return true;
	end
	return false;
end
-- 发送公告给玩家 -- 58 -- 已测试 -- 正常
function Local_Item_UseItemDispatcher_EV_ITEM_TYPE_BULLETINTOUSER(self, step)
	local frmBlessingsCard = uiGetglobal("layWorld.frmBlessingsCard");
	layWorld_frmBlessingsCard_OnEvent(frmBlessingsCard, "EVENT_ItemUseIndirect", {self.VarItemUse});
	return true;
end
-- 小宠物洗点道具 -- 107
function Local_Item_UseItemDispatcher_EV_ITEM_TYPE_SMALLPETPOINTSCLEAR(self, step)
	local title = "";
	local msg = string.format(LAN("MSG_CLEARSMALLPETPOINTS_ASK")); -- 你确定要清除掉当前小宠物的属性点数吗？
	local form = uiMessageBox(msg, title, true, true, true);
	local MsgArg = -- 生成MessageBox的临时参数
	{
		Dispatcher	=	self;
	}
	SAPI.AddDefaultMessageBoxCallBack(form, function(Event, Arg) Arg.Dispatcher:Release() end, nil, MsgArg);
	return true;
end
-- 召唤玩家到自己身边 --
function Local_Item_UseItemDispatcher_EV_ITEM_TYPE_CALLFRIEND(self, step)
	local title = "";
	local msg = string.format(LAN("msg_input_callfriend")); -- 请输入你要召唤的玩家的名字：
	local form = uiInputBox(msg, title, "", true, true, true);
	local MsgArg = -- 生成MessageBox的临时参数
	{
		Dispatcher	=	self;
	}
	SAPI.AddDefaultInputBoxCallBack(form, function(Event, Arg, text) Arg.Dispatcher:Release(text) end, nil, MsgArg);
	return true;
end
-- 改变小宠物外形 -- 150
function Local_Item_UseItemDispatcher_EV_ITEM_TYPE_CHANGESMALLPETAPPEARANCE(self, step)
	local objInfoUse, classInfoUse = self:GetUseItemInfo();
	if not objInfoUse then return false end

	--local LastTime = tonumber(classInfoUse.OtherParam2);
	local modelid = tonumber(classInfoUse.OtherParam1);
	--if not LastTime or not modelid then return false end
	
	local id = uiUserGetCurrentNonCombatPetInfo();
	if not id then uiClientMsg(LAN("msg_change_smallpet_appearance1"), false) return false end -- 必须在小宠物放出的情况下才能使用该道具

	local modelInfo = uiModel_GetModelInfo(modelid);
	if not modelInfo then return false end

	--local year, month, day, hour, minute, second = uiFormatTime(uiGetServerTime() + LastTime);
	
	local title = "";
	local msg = string.format(LAN("msg_change_smallpet_appearance2"), modelInfo.Name); -- 您将把当前小宠物变身成%s，如果原来有变身效果，将被覆盖，您确定
	
	local form = uiMessageBox(msg, title, true, true, true);
	local MsgArg = -- 生成MessageBox的临时参数
	{
		Dispatcher	=	self;
	}
	SAPI.AddDefaultMessageBoxCallBack(form, function(Event, Arg) Arg.Dispatcher:Release() end, nil, MsgArg);
	return true;
end














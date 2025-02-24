
-- 刷新指定装备
function TemplateBtnOtherEquip_Refresh(self)
	local part = self:Get(EV_UI_EQUIP_PART_KEY);
	local id, classid = uiSeeEquipGetCurEquipItemByPart(part); -- 获取此部位的当前装备
	if id == nil or id == 0 or classid == nil or classid == 0 then
		self:Delete(EV_UI_SHORTCUT_OBJECTID_KEY);
		self:Delete(EV_UI_SHORTCUT_CLASSID_KEY);
		self:SetNormalImage(0); -- 清除图标
	else
		self:Set(EV_UI_SHORTCUT_OBJECTID_KEY, id);
		self:Set(EV_UI_SHORTCUT_CLASSID_KEY, classid);
		local tableInfo = uiItemGetItemClassInfoByTableIndex(classid); -- 道具的静态信息
		self:SetNormalImage(SAPI.GetImage(tableInfo.Icon)); -- 设置图标
	end
end
function layWorld_frmItemlookEx_modelOther_RefreshPart(self, part)
	uiInfo("layWorld_frmItemlookEx_modelOther_RefreshPart[ "..tostring(part).." ]")
	local model_pre = "SELF_SUB_MODEL";
	local path_pre = "SELF_SUB_PATH";
	if self == nil then self = uiGetglobal("layWorld.frmItemlookEx.modelOther") end
	local model= uiSeeEquipGetCurEquipModelByPart(part);
	local equip_mode, param = uiSeeEquipGetEquipParamByPart(part);
	if equip_mode == nil then return end
	if equip_mode == EV_EQUIP_MODE_LOAD_SKIN then
		self:UnloadSkin(model_pre..part);
		if model == nil or model[1] == nil then
			self:UnloadSkin(model_pre..part);
		else
			self:LoadSkin(model_pre..part, model[1]);
			uiInfo("SKIN="..model[1]);
		end
	elseif equip_mode == EV_EQUIP_MODE_LINK then
		local slot = param.Slot;
		for i, s in ipairs(slot) do
			local short_name = model_pre..part..i;
			if model == nil or model[i] == nil then
				self:UnlinkModel(short_name);
			else
				local m = model[i];
				self:LinkModel(m, short_name, s);
				uiInfo("LINK="..m);
			end
		end
	elseif equip_mode == EV_EQUIP_MODE_LINK_WITH_PATH then
		local path = param.Path;
		self:LinkModel(path.Name, path_pre, path.Slot);
		local slot = param.Slot;
		for i, s in ipairs(slot) do
			local short_name = model_pre..part..i;
			local full_name = path_pre.."."..short_name;
			if model == nil or model[1] == nil then
				self:UnlinkModel(full_name);
			else
				local m = model[1];
				self:LinkSubModel(m, short_name, s, path_pre);
				uiInfo("EV_EQUIP_MODE_LINK_WITH_PATH="..m);
			end
		end
	end
end
function layWorld_frmItemlookEx_modelOther_Refresh(self)
	if self == nil then self = uiGetglobal("layWorld.frmItemlookEx.modelOther") end
	self:ClearModel();
	self:SetCameraEye(0, -80, 50, true);
	self:SetCameraLookAt(0, 0, 25);
	self:SetCameraUp(0, 0, 1);
	local model = uiSeeEquipGetCurModel();
	uiInfo("model="..model);
	if model == nil then return end
	local head, hair = uiSeeEquipGetCurAppearance();
	if head == nil then return end
	self:SetModel(model);
	self:LoadSkin("head", head);
	self:LoadSkin("hair", hair);
	layWorld_frmItemlookEx_modelOther_RefreshPart(self, EV_EQUIP_PART_MAINTRUMP);			--主法宝
	layWorld_frmItemlookEx_modelOther_RefreshPart(self, EV_EQUIP_PART_SUBTRUMP1);            --辅助法宝1
	layWorld_frmItemlookEx_modelOther_RefreshPart(self, EV_EQUIP_PART_SUBTRUMP2);            --辅助法宝2
	layWorld_frmItemlookEx_modelOther_RefreshPart(self, EV_EQUIP_PART_CLOTHING);             --盔甲
	layWorld_frmItemlookEx_modelOther_RefreshPart(self, EV_EQUIP_PART_GLOVE);                --手套
	layWorld_frmItemlookEx_modelOther_RefreshPart(self, EV_EQUIP_PART_SHOES);                --鞋子
	layWorld_frmItemlookEx_modelOther_RefreshPart(self, EV_EQUIP_PART_CUFF);                 --护腕
	layWorld_frmItemlookEx_modelOther_RefreshPart(self, EV_EQUIP_PART_KNEEPAD);              --护膝
	layWorld_frmItemlookEx_modelOther_RefreshPart(self, EV_EQUIP_PART_SASH);                 --腰带
	layWorld_frmItemlookEx_modelOther_RefreshPart(self, EV_EQUIP_PART_RING1);                --戒指1
	layWorld_frmItemlookEx_modelOther_RefreshPart(self, EV_EQUIP_PART_RING2);                --戒指2
	layWorld_frmItemlookEx_modelOther_RefreshPart(self, EV_EQUIP_PART_AMULET1);              --护身符1
	layWorld_frmItemlookEx_modelOther_RefreshPart(self, EV_EQUIP_PART_AMULET2);              --护身符2
	layWorld_frmItemlookEx_modelOther_RefreshPart(self, EV_EQUIP_PART_PANTS);                --裤子
	layWorld_frmItemlookEx_modelOther_RefreshPart(self, EV_EQUIP_PART_CLOAK);                --披风
	layWorld_frmItemlookEx_modelOther_RefreshPart(self, EV_EQUIP_PART_HELM);                 --头盔
	layWorld_frmItemlookEx_modelOther_RefreshPart(self, EV_EQUIP_PART_SHOULDER);             --护肩
end
-- 刷新所有装备
function TemplateBtnOtherEquip_RefreshAll()
	local form = uiGetglobal("layWorld.frmItemlookEx");
	for i = 0,12,1 do
		local btPart = SAPI.GetChild(form, "btPart"..i);
		TemplateBtnOtherEquip_Refresh(btPart); -- 逐个刷新
	end
	local modelOther = SAPI.GetChild(form, "modelOther");
	layWorld_frmItemlookEx_modelOther_Refresh(modelOther);
end
function TemplateBtnOtherEquip_OnLoad(self)
	self:RegisterScriptEventNotify("EVENT_SelfEnterWorld");
end
function TemplateBtnOtherEquip_OnEvent(self, event, Arg)
	if event == "EVENT_SelfEnterWorld" then
		local t_equip_part =
		{
			["btPart0"] = EV_EQUIP_PART_CLOTHING,	-- 盔甲
			["btPart1"] = EV_EQUIP_PART_SASH,		--  腰带
			["btPart2"] = EV_EQUIP_PART_CUFF,		--  护腕
			["btPart3"] = EV_EQUIP_PART_GLOVE,		--  手套
			["btPart4"] = EV_EQUIP_PART_KNEEPAD,	--  护膝
			["btPart5"] = EV_EQUIP_PART_MAINTRUMP,	--  主法宝
			["btPart6"] = EV_EQUIP_PART_SUBTRUMP1,	--  辅助法宝
			["btPart7"] = EV_EQUIP_PART_SUBTRUMP2,	--  辅助法宝
			["btPart8"] = EV_EQUIP_PART_SHOES,		--  鞋子
			["btPart9"] = EV_EQUIP_PART_AMULET1,	--  护身符
			["btPart10"] = EV_EQUIP_PART_AMULET2,	--  护身符
			["btPart11"] = EV_EQUIP_PART_RING1,		--  戒指
			["btPart12"] = EV_EQUIP_PART_RING2,		--  戒指
		}
		local name = self:getShortName();
		self:Set(EV_UI_EQUIP_PART_KEY, t_equip_part[name]);
	end
end
-- 触发Hint
function TemplateBtnOtherEquip_OnHint(self)
	local part = self:Get(EV_UI_EQUIP_PART_KEY);
	if part == nil then self:SetHintRichText(0); return end
	local hint = uiSeeEquipGetEquipedItemHintByPart(part);
	if hint == nil then hint = 0 end
	self:SetHintRichText(hint);
end

function layWorld_frmItemlookEx_OnLoad(self)
	self:RegisterScriptEventNotify("EVENT_ItemSeeOtherEquipShow");
	self:RegisterScriptEventNotify("EVENT_OtherLeaveWorld");
end

function layWorld_frmItemlookEx_OnEvent(self, event, arg)
	if event == "EVENT_ItemSeeOtherEquipShow" then
		TemplateBtnOtherEquip_RefreshAll();
		self:ShowAndFocus();
	elseif event == "EVENT_OtherLeaveWorld" then
		if self:getVisible() == false then return end
		local ObjectId = arg[1];
		local CurObjectId = uiSeeEquipGetOtherObjectId();
		if CurObjectId == nil or CurObjectId == 0 or CurObjectId == ObjectId then
			self:Hide();
		end
	end
end

function layWorld_frmItemlookEx_OnShow(self)
	uiRegisterEscWidget(self);
end







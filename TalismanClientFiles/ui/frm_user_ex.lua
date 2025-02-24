local User_Reputation_Ui_Show_Max = 5
local bUser_GodModelShowRefresh = false
local User_GodSkillCurPage = 1


function frmUser_TemplateActionShortcutButton_OnLoad(self)
	self:Set(EV_UI_SHORTCUT_OWNER_KEY, EV_UI_SHORTCUT_OWNER_ATTRIBUTE);	-- 按键类别
	self:Set(EV_UI_SHORTCUT_TYPE_KEY, EV_SHORTCUT_OBJECT_MISC);			-- 内容的类别
	local ID = self.ID;
	if not ID or ID == 0 then
		ID = 0;
		self:Hide();
	else
		self:Show();
	end
	self:Set(EV_UI_SHORTCUT_OBJECTID_KEY, ID);							-- 内容的ObjectId
	self:Set(EV_UI_SHORTCUT_CLASSID_KEY, 0);							-- 内容的表格Id
	frmUser_TemplateActionShortcutButton_Refresh(self);
end

function frmUser_TemplateActionShortcutButton_OnLClick(self)
	local shortcut_type = self:Get(EV_UI_SHORTCUT_TYPE_KEY);
	if shortcut_type == nil then return end
	if shortcut_type == EV_SHORTCUT_OBJECT_MISC then
		local shortcut_objectid = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
		if shortcut_objectid == nil or shortcut_objectid == 0 then return end
		uiSkill_MiscAction(shortcut_objectid);
	end
end

function frmUser_TemplateActionShortcutButton_OnHint(self)
	local hint = 0;
	local shortcut_type = self:Get(EV_UI_SHORTCUT_TYPE_KEY);
	if shortcut_type == nil then
	elseif shortcut_type == EV_SHORTCUT_OBJECT_MISC then
		local shortcut_objectid = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
		if shortcut_objectid == nil or shortcut_objectid == 0 then
		else
			local item = EvUiLuaClass_RichTextItem:new();
			local text = "";
			if shortcut_objectid == nil or shortcut_objectid == 0 then
			elseif shortcut_objectid == EV_UI_SHORTCUT_OBJECTID_MISC_SIT then				-- 打坐
				text = LAN("hint_sit");
			elseif shortcut_objectid == EV_UI_SHORTCUT_OBJECTID_MISC_PRACTICE then          -- 修炼法宝
				text = LAN("hint_practice");
			elseif shortcut_objectid == EV_UI_SHORTCUT_OBJECTID_MISC_NORMALATTACK then      -- 普通攻击
				text = LAN("hint_normalattack");
			elseif shortcut_objectid == EV_UI_SHORTCUT_OBJECTID_MISC_ITEMFUSE then        	-- 法宝熔合
				text = LAN("hint_fuse");
			elseif shortcut_objectid == EV_UI_SHORTCUT_OBJECTID_MISC_AUTOUSE then			-- 消耗品助手
				text = LAN("hint_autouse");
			elseif shortcut_objectid == EV_UI_SHORTCUT_OBJECTID_MISC_CONCENTRATE then		-- 凝神
				text = LAN("hint_concentrate");
			end
			item.Text = text;
			item.Font = LAN("font_title");
			item.FontSize = LAN("font_s_17");
			local line = EvUiLuaClass_RichTextLine:new();
			line:InsertItem(item);
			local rich_text = EvUiLuaClass_RichText:new();
			rich_text:InsertLine(line);
			hint = uiCreateRichText("String", rich_text:ToRichString());
		end
	end
	self:SetHintRichText(hint);
end

function frmUser_TemplateActionShortcutButton_Refresh(self)
	local shortcut_owner = self:Get(EV_UI_SHORTCUT_OWNER_KEY);
	if shortcut_owner == nil or shortcut_owner ~= EV_UI_SHORTCUT_OWNER_ATTRIBUTE then return end
	local shortcut_type = self:Get(EV_UI_SHORTCUT_TYPE_KEY);
	local shortcut_objectid = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
	local shortcut_classid = self:Get(EV_UI_SHORTCUT_CLASSID_KEY);
	
	local icon = 0; -- 图标地址 -- 指针地址
	local itemCount = 0; -- 道具的当前数量
	local countText = ""; -- 道具的当前数量文本
	local bModifyFlag = false;
	
	if shortcut_type == nil or shortcut_type == EV_SHORTCUT_OBJECT_NONE then
		shortcut_type = EV_SHORTCUT_OBJECT_NONE;
	elseif shortcut_type == EV_SHORTCUT_OBJECT_MISC then
		if shortcut_objectid == nil or shortcut_objectid == 0 then
		elseif shortcut_objectid == EV_UI_SHORTCUT_OBJECTID_MISC_SIT then				-- 打坐
			icon = SAPI.GetImage("ic_action_sit", 2, 2, -2, -2);
			bModifyFlag = true;
		elseif shortcut_objectid == EV_UI_SHORTCUT_OBJECTID_MISC_PRACTICE then          -- 修炼法宝
			icon = SAPI.GetImage("ic_action_pracitice", 2, 2, -2, -2);
			bModifyFlag = true;
		elseif shortcut_objectid == EV_UI_SHORTCUT_OBJECTID_MISC_NORMALATTACK then      -- 普通攻击
			icon = SAPI.GetImage("ic_action_attack", 2, 2, -2, -2);
			bModifyFlag = true;
		elseif shortcut_objectid == EV_UI_SHORTCUT_OBJECTID_MISC_ITEMFUSE then        	-- 法宝熔合
			icon = SAPI.GetImage("ic_action_fuse", 2, 2, -2, -2);
			bModifyFlag = true;
		elseif shortcut_objectid == EV_UI_SHORTCUT_OBJECTID_MISC_AUTOUSE then			-- 消耗品助手
			icon = SAPI.GetImage("ic_sys001", 2, 2, -2, -2);
			bModifyFlag = true;
		elseif shortcut_objectid == EV_UI_SHORTCUT_OBJECTID_MISC_CONCENTRATE then		-- 凝神
			icon = SAPI.GetImage("ic_sys002", 2, 2, -2, -2);
			bModifyFlag = true;
		end
	end
	-- 操作按钮
	self:ModifyFlag("DragOut_MouseMove", bModifyFlag);
	self:SetNormalImage(icon);
	self:SetUltraTextNormal(countText);
end

function frmUser_TemplateGodSKillShortcutButton_OnLoad(self)
	self:Set(EV_UI_SHORTCUT_OWNER_KEY, EV_UI_SHORTCUT_OWNER_ATTRIBUTE);	-- 按键类别
	self:Set(EV_UI_SHORTCUT_TYPE_KEY, EV_SHORTCUT_OBJECT_SKILL);		-- 内容的类别
	self:Set(EV_UI_SHORTCUT_OBJECTID_KEY, 0);							-- 内容的ObjectId
	self:Set(EV_UI_SHORTCUT_CLASSID_KEY, 0);							-- 内容的表格Id
end

function frmUser_TemplateGodSKillShortcutButton_OnHint(self)
	local hint = 0;
	local shortcut_type = self:Get(EV_UI_SHORTCUT_TYPE_KEY);
	if shortcut_type == nil then
	elseif shortcut_type == EV_SHORTCUT_OBJECT_SKILL then
		local shortcut_classid = self:Get(EV_UI_SHORTCUT_CLASSID_KEY);
		if shortcut_classid == nil or shortcut_classid == 0 then
		else
			hint = uiSkill_GetMySkillRichText(shortcut_classid);
			if hint == nil then hint = 0 end
		end
	end
	self:SetHintRichText(hint);
end

function frmUser_TemplateGodSKillShortcutButton_Refresh(self)
	local shortcut_dbid = self:Get(LOCAL_SHORTCUT_DBID_KEY);
	local shortcut_owner = self:Get(EV_UI_SHORTCUT_OWNER_KEY);
	if shortcut_owner == nil or shortcut_owner ~= EV_UI_SHORTCUT_OWNER_ATTRIBUTE then return end
	local shortcut_type = self:Get(EV_UI_SHORTCUT_TYPE_KEY);
	local shortcut_objectid = self:Get(EV_UI_SHORTCUT_OBJECTID_KEY);
	local shortcut_classid = self:Get(EV_UI_SHORTCUT_CLASSID_KEY);
	
	local icon = 0; -- 图标地址 -- 指针地址
	local itemCount = 0; -- 道具的当前数量
	local countText = ""; -- 道具的当前数量文本
	local bModifyFlag = false;
	
	if shortcut_type == nil or shortcut_type == EV_SHORTCUT_OBJECT_NONE then
		shortcut_type = EV_SHORTCUT_OBJECT_NONE;
	elseif shortcut_classid == nil or shortcut_classid == 0 then
	elseif shortcut_type == EV_SHORTCUT_OBJECT_SKILL then
		local tableInfo = uiSkill_GetSkillBaseInfoByIndex(shortcut_classid);
		icon = SAPI.GetImage(tableInfo.StrImage, 2, 2, -2, -2);
	end
	-- 操作按钮
	self:ModifyFlag("DragOut_MouseMove", bModifyFlag);
	self:SetNormalImage(icon);
	self:SetUltraTextNormal(countText);
end

function layWorld_frmAllEx_Refresh()
	layWorld_frmAllEx_frmUser_Refresh()	
	layWorld_frmAllEx_frmReputation_Refresh()
	layWorld_frmAllEx_frmAction_Refresh()
end

function layWorld_frmAllEx_frmUser_Refresh()
	local self = uiGetglobal("layWorld.frmAllEx.frmUser")

	local name, party, sex = uiGetMyInfo("Role")
	
	local userName = SAPI.GetChild(self, "labCharName")
	userName:SetText(name)

	party = uiGetPartyInfo(party)
	local userParty = SAPI.GetChild(self, "labCharFaction")
	userParty:SetText(party)
	
	local userLev, userExp, userNextLevExp = uiGetMyInfo("Exp")
	local pgbExp = SAPI.GetChild(self, "pgbExp")
	pgbExp:SetValue(userExp / userNextLevExp)
	pgbExp:SetText(string.format(uiLanString("msg_att_lev"), userLev, (userExp/userNextLevExp)*100))

	local pgbHp = SAPI.GetChild(self, "pgbHp")
	local userHp, userMaxHp = uiGetMyInfo("Hp")
	pgbHp:SetValue(userHp/userMaxHp)
	pgbHp:SetText(string.format("%d / %d", userHp, userMaxHp))

	local pgbNimbus = SAPI.GetChild(self, "pgbNimbus")
	local userNp, userMaxNp = uiGetMyInfo("Np")
	pgbNimbus:SetValue(userNp/userMaxNp)
	pgbNimbus:SetText(string.format("%d / %d", userNp, userMaxNp))

	local labPkValue = SAPI.GetChild(self, "labPkValue")
	local userPk = uiGetMyInfo("Pk")
	labPkValue:SetText(""..userPk)

	local labFatigue = SAPI.GetChild(self, "labFatigue")
	local userTire = uiGetMyInfo("Tire")
	labFatigue:SetText(""..userTire)

	local userStrong = uiGetMyInfo("Str")
	local labStr = SAPI.GetChild(self, "labStr")
	labStr:SetText(""..userStrong)

	local userDex = uiGetMyInfo("Dex")
	local labDex = SAPI.GetChild(self, "labDex")
	labDex:SetText(""..userDex)

	local userWit = uiGetMyInfo("Wit")
	local labWit = SAPI.GetChild(self, "labWit")
	labWit:SetText(""..userWit)

	local userCon = uiGetMyInfo("Con")
	local labCon = SAPI.GetChild(self, "labCon")
	labCon:SetText(""..userCon)

	local userMinPhyDamage, userMaxPhyDamage, userOtherPhyDamage = uiGetMyInfo("PhyDamage")
	local labPhyDmg = SAPI.GetChild(self, "labPhyDmg")
	local labPhyDmgDesc2 = SAPI.GetChild(self,"labPhyDmgDesc2")
	labPhyDmg:SetText(userMinPhyDamage.."-"..userMaxPhyDamage)
	labPhyDmgDesc2:SetText(string.format("(+%.2f)", userOtherPhyDamage))
	
	local userPhyArmor = uiGetMyInfo("PhyArmor")
	local labPhyArmor = SAPI.GetChild(self, "labPhyArmor")
	labPhyArmor:SetText(""..userPhyArmor)

	local userParry = uiGetMyInfo("Parry")
	local labZhaoJiaRate = SAPI.GetChild(self, "labZhaoJiaRate")
	labZhaoJiaRate:SetText(""..userParry)

	local userChit = uiGetMyInfo("Chit")
	local labCritical = SAPI.GetChild(self, "labCritical")
	labCritical:SetText(""..userChit)

	local userDodge = uiGetMyInfo("Dodge")
	local labDodgeRate = SAPI.GetChild(self, "labDodgeRate")
	labDodgeRate:SetText(""..userDodge)

	local userFireArmor = uiGetMyInfo("FireArmor")
	local labFireArmor = SAPI.GetChild(self, "labFireArmor")
	labFireArmor:SetText(""..userFireArmor)

	local userWaterArmor = uiGetMyInfo("WaterArmor")
	local labWatorArmor = SAPI.GetChild(self, "labWatorArmor")
	labWatorArmor:SetText(""..userWaterArmor)

	local userBoltArmor = uiGetMyInfo("BoltArmor")
	local labLightArmor = SAPI.GetChild(self, "labLightArmor")
	labLightArmor:SetText(""..userBoltArmor)

	local userBuddhistArmor = uiGetMyInfo("BuddhistArmor")
	local labFoArmor = SAPI.GetChild(self, "labFoArmor")
	labFoArmor:SetText(""..userBuddhistArmor)

	local userPoisonArmor = uiGetMyInfo("PoisonArmor")
	local labPoisonArmor = SAPI.GetChild(self, "labPoisonArmor")
	labPoisonArmor:SetText(""..userPoisonArmor)

end

function layWorld_frmAllEx_frmGod_RebuildGodLevInfo(self)
	local lbGodFeel = SAPI.GetChild(self, "lbGodFeel")
	local lbGodLevel = SAPI.GetChild(self, "lbGodLevel")
	local edbGodHelp = SAPI.GetChild(self, "edbGodHelp")
	
	local userGodTitle , userGodLev, userGodHint , userGodModel= uiGetMyInfo("God")
	lbGodFeel:SetText(userGodTitle)
	lbGodLevel:SetText(""..userGodLev)
	edbGodHelp:SetText(userGodHint)

	if not bUser_GodModelShowRefresh then
		bUser_GodModelShowRefresh = true
		layWorld_frmAllEx_frmGod_RebuildGodModel(self)
	end
end

function layWorld_frmAllEx_frmGod_RebuildGodModel(self)
	local _ , _, _ , userGodModel= uiGetMyInfo("God")
	local mdvGod = SAPI.GetChild(self, "mdvGod")
	mdvGod:SetModel(userGodModel)
end

function layWorld_frmAllEx_frmGod_OnUpDate(self)
	local bt3DLeft = SAPI.GetChild(self, "bt3DLeft")
	local bt3DRight = SAPI.GetChild(self, "bt3DRight")
	local mdvGod = SAPI.GetChild(self, "mdvGod")
	mdvGod:StopTurnModel()
	if bt3DLeft:IsCaptured() then
		mdvGod:StartTurnModel()
		mdvGod:SetTurnSpeed(0,0,-0.02)
	elseif bt3DRight:IsCaptured() then
		mdvGod:StartTurnModel()
		mdvGod:SetTurnSpeed(0,0,0.02)
	end

	local x, y, w, h = uiGetGameViewRect()
	local x1, y1, w1, h1 = uiGetWidgetRect(mdvGod)
	if x1 < x or x1 + w1 > x + w or y1 + h1 > y + h then
		mdvGod:Hide()
	else
		mdvGod:Show()
	end

end

function layWorld_frmAllEx_frmReputation_Refresh()
	local self = uiGetglobal("layWorld.frmAllEx.frmReputation")
	
	local scrRpt = SAPI.GetChild(self, "scrRpt")

	local size, ltReputation = uiGetMyInfo("Reputation")

	--for i, credit in ipairs(ltReputation) do
		--credit.
	--end
	
	local iCurrTopIndex = 0

	if size <= User_Reputation_Ui_Show_Max then
		iCurrTopIndex = 0
		scrRpt:SetData(0, 0, 0, 1);
	else
		scrRpt:Show()
		scrRpt:SetStep(1)
		scrRpt:SetData(0, size - User_Reputation_Ui_Show_Max, scrRpt:getValue(), 1)
		scrRpt:SetValuePerPage(User_Reputation_Ui_Show_Max - 1);
		iCurrTopIndex = scrRpt:getValue()

		if iCurrTopIndex < 0 then
			iCurrTopIndex = 0
		end

		if iCurrTopIndex > size - 1 then
			iCurrTopIndex = size - 1
		end

	end

	local iMaxItemNum = size - iCurrTopIndex
	if iMaxItemNum >=User_Reputation_Ui_Show_Max then
		iMaxItemNum =User_Reputation_Ui_Show_Max
	end

	for i=1, User_Reputation_Ui_Show_Max, 1 do
		local lbRpt = SAPI.GetChild(self, "lbRpt"..i)
		layWorld_frmAllEx_frmReputation_SetRptInfo(lbRpt)
	end

	for i=1, iMaxItemNum, 1 do
		local lbRpt = SAPI.GetChild(self, "lbRpt"..i)
		layWorld_frmAllEx_frmReputation_SetRptInfo(lbRpt,ltReputation[iCurrTopIndex + i])
	end
	
end

function layWorld_frmAllEx_frmReputation_SetRptInfo(lbRpt,ltInfo)
	
	local lbRepName = SAPI.GetChild(lbRpt, "lbRepName")
	local lbReputationStr = SAPI.GetChild(lbRpt, "lbReputationStr")
	local lbReputation = SAPI.GetChild(lbRpt, "lbReputation")
	local pgReputation = SAPI.GetChild(lbRpt, "pgReputation")
	
	if ltInfo == nil then
		lbRpt:Hide()
	else
		lbRpt:Show()
		lbRepName:SetText(ltInfo.Area)
		lbReputationStr:SetText(uiLanString("msg_credit_show_"..ltInfo.Level))
		
		if ltInfo.Level < 10 then
			lbReputation:SetText(uiLanString("msg_credit_show_"..(ltInfo.Level+1)))
		else
			lbReputation:SetText("")
		end

		if ltInfo.Level == 10 then
			pgReputation:SetText("")
			pgReputation:SetValue(1.0)
		else
			
		pgReputation:SetValue(ltInfo.Credit / ltInfo.MaxCredit)
		pgReputation:SetText(ltInfo.Credit.."/"..ltInfo.MaxCredit);

		end
		
	end


end

function layWorld_frmAllEx_frmAction_Refresh()
	
end

function layWorld_frmAllEx_SetHint(self,info)
	local _, userAttrText = uiGetMyInfo(info)
	if userAttrText ~= nil then
		self:SetHintRichText(userAttrText)
	else
		self:SetHintText("")
	end
end


function layWorld_frmAllEx_SetSelectIndex(index)

	local frmAllEx = uiGetglobal("layWorld.frmAllEx")

	local btUser = SAPI.GetChild(frmAllEx,"btUser")
	local btGod = SAPI.GetChild(frmAllEx,"btGod")
	local btReputation = SAPI.GetChild(frmAllEx,"btReputation")
	local btAction = SAPI.GetChild(frmAllEx,"btAction")

	local frmUser = SAPI.GetChild(frmAllEx,"frmUser")
	local frmGod = SAPI.GetChild(frmAllEx,"frmGod")
	local frmReputation = SAPI.GetChild(frmAllEx,"frmReputation")
	local frmAction = SAPI.GetChild(frmAllEx,"frmAction")
	
	if index == 1 and not uiCanUseGodSystem() then
		uiClientMsg(uiLanString("msg_god21"), true)
		btGod:SetChecked(false)
		return
	end
	
	btUser:SetChecked(false)
	btGod:SetChecked(false)
	btReputation:SetChecked(false)
	btAction:SetChecked(false)

	frmUser:Hide()
	frmGod:Hide()
	frmReputation:Hide()
	frmAction:Hide()

	if index == 0 then
		btUser:SetChecked(true)
		frmUser:Show()
	elseif index == 1 then
		btGod:SetChecked(true)
		frmGod:Show()
	elseif index == 2 then
		btReputation:SetChecked(true)
		frmReputation:Show()
	elseif index == 3 then
		btAction:SetChecked(true)
		frmAction:Show()
	end
	
	layWorld_frmAllEx_Refresh()

end


function layWorld_frmGodOfflineEx_OnShow(self)
	local userGodTitle = uiGetMyInfo("God")
	local bItem1, bItem2, userString1, userString2, userString3 = uiGetMyInfo("GodPractise")
	
	local lbGodFeel2 = SAPI.GetChild(self,"lbGodFeel2")
	local edbWill = SAPI.GetChild(self,"edbWill")
	local edbWillItemInfo1 = SAPI.GetChild(self,"edbWillItemInfo1")
	local edbWillItemInfo2 = SAPI.GetChild(self,"edbWillItemInfo2")

	local btWillItem1 = SAPI.GetChild(self,"btWillItem1")
	local btWillItem2 = SAPI.GetChild(self,"btWillItem2")

	lbGodFeel2:SetText(userGodTitle)
	edbWill:SetText(userString1)
	edbWillItemInfo1:SetText(userString2)
	edbWillItemInfo2:SetText(userString3)

	if bItem1 then
		btWillItem1:Enable()
	else
		btWillItem1:Disable()
	end
	if bItem2 then 
		btWillItem2:Enable()
	else
		btWillItem2:Disable()
	end
end

function layWorld_frmGodOfflineEx_btStart_OnLClick(self)
	self:Disable()
	layWorld_frmGodOfflineEx_Start_GodPractise()
end

function layWorld_frmGodOfflineEx_Start_GodPractise()
	local btStart = uiGetglobal("layWorld.frmGodOfflineEx.btStart")
	local ckbUseItem1 = uiGetglobal("layWorld.frmGodOfflineEx.ckbUseItem1")
	local ckbUseItem2 = uiGetglobal("layWorld.frmGodOfflineEx.ckbUseItem2")
	local level = uiGetMyInfo("Exp");
	if (ckbUseItem1:getChecked() == true or ckbUseItem2:getChecked() == true) and level < uiUseGodItemMinLevel() then
		ckbUseItem1:SetChecked(false);
		ckbUseItem2:SetChecked(false);
		uiClientMsg(string.format(LAN("msg_god22"), uiUseGodItemMinLevel()), true);
	end

	if btStart:getEnable() then
	else
		local ckbAuto = uiGetglobal("layWorld.frmGodOfflineEx.ckbAuto")
		
		uiSetGodPractiseParam(ckbUseItem1:getChecked(),ckbUseItem2:getChecked(),true,ckbAuto:getChecked())
		--uiStartGodPractise(ckbUseItem1:getChecked(),ckbUseItem2:getChecked())
	end
end

function layWorld_frmAllEx_frmGod_GodSkill_Refresh(page)
	local _ , _, _ , _ , userGodSkillCount, userGodSkills= uiGetMyInfo("God")
	local frmGodSkill = uiGetglobal("layWorld.frmAllEx.frmGod.frmGodSkill")
	for i = 1, 10, 1 do
		local btSkill = SAPI.GetChild(frmGodSkill, string.format("btGodSkill%02d", i))
		btSkill:Set(EV_UI_SHORTCUT_CLASSID_KEY, 0);
		frmUser_TemplateGodSKillShortcutButton_Refresh(btSkill);
		--uiCreateShortcut(btSkill, EV_SHORTCUT_OBJECT_SKILL, 0)
	end

	if page < 1 then
		return
	end

	local lbGodSkillNumber = uiGetglobal("layWorld.frmAllEx.frmGod.lbGodSkillNumber")
	lbGodSkillNumber:SetText(""..page)

	if userGodSkillCount < ((page - 1)*10) then
		return
	end

	local showGodSkillCount = userGodSkillCount - ((page - 1)*10)

	if showGodSkillCount > 10 then
		showGodSkillCount = 10
	end

	for i=1, showGodSkillCount, 1 do
		local btSkill = SAPI.GetChild(frmGodSkill, string.format("btGodSkill%02d", i))
		
		btSkill:Set(EV_UI_SHORTCUT_CLASSID_KEY, userGodSkills[(i + ((page - 1)*10))]);
		
		frmUser_TemplateGodSKillShortcutButton_Refresh(btSkill);
		
		--uiCreateShortcut(btSkill, EV_SHORTCUT_OBJECT_SKILL, userGodSkills[(i + ((page - 1)*10))])
	end
end

function layWorld_frmAllEx_frmGod_OnShow(self)
	layWorld_frmAllEx_frmGod_GodSkill_Refresh(User_GodSkillCurPage)
end

function layWorld_frmAllEx_frmGod_SkillPageChange(number)
	User_GodSkillCurPage = User_GodSkillCurPage + number
	if User_GodSkillCurPage < 1 then
		User_GodSkillCurPage = 1
	end

	local _ , _, _ , _ , userGodSkillCount= uiGetMyInfo("God")

	if (User_GodSkillCurPage - 1) * 10 > userGodSkillCount then
		User_GodSkillCurPage =  (userGodSkillCount / 10) + 1
	end

	User_GodSkillCurPage = math.floor(User_GodSkillCurPage)

	layWorld_frmAllEx_frmGod_GodSkill_Refresh(User_GodSkillCurPage)
end

function layWorld_frmAllEx_frmAction_OnShow(self)
--[[
	for i = 1,5,1 do
		local btAction = SAPI.GetChild(self, string.format("btNormal%d", i))
		btAction:Hide()
	end

	for i=1,3,1 do
		local btActionMood = SAPI.GetChild(self, string.format("btMood%d", i))
		btActionMood:Hide()
	end
	
	local userActionCount, userActionIndexArr = uiGetMyInfo("ActionPose")
	local j = 1
	for i=1, 5, 1 do
		if i > userActionCount - 2 then
			break
		end
		local btAction = SAPI.GetChild(self, string.format("btNormal%d", i))
		if j == 2 or j==4 then
			j = j + 1
		end
		uiCreateShortcut(btAction, EV_SHORTCUT_OBJECT_MISC, userActionIndexArr[j])
		btAction:Show()
		j = j + 1
	end

	local userMoodCount, userMoodIndexArr = uiGetMyInfo("ActionMood")
	for i=1, 3, 1 do
		if i > userMoodCount then
			break
		end
		local btActionMood = SAPI.GetChild(self, string.format("btMood%d", i))
		uiCreateShortcut(btActionMood, EV_SHORTCUT_OBJECT_MISC, userMoodIndexArr[i])
		btActionMood:Show()
	end
	]]
end

--*********************
-- lay_select_character2
--*********************
local RoleSelectionList =
{
};

function RoleSelection_OnLoad(self)
	table.insert(RoleSelectionList, self); -- ×¢²á¿Ø¼þ
end

function UpdateRoleList ()
	local count = uiCharGetRoleCount(true);
	for i = 0, table.getn(RoleSelectionList)-1 do
		local ckbSelectChar = RoleSelectionList[i+1];
		if (i < count) then
			local name, level, party, lockedTimeLeft, _, active, deletetime = uiCharGetRoleInfo(i, true);
			if name == nil then name = "Òì³£"; level = 0; party = "Î´Öª"; lockedTimeLeft = 0; end
			uiGetChild(ckbSelectChar, "lbName"):SetText(name);
			uiGetChild(ckbSelectChar, "lbLevel"):SetText(tostring(level));
			local PositionText = "";
			if lockedTimeLeft > 0 then
				PositionText = LAN("msg_login13").." ";
				if lockedTimeLeft >= (24 * 3600) then
					PositionText = PositionText..string.format(LAN("MSG_DAY"), math.ceil(lockedTimeLeft/(24*3600)));
				elseif lockedTimeLeft >= 3600 then
					PositionText = PositionText..string.format(LAN("MSG_HOUR"), math.ceil(lockedTimeLeft/(3600)));
				elseif lockedTimeLeft >= 60 then
					PositionText = PositionText..string.format(LAN("MSG_MINUTE"), math.ceil(lockedTimeLeft/(60)));
				else
					PositionText = PositionText..string.format(LAN("MSG_MINUTE"), 1);
				end
				uiGetChild(ckbSelectChar, "lbName"):SetTextColorEx(124, 124, 124, 255);
				uiGetChild(ckbSelectChar, "lbLevel"):SetTextColorEx(124, 124, 124, 255);
				ckbSelectChar:SetHintText(PositionText);
			else
				uiGetChild(ckbSelectChar, "lbName"):SetTextColorEx(255, 255, 255, 255);
				uiGetChild(ckbSelectChar, "lbLevel"):SetTextColorEx(255, 255, 255, 255);
				ckbSelectChar:SetHintText("");
			end
			uiGetChild(ckbSelectChar, "lbPosition"):SetText(PositionText);
			uiGetChild(ckbSelectChar, "lbPosition"):SetTextColorEx(124, 124, 124, 255);
			ckbSelectChar:Show();
		else
			ckbSelectChar:Hide();
		end
	end
	uiGetglobal("laySelectChar.lbLayerSelectChar2.lbContainer"):Show();
	local btDelRole = uiGetglobal("laySelectChar.lbLayerSelectChar2.lbContainer.btDelRole");
	if uiIsEnableDelRole() == true then
		btDelRole:Show();
	else
		btDelRole:Hide();
	end
end

function RoleSelection_OnLClick(self)
	local index = SAPI.GetIndexInTable(RoleSelectionList, self);
	if (index) then
		uiCharSelectRole(index - 1);
	end
end

function RoleSelection_OnKeyDown(self, key)
	if key == string.byte("D") and uiIsKeyPressed("CTRL") and uiIsKeyPressed("SHIFT") then
		uiCharDeleteRole();
	end
end

function RoleSelection_SelectChanged(index)
	local btDelRole = uiGetglobal("laySelectChar.lbLayerSelectChar2.lbContainer.btDelRole");
	local btEnterGame = uiGetglobal("laySelectChar.lbLayerSelectChar2.lbContainer.btEnterGame");
	btDelRole:Disable();
	btEnterGame:Disable();
	index = index + 1;
	for i, obj in ipairs(RoleSelectionList) do
		if (i == index) then
			obj:SetChecked(true);
			btDelRole:Enable();
			btEnterGame:Enable();
		else
			obj:SetChecked(false);
		end
	end
	local name, level, party, lockedTimeLeft, _, active, deletetime = uiCharGetRoleInfo(index-1, true);
	if lockedTimeLeft ~= nil and lockedTimeLeft > 0 then btEnterGame:Disable() end
end

function RoleSelection_ReceiveServerInfoList()
	uiGetglobal("laySelectChar.lbLayerSelectChar2.lbContainer"):Hide();
	uiGetglobal("laySelectChar.lbLayerSelectChar2.lbContainer.btDelRole"):Hide();
	uiGetglobal("laySelectChar.lbLayerSelectChar2.lbContainer.btCreateRole").AutoEnter = true;
end




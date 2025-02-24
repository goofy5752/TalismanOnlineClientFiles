UI_WorldMap_CurShowMapZoneId = 0
UI_WorldMap_CurShowMapContinentId = 0

local UI_WorldMap_MAP_POS_MIN_RATE = 0.001
local UI_WorldMap_MAP_POS_MAX_RATE = 0.999

local UI_WorldMap_Area_Left = 0
local UI_WorldMap_Area_Right = 0
local UI_WorldMap_Area_Top = 0
local UI_WorldMap_Area_Bottom = 0

local UI_WorldMap_Map_Width = 800
local UI_WorldMap_map_Height = 540

local UI_WorldMap_CurShow_Frm = nil

local UI_WorldMap_AutoWalk_ContinentId = 0
local UI_WorldMap_AutoWalk_PosX = 0
local UI_WorldMap_AutoWalk_PosY = 0

local UI_WorldMap_MapVisible = 1

function layWorld_frmWorldMapEx_ToggleWorldMap(self)
	if self:getVisible() then
		self:Hide()
	else
		
		if uiWorldMap_CheckWorldMapCanShow() then
			local curZoneInfo = uiWorldMap_GetCurrentZoneInfo()
			if curZoneInfo == nil then return end
			layWorld_frmWorldMapEx_Refresh_MapZone(self, curZoneInfo.ContinentId, curZoneInfo.Id)
			self:ShowAndFocus()
		end
	end
end

function layWorld_frmWorldMapEx_Refresh_MapZone(self, countinentId, zoneId)
	local cbZone = SAPI.GetChild(self, "cbZone")
	cbZone:RemoveAllItems()

	local cbContinent = SAPI.GetChild(self, "cbContinent")
	local btZoomIn = SAPI.GetChild(self, "btZoomIn")
	btZoomIn:Enable()

	UI_WorldMap_CurShow_Frm = nil

	local ltAllInfo = uiWorldMap_GetAllZoneInfo()
	for i,zoneInfo in ipairs(ltAllInfo) do
		if zoneInfo.ContinentId == countinentId then
			cbZone:AddItem(zoneInfo.Name,0)

			if zoneInfo.Id == zoneId then
				local cInfo = uiWorldMap_GetContinentInfoById(zoneInfo.ContinentId)
				if cInfo == nil then
					cbContinent:Hide()
					btZoomIn:Hide()
				else
					cbContinent:Show()
					btZoomIn:Show()
					cbContinent:SetText(cInfo.Name)
				end

				cbZone:SetText(zoneInfo.Name)
				layWorld_frmWorldMapEx_HideAllZone()
				layWorld_frmWorldMapEx_HideAllConinent()
				UI_WorldMap_CurShowMapZoneId = zoneInfo.Id
				UI_WorldMap_CurShowMapContinentId = zoneInfo.ContinentId
				UI_WorldMap_Area_Left = zoneInfo.AreaLeft  
				UI_WorldMap_Area_Right = zoneInfo.AreaRight
				UI_WorldMap_Area_Top = zoneInfo.AreaTop
				UI_WorldMap_Area_Bottom = zoneInfo.AreaBottom
				local frmZone = SAPI.GetChild(self, string.format("frmZone%03d", zoneId))
				frmZone:Show()
				frmZone:SetTransparency(UI_WorldMap_MapVisible)
				UI_WorldMap_CurShow_Frm = frmZone
				local wgSelf = SAPI.GetChild(self, "wgSelf")
				local mvSelf = SAPI.GetChild(wgSelf, "mvSelf")
				mvSelf:PlayPose("show", false)
				local bImage = SAPI.GetImage(zoneInfo.BackGroundImg)
				if bImage ~= nil then
					frmZone:SetBackgroundImage(bImage)
				end
			end
		end
	end
	
	local lbAutoWalkMark = SAPI.GetChild(self, "lbAutoWalkMark")
	if uiWorldMap_ContinentCanAutoWalkById(countinentId) then
		lbAutoWalkMark:Show()
	else
		lbAutoWalkMark:Hide()
	end
	layWorld_frmWorldMapEx_OnUpdate(self)
end

function layWorld_frmWorldMapEx_Refresh_MapContinent(self, countinentId)
	local continentInfo = uiWorldMap_GetCurrentContinentInfo(countinentId)

	if continentInfo == nil then return end

	local cbZone = SAPI.GetChild(self, "cbZone")
	cbZone:RemoveAllItems()
	cbZone:SetText("")

	local cbContinent = SAPI.GetChild(self, "cbContinent")
	local btZoomIn = SAPI.GetChild(self, "btZoomIn")
	btZoomIn:Disable()
	UI_WorldMap_CurShow_Frm = nil
	
	cbContinent:SetText(continentInfo.Name)

	local ltAllInfo = uiWorldMap_GetAllZoneInfo()
	for i,zoneInfo in ipairs(ltAllInfo) do
		if zoneInfo.ContinentId == countinentId then
			cbZone:AddItem(zoneInfo.Name,0)
		end
	end

	layWorld_frmWorldMapEx_HideAllZone()
	layWorld_frmWorldMapEx_HideAllConinent()

	UI_WorldMap_CurShowMapZoneId = 0
	UI_WorldMap_CurShowMapContinentId = countinentId
	UI_WorldMap_Area_Left = continentInfo.AreaLeft  
	UI_WorldMap_Area_Right = continentInfo.AreaRight
	UI_WorldMap_Area_Top = continentInfo.AreaTop
	UI_WorldMap_Area_Bottom = continentInfo.AreaBottom
	local frmContinent = SAPI.GetChild(self, string.format("frmContinent%02d", countinentId))
	frmContinent:Show()
	frmContinent:SetTransparency(UI_WorldMap_MapVisible)
	UI_WorldMap_CurShow_Frm = frmContinent
	
	local wgSelf = SAPI.GetChild(self, "wgSelf")
	local mvSelf = SAPI.GetChild(wgSelf, "mvSelf")
	mvSelf:PlayPose("show", false)
	local bImage = SAPI.GetImage(continentInfo.BackGroundImg)
	if bImage ~= nil then
		frmContinent:SetBackgroundImage(bImage)
	end

	local lbAutoWalkMark = SAPI.GetChild(self, "lbAutoWalkMark")
	if uiWorldMap_ContinentCanAutoWalkById(countinentId) then
		lbAutoWalkMark:Show()
	else
		lbAutoWalkMark:Hide()
	end
	layWorld_frmWorldMapEx_OnUpdate(self)
end

function layWorld_frmWorldMapEx_HideAllZone()
	local self = uiGetglobal("layWorld.frmWorldMapEx")
	local ltAllInfo = uiWorldMap_GetAllZoneInfo()

	if ltAllInfo == nil then return end

	for i, info in ipairs(ltAllInfo) do
		local frmZone = SAPI.GetChild(self, string.format("frmZone%03d", info.Id))
		frmZone:Hide()
		frmZone:SetBackgroundImage(0)
	end


end

function layWorld_frmWorldMapEx_HideAllConinent()
	local self = uiGetglobal("layWorld.frmWorldMapEx")
	local ltAllInfo = uiWorldMap_GetAllContinentInfo()

	if ltAllInfo == nil then return end

	for i, info in ipairs(ltAllInfo) do
		local frmContinent = SAPI.GetChild(self, string.format("frmContinent%02d", info.Id))
		frmContinent:Hide()
		frmContinent:SetBackgroundImage(0)
	end
end

function layWorld_frmWorldMapEx_OnUpdate(self)
	if not self:getVisible() then
		return
	end

	if not uiWorldMap_CheckWorldMapCanShow() then
		self:Hide()
		return
	end

	if UI_WorldMap_CurShow_Frm == nil then
		return
	end
	
	local continentid, posX, posY, radian = uiWorldMap_GetSelfCurSceneInfo()
	if continentid == nil then self:Hide() return end

	local lbUserPos = SAPI.GetChild(self, "lbUserPos")
	lbUserPos:Hide()
	local wgSelf = SAPI.GetChild(self, "wgSelf")
	wgSelf:Hide()
	local btAutoWalk = SAPI.GetChild(self, "btAutoWalk")
	btAutoWalk:Hide()

	for i=1, 4, 1 do 
		local btTeam = SAPI.GetChild(self, "btTeam"..i)
		btTeam:Hide()
	end

	for i=1, 2, 1 do
		local btMapNote = SAPI.GetChild(self, "btMapNote"..i)
		btMapNote:Hide()
	end

	if continentid == UI_WorldMap_CurShowMapContinentId then
		local xRote = (posX - UI_WorldMap_Area_Left) / (UI_WorldMap_Area_Right - UI_WorldMap_Area_Left)
		local yRote = (posY - UI_WorldMap_Area_Top) / (UI_WorldMap_Area_Bottom - UI_WorldMap_Area_Top)
		if xRote >= UI_WorldMap_MAP_POS_MIN_RATE and xRote <= UI_WorldMap_MAP_POS_MAX_RATE and yRote >= UI_WorldMap_MAP_POS_MIN_RATE and yRote <= UI_WorldMap_MAP_POS_MAX_RATE then
			lbUserPos:Show()
			lbUserPos:SetText(""..posX..","..posY)
			wgSelf:Show()
			local __X,__Y = uiGetWidgetRect(UI_WorldMap_CurShow_Frm)
			local XXX,YYY = uiGetWidgetRect(self)
			__X = __X - XXX
			__Y = __Y - YYY
			__X = __X + xRote*UI_WorldMap_Map_Width
			__Y = __Y + (1 - yRote)*UI_WorldMap_map_Height
			
			local _,_,__W,__H = uiGetWidgetRect(wgSelf)
			__X = __X - __W/2
			__Y = __Y - __H/2

			wgSelf:MoveTo(__X,__Y)
			local btSelf = SAPI.GetChild(wgSelf, "btSelf")
			btSelf:SetTransparency(UI_WorldMap_MapVisible)
			local img = btSelf:getBackgroundImage()
			uiSetImageRotateZ(img, radian)
		end
	end


	local mouse_x, mouse_y = uiGetMousePosition()
	if UI_WorldMap_CurShow_Frm:IsContain(mouse_x, mouse_y) then
		local __X,__Y = uiGetWidgetRect(UI_WorldMap_CurShow_Frm)
		__X = mouse_x - __X
		__Y = mouse_y - __Y

		__X = (__X / UI_WorldMap_Map_Width) * (UI_WorldMap_Area_Right - UI_WorldMap_Area_Left) + UI_WorldMap_Area_Left
		__Y = (1 - __Y / UI_WorldMap_map_Height) * (UI_WorldMap_Area_Bottom - UI_WorldMap_Area_Top) + UI_WorldMap_Area_Top

		local lbMousePos = SAPI.GetChild(self, "lbMousePos")
		lbMousePos:SetText(""..math.floor(__X)..","..math.floor(__Y))
	end

	local ltTeam = uiWorldMap_GetSelfTeamOtherPlayerInfo()
	if ltTeam ~= nil then
		for i, teamMember in ipairs(ltTeam) do
			if teamMember.ContinentId == UI_WorldMap_CurShowMapContinentId then
				
				local xRote = (teamMember.PosX - UI_WorldMap_Area_Left) / (UI_WorldMap_Area_Right - UI_WorldMap_Area_Left)
				local yRote = (teamMember.PosY - UI_WorldMap_Area_Top) / (UI_WorldMap_Area_Bottom - UI_WorldMap_Area_Top)
				if xRote >= UI_WorldMap_MAP_POS_MIN_RATE and xRote <= UI_WorldMap_MAP_POS_MAX_RATE and yRote >= UI_WorldMap_MAP_POS_MIN_RATE and yRote <= UI_WorldMap_MAP_POS_MAX_RATE then
					local btTeam = SAPI.GetChild(self, "btTeam"..i)
					btTeam:Show()
					local __X,__Y = uiGetWidgetRect(UI_WorldMap_CurShow_Frm)
					local XXX,YYY = uiGetWidgetRect(self)
					__X = __X - XXX
					__Y = __Y - YYY
					__X = __X + xRote*UI_WorldMap_Map_Width
					__Y = __Y + (1 - yRote)*UI_WorldMap_map_Height
					
					local _,_,__W,__H = uiGetWidgetRect(btTeam)
					__X = __X - __W/2
					__Y = __Y - __H/2

					btTeam:MoveTo(__X,__Y)
					btTeam:SetHintText(teamMember.Name)
					btTeam:SetTransparency(UI_WorldMap_MapVisible)
				end
			end
		end
	end

	if UI_WorldMap_AutoWalk_ContinentId == UI_WorldMap_CurShowMapContinentId then
		local xRote = (UI_WorldMap_AutoWalk_PosX - UI_WorldMap_Area_Left) / (UI_WorldMap_Area_Right - UI_WorldMap_Area_Left)
		local yRote = (UI_WorldMap_AutoWalk_PosY - UI_WorldMap_Area_Top) / (UI_WorldMap_Area_Bottom - UI_WorldMap_Area_Top)
		if xRote >= UI_WorldMap_MAP_POS_MIN_RATE and xRote <= UI_WorldMap_MAP_POS_MAX_RATE and yRote >= UI_WorldMap_MAP_POS_MIN_RATE and yRote <= UI_WorldMap_MAP_POS_MAX_RATE then
			
			btAutoWalk:Show()
			local __X,__Y = uiGetWidgetRect(UI_WorldMap_CurShow_Frm)
			local XXX,YYY = uiGetWidgetRect(self)
			__X = __X - XXX
			__Y = __Y - YYY
			__X = __X + xRote*UI_WorldMap_Map_Width
			__Y = __Y + (1 - yRote)*UI_WorldMap_map_Height
			
			local _,_,__W,__H = uiGetWidgetRect(btAutoWalk)
			__X = __X - __W/2
			__Y = __Y - __H/2

			btAutoWalk:MoveTo(__X,__Y)
			btAutoWalk:SetTransparency(UI_WorldMap_MapVisible)
		end
	end
	for i=1, 2, 1 do
		local btMapNote = SAPI.GetChild(self, "btMapNote"..i)
		if btMapNote:Get("continentId") == UI_WorldMap_CurShowMapContinentId then
			local xRote = (btMapNote:Get("posX") - UI_WorldMap_Area_Left) / (UI_WorldMap_Area_Right - UI_WorldMap_Area_Left)
			local yRote = (btMapNote:Get("posY") - UI_WorldMap_Area_Top) / (UI_WorldMap_Area_Bottom - UI_WorldMap_Area_Top)
			if xRote >= UI_WorldMap_MAP_POS_MIN_RATE and xRote <= UI_WorldMap_MAP_POS_MAX_RATE and yRote >= UI_WorldMap_MAP_POS_MIN_RATE and yRote <= UI_WorldMap_MAP_POS_MAX_RATE then
				
				btMapNote:Show()
				local __X,__Y = uiGetWidgetRect(UI_WorldMap_CurShow_Frm)
				local XXX,YYY = uiGetWidgetRect(self)
				__X = __X - XXX
				__Y = __Y - YYY
				__X = __X + xRote*UI_WorldMap_Map_Width
				__Y = __Y + (1 - yRote)*UI_WorldMap_map_Height
				
				local _,_,__W,__H = uiGetWidgetRect(btMapNote)
				__X = __X - __W/2
				__Y = __Y - __H/2

				btMapNote:MoveTo(__X,__Y)
				btMapNote:SetTransparency(UI_WorldMap_MapVisible)
			end
		end
	end
end

function layWorld_frmWorldMapEx_wgSelf_OnHint(self)
	local name = uiGetMyInfo("Role")
	self:SetHintText(name)
end

function layWorld_TemplateFormZone_FormZone_OnLClick(self)
	uiSetEventProcessed(false)
end

function layWorld_TemplateFormZone_FormZone_OnRClick(self)
	local mouse_x, mouse_y = uiGetMousePosition()
	if UI_WorldMap_CurShow_Frm:IsContain(mouse_x, mouse_y) then
		local __X,__Y = uiGetWidgetRect(UI_WorldMap_CurShow_Frm)
		__X = mouse_x - __X
		__Y = mouse_y - __Y

		__X = (__X / UI_WorldMap_Map_Width) * (UI_WorldMap_Area_Right - UI_WorldMap_Area_Left) + UI_WorldMap_Area_Left
		__Y = (1 - __Y / UI_WorldMap_map_Height) * (UI_WorldMap_Area_Bottom - UI_WorldMap_Area_Top) + UI_WorldMap_Area_Top

		uiWorldMap_AutoWalk(UI_WorldMap_CurShowMapContinentId, math.floor(__X), math.floor(__Y))
	end
end

function layWorld_frmWorldMapEx_OnUserAutoWalk(self, continentId, PosX, PosY)
	UI_WorldMap_AutoWalk_ContinentId = continentId
	UI_WorldMap_AutoWalk_PosX = PosX
	UI_WorldMap_AutoWalk_PosY = PosY
	local hinttext = string.format(LAN("msg_auto_walk1"), PosX, PosY)
	local btAutoWalk = SAPI.GetChild(self, "btAutoWalk")
	btAutoWalk:SetHintText(hinttext)
	uiInfo(hinttext)
end

function layWorld_frmWorldMapEx_AddMapNote(self, continentId, posX, posY, name)
	local btMapNote1 = SAPI.GetChild(self, "btMapNote1")
	local btMapNote2 = SAPI.GetChild(self, "btMapNote2")

	if btMapNote1:Get("time") == nil then
		btMapNote1:Set("time", uiGetNowSecond())
		btMapNote1:Set("continentId", continentId)
		btMapNote1:Set("posX", posX)
		btMapNote1:Set("posY", posY)
		btMapNote1:SetHintText(name)
	elseif btMapNote2:Get("time") == nil then
		btMapNote2:Set("time", uiGetNowSecond())
		btMapNote2:Set("continentId", continentId)
		btMapNote2:Set("posX", posX)
		btMapNote2:Set("posY", posY)
		btMapNote2:SetHintText(name)
	else
		if btMapNote1:Get("time") >= btMapNote2:Get("time") then
			btMapNote2:Set("time", uiGetNowSecond())
			btMapNote2:Set("continentId", continentId)
			btMapNote2:Set("posX", posX)
			btMapNote2:Set("posY", posY)
			btMapNote2:SetHintText(name)
		else
			btMapNote1:Set("time", uiGetNowSecond())
			btMapNote1:Set("continentId", continentId)
			btMapNote1:Set("posX", posX)
			btMapNote1:Set("posY", posY)
			btMapNote1:SetHintText(name)
		end
	end

	uiWorldMap_AutoWalk(continentId, posX, posY)
end

function layWorld_frmWorldMapEx_ClearAllMapNote(self)
	for i=1, 2, 1 do
		local btMapNote = SAPI.GetChild(self, "btMapNote"..i)
		btMapNote:Delete("time")
		btMapNote:Delete("continentId")
		btMapNote:Delete("posX")
		btMapNote:Delete("posY")
		btMapNote:Hide()
	end
end

function layWorld_frmWorldMapEx_btZoomIn_OnLClick()
	local self = uiGetglobal("layWorld.frmWorldMapEx")
	layWorld_frmWorldMapEx_Refresh_MapContinent(self, UI_WorldMap_CurShowMapContinentId)
end

function layWorld_frmWorldMapEx_OnShow(self)
	local cbContinent = SAPI.GetChild(self, "cbContinent")
	cbContinent:RemoveAllItems()
	local ltAllInfo = uiWorldMap_GetAllContinentInfo()

	for i, info in ipairs(ltAllInfo) do
		cbContinent:AddItem(info.Name,0)

	end


	uiWorldMap_PlayWorldMapSound("world_map_open.wav")
end

function layWorld_frmWorldMapEx_OnHide(self)
	uiWorldMap_PlayWorldMapSound("world_map_close.wav")
end

function layWorld_frmWorldMapEx_cbContinent_OnUpdateText(self)
	local continentName = self:getText()
	local ltAllInfo = uiWorldMap_GetAllContinentInfo()
	

	if ltAllInfo == nil then return end

	for i, info in ipairs(ltAllInfo) do
		if info.Name == continentName then
			local frmWorldMapEx = uiGetglobal("layWorld.frmWorldMapEx")
			layWorld_frmWorldMapEx_Refresh_MapContinent(frmWorldMapEx, info.Id)
			return
		end
	end
end

function layWorld_frmWorldMapEx_cbZone_OnUpdateText(self)
	local zoneName = self:getText()
	local ltAllInfo = uiWorldMap_GetAllZoneInfo()


	if ltAllInfo == nil then return end

	for i, info in ipairs(ltAllInfo) do
		if info.Name == zoneName then
			local frmWorldMapEx = uiGetglobal("layWorld.frmWorldMapEx")
			layWorld_frmWorldMapEx_Refresh_MapZone(frmWorldMapEx, info.ContinentId, info.Id)
			return
		end
	end
end

function layWorld_frmWorldMapEx_OnZoneChanged(self, zoneId)
	if not self:getVisible() then return end

	local zoneInfo = uiWorldMap_GetZoneInfoById(zoneId)
	if zoneInfo == nil then return end

	layWorld_frmWorldMapEx_Refresh_MapZone(self, zoneInfo.ContinentId, zoneId)
end

function layWorld_TemplateButtonZoneButton_ZoneButton_OnEnter(self)
	local frmWorldMapEx = uiGetglobal("layWorld.frmWorldMapEx")
	local frmContinent = SAPI.GetChild(frmWorldMapEx, string.format("frmContinent%02d", UI_WorldMap_CurShowMapContinentId))
	if not frmContinent:getVisible() then return end
	
	local bBreak = false
	local buttonId = 0
	for i = 1, 32, 1 do
		for j=1, 16, 1 do
			local btZone = SAPI.GetChild(frmContinent, string.format("btZone%03d",i).."_"..string.format("%02d",j))
			if btZone == nil then
				break
			end
			if SAPI.Equal(btZone, self) then
				buttonId = i
				bBreak = true
				break
			end
			
		end
		if bBreak then break end
	end

	if buttonId == 0 then uiInfo("error:::::::buttonId = "..buttonId) return end

	local edtInfo = SAPI.GetChild(frmWorldMapEx, "edtInfo")
	
	local zoneInfo = uiWorldMap_GetZoneInfoById(buttonId)
	if zoneInfo == nil then uiInfo("error:::::::zoneInfo = nil") return end

	edtInfo:SetText(zoneInfo.Name)
	local ckbZone = SAPI.GetChild(frmContinent,string.format("ckbZone%03d", buttonId))
	ckbZone:SetChecked(true)

end

function layWorld_TemplateButtonZoneButton_ZoneButton_OnLeave(self)
	local frmWorldMapEx = uiGetglobal("layWorld.frmWorldMapEx")
	local frmContinent = SAPI.GetChild(frmWorldMapEx, string.format("frmContinent%02d", UI_WorldMap_CurShowMapContinentId))
	if not frmContinent:getVisible() then return end
	
	local bBreak = false
	local buttonId = 0
	for i = 1, 32, 1 do
		for j=1, 16, 1 do
			local btZone = SAPI.GetChild(frmContinent, string.format("btZone%03d",i).."_"..string.format("%02d",j))
			if btZone == nil then
				break
			end
			if SAPI.Equal(btZone, self) then
				buttonId = i
				bBreak = true
				break
			end
			
		end
		if bBreak then break end
	end

	if buttonId == 0 then uiInfo("error:::::::buttonId = "..buttonId) return end

	local edtInfo = SAPI.GetChild(frmWorldMapEx, "edtInfo")

	edtInfo:SetText("")
	local ckbZone = SAPI.GetChild(frmContinent,string.format("ckbZone%03d", buttonId))
	ckbZone:SetChecked(false)
end

function layWorld_TemplateButtonZoneButton_ZoneButton_OnLClick(self)
	layWorld_TemplateButtonZoneButton_ZoneButton_OnLeave(self)
	local frmWorldMapEx = uiGetglobal("layWorld.frmWorldMapEx")
	local frmContinent = SAPI.GetChild(frmWorldMapEx, string.format("frmContinent%02d", UI_WorldMap_CurShowMapContinentId))
	if not frmContinent:getVisible() then return end
	
	local bBreak = false
	local buttonId = 0
	for i = 1, 32, 1 do
		for j=1, 16, 1 do
			local btZone = SAPI.GetChild(frmContinent, string.format("btZone%03d",i).."_"..string.format("%02d",j))
			if btZone == nil then
				break
			end
			if SAPI.Equal(btZone, self) then
				buttonId = i
				bBreak = true
				break
			end
			
		end
		if bBreak then break end
	end

	if buttonId == 0 then uiInfo("error:::::::buttonId = "..buttonId) return end

	layWorld_frmWorldMapEx_Refresh_MapZone(frmWorldMapEx, UI_WorldMap_CurShowMapContinentId, buttonId)
end

function layWorld_TemplateButtonZoneButton_ZoneButton_OnRClick(self)
	local mouse_x, mouse_y = uiGetMousePosition()
	if UI_WorldMap_CurShow_Frm:IsContain(mouse_x, mouse_y) then
		local __X,__Y = uiGetWidgetRect(UI_WorldMap_CurShow_Frm)
		__X = mouse_x - __X
		__Y = mouse_y - __Y

		__X = (__X / UI_WorldMap_Map_Width) * (UI_WorldMap_Area_Right - UI_WorldMap_Area_Left) + UI_WorldMap_Area_Left
		__Y = (1 - __Y / UI_WorldMap_map_Height) * (UI_WorldMap_Area_Bottom - UI_WorldMap_Area_Top) + UI_WorldMap_Area_Top

		uiWorldMap_AutoWalk(UI_WorldMap_CurShowMapContinentId, math.floor(__X), math.floor(__Y))
	end
end

function layWorld_frmWorldMapEx_ChangedVisible(self, _v)
	UI_WorldMap_MapVisible = _v / 100
	if UI_WorldMap_MapVisible < 0 then UI_WorldMap_MapVisible = 0 end
	if UI_WorldMap_MapVisible > 1 then UI_WorldMap_MapVisible = 1 end
	self:SetTransparency(UI_WorldMap_MapVisible)

	if UI_WorldMap_CurShow_Frm ~= nil then
		UI_WorldMap_CurShow_Frm:SetTransparency(UI_WorldMap_MapVisible)
	end
end
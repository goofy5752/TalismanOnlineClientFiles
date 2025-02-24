local UI_AskAndAnswer_AnswerIdx = 0

function layWorld_frmQuestion_ToShow(self)
	self:ShowAndFocus()
	layWorld_frmQuestion_Refresh(self)
end

function layWorld_frmQuestion_Refresh(self)
	local lbundoImg = SAPI.GetChild(self, "lbundoImg")
	local lbQuestionsNumber = SAPI.GetChild(self, "lbQuestionsNumber")
	local lbReward = SAPI.GetChild(self, "lbReward")
	local ckb1 = SAPI.GetChild(self, "ckb1")
	local ckb2 = SAPI.GetChild(self, "ckb2")
	local ckb3 = SAPI.GetChild(self, "ckb3")
	local ckb4 = SAPI.GetChild(self, "ckb4")
	local btSpendInfo = SAPI.GetChild(self, "btSpendInfo")
	btSpendInfo:Disable()

	local ltInfo = uiAskAndAnswer_GetInfo()

	lbundoImg:SetText(ltInfo.question)
	lbQuestionsNumber:SetText(""..ltInfo.rightCnt)
	--lbReward:SetText(LAN("msg_askandanwser_exp")..ltInfo.rightExp.." "..LAN("msg_askandanwser_nimbus")..ltInfo.rightNimbus)
	lbReward:SetText(""..ltInfo.rightExp..LAN("msg_askandanwser_exp")..","..ltInfo.rightNimbus..LAN("msg_askandanwser_nimbus"))
	ckb1:SetText(ltInfo.answer1)
	ckb2:SetText(ltInfo.answer2)
	ckb3:SetText(ltInfo.answer3)
	ckb4:SetText(ltInfo.answer4)
	ckb1:SetChecked(false)
	ckb2:SetChecked(false)
	ckb3:SetChecked(false)
	ckb4:SetChecked(false)

end

function layWorld_frmQuestion_btSpendInfo_OnLClick(self)
	if UI_AskAndAnswer_AnswerIdx == 0 then return end
	local frmQuestion = uiGetglobal("layWorld.frmQuestion")
	
	uiAskAndAnswer_SendAnswer(UI_AskAndAnswer_AnswerIdx)
	UI_AskAndAnswer_AnswerIdx = 0
	frmQuestion:Hide()
	
end

function layWorld_frmQuestion_ckb1_OnLClick(self)
	
	UI_AskAndAnswer_AnswerIdx = 1
	local frmQuestion = uiGetglobal("layWorld.frmQuestion")
	local btSpendInfo = SAPI.GetChild(frmQuestion, "btSpendInfo")
	btSpendInfo:Enable()
	local ckb1 = SAPI.GetChild(frmQuestion, "ckb1")
	local ckb2 = SAPI.GetChild(frmQuestion, "ckb2")
	local ckb3 = SAPI.GetChild(frmQuestion, "ckb3")
	local ckb4 = SAPI.GetChild(frmQuestion, "ckb4")
	ckb1:SetChecked(true)
	ckb2:SetChecked(false)
	ckb3:SetChecked(false)
	ckb4:SetChecked(false)
end

function layWorld_frmQuestion_ckb2_OnLClick(self)
	UI_AskAndAnswer_AnswerIdx = 2
	local frmQuestion = uiGetglobal("layWorld.frmQuestion")
	local btSpendInfo = SAPI.GetChild(frmQuestion, "btSpendInfo")
	btSpendInfo:Enable()
	local ckb1 = SAPI.GetChild(frmQuestion, "ckb1")
	local ckb2 = SAPI.GetChild(frmQuestion, "ckb2")
	local ckb3 = SAPI.GetChild(frmQuestion, "ckb3")
	local ckb4 = SAPI.GetChild(frmQuestion, "ckb4")
	ckb1:SetChecked(false)
	ckb2:SetChecked(true)
	ckb3:SetChecked(false)
	ckb4:SetChecked(false)
end

function layWorld_frmQuestion_ckb3_OnLClick(self)
	UI_AskAndAnswer_AnswerIdx = 3
	local frmQuestion = uiGetglobal("layWorld.frmQuestion")
	local btSpendInfo = SAPI.GetChild(frmQuestion, "btSpendInfo")
	btSpendInfo:Enable()
	local ckb1 = SAPI.GetChild(frmQuestion, "ckb1")
	local ckb2 = SAPI.GetChild(frmQuestion, "ckb2")
	local ckb3 = SAPI.GetChild(frmQuestion, "ckb3")
	local ckb4 = SAPI.GetChild(frmQuestion, "ckb4")
	ckb1:SetChecked(false)
	ckb2:SetChecked(false)
	ckb3:SetChecked(true)
	ckb4:SetChecked(false)
end

function layWorld_frmQuestion_ckb4_OnLClick(self)
	UI_AskAndAnswer_AnswerIdx = 4
	local frmQuestion = uiGetglobal("layWorld.frmQuestion")
	local btSpendInfo = SAPI.GetChild(frmQuestion, "btSpendInfo")
	btSpendInfo:Enable()
	local ckb1 = SAPI.GetChild(frmQuestion, "ckb1")
	local ckb2 = SAPI.GetChild(frmQuestion, "ckb2")
	local ckb3 = SAPI.GetChild(frmQuestion, "ckb3")
	local ckb4 = SAPI.GetChild(frmQuestion, "ckb4")
	ckb1:SetChecked(false)
	ckb2:SetChecked(false)
	ckb3:SetChecked(false)
	ckb4:SetChecked(true)
end
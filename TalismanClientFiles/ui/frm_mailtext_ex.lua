
function layWorld_MailTextsEx_OnShow(self)
	uiRegisterEscWidget(self);
    local frmSendMailTexts;
    local lbTextName;  --邮件发件人
    local lbTextTitle; --邮件标题
    local edbMail;--邮件内容
    local btnA1,btnA2;
    local lbSystext;--官方警告

    local m_icurrent;
    m_icurrent=self:Get("ifmAcceptMailCurrent");

    frmSendMailTexts = uiGetglobal("layWorld.frmMailTextsEx.frmSendMailTexts");
    lbTextName = SAPI.GetChild(frmSendMailTexts,"lbTextName");
    lbTextTitle = SAPI.GetChild(frmSendMailTexts,"lbTextTitle");
    edbMail = SAPI.GetChild(frmSendMailTexts,"edbMail");
    btnA1 = SAPI.GetChild(frmSendMailTexts,"btnA1");
    btnA2 = SAPI.GetChild(frmSendMailTexts,"btnA2");
    lbSystext = SAPI.GetChild(frmSendMailTexts,"lbSystext");

    --Mail Sender's Name
    if MailExItems[m_icurrent].SenderName~="" then
        lbTextName:SetText(MailExItems[m_icurrent].SenderName);
    else
        lbTextName:SetText(uiLanString("gm_name"));
    end
    --Mail Title
    lbTextTitle:SetText(MailExItems[m_icurrent].Title);
    --Mail Content
    edbMail:SetText(MailExItems[m_icurrent].Content);
    edbMail:Disable();
    --Alarm Safe
    if MailExItems[m_icurrent].IsSystemMail==false then
        lbSystext:SetTextColorEx(0,0,255,255);
        lbSystext:SetText(uiLanString("msg_mail_not_sys_mail"));
       else
        lbSystext:SetText("");
    end


    btnA1:Hide();
    btnA2:Hide();

    --Mail 's Attach 1
   -- uiMessage(tostring(MailExItems[m_icurrent]["Item"]));

     btnA1:SetUltraTextNormal("");
    if MailExItems[m_icurrent]["Item"]~=nil and MailExItems[m_icurrent]["Item"]["Icon"]~=nil then
       btnA1:SetBackgroundImage(SAPI.GetImage(MailExItems[m_icurrent]["Item"]["Icon"]));
                if MailExItems[m_icurrent]["Item"]["Count"]~=nil then
                    btnA1:SetUltraTextNormal(tostring(MailExItems[m_icurrent]["Item"]["Count"]));
                end
       btnA1:Show();
    end
    --Mail 's Attach 2 Money
    if MailExItems[m_icurrent]["Money"]~=nil and MailExItems[m_icurrent]["Money"]["Icon"]~=nil then
        btnA2:SetBackgroundImage(SAPI.GetImage(MailExItems[m_icurrent]["Money"]["Icon"]));
        btnA2:Show();
    end

	--uiMessage("Go to show mailex......");

end

function layWorld_frmMailTextsEx_frmSendMailTexts_OnLClick(index)
    local m_icurrent;
    local MailTextsEx = uiGetglobal("layWorld.frmMailTextsEx");
    m_icurrent=MailTextsEx:Get("ifmAcceptMailCurrent");
    if index == 1 then
    uiMailGetItem(m_icurrent-1);
    elseif index == 2 then
    uiMailGetMoney(m_icurrent-1);
    end
end

function layWorld_frmMailTextsEx_frmSendMailTexts_MailDelete(self)
    local m_icurrent;
    local MailTextsEx = uiGetglobal("layWorld.frmMailTextsEx");
    m_icurrent=MailTextsEx:Get("ifmAcceptMailCurrent");
    --删除邮件时，当附件如果有未取的东西要弹出对话框询问
    --uiMessage(tostring(m_icurrent-1));
    if MailExItems[m_icurrent]["Item"]~=nil and MailExItems[m_icurrent]["Item"]["Icon"]~=nil or
       MailExItems[m_icurrent]["Money"]~=nil and MailExItems[m_icurrent]["Money"]["Icon"]~=nil then

       uiMessageBox(uiLanString("msg_mail_del_ask"),"",true,true,true);
       SAPI.AddDefaultMessageBoxCallBack(layWorld_frmMailTextsEx_frmSendMailTexts_MailDeleteAttachYes,layWorld_frmMailTextsEx_frmSendMailTexts_MailDeleteAttachNo,m_icurrent);
    else
       layWorld_frmMailTextsEx_frmSendMailTexts_MailDeleteAttachYes("Ok",m_icurrent);
    end

end

function layWorld_frmMailTextsEx_frmSendMailTexts_MailDeleteAttachYes(_,m_icurrent)

     uiMailDeleteMail(m_icurrent-1);
     layWorld_frmMailTextsEx_frmSendMailTexts_MailClose();

end

function layWorld_frmMailTextsEx_frmSendMailTexts_MailDeleteAttachNo(_,self)
    --not do any thing
end


function layWorld_frmMailTextsEx_frmSendMailTexts_MailClose(self)
    local frmMailTextsEx = uiGetglobal("layWorld.frmMailTextsEx");
    frmMailTextsEx:Hide();
	--
	layWorld_frmMailEx_process_autoDelMailItem()
end

function layWorld_MailTextsEx_OnHide(self)
    layWorld_frmMailEx_fmAcceptMail_UnCheckAllButton();
end

function layWorld_MailTextsEx_Hide()
    local frmMailTextsEx = uiGetglobal("layWorld.frmMailTextsEx");
    frmMailTextsEx:Hide();
end

function layWorld_MailTextsEx_OnUpdate(self)
	if uiMailDialogCheckDistance() ~= true then
		self:Hide();
	end
end

function layWorld_frmMailTextsEx_frmSendMailTexts_OnHint(self)
    local hint = 0;
    local m_icurrent;
    local MailTextsEx = uiGetglobal("layWorld.frmMailTextsEx");
    m_icurrent=MailTextsEx:Get("ifmAcceptMailCurrent");

    uiInfo("layWorld_frmMailTextsEx_frmSendMailTexts_OnHint");

   	self:SetHintRichText(hint);
    if MailExItems[m_icurrent] and MailExItems[m_icurrent]["Item"] and MailExItems[m_icurrent]["Item"]["ObjectId"] then
     	hint = uiMailGreateHint(MailExItems[m_icurrent]["Item"]["ObjectId"]);
     	self:SetHintRichText(hint);
    end

end
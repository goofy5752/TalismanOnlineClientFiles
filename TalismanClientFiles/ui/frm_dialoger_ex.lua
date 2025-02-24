----------------------
--NPC 对话框  wj
function layWorld_frmDialogerEx_btClose_OnLClick()
    local layWorld_frmDialogerEx = uiGetglobal("layWorld.frmDialogerEx");
    layWorld_frmDialogerEx:Hide();
end

function layWorld_frmDialogerEx_edtdialogerTest_OnHyperLink(self, hypertype, hyperlink)
    local bNormal=true;    
    local iType=0;
    local iParam={};
    local layWorld_frmDialogerEx = uiGetglobal("layWorld.frmDialogerEx");
    

    if hyperlink ~= nil then
        --uiMessage(tostring(hyperlink));
        --uiInfo("OnHyperLink:"..tostring(hyperlink));
        if tostring(hyperlink) == "guildterrupdate:param?i=2"
        or tostring(hyperlink) == "guildterrnew:param?i=2"  then
            local count,_,_=uiGetBagItemInfoByType(EV_ITEM_TYPE_GUILDTERRTREESPEED);
            if count>=1 then
                bNormal=false;
                iType=1; --update the tree item
                --uiInfo("OnHyperLink:false");
            else 
                bNormal=true;                
                --uiInfo("OnHyperLink:true normal");
                --uiInfo("OnHyperLink:"..tostring(hyperlink));
            end
        elseif tostring(hyperlink) == "guildwar:NA?NA=0" then
            local frmGuildPKEx = uiGetglobal("layWorld.frmGuildPKEx");
            frmGuildPKEx:Show();
            layWorld_frmDialogerEx:Hide();
            return;            
        else
            bNormal=true;
        end        
        iParam[1]=iType;
        iParam[2]=hyperlink;
        
        if bNormal == true then
            uiPost(hyperlink);
            local layWorld_frmDialogerEx = uiGetglobal("layWorld.frmDialogerEx");
            layWorld_frmDialogerEx:Hide();
            --uiInfo("bNormal ---OnHyperLink:true ");
        else
            --uiInfo("bNormal ---OnHyperLink:false ");
            --uiInfo(uiLanString("GUILDTERR_ITEM_USE"));
            local wordmess="";
            local msgBox;
            if tostring(hyperlink) == "guildterrupdate:param?i=2" then
                wordmess=uiLanString("GUILDTERR_ITEM_USE");
                msgBox = uiMessageBox(wordmess,"",true,true,true);
                SAPI.AddDefaultMessageBoxCallBack(msgBox,layWorld_frmDialogerEx_edtdialogerTest_OnHyperLink_Yes,layWorld_frmDialogerEx_edtdialogerTest_OnHyperLink_No,iParam);            
            elseif tostring(hyperlink) == "guildterrnew:param?i=2" then
                wordmess=uiLanString("GUILDTERR_ITEM_USE_NEW");
                msgBox = uiMessageBox(wordmess,"",true,true,true);
                SAPI.AddDefaultMessageBoxCallBack(msgBox,layWorld_frmDialogerEx_edtdialogerTest_OnHyperLink_Yes,layWorld_frmDialogerEx_edtdialogerTest_OnHyperLink_No,iParam);            
            end
 
        end
        
    end
end

function layWorld_frmDialogerEx_edtdialogerTest_OnHyperLink_Yes(_,iParam)
    local bSuccess=true;
    local hyperlink=tostring(iParam[2]);

    if iParam[1] == 1 then
        hyperlink=hyperlink.."&item=1";
    end
    --uiInfo("POST"..hyperlink);

    uiPost(hyperlink);
    local layWorld_frmDialogerEx = uiGetglobal("layWorld.frmDialogerEx");
    layWorld_frmDialogerEx:Hide();
end

function layWorld_frmDialogerEx_edtdialogerTest_OnHyperLink_No(_,iParam)
    local hyperlink=tostring(iParam[2]);
    uiPost(hyperlink);
    local layWorld_frmDialogerEx = uiGetglobal("layWorld.frmDialogerEx");
    layWorld_frmDialogerEx:Hide();
end

function layWorld_frmDialogerEx_OnLoad(self)
    self:RegisterScriptEventNotify("event_interactive_with_npc");
end

function layWorld_frmDialogerEx_OnEvent(self,event,arg)    
    if event == "event_interactive_with_npc" then
		local NpcObjectId = arg[1];
		local NpcWord = arg[2];
        local NpcName,NpcImg;
		
		local i = string.find(NpcWord, "<Item"); -- NpcWord是一个RichText 如果没有Item标签,则说明没有内容
		if not i then return end

        local lbdialogerNpcName;
        local btdialogerImg;
        local edtdialogerTest;
        lbdialogerNpcName = SAPI.GetChild(self,"lbdialogerNpcName");
        btdialogerImg = SAPI.GetChild(self,"btdialogerImg");
        edtdialogerTest = SAPI.GetChild(self,"edtdialogerTest");
        
        --Get Current Interactive NPC's Information
        NpcObjectId,NpcName,NpcImg=uiNpcDialogGetNpcInfo();
        self:ShowAndFocus();
        if NpcName ~= nil then
            lbdialogerNpcName:SetText(NpcName);
        end
        if NpcImg ~= nil then
            btdialogerImg:SetBackgroundImage(SAPI.GetImage(NpcImg));            
        end
        if NpcWord ~= nil then
			edtdialogerTest:SetRichText(NpcWord,false);
        end   
    end    
end

function layWorld_frmDialogerEx_OnUpdate(self, delta)
	-- 每秒检查一次与NPC之间的距离
	local bInside = uiNpcDialogCheckDistance();
	if bInside == false then
		self:Hide();
	end
end





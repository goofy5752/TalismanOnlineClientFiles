



--uiHelpGetHelpMenuList

function layWorld_frmHelpEx_lstHelpInfo_OnSelect(self)
     local helpcontent=uiHelpGetHelpMenuList();
    local lstHelpInfo=uiGetglobal("layWorld.frmHelpEx.lstHelpInfo");
    local edtContext=uiGetglobal("layWorld.frmHelpEx.edtContext");
    local commonstr=uiGetCommonPath().."help\\"; --edbHelpIndex:SetRichTextFile("local\\common\\help\\help001.xml",false);
    local iSel=lstHelpInfo:getSelectLine();
    edtContext:SetText("");
    edtContext:SetRichTextFile(commonstr..helpcontent[iSel+1].File,true);    
end

function layWorld_frmHelpEx_OnShow(self)
	uiRegisterEscWidget(self);
    local helpcontent=uiHelpGetHelpMenuList();
    local iNum=table.getn(helpcontent);
    local lstHelpInfo=uiGetglobal("layWorld.frmHelpEx.lstHelpInfo");
    lstHelpInfo:RemoveAllColumns(false);
    lstHelpInfo:RemoveAllLines(true);

    lstHelpInfo:InsertColumn(uiLanString("help_reference"),200,4294967040,-1,-1,-1);
    for i=1,iNum,1 do
       lstHelpInfo:InsertLine(-1,4294967040,-1);
       lstHelpInfo:SetLineItem(i-1,0,tostring(helpcontent[i].Title),4294967040);
    end
    lstHelpInfo:SetSelect(0);
end


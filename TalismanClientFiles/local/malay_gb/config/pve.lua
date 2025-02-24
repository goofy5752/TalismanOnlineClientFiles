OpenFlag = 1; --系统是否开放, 1 : 开放, 0 : 关闭

PVEState = 0
PVEBeginTime = 0;
PVELastTime = 7200;
PVESceneObjId = 0;
NpcLevel = GetLimitLevel();
BroadcastEndFlag = 0;
if NpcLevel  >= 99 then
	NpcLevel = 80
end
BossSet = {5363,5379,5406}
PVESceneResId = 21

function IsPVETime()
    local DayOfWeek = GetServerDayOfWeek();
    local Hour = GetServerHour();

    if (DayOfWeek == 0) and (Hour >= 19 and Hour <= 21) then
        return 1;
    end

    return 0;
end

function On1MinTimer(dwNow)
    if PVEState == 0 then
        if IsPVETime() == 1 then
            --BeginPVE()
        end
    else
        if (dwNow - PVEBeginTime) > (PVELastTime - 300) then
    		if BroadcastEndFlag == 0 then
    		    BroadcastEndFlag = 1
    		    str=L("msg_script_pve_end");
    		    Bulletin(str);
    		end
    	end
    
    	if (dwNow - PVEBeginTime) > PVELastTime then
    		EndPVE()
    	end
    end
end

function OnBeginPVE()
    PVEState = 1
    PVEBeginTime = GetServerTime();

    PVESceneObjId = SvrCreateScene(PVESceneResId);
    PVEOnSceneCreate(PVESceneObjId);

    CreateSceneNpc(1, 2074, 10, -1658, 8)

    local str=L("msg_script_pve_begin");
    SendMedia(str,6);
end

function OnEndPVE()
    BroadcastEndFlag = 0;

    PVEState = 0;
	PVEBeginTime = 0;
	
	if PVESceneObjId ~= 0 then
	    SvrChangeSceneAllUser(PVESceneObjId, 1, 51, -1629)
	
	    SvrDestroyScene(PVESceneObjId);
	    PVESceneObjId = 0;
	end

    local str=L("msg_script_pve_ended");
    SendMedia(str,6);
end

function GetPVEPoint(nUserId, nNpcId, nNpcTypeId, nUserLev, nNpcLev, nUserParty, nVal)
    -- 0 峨嵋 1 佛门 2 青城 3 百花 4 仙禽
    local pvepoint = 0;
    local npcrad = 1;
    local partyrad = 1;
    --小头领比率
    if nNpcTypeId == 5374 or nNpcTypeId == 5354 or nNpcTypeId == 5381 or nNpcTypeId == 5382 then
	npcrad = 1.5
    end
    --Boss比率
    if nNpcTypeId == 5363 or nNpcTypeId == 5379 or nNpcTypeId == 5380 or nNpcTypeId == 5406 or nNpcTypeId == 5407 then
	npcrad = 2
    end
    --花刺
    --if nNpcTypeId == 5382 then
    --	npcrad = 0.1
    --end 
    --门派比率
    if nUserParty == 0 then
	if nUserLev >= 41 and nUserLev <= 50 then
	   partyrad = 1
	end
	if nUserLev >= 51 then
	   partyrad = 0.8
	end
    end
    
    if nUserParty == 2 or nUserParty == 3 or nUserParty == 4 then
	partyrad = 1
    end

    if nUserParty == 1 then
	partyrad = 1.6
    end
    
    pvepoint = nNpcLev * npcrad * partyrad * nVal / 2000
    --OutputLog("pvepoint = "..pvepoint)
    return pvepoint;
end

function GetPVEPointByAddHp(nUserId, nTarUserId, nUserLev, nTarUserLev, nUserParty, nTarUserParty, nVal, nNpcLev)
	local pvepoint = 0;
	local healrad = 1;
	local healselfrad = 1;
	
	if nUserId == nTarUserId then 
	    healselfrad = 0.5
	end
	if nUserLev >= 40 and nUserLev<=50 then
	    healrad = 0.05
	end
	if nUserLev >= 51 and nUserLev<= 60 then
	    healrad = 0.5
	end
	if nUserLev >= 61 then
	    healrad = 0.5
	end

    
	

	pvepoint = nNpcLev * healselfrad * healrad * nVal / 300
	return pvepoint;
end

function GiveBonusByRank(szUserName, nRank, nUserParty, nUserLev, nPoint)
    local LAN_Text = "" ;
    local LAN_Title = "" ;
    if (nPoint > 50000) then
     	     LAN_Title = L("msg_script_pve_title");
            --"第%d名奖励"
            LAN_Text = L("msg_script_pve_txt");
            mailTitle = LAN_Title
            mailContent = string.format(LAN_Text, nRank);
	if (nRank <= 5) then           
    		--CreateCodeItemAddMailByName(szUserName, 11116, "v=1;s=1|i=3972;b=2;%=10", mailTitle, mailContent)
	elseif (nRank <= 10) then
		--CreateCodeItemAddMailByName(szUserName, 11116, "v=1;s=1|i=3972;b=2;%=5", mailTitle, mailContent)
	elseif (nRank <= 20) then
		--CreateCodeItemAddMailByName(szUserName, 11116, "v=1;s=1|i=3972;b=2;%=3", mailTitle, mailContent)
	elseif (nRank <= 50) then
		--CreateCodeItemAddMailByName(szUserName, 11116, "v=1;s=1|i=3971;b=2;%=4", mailTitle, mailContent)
	elseif (nRank <= 100) then
		--CreateCodeItemAddMailByName(szUserName, 11116, "v=1;s=1|i=3971;b=2;%=2", mailTitle, mailContent)
	end
   end
end
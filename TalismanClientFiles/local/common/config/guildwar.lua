OpenFlag = 1; --系统是否开放, 1 : 开放, 0 : 关闭

DeclareGuildMinLevel = 7;
TopKiller = 50;  --最大杀手显示排名人数

GuildWarState = 0;
GuildWarBeginTime = 0;
GuildWarLastTime = 3600;

function GetDeclareGuildWarMoney(nGuildLev, nDeclareGuildLev)
    if nGuildLev <= nDeclareGuildLev then
        return 20 * 10000;
    end
    
    local nLevDiff = nGuildLev - nDeclareGuildLev;
    return (20 + 30 * nLevDiff) * 10000;
end

function GuildWarTimeCheck(tm)
    local DayOfWeek = GetServerDayOfWeek();
    local Hour = GetServerHour();

    if tostring(tm) == "guildb" then
        --Check Is GuildWar time begin
        if (DayOfWeek == 2 or DayOfWeek == 4) and (Hour == 20) then
            return 1;
        else
            return 0;
        end
    elseif tostring(tm)== "guildcandeclare" then
       --Check is guild war can declare
       if (DayOfWeek == 2 or DayOfWeek == 4) and (Hour >= 19 and Hour <= 20) then
           return 0;
       else
           return 1;
       end
    elseif tostring(tm)== "guildbafter" then
      --在帮会战时间内 以及当天 帮战时间后
        if Hour >= 20 and (DayOfWeek == 2 or DayOfWeek == 4) then
            return 1;
        else
            return 0;
        end
    end
    return 0;
end

function IsDeclareGuildWarTime()   
    return GuildWarTimeCheck("guildcandeclare");
end

function IsGuildWarTime()    
    return GuildWarTimeCheck("guildb");   
end

function On1MinTimer(dwNow)
    if GuildWarState == 0 then
        --local DayOfWeek = GetServerDayOfWeek();
        --local NowHour = GetServerHour();
        if IsGuildWarTime()==1 then
            BeginGuildWar()
        end
    else
    	if (dwNow - GuildWarBeginTime) > GuildWarLastTime then
    		EndGuildWar()
    	end
    end
end

function OnBeginGuildWar()
    GuildWarState = 1
    GuildWarBeginTime = GetServerTime();
    local str=L("MSG_GUILDWAR_BEGIN");
    SendMedia(str,6);
end

function OnEndGuildWar()
    GuildWarState = 0;
	GuildWarBeginTime = 0;
    local str=L("MSG_GUILDWAR_END");
    SendMedia(str,6);
end

function OnGuildWarDeclareSuccess(nUserId, strGuildName, strDeclareGuildName)
    --发传闻
    local str=string.format(L("MSG_GUILDWAR_WORLD1"),strGuildName,strDeclareGuildName,GetNextGuildWarTime());
    SendMedia(str,6);
end

function OnUserEnterWorld(nUserId, strDeclareGuildName)
    --ReceiveMsg
    local str="";
    if IsGuildWarTime()==1 then
         str=string.format(L("MSG_GUILDWAR_WORLD3"),strDeclareGuildName,"21:00");
    else
         str=string.format(L("MSG_GUILDWAR_WORLD2"),strDeclareGuildName,GetNextGuildWarTime());
    end
    ReceiveMsg(nUserId, str, 7);
end

function GetPreGuildWarTime()
    local DayOfWeek = GetServerDayOfWeek();
    local NowHour = GetServerHour();
    local ServerTime = GetServerTime();

    local Year,Month,Day,strNextData;  
    --if NowHour >= 20 and (DayOfWeek == 2 or DayOfWeek == 4) then
    if GuildWarTimeCheck("guildbafter")==1 then
        --在帮会战时间内 以及当前 帮战时间后
        Year = GetTimeYear(ServerTime);
        Month = GetTimeMonth(ServerTime);
        Day = GetTimeDay(ServerTime);
        strNextData=string.format(L("MSG_GUILDWAR_LSTTM"),tostring(Year),tostring(Month),tostring(Day));
        return tostring(strNextData);    
    else
        --在帮会战时间前
        local AddDay = 0;
        if DayOfWeek == 0 then            
            AddDay = -3;
        elseif DayOfWeek == 1 then
            AddDay = -4;
        elseif DayOfWeek == 2 then
            AddDay = -5;            
        elseif DayOfWeek == 3 then
            AddDay = -1;            
        elseif DayOfWeek == 4 then
                AddDay = -2;
        elseif DayOfWeek == 5 then
            AddDay = -1;
        elseif DayOfWeek == 6 then
            AddDay = -2;
        end
        local PreGuildWarTime = ServerTime + AddDay * 24 * 3600;
        Year = GetTimeYear(PreGuildWarTime);
        Month = GetTimeMonth(PreGuildWarTime);
        Day = GetTimeDay(PreGuildWarTime);
        strNextData=string.format(L("MSG_GUILDWAR_LSTTM"),tostring(Year),tostring(Month),tostring(Day));
        return tostring(strNextData);
    end

end

function GetNextGuildWarTime()
    local DayOfWeek = GetServerDayOfWeek();
    local NowHour = GetServerHour();

    local strre=L("MSG_GUILDWAR_WORLD4");

    --if NowHour == 20 and (DayOfWeek == 2 or DayOfWeek == 4) then
    --    return tostring(strre);
    --end
    if GuildWarTimeCheck("guildb") == 1 then
        return tostring(strre);
    end

    local ServerTime = GetServerTime();
    local AddDay = 0;
    if DayOfWeek == 0 then
        AddDay = 2;        
    elseif DayOfWeek == 1 then
        AddDay = 1
    elseif DayOfWeek == 2 then
        if NowHour < 20 then
            AddDay = 0;
        else
            AddDay = 2;
        end
    elseif DayOfWeek == 3 then
        AddDay = 1
    elseif DayOfWeek == 4 then
        if NowHour < 20 then
            AddDay = 0;
        else
            AddDay = 5;
        end
    elseif DayOfWeek == 5 then
        AddDay = 4
    elseif DayOfWeek == 6 then
        AddDay = 3
    end
    
    local NextGuildWarTime = ServerTime + AddDay * 24 * 3600;
    local Year = GetTimeYear(NextGuildWarTime);
    local Month = GetTimeMonth(NextGuildWarTime);
    local Day = GetTimeDay(NextGuildWarTime);

    local strNextData=string.format("%s-%s-%s 20:00-21:00",tostring(Year),tostring(Month),tostring(Day));
    
    return tostring(strNextData);
end

function OnGuildWarGiveBonus(
    GuildName, KillCount, LeaderDBId,
    AgainstGuildName, AgainstKillCount
)
    if KillCount > AgainstKillCount then
        --SendMedia(str,6);
    end

    if KillCount >= 300 then
        --CreateCodeItemAddMailByDBId(LeaderDBId, codeItemIndex, itemCode, mailTitle, mailContent)
    end
end

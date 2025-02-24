
include("script/game_script_base.lua")

--城战的怪物被创建后调用,包括载入存盘后的城战
function ResetMonsterData(creId, lev)
        --OutputLog("ResetMonsterData "..lev)
	--SetMonsterLev(creId, lev)
	SetNpcLevAndAttrib(creId, lev)
end

function OnWarWin(_warArea, _guild)
    if GuildTerritoryAddPoint(_guild, 5000) then
	local strGuildName = GuildGetName(_guild);
	Msg(2, "world", string.format(L("msg_guild_win"),strGuildName));
    else
    end
end

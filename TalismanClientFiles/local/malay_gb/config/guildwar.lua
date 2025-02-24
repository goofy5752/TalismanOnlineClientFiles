function OnGuildWarGiveBonus(
    GuildName, KillCount, LeaderDBId,
    AgainstGuildName, AgainstKillCount
)
    if KillCount > AgainstKillCount then
        --SendMedia(str,6);
    end
    
    LAN_Title = L("msg_script_guildwar_title");
    LAN_Text = L("msg_script_guildwar_text");
   

    if KillCount >= 300 then
        CreateCodeItemAddMailByDBId(LeaderDBId, 11112, "v=1;s=1|i=5638;b=2", LAN_Title, LAN_Text)
    end
end

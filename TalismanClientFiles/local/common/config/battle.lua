PkPunish_GoldRate = {0,10,20};		-- pk惩罚，损失的金钱比率
PkPunish_ExpRate = {0,2,8};		-- pk惩罚，损失的经验比率
PkPunish_NimbusRate = {0,2,8};		-- pk惩罚，损失的灵力比率
PkPunish_DropEquipmentRate = {0,0,15};	-- pk惩罚，掉落装备的概率
PkPunish_DropMainTrump = false;		-- pk惩罚，是否掉落主法宝类道具
PkPunish_DropSubTrump = false;		-- pk惩罚，是否掉落副法宝类道具
DeBuffWeakTime = 30000;			-- DeBuff效果减益的有效时间
Ectype_MinRiderLevel = 7;		-- 在副本里骑乘兽的最小锻造等级

--int GetCreParty(int nCreId)
--int GetCreLev(int nCreId)
--int GetCreHp(int nCreId)
--int GetCreMaxHp(int nCreId)
--int GetCreMp(int nCreId)
--int GetCreMaxMp(int nCreId)
--int AddCreEff(int nCreId, int nAdderId, int nEffId)
--int GetCreSpeed(int nCreId)
--int GetCreDistance(int nCre1Id, int nCre2Id)
--int CreHasEff(int nCreId, int nEffId)
--int IfCreRideThenUnRide(int nCreId)
--int GetNpcTypeId(int nNpcId)

function OnNpcBackAttackUser(nEcyptId, nNpcId, nNpcTypeId, nNpcTitle, nUserId)
   if nEcyptId > 0 then
     Random = math.random(1, 100);
     if (Random < 30) then
        AddCreEff(nUserId, nNpcId, 9)
     end
   end
end


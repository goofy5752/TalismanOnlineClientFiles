Version = 1 --系统版本
OpenFlag = 1 --系统是否开放, 1 : 开, 0 : 关
AutoAskFlag = 1 --是否开启随机回答问题, 1 : 开, 0 : 关
MaxAskCount = 3 --最多询问次数
AskInterval = 30 * 60 --随即回答问题的问题发送间隔，单位秒
AnswerTimeLimit = 180 --回答时限，单位秒
LockDuration = 10 * 60 --禁止时间，单位秒
LockAskInterval = 5 * 60 --锁定时发送问题的时间间隔，单位秒
TimeoutAnswerWrongFlag = 1 --超时认为答错

--int GetUserParty(int nUserId);获取门派
--int GetUserLevel(int nUserId);获取等级
--void AddUserExp(int nUserId, int nAddExp);加经验
--void AddUserNimbus(int nUserId, int nAddNimbus);加灵力
--void AddUserMoney(int nUserId, int nAddMoney);加金钱
--void AddEffect(int nUserId, int nEffectId);加Buffer

function OnAnswerOk(nUserId)
    if IsGMAsk(nUserId) == 1 then
        return
    end

    iLev = GetUserLevel(nUserId);
    if (iLev < 10) then
        AntiAddUserExp(nUserId, 300)
	AntiAddUserNimbus(nUserId, 150)
    elseif (iLev >= 10 and iLev < 30) then
        AntiAddUserExp(nUserId, 800)
	AntiAddUserNimbus(nUserId, 400)
    elseif (iLev >= 30 and iLev < 60) then
        AntiAddUserExp(nUserId, 1200)
	AntiAddUserNimbus(nUserId, 600)
    else 
	AntiAddUserExp(nUserId, 1800)
	AntiAddUserNimbus(nUserId, 900)
    end
end

function OnAnswerWrong(nUserId, nAskCnt)
    if (nAskCnt == 1) then
        AskUser(nUserId);
        return;
    end

    ClearAskCount(nUserId);

    nOneDayWrongCnt = IncOneDayWrongCnt(nUserId);
    if (nOneDayWrongCnt == 1) then
        LockUser(nUserId, 10 * 60)
    elseif (nOneDayWrongCnt == 2) then
        BlockAccount(nUserId, 60 * 60);
        KickUser(nUserId);
    elseif (nOneDayWrongCnt == 3) then
        BlockAccount(nUserId, 360 * 60);
        KickUser(nUserId);
    else
        BlockAccount(nUserId, 2880 * 60);
        KickUser(nUserId);
    end
end


CameraEffect = 0
ShakeRadian = 0
EffectIntensity = 0
EffectSpeed = 0

function OnTick(dwDelta)
    
    if CameraEffect == 0 then
        return    
    end
    
    if CameraEffect == 1 then
        ShakeRadian = ShakeRadian + (dwDelta / 1000);
        local z = math.abs(math.sin(EffectSpeed * ShakeRadian)) * EffectIntensity + math.random(-5, 5);
        AddCameraPos(0, 0, z)    
    end
    
end

function OnItemUseBegin(pCreature, pItem, pTarget)
    if IsControlUser(pCreature) == 1 then
        if GetItemIndex(pItem) == 1200 then
            --CameraEffect = 1;
            EffectSpeed = 4;
            ShakeRadian = 0;
            EffectIntensity = 10;
        end
    end
end

function OnItemUseEnd(pCreature, pItem, Result, pTarget)
    if IsControlUser(pCreature) == 1 then
        if CameraEffect == 1 then
            CameraEffect = 0;
        end
    end
end

function SplitString(szFullString, szSeparator)
    local nFindStartIndex = 1
    local nSplitIndex = 1
    local nSplitArray = {}
    local nFullStringLen = string.len(szFullString)
    local nSeparatorLen = string.len(szSeparator)
    while true do
        local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
        if not nFindLastIndex then
            nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFullStringLen)
            break
        end
        nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
        nFindStartIndex = nFindLastIndex + nSeparatorLen
        nSplitIndex = nSplitIndex + 1
    end
    return nSplitArray
end

function OnCamera(nCreId, strParam)
    local vecParam = SplitString(strParam, ";")
    if vecParam[1] then
        if vecParam[1] == "target" then
            if not vecParam[2] then
                return
            end
            local nPlayPoseMillSec = 1000
            if vecParam[3] then
                nPlayPoseMillSec = tonumber(vecParam[3])
            end
            local fScale = 1
            if vecParam[4] and vecParam[5] then
                local fMinDis = tonumber(vecParam[4])
                local fMaxDis = tonumber(vecParam[5])
                local TargetUserDis = GetTarUserDistance(nCreId);
                if TargetUserDis <= fMinDis then
                    fScale = 1
                elseif TargetUserDis >= fMaxDis then
                    return
                else
                    fScale = 1 - (TargetUserDis - fMinDis) / (fMaxDis - fMinDis)
                end
                if fScale >= 1 then
                    fScale = 1
                end
                if fScale <= 0 then
                    return
                end
            end
            PlayTargetCameraEff(vecParam[2], nPlayPoseMillSec, fScale)
        end
    end
end

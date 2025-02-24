AnswerRightCount = 15

function GetAnswerRightExp(nLevel, nParty)
    if nLevel <= 20 then
        return 3000
    elseif nLevel <= 30 then
        return 4000
    elseif nLevel <= 40 then
        return 5000
    else
        return 8000
    end
end

function GetAnswerRightNimbus(nLevel, nParty)
    if nLevel <= 20 then
        return 1000
    elseif nLevel <= 30 then
        return 2000
    elseif nLevel <= 40 then
        return 2500
    else
        return 4000
    end
end

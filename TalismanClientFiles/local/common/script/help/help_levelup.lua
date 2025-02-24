function OnUpdateMonster()
	nLevel = GetUserLevel()
	iParty = GetUserParty()
	if nLevel <=4 then
    		SetMonsterFile("helpmonster1to4.xml")
	elseif nLevel >= 5 and nLevel <= 10 then
		if iParty == 0 then
    			SetMonsterFile("helpmonster5to10a.xml")
		elseif iParty == 1 then
			SetMonsterFile("helpmonster5to10a.xml")
		elseif iParty == 2 then
			SetMonsterFile("helpmonster5to10a.xml")
		elseif iParty == 3 then
			SetMonsterFile("helpmonster5to10b.xml")
		elseif iParty == 4 then
			SetMonsterFile("helpmonster5to10b.xml")
		end
	elseif nLevel >= 11 and nLevel <= 20 then
		SetMonsterFile("helpmonster11to20.xml")
	elseif nLevel >= 21 and nLevel <= 24 then
		SetMonsterFile("helpmonster21to24.xml")
	elseif nLevel >= 25 and nLevel <= 30 then
		SetMonsterFile("helpmonster25to30.xml")
	elseif nLevel >= 31 and nLevel <= 35 then
		SetMonsterFile("helpmonster31to35.xml")
	elseif nLevel >= 36 and nLevel <= 40 then
		SetMonsterFile("helpmonster36to40.xml")
	elseif nLevel >= 41 and nLevel <= 45 then
		SetMonsterFile("helpmonster41to45.xml")
	elseif nLevel >= 46 and nLevel <= 50 then
		SetMonsterFile("helpmonster46to50.xml")
	elseif nLevel >= 51 and nLevel <= 60 then
		SetMonsterFile("helpmonster51to60.xml")
	end
end

function OnUpdateDungeon()
	nLevel = GetUserLevel()
	if nLevel >=15 and nLevel < 25 then
		SetDungeonFile("helpfuben1.xml")
		SetDungeonFile("helpfuben2.xml")    
	elseif nLevel >= 25  and nLevel < 35 then
		SetDungeonFile("helpfuben3.xml")
	elseif nLevel >= 35  and nLevel < 40 then
		SetDungeonFile("helpfuben35.xml")
	elseif nLevel >= 40  and nLevel < 45 then
		SetDungeonFile("helpfuben4.xml")
	elseif nLevel >= 45  and nLevel < 55 then
		SetDungeonFile("helpfuben5.xml")
	elseif nLevel >= 55  and nLevel < 60 then
		SetDungeonFile("helpfuben6.xml")
	elseif nLevel >= 60  then
		SetDungeonFile("helpfuben7.xml")

	end
end

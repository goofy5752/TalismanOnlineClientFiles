OpenFlag = 1 --摆摊系统是否开放, 1 : 开放, 0 : 关闭

MinStallLevel = 10 --摆摊最小等级

CanBuyWhenStall = 0 --摆摊时是否允许购买其它摊位的东西，1 : 允许, 0 : 不允许

MaxSloganTextSize = 24 --摆摊招牌的最大字节长度

MaxStallTalkPageItemSize = 20 --留言最大字节长度

MaxStallTalkPageItemCount = 32 --最大留言条数

StallArea = {2} --可以摆摊的区域Id

MinStallInterval = 80 --摆摊最小间隔

function OnStallStateChanged(nUserId, nStallState, nLevel, nSex)

	if nStallState == 1 then
	   if nLevel < 30 then
	     if nSex == 0 then
		SetModel(nUserId, 5063)
             else
                SetModel(nUserId, 5064)
	     end
	   elseif nLevel >= 30 then
	     if nSex == 0 then
		SetModel(nUserId, 5065)
	     else
		SetModel(nUserId, 5066)
             end
	   end
	else
		ResetModel(nUserId)
	end

end


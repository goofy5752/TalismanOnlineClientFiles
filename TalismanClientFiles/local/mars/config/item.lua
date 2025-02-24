include("script/game_script_base.lua")

ItemMaxSmithingLevel                = 12;			        								-- 道具最大打造等级
ItemSmithing_FailCounter_Enable     = true;                 					-- 是否开启记录道具的打造失败次数
ItemSmithing_FailCounter_Add        = { 5,5,5,5,5,5,1,1,1,1,1,1,0 }   			-- 额外成功率(失败次数 * x%)
ItemSmithing_FailCounter_MaxAdd     = 20                    					-- 额外成功率最大不超过x%
ItemSmithing_TrumpEffect    	      = "eff_wlev10";                 	-- 主法宝达到一定等级时的特效
ItemSmithing_TrumpLink          	  = "root";                   			-- 主法宝达到一定等级时的特效Link点
ItemSmithing_ArmorEffect         	  = "eff_alev10";               		-- 防具达到一定等级时的特效
ItemSmithing_ArmorLink          	  = "root";                   			-- 防具达到一定等级时的特效Link点
ItemSmithing_PlusAttrib_Trump       = { 0,0,0,0,0,0,251,252,253,254,255,256 } -- 道具到达特定锻造等级后每级附加一条特殊属性
ItemSmithing_PlusAttrib_Armor       = { 0,0,0,0,0,0,261,262,263,264,265,266 } -- 道具到达特定锻造等级后每级附加一条特殊属性
ItemSmithing_FailCounter_Clear 			= { 1,1,1,1,1,1,1,1,1,1,1,1 } 				-- 打造成功后额外成功率是否清除掉
ItemSmithing_AddFailCounter 			= { 0,0,0,1,1,1,1,1,1,1,1,1 }   --打造失败增加的失败次数

CanSeeOtherEquipment                = true;
ItemEffectSmithingLevel							= 10;	        -- 道具达到该等级时增加的特效
ItemRiderEffect                     = "eff_ridelev10"   				-- 座骑达到一定等级时的特效
ItemRiderEffectLink                 = "root"      -- 座骑达到一定等级时的特效link点
ItemSmithing_AddFailCounter 			= { 0,1,1,1,1,1,1,1,1,1,1,1 }   --打造失败增加的失败次数

-- 系统初始化
function ItemInit()
    -- 初始化语言 
    LOAD_LAN("MSG_SMITHING_SUCCESS")
    LOAD_LAN("MSG_SMITHING_FAIL")
    LOAD_LAN("msg_script_smithing_fail1")
end

function OnSmithingFail(user, item, origSmithingLevel, smithingLevel, costGold, failedNum)
    ReceiveMsg(user, LAN("MSG_SMITHING_FAIL"), CHANNEL_SYS);
end

-- 锻造成功
function OnSmithingSuccess(user, item, origSmithingLevel, smithingLevel)
    ReceiveMsg(user, LAN("MSG_SMITHING_SUCCESS"), CHANNEL_SYS);
end

function CanItemEnchant(nItemType, nGemItemIndex)
    if nItemType < 1 or nItemType > 8 then
        return 0
    end
    
    return 1
end

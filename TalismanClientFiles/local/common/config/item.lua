include("script/game_script_base.lua")

ItemMaxSmithingLevel                = 12;			        								-- ����������ȼ�
ItemSmithing_FailCounter_Enable     = true;                 					-- �Ƿ�����¼���ߵĴ���ʧ�ܴ���
ItemSmithing_FailCounter_Add        = { 5,5,5,5,5,5,1,1,1,1,1,1,0 }   			-- ����ɹ���(ʧ�ܴ��� * x%)
ItemSmithing_FailCounter_MaxAdd     = 20                    					-- ����ɹ�����󲻳���x%
ItemSmithing_TrumpEffect    	      = "eff_wlev10";                 	-- �������ﵽһ���ȼ�ʱ����Ч
ItemSmithing_TrumpLink          	  = "root";                   			-- �������ﵽһ���ȼ�ʱ����ЧLink��
ItemSmithing_ArmorEffect         	  = "eff_alev10";               		-- ���ߴﵽһ���ȼ�ʱ����Ч
ItemSmithing_ArmorLink          	  = "root";                   			-- ���ߴﵽһ���ȼ�ʱ����ЧLink��
ItemSmithing_PlusAttrib_Trump       = { 0,0,0,0,0,0,251,252,253,254,255,256 } -- ���ߵ����ض�����ȼ���ÿ������һ����������
ItemSmithing_PlusAttrib_Armor       = { 0,0,0,0,0,0,261,262,263,264,265,266 } -- ���ߵ����ض�����ȼ���ÿ������һ����������
ItemSmithing_FailCounter_Clear 			= { 1,1,1,1,1,1,1,1,1,1,1,1 } 				-- ����ɹ������ɹ����Ƿ������
ItemSmithing_AddFailCounter 			= { 0,0,0,1,1,1,1,1,1,1,1,1 }   --����ʧ�����ӵ�ʧ�ܴ���

CanSeeOtherEquipment                = true;
ItemEffectSmithingLevel							= 10;	        -- ���ߴﵽ�õȼ�ʱ���ӵ���Ч
ItemRiderEffect                     = "eff_ridelev10"   				-- ����ﵽһ���ȼ�ʱ����Ч
ItemRiderEffectLink                 = "root"      -- ����ﵽһ���ȼ�ʱ����Чlink��
ItemSmithing_AddFailCounter 			= { 0,1,1,1,1,1,1,1,1,1,1,1 }   --����ʧ�����ӵ�ʧ�ܴ���

-- ϵͳ��ʼ��
function ItemInit()
    -- ��ʼ������ 
    LOAD_LAN("MSG_SMITHING_SUCCESS")
    LOAD_LAN("MSG_SMITHING_FAIL")
    LOAD_LAN("msg_script_smithing_fail1")
end

function OnSmithingFail(user, item, origSmithingLevel, smithingLevel, costGold, failedNum)
    ReceiveMsg(user, LAN("MSG_SMITHING_FAIL"), CHANNEL_SYS);
end

-- ����ɹ�
function OnSmithingSuccess(user, item, origSmithingLevel, smithingLevel)
    ReceiveMsg(user, LAN("MSG_SMITHING_SUCCESS"), CHANNEL_SYS);
end

function CanItemEnchant(nItemType, nGemItemIndex)
    if nItemType < 1 or nItemType > 8 then
        return 0
    end
    
    return 1
end

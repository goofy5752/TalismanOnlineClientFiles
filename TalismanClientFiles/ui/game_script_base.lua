
include("script/lua_class_inc.lua")


-- 聊天频道
CHANNEL_SYS				    = 7     --系统频道


-- 道具颜色
itemColor_White		        = 0
itemColor_Green		        = 1
itemColor_Blue		        = 2
itemColor_Golden	        = 3
itemColor_Golden_Plus       = 4
itemColor_Blue_Plus         = 5
itemColor_Green_Plus        = 6
itemColor_White_Plus        = 7


-- 道具绑定方式
itemBind_NotBind            = 0
itemBind_Binded	            = 1
itemBind_BindWhenPick       = 2
itemBind_BindWhenEquip      = 3


-- 语言表
GolbalLanguage = {}


function LOAD_LAN(str_id)
    if (GolbalLanguage[str_id] == nil) then
    	GolbalLanguage[str_id]	= LoadScriptString(str_id)
    end
end


function LAN(str_id)
	if GolbalLanguage[str_id]==nil then
		return str_id;
	else 
		return GolbalLanguage[str_id];
	end
end


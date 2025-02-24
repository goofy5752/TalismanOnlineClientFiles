


local hidelist = 
{
};

--------------- 需要Hide的控件全路径请添加在上面的列表中，格式如下
--	local hidelist = 
--	{
--		"layWorld.XXXXX",
--		"layWorld.YYYYY",
--	};
--
--
--







--------------- 以下是程序实现

local op = nil;
local function Hide(name)
	op = uiGetglobal(name)
	if op == nil then
		uiError (string.format("widget not find error [%s]", name))
		return false;
	end
	op:Hide();
	return true;
end

for i, v in ipairs(hidelist) do
	print(Hide(v))
end

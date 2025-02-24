
RemoteCommandCallBack = {};

function Receive(message)
	if message == nil then
		uiMessage("message nil error");
		return false;
	end
	-- 解析请求字符串
	local i, _, address, command, cmdType, arguments = string.find(message, "^(.+):(.+)?type=(.-)&(.*)$");
	if i == nil then
		cmdType = "default";
		_, _, address, command, arguments = string.find(message, "^(.+):(.+)?(.*)$");
	end
	if address == nil or command == nil or cmdType == nil or arguments == nil then
		uiMessage("bad command : "..message.."\n format error.");
		return false;
	end
	if RemoteCommandCallBack == nil then
		uiMessage("bad command : "..message.."\n".."ServerCommandCalBack == nil");
		return false;
	end
	if RemoteCommandCallBack[address] == nil then
		uiMessage("bad command : "..message.."\n".."ServerCommandCalBack["..address.."] == nil");
		return false;
	end
	if RemoteCommandCallBack[address][command] == nil then
		uiMessage("bad command : "..message.."\n".."RemoteCommandCallBack["..address.."]["..command.."] == nil");
		return false;
	end
	if RemoteCommandCallBack[address][command][cmdType] == nil or table.getn(RemoteCommandCallBack[address][command][cmdType]) == 0 then
		if RemoteCommandCallBack[address][command][cmdType] == nil then
			return cmdType;
		end
		return 3;
	end
	
	local argument = {};
	local key, value = nil, nil;
	arguments = arguments.."&";
	for key, value in string.gfind(arguments, "(.-)=(.-)&") do
		argument[key] = value;
	end
	for _, _func in ipairs(RemoteCommandCallBack[address][command][cmdType]) do
		_func(argument);
	end
	--RemoteCommandCallBack[address][command][cmdType](argument);
	return true;
end

function BindCallBack (address, command, cmdType, funcCallBack)
	if address == nil or type(address) ~= "string" or address == "" or command == nil or type(command) ~= "string" or command == "" or cmdType == nil or type(cmdType) ~= "string" or cmdType == "" or funcCallBack == nil or type(funcCallBack) ~= "function" then
		uiError("BindCallBack error...");
		return false;
	end
	if RemoteCommandCallBack == nil then
		RemoteCommandCallBack = {};
	end
	if RemoteCommandCallBack[address] == nil then
		RemoteCommandCallBack[address] = {};
	end
	if RemoteCommandCallBack[address][command] == nil then
		RemoteCommandCallBack[address][command] = {};
	end
	if RemoteCommandCallBack[address][command][cmdType] == nil then
		RemoteCommandCallBack[address][command][cmdType] = {};
	end
	local funcCount = table.getn(RemoteCommandCallBack[address][command][cmdType]);
	if funcCount then
		for i, func in ipairs(RemoteCommandCallBack[address][command][cmdType]) do
			if (tostring(func) == tostring(funcCallBack)) then
				return false;
			end
		end
		RemoteCommandCallBack[address][command][cmdType][funcCount+1] = funcCallBack; -- 对请求消息的响应
	end
	return true;
end

--=========================
-- CreateRemoteCommandString 按固定格式创建
--=========================
-- pointshop://getdata:request?ver=12&data="sdfasd"
-- pointshop://getdata?cmd=request&asf=xsd
function CreateRemoteCommandString (_address, _command, _type, _argTable)
	local commandString = _address..":".._command.."?type=".._type;
	if _argTable ~= nil and type(_argTable) == "table" then
		for _k, _v in pairs(_argTable) do
			commandString = commandString.."&".._k.."=".._v;
		end
	end
	return commandString;
end

function RemoteCommand (_address, _command, _type, _argTable)
	uiPost(CreateRemoteCommandString(_address, _command, _type, _argTable));
end








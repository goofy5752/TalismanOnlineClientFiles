--[[
local _class={}
 
function class_share(super)
	local class_type={}
	class_type.ctor=false
	class_type.super=super
	class_type.new=	function(...) 
						local obj={}
						do
							local create
							create = function(c, ...)
								if c.super then
									create(c.super, unpack(arg))
								end
								if c.ctor then
									c.ctor(obj, unpack(arg))
								end
							end
			 
							create(class_type,  unpack(arg))
						end
						setmetatable(obj,{ __index=_class[class_type] })
						return obj
					end
	local vtbl={}
	_class[class_type]=vtbl
 
	setmetatable(class_type,{__newindex=
		function(t,k,v)
			vtbl[k]=v
		end
	})
 
	if super then
		setmetatable(vtbl,{__index=
			function(t,k)
				local ret=_class[super][k]
				vtbl[k]=ret
				return ret
			end
		})
	end
 
	return class_type
end
]]
--create by fantasy - 2010.02.22
--看过lua_class_inc.lua(完整内容如上所示)之后，作了一些修改，但不是为了取代上示class(super)
--下示新的class(super)是严格的C++风格的类
--上示的class(super)用于特殊情况--同一个类new出来的不同实例共享变量(即vtbl中存的值)，而下示的实现也可以进行相应功能的扩展，但现在只是纯C++风格的类
--注意：
--1.C++的类不能直接使用，但lua是通过table来模拟的，所以，lua所谓的类是可以直接使用的，请尽量使用new出来的table，慎重
--2.当你希望设置类变量时，请使用lua类，就像C++里对类static成员变量进行设置一样
function class(super)
	local class_type = {};
	class_type.super = super;
	function class_type:construct(tnew, ...)
		if self.super then self.super:construct(tnew, unpack(arg)) end
	end;
	function class_type:new(...)
		local tnew = {};
		self:construct(tnew, unpack(arg));
		setmetatable(tnew, self);
		self.__index = self;
		return tnew;
	end;
	if super then
		setmetatable(class_type, super);
		super.__index = super;
	end
	return class_type;
end





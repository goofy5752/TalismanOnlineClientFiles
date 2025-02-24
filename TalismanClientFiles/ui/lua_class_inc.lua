
-- lua class implement

local _class={}
 
function class(super)
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
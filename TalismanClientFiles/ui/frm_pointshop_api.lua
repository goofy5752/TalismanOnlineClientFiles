--**************
-- API
--**************

PointShopAPI = {};
function PointShopAPI.SelectItem (indexType, indexItem)
	PointShopXMLTypes.SelectedIndex = PointShopXMLTypes:FindTypeIndex(indexType);
	PointShopXMLItems.SelectedIndex = indexItem;
	PointShopItemType_Update();
	PointShopItemShow_Update();
	PointShopItemType_RollToSelected();
	PointShopItemShow_RollToSelected();
	PointShopItemPromotion_Update();
end

function PointShopAPI.GetDate()
	local ver, _, _ = uiPointShopGetInfo();
	if ver == nil then
		return;
	end
	local _argTable = {
		["version"] = ver,
	};
	RemoteCommand("point_shop", "getdata", "request", _argTable);
end








-- See LICENSE for terms

local type = type
local TranslationTable = TranslationTable
local MsgPopup = ChoGGi.ComFuncs.MsgPopup

--~	local Translate = ChoGGi.ComFuncs.Translate
--~	local RetName = ChoGGi.ComFuncs.RetName

function ChoGGi.MenuFuncs.SetRoverChargeRadius()
	local default_setting = 0
	local item_list = {
		{text = TranslationTable[1000121--[[Default]]] .. ": " .. default_setting, value = default_setting},
		{text = 1, value = 1},
		{text = 2, value = 2},
		{text = 3, value = 3},
		{text = 4, value = 4},
		{text = 5, value = 5},
		{text = 10, value = 10},
		{text = 25, value = 25},
		{text = 50, value = 50},
		{text = 100, value = 100},
		{text = 250, value = 250},
		{text = 500, value = 500},
	}

	local hint = default_setting
	if ChoGGi.UserSettings.RCChargeDist then
		hint = ChoGGi.UserSettings.RCChargeDist
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		choice = choice[1]

		local value = choice.value
		if type(value) == "number" then

			if value == default_setting then
				ChoGGi.UserSettings.RCChargeDist = nil
			else
				ChoGGi.UserSettings.RCChargeDist = value
			end

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				ChoGGi.ComFuncs.SettingState(choice.text),
				TranslationTable[302535920000541--[[RC Set Charging Distance]]]
			)
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = TranslationTable[302535920000880--[[Set Rover Charge Radius]]],
		hint = TranslationTable[302535920000106--[[Current]]] .. ": " .. hint,
		skip_sort = true,
	}
end

function ChoGGi.MenuFuncs.SetRCMoveSpeed()
	local r = const.ResourceScale
	local default_setting = ChoGGi.Consts.SpeedRC
	local UpgradedSetting = ChoGGi.ComFuncs.GetResearchedTechValue("SpeedRC")
	local item_list = {
		{text = TranslationTable[1000121--[[Default]]] .. ": " .. (default_setting / r), value = default_setting, hint = TranslationTable[302535920000889--[[base speed]]]},
		{text = 5, value = 5 * r},
		{text = 10, value = 10 * r},
		{text = 15, value = 15 * r},
		{text = 25, value = 25 * r},
		{text = 50, value = 50 * r},
		{text = 100, value = 100 * r},
		{text = 1000, value = 1000 * r},
		{text = 10000, value = 10000 * r},
	}
	if default_setting ~= UpgradedSetting then
		table.insert(item_list, 2, {text = TranslationTable[302535920000890--[[Upgraded]]] .. ": " .. (UpgradedSetting / r), value = UpgradedSetting, hint = TranslationTable[302535920000891--[[apply tech unlocks]]]})
	end

	local hint = UpgradedSetting
	if ChoGGi.UserSettings.SpeedRC then
		hint = ChoGGi.UserSettings.SpeedRC
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		choice = choice[1]

		local value = choice.value
		if type(value) == "number" then
			ChoGGi.ComFuncs.SetSavedConstSetting("SpeedRC", value)
			local objs = UICity.labels.Rover or ""
			for i = 1, #objs do
				objs[i]:SetBase("move_speed", value)
			end

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				ChoGGi.ComFuncs.SettingState(choice.text),
				TranslationTable[302535920000543--[[RC Move Speed]]]
			)
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = TranslationTable[302535920000543--[[RC Move Speed]]],
		hint = TranslationTable[302535920000106--[[Current]]] .. ": " .. hint .. "\n\n"
			.. TranslationTable[302535920001085--[[Setting speed to a non integer (e.g 2.5) crashes the game!]]],
		skip_sort = true,
	}
end

function ChoGGi.MenuFuncs.RCTransportInstantTransfer_Toggle()
	ChoGGi.ComFuncs.SetConstsG("RCRoverTransferResourceWorkTime", ChoGGi.ComFuncs.NumRetBool(Consts.RCRoverTransferResourceWorkTime, 0, ChoGGi.Consts.RCRoverTransferResourceWorkTime))
	ChoGGi.ComFuncs.SetConstsG("RCTransportGatherResourceWorkTime", ChoGGi.ComFuncs.NumRetBool(Consts.RCTransportGatherResourceWorkTime, 0, ChoGGi.ComFuncs.GetResearchedTechValue("RCTransportGatherResourceWorkTime")))
	ChoGGi.ComFuncs.SetSavedConstSetting("RCRoverTransferResourceWorkTime")
	ChoGGi.ComFuncs.SetSavedConstSetting("RCTransportGatherResourceWorkTime")

	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.RCRoverTransferResourceWorkTime),
		TranslationTable[302535920000549--[[RC Instant Resource Transfer]]]
	)
end

function ChoGGi.MenuFuncs.SetRCTransportStorageCapacity()
	local r = const.ResourceScale
	local default_setting = ChoGGi.ComFuncs.GetResearchedTechValue("RCTransportStorageCapacity") / r
	local item_list = {
		{text = TranslationTable[1000121--[[Default]]] .. ": " .. default_setting, value = default_setting},
		{text = 50, value = 50},
		{text = 75, value = 75},
		{text = 100, value = 100},
		{text = 250, value = 250},
		{text = 500, value = 500},
		{text = 1000, value = 1000},
		{text = 2000, value = 2000, hint = TranslationTable[302535920000925--[[somewhere above 2000 will delete the save (when it's full)]]]},
	}

	local hint = default_setting
	if ChoGGi.UserSettings.RCTransportStorageCapacity then
		hint = ChoGGi.UserSettings.RCTransportStorageCapacity / r
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		choice = choice[1]

		local value = choice.value
		if type(value) == "number" then
			local default = value == default_setting

			local value = value * r
			-- somewhere above 2000 screws the save
			if value > 2000000 then
				value = 2000000
			end
			-- for any rc constructors
			local rc_con_value = ChoGGi.ComFuncs.GetResearchedTechValue("RCTransportStorageCapacity", "RCConstructor")

			-- loop through and set all
			if UIColony then
				local label = UIColony:GetCityLabels("RCTransportAndChildren")
				for i = 1, #label do
					local rc = label[i]
					if default and rc:IsKindOf("RCConstructor") then
						rc.max_shared_storage = rc_con_value
					else
						rc.max_shared_storage = value
					end
				end
			end

			if default then
				ChoGGi.UserSettings.RCTransportStorageCapacity = nil
			else
				ChoGGi.ComFuncs.SetSavedConstSetting("RCTransportStorageCapacity", value)
			end

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				ChoGGi.ComFuncs.SettingState(choice.text),
				TranslationTable[302535920000551--[[RC Storage Capacity]]]
			)
		end
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = TranslationTable[302535920000927--[[Set RC Transport Capacity]]],
		hint = TranslationTable[302535920000914--[[Current capacity]]] .. ": " .. hint,
		skip_sort = true,
	}
end


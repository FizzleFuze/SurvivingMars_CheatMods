-- See LICENSE for terms

local MsgPopup = ChoGGi.ComFuncs.MsgPopup
local TranslationTable = TranslationTable

function ChoGGi.MenuFuncs.SetConstMenu(action)
	local ConstsUS = ChoGGi.UserSettings.Consts
	local ConstsC = ChoGGi.Consts

	local setting_scale = action.setting_scale
--~ 	printC(setting_scale, "setting_scale")
	-- see about using scale to setup the numbers

	local setting_id = action.setting_id
	local setting_name = action.setting_name
	local setting_desc = action.setting_desc
	local default_setting = action.setting_value

	local item_list = {
		{text = TranslationTable[1000121--[[Default]]] .. ": " .. default_setting, value = default_setting},
		{text = 15, value = 15},
		{text = 20, value = 20},
		{text = 25, value = 25},
		{text = 50, value = 50},
		{text = 75, value = 75},
		{text = 100, value = 100},
		{text = 250, value = 250},
		{text = 500, value = 500},
		{text = 1000, value = 1000},
		{text = 10000, value = 10000},
		{text = 25000, value = 25000},
	}
	local previous = ChoGGi.UserSettings[setting_id]
	if previous then
		table.insert(item_list, 2, {
			text = T(1000231--[[Previous]]) .. ": " .. previous,
			value = previous,
			hint = TranslationTable[302535920000213--[[Previously set in an ECM menu (meaning it's active and the setting here will override this value).]]]
		})
	end

	local hint = default_setting
	if ConstsUS[setting_id] then
		hint = ConstsUS[setting_id]
	end

	local function CallBackFunc(choice)
		if choice.nothing_selected then
			return
		end
		choice = choice[1]
		local value = choice.value

		if type(value) == "number" then
			ChoGGi.ComFuncs.SetConstsG(setting_id, value)
			-- If setting is the same as the default then remove it
			if ConstsC[setting_id] == value then
				ConstsUS[setting_id] = nil
			else
				ConstsUS[setting_id] = value
			end

			ChoGGi.SettingFuncs.WriteSettings()
			MsgPopup(
				ChoGGi.ComFuncs.SettingState(choice.text),
				setting_name
			)
		end
	end

	hint = TranslationTable[302535920000106--[[Current]]] .. ": " .. hint .. "\n\n" .. setting_desc
	if setting_scale then
		hint = hint .. "\n" .. Translate(1000081--[[Scale]]) .. ": "
			.. Presets.ConstDef.Scale[setting_scale].value .. "("
			.. TranslationTable[302535920000182--[[The scale this amount will be multipled by when used.]]] .. ")"
	end

	ChoGGi.ComFuncs.OpenInListChoice{
		callback = CallBackFunc,
		items = item_list,
		title = setting_name,
		hint = hint,
		skip_sort = true,
	}
end

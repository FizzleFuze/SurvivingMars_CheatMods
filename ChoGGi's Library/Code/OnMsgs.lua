-- See LICENSE for terms

local S = ChoGGi.Strings

local OnMsg = OnMsg

-- we don't add shortcuts and ain't supposed to drink no booze
function OnMsg.ShortcutsReloaded()
	ChoGGi.ComFuncs.Rebuildshortcuts()
end

-- so we at least have keys when it happens (what is "it"?)
function OnMsg.ReloadLua()
	if type(XShortcutsTarget.UpdateToolbar) == "function" then
		ChoGGi.ComFuncs.Rebuildshortcuts()
	end
end

-- use this message to perform post-built actions on the final classes
function OnMsg.ClassesBuilt()
	-- add build cat for my items
	local bc = BuildCategories
	if not table.find(bc,"id","ChoGGi") then
		bc[#bc+1] = {
			id = "ChoGGi",
			name = S[302535920001400--[[ChoGGi--]]],
			image = ChoGGi.library_path .. "UI/bmc_incal_resources.png",
			highlight = ChoGGi.library_path .. "UI/bmc_incal_resources_shine.png",
		}
	end
end

-- needed for UICity and some others that aren't created till around then
function OnMsg.LoadGame()
	ChoGGi.ComFuncs.RetName_Update()
	ChoGGi.ComFuncs.UpdateStringsList()
end
function OnMsg.CityStart()
	ChoGGi.ComFuncs.RetName_Update()
	ChoGGi.ComFuncs.UpdateStringsList()
end
-- now i should probably go around and change all my localed strings...
function OnMsg.TranslationChanged()
	ChoGGi.ComFuncs.UpdateStringsList()
	ChoGGi.ComFuncs.UpdateDataTables()
	if UICity then
		ChoGGi.ComFuncs.UpdateDataTablesCargo()
	end
end

ChoGGi.Temp.UIScale = (LocalStorage.Options.UIScale + 0.0) / 100

-- This updates my dlgs when the ui scale is changed
local point = point
local pairs = pairs
local GetSafeAreaBox = GetSafeAreaBox
-- I guess I need a replacefuncs for lib as well...
local orig_SetUserUIScale = SetUserUIScale
function SetUserUIScale(val,...)
	orig_SetUserUIScale(val,...)

	local UIScale = (val + 0.0) / 100
	-- update existing dialogs
	local g_ChoGGiDlgs = g_ChoGGiDlgs
	for dlg in pairs(g_ChoGGiDlgs) do
		dlg.dialog_width_scaled = dlg.dialog_width * UIScale
		dlg.dialog_height_scaled = dlg.dialog_height * UIScale
		dlg.header_scaled = dlg.header * UIScale

		-- make sure the size i use is below the res w/h
		local _,_,x,y = GetSafeAreaBox():xyxy()
		if dlg.dialog_width_scaled > x then
			dlg.dialog_width_scaled = x - 50
		end
		if dlg.dialog_height_scaled > y then
			dlg.dialog_height_scaled = y - 50
		end

		dlg:SetSize(dlg.dialog_width_scaled, dlg.dialog_height_scaled)
	end
	-- might as well update this now (used to be in an OnMsg)
	ChoGGi.Temp.UIScale = UIScale
end

-- See LICENSE for terms

-- add keybind for photo mode
local Actions = ChoGGi.Temp.Actions
Actions[#Actions+1] = {ActionName = T(302535920011968, "Photo Mode Toggle"),
	ActionId = "ChoGGi.RebindHardcodedKeys.PhotoMode",
	ActionShortcut = "Shift-F12",
	replace_matching_id = true,
	OnAction = function()
		if g_PhotoMode then
			PhotoModeEnd()
			Dialogs.PhotoMode:Close()
			if GetTimeFactor() == 0 then
				local dlg = (GetMarsPauseDlg())
				if dlg then
					dlg:SetParent(terminal.desktop)
				end
			end

		else
			CloseIngameMainMenu()
			StartPhotoMode()
		end
	end,
	ActionBindable = true,
}
-- add keybind for toggle
Actions[#Actions+1] = {ActionName = T(302535920011969, "Salvage Cursor"),
	ActionId = "ChoGGi.RebindHardcodedKeys.SalvageCursor",
	ActionShortcut = "Ctrl-Delete",
	replace_matching_id = true,
	OnAction = function()
		local igi = GetInGameInterface()
		if igi then
			if igi.mode == "selection" then
				g_LastBuildItem = "Salvage"
				igi:SetMode("demolish")
				PlayFX("DemolishButton", "start")
			else
				igi:SetMode("selection")
			end
		end
	end,
	ActionBindable = true,
}
Actions[#Actions+1] = {ActionName = T(302535920011698, "Cycle Visual Variant Backward"),
	ActionId = "ChoGGi.RebindHardcodedKeys.CycleVisualVariantBackward",
	ActionShortcut = "[",
	replace_matching_id = true,
	ActionBindable = true,
}
Actions[#Actions+1] = {ActionName = T(302535920011699, "Cycle Visual Variant Forward"),
	ActionId = "ChoGGi.RebindHardcodedKeys.CycleVisualVariantForward",
	ActionShortcut = "]",
	replace_matching_id = true,
	ActionBindable = true,
}
Actions[#Actions+1] = {ActionName = T(302535920011700, "Construction Cancel"),
	ActionId = "ChoGGi.RebindHardcodedKeys.ConstructionCancel",
	ActionShortcut = "Escape",
	replace_matching_id = true,
	ActionBindable = true,
}

local GetShortcuts = GetShortcuts
local VKStrNamesInverse = VKStrNamesInverse

local function RetShortcuts(id)
	local keys = GetShortcuts(id)

	return keys[1] and VKStrNamesInverse[keys[1]],
		keys[2] and VKStrNamesInverse[keys[2]],
		keys[31] and VKStrNamesInverse[keys[3]]
end

local orig_ConstructionModeDialog_OnKbdKeyDown = ConstructionModeDialog.OnKbdKeyDown
function ConstructionModeDialog:OnKbdKeyDown(virtual_key, ...)
	-- check if input is key set in binds
	local back1, back2, back3 = RetShortcuts("ChoGGi.RebindHardcodedKeys.CycleVisualVariantBackward")
	local for1, for2, for3 = RetShortcuts("ChoGGi.RebindHardcodedKeys.CycleVisualVariantForward")
	local cancel1, cancel2, cancel3 = RetShortcuts("ChoGGi.RebindHardcodedKeys.ConstructionCancel")

	-- fire off orig func with default key sent
	if virtual_key == cancel1 or virtual_key == cancel2 or virtual_key == cancel3 then
		return orig_ConstructionModeDialog_OnKbdKeyDown(self, const.vkEsc, ...)
	elseif virtual_key == for1 or virtual_key == for2 or virtual_key == for3 then
		return orig_ConstructionModeDialog_OnKbdKeyDown(self, const.vkClosesq, ...)
	elseif virtual_key == back1 or virtual_key == back2 or virtual_key == back3 then
		return orig_ConstructionModeDialog_OnKbdKeyDown(self, const.vkOpensq, ...)
	end

	return "continue"
end

Actions[#Actions+1] = {ActionName = T(302535920011974, "Place Multiple Buildings"),
	ActionId = "ChoGGi.RebindHardcodedKeys.PlaceMultipleBuildings",
	ActionShortcut = "Shift",
	replace_matching_id = true,
	ActionBindable = true,
}

local IsKeyPressed = terminal.IsKeyPressed

local orig_IsPlacingMultipleConstructions = IsPlacingMultipleConstructions
function IsPlacingMultipleConstructions(...)
	local shift1, shift2, shift3 = RetShortcuts("ChoGGi.RebindHardcodedKeys.PlaceMultipleBuildings")
	if IsKeyPressed(shift1) or IsKeyPressed(shift2) or IsKeyPressed(shift3) then
    return true
	end

	return orig_IsPlacingMultipleConstructions(...)
end

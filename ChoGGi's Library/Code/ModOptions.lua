-- See LICENSE for terms

local table = table
local type = type
local HasModsWithOptions = HasModsWithOptions
local TranslationTable = TranslationTable

local function UpdateProp(xtemplate)
	local idx = table.find(xtemplate, "MaxWidth", 400)
	if idx then
		xtemplate[idx].MaxWidth = 1000000
	end
end

local function AdjustNumber(self, direction)
	local slider = self.parent.idSlider
	if direction then
		slider:ScrollTo(slider.Scroll + slider.StepSize)
	else
		slider:ScrollTo(slider.Scroll - slider.StepSize)
	end
end

local function AddSliderButtons(xtemplate)
	local idx = table.find(xtemplate, "Id", "idSlider")
	if idx then
		local template_left = PlaceObj("XTemplateWindow", {
				"Id", "idButtonLower_ChoGGi",
				"__class", "XTextButton",
				"Text", T(0000, "[-]"),
				"FXMouseIn", "ActionButtonHover",
				"FXPress", "ActionButtonClick",
				"FXPressDisabled", "UIDisabledButtonPressed",
				"HAlign", "center",
				"RolloverZoom", 1100,
				"Background", 0,
				"FocusedBackground", 0,
				"RolloverBackground", 0,
				"PressedBackground", 0,
				"TextStyle", "MessageTitle",
				"MouseCursor", "UI/Cursors/Rollover.tga",
				"OnPress", function(self)
					AdjustNumber(self, false)
				end,
				"RolloverTemplate", "Rollover",
			})
		local template_right = PlaceObj("XTemplateWindow", {
				"__template", "PropName",
				"__class", "XTextButton",
				"Id", "idButtonHigher_ChoGGi",
				"Text", T(0000, "[+]"),
				"FXMouseIn", "ActionButtonHover",
				"FXPress", "ActionButtonClick",
				"FXPressDisabled", "UIDisabledButtonPressed",
				"HAlign", "center",
				"RolloverZoom", 1100,
				"Background", 0,
				"FocusedBackground", 0,
				"RolloverBackground", 0,
				"PressedBackground", 0,
				"TextStyle", "MessageTitle",
				"MouseCursor", "UI/Cursors/Rollover.tga",
				"OnPress", function(self)
					AdjustNumber(self, true)
				end,
				"RolloverTemplate", "Rollover",
			})
		table.insert(xtemplate, idx, template_left)
		table.insert(xtemplate, idx+2, template_right)
	end
end

local function ChangeBoolColour(xtemplate, id, colour)
	local idx = table.find(xtemplate, "Id", id)
	if not idx then
		return
	end

	local template = xtemplate[idx]
	template.Text = table.concat(T("<" .. colour .. ">") .. template.Text .. "</color>")
end

function OnMsg.ClassesPostprocess()

	-- ignore persist errors
	-- this is in pp so it overrides ECM overriding the func
	local ChoOrig_ReportPersistErrors = ReportPersistErrors
	function ReportPersistErrors(...)
		-- be useful for restarting threads, see if devs will add it
		Msg("PostSaveGame")

		if CurrentModOptions:GetProperty("IgnorePersistErrors") then
			return 0, 0
		end

		return ChoOrig_ReportPersistErrors(...)
	end

	-- Mod Options Expanded
	local xtemplate = XTemplates.PropBool[1]
	if not xtemplate.ChoGGi_ModOptionsExpanded then
		xtemplate.ChoGGi_ModOptionsExpanded = true

		-- Change On/Off text to green/red/duct tape
		ChangeBoolColour(xtemplate, "idOn", "green")
		ChangeBoolColour(xtemplate, "idOff", "red")

		UpdateProp(xtemplate)
		UpdateProp(XTemplates.PropChoiceOptions[1])

		xtemplate = XTemplates.PropNumber[1]
		UpdateProp(xtemplate)
		-- add buttons to number
		AddSliderButtons(xtemplate)

--~ 		-- hmm
--~ 		UpdateProp(XTemplates.PropKeybinding[1])
	end

	-- Mod Options Button
	xtemplate = XTemplates.XIGMenu[1]
	if not xtemplate.ChoGGi_ModOptionsButton then
		xtemplate.ChoGGi_ModOptionsButton = true

		-- XTemplateWindow[3] ("Margins" = (60, 40)-(0, 0) *(HGE.Box)) >
		xtemplate = xtemplate[3]
		for i = 1, #xtemplate do
			if xtemplate[i].Id == "idList" then
				xtemplate = xtemplate[i]
				break
			end
		end

		if xtemplate.Id == "idList" then
			table.insert(xtemplate, 5, PlaceObj("XTemplateAction", {
				"ActionId", "idModOptions",
				"ActionName", TranslationTable[1000867--[[Mod Options]]],
				"ActionToolbar", "mainmenu",
				"__condition", function()
					if CurrentModOptions.GetProperty then
						return CurrentModOptions:GetProperty("ModOptionsButton") and HasModsWithOptions()
					end
					return HasModsWithOptions()
				end,
				"OnAction", function(_, host)
					-- change to options dialog
					host:SetMode("Options")

					-- then change to mod options
					-- [2]XContentTemplate.idOverlayDlg.idList
					local list = host[2].idOverlayDlg.idList
					for i = 1, #list do
						local context = list[i].context
						if type(context) == "table" and context.id == "ModOptions" then
							SetDialogMode(list[i], "mod_choice", context)
							break
						end
					end
				end,
			}))
		end

	end

	-- Add check for mod options with: "Header", true, and remove On/Off text from it
	-- If it ignores fake values then use "name" and check for prefix Header_
end

-- sort list of mods for mod options

local CmpLower = CmpLower
local function sort_mods(a, b)
	return CmpLower(a.title, b.title)
end

local ChoOrig_XTemplateForEach_map = XTemplateForEach.map
function XTemplateForEach.map(parent, context, array, i)
	if array == ModsLoaded then
		array = table.icopy(array)
		table.sort(array, sort_mods)
	end
	return ChoOrig_XTemplateForEach_map(parent, context, array, i)
end

-- See LICENSE for terms

-- local whatever globals we call
local ShowHexRanges = ShowHexRanges
local HideHexRanges = HideHexRanges
local IsKindOf = IsKindOf
local pairs = pairs
local SuspendPassEdits = SuspendPassEdits
local ResumePassEdits = ResumePassEdits
local RGBtoColour = ChoGGi.ComFuncs.RGBtoColour

local mod_EnableGrid
local mod_DistFromCursor
local mod_GridOpacity
local mod_SelectDome
local mod_SelectOutside
local mod_GridScale
local mod_HexColour

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	local options = CurrentModOptions
	mod_EnableGrid = options:GetProperty("Option1")
	mod_DistFromCursor = options:GetProperty("DistFromCursor") * 1000
	mod_GridOpacity = options:GetProperty("GridOpacity")
	mod_SelectDome = options:GetProperty("SelectDome")
	mod_SelectOutside = options:GetProperty("SelectOutside")
	mod_GridScale = options:GetProperty("GridScale")

	mod_HexColour = RGBtoColour(options:GetProperty("HexColour"))
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local grids_visible

local function ShowGrids()
	SuspendPassEdits("ChoGGi.CursorBuilding.GameInit.Construction Show Dome Grid")
	ShowHexRanges(UICity, "Dome")

	-- edit grids
	local g_HexRanges = g_HexRanges
	for range, obj in pairs(g_HexRanges) do
		if IsKindOf(obj, "Dome") then
			if IsKindOf(range, "RangeHexMultiSelectRadius") then
				range:SetOpacity(mod_GridOpacity)
				range.ChoGGi_visible = true
			end

			for i = 1, #range.decals do
				local decal = range.decals[i]
				decal:SetColorModifier(mod_HexColour)
				decal:SetScale(mod_GridScale)
			end

		end
	end

	ResumePassEdits("ChoGGi.CursorBuilding.GameInit.Construction Show Dome Grid")
	grids_visible = true
end
local function HideGrids()
	SuspendPassEdits("ChoGGi.CursorBuilding.Done.Construction Show Dome Grid")
	HideHexRanges(UICity, "Dome")
	ResumePassEdits("ChoGGi.CursorBuilding.Done.Construction Show Dome Grid")
	grids_visible = false
end

local ChoOrig_CursorBuilding_GameInit = CursorBuilding.GameInit
function CursorBuilding:GameInit(...)
	ChoOrig_CursorBuilding_GameInit(self, ...)
	if mod_EnableGrid and self.template:IsKindOf("Dome") then
		ShowGrids()
	end
end

local ChoOrig_CursorBuilding_UpdateShapeHexes = CursorBuilding.UpdateShapeHexes
function CursorBuilding:UpdateShapeHexes(...)
	if not (mod_EnableGrid or self.template:IsKindOf("Dome")) then
		return ChoOrig_CursorBuilding_UpdateShapeHexes(self, ...)
	end

	local range_limit = mod_DistFromCursor > 0 and mod_DistFromCursor
	local cursor_pos = self:GetPos()

	SuspendPassEdits("ChoGGi.CursorBuilding.UpdateShapeHexes.Construction Show Dome Grid")
	local g_HexRanges = g_HexRanges
	for range, obj in pairs(g_HexRanges) do
		if range.SetVisible and IsKindOf(obj, "Dome") then
			if range_limit and cursor_pos:Dist2D(obj:GetPos()) > range_limit then
				-- GetVisible() always returns true (for ranges?)
				if range.ChoGGi_visible then
					range:SetVisible(false)
					range.ChoGGi_visible = false
				end
			else
				if not range.ChoGGi_visible then
					range:SetVisible(true)
					range.ChoGGi_visible = true
				end
			end
		end
	end
	ResumePassEdits("ChoGGi.CursorBuilding.UpdateShapeHexes.Construction Show Dome Grid")

	return ChoOrig_CursorBuilding_UpdateShapeHexes(self, ...)
end

local ChoOrig_CursorBuilding_Done = CursorBuilding.Done
function CursorBuilding.Done(...)
	HideGrids()
	return ChoOrig_CursorBuilding_Done(...)
end

local function AddRanges()
	SuspendPassEdits("ChoGGi.SelectionAdded.Construction Show Dome Grid")
	ShowHexRanges(UICity, "Dome")
	ResumePassEdits("ChoGGi.SelectionAdded.Construction Show Dome Grid")
end

function OnMsg.SelectionAdded(obj)
	if not obj then
		return
	end

	if mod_SelectDome and obj:IsKindOf("Dome")
		or mod_SelectOutside and obj:IsKindOf("DomeOutskirtBld") and not obj:IsKindOf("StorageDepot")
	then
		-- needs a slight delay, or last selected dome will lose it's selection radius
		CreateRealTimeThread(AddRanges)
	end
end

function OnMsg.SelectionRemoved()
	SuspendPassEdits("ChoGGi.SelectionRemoved.Construction Show Dome Grid")
	HideHexRanges(UICity, "Dome")
	ResumePassEdits("ChoGGi.SelectionRemoved.Construction Show Dome Grid")
end

-- add keybind for toggle
local Actions = ChoGGi.Temp.Actions
Actions[#Actions+1] = {ActionName = T(302535920011584, "Construction Show Dome Range"),
	ActionId = "ChoGGi.ConstructionShowDomeRange.ToggleGrid",
	OnAction = function()
		if grids_visible then
			HideGrids()
		else
			ShowGrids()
		end
	end,
	ActionShortcut = "Numpad 4",
	replace_matching_id = true,
	ActionBindable = true,
}

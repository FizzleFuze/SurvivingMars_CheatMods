-- See LICENSE for terms

-- DLC installed
if not g_AvailableDlc.picard then
	print(CurrentModDef.title, ": Below & Beyond DLC not installed!")
	return
end

-- some stuff checks one some other...
local SetConstsG = ChoGGi.ComFuncs.SetConstsG

local mod_EnableMod
local mod_MaxAsteroids
-- the funcs below need a +2 count (surface/underground)
local mod_MaxAsteroidsPlusTwo

-- populated below
local OnContextUpdate_ChoOrig
local function OnContextUpdate_ChoFake(self, context, ...)
	if not mod_EnableMod or not g_AccessibleDlc.picard then
		return OnContextUpdate_ChoOrig(self, context, ...)
	end

	local map_entries = context.idMapSwitch:GetEntries()
	for i = 1, mod_MaxAsteroidsPlusTwo do
		local button = self[i]
		local entry = map_entries[i]
		if entry then
			button:OnContextUpdate(entry)
			button:SetVisible(true)
		else
			button:SetVisible(false)
		end
	end

--~ 	return OnContextUpdate_ChoOrig(self, context, ...)
end

local array_ChoOrig
local function array_ChoFake(...)
	if not mod_EnableMod or not g_AccessibleDlc.picard then
		return array_ChoOrig(...)
	end

	return nil, 1, mod_MaxAsteroidsPlusTwo
end
--
function OnMsg.ClassesPostprocess()
	local template = XTemplates.MapSwitch[1][4--[[XTemplateWindow]]][1--[[idContent]]]

	if template.ChoGGi_MoreAsteroids_updated then
		return
	end

	OnContextUpdate_ChoOrig = template.OnContextUpdate
	template.OnContextUpdate = OnContextUpdate_ChoFake

	array_ChoOrig = template[2--[[XTemplateForEach]]].array
	template[2].array = array_ChoFake

	template.ChoGGi_MoreAsteroids_updated = true
end
--

local function StartupCode()
	if not mod_EnableMod then
		return
	end

	SetConstsG("MaxAsteroids", mod_MaxAsteroids)
end
OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_MaxAsteroids = CurrentModOptions:GetProperty("MaxAsteroids")

	mod_MaxAsteroidsPlusTwo = mod_MaxAsteroids + 2

	-- Make sure we're in-game UIColony
	if not UICity then
		return
	end

	StartupCode()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

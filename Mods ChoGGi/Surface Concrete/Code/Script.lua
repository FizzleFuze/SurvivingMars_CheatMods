-- See LICENSE for terms

local GetMapID = GetMapID
local AsyncRand = AsyncRand
local GetRandomPassableAround = GetRandomPassableAround

local mod_EnableMod
local mod_MaxDeposits

GlobalVar("g_ChoGGi_SurfaceConcrete_Spawned", false)

local function StartupCode()
	if not mod_EnableMod or g_ChoGGi_SurfaceConcrete_Spawned then
		return
	end

	local min, max = 0, 21600
	local Cities = Cities
	local SurfaceDepositConcrete = SurfaceDepositConcrete

	local objs = UIColony:GetCityLabels("TerrainDepositMarker")
	for i = 1, #objs do
		local obj = objs[i]

		for j = 1, mod_MaxDeposits do
			local pos = GetRandomPassableAround(
				obj,
				8000, 500, obj.city or Cities[GetMapID(obj)]
			)

			local deposit = SurfaceDepositConcrete:new()
			deposit:SetPos(pos)
			deposit:SetAngle(AsyncRand(max - min + 1) + min)
		end

	end


	g_ChoGGi_SurfaceConcrete_Spawned = true
end
OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_MaxDeposits = CurrentModOptions:GetProperty("MaxDeposits")

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

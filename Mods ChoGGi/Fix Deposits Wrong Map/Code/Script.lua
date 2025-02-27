-- See LICENSE for terms

if not g_AvailableDlc.picard then
	print(CurrentModDef.title, ": Below & Beyond DLC not installed!")
	return
end

local RetObjMapId = ChoGGi.ComFuncs.RetObjMapId

local mod_EnableMod

-- Skip the indexed sector tables since we're using pairs()
local sector_nums = {
 [1] = true,
 [2] = true,
 [3] = true,
 [4] = true,
 [5] = true,
 [6] = true,
 [7] = true,
 [8] = true,
 [9] = true,
 [10] = true,
}

local function FixDeposit(deposit, map_id)
	-- No point in moving something already there
	if deposit and RetObjMapId(deposit) ~= map_id then
		-- Move deposit to surface map (preserves position)
		deposit:TransferToMap(map_id)
		-- z is still set to z from underground (got me)
		local pos = deposit:GetPos()
		-- Used surface.terrain:GetHeight instead of just :SetTerrainZ() since that seems to be the active terrain
		deposit:SetPos(pos:SetZ(GameMaps[map_id].terrain:GetHeight(pos)))
	end
end

local function UpdateDeposits(map_id)
	local sectors = Cities[map_id].MapSectors
	for sector in pairs(sectors) do
		if not sector_nums[sector] and #sector.markers.surface > 0 then
			local deposits = sector.markers.surface
			for i = 1, #deposits do
				FixDeposit(deposits[i].deposit, map_id)
			end
		end
	end
end

local function UpdateMaps()
	if not mod_EnableMod then
		return
	end

	UpdateDeposits(MainMapID)
	UpdateDeposits(UIColony.underground_map_id)
end
SavegameFixups.ChoGGi_FixDepositsStuckUnderground = UpdateMaps

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")

	-- make sure we're in-game UIColony
	if not UICity then
		return
	end

	UpdateMaps()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

-- someone didn't check where it spawns (active realm)
-- https://github.com/surviving-mars/SurvivingMars/blob/master/Lua/Buildings/TerrainDeposit.lua#L224
local ChoOrig_TerrainDepositMarker_SpawnDeposit = TerrainDepositMarker.SpawnDeposit
function TerrainDepositMarker:SpawnDeposit(...)
	if not mod_EnableMod then
		return ChoOrig_TerrainDepositMarker_SpawnDeposit(self, ...)
	end

	local deposit = ChoOrig_TerrainDepositMarker_SpawnDeposit(self, ...)
	FixDeposit(deposit, self:GetMapID())
	return deposit
end

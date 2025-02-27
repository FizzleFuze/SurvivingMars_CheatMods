-- See LICENSE for terms

-- set below
local skins, palettes

-- override skin funcs
local function GetSkins(self)
	return skins, palettes
end

-- replace the default getskins function with ours
RocketBase.GetSkins = GetSkins
SupplyPod.GetSkins = GetSkins
-- override needed for Coloured Depots mod
RocketBase.ChangeSkin = Building.ChangeSkin
SupplyPod.ChangeSkin = Building.ChangeSkin

-- start with base game skins
skins = {
	"Rocket",
	"Rocket_Trailblazer",
	"CombatRover",
	"SupplyPod",
}

palettes = {
	RocketBase.rocket_palette,
	{},
	AttackRover.palette,
	SupplyPod.rocket_palette,
}

-- unlock Trailblazer skins
local tb = g_TrailblazerSkins
tb.Drone = "Drone_Trailblazer"
tb.RCRover = "Rover_Trailblazer"
tb.RCTransport = "RoverTransport_Trailblazer"
tb.ExplorerRover = "RoverExplorer_Trailblazer"
tb.SupplyRocket = "Rocket_Trailblazer"

-- add space race entities
if g_AvailableDlc.gagarin then
	skins[#skins+1] = "DropPod"
	skins[#skins+1] = "ArcPod"
	skins[#skins+1] = "ZeusRocket"
	skins[#skins+1] = "SpaceYDragonRocket"
	palettes[#palettes+1] = DropPod.rocket_palette
	palettes[#palettes+1] = ArkPod.rocket_palette
	palettes[#palettes+1] = ZeusRocket.rocket_palette
	palettes[#palettes+1] = DragonRocket.rocket_palette
	ArkPod.GetSkins = GetSkins
	DropPod.GetSkins = GetSkins
	ZeusRocket.GetSkins = GetSkins
	DragonRocket.GetSkins = GetSkins
end

-- landers
if g_AvailableDlc.picard then
	skins[#skins+1] = "LanderRocket"
	skins[#skins+1] = "LanderRocket_Asteroid"
	palettes[#palettes+1] = LanderRocketBase.rocket_palette
	palettes[#palettes+1] = LanderRocketBase.rocket_palette
	LanderRocketBase.GetSkins = GetSkins
	LanderRocketBase.GetSkins = GetSkins
end

-- Silva - Orion Heavy Rocket
function OnMsg.ModsReloaded()
	-- check if the mod is loaded and if it was already added to the list
	if not table.find(skins, "RDM_OrionRocket")
		and table.find(ModsLoaded, "id", "Ucv4buQ")
	then
		-- If not then add to the list
		skins[#skins+1] = "RDM_OrionRocket"
		palettes[#palettes+1] = RDM_OrionRocket.rocket_palette
		RDM_OrionRocket.GetSkins = GetSkins
--~ 		RDM_OrionRocket.GetCurrentSkin = GetCurrentSkin
	end
end

-- See LICENSE for terms

local mod_MinimumSurfaceDeposits
local mod_MinimumSubsurfaceDeposits

-- fired when settings are changed/init
local function ModOptions()
	mod_MinimumSurfaceDeposits = CurrentModOptions:GetProperty("MinimumSurfaceDeposits")
	mod_MinimumSubsurfaceDeposits = CurrentModOptions:GetProperty("MinimumSubsurfaceDeposits")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when Mod Options>Apply button is clicked
function OnMsg.ApplyModOptions(id)
	-- I'm sure it wouldn't be that hard to only call this msg for the mod being applied, but...
	if id == CurrentModId then
		ModOptions()
	end
end

local table = table

local AsyncRand = AsyncRand
local CreateRand = CreateRand

-- only needed for mod_MinimumDeposits == 0; we ignore this if mod option > 0, but this is (probably slightly) faster then orig func so no need to bother checking
local orig_City_CreateMapRand = City.CreateMapRand
function City:CreateMapRand(which, ...)
	-- we don't want to mess with CreateResearchRand
	if which == "Exploration" then
		return CreateRand(true, AsyncRand(), ...)
	end
	return orig_City_CreateMapRand(self, which, ...)
end

local orig_InitialReveal = InitialReveal
function InitialReveal(eligible, ...)
	if mod_MinimumSurfaceDeposits == 0 and mod_MinimumSubsurfaceDeposits == 0 then
		return orig_InitialReveal(eligible, ...)
	end

	-- get any sectors with min amount of deposits
	local found_mins = table.ifilter(eligible, function(_, deposit)
    return #deposit.markers.surface > mod_MinimumSurfaceDeposits and #deposit.markers.subsurface > mod_MinimumSubsurfaceDeposits
  end)

	-- pick a random sector from list of found ones
	if #found_mins > 0 then
		return {table.rand(found_mins)}
	end

	-- probably too high of a min
	table.sort(eligible, function(a, b)
		return #a.markers.surface > #b.markers.surface
	end)
	-- sub after as it's more important for the long run (unless you love concrete)
	table.sort(eligible, function(a, b)
		return #a.markers.subsurface > #b.markers.subsurface
	end)
	return {eligible[1]}

end

-- See LICENSE for terms

local table = table
local pairs, type = pairs, type
local Sleep = Sleep
local IsValid = IsValid
local DoneObject = DoneObject
local TranslationTable = TranslationTable
--~ local Translate = ChoGGi.ComFuncs.Translate
local MsgPopup = ChoGGi.ComFuncs.MsgPopup
local DeleteObject = ChoGGi.ComFuncs.DeleteObject
local ToggleWorking = ChoGGi.ComFuncs.ToggleWorking

local testing = ChoGGi.testing

function ChoGGi.MenuFuncs.RemoveInvalidLabelObjects()
	local labels = UICity.labels
	for id, label in pairs(labels) do
		if id ~= "Consts" then
			for i = #label, 1, -1 do
				if not IsValid(label[i]) then
					table.remove(label, i)
				end
			end
		end
	end
	MsgPopup(
		TranslationTable[4493--[[All]]],
		TranslationTable[302535920001533--[[Remove Invalid Label Objects]]]
	)
end

function ChoGGi.MenuFuncs.RocketCrashesGameOnLanding()
	local rockets = UICity.labels.SupplyRocket or ""
	for i = 1, #rockets do
		rockets[i]:ForEachAttach("ParSystem", function(a)
			if type(a.polyline) == "string" and a.polyline:find("\0") then
				DoneObject(a)
			end
		end)
	end
	MsgPopup(
		TranslationTable[4493--[[All]]],
		TranslationTable[302535920001351--[[Rocket Crashes Game On Landing]]]
	)
end

function ChoGGi.MenuFuncs.ToggleWorkingAll()
	local skips = {"OrbitalProbe", "ResourceStockpile", "WasteRockStockpile", "BaseRover"}
	MapForEach("map", "BaseBuilding", function(o)
		if type(o.ToggleWorking) == "function" and not o:IsKindOfClasses(skips) then
			ToggleWorking(o)
		end
	end)

	MsgPopup(
		TranslationTable[4493--[[All]]],
		TranslationTable[302535920001299--[[Toggle Working On All Buildings]]]
	)
end

do -- DronesNotRepairingDome
	local looping_thread

	function ChoGGi.MenuFuncs.DronesNotRepairingDomes()
		local Sleep = Sleep
		MsgPopup(
			TranslationTable[83--[[Domes]]],
			TranslationTable[302535920001295--[[Drones Not Repairing Domes]]]
		)
		-- just in case someone decides to click it more than once...
		if looping_thread then
			DeleteThread(looping_thread)
			looping_thread = nil
		end
		-- loop 50 times, more than long enough for a drone smart/idle enough to grab the res outside the dome and repair it.
		looping_thread = CreateRealTimeThread(function()
			local count = 0
			while true do
				if count > 49 then
					break
				end
				count = count + 1

				local domes = UICity.labels.Domes or ""
				for i = 1, #domes do
					-- get a list of all res in the center of dome
					local pos = domes[i]:GetSpotPos(-1)
					local objs = MapGet(pos, 1000, "ResourcePile")
					-- loop through the spots till we find a Workdrone outside the dome (any spot outside will do)
					local id_start, id_end = domes[i]:GetAllSpots(domes[i]:GetState())
					for j = id_start, id_end do
						if domes[i]:GetSpotName(j) == "Workdrone" then
							local spot_pos = domes[i]:GetSpotPos(j)
							-- and goodbye res
							for k = 1, #objs do
								objs[k]:SetPos(spot_pos)
							end
							break
						end
					end
				end

				Sleep(1000)
			end
			MsgPopup(
				TranslationTable[1157--[[Complete thread]]],
				TranslationTable[302535920001295--[[Drones Not Repairing Domes]]]
			)
		end)
	end
end -- do

do -- ResetCommanders
	local function ResetRover(rc)
		local drones
		if rc.attached_drones then
			drones = #rc.attached_drones
			for i = 1, #rc.attached_drones do
				DoneObject(rc.attached_drones[i])
			end
		end
		local pos = rc:GetVisualPos()
		local new = rc:Clone()
		DoneObject(rc)
		new:SetPos(GetPassablePointNearby(pos))
		-- add any missing drones
		if drones > #new.attached_drones then
			repeat
				new:SpawnDrone()
			until drones == #new.attached_drones
		end
	end

	function ChoGGi.MenuFuncs.ResetCommanders()
		CreateRealTimeThread(function()
			local Sleep = Sleep
			local GetStateIdx = GetStateIdx
			local before_table = {}

			-- get all commanders stuck in deploy with at least one drone
			MapForEach("map", "RCRover", function(rc)
				local drones = #rc.attached_drones > 0
				if drones then
					if rc:GetState() == GetStateIdx("deployIdle") then
						-- store them in a table for later
						before_table[rc.handle] = {rc = rc, amount = #rc.attached_drones}
					-- borked, no sense in waiting for later
					elseif rc:GetState() == GetStateIdx("idle") and rc.waiting_on_drones then
						ResetRover(rc)
					end
				end
			end)
			-- let user know something is happening
			MsgPopup(
				T(5438--[[Rovers]]),
				TranslationTable[302535920000464--[[Updating Rovers]]]
			)
			--wait awhile just to be sure
			Sleep(5000)
			--go through and reset any rovers still doing the same thing
			for _, rc_table in pairs(before_table) do
				local state = rc_table.rc:GetState() == GetStateIdx("deployIdle")
				local drones = #rc_table.rc.attached_drones == rc_table.amount
				if state and drones then
					ResetRover(rc_table.rc)
				end
			end
		end)
	end
end -- do

do -- Colonist stuff
	local SpawnColonist = ChoGGi.ComFuncs.SpawnColonist
	local FindNearestObject = FindNearestObject
	local GetPassablePointNearby = GetPassablePointNearby

	function ChoGGi.MenuFuncs.ResetAllColonists()
		local UICity = UICity
		local function CallBackFunc(answer)
			if answer then
				local objs = UICity.labels.Colonist or ""
				for i = 1, #objs do
					local c = objs[i]
					local is_valid = IsValid(c)
					SpawnColonist(c, nil, is_valid and c:GetVisualPos(), UICity)
					if is_valid then
						DoneObject(c)
					end
				end
			end
		end

		ChoGGi.ComFuncs.QuestionBox(
			Translate(6779--[[Warning]]) .. "!\n" .. TranslationTable[302535920000055--[[Reset All Colonists]]]
				.. "\n" .. TranslationTable[302535920000939--[["Fix certain freezing issues (mouse still moves screen, keyboard doesn't), will lower comfort by about 20."]]],
			CallBackFunc,
			Translate(6779--[[Warning]]) .. ": " .. TranslationTable[302535920000055--[[Reset All Colonists]]]
		)
	end

	function ChoGGi.MenuFuncs.ColonistsTryingToBoardRocketFreezesGame()
		local UICity = UICity
		local objs = UICity.labels.Colonist or ""
		local rockets = UICity.labels.SupplyRocket or {}
		for i = 1, #objs do
			local c = objs[i]
			local is_valid = IsValid(c)
			if is_valid and c:GetStateText() == "movePlanet" then
				local rocket = FindNearestObject(rockets, c)
				SpawnColonist(c, rocket, c:GetVisualPos(), UICity)
				DeleteObject(c)
			end
		end

		MsgPopup(
			T(4493--[[All]]),
			TranslationTable[302535920000591--[[Colonists Trying To Board Rocket Freezes Game]]]
		)
	end

	local function AttachedColonist(c, pos, rocket, city)
		-- try to remove attached colonist from rocket, and get pos so we can create a new c at the same pos
		if IsValid(c) then
			c:Detach()
			SpawnColonist(c, rocket, pos, city)
			DoneObject(c)
		else
			SpawnColonist(nil, nil, rocket, pos, city)
		end
	end
	function ChoGGi.MenuFuncs.ColonistsStuckOutsideRocket()
		local InvalidPos = ChoGGi.Consts.InvalidPos
		local UICity = UICity
		local rockets = UICity.labels.SupplyRocket or ""
		for i = 1, #rockets do
			-- SupplyRocket also returns rockets in space
			if rockets[i]:GetPos() ~= InvalidPos then
				local pos = GetPassablePointNearby(rockets[i]:GetPos())
				rockets[i]:ForEachAttach("Colonist", AttachedColonist, pos, rockets[i], UICity)
			end
		end
		MsgPopup(
			T(5238--[[Rockets]]),
			TranslationTable[302535920000585--[[Colonists Stuck Outside Rocket]]]
		)
	end

end -- do

function ChoGGi.MenuFuncs.ParticlesWithNullPolylines()
	SuspendPassEdits("ChoGGi.MenuFuncs.ParticlesWithNullPolylines")
	local objs = MapGet(true, "ParSystem", function(o)
		if type(o.polyline) == "string" and o.polyline:find("\0") then
			return true
		end
	end)
	for i = #objs, 1, -1 do
		DoneObject(objs[i])
	end
	ResumePassEdits("ChoGGi.MenuFuncs.ParticlesWithNullPolylines")

	MsgPopup(
		T(4493--[[All]]),
		TranslationTable[302535920000593--[[Remove Particles With Null Polylines]]]
	)
end

function ChoGGi.MenuFuncs.RemoveMissingClassObjects()
	local function CallBackFunc(answer)
		if answer then
			SuspendPassEdits("ChoGGi.MenuFuncs.RemoveMissingClassObjects")
			MapDelete(true, "UnpersistedMissingClass")
			ResumePassEdits("ChoGGi.MenuFuncs.RemoveMissingClassObjects")
			MsgPopup(
				T(4493--[[All]]),
				TranslationTable[302535920000587--[[Remove Missing Class Objects]]]
			)
		end
	end

	ChoGGi.ComFuncs.QuestionBox(
		Translate(6779--[[Warning]]) .. "!\n"
			.. TranslationTable[302535920000588--[[May crash game, SAVE FIRST. These are probably from mods that were removed (if you're getting a PinDlg error then this should fix it).]]],
		CallBackFunc,
		Translate(6779--[[Warning]]) .. ": " .. TranslationTable[302535920000587--[[Remove Missing Class Objects]]]
	)
end

function ChoGGi.MenuFuncs.MirrorSphereStuck()
	local objs = UICity.labels.MirrorSpheres or ""
	for i = 1, #objs do
		local obj = objs[i]
		if not IsValid(obj.target) then
			DeleteObject(obj)
		end
	end

	SuspendPassEdits("ChoGGi.MenuFuncs.MirrorSphereStuck")
	objs = MapGet(true, "ParSystem", function(o)
		if o:GetParticlesName() == "PowerDecoy_Captured" and
				type(o.polyline) == "string" and o.polyline:find("\0") then
			return true
		end
	end)
	for i = #objs, 1, -1 do
		DoneObject(objs[i])
	end

	ResumePassEdits("ChoGGi.MenuFuncs.MirrorSphereStuck")

	MsgPopup(
		T(4493--[[All]]),
		TranslationTable[302535920000595--[[Mirror Sphere Stuck]]]
	)
end

function ChoGGi.MenuFuncs.StutterWithHighFPS()
	local CheckForBorkedTransportPath = ChoGGi.ComFuncs.CheckForBorkedTransportPath
	local bad_objs = {}
	local objs = UICity.labels.Unit or ""
	for i = 1, #objs do
		CheckForBorkedTransportPath(objs[i], bad_objs)
	end
	if testing then
		ex(bad_objs)
	end

	ChoGGi.ComFuncs.ResetHumanCentipedes()
	MsgPopup(
		T(4493--[[All]]),
		TranslationTable[302535920000597--[[Stutter With High FPS]]]
	)
end

do -- DronesKeepTryingBlockedAreas
	local function ResetPriorityQueue(cls_name)
		local max = const.MaxBuildingPriority
		MapForEach("map", cls_name, function(o)
			-- clears out the queues
			o.priority_queue = {}
			for priority = -1, max do
				o.priority_queue[priority] = {}
			end
		end)
	end

	function ChoGGi.MenuFuncs.DronesKeepTryingBlockedAreas()
		ResetPriorityQueue("SupplyRocket")
		ResetPriorityQueue("RCRover")
		ResetPriorityQueue("DroneHub")
		-- toggle working state on all ConstructionSite (wakes up drones else they'll wait at hub)
		MapForEach("map", "ConstructionSite", ToggleWorking)
		MsgPopup(
			T(4493--[[All]]),
			TranslationTable[302535920000599--[[Drones Keep Trying Blocked Areas]]]
		)
	end
end -- do

function ChoGGi.MenuFuncs.AlignAllBuildingsToHexGrid()
	local HexGetNearestCenter = HexGetNearestCenter
	MapForEach("map", "Building", function(o)
		o:SetPos(HexGetNearestCenter(o:GetVisualPos()))
	end)
	MsgPopup(
		T(4493--[[All]]),
		TranslationTable[302535920000621--[[Align All Buildings To Hex Grid]]]
	)
end

do -- RemoveUnreachableConstructionSites
	local type, pairs = type, pairs
	local function RemoveUnreachable(cls_name)
		MapForEach("map", cls_name, function(o)
			local unreach = o.unreachable_buildings or empty_table
			for bld in pairs(unreach) do
				if type(bld.IsKindOf) == "function" and bld:IsKindOf("ConstructionSite") then
					bld:Cancel()
				end
			end
			o.unreachable_buildings = false
		end)
	end

	function ChoGGi.MenuFuncs.RemoveUnreachableConstructionSites()
		local objs = UICity.labels.Drone or ""
		for i = 1, #objs do
			objs[i]:CleanUnreachables()
		end
		RemoveUnreachable("DroneHub")
		RemoveUnreachable("RCRover")
		RemoveUnreachable("SupplyRocket")

		MsgPopup(
			TranslationTable[302535920000971--[[Sites]]],
			TranslationTable[302535920000601--[[Idle Drones Won't Build When Resources Available]]]
		)
	end
end -- do

function ChoGGi.MenuFuncs.RemoveYellowGridMarks()
	SuspendPassEdits("ChoGGi.MenuFuncs.RemoveYellowGridMarks")
	MapDelete(true, "GridTile")
	MapDelete(true, "GridTileWater")
	ResumePassEdits("ChoGGi.MenuFuncs.RemoveYellowGridMarks")
	MsgPopup(
		T(4493--[[All]]),
		TranslationTable[302535920000603--[[Remove Yellow Grid Marks]]]
	)
end

function ChoGGi.MenuFuncs.RemoveBlueGridMarks()
	SuspendPassEdits("ChoGGi.MenuFuncs.RemoveBlueGridMarks")
	local objs = MapGet(true, "RangeHexRadius", function(o)
		if not o.ToggleWorkZone then
			return true
		end
	end)
	for i = #objs, 1, -1 do
		DoneObject(objs[i])
	end
	-- remove the rover outlines added from https://forum.paradoxplaza.com/forum/index.php?threads/surviving-mars-persistent-transport-route-blueprint-on-map.1121333/
	objs = MapGet(true, "WireFramedPrettification", function(o)
		if o:GetEntity() == "RoverTransport" then
			return true
		end
	end)
	for i = #objs, 1, -1 do
		DoneObject(objs[i])
	end

	ResumePassEdits("ChoGGi.MenuFuncs.RemoveBlueGridMarks")

	MsgPopup(
		T(4493--[[All]]),
		TranslationTable[302535920001193--[[Remove Blue Grid Marks]]]
	)
end

function ChoGGi.MenuFuncs.ProjectMorpheusRadarFellDown()
	local objs = UICity.labels.ProjectMorpheus or ""
	for i = 1, #objs do
		objs[i]:ChangeWorkingStateAnim(false)
		objs[i]:ChangeWorkingStateAnim(true)
	end
	MsgPopup(
		T(4493--[[All]]),
		TranslationTable[302535920000605--[[Project Morpheus Radar Fell Down]]]
	)
end

function ChoGGi.MenuFuncs.RebuildWalkablePointsInDomes()
	MapForEach("map", "Dome", function(o)
		o.walkable_points = false
		o:GenerateWalkablePoints()
	end)
	MsgPopup(
		T(4493--[[All]]),
		TranslationTable[302535920000583--[[Rebuild Walkable Points In Domes]]]
	)
end

function ChoGGi.MenuFuncs.AttachBuildingsToNearestWorkingDome()
	local AttachToNearestDome = ChoGGi.ComFuncs.AttachToNearestDome
	local objs = UICity.labels.InsideBuildings or ""
	for i = 1, #objs do
		AttachToNearestDome(objs[i])
	end

	MsgPopup(
		T(3980--[[Buildings]]),
		TranslationTable[302535920000609--[[Attach Buildings To Nearest Working Dome]]]
	)
end

function ChoGGi.MenuFuncs.ColonistsFixBlackCube()
	local objs = UICity.labels.Colonist or ""
	for i = 1, #objs do
		local c = objs[i]
		if c:GetEntity():find("Child") and c.specialist ~= "none" then
			c.specialist = "none"

			c.traits.Youth = nil
			c.traits.Adult = nil
			c.traits["Middle Aged"] = nil
			c.traits.Senior = nil
			c.traits.Retiree = nil

			c.traits.Child = true
			c.age_trait = "Child"
			c.age = 0
			c:ChooseEntity()
			c:SetResidence(false)
			c:UpdateResidence()
		end
	end
	MsgPopup(
		T(4493--[[All]]),
		TranslationTable[302535920000619--[[Fix Black Cube Colonists]]]
	)
end

do -- CablesAndPipesRepair
	local function RepairBorkedObjects(borked)
		local just_in_case = 0
		while #borked > 0 do

			for i = #borked, 1, -1 do
				local element = borked[i]
				if element.Repair and IsValid(element) then
					element:Repair()
				end
			end

			if just_in_case > 25000 then
				break
			end
			just_in_case = just_in_case + 1

		end
	end

	function ChoGGi.MenuFuncs.CablesAndPipesRepair()
		local g_BrokenSupplyGridElements = g_BrokenSupplyGridElements
		RepairBorkedObjects(g_BrokenSupplyGridElements.electricity)
		RepairBorkedObjects(g_BrokenSupplyGridElements.water)

		MsgPopup(
			T(4493--[[All]]),
			TranslationTable[302535920000157--[[Cables & Pipes]]] .. ": " .. TranslationTable[302535920000607--[[Instant Repair]]]
		)
	end
end -- do

--~ function ChoGGi.MenuFuncs.FireMostFixes()
--~ 	CreateRealTimeThread(function()
--~ 		local MenuFuncs = ChoGGi.MenuFuncs

--~ 		pcall(MenuFuncs.RemoveUnreachableConstructionSites)
--~ 		pcall(MenuFuncs.ParticlesWithNullPolylines)
--~ 		pcall(MenuFuncs.StutterWithHighFPS)
--~ 		pcall(MenuFuncs.ColonistsTryingToBoardRocketFreezesGame)
--~ 		pcall(MenuFuncs.AttachBuildingsToNearestWorkingDome)
--~ 		pcall(MenuFuncs.DronesKeepTryingBlockedAreas)
--~ 		pcall(MenuFuncs.RemoveYellowGridMarks)
--~ 		pcall(MenuFuncs.RemoveBlueGridMarks)
--~ 		pcall(MenuFuncs.CablesAndPipesRepair)
--~ 		pcall(MenuFuncs.MirrorSphereStuck)
--~ 		pcall(MenuFuncs.ProjectMorpheusRadarFellDown)
--~ 		pcall(MenuFuncs.RemoveInvalidLabelObjects)

--~ 		-- loop through and remove all my msgs from the onscreen popups
--~ 		CreateRealTimeThread(function()
--~ 			local MsgPopups = ChoGGi.Temp.MsgPopups
--~ 			Sleep(500)
--~ 			while #MsgPopups < 10 do
--~ 				Sleep(100)
--~ 			end
--~ 			local popups = MsgPopups or ""
--~ 			for i = #popups, 1, -1 do
--~ 				popups[i]:delete()
--~ 			end
--~ 			table.iclear(MsgPopups)
--~ 		end)
--~ 	end)
--~ end

------------------------- toggles

function ChoGGi.MenuFuncs.FixMissingModBuildings_Toggle()
	ChoGGi.UserSettings.FixMissingModBuildings = not ChoGGi.UserSettings.FixMissingModBuildings
	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.FixMissingModBuildings),
		TranslationTable[302535920001483--[[Missing Mod Buildings]]]
	)
end

-- broked ai mods... (fix your crap or take it down kthxbai)
function ChoGGi.MenuFuncs.ColonistsStuckOutsideServiceBuildings_Toggle()
	if ChoGGi.UserSettings.ColonistsStuckOutsideServiceBuildings then
		ChoGGi.UserSettings.ColonistsStuckOutsideServiceBuildings = nil
	else
		ChoGGi.UserSettings.ColonistsStuckOutsideServiceBuildings = true
		ChoGGi.ComFuncs.ResetHumanCentipedes()
	end

	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.ColonistsStuckOutsideServiceBuildings),
		TranslationTable[302535920000248--[[Colonists Stuck Outside Service Buildings]]]
	)
end

function ChoGGi.MenuFuncs.DroneResourceCarryAmountFix_Toggle()
	ChoGGi.UserSettings.DroneResourceCarryAmountFix = ChoGGi.ComFuncs.ToggleValue(ChoGGi.UserSettings.DroneResourceCarryAmountFix)

	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.DroneResourceCarryAmountFix),
		TranslationTable[302535920000613--[[Drone Carry Amount]]]
	)
end

function ChoGGi.MenuFuncs.SortCommandCenterDist_Toggle()
	ChoGGi.UserSettings.SortCommandCenterDist = ChoGGi.ComFuncs.ToggleValue(ChoGGi.UserSettings.SortCommandCenterDist)

	ChoGGi.SettingFuncs.WriteSettings()
	MsgPopup(
		ChoGGi.ComFuncs.SettingState(ChoGGi.UserSettings.SortCommandCenterDist),
		TranslationTable[302535920000615--[[Sort Command Center Dist]]]
	)
end

---------------------------------------------------Testers

--~ GetDupePositions(UICity.labels.Colonist or "")
--~ function ChoGGi.MenuFuncs.GetDupePositions(list)
--~	 local dupes = {}
--~	 local positions = {}
--~	 local pos
--~	 for i = 1, #list do
--~		 pos = list[i]:GetPos()
--~		 pos = tostring(point(pos:x(), pos:y()))
--~		 if not positions[pos] then
--~			 positions[pos] = true
--~		 else
--~			 dupes[pos] = true
--~		 end
--~	 end
--~	 if dupes[1] then
--~		 table.sort(dupes)
--~		 ChoGGi.ComFuncs.OpenInExamineDlg(dupes)
--~	 end
--~ end

--~ function ChoGGi.MenuFuncs.DeathToObjects(cls)
--~ use MapDelete above
--~ 	end

--~ ChoGGi.MenuFuncs.DeathToObjects("BaseRover")
--~ ChoGGi.MenuFuncs.DeathToObjects("Colonist")
--~ ChoGGi.MenuFuncs.DeathToObjects("CargoShuttle")
--~ ChoGGi.MenuFuncs.DeathToObjects("Building")
--~ ChoGGi.MenuFuncs.DeathToObjects("Drone")
--~ ChoGGi.MenuFuncs.DeathToObjects("SupplyRocket")
--~ ChoGGi.MenuFuncs.DeathToObjects("Unit") --rovers/drones/colonists

--~ --show all elec consumption
--~ local amount = 0
--~ MapForEach("map", nil, function(o)
--~ 	if o.class and o.electricity and o.electricity.consumption then
--~ 		local temp = o.electricity.consumption / 1000
--~ 		amount = amount + temp
--~ 		print(o.class, ": ", temp)
--~ 	end
--~ end)
--~ print(amount)

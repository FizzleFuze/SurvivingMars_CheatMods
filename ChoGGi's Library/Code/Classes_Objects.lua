-- See LICENSE for terms

local TranslationTable = TranslationTable
local AveragePoint2D = AveragePoint2D
local PolylineSetParabola = ChoGGi.ComFuncs.PolylineSetParabola

-- blank CObject (could use Object, but has more parents) class we add to all the objects below for easier deleting
DefineClass.ChoGGi_ODeleteObjs = {
	__parents = {"CObject"},
}

-- simplest entity object possible for hexgrids (it went from being laggy with 100 to usable, though that includes some use of local, so who knows)
DefineClass.ChoGGi_OHexSpot = {
	__parents = {"ChoGGi_ODeleteObjs"},
	entity = "GridTile",
}

-- re-define objects for ease of deleting later on
DefineClass.ChoGGi_OVector = {
	__parents = {"ChoGGi_ODeleteObjs","Vector"},
}
DefineClass.ChoGGi_OSphere = {
	__parents = {"ChoGGi_ODeleteObjs","Sphere"},
}
DefineClass.ChoGGi_OPolyline = {
	__parents = {"ChoGGi_ODeleteObjs","Polyline"},
}
function ChoGGi_OPolyline:SetParabola(a, b)
	PolylineSetParabola(self, a, b)
	self:SetPos(AveragePoint2D(self.vertices))
end
local line_points = {}
function ChoGGi_OPolyline:SetLine(a, b)
	line_points[1] = a
	line_points[2] = b
--~ 	self.vertices = line_points
	self.max_vertices = #line_points
	self:SetMesh(line_points)
	self:SetPos(AveragePoint2D(line_points))
end

--~ SetZOffsetInterpolation, SetOpacityInterpolation
DefineClass.ChoGGi_OText = {
	__parents = {"ChoGGi_ODeleteObjs","Text"},
	text_style = "Action",
}
DefineClass.ChoGGi_OOrientation = {
	__parents = {"ChoGGi_ODeleteObjs","Orientation"},
}
DefineClass.ChoGGi_OCircle = {
	__parents = {"ChoGGi_ODeleteObjs","Circle"},
}

DefineClass.ChoGGi_OBuildingEntityClass_Generic = {
	__parents = {
		"Demolishable",
		"BaseBuilding",
		"BuildingEntityClass",
		-- so we can have a selection panel for spawned entity objects
		"InfopanelObj",
	},
	-- defined in ECM OnMsgs
	ip_template = "ipChoGGi_Entity",
}
-- add some info/functionality to spawned entity objects
ChoGGi_OBuildingEntityClass_Generic.GetDisplayName = CObject.GetEntity
function ChoGGi_OBuildingEntityClass_Generic.GetIPDescription()
	return TranslationTable[302535920001110--[[Spawned entity object]]]
end
-- circle or hex thingy?
ChoGGi_OBuildingEntityClass_Generic.OnSelected = AddSelectionParticlesToObj
-- prevent an error msg in log
ChoGGi_OBuildingEntityClass_Generic.BuildWaypointChains = empty_func
-- round and round she goes, and where she stops BOB knows
ChoGGi_OBuildingEntityClass_Generic.Rotate = ChoGGi.ComFuncs.RotateBuilding

DefineClass.ChoGGi_OBuildingEntityClass = {
	__parents = {
		"ChoGGi_OBuildingEntityClass_Generic",
		"ChoGGi_ODeleteObjs",
	},
}

DefineClass.ChoGGi_OBuildingEntityClass_Perm = {
	__parents = {
		"ChoGGi_OBuildingEntityClass_Generic",
	},
}

-- add any auto-attach items
DefineClass.ChoGGi_OBuildingEntityClassAttach = {
	__parents = {
		"ChoGGi_OBuildingEntityClass_Generic",
		"ChoGGi_ODeleteObjs",
		"AutoAttachObject",
	},
	auto_attach_at_init = true,
}
ChoGGi_OBuildingEntityClassAttach.GameInit = AutoAttachObject.Init

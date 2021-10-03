return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 10,
			"version_minor", 5,
		}),
	},
	"title", "Waste Rock Grinder",
	"id", "ChoGGi_WasteRockGrinder",
	"steam_id", "2544246919",
	"pops_any_uuid", "53a56418-38cd-4b05-bc06-144a517292b7",
	"lua_revision", 1007000, -- Picard
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
--~ 	"has_options", true,
	"TagBuildings", true,
	"description", [[
Automated waste rock extractor that produces waste rock (and dust).
Produces 24 per Sol.


Requested by Rejected Spawn.
]],
})

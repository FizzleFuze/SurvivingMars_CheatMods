return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 10,
			"version_minor", 1,
		}),
	},
	"title", "Drone Hub Range",
	"id", "ChoGGi_DroneHubRange",
	"steam_id", "2474837548",
	"pops_any_uuid", "f7e5153e-862e-4805-aff4-6d74d9f1a4a9",
	"lua_revision", 1001514, -- Tito
	"version", 4,
	"version_major", 0,
	"version_minor", 4,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"TagBuildings", true,
	"TagInterface", true,
	"TagTools", true,
	"description", [[
Change range of drone hubs (see mod options).


Doesn't seem to work on xbox.


Requested by lovely_sombrero.
]],
})

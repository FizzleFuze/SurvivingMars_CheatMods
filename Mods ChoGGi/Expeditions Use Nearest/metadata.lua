return PlaceObj("ModDef", {
	"title", "Expeditions Use Nearest",
	"id", "ChoGGi_ExpeditionsUseNearestDrones",
	"steam_id", "2287155002",
	"pops_any_uuid", "1e399bf5-1fe9-4329-871e-adb6a10a331d",
	"lua_revision", 1007000, -- Picard
	"version", 5,
	"version_major", 0,
	"version_minor", 5,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[
Change how expedition rockets pick drones/colonists: Instead of a round-robin approach; this will grab based on distance.
Mod options to choose which overrides to enable.


Requested by vizthex.
]],
})

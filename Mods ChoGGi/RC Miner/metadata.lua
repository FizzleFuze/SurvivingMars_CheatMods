return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 10,
			"version_minor", 9,
		}),
	},
	"title", "RC Miner",
	"id", "ChoGGi_PortableMiner",
	"steam_id", "1411113412",
	"pops_any_uuid", "77ce8f23-dd20-4d38-9161-19c958ff9878",
	"lua_revision", 1007000, -- Picard
	"version", 32,
	"version_major", 3,
	"version_minor", 2,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[
It's a rover that mines, tell it where to go and if there's a resource (Metals/Concrete/Minerals) close by it'll start mining it.
Supports the Auto-mode added in Sagan (boosts the amount stored per stockpile when enabled).
Use mod options to tweak the settings.



Affectionately known as the pooper shooter.
]],
})

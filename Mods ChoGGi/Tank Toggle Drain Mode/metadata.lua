return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 10,
			"version_minor", 1,
		}),
	},
	"title", "Tank Toggle Drain Mode",
	"id", "ChoGGi_TankToggleDrainMode",
	"lua_revision", 1001514, -- Tito
	"steam_id", "2214626980",
	"pops_any_uuid", "d87650c0-ced0-4755-997f-c47627550549",
	"version", 2,
	"version_major", 0,
	"version_minor", 2,
	"image", "Preview.png",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
--~ 	"has_options", true,
	"TagInterface", true,
	"description", [[Adds a button to toggle drain only mode on water/air/electrical tanks.
You can use this to move tanks without throwing away the contents.


Requested by Vas.]],
})

return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 6,
			"version_minor", 4,
		}),
	},
	"title", "Auto Empty Waste Storage",
	"version_major", 0,
	"version_minor", 4,
	"saved", 1539950400,
	"id", "ChoGGi_AutoEmptyWasteStorage",
	"author", "ChoGGi",
	"image","Preview.png",
	"code", {
		"Code/Script.lua"
	},
	"lua_revision", LuaRevision or 244275,
	"steam_id", "1485526508",
	"description", [[Automatically empties waste storage sites.

Use Mod Config to toggle enabled, and hourly/daily empty.]],
})

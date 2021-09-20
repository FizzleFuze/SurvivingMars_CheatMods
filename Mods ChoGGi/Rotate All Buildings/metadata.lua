return PlaceObj("ModDef", {
	"title", "Rotate All Buildings",
	"id", "ChoGGi_RotateAllBuildings",
	"pops_any_uuid", "e22c2a8a-60a1-4736-9c11-b4ecbe14dce0",
	"steam_id", "1566471085",
	"lua_revision", 1007000, -- Picard
	"version", 3,
	"version_major", 0,
	"version_minor", 3,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"TagInterface", true,
	"description", [[
Removes rotate limit imposed on certain buildings.
Lets you rotate the Underground Entrance to pick where the elevator entrance goes (objs too close may interfere when rotating).
]],
})

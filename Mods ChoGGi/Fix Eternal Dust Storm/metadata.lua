return PlaceObj("ModDef", {
	"title", "Fix Eternal Dust Storm",
	"id", "ChoGGi_FixEternalDustStorm",
	"steam_id", "1594158818",
	"pops_any_uuid", "06dcbc57-c2d7-456f-9091-4d93babe14f6",
	"lua_revision", 1007000, -- Picard
	"version", 3,
	"version_major", 0,
	"version_minor", 3,
	"image", "Preview.png",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagOther", true,
	"description", [[There's no notification, but any newly placed buildings will complain about a dust storm.
You don't need to leave this enabled afterwards.

https://forum.paradoxplaza.com/forum/index.php?threads/surviving-mars-eternal-dust-storm.1139596/

Includes mod option to disable fix.
]],
})

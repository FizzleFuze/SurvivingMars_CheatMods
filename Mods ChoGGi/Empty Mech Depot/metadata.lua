return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 10,
			"version_minor", 1,
		}),
	},
	"title", "Empty Mech Depot",
	"version", 10,
	"version_major", 1,
	"version_minor", 0,
	"image", "Preview.jpg",
	"id", "ChoGGi_EmptyMechDepot",
	"steam_id", "1411108310",
	"pops_any_uuid", "c3b2ae57-aaf6-4dd1-a5ad-2bd33afd0505",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"lua_revision", 1001514, -- Tito
	"description", [[
Adds a button to mech depots to empty them out into a small depot in front of them.

This also allows you to salvage mech depots with resources in them.
You need to enable the mod option beforehand: This will delete the resources!.

Includes mod option to stop it from deleting mech depot afterwards.
]],
})

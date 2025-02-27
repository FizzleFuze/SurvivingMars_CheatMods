return PlaceObj("ModDef", {
	"title", "Fix Missing Mod Buildings",
	"version", 5,
	"version_major", 0,
	"version_minor", 5,
	"image", "Preview.png",
	"id", "ChoGGi_MissingModBuildings",
	"author", "ChoGGi",
	"steam_id", "1443225581",
	"pops_any_uuid", "228b89e9-b241-4052-98b3-e0a0a010f8c6",
	"code", {
		"Code/Script.lua"
	},
	"lua_revision", 1007000, -- Picard
	"has_options", true,
	"TagOther", true,
	"description", [[This replaces my Missing Residences/Missing Workplaces mods, it also adds support for some other missing buildings.

If you installed a mod that adds certain buildings, then removed the mod without removing them; your game won't load...

This fixes that, and will remove any broked buildings.

You can remove this mod after saving your game, or leave it enabled.
Includes mod option to disable fix.




BACKUP your save before using this.


]],
})

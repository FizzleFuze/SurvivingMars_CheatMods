return PlaceObj("ModDef", {
  "title", "Add Water Each Sol",
	"version_major", 0,
	"version_minor", 5,
  "saved", 1536062400,
  "id", "ChoGGi_AddWaterEachSol",
  "author", "ChoGGi",
	"code", {
		"Code/Script.lua",
		"Code/ModConfig.lua",
	},
	"image", "Preview.png",
  "steam_id", "1440164001",
	"lua_revision", LuaRevision or 244275,
  "description", [[Adds 50 units of water to any visible deposits each new Sol.

This will not increase the capacity, so if the deposit is full that's it.

You can adjust the amount added with Mod Config Reborn.]],
})

return PlaceObj("ModDef", {
	"title", "Pipes Less Limits",
	"id", "ChoGGi_PipesLessLimits",
	"steam_id", "1819506189",
	"pops_any_uuid", "0fb8383a-6320-4a1f-864e-21b962291424",
	"lua_revision", 1007000, -- Picard
	"version", 2,
	"version_major", 0,
	"version_minor", 2,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"TagGameplay", true,
	"description", [[
Allows more buildings to be built under pipes.
Subsurface Heater, Tunnel, Landing/Trade Pad, Solar Array

Some won't stick through depending on angle, up to you to make it not stupid looking:
Drone Hub, Shuttle Hub, Automatic Metals Extractor, Rare/Metals Refinery, Waste Rock Processor, Polymer Plant, Drone Assembler, Fuel Refinery, MOXIE, Oxygen Tank, Water Extractor, Moisture Vaporator, Fungal Farm, Outside Ranch, Mech Storage

Any I missed?



Known Issues:
Placing reversed air tanks next to each other under a pipe will cause the pipe to be invisible, you can also try removing and rebuilding?
]],
})

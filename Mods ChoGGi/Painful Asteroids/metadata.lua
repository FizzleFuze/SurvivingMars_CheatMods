return PlaceObj("ModDef", {
	"title", "Painful Asteroids",
	"id", "ChoGGi_PainfulAsteroids",
	"steam_id", "2424938510",
	"pops_any_uuid", "c6fa07e9-c83a-4f86-89a7-b7c1a390bebd",
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
	"description", [[Makes the dome and any buildings inside it malfunction on impact.
This also increases the damage area when landing outside domes.

Mod Options:
[b]Dome + Asteroid = Death[/b]: Death of those in the dome, and any buildings inside are destroyed (I wouldn't park rovers too close to domes).
[b]Impact Range[/b]: When landing outside of domes; how large of an area is affected by asteroid.
[b]Destruction Percent[/b]: What percentage of buildings are malfunctioned/destroyed on hit.
[b]Extra Fractures[/b]: More dome cracks.
]],
})

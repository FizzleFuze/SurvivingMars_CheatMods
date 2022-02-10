-- See LICENSE for terms

--~ return {
local props = {
--~ 	PlaceObj("ModItemOptionNumber", {
--~ 		"name", "BreakthroughCount",
--~ 		"DisplayName", T(0000, "Breakthrough Count"),
--~ 		"Help", T(0000, [[Defaults to 12: 4 from Planetary anomalies, and 12 from ground anomalies.
--~ 	You can also get some from storybits, but those can change slightly (you could bump it up to 17 and very likely get them as well).]]),
--~ 		"DefaultValue", 12,
--~ 		"MinValue", 1,
--~ 		"MaxValue", #(Presets.TechPreset.Breakthroughs or 50),
--~ 	}),
}

-- REMOVE LIB 10.9
local idx = table.find(ModsLoaded, "id", "ChoGGi_Library")
if not idx then
	return props
end
-- needs 10.9 or higher
if ModsLoaded[idx].version <= 108 then
	return props
end

props[#props+1] = PlaceObj("ModItemOptionNumber", {
	"name", "BreakthroughCount",
	"DisplayName", T(0000, "Breakthrough Count"),
	"Help", T(0000, [[Defaults to 12: 4 from Planetary anomalies, and 12 from ground anomalies.
You can also get some from storybits, but those can change slightly (you could bump it up to 17 and very likely get them as well).]]),
	"DefaultValue", 12,
	"MinValue", 1,
	"MaxValue", #(Presets.TechPreset.Breakthroughs or 50),
})

return props
-- REMOVE LIB 10.9

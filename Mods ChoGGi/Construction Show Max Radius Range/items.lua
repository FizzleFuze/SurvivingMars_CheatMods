return {
	PlaceObj("ModItemOptionToggle", {
		"name", "ShowConstruct",
		"DisplayName", T(302535920011403, "Show during construction"),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "SetMaxRadius",
		"DisplayName", T(302535920011711, "Set Max Radius"),
		"Help", T(302535920011712, "Set radius for newly placed buildings to max radius."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "ShowMaxDroneHubRadius",
		"DisplayName", T(0000, "Show Max Drone Hub Radius"),
		"Help", T(0000, "Toggle between 35/50 hexes (B&B DLC)."),
		"DefaultValue", false,
	}),
}

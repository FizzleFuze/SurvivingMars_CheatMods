return PlaceObj("ModDef", {
	"title", "Log Flush v0.2",
	"version", 2,
	"saved", 1533124800,
	"id", "ChoGGi_LogFlush",
	"steam_id", "1414089790",
	"author", "ChoGGi",
	"code", {"Script.lua"},
	"image", "Preview.png",
	"description", [[This calls the FlushLogFile() command as soon as the game loads, as well as each new Sol.
Now if SM crashes a certain way (that doesn't create the log), you still have a log to look at.

Also included are commented out options to flush on NewHour/NewMinute.]],
})
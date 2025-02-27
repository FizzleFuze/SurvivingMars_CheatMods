### Add locale support to your mod
```lua
If you're translating for XWindows, and you need to use a table value use:
T{123, "string<context_value>", context_value = some_obj}
Otherwise you can skip the table creation and just use:
T(123, "string")

In your mod folder create a Locales folder, in that folder create English.csv (or whatever you use).

Mod folder\Locales\English.csv

In English.csv add text like so (you only really need: ID,Text though Translation isn't bad)
ID,Text,Translation,Old Translation,Gender
11111111110001001,Some text
11111111110001002,and More text.
11111111110001003,"and some ""quoted"" text"
11111111110001004,"some text with

new lines in them"
11111111110001005,"some text with commas, included"

CHANGE 11111111 to some random number, or use whatever you already use in your mod.

In items.lua add:
PlaceObj("ModItemLocTable", {
	"language", "English",
	"filename", "Locales/English.csv",
}),

Now you can use _InternalTranslate(T(11111111110001029--[[optionally showing a string for your %s.--]])):format("sanity")
or T(11111111110001029, some text <custom_text>") like usual
All a translator needs to do is make a copy of English.csv, rename it to their lang: OpenExamine(AllLanguages),
start changing strings, and then send you the file.
Of course this doesn't stop you from using <values> as well (just use T{} and call it a day).




I like to use this function for ease of use (and to make sure I always get a string back):

-- the string _InternalTranslate returns on failure
local missing_text = "Missing text"

-- local some globals
local type, tostring, print = type, tostring, print
local _InternalTranslate, T, IsT = _InternalTranslate, T, IsT

-- translate func that always returns a string (string id, {id,value}, nil)
function Translate(t, context, ...)
	if not t then
		return missing_text
	end
	if t == "" then
		return t
	end

	local str = _InternalTranslate(
		(context and T(t, context, ...) or T{t, context, ...})
	)

	-- Missing text means the string id wasn't found (generally)
	if str == missing_text or type(str) ~= "string" then
		-- try to return the string id, if we can
		print("Translate Failed:", t, context, ...)
		return tostring(IsT(t) or missing_text)
	end

	-- and done
	return str
end


Translate(11111111110001029, "The text from the csv in a comment, so I know what it means")
```


### CSV import issue:
##### "[LUA ERROR] table index is nil, field ModsLoadLocTables"
##### "CommonLua/Core/localization.lua:559: table index is nil"
##### Also the game may freeze.

```lua
Install my Expanded Cheat Menu mod then go to Menu>Debug>Test Locale File

It'll return a list of translated and failed strings, as well as some context to where the error is.

File Path is the path to the csv file
Mods.ChoGGi_ExampleTranslateGame.env.CurrentModPath .. "Locale/Game.csv"
or
"AppData/Mods/Some Mod/Locales/file.csv"

Test Columns can be true to report columns above 5 (usual amount for translations).
It can also be a number for a custom amount of columns (if you get too many or not enough errors).

for something like
302535920000887,Example,
you should send 4
for something like
1000591,Error,Errore,
then 5 will work

Test Columns requires you to install my HelperMod for ECM.
```
![Test Locale File](Locales.png?raw=true "Test Locale File")

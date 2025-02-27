-- See LICENSE for terms

local LICENSE = [[
Any code from https://github.com/HaemimontGames/SurvivingMars is copyright by their LICENSE

All of my code is licensed under the MIT License as follows:

MIT License

Copyright (c) 2018-2022 ChoGGi

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

-- I should really split this into funcs and settings... one of these days
ChoGGi = {
	-- anyone examining ChoGGi will see this first
	_LICENSE = LICENSE,
	-- easy access to them
	id_lib = CurrentModId,
	def_lib = CurrentModDef,
	-- Is ECM shanghaied by the blacklist?
	blacklist = true,
	-- constants
	Consts = {InvalidPos = InvalidPos()},
	-- default ECM settings
	Defaults = false,
	-- means of communication
	email = "SM_Mods@choggi.org",
	-- font used for various UI stuff
	font = "droid",
	-- Wha'choo talkin' 'bout, Willis?
	lang = GetLanguage(),
	-- path to this mods' folder
	library_path = CurrentModPath,
	-- easier access to some data
	Tables = {
		Cargo = {},
		CargoPresets = {},
		ColonistAges = {},
		ColonistBirthplaces = {},
		ColonistGenders = {},
		ColonistSpecializations = {},
		Mystery = {},
		NegativeTraits = {},
		OtherTraits = {},
		PositiveTraits = {},
		Resources = {},
		SchoolTraits = {},
		SanatoriumTraits = {},
		Sponsors = {},
		Commanders = {},
		ConstructionStatus = {},
		-- don't want to have to declare these more than i have to
		const_names = {
			"BreakThroughTechsPerGame",
			"CommandCenterMaxRadius",
			"DroneBatteryMax",
			"DroneRestrictRadius",
			"ExplorationQueueMaxSize",
			"fastGameSpeed",
			"MaxToxicRainPools",
			"mediumGameSpeed",
			"MoistureVaporatorPenaltyPercent",
			"MoistureVaporatorRange",
			"OmegaTelescopeBreakthroughsCount",
			"RCRoverMaxRadius",
			"ResearchQueueSize",
		},
	},
	-- stuff that isn't ready for release, more print msgs, and some default settings
	testing = false,
	-- for text dumping (yep .pc means windows desktop, i guess .linux/.osx aren't personal computers)
	newline = Platform.pc and "\r\n" or "\n",
	-- CommonFunctions.lua/ECM_Functions.lua
	ComFuncs = {
		DebugGetInfo = format_value,
	},
	-- orig funcs that get replaced
	OrigFuncs = {},
	-- /Menus/*
	MenuFuncs = {},
	-- InfoPaneCheats.lua
	InfoFuncs = {},
	-- Defaults.lua
	SettingFuncs = {},
	-- ConsoleFuncs.lua
	ConsoleFuncs = {},
	-- temporary... stuff
	Temp = {
		-- collect error msgs to be displayed in console after game is loaded
		StartupMsgs = {},
		-- a list of menuitems and shortcut keys for Msg("ShortcutsReloaded")
		Actions = {},
		-- rememeber transparency for some of my dialogs (ex and console log)
		Dlg_transp_mode = false,
		-- stores a table of my dialogs
		Dialogs = {},
		-- they changed it once, they can change it again (trans func returns this for fail, and posb something else)
		missing_text = "Missing text",
	},
	-- settings that are saved to settings_file
	UserSettings = {
		BuildingSettings = {},
		Transparency = {},
		-- saved Consts settings
		Consts = {},
	},
}
--
local ChoGGi = ChoGGi

do -- translate (todo update code to not need this, maybe use T() for menus)
	local locale_path = ChoGGi.library_path .. "Locales/"
	-- load locale translation (if any, not likely with the amount of text, but maybe a partial one)
	if not LoadTranslationTableFile(locale_path .. ChoGGi.lang .. ".csv") then
		LoadTranslationTableFile(locale_path .. "English.csv")
	end

	Msg("TranslationChanged")
end -- do

-- fake mod used to tell if it's my comp, if you want some extra msgs and .testing funcs have at it (Testing.lua)
if Mods.ChoGGi_testing or Mods.TESTING then
	ChoGGi.testing = {}
	printC = print
else
	printC = empty_func
end

-- Maybe they'll update the game again?
--~ -- Is ECM shanghaied by the blacklist?
--~ if def.no_blacklist then
--~ 	ChoGGi.blacklist = false
--~ 	local env = def.env
--~ 	Msg("ChoGGi_UpdateBlacklistFuncs", env)
--~ 	-- make lib mod have access as well
--~ 	local lib_env = ChoGGi.def_lib.env
--~ 	lib_env._G = env._G
--~ 	lib_env.rawget = env.rawget
--~ 	lib_env.getmetatable = env.getmetatable
--~ 	lib_env.os = env.os
--~ end

-- I didn't get a harumph outta that guy!
ModEnvBlacklist = {--[[Harumph!]]}

-- Used to bypass blacklist
local ChoOrig_cmdline = Platform.cmdline
Platform.cmdline = true

-- Wait for g_ConsoleFENV
local Sleep = Sleep
CreateRealTimeThread(function()
	if not g_ConsoleFENV then
		WaitMsg("Autorun")
	end
	while not g_ConsoleFENV do
		Sleep(250)
	end
	-- Might as well reset it?
	Platform.cmdline = ChoOrig_cmdline
	--
	local env = g_ConsoleFENV._G
	ChoGGi.blacklist = false
	Msg("ChoGGi_UpdateBlacklistFuncs", env)

	-- Make my mods have access
	local lib_env = ChoGGi.def_lib.env
	lib_env._G = env
	lib_env.rawget = env.rawget
	lib_env.getmetatable = env.getmetatable
	lib_env.os = env.os
	--
	if ChoGGi.def then
		lib_env = ChoGGi.def.env
		lib_env._G = env
		lib_env.rawget = env.rawget
		lib_env.getmetatable = env.getmetatable
		lib_env.os = env.os
	end

	ChoGGi.ComFuncs.FileExists = env.io.exists
	if ChoGGi.testing then
		ChoGGi.env = env
	end

end)

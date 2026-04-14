-- SERVER SCRIPT - Place inside the trigger Part
-- LocalScript goes UNDER this Script (set Disabled = true)

local Players             = game:GetService("Players")
local ReplicatedStorage   = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local remoteFolder = ReplicatedStorage:FindFirstChild("MorphGuiRemotes")
if not remoteFolder then
	remoteFolder = Instance.new("Folder")
	remoteFolder.Name = "MorphGuiRemotes"
	remoteFolder.Parent = ReplicatedStorage
end

local function getOrMake(class, name)
	local r = remoteFolder:FindFirstChild(name)
	if not r then
		r = Instance.new(class)
		r.Name = name
		r.Parent = remoteFolder
	end
	return r
end

local morphRequestEvent   = getOrMake("RemoteEvent",    "MorphRequest")
local notifyUnlockEvent   = getOrMake("RemoteEvent",    "NotifyUnlock")
local isUnlockedFunc      = getOrMake("RemoteFunction", "IsUnlocked")
local resetMorphEvent     = getOrMake("RemoteEvent",    "ResetMorph")
local tinkyTeleportEvent  = getOrMake("RemoteEvent",    "TinkyTeleport")
local tinkyJumpscareEvent = getOrMake("RemoteEvent",    "TinkyJumpscare")
local tinkyReadyEvent     = getOrMake("RemoteEvent",    "TinkyReady")
-- New v4.5 remotes
local morphCompleteEvent  = getOrMake("RemoteEvent",    "MorphComplete")
local morphPrivateEvent   = getOrMake("RemoteEvent",    "MorphPrivate")

-- ============================================
-- FEATURED MORPH REMOTES
-- ============================================
local getFeaturedFunc        = getOrMake("RemoteFunction", "GetFeaturedMorph")
local featuredUpdatedEvent   = getOrMake("RemoteEvent",    "FeaturedMorphUpdated")

-- Trevor Henderson module ID (v4.5 — all Trevor morphs use this)
local TREVOR_ID = 75834950186546

local MORPHS = {
	-- ══════════════════════════════════════════════
	-- TREVOR HENDERSON — all use TREVOR_ID
	-- ══════════════════════════════════════════════
	["Ice Siren Head"]           = {TREVOR_ID,        "ice siren head",              "MorphMonster"},
	["Blood Siren Head"]         = {TREVOR_ID,        "blood siren head",            "MorphMonster"},
	["Dark Siren Head"]          = {TREVOR_ID,        "dark siren head",             "MorphMonster"},
	["Shadow Siren Head"]        = {TREVOR_ID,        "shadow siren head",           "MorphMonster"},
	["Trafficlight Head"]        = {TREVOR_ID,        "trafficlight head",           "MorphMonster"},
	["Wood Siren Head"]          = {TREVOR_ID,        "wood siren head",             "MorphMonster"},
	["Light Siren Head"]         = {TREVOR_ID,        "light siren head",            "MorphMonster"},
	["OG Siren Head"]            = {TREVOR_ID,        "og siren head",               "MorphMonster"},
	["Shadow Siren Head V2"]     = {TREVOR_ID,        "shadow siren head",           "MorphMonster"},
	["Siren Head"]               = {TREVOR_ID,        "sirenhead",                   "MorphMonster"},
	["Siren Head 2"]             = {TREVOR_ID,        "sirenhead2",                  "MorphMonster"},
	["The Hugger"]               = {TREVOR_ID,        "the hugger",                  "MorphMonster"},
	["Banana Eater"]             = {TREVOR_ID,        "banana eater",                "MorphMonster"},
	["The Extra Slide"]          = {TREVOR_ID,        "the extra slide",             "MorphMonster"},
	["God of Roadkill"]          = {102798848281487,  "god of roadkill",             "MorphMonster"},
	["Good Boy"]                 = {102798848281487,  "good boy",                    "MorphMonster"},
	["Mothman"]                  = {102798848281487,  "mothman",                     "MorphMonster"},
	["Scribble Head"]            = {102798848281487,  "scribble head",               "MorphMonster"},
	["The Lamb"]                 = {TREVOR_ID,        "the lamb",                    "MorphMonster"},
	["Yoyo"]                     = {TREVOR_ID,        "yoyo",                        "MorphMonster"},
	["Anxious Dog"]              = {TREVOR_ID,        "anxious dog",                 "MorphMonster"},
	["Bonesworth"]               = {TREVOR_ID,        "bonesworth",                  "MorphMonster"},
	["Breaking News"]            = {TREVOR_ID,        "breaking news",               "MorphMonster"},
	["Bridgeworm"]               = {TREVOR_ID,        "bridgeworm",                  "MorphMonster"},
	["Chicken Ghost"]            = {TREVOR_ID,        "chicken ghost",               "MorphMonster"},
	["Costume Man"]              = {TREVOR_ID,        "costume man",                 "MorphMonster"},
	["Country Road Creature"]    = {TREVOR_ID,        "country road creature",       "MorphMonster"},
	["Day 17"]                   = {TREVOR_ID,        "day 17",                      "MorphMonster"},
	["Day 18"]                   = {TREVOR_ID,        "day 18",                      "MorphMonster"},
	["Forgotten Baby"]           = {TREVOR_ID,        "forgotten baby",              "MorphMonster"},
	["Ghost Pig"]                = {TREVOR_ID,        "ghost pig",                   "MorphMonster"},
	["Hole Man"]                 = {TREVOR_ID,        "hole man",                    "MorphMonster"},
	["Househead Minion"]         = {TREVOR_ID,        "househead minion",            "MorphMonster"},
	["Humanoid Rabbit"]          = {TREVOR_ID,        "humanoid rabbit",             "MorphMonster"},
	["Big Charlie"]              = {TREVOR_ID,        "big charlie",                 "MorphMonster"},
	["Highwayworm"]              = {TREVOR_ID,        "highwayworm",                 "MorphMonster"},
	["Hush"]                     = {TREVOR_ID,        "hush",                        "MorphMonster"},
	["Living House / Househead"] = {TREVOR_ID,        "living house / househead",    "MorphMonster"},
	["Househead V2"]             = {TREVOR_ID,        "living house / househead V2", "MorphMonster"},
	["Long Horse"]               = {TREVOR_ID,        "long horse",                  "MorphMonster"},
	["Milkwalker Ambassador"]    = {TREVOR_ID,        "milkwalker abassador",        "MorphMonster"},
	["Nervous Houseguest"]       = {TREVOR_ID,        "nervous houseguest",          "MorphMonster"},
	["OG Breaking News"]         = {TREVOR_ID,        "og breaking news",            "MorphMonster"},
	["Peeping Tom"]              = {TREVOR_ID,        "peeping tom",                 "MorphMonster"},
	["Ribbit"]                   = {TREVOR_ID,        "ribbit",                      "MorphMonster"},
	["Starliner Cinema"]         = {TREVOR_ID,        "starliner cinema",            "MorphMonster"},
	["Street Horse"]             = {TREVOR_ID,        "street horse",                "MorphMonster"},
	["The Angel"]                = {TREVOR_ID,        "the angel",                   "MorphMonster"},
	["Bird Watcher"]             = {98889092235451,   "",                            "BirdWatcher"},
	["Cartoon Sheep"]            = {98228164982337,   "Cartoon Sheep",               "MorphMonster"},
	["Cartoon Dog 2"]            = {TREVOR_ID,        "cartoon dog2",                "MorphMonster"},
	["Cartoon Mouse"]            = {TREVOR_ID,        "cartoon mouse",               "MorphMonster"},
	["Cartoon Cat"]              = {TREVOR_ID,        "cartoon cat",                 "MorphMonster"},
	["Cartoon Dog"]              = {TREVOR_ID,        "cartoon dog",                 "MorphMonster"},
	["OG Cartoon Cat"]           = {TREVOR_ID,        "og cartoon cat",              "MorphMonster"},
	-- ══════════════════════════════════════════════
	-- OTHERS / NON-TREVOR
	-- ══════════════════════════════════════════════
	["Unity 096"]                = {130962958730541,  "Unity 096",                   "MorphMonster"},
	["Adult Mimic"]              = {130962958730541,  "adultmimic",                  "MorphMonster"},
	["Elder Mimic"]              = {130962958730541,  "eldermimic",                  "MorphMonster"},
	["Aflock"]                   = {124073139418230,  "aflock",                      "MorphMonster"},
	["Bon The Rabbit"]           = {97139246600015,   "bontherabbit",                "MorphMonster"},
	["Cremator"]                 = {103731803308903,  "cremator",                    "MorphMonster"},
	["Floater"]                  = {124073139418230,  "floater",                     "MorphMonster"},
	["Grunt"]                    = {124073139418230,  "grunt",                       "MorphMonster"},
	["Pumpkin Rabbit"]           = {97139246600015,   "pumpkinrabbit",               "MorphMonster"},
	["Sergeant"]                 = {103731803308903,  "sergeant",                    "MorphMonster"},
	["Fast Handcrab"]            = {103731803308903,  "Fast Handcrab",               "MorphMonster"},
	["HL1 Headcrab"]             = {103731803308903,  "HL1 Headcrab",                "MorphMonster"},
	["Headcrab"]                 = {103731803308903,  "Headcrab",                    "MorphMonster"},
	["Poison Headcrab"]          = {99178462838548,   "Poison Headcrab",             "MorphMonster"},
	["Barney"]                   = {99178462838548,   "barney",                      "MorphMonster"},
	["Fast Zombie"]              = {103731803308903,  "fastzombie",                  "MorphMonster"},
	["Headcrab Zombie"]          = {99178462838548,   "headcrab zombie",             "MorphMonster"},
	["Poison Zombie"]            = {99178462838548,   "poison zombie",               "MorphMonster"},
	["Aka Manto"]                = {88521859208314,   "aka manto",                   "MorphMonster"},
	["Death Angel"]              = {88521859208314,   "death angel",                 "MorphMonster"},
	["Funny Friend"]             = {135943138749317,  "funny friend",                "MorphMonster"},
	["Horror"]                   = {88521859208314,   "horror",                      "MorphMonster"},
	["Schizophrenia"]            = {81713056915496,   "",                            "load"},
	["Schizophrenia V2"]         = {78098691505458,   "",                            "load"},
	["Shin Sonic"]               = {77055143496081,   "small shin",                  "MorphMonster"},
	["Big Shin"]                 = {77055143496081,   "shin sonic",                  "MorphMonster"},
	["Sonic.EYX"]                = {77055143496081,   "sonic.eyx",                   "MorphMonster"},
	["SCP-049"]                  = {70922780816825,   "scp-049",                     "MorphMonster"},
	["SCP-1499-1"]               = {70922780816825,   "scp-1499-1",                  "MorphMonster"},
	["SCP-178-1"]                = {70922780816825,   "scp-178-1",                   "MorphMonster"},
	["SCP-2427-3"]               = {70922780816825,   "scp-2427-3",                  "MorphMonster"},
	["SCP-966"]                  = {70922780816825,   "scp-966",                     "MorphMonster"},
	["SCP-096"]                  = {70922780816825,   "scp096",                      "MorphMonster"},
	["SCP-106"]                  = {70922780816825,   "scp106",                      "MorphMonster"},
	["SCP-457"]                  = {70922780816825,   "scp457",                      "MorphMonster"},
	["SCP-682"]                  = {70922780816825,   "scp682",                      "MorphMonster"},
	["SCP-860-1"]                = {70922780816825,   "scp860-1",                    "MorphMonster"},
	["SCP-939 Original"]         = {70922780816825,   "scp939original",              "MorphMonster"},
	["SCP-096 B"]                = {109044049581210,  "scp096b",                     "MorphMonster"},
	["SCP-096 Comix"]            = {109044049581210,  "scp096comix",                 "MorphMonster"},
	["SCP-096 Reskin"]           = {109044049581210,  "scp096reskin",                "MorphMonster"},
	["Craig"]                    = {125375466492613,  "craig",                       "MorphMonster"},
	-- Cry of Fear
	["Saw Crazy"]                = {114287881125205,  "",                            "load"},
	["Citalopram"]               = {73416410522537,   "",                            "load"},
	["Faceless"]                 = {102798848281487,  "faceless",                    "MorphMonster"},
	["Faster"]                   = {121053606797327,  "",                            "load"},
	["Sawrunner"]                = {129884414175186,  "",                            "load"},
	["Taller"]                   = {128295083288420,  "",                            "load"},
	["Deathclaw"]                = {125375466492613,  "deathclaw",                   "MorphMonster"},
	["Ethre"]                    = {125375466492613,  "ethre",                       "MorphMonster"},
	["Fleshgait"]                = {125375466492613,  "fleshgait",                   "MorphMonster"},
	["Freddy Krueger"]           = {125375466492613,  "freddy kruegar",              "MorphMonster"},
	["Fresno Nightcrawler"]      = {125375466492613,  "fresno nightcrawler",         "MorphMonster"},
	["Goatman"]                  = {125375466492613,  "goatman",                     "MorphMonster"},
	["Insanity"]                 = {125375466492613,  "insanity",                    "MorphMonster"},
	["Kate"]                     = {125375466492613,  "kate",                        "MorphMonster"},
	["Memphis Tennessee"]        = {125375466492613,  "memphis tennassee",           "MorphMonster"},
	["Prettyface"]               = {125375466492613,  "prettyface",                  "MorphMonster"},
	["Rake"]                     = {125375466492613,  "rake",                        "MorphMonster"},
	["Richard Boderman"]         = {125375466492613,  "richard boderman",            "MorphMonster"},
	["Skinwalker"]               = {125375466492613,  "skinwalker",                  "MorphMonster"},
	["Walking Mask"]             = {125375466492613,  "walking mask",                "MorphMonster"},
	["Guilt"]                    = {81546506083878,   "guilt",                       "MorphMonster"},
	["Locust"]                   = {81546506083878,   "locust",                      "MorphMonster"},
	["Organator"]                = {81546506083878,   "organator",                   "MorphMonster"},
	["The Boiled One/Phen"]      = {81546506083878,   "phen",                        "MorphMonster"},
	["Old Scopophobia 096"]      = {121587930899191,  "Old scopophobia 096",         "MorphMonster"},
	["Scopophobia 096"]          = {121587930899191,  "Scopophobia 096",             "MorphMonster"},
	["SCP-939"]                  = {121587930899191,  "scp939",                      "MorphMonster"},
	["Bart"]                     = {104855627773091,  "bart",                        "MorphMonster"},
	["Bloodbath"]                = {104855627773091,  "bloodbath",                   "MorphMonster"},
	["Cybot"]                    = {104855627773091,  "cybot",                       "MorphMonster"},
	["Ghostborn"]                = {104855627773091,  "ghostborn",                   "MorphMonster"},
	["Jaguar"]                   = {104855627773091,  "jaguar",                      "MorphMonster"},
	["Soul"]                     = {104855627773091,  "soul",                        "MorphMonster"},
	["Suitborn"]                 = {104855627773091,  "suitborn",                    "MorphMonster"},
	["Antlion Alyx"]             = {97331759261813,   "antlionalyx",                 "MorphMonster"},
	["Antlion Guard"]            = {97331759261813,   "antlionguard",                "MorphMonster"},
	["Fast Zombie (HL2)"]        = {97331759261813,   "fastzombie",                  "MorphMonster"},
	["Gargantua"]                = {97331759261813,   "gargantua",                   "MorphMonster"},
	["Grunt (HL)"]               = {97331759261813,   "grunt",                       "MorphMonster"},
	["HL2 Barnacle"]             = {97331759261813,   "hl2barnacle",                 "MorphMonster"},
	["HL2 Hunter"]               = {97331759261813,   "hl2hunter",                   "MorphMonster"},
	["Poison Zombie (HL2)"]      = {97331759261813,   "poison zombie",               "MorphMonster"},
	["Strider"]                  = {97331759261813,   "strider",                     "MorphMonster"},
	["Vortigaunt"]               = {97331759261813,   "vortigaunt",                  "MorphMonster"},
	["Gonome"]                   = {103731803308903,  "gonome",                      "MorphMonster"},
	["HL1 Houndeye"]             = {103731803308903,  "hl1houndeye",                 "MorphMonster"},
	["Mr. Friendly"]             = {103731803308903,  "mr friendly",                 "MorphMonster"},
	["Tentacle"]                 = {103731803308903,  "tentaclev2",                  "MorphMonster"},
	["Gonarch"]                  = {102798848281487,  "gonarch",                     "MorphMonster"},
	["boid"]                     = {86528803321296,   "boid",                        "MorphMonster"},
	["crasher"]                  = {134835962035545,  "crasher",                     "MorphMonster"},
	["Howler"]                   = {133979395693622,  "howler",                      "MorphMonster"},
	["SCP-049 V2"]               = {130438841675828,  "scp-049",                     "MorphMonster"},
	["SCP-1499-1 V2"]            = {130438841675828,  "scp-1499-1",                  "MorphMonster"},
	["SCP-178-1 V2"]             = {130438841675828,  "scp-178-1",                   "MorphMonster"},
	["SCP-2427-3 V2"]            = {130438841675828,  "scp-2427-3",                  "MorphMonster"},
	["SCP-966 V2"]               = {130438841675828,  "scp-966",                     "MorphMonster"},
	["SCP-096 V2"]               = {130438841675828,  "scp096",                      "MorphMonster"},
	["SCP-106 V2"]               = {130438841675828,  "scp106",                      "MorphMonster"},
	["SCP-457 V2"]               = {130438841675828,  "scp457",                      "MorphMonster"},
	["SCP-682 V2"]               = {130438841675828,  "scp682",                      "MorphMonster"},
	["SCP-860-1 V2"]             = {130438841675828,  "scp860-1",                    "MorphMonster"},
	["SCP-939 Original V2"]      = {130438841675828,  "scp939original",              "MorphMonster"},
	["Catnap"]                   = {139111114772425,  "catnap",                      "MorphMonster"},
	["Huggy Wuggy"]              = {139111114772425,  "huggy wuggy",                 "MorphMonster"},
	["Hunter"]                   = {139111114772425,  "hunter",                      "MorphMonster"},
	["Killy Willy"]              = {110475955009271,  "Killy Willy",                 "MorphMonster"},
	["Marshmallow Huggy"]        = {110475955009271,  "Marshmallow Huggy",           "MorphMonster"},
	["Prototype"]                = {73755486018996,   "Prototype",                   "MorphMonster"},
	["Split"]                    = {6228948850,        "",                            "load"},
	["Caducus"]                  = {5686002742,        "caducus",                    "Fire"},
	["Voidman"]                  = {5448300595,        "",                            "load"},
	["Spider Queen"]             = {113277656483754,   "",                            "BirdWatcher"},
	["Aranea Membri"]            = {127137844503241,  "Aranea Membri",               "MorphMonster"},
	["Bacteria"]                 = {127137844503241,  "bacteria",                    "MorphMonster"},
	["Deformed Howler"]          = {127137844503241,  "deformedhowler",              "MorphMonster"},
	["Neighborhood Watch"]       = {127137844503241,  "neighborhood watch",          "MorphMonster"},
	["Skinstealer"]              = {127137844503241,  "skinstealer",                 "MorphMonster"},
	["Smiler"]                   = {127137844503241,  "smiler",                      "MorphMonster"},
	["Starfish"]                 = {113986863695527,  "starfish",                    "MorphMonster"},
	["Stalker"]                  = {101962368700042,   "",                            "BirdWatcher"},
	["LC Jester"]                = {110306212034916,   "",                            "Init"},
	["Roaring Knight"]           = {134010721518596,   "",                            "LoadCap"},
	["Stukabat"]                 = {134996769430684,   "",                            "BirdWatcher"},
	["Error Demogorgen"]         = {99939256152642,   "",                            "load"},
	["Demogorgen (Idk Version)"] = {138169667330335,  "",                            "load"},
	["Demogorgen Version 3"]     = {85309903566753,   "",                            "load"},
	["Demogorgen v3 (Ink Variant)"] = {100262723848810,"",                           "load"},
	["Mysterious Sonic"]         = {132667025141532,  "",                            "MorphPlayer"},
	["SCP-610-1"]                = {139103150623291,  "scp 610-1",                   "MorphMonster"},
	["SCP-610-2"]                = {139103150623291,  "scp 610-2",                   "MorphMonster"},
	["SCP-610-3"]                = {139103150623291,  "scp 610-3",                   "MorphMonster"},
	["SCP-610-4"]                = {139103150623291,  "scp 610-4",                   "MorphMonster"},
	["SCP-610-5"]                = {139103150623291,  "scp 610-5",                   "MorphMonster"},
	["SCP-610-6"]                = {139103150623291,  "scp 610-6",                   "MorphMonster"},
	["SCP-610-7"]                = {139103150623291,  "scp 610-7",                   "MorphMonster"},
	["SCP-610-8"]                = {139103150623291,  "scp 610-8",                   "MorphMonster"},
	["Cloth Wanderer (087)"]     = {115201570183639,  "clothwanderer - 087",         "MorphMonster"},
	["Eye Killer (087)"]         = {115201570183639,  "eyekiller - 087",             "MorphMonster"},
	["Masked Man (087)"]         = {115201570183639,  "maskedman - 087",             "MorphMonster"},
	["Red Mist Monster (087)"]   = {115201570183639,  "redmistmonster - 087",        "MorphMonster"},
	-- Pillar Chase
	["mario.exe"]                = {126059778738629,  "",                            "load"},
	["Ao Oni"]                   = {139305717815487,  "",                            "load"},
	["Inkfell"]                  = {140659312060143,  "",                            "load"},
	["fuwattie"]                 = {132316983668446,  "",                            "load"},
	["fogborn"]                  = {138705805410090,  "",                            "load"},
	["jeffery wood"]             = {107756147819635,  "",                            "load"},
	["tinky"]                    = {81908602269802,   "",                            "load"},
	["smiley"]                   = {76516416928920,   "",                            "load"},
	["samsung"]                  = {133082072511615,  "",                            "load"},
	["wyst"]                     = {138573243359456,  "",                            "load"},
	["bramble"]                  = {116753685690238,  "Lanternhead",                 "MorphMonster"},
	["Realism Death Angel"]      = {140353745285461,  "death angel",                 "MorphMonster"},
	-- Die of Death
	["Pursuer"]                  = {123509624766470,  "Pursuer",                     "DOD"},
	["Killdroid"]                = {123509624766470,  "Killdroid",                   "DOD"},
	["Badware"]                  = {123509624766470,  "Badware",                     "DOD"},
	["Harken"]                   = {123509624766470,  "Harken",                      "DOD"},
	["Artful"]                   = {123509624766470,  "Artful",                      "DOD"},
	["Paranoy"]                  = {123509624766470,  "Paranoy",                     "DOD"},
	-- FNAF
	["junkyard foxy"]            = {134749539058427,  "foxy",                        "MorphMonster"},
	["The Entity"]               = {12487132086,      "",                            "DirectCall"},
	["Golden Freddy"]            = {13798449568,      "",                            "DirectCall"},
	["Mimic"]                    = {87018700981612,   "Mimic",                       "MorphMonster"},
	["Ruin Mimic"]               = {126137936491365,  "Ruin Mimic",                  "MorphMonster"},
	-- Others
	["Green"]                    = {89235764665856,   "Green",                       "MorphMonster"},
}

local morphingPlayers = {}
local givenTo         = {}
local unlockedPlayers = {}
local playerMorphs    = {}

local triggerPart = script.Parent
script.Parent = ServerScriptService

-- ============================================
-- FEATURED MORPH SYSTEM
-- ============================================
-- Rotates every 12 hours, deterministic across all servers
-- using os.time() so every server picks the same morph.
local FEATURED_DURATION = 12 * 3600 -- 12 hours in seconds

-- Build a sorted list of morph names for deterministic indexing
local morphNamesList = {}
for name, _ in pairs(MORPHS) do
	table.insert(morphNamesList, name)
end
table.sort(morphNamesList)

local cachedFeaturedPeriod = -1
local cachedFeaturedName   = ""

local function getFeaturedMorph()
	local period = math.floor(os.time() / FEATURED_DURATION)
	if period ~= cachedFeaturedPeriod then
		cachedFeaturedPeriod = period
		-- Simple deterministic hash: multiply period by a prime, mod by list size
		local index = ((period * 7919) % #morphNamesList) + 1
		cachedFeaturedName = morphNamesList[index]
		print("[MorphGUI] Featured morph rotated to:", cachedFeaturedName)
	end
	return cachedFeaturedName
end

local function getTimeUntilNextFeatured()
	return FEATURED_DURATION - (os.time() % FEATURED_DURATION)
end

-- Initialize on server start
getFeaturedMorph()

-- Remote: clients ask for the current featured morph
getFeaturedFunc.OnServerInvoke = function(_player)
	local name = getFeaturedMorph()
	local timeLeft = getTimeUntilNextFeatured()
	return name, timeLeft
end

-- Background loop: check for rotation and notify all clients
task.spawn(function()
	while true do
		local sleepTime = getTimeUntilNextFeatured() + 1
		task.wait(sleepTime)
		local newName = getFeaturedMorph()
		local newTimeLeft = getTimeUntilNextFeatured()
		for _, player in ipairs(Players:GetPlayers()) do
			featuredUpdatedEvent:FireClient(player, newName, newTimeLeft)
		end
	end
end)

-- ============================================
-- PRIVATE MODULE DETECTION
-- ============================================
local function isPrivateError(err)
	if not err then return false end
	local s = tostring(err):lower()
	return s:find("private") or s:find("access denied") or
		s:find("restricted") or s:find("not authorized") or
		s:find("module was filtered") or s:find("cannot load")
end

-- ============================================
-- REMOTE HANDLERS
-- ============================================
isUnlockedFunc.OnServerInvoke = function(player)
	return unlockedPlayers[player.UserId] == true
end

local CORRECT_CODE = "chadisthebest"

notifyUnlockEvent.OnServerEvent:Connect(function(player, code)
	if type(code) ~= "string" then return end
	if code:gsub("%s",""):lower() ~= CORRECT_CODE then return end
	unlockedPlayers[player.UserId] = true
	print("[MorphGUI] Unlocked for", player.Name)
end)

resetMorphEvent.OnServerEvent:Connect(function(player)
	if morphingPlayers[player.UserId] then return end
	morphingPlayers[player.UserId] = true
	pcall(function() require(3436957371):r6(player.Name) end)
	task.wait(0.5)
	morphingPlayers[player.UserId] = nil
	print("[MorphGUI] Reset morph for", player.Name)
end)

-- ============================================
-- TINKY TELEPORT
-- ============================================
tinkyTeleportEvent.OnServerEvent:Connect(function(player)
	if playerMorphs[player.UserId] ~= "tinky" then return end
	local targets = {}
	for _, other in ipairs(Players:GetPlayers()) do
		if other == player then continue end
		local char = other.Character
		if not char then continue end
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not hum or hum.Health <= 0 then continue end
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if not hrp then continue end
		table.insert(targets, {player = other, hrp = hrp})
	end
	if #targets == 0 then return end
	local target  = targets[math.random(1, #targets)]
	local tinkyChar = player.Character
	if not tinkyChar then return end
	local tinkyHRP = tinkyChar:FindFirstChild("HumanoidRootPart")
	if not tinkyHRP then return end
	tinkyHRP.CFrame = target.hrp.CFrame * CFrame.new(0, 0, -3)
	tinkyJumpscareEvent:FireClient(target.player)
	print("[MorphGUI] Tinky teleported", player.Name, "→", target.player.Name)
end)

-- ============================================
-- INJECTION
-- ============================================
local function injectScript(player)
	local pg = player:FindFirstChildOfClass("PlayerGui")
	if not pg then return end
	local old = pg:FindFirstChild("MorphGuiReborn_Holder")
	if old then old:Destroy() end
	local ls = script:FindFirstChildOfClass("LocalScript")
	if not ls then warn("[MorphGUI] LocalScript template missing!") return end
	local holder = Instance.new("ScreenGui")
	holder.Name = "MorphGuiReborn_Holder"
	holder.ResetOnSpawn = false
	holder.Enabled = false
	holder.DisplayOrder = 0
	holder.Parent = pg
	local clone = ls:Clone()
	clone.Name = "MorphGuiReborn_LS"
	clone.Disabled = false
	clone.Parent = holder
	print("[MorphGUI] Script injected for", player.Name)
end

local function setupPlayer(player)
	player.CharacterAdded:Connect(function()
		if not givenTo[player.UserId] then return end
		task.wait(3)
		injectScript(player)
	end)
end

for _, p in ipairs(Players:GetPlayers()) do setupPlayer(p) end
Players.PlayerAdded:Connect(setupPlayer)

Players.PlayerRemoving:Connect(function(player)
	givenTo[player.UserId]         = nil
	morphingPlayers[player.UserId] = nil
	unlockedPlayers[player.UserId] = nil
	playerMorphs[player.UserId]    = nil
end)

-- ============================================
-- TRIGGER
-- ============================================
triggerPart.Touched:Connect(function(hit)
	if not hit or not hit.Parent then return end
	local character = hit.Parent
	if not character:FindFirstChildOfClass("Humanoid") then return end
	local player = Players:GetPlayerFromCharacter(character)
	if not player then return end
	if givenTo[player.UserId] then return end
	givenTo[player.UserId] = true
	injectScript(player)
end)

-- ============================================
-- MORPH REQUEST
-- ============================================
morphRequestEvent.OnServerEvent:Connect(function(player, morphName)
	if morphingPlayers[player.UserId] then return end

	local data = MORPHS[morphName]
	if not data then
		morphCompleteEvent:FireClient(player, false, morphName)
		return
	end

	if data[3] == "LoadCap" and playerMorphs[player.UserId] == "Roaring Knight" then
		morphCompleteEvent:FireClient(player, false, morphName)
		return
	end

	morphingPlayers[player.UserId] = true

	local moduleId = data[1]
	local tag      = data[2]
	local func     = data[3]
	local plrName  = player.Name

	playerMorphs[player.UserId] = morphName

	pcall(function() require(3436957371):r6(plrName) end)
	task.wait(morphName == "Split" and 2.0 or 0.8)

	local ok, err = pcall(function()
		if func == "MorphMonster" then
			require(moduleId).MorphMonster(plrName, tag)
		elseif func == "DOD" then
			require(moduleId)[tag](plrName)
		elseif func == "DirectCall" then
			require(moduleId)(plrName)
		elseif func == "load" then
			require(moduleId).load(plrName)
		elseif func == "MorphPlayer" then
			require(moduleId).MorphPlayer(plrName)
		elseif func == "Fire" then
			require(moduleId):Fire(plrName, tag)
		elseif func == "Init" then
			require(moduleId):Init(plrName)
		elseif func == "LoadCap" then
			require(moduleId).Load(plrName)
		elseif func == "BirdWatcher" then
			local morph = require(moduleId):Clone()
			morph.HumanoidRootPart.Anchored   = true
			morph.HumanoidRootPart.CFrame     = player.Character.HumanoidRootPart.CFrame
			morph.HumanoidRootPart.CanCollide = false
			if morph:FindFirstChild("Head") then
				morph.Head.CanCollide = false
				morph.Head.Massless   = true
			end
			player.Character = morph
			morph.Parent = workspace
			task.wait(0.5)
			morph.HumanoidRootPart.Anchored = false
		end
	end)

	task.wait(0.5)

	if not ok and isPrivateError(err) then
		morphPrivateEvent:FireClient(player, morphName)
		print("[MorphGUI] Private module detected for", morphName, "—", tostring(err))
	elseif not ok then
		morphCompleteEvent:FireClient(player, false, morphName)
		print("[MorphGUI] Morph failed for", morphName, "—", tostring(err))
	else
		morphCompleteEvent:FireClient(player, true, morphName)
	end

	if func ~= "LoadCap" then
		morphingPlayers[player.UserId] = nil
	end

	if morphName == "tinky" then
		task.spawn(function()
			task.wait(14)
			if playerMorphs[player.UserId] == "tinky" then
				tinkyReadyEvent:FireClient(player)
			end
		end)
	end
end)

-- ============================================
-- STRICK WATCHER
-- ============================================
local function handleStrick(strickModel)
	local marker = Instance.new("Script")
	marker.Name    = "Tabillity"
	marker.Enabled = false
	marker.Parent  = strickModel
	for _, p in ipairs(Players:GetPlayers()) do
		if playerMorphs[p.UserId] == "tinky" then
			tinkyReadyEvent:FireClient(p)
		end
	end
end

for _, child in ipairs(workspace:GetChildren()) do
	if child.Name == "strick" then handleStrick(child) end
end
workspace.ChildAdded:Connect(function(child)
	if child.Name == "strick" then handleStrick(child) end
end)

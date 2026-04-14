-- LOCAL SCRIPT - Place UNDER the server Script, set Disabled = true

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

print("[MorphGUI] Script started for", player.Name)

local remoteFolder = ReplicatedStorage:WaitForChild("MorphGuiRemotes", 15)
if not remoteFolder then print("[MorphGUI] ERROR: remotes not found") return end
local morphRequestEvent = remoteFolder:WaitForChild("MorphRequest", 15)
if not morphRequestEvent then print("[MorphGUI] ERROR: MorphRequest not found") return end
local notifyUnlockEvent = remoteFolder:WaitForChild("NotifyUnlock", 15)
if not notifyUnlockEvent then print("[MorphGUI] ERROR: NotifyUnlock not found") return end
local isUnlockedFunc    = remoteFolder:WaitForChild("IsUnlocked", 15)
if not isUnlockedFunc then print("[MorphGUI] ERROR: IsUnlocked not found") return end
local resetMorphEvent   = remoteFolder:WaitForChild("ResetMorph", 15)
if not resetMorphEvent then print("[MorphGUI] ERROR: ResetMorph not found") return end
local tinkyTeleportEvent  = remoteFolder:WaitForChild("TinkyTeleport", 15)
if not tinkyTeleportEvent then print("[MorphGUI] ERROR: TinkyTeleport not found") return end
local tinkyJumpscareEvent = remoteFolder:WaitForChild("TinkyJumpscare", 15)
if not tinkyJumpscareEvent then print("[MorphGUI] ERROR: TinkyJumpscare not found") return end
local morphCompleteEvent  = remoteFolder:WaitForChild("MorphComplete",  15)
if not morphCompleteEvent  then print("[MorphGUI] ERROR: MorphComplete not found")  return end
local morphPrivateEvent   = remoteFolder:WaitForChild("MorphPrivate",   15)
if not morphPrivateEvent   then print("[MorphGUI] ERROR: MorphPrivate not found")   return end
local getFeaturedFunc    = remoteFolder:WaitForChild("GetFeaturedMorph", 15)
local featuredUpdatedEvt = remoteFolder:WaitForChild("FeaturedMorphUpdated", 15)
print("[MorphGUI] Remotes OK")

local isUnlocked = isUnlockedFunc:InvokeServer()
print("[MorphGUI] isUnlocked from server:", isUnlocked)

local screen = nil

local CORRECT_CODE = "chadisthebest"

local C_ACCENT  = Color3.fromRGB(30,100,220)
local C_DARK    = Color3.fromRGB(15,60,160)
local C_BG      = Color3.fromRGB(10,12,22)
local C_BTN     = Color3.fromRGB(18,22,40)
local C_HOV     = Color3.fromRGB(30,100,220)
local C_SEL     = Color3.fromRGB(20,70,160)
local C_STROKE  = Color3.fromRGB(40,60,120)
local C_TEXT    = Color3.fromRGB(220,230,255)
local C_SUB     = Color3.fromRGB(100,120,180)
local C_RED     = Color3.fromRGB(180,30,30)
local C_TAB_ON  = Color3.fromRGB(30,100,220)
local C_TAB_OFF = Color3.fromRGB(18,22,40)
local C_PANEL   = Color3.fromRGB(8,11,20)
local C_GREEN   = Color3.fromRGB(30,160,80)
local C_GOLD    = Color3.fromRGB(255,200,50)
local C_GOLD_DK = Color3.fromRGB(180,140,30)

-- ============================================
-- MORPH INFO TABLE
-- Only Bacteria has a real entry. All others get the default.
-- ============================================
local DEFAULT_IMAGE = ""   -- blank
local DEFAULT_DESC  = "No description yet!"

local MORPH_INFO = {
	["Bacteria"] = {
		image = "rbxassetid://106821108400971",
		desc  = "The creature that resides on level 0, known for its wavy bacteria body its extremely deadly and encounters with it result in a fatal end. Its arms capeable of lifting tons its not a laughing matter.",
	},
	["Neighborhood Watch"] = {
		image = "rbxassetid://74934160414524",
		desc  = "Entity 96, also referred to as The Neighborhood Watch, consists of human eye-like entities predominantly found in Level 9 of the Backrooms. While occasionally spotted wandering near the borders of Level 9, they never intentionally cross into other levels.\n\nThese entities possess keen sight and touch but lack hearing and smell. They don't require food to survive and have never been seen consuming any.\n\nThe Neighborhood Watch is an exceptionally dangerous entity due to its aggressive behaviors towards any encountered living beings. The cause of this aggression remains unknown. If you happen to be spotted by The Neighborhood Watch, it's advisable to leave the level promptly.\n\nThey are also known to intentionally interfere with video and image recordings, causing static disruptions, and have the ability to destroy electronic devices by staying in proximity.",
	},
	["Aranea Membri"] = {
		image = "rbxassetid://129020642895675",
		desc  = "Aranea Membri, also known as Spider Legs, are a hostile entity inhabiting the Backrooms. They are distinguished by oftentimes taking residence in the ceilings of levels they inhabit, utilizing it as a method of ambushing prey. Aranea Membri are large spider-like entities, attaining a quadrupedal stance with several sharp, featureless limbs. Aranea Membri bear faces resembling what appears to be some sort of carnivoran skull. Although their hostility and extreme speed make them difficult to observe closely, current estimates and autopsies put their average height at around seven feet 8 (21 decimetres) and their length at around eight feet (24 decimetres). The entity's black skin appears to be made of a solidified version of Niralola Black, allowing them to melt or disappear into dark areas. In addition, as the entity walks, it makes a loud metallic clanking sound. Although the origin of this is unknown, it is extremely helpful for wanderers seeking to avoid these entities.\n\nThese entities are highly predatory and are known to pursue and attack humans on sight. As such, they should be avoided whenever possible. Aranea Membri seem to nest in empty, dark spaces above the roofs of many levels within the Backrooms, waiting for other entities or humans to approach their location (the entity's so-called stalking stage). How it knows the approach of other beings is unknown, but it is currently believed that it uses a highly developed sense of hearing to do so. Once prey is nearby, it opens up a hole in the ceiling and emerges to pursue its prey.\n\nAfter the entity leaves its hole in the ceiling, it then enters what is labeled as its hunting stage. Upon finding its prey (often immediately after emerging), the Aranea Membri will begin a pursuit, attempting to trample wanderers under its limbs. When hunting, Aranea Membri can reach speeds of up to 50 mph when hunting, which it uses to its advantage (albeit it is only able to reach these speeds within long, straight hallways). Aranea Membri can also use their momentum to knock over obstacles, break down walls, or instantly crush their target. After a successful hunt, these entities will drag their victim through the hole from which they emerged and will disappear from view into the darkness.\n\nThese entities appear to have a lowered intelligence, as they often forget about prey if it eludes them for long enough.",
	},
	["Breaking News"] = {
		image = "rbxassetid://135904571736210",
		desc  = "Breaking News depicts a terrifyingly tall creature with a vaguely humanoid appearance, although somewhat twisted and disfigured. Its entire body is covered in what appears to be jet-black skin that has difficulty reflecting light off of it. This strange skin encompasses the creature's whole twisted body, head-to-toe.\n\nThe legs and torso of the creature is rather similar to that of a human's, just without certain features like hair. It does appear to posses a slightly thin and possibly malnourished physique, as some of its ribs slightly make a mark on the creature's sides and the legs seem quite thin and short, when compared to the proportions of a person, that is.\n\nThe creature's arms are also hairless and covered with its strangely-colored skin. However, what makes this creature's arms unique is that they actually reach all the way down to the ground, covering most the height of its entire body, making a stark contrast between its short legs. These arms also seem to be much skinnier than even the beast's legs, but it does have slightly large forearms.\n\nFinally, the most iconic and interesting part of this Giant is its crooked head and twisted neck. The neck is a few times longer than it should be, which makes it bend slightly backwards and forwards in any direction, which leads it to have its infamously crooked head, always leaning and drooping downwards. The head itself is also completely featureless; no mouth, eyes, ears, hair, nose or anything.\n\nThe behavior of Breaking News is not very well-known, theres only 2 known images of the creature, which don't have very informative captions. But due to it being confirmed to be a member of The Giants, we can however make assumptions on its behavior based on what we know about other Giants.\n\nFirst of all, Breaking News is almost certainly a Destruction Giant. The creature is not nearly tall enough to pierce the skies and bring worthy people to salvation. It also does not posses any extendable tendrils or strings which would help it do the aforementioned task. It is also noteworthy that it is a humanoid Giant, and Giants of this body type are almost never Collection Giants.\n\nSince this is the case, we assume that it merely wanders about, looking for any cities or human settlements it can find in order to destroy it, and kill any people it deems sinful or unworthy, while sparing the rest to be collected by other Giants like The Wandering Faith or Remain Indoors. From the images we've seen of it, the creature seems to prefer to stay still in one place for extended periods of time, almost looking at rest, unlike other Giants who were photographed while on the move or doing something. The reason behind this strange behavior is unknown. It is possible that the creature is actually asleep during these images, which would make sense since it would be easier to take a good picture of it when it is sleeping. This is further backed up by the fact that all the images of it are taken during nighttime.\n\nWhether or not the creature requires other sustenance like food and water to survive is unknown, but it is unlikely that it does since most other Giants do not display any reliance on necessities, nor do they seek them. The creature's massive size would easily allow it to cause mass destruction on a city-wide scale, especially since it has human-like hands to grab people or to demolish buildings. Its humanoid body structure would also help it to be a rather fast creature when running. It could also crawl on all fours for additional speed, though it seems it prefers to walk as a biped. Its jet black skin would also somewhat camouflage it with the night sky, hiding the creature in plain sight while it is asleep.\n\nLike most Giants, this creature is able to function properly despite not possessing any eyes or other normal senses, so it is possible that it also has some sort of additional supernatural or enhanced senses. This may also imply it has some sort of echolocation ability.\n\nThere is a theory which suggests that Breaking News and The Giant With Red Dots are actually the same creature. If this is true (which is very likely, given the numerous similarities they share), then Breaking News would also have the capability to create red glowing lights on its torso to further disorient its victims, which would make it a great way to stun and distract a victim's mind.",
	},
	["Milkwalker Ambassador"] = {
		image = "rbxassetid://84464011901566",
		desc  = "The Milkwalker Ambassador is a strange-looking creature of big size. It has similar arms and legs to Siren Head. The only features it doesn't share with Siren head are it's torso and head. It's torso is practically non-existent and, hence it's name, it has a milk carton for a head.",
	},
}

local function getMorphInfo(name)
	local info = MORPH_INFO[name]
	if info then
		return info.image, info.desc
	end
	return DEFAULT_IMAGE, DEFAULT_DESC
end

-- ============================================
-- MORPH LIST
-- ============================================
local MORPH_NAMES = {
	"Ice Siren Head","Blood Siren Head","Dark Siren Head","Shadow Siren Head",
	"Trafficlight Head","Wood Siren Head","Unity 096","Adult Mimic","Elder Mimic",
	"Aflock","Bon The Rabbit","Cremator","Floater","Grunt","Pumpkin Rabbit","Sergeant",
	"Anxious Dog","Bonesworth","Breaking News","Bridgeworm","Chicken Ghost",
	"Costume Man","Country Road Creature","Day 17","Day 18","Forgotten Baby",
	"Ghost Pig","Hole Man","Househead Minion","Humanoid Rabbit",
	"Big Charlie","Highwayworm","Hush","Living House / Househead","Househead V2",
	"Long Horse","Milkwalker Ambassador","Nervous Houseguest","OG Breaking News",
	"Peeping Tom","Ribbit","Starliner Cinema","Street Horse","The Angel",
	"Fast Handcrab","HL1 Headcrab","Headcrab","Poison Headcrab",
	"Barney","Fast Zombie","Headcrab Zombie","Poison Zombie",
	"Aka Manto","Death Angel","Funny Friend","Horror",
	"Schizophrenia","Schizophrenia V2","Shin Sonic","Big Shin","Sonic.EYX",
	"SCP-049","SCP-1499-1","SCP-178-1","SCP-2427-3","SCP-966",
	"SCP-096","SCP-106","SCP-457","SCP-682","SCP-860-1","SCP-939 Original",
	"SCP-096 B","SCP-096 Comix","SCP-096 Reskin",
	"Craig","Deathclaw","Ethre","Fleshgait","Freddy Krueger",
	"Fresno Nightcrawler","Goatman","Insanity","Kate","Memphis Tennessee",
	"Prettyface","Rake","Richard Boderman","Skinwalker","Walking Mask",
	"Light Siren Head","Banana Eater","Guilt","Locust","Organator","The Boiled One/Phen",
	"Old Scopophobia 096","Scopophobia 096","SCP-939",
	"Bart","Bloodbath","Cybot","Ghostborn","Jaguar","Soul","Suitborn",
	"Antlion Alyx","Antlion Guard","Fast Zombie (HL2)","Gargantua","Grunt (HL)",
	"HL2 Barnacle","HL2 Hunter","Poison Zombie (HL2)","Strider","Vortigaunt",
	"Gonome","HL1 Houndeye","Mr. Friendly","Tentacle","Gonarch","boid","crasher",
	"OG Siren Head","Shadow Siren Head V2","Siren Head","Siren Head 2","The Extra Slide","The Hugger",
	"God of Roadkill","Good Boy","Mothman","Scribble Head","The Lamb","Yoyo","Cartoon Sheep",
	"Howler",
	"Aranea Membri","Bacteria","Deformed Howler","Neighborhood Watch","Skinstealer","Smiler","Starfish",
	"SCP-049 V2","SCP-1499-1 V2","SCP-178-1 V2","SCP-2427-3 V2","SCP-966 V2",
	"SCP-096 V2","SCP-106 V2","SCP-457 V2","SCP-682 V2","SCP-860-1 V2","SCP-939 Original V2",
	"Error Demogorgen","Demogorgen (Idk Version)","Mysterious Sonic","Demogorgen Version 3","Demogorgen v3 (Ink Variant)",
	"Cartoon Dog 2","Cartoon Mouse","Boxy Boo","Cartoon Cat","Cartoon Dog",
	"Catnap","Huggy Wuggy","Hunter","OG Cartoon Cat","Killy Willy","Marshmallow Huggy","Prototype",
	"SCP-610-1","SCP-610-2","SCP-610-3","SCP-610-4",
	"SCP-610-5","SCP-610-6","SCP-610-7","SCP-610-8",
	"Cloth Wanderer (087)","Eye Killer (087)","Masked Man (087)","Red Mist Monster (087)",
	"Split","Caducus","Voidman","Bird Watcher","Spider Queen","Stukabat","LC Jester","Roaring Knight",
	"Saw Crazy","Citalopram","Faceless","Faster","Sawrunner","Taller",
	"mario.exe","Ao Oni","Inkfell","fuwattie","fogborn","jeffery wood","tinky","smiley","samsung","wyst",
	"bramble",
	"Realism Death Angel",
	"Pursuer","Killdroid","Badware","Harken","Artful","Paranoy",
	"junkyard foxy","The Entity","Golden Freddy","Mimic","Ruin Mimic",
	"Green",
}

-- ============================================
-- CATEGORY LOOKUP
-- ============================================
local TREVOR_HENDERSON = {
	["Ice Siren Head"]        = true, ["Blood Siren Head"]      = true,
	["Dark Siren Head"]       = true, ["Shadow Siren Head"]     = true,
	["Trafficlight Head"]     = true, ["Wood Siren Head"]       = true,
	["Light Siren Head"]      = true, ["OG Siren Head"]         = true,
	["Shadow Siren Head V2"]  = true, ["Siren Head"]            = true,
	["Siren Head 2"]          = true, ["Banana Eater"]          = true,
	["The Extra Slide"]       = true, ["The Hugger"]            = true,
	["God of Roadkill"]       = true, ["Good Boy"]              = true,
	["Mothman"]               = true, ["Scribble Head"]         = true,
	["The Lamb"]              = true, ["Yoyo"]                  = true,
	["Anxious Dog"]           = true, ["Bonesworth"]            = true,
	["Breaking News"]         = true, ["Bridgeworm"]            = true,
	["Chicken Ghost"]         = true, ["Costume Man"]           = true,
	["Country Road Creature"] = true, ["Day 17"]                = true,
	["Day 18"]                = true, ["Forgotten Baby"]        = true,
	["Ghost Pig"]             = true, ["Hole Man"]              = true,
	["Househead Minion"]      = true, ["Humanoid Rabbit"]       = true,
	["Big Charlie"]           = true, ["Highwayworm"]           = true,
	["Hush"]                  = true, ["Living House / Househead"] = true,
	["Househead V2"]          = true, ["Long Horse"]            = true,
	["Milkwalker Ambassador"] = true, ["Nervous Houseguest"]    = true,
	["OG Breaking News"]      = true, ["Peeping Tom"]           = true,
	["Ribbit"]                = true, ["Starliner Cinema"]      = true,
	["Street Horse"]          = true, ["The Angel"]             = true,
	["Cartoon Dog 2"]         = true, ["Cartoon Mouse"]         = true,
	["Cartoon Cat"]           = true, ["Cartoon Dog"]           = true,
	["OG Cartoon Cat"]        = true,
	["Bird Watcher"]          = true,
	["Cartoon Sheep"]         = true,
}
local DOCTOR_NOWHERE = {
	["Guilt"]                 = true,
	["The Boiled One/Phen"]   = true,
	["Locust"]                = true,
	["Organator"]             = true,
}
local SCP_MORPHS = {
	["Unity 096"]             = true,
	["SCP-049"]               = true, ["SCP-1499-1"]            = true,
	["SCP-178-1"]             = true, ["SCP-2427-3"]            = true,
	["SCP-966"]               = true, ["SCP-096"]               = true,
	["SCP-106"]               = true, ["SCP-457"]               = true,
	["SCP-682"]               = true, ["SCP-860-1"]             = true,
	["SCP-939 Original"]      = true, ["SCP-096 B"]             = true,
	["SCP-096 Comix"]         = true, ["SCP-096 Reskin"]        = true,
	["Old Scopophobia 096"]   = true, ["Scopophobia 096"]       = true,
	["SCP-939"]               = true,
	["SCP-049 V2"]            = true, ["SCP-1499-1 V2"]         = true,
	["SCP-178-1 V2"]          = true, ["SCP-2427-3 V2"]         = true,
	["SCP-966 V2"]            = true, ["SCP-096 V2"]            = true,
	["SCP-106 V2"]            = true, ["SCP-457 V2"]            = true,
	["SCP-682 V2"]            = true, ["SCP-860-1 V2"]          = true,
	["SCP-939 Original V2"]   = true,
	["SCP-610-1"]             = true, ["SCP-610-2"]             = true,
	["SCP-610-3"]             = true, ["SCP-610-4"]             = true,
	["SCP-610-5"]             = true, ["SCP-610-6"]             = true,
	["SCP-610-7"]             = true, ["SCP-610-8"]             = true,
	["Cloth Wanderer (087)"]  = true, ["Eye Killer (087)"]      = true,
	["Masked Man (087)"]      = true, ["Red Mist Monster (087)"] = true,
}
local HALF_LIFE = {
	["Fast Handcrab"]         = true, ["HL1 Headcrab"]          = true,
	["Headcrab"]              = true, ["Poison Headcrab"]       = true,
	["Barney"]                = true, ["Fast Zombie"]           = true,
	["Headcrab Zombie"]       = true, ["Poison Zombie"]         = true,
	["Antlion Alyx"]          = true, ["Antlion Guard"]         = true,
	["Fast Zombie (HL2)"]     = true, ["Gargantua"]             = true,
	["Grunt (HL)"]            = true, ["HL2 Barnacle"]          = true,
	["HL2 Hunter"]            = true, ["Poison Zombie (HL2)"]   = true,
	["Strider"]               = true, ["Vortigaunt"]            = true,
	["Aflock"]                = true, ["Cremator"]              = true,
	["Floater"]               = true, ["Grunt"]                 = true,
	["Sergeant"]              = true, ["Stukabat"]              = true,
	["Hunter"]                = true, ["Gonome"]                = true,
	["HL1 Houndeye"]          = true, ["Mr. Friendly"]          = true,
	["Tentacle"]              = true, ["Gonarch"]               = true,
	["boid"]                  = true, ["crasher"]               = true,
	["Stalker"]               = true,
}
local COF_MORPHS = {
	["Craig"]                 = true,
	["Saw Crazy"]             = true,
	["Citalopram"]            = true,
	["Faceless"]              = true,
	["Faster"]                = true,
	["Sawrunner"]             = true,
	["Taller"]                = true,
}
local BACKROOMS = {
	["Aranea Membri"]         = true,
	["Bacteria"]              = true,
	["Deformed Howler"]       = true,
	["Howler"]                = true,
	["Neighborhood Watch"]    = true,
	["Skinstealer"]           = true,
	["Smiler"]                = true,
	["Starfish"]              = true,
}
local PPT_MORPHS = {
	["Huggy Wuggy"]           = true,
	["Catnap"]                = true,
	["Boxy Boo"]              = true,
	["Killy Willy"]           = true,
	["Marshmallow Huggy"]     = true,
	["Prototype"]             = true,
}
local SF_MORPHS = {
	["Goatman"]               = true,
	["Fleshgait"]             = true,
	["Fresno Nightcrawler"]   = true,
	["Skinwalker"]            = true,
	["Rake"]                  = true,
	["Kate"]                  = true,
	["Insanity"]              = true,
	["Walking Mask"]          = true,
	["Richard Boderman"]      = true,
	["Prettyface"]            = true,
	["Ethre"]                 = true,
	["Deathclaw"]             = true,
}
local PILLAR_CHASE = {
	["mario.exe"]             = true,
	["Ao Oni"]                = true,
	["Inkfell"]               = true,
	["fuwattie"]              = true,
	["fogborn"]               = true,
	["jeffery wood"]          = true,
	["tinky"]                 = true,
	["smiley"]                = true,
	["samsung"]               = true,
	["wyst"]                  = true,
}
local DIE_OF_DEATH = {
	["Pursuer"]  = true, ["Killdroid"] = true,
	["Badware"]  = true, ["Harken"]    = true,
	["Artful"]   = true, ["Paranoy"]   = true,
}
local FNAF_MORPHS = {
	["junkyard foxy"]  = true,
	["The Entity"]     = true,
	["Golden Freddy"]  = true,
	["Mimic"]          = true,
	["Ruin Mimic"]     = true,
}

local function getCategory(name)
	if TREVOR_HENDERSON[name] then return "trevor"      end
	if DOCTOR_NOWHERE[name]   then return "doctor"      end
	if SCP_MORPHS[name]       then return "scp"         end
	if HALF_LIFE[name]        then return "halflife"    end
	if COF_MORPHS[name]       then return "cof"         end
	if BACKROOMS[name]        then return "backrooms"   end
	if PPT_MORPHS[name]       then return "ppt"         end
	if SF_MORPHS[name]        then return "sf"          end
	if PILLAR_CHASE[name]     then return "pillarchase" end
	if DIE_OF_DEATH[name]     then return "dod"         end
	if FNAF_MORPHS[name]      then return "fnaf"        end
	return "others"
end

-- ============================================
-- TINKY ABILITY
-- ============================================
if _G.tinkyKilled == nil then _G.tinkyKilled = true end

local function ensureTinkyGui()
	if playerGui:FindFirstChild("TinkyReadyGui") then return end
	local rGui = Instance.new("ScreenGui")
	rGui.Name           = "TinkyReadyGui"
	rGui.ResetOnSpawn   = false
	rGui.DisplayOrder   = 999998
	rGui.IgnoreGuiInset = true
	rGui.Parent         = playerGui
	local rLbl = Instance.new("TextLabel")
	rLbl.Size                   = UDim2.new(1, -40, 0, 26)
	rLbl.Position               = UDim2.new(0, 20, 0, 8)
	rLbl.BackgroundColor3       = Color3.fromRGB(100, 20, 160)
	rLbl.BackgroundTransparency = 0
	rLbl.TextColor3             = Color3.new(1, 1, 1)
	rLbl.TextSize               = 13
	rLbl.Font                   = Enum.Font.GothamBold
	rLbl.Text                   = "⚡ Tinky ready!  Press T to teleport"
	rLbl.BorderSizePixel        = 0
	rLbl.Parent                 = rGui
	Instance.new("UICorner", rLbl).CornerRadius = UDim.new(0, 6)
end

local function nukeTinkyGui()
	local g = playerGui:FindFirstChild("TinkyReadyGui")
	if g then g:Destroy() end
end

local _myTConn = nil
local function ensureTConn()
	if _myTConn then return end
	_myTConn = UserInputService.InputBegan:Connect(function(input, processed)
		if processed then return end
		if input.KeyCode ~= Enum.KeyCode.T then return end
		if _G.tinkyKilled then return end
		tinkyTeleportEvent:FireServer()
		print("[Tinky] T fired")
	end)
end
local function nukeTConn()
	if _myTConn then
		pcall(function() _myTConn:Disconnect() end)
		_myTConn = nil
	end
end

task.spawn(function()
	while true do
		task.wait(0.5)
		if _G.tinkyKilled then
			nukeTConn()
			nukeTinkyGui()
		else
			ensureTinkyGui()
			ensureTConn()
		end
	end
end)

_G.onMorphSelected = function(morphName)
	if morphName == "tinky" then
		_G.tinkyKilled = false
		print("[Tinky] ENABLED — immortal T active")
	else
		_G.tinkyKilled = true
		print("[Tinky] Disabled — different morph selected")
	end
end

-- ============================================
-- BUILD GUI
-- ============================================
local _guiConnections = {}
local _countdownActive = false

local function buildGUI()
	-- Disconnect any existing event connections from a previous build
	for _, conn in ipairs(_guiConnections) do
		pcall(function() conn:Disconnect() end)
	end
	_guiConnections = {}
	_countdownActive = false

	local old = playerGui:FindFirstChild("MorphGuiReborn_Screen")
	if old then old:Destroy() end

	screen = Instance.new("ScreenGui")
	screen.Name           = "MorphGuiReborn_Screen"
	screen.ResetOnSpawn   = false
	screen.DisplayOrder   = 99999
	screen.IgnoreGuiInset = true
	screen.Parent         = playerGui

	-- ============================================
	-- CLICK SOUND + 3D PRESS ANIMATION HELPERS
	-- ============================================
	local clickSound = Instance.new("Sound")
	clickSound.SoundId  = "rbxassetid://140494750798924"
	clickSound.Volume   = 0.6
	clickSound.RollOffMaxDistance = 0
	clickSound.Parent   = screen

	local function playClick()
		-- Stop and restart so rapid clicks always fire
		clickSound:Stop()
		clickSound:Play()
	end

	-- Adds a 3D "sink" press feel to any TextButton.
	-- normalBg  : Color3 the button rests at
	-- hoverBg   : Color3 while hovered (optional — defaults to normalBg lighten)
	-- sinkY     : pixels to sink downward on press (default 3)
	local function addPressEffect(btn, normalBg, hoverBg, sinkY)
		sinkY   = sinkY or 3
		hoverBg = hoverBg or normalBg
		local pressedBg = normalBg:Lerp(Color3.new(0,0,0), 0.32)
		local origPos   = btn.Position
		local isHovered = false

		btn.MouseEnter:Connect(function()
			isHovered = true
		end)
		btn.MouseLeave:Connect(function()
			isHovered = false
			-- Always spring back on leave in case mouse released outside
			TweenService:Create(btn, TweenInfo.new(0.14, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Position = origPos,
				BackgroundColor3 = normalBg,
			}):Play()
		end)
		btn.MouseButton1Down:Connect(function()
			playClick()
			TweenService:Create(btn, TweenInfo.new(0.07, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundColor3 = pressedBg,
				Position = UDim2.new(origPos.X.Scale, origPos.X.Offset,
					origPos.Y.Scale, origPos.Y.Offset + sinkY),
			}):Play()
		end)
		btn.MouseButton1Up:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				BackgroundColor3 = isHovered and hoverBg or normalBg,
				Position = origPos,
			}):Play()
		end)
	end

	-- ============================================
	-- Main frame
	local frame = Instance.new("Frame")
	frame.Name              = "MainFrame"
	frame.Size              = UDim2.new(0,420,0,620)
	frame.Position          = UDim2.new(0.5,-210,0.5,-310)
	frame.BackgroundColor3  = C_BG
	frame.BorderSizePixel   = 0
	frame.ClipsDescendants  = true
	frame.Parent            = screen
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)
	local fStroke = Instance.new("UIStroke")
	fStroke.Color     = C_ACCENT
	fStroke.Thickness = 2
	fStroke.Parent    = frame

	-- Title bar
	local tbar = Instance.new("Frame")
	tbar.Size             = UDim2.new(1,0,0,44)
	tbar.BackgroundColor3 = C_ACCENT
	tbar.BorderSizePixel  = 0
	tbar.ZIndex           = 10
	tbar.Parent           = frame
	Instance.new("UICorner", tbar).CornerRadius = UDim.new(0,12)
	local tfix = Instance.new("Frame")
	tfix.Size             = UDim2.new(1,0,0.5,0)
	tfix.Position         = UDim2.new(0,0,0.5,0)
	tfix.BackgroundColor3 = C_ACCENT
	tfix.BorderSizePixel  = 0
	tfix.ZIndex           = 10
	tfix.Parent           = tbar

	local tlabel = Instance.new("TextLabel")
	tlabel.Size               = UDim2.new(1,-140,1,0)
	tlabel.Position           = UDim2.new(0,14,0,0)
	tlabel.BackgroundTransparency = 1
	tlabel.Text               = "⚡  Morph GUI  —  v4.5"
	tlabel.TextColor3         = Color3.new(1,1,1)
	tlabel.TextSize           = 14
	tlabel.Font               = Enum.Font.GothamBold
	tlabel.TextXAlignment     = Enum.TextXAlignment.Left
	tlabel.ZIndex             = 11
	tlabel.Parent             = tbar

	local function makeHeaderBtn(xOff, txt, bg)
		local b = Instance.new("TextButton")
		b.Size             = UDim2.new(0,28,0,28)
		b.Position         = UDim2.new(1,xOff,0,8)
		b.BackgroundColor3 = bg
		b.Text             = txt
		b.TextColor3       = Color3.new(1,1,1)
		b.TextSize         = 13
		b.Font             = Enum.Font.GothamBold
		b.BorderSizePixel  = 0
		b.AutoButtonColor  = false
		b.ZIndex           = 12
		b.Parent           = tbar
		Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
		return b
	end

	local minBtn   = makeHeaderBtn(-66,  "-",  C_DARK)
	local closeBtn = makeHeaderBtn(-34,  "X",  C_RED)
	local verBtn   = makeHeaderBtn(-100, "🔄", Color3.fromRGB(20,80,40))
	local resetBtn = makeHeaderBtn(-134, "⚠",  Color3.fromRGB(160,80,0))
	local minimized = false

	-- Press effects for header buttons
	addPressEffect(minBtn,   C_DARK,                   C_DARK:Lerp(Color3.new(1,1,1),0.1))
	addPressEffect(closeBtn, C_RED,                    C_RED:Lerp(Color3.new(1,1,1),0.1))
	addPressEffect(verBtn,   Color3.fromRGB(20,80,40), Color3.fromRGB(30,110,55))
	addPressEffect(resetBtn, Color3.fromRGB(160,80,0), Color3.fromRGB(190,100,10))

	-- ---- CHANGELOG POPUP ----
	local changelog = Instance.new("Frame")
	changelog.Size             = UDim2.new(1,-20,0,260)
	changelog.Position         = UDim2.new(0,10,0,52)
	changelog.BackgroundColor3 = Color3.fromRGB(8,14,28)
	changelog.BorderSizePixel  = 0
	changelog.Visible          = false
	changelog.ZIndex           = 50
	changelog.ClipsDescendants = true
	changelog.Parent           = frame
	Instance.new("UICorner", changelog).CornerRadius = UDim.new(0,8)
	local clStroke = Instance.new("UIStroke")
	clStroke.Color     = C_ACCENT
	clStroke.Thickness = 1
	clStroke.Parent    = changelog

	local clTitle = Instance.new("TextLabel")
	clTitle.Size                 = UDim2.new(1,-10,0,28)
	clTitle.Position             = UDim2.new(0,8,0,6)
	clTitle.BackgroundTransparency = 1
	clTitle.Text                 = "🔄  Version 4.5  —  Changelog"
	clTitle.TextColor3           = Color3.new(1,1,1)
	clTitle.TextSize             = 13
	clTitle.Font                 = Enum.Font.GothamBold
	clTitle.TextXAlignment       = Enum.TextXAlignment.Left
	clTitle.ZIndex               = 51
	clTitle.Parent               = changelog

	local clDivider = Instance.new("Frame")
	clDivider.Size             = UDim2.new(1,-16,0,1)
	clDivider.Position         = UDim2.new(0,8,0,36)
	clDivider.BackgroundColor3 = C_STROKE
	clDivider.BorderSizePixel  = 0
	clDivider.ZIndex           = 51
	clDivider.Parent           = changelog

	local clScroll = Instance.new("ScrollingFrame")
	clScroll.Size                  = UDim2.new(0,372,0,214)
	clScroll.Position              = UDim2.new(0,4,0,42)
	clScroll.BackgroundTransparency = 1
	clScroll.BorderSizePixel       = 0
	clScroll.ScrollBarThickness    = 5
	clScroll.ScrollBarImageColor3  = C_ACCENT
	clScroll.ScrollingDirection    = Enum.ScrollingDirection.Y
	clScroll.CanvasSize            = UDim2.new(0,0,0,1200)
	clScroll.ZIndex                = 51
	clScroll.Parent                = changelog

	local CHANGELOG_TEXT = [[v4.5
✦ All Trevor Henderson morphs updated
  to new unified module (126117931044909)
✦ Private module detection added:
  if a module is set to private the GUI
  shows "Module is privated, await for
  a new patch" instead of silently failing
✦ Morph loading screen added:
  - Full-screen animated loading overlay
    appears when you click MORPH
  - Vanishes automatically once the server
    confirms the morph has fully loaded
  - Skip button available to dismiss early
✦ Button split/expand animation:
  clicking a morph in the list now animates
  the button expanding upward to reveal
  the entity image and description in place
  before sliding to the full detail panel

v4.3
✦ Click sound added to every button
  (plays on press everywhere in GUI)
✦ 3D button press animation:
  buttons now visually sink in when
  clicked and spring back on release
✦ Scrollbar redesigned — thicker,
  bright white, always visible
✦ Zoom overlay close button fixed
  from "0" icon to proper "X"
✦ GUI cleaned up — tighter spacing,
  improved contrast and button feel

v4.0
✦ GUI Remaster — detail panel system
  Clicking a morph now opens a mini menu
  before you commit to morphing, showing:
  - Entity image (top of panel)
  - Entity name
  - Description / lore
  - MORPH button to confirm
  - BACK button to return to list
✦ Bacteria gets a full entry:
  - Image: rbxassetid://106821108400971
  - Full lore description added
✦ All other morphs show "No description yet!"
  with a blank image placeholder

v3.1
✦ New morphs:
  - Cartoon Sheep (Trevor Henderson)
  - Green (Others)
  - Mimic (FNAF)
  - Ruin Mimic (FNAF)
✦ junkyard foxy: CANNOT REMORPH warning
✦ Golden Freddy & The Entity: permanent
  server warning added

v3.0
✦ Task system removed entirely
✦ New tab: Pillar Chase
✦ New tab: Die of Death
✦ Slender Fortress, Half-Life, PPT expanded
✦ SCP V2 pack + SCP-610 + SCP-087 packs
✦ Tinky T ability added
✦ Watchdog improved

v2.3
✦ LC Jester, Roaring Knight added

v2.2
✦ Trevor Henderson: God of Roadkill,
  Good Boy, Mothman, Scribble Head

v2.0
✦ Half-Life & Cry of Fear expanded
✦ The Hugger added

v1.42
✦ Fixed broken morph bug

v1.4
✦ Killy Willy, Marshmallow Huggy added

v1.3
✦ Demogorgen variants added

v1.2
✦ SCP-087 pack added

v1.1
✦ Backrooms tab completed

v1.0
✦ Initial release]]

	local clBody = Instance.new("TextLabel")
	clBody.Size              = UDim2.new(0,356,0,0)
	clBody.Position          = UDim2.new(0,4,0,4)
	clBody.BackgroundTransparency = 1
	clBody.Text              = CHANGELOG_TEXT
	clBody.TextColor3        = C_TEXT
	clBody.TextSize          = 11
	clBody.Font              = Enum.Font.Gotham
	clBody.TextXAlignment    = Enum.TextXAlignment.Left
	clBody.TextYAlignment    = Enum.TextYAlignment.Top
	clBody.TextWrapped       = true
	clBody.AutomaticSize     = Enum.AutomaticSize.Y
	clBody.ZIndex            = 52
	clBody.Parent            = clScroll

	task.defer(function()
		clScroll.CanvasSize = UDim2.new(0,0,0, clBody.AbsoluteSize.Y + 12)
	end)

	-- ---- RESET POPUP ----
	local resetPopup = Instance.new("Frame")
	resetPopup.Size             = UDim2.new(1,-20,0,90)
	resetPopup.Position         = UDim2.new(0,10,0,52)
	resetPopup.BackgroundColor3 = Color3.fromRGB(30,10,10)
	resetPopup.BorderSizePixel  = 0
	resetPopup.Visible          = false
	resetPopup.ZIndex           = 50
	resetPopup.ClipsDescendants = true
	resetPopup.Parent           = frame
	Instance.new("UICorner", resetPopup).CornerRadius = UDim.new(0,8)
	local rpStroke = Instance.new("UIStroke")
	rpStroke.Color     = Color3.fromRGB(200,60,0)
	rpStroke.Thickness = 1
	rpStroke.Parent    = resetPopup

	local rpLabel = Instance.new("TextLabel")
	rpLabel.Size                 = UDim2.new(1,-16,0,38)
	rpLabel.Position             = UDim2.new(0,8,0,6)
	rpLabel.BackgroundTransparency = 1
	rpLabel.Text                 = "⚠  Reset Morph\nResets you to default R6 — clears all morph bugs."
	rpLabel.TextColor3           = Color3.fromRGB(255,180,80)
	rpLabel.TextSize             = 11
	rpLabel.Font                 = Enum.Font.Gotham
	rpLabel.TextXAlignment       = Enum.TextXAlignment.Left
	rpLabel.TextYAlignment       = Enum.TextYAlignment.Top
	rpLabel.TextWrapped          = true
	rpLabel.ZIndex               = 51
	rpLabel.Parent               = resetPopup

	local rpConfirm = Instance.new("TextButton")
	rpConfirm.Size             = UDim2.new(1,-16,0,28)
	rpConfirm.Position         = UDim2.new(0,8,0,52)
	rpConfirm.BackgroundColor3 = Color3.fromRGB(160,40,0)
	rpConfirm.Text             = "RESET NOW"
	rpConfirm.TextColor3       = Color3.new(1,1,1)
	rpConfirm.TextSize         = 12
	rpConfirm.Font             = Enum.Font.GothamBold
	rpConfirm.BorderSizePixel  = 0
	rpConfirm.AutoButtonColor  = false
	rpConfirm.ZIndex           = 52
	rpConfirm.Parent           = resetPopup
	Instance.new("UICorner", rpConfirm).CornerRadius = UDim.new(0,6)

	rpConfirm.MouseButton1Click:Connect(function()
		rpConfirm.Text             = "Resetting..."
		rpConfirm.BackgroundColor3 = Color3.fromRGB(80,20,0)
		resetMorphEvent:FireServer()
		task.delay(2, function()
			if rpConfirm and rpConfirm.Parent then
				rpConfirm.Text             = "RESET NOW"
				rpConfirm.BackgroundColor3 = Color3.fromRGB(160,40,0)
				resetPopup.Visible         = false
			end
		end)
	end)

	verBtn.MouseButton1Click:Connect(function()
		changelog.Visible  = not changelog.Visible
		if changelog.Visible then resetPopup.Visible = false end
	end)
	resetBtn.MouseButton1Click:Connect(function()
		resetPopup.Visible = not resetPopup.Visible
		if resetPopup.Visible then changelog.Visible = false end
	end)

	-- Restore button (when GUI closed)
	local restoreBtn = Instance.new("TextButton")
	restoreBtn.Size             = UDim2.new(0,40,0,40)
	restoreBtn.Position         = UDim2.new(0,10,1,-50)
	restoreBtn.BackgroundColor3 = C_ACCENT
	restoreBtn.Text             = "M"
	restoreBtn.TextColor3       = Color3.new(1,1,1)
	restoreBtn.TextSize         = 14
	restoreBtn.Font             = Enum.Font.GothamBold
	restoreBtn.BorderSizePixel  = 0
	restoreBtn.AutoButtonColor  = false
	restoreBtn.Visible          = false
	restoreBtn.ZIndex           = 20
	restoreBtn.Parent           = screen
	Instance.new("UICorner", restoreBtn).CornerRadius = UDim.new(0,8)
	addPressEffect(restoreBtn, C_ACCENT, C_HOV)

	-- ==================== LOADING SCREEN ====================
	-- Full-screen overlay shown while morph is loading server-side
	local loadScreen = Instance.new("Frame")
	loadScreen.Name                 = "LoadScreen"
	loadScreen.Size                 = UDim2.new(1,0,1,0)
	loadScreen.BackgroundColor3     = Color3.fromRGB(4,6,14)
	loadScreen.BackgroundTransparency = 0
	loadScreen.BorderSizePixel      = 0
	loadScreen.ZIndex               = 300
	loadScreen.Visible              = false
	loadScreen.Parent               = screen

	local loadGlow = Instance.new("Frame")
	loadGlow.Size                 = UDim2.new(0,200,0,200)
	loadGlow.Position             = UDim2.new(0.5,-100,0.5,-140)
	loadGlow.BackgroundColor3     = C_ACCENT
	loadGlow.BackgroundTransparency = 0.85
	loadGlow.BorderSizePixel      = 0
	loadGlow.ZIndex               = 301
	loadGlow.Parent               = loadScreen
	Instance.new("UICorner", loadGlow).CornerRadius = UDim.new(1,0)

	local loadSpinnerOuter = Instance.new("Frame")
	loadSpinnerOuter.Size                 = UDim2.new(0,80,0,80)
	loadSpinnerOuter.Position             = UDim2.new(0.5,-40,0.5,-110)
	loadSpinnerOuter.BackgroundTransparency = 1
	loadSpinnerOuter.BorderSizePixel      = 0
	loadSpinnerOuter.ZIndex               = 302
	loadSpinnerOuter.Parent               = loadScreen

	local loadArc = Instance.new("Frame")
	loadArc.Size                 = UDim2.new(1,0,0.5,0)
	loadArc.Position             = UDim2.new(0,0,0,0)
	loadArc.BackgroundColor3     = C_ACCENT
	loadArc.BackgroundTransparency = 0
	loadArc.BorderSizePixel      = 0
	loadArc.ZIndex               = 303
	loadArc.Parent               = loadSpinnerOuter
	Instance.new("UICorner", loadArc).CornerRadius = UDim.new(1,0)

	-- Spinning animation
	local spinRunning = false
	local function startSpin()
		spinRunning = true
		task.spawn(function()
			local angle = 0
			while spinRunning and loadScreen.Visible do
				angle = (angle + 4) % 360
				loadSpinnerOuter.Rotation = angle
				loadGlow.BackgroundTransparency = 0.78 + math.sin(angle * math.pi / 180) * 0.07
				task.wait(0.03)
			end
		end)
	end

	local loadTitle = Instance.new("TextLabel")
	loadTitle.Size                 = UDim2.new(1,-40,0,32)
	loadTitle.Position             = UDim2.new(0,20,0.5,-20)
	loadTitle.BackgroundTransparency = 1
	loadTitle.Text                 = "Loading..."
	loadTitle.TextColor3           = Color3.new(1,1,1)
	loadTitle.TextSize             = 22
	loadTitle.Font                 = Enum.Font.GothamBold
	loadTitle.ZIndex               = 302
	loadTitle.Parent               = loadScreen

	local loadSub = Instance.new("TextLabel")
	loadSub.Size                 = UDim2.new(1,-40,0,20)
	loadSub.Position             = UDim2.new(0,20,0.5,18)
	loadSub.BackgroundTransparency = 1
	loadSub.Text                 = "Applying morph, please wait..."
	loadSub.TextColor3           = C_SUB
	loadSub.TextSize             = 13
	loadSub.Font                 = Enum.Font.Gotham
	loadSub.ZIndex               = 302
	loadSub.Parent               = loadScreen

	local loadSkip = Instance.new("TextButton")
	loadSkip.Size             = UDim2.new(0,110,0,36)
	loadSkip.Position         = UDim2.new(0.5,-55,0.5,60)
	loadSkip.BackgroundColor3 = Color3.fromRGB(30,30,50)
	loadSkip.Text             = "Skip ›"
	loadSkip.TextColor3       = C_SUB
	loadSkip.TextSize         = 13
	loadSkip.Font             = Enum.Font.GothamBold
	loadSkip.BorderSizePixel  = 0
	loadSkip.AutoButtonColor  = false
	loadSkip.ZIndex           = 302
	loadSkip.Parent           = loadScreen
	Instance.new("UICorner", loadSkip).CornerRadius = UDim.new(0,8)
	addPressEffect(loadSkip, Color3.fromRGB(30,30,50), Color3.fromRGB(50,50,80))

	local function showLoadScreen(morphName)
		loadTitle.Text   = "Morphing into " .. morphName
		loadSub.Text     = "Loading module, please wait..."
		loadScreen.BackgroundTransparency = 1
		loadScreen.Visible = true
		TweenService:Create(loadScreen, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
		startSpin()
	end

	local function hideLoadScreen()
		spinRunning = false
		TweenService:Create(loadScreen, TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()
		task.delay(0.26, function()
			if loadScreen and loadScreen.Parent then
				loadScreen.Visible = false
			end
		end)
	end

	loadSkip.MouseButton1Click:Connect(hideLoadScreen)

	-- ==================== PRIVATE MODULE POPUP ====================
	local privatePopup = Instance.new("Frame")
	privatePopup.Name                 = "PrivatePopup"
	privatePopup.Size                 = UDim2.new(0,320,0,110)
	privatePopup.Position             = UDim2.new(0.5,-160,-0.25,0)
	privatePopup.BackgroundColor3     = Color3.fromRGB(12,8,8)
	privatePopup.BorderSizePixel      = 0
	privatePopup.ZIndex               = 400
	privatePopup.Visible              = false
	privatePopup.Parent               = screen
	Instance.new("UICorner", privatePopup).CornerRadius = UDim.new(0,12)
	local ppStroke = Instance.new("UIStroke")
	ppStroke.Color     = Color3.fromRGB(200,40,40)
	ppStroke.Thickness = 2
	ppStroke.Parent    = privatePopup

	local ppIcon = Instance.new("TextLabel")
	ppIcon.Size                 = UDim2.new(0,40,0,40)
	ppIcon.Position             = UDim2.new(0,12,0,12)
	ppIcon.BackgroundTransparency = 1
	ppIcon.Text                 = "🔒"
	ppIcon.TextSize             = 26
	ppIcon.Font                 = Enum.Font.GothamBold
	ppIcon.ZIndex               = 401
	ppIcon.Parent               = privatePopup

	local ppTitle = Instance.new("TextLabel")
	ppTitle.Size                 = UDim2.new(1,-70,0,22)
	ppTitle.Position             = UDim2.new(0,58,0,10)
	ppTitle.BackgroundTransparency = 1
	ppTitle.Text                 = "Module is privated"
	ppTitle.TextColor3           = Color3.fromRGB(255,80,80)
	ppTitle.TextSize             = 14
	ppTitle.Font                 = Enum.Font.GothamBold
	ppTitle.TextXAlignment       = Enum.TextXAlignment.Left
	ppTitle.ZIndex               = 401
	ppTitle.Parent               = privatePopup

	local ppSub = Instance.new("TextLabel")
	ppSub.Size                 = UDim2.new(1,-24,0,36)
	ppSub.Position             = UDim2.new(0,12,0,36)
	ppSub.BackgroundTransparency = 1
	ppSub.Text                 = "Await for a new patch."
	ppSub.TextColor3           = C_SUB
	ppSub.TextSize             = 12
	ppSub.Font                 = Enum.Font.Gotham
	ppSub.TextXAlignment       = Enum.TextXAlignment.Left
	ppSub.TextWrapped          = true
	ppSub.ZIndex               = 401
	ppSub.Parent               = privatePopup

	local ppClose = Instance.new("TextButton")
	ppClose.Size             = UDim2.new(1,-24,0,26)
	ppClose.Position         = UDim2.new(0,12,1,-34)
	ppClose.BackgroundColor3 = Color3.fromRGB(40,12,12)
	ppClose.Text             = "Dismiss"
	ppClose.TextColor3       = Color3.fromRGB(200,80,80)
	ppClose.TextSize         = 12
	ppClose.Font             = Enum.Font.GothamBold
	ppClose.BorderSizePixel  = 0
	ppClose.AutoButtonColor  = false
	ppClose.ZIndex           = 402
	ppClose.Parent           = privatePopup
	Instance.new("UICorner", ppClose).CornerRadius = UDim.new(0,6)
	addPressEffect(ppClose, Color3.fromRGB(40,12,12), Color3.fromRGB(70,20,20))

	local function showPrivatePopup(morphName)
		ppSub.Text = '"' .. morphName .. '" module is privated.\nAwait for a new patch.'
		privatePopup.Position = UDim2.new(0.5,-160,-0.25,0)
		privatePopup.Visible  = true
		TweenService:Create(privatePopup, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Position = UDim2.new(0.5,-160,0,14)
		}):Play()
		task.delay(6, function()
			if privatePopup and privatePopup.Visible then
				TweenService:Create(privatePopup, TweenInfo.new(0.2), {
					Position = UDim2.new(0.5,-160,-0.25,0)
				}):Play()
				task.delay(0.21, function() privatePopup.Visible = false end)
			end
		end)
	end

	ppClose.MouseButton1Click:Connect(function()
		TweenService:Create(privatePopup, TweenInfo.new(0.2), {
			Position = UDim2.new(0.5,-160,-0.25,0)
		}):Play()
		task.delay(0.21, function() privatePopup.Visible = false end)
	end)

	-- Wire up the two new server events
	table.insert(_guiConnections, morphCompleteEvent.OnClientEvent:Connect(function(success, morphName)
		hideLoadScreen()
	end))

	table.insert(_guiConnections, morphPrivateEvent.OnClientEvent:Connect(function(morphName)
		hideLoadScreen()
		showPrivatePopup(morphName)
	end))

	-- ==================== PASSWORD FRAME ====================
	local pwFrame = Instance.new("Frame")
	pwFrame.Size                 = UDim2.new(1,0,1,-44)
	pwFrame.Position             = UDim2.new(0,0,0,44)
	pwFrame.BackgroundTransparency = 1
	pwFrame.Parent               = frame

	local lockLbl = Instance.new("TextLabel")
	lockLbl.Size                 = UDim2.new(1,0,0,60)
	lockLbl.Position             = UDim2.new(0,0,0,30)
	lockLbl.BackgroundTransparency = 1
	lockLbl.Text                 = "🔒"
	lockLbl.TextSize             = 48
	lockLbl.Font                 = Enum.Font.GothamBold
	lockLbl.TextColor3           = C_ACCENT
	lockLbl.Parent               = pwFrame

	local pwPrompt = Instance.new("TextLabel")
	pwPrompt.Size                 = UDim2.new(1,-40,0,22)
	pwPrompt.Position             = UDim2.new(0,20,0,105)
	pwPrompt.BackgroundTransparency = 1
	pwPrompt.Text                 = "Enter access code:"
	pwPrompt.TextColor3           = C_SUB
	pwPrompt.TextSize             = 13
	pwPrompt.Font                 = Enum.Font.Gotham
	pwPrompt.Parent               = pwFrame

	local codeBox = Instance.new("TextBox")
	codeBox.Size               = UDim2.new(1,-40,0,42)
	codeBox.Position           = UDim2.new(0,20,0,132)
	codeBox.BackgroundColor3   = C_BTN
	codeBox.TextColor3         = C_TEXT
	codeBox.PlaceholderText    = "Type code here..."
	codeBox.PlaceholderColor3  = C_SUB
	codeBox.Text               = ""
	codeBox.TextSize           = 15
	codeBox.Font               = Enum.Font.Gotham
	codeBox.ClearTextOnFocus   = false
	codeBox.BorderSizePixel    = 0
	codeBox.Parent             = pwFrame
	Instance.new("UICorner", codeBox).CornerRadius = UDim.new(0,8)
	local cbStroke = Instance.new("UIStroke")
	cbStroke.Color     = C_STROKE
	cbStroke.Thickness = 1
	cbStroke.Parent    = codeBox

	local submitBtn = Instance.new("TextButton")
	submitBtn.Size             = UDim2.new(1,-40,0,42)
	submitBtn.Position         = UDim2.new(0,20,0,182)
	submitBtn.BackgroundColor3 = C_ACCENT
	submitBtn.Text             = "UNLOCK"
	submitBtn.TextColor3       = Color3.new(1,1,1)
	submitBtn.TextSize         = 14
	submitBtn.Font             = Enum.Font.GothamBold
	submitBtn.BorderSizePixel  = 0
	submitBtn.AutoButtonColor  = false
	submitBtn.Parent           = pwFrame
	Instance.new("UICorner", submitBtn).CornerRadius = UDim.new(0,8)

	local pwStatusLbl = Instance.new("TextLabel")
	pwStatusLbl.Size                 = UDim2.new(1,-40,0,22)
	pwStatusLbl.Position             = UDim2.new(0,20,0,232)
	pwStatusLbl.BackgroundTransparency = 1
	pwStatusLbl.Text                 = ""
	pwStatusLbl.TextColor3           = Color3.fromRGB(255,80,80)
	pwStatusLbl.TextSize             = 12
	pwStatusLbl.Font                 = Enum.Font.Gotham
	pwStatusLbl.Parent               = pwFrame

	-- ==================== MORPH LIST FRAME ====================
	local mFrame = Instance.new("Frame")
	mFrame.Size                 = UDim2.new(1,0,1,-44)
	mFrame.Position             = UDim2.new(0,0,0,44)
	mFrame.BackgroundTransparency = 1
	mFrame.Visible              = false
	mFrame.Parent               = frame

	-- Tab rows
	local function makeTabRow(yPos)
		local r = Instance.new("Frame")
		r.Size                 = UDim2.new(1,-20,0,28)
		r.Position             = UDim2.new(0,10,0,yPos)
		r.BackgroundTransparency = 1
		r.Parent               = mFrame
		return r
	end
	local tabRow1 = makeTabRow(6)
	local tabRow2 = makeTabRow(38)
	local tabRow3 = makeTabRow(70)
	local tabRow4 = makeTabRow(102)
	local tabRow5 = makeTabRow(134)
	local tabRow6 = makeTabRow(166)
	local tabRow7 = makeTabRow(198)

	local function makeTab(parent, xScale, xOff, txt, on)
		local t = Instance.new("TextButton")
		t.Size             = UDim2.new(xScale,-3,1,0)
		t.Position         = UDim2.new(1-xScale, xOff, 0, 0)
		t.BackgroundColor3 = on and C_TAB_ON or C_TAB_OFF
		t.Text             = txt
		t.TextColor3       = on and Color3.new(1,1,1) or C_SUB
		t.TextSize         = 11
		t.Font             = Enum.Font.GothamBold
		t.BorderSizePixel  = 0
		t.AutoButtonColor  = false
		t.Parent           = parent
		Instance.new("UICorner", t).CornerRadius = UDim.new(0,7)
		return t
	end

	local tabTrevor    = makeTab(tabRow1, 0.5, 0, "🌲 Trevor Henderson", true)
	tabTrevor.Position = UDim2.new(0,0,0,0)
	local tabDoctor    = makeTab(tabRow1, 0.5, 3, "🧪 Dr. Nowhere", false)
	tabDoctor.Position = UDim2.new(0.5,3,0,0)
	local tabSCP       = makeTab(tabRow2, 0.5, 0, "☢ SCP", false)
	tabSCP.Position    = UDim2.new(0,0,0,0)
	local tabHL        = makeTab(tabRow2, 0.5, 3, "🔬 Half-Life", false)
	tabHL.Position     = UDim2.new(0.5,3,0,0)
	local tabCoF       = makeTab(tabRow3, 0.5, 0, "🔦 Cry of Fear", false)
	tabCoF.Position    = UDim2.new(0,0,0,0)
	local tabBackrooms = makeTab(tabRow3, 0.5, 3, "🟨 Backrooms", false)
	tabBackrooms.Position = UDim2.new(0.5,3,0,0)
	local tabPPT       = makeTab(tabRow4, 0.5, 0, "🧸 Poppy Playtime", false)
	tabPPT.Position    = UDim2.new(0,0,0,0)
	local tabSF        = makeTab(tabRow4, 0.5, 3, "👤 Slender Fortress", false)
	tabSF.Position     = UDim2.new(0.5,3,0,0)
	local tabPillar    = makeTab(tabRow5, 0.5, 0, "🏛 Pillar Chase", false)
	tabPillar.Position = UDim2.new(0,0,0,0)
	local tabOthers    = makeTab(tabRow5, 0.5, 3, "👁 Others", false)
	tabOthers.Position = UDim2.new(0.5,3,0,0)
	local tabDOD       = makeTab(tabRow6, 0.5, 0, "💀 Die of Death", false)
	tabDOD.Position    = UDim2.new(0,0,0,0)
	local tabFNAF      = makeTab(tabRow6, 0.5, 3, "🐻 FNAF", false)
	tabFNAF.Position   = UDim2.new(0.5,3,0,0)
	local tabFeatured  = makeTab(tabRow7, 1.0, 0, "⭐ FEATURED MORPH", false)
	tabFeatured.Position         = UDim2.new(0,0,0,0)
	tabFeatured.Size             = UDim2.new(1,0,1,0)
	tabFeatured.BackgroundColor3 = C_GOLD_DK
	tabFeatured.TextColor3       = Color3.fromRGB(255,255,220)

	-- Press effects on all tabs (sinkY=2 since they're small)
	for _, t in ipairs({tabTrevor,tabDoctor,tabSCP,tabHL,tabCoF,tabBackrooms,
		tabPPT,tabSF,tabPillar,tabOthers,tabDOD,tabFNAF}) do
		addPressEffect(t, C_TAB_OFF, C_TAB_ON, 2)
	end
	addPressEffect(tabFeatured, C_GOLD_DK, C_GOLD, 2)

	-- Search box
	local searchBox = Instance.new("TextBox")
	searchBox.Size              = UDim2.new(1,-20,0,32)
	searchBox.Position          = UDim2.new(0,10,0,232)
	searchBox.BackgroundColor3  = C_BTN
	searchBox.TextColor3        = C_TEXT
	searchBox.PlaceholderText   = "🔍 Search morphs..."
	searchBox.PlaceholderColor3 = C_SUB
	searchBox.Text              = ""
	searchBox.TextSize          = 13
	searchBox.Font              = Enum.Font.Gotham
	searchBox.ClearTextOnFocus  = false
	searchBox.BorderSizePixel   = 0
	searchBox.Parent            = mFrame
	Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0,8)
	local sbStroke = Instance.new("UIStroke")
	sbStroke.Color     = C_STROKE
	sbStroke.Thickness = 1
	sbStroke.Parent    = searchBox

	local countLbl = Instance.new("TextLabel")
	countLbl.Size                 = UDim2.new(1,-20,0,16)
	countLbl.Position             = UDim2.new(0,10,0,269)
	countLbl.BackgroundTransparency = 1
	countLbl.Text                 = ""
	countLbl.TextColor3           = C_SUB
	countLbl.TextSize             = 11
	countLbl.Font                 = Enum.Font.Gotham
	countLbl.TextXAlignment       = Enum.TextXAlignment.Left
	countLbl.Parent               = mFrame

	local scroll = Instance.new("ScrollingFrame")
	scroll.Size                  = UDim2.new(1,-10,1,-342)
	scroll.Position              = UDim2.new(0,5,0,288)
	scroll.BackgroundTransparency = 1
	scroll.BorderSizePixel       = 0
	scroll.ScrollBarThickness    = 4
	scroll.ScrollBarImageColor3  = C_ACCENT
	scroll.CanvasSize            = UDim2.new(0,0,0,0)
	scroll.AutomaticCanvasSize   = Enum.AutomaticSize.Y
	scroll.Parent                = mFrame

	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding   = UDim.new(0,4)
	layout.Parent    = scroll

	local lpad = Instance.new("UIPadding")
	lpad.PaddingLeft  = UDim.new(0,4)
	lpad.PaddingRight = UDim.new(0,4)
	lpad.PaddingTop   = UDim.new(0,4)
	lpad.Parent       = scroll

	local statusBar = Instance.new("TextLabel")
	statusBar.Size                 = UDim2.new(1,-20,0,20)
	statusBar.Position             = UDim2.new(0,10,1,-38)
	statusBar.BackgroundTransparency = 1
	statusBar.Text                 = "No morph selected"
	statusBar.TextColor3           = C_SUB
	statusBar.TextSize             = 11
	statusBar.Font                 = Enum.Font.Gotham
	statusBar.TextXAlignment       = Enum.TextXAlignment.Left
	statusBar.Parent               = mFrame

	local credLbl = Instance.new("TextLabel")
	credLbl.Size                 = UDim2.new(1,-20,0,18)
	credLbl.Position             = UDim2.new(0,10,1,-20)
	credLbl.BackgroundTransparency = 1
	credLbl.Text                 = "✦ Created by Chad"
	credLbl.TextColor3           = Color3.fromRGB(50,80,160)
	credLbl.TextSize             = 11
	credLbl.Font                 = Enum.Font.GothamBold
	credLbl.Parent               = mFrame

	-- ==================== DETAIL PANEL ====================
	-- Slides over the scroll list when a morph is clicked.
	-- Contains: image, name, description, MORPH + BACK buttons, warnings.

	-- Click-blocker: invisible TextButton that sits over mFrame and eats all
	-- clicks through to the morph list while the detail panel is open.
	local clickBlocker = Instance.new("TextButton")
	clickBlocker.Name                 = "ClickBlocker"
	clickBlocker.Size                 = UDim2.new(1,0,1,-44)
	clickBlocker.Position             = UDim2.new(0,0,0,44)
	clickBlocker.BackgroundTransparency = 1
	clickBlocker.Text                 = ""
	clickBlocker.ZIndex               = 19
	clickBlocker.Visible              = false
	clickBlocker.AutoButtonColor      = false
	clickBlocker.Parent               = frame
	-- Swallow all clicks silently
	clickBlocker.MouseButton1Click:Connect(function() end)

	-- Fullscreen zoom overlay — child of screen so it goes above everything
	local zoomOverlay = Instance.new("Frame")
	zoomOverlay.Name                 = "ZoomOverlay"
	zoomOverlay.Size                 = UDim2.new(1,0,1,0)
	zoomOverlay.Position             = UDim2.new(0,0,0,0)
	zoomOverlay.BackgroundColor3     = Color3.fromRGB(0,0,0)
	zoomOverlay.BackgroundTransparency = 0.25
	zoomOverlay.BorderSizePixel      = 0
	zoomOverlay.ZIndex               = 200
	zoomOverlay.Visible              = false
	zoomOverlay.Parent               = screen

	local zoomImg = Instance.new("ImageLabel")
	zoomImg.Size                   = UDim2.new(0.88,0,0.78,0)
	zoomImg.Position               = UDim2.new(0.06,0,0.09,0)
	zoomImg.BackgroundColor3       = Color3.fromRGB(6,8,16)
	zoomImg.BackgroundTransparency = 0
	zoomImg.Image                  = ""
	zoomImg.ScaleType              = Enum.ScaleType.Fit
	zoomImg.ZIndex                 = 201
	zoomImg.Parent                 = zoomOverlay
	Instance.new("UICorner", zoomImg).CornerRadius = UDim.new(0,14)

	local zoomClose = Instance.new("TextButton")
	zoomClose.Size             = UDim2.new(0,38,0,38)
	zoomClose.Position         = UDim2.new(1,-48,0,10)
	zoomClose.BackgroundColor3 = C_RED
	zoomClose.Text             = "X"
	zoomClose.TextColor3       = Color3.new(1,1,1)
	zoomClose.TextSize         = 18
	zoomClose.Font             = Enum.Font.GothamBold
	zoomClose.BorderSizePixel  = 0
	zoomClose.AutoButtonColor  = false
	zoomClose.ZIndex           = 202
	zoomClose.Parent           = zoomOverlay
	Instance.new("UICorner", zoomClose).CornerRadius = UDim.new(0,8)

	-- Close zoom on X or clicking the dark backdrop
	local function closeZoom()
		TweenService:Create(zoomOverlay, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
		TweenService:Create(zoomImg, TweenInfo.new(0.15), {ImageTransparency = 1}):Play()
		task.delay(0.16, function()
			if zoomOverlay and zoomOverlay.Parent then
				zoomOverlay.Visible        = false
				zoomOverlay.BackgroundTransparency = 0.25
				zoomImg.ImageTransparency  = 0
			end
		end)
	end

	local function openZoom(imgId)
		if imgId == "" or imgId == DEFAULT_IMAGE then return end
		zoomImg.Image              = imgId
		zoomImg.ImageTransparency  = 1
		zoomOverlay.BackgroundTransparency = 1
		zoomOverlay.Visible        = true
		TweenService:Create(zoomOverlay, TweenInfo.new(0.18), {BackgroundTransparency = 0.25}):Play()
		TweenService:Create(zoomImg, TweenInfo.new(0.18), {ImageTransparency = 0}):Play()
	end

	zoomClose.MouseButton1Click:Connect(closeZoom)
	addPressEffect(zoomClose, C_RED, C_RED:Lerp(Color3.new(1,1,1),0.15))
	-- Clicking the dark backdrop outside the image also closes
	zoomOverlay.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			closeZoom()
		end
	end)
	-- But don't let clicks on the image itself close it
	zoomImg.InputBegan:Connect(function(input)
		input:Destroy() -- swallow so it doesn't bubble to overlay
	end)

	local detailPanel = Instance.new("Frame")
	detailPanel.Name              = "DetailPanel"
	detailPanel.Size              = UDim2.new(1,0,1,-44)
	detailPanel.Position          = UDim2.new(0,0,0,44)
	detailPanel.BackgroundColor3  = C_PANEL
	detailPanel.BorderSizePixel   = 0
	detailPanel.Visible           = false
	detailPanel.ZIndex            = 20
	detailPanel.ClipsDescendants  = true
	detailPanel.Parent            = frame

	-- Back button at top-left of detail panel
	local backBtn = Instance.new("TextButton")
	backBtn.Size             = UDim2.new(0,80,0,28)
	backBtn.Position         = UDim2.new(0,10,0,10)
	backBtn.BackgroundColor3 = C_BTN
	backBtn.Text             = "← Back"
	backBtn.TextColor3       = C_TEXT
	backBtn.TextSize         = 12
	backBtn.Font             = Enum.Font.GothamBold
	backBtn.BorderSizePixel  = 0
	backBtn.AutoButtonColor  = false
	backBtn.ZIndex           = 21
	backBtn.Parent           = detailPanel
	Instance.new("UICorner", backBtn).CornerRadius = UDim.new(0,6)
	local backStroke = Instance.new("UIStroke")
	backStroke.Color     = C_STROKE
	backStroke.Thickness = 1
	backStroke.Parent    = backBtn

	-- Entity image
	local entityImg = Instance.new("ImageLabel")
	entityImg.Size                   = UDim2.new(1,-24,0,180)
	entityImg.Position               = UDim2.new(0,12,0,48)
	entityImg.BackgroundColor3       = Color3.fromRGB(6,8,16)
	entityImg.BackgroundTransparency = 0
	entityImg.Image                  = ""
	entityImg.ScaleType              = Enum.ScaleType.Fit
	entityImg.ZIndex                 = 21
	entityImg.Parent                 = detailPanel
	Instance.new("UICorner", entityImg).CornerRadius = UDim.new(0,10)
	local imgStroke = Instance.new("UIStroke")
	imgStroke.Color     = C_STROKE
	imgStroke.Thickness = 1
	imgStroke.Parent    = entityImg

	-- Placeholder label inside image when blank
	local imgPlaceholder = Instance.new("TextLabel")
	imgPlaceholder.Size                 = UDim2.new(1,0,1,0)
	imgPlaceholder.BackgroundTransparency = 1
	imgPlaceholder.Text                 = "No Image"
	imgPlaceholder.TextColor3           = Color3.fromRGB(50,60,100)
	imgPlaceholder.TextSize             = 14
	imgPlaceholder.Font                 = Enum.Font.GothamBold
	imgPlaceholder.ZIndex               = 22
	imgPlaceholder.Parent               = entityImg

	-- Invisible click-catcher on top of image to open zoom
	-- (ImageLabel doesn't fire click events, so we overlay a TextButton)
	local imgClickBtn = Instance.new("TextButton")
	imgClickBtn.Size                 = UDim2.new(1,0,1,0)
	imgClickBtn.BackgroundTransparency = 1
	imgClickBtn.Text                 = ""
	imgClickBtn.ZIndex               = 23
	imgClickBtn.AutoButtonColor      = false
	imgClickBtn.Parent               = entityImg

	-- Zoom hint label bottom-right of image
	local zoomHint = Instance.new("TextLabel")
	zoomHint.Size                 = UDim2.new(0,70,0,18)
	zoomHint.Position             = UDim2.new(1,-74,1,-22)
	zoomHint.BackgroundColor3     = Color3.fromRGB(0,0,0)
	zoomHint.BackgroundTransparency = 0.4
	zoomHint.Text                 = "🔍 tap to zoom"
	zoomHint.TextColor3           = Color3.new(1,1,1)
	zoomHint.TextSize             = 9
	zoomHint.Font                 = Enum.Font.Gotham
	zoomHint.ZIndex               = 23
	zoomHint.Visible              = false   -- shown only when image exists
	zoomHint.Parent               = entityImg
	Instance.new("UICorner", zoomHint).CornerRadius = UDim.new(0,4)

	-- Entity name label
	local entityName = Instance.new("TextLabel")
	entityName.Size                 = UDim2.new(1,-24,0,28)
	entityName.Position             = UDim2.new(0,12,0,236)
	entityName.BackgroundTransparency = 1
	entityName.Text                 = ""
	entityName.TextColor3           = Color3.new(1,1,1)
	entityName.TextSize             = 16
	entityName.Font                 = Enum.Font.GothamBold
	entityName.TextXAlignment       = Enum.TextXAlignment.Left
	entityName.ZIndex               = 21
	entityName.Parent               = detailPanel

	-- Divider under name
	local nameDivider = Instance.new("Frame")
	nameDivider.Size             = UDim2.new(1,-24,0,1)
	nameDivider.Position         = UDim2.new(0,12,0,268)
	nameDivider.BackgroundColor3 = C_STROKE
	nameDivider.BorderSizePixel  = 0
	nameDivider.ZIndex           = 21
	nameDivider.Parent           = detailPanel

	-- Description scroll area — fills all space between divider and warn/morph at bottom
	-- AutomaticCanvasSize handles infinite content automatically — no manual CanvasSize needed
	local descScroll = Instance.new("ScrollingFrame")
	descScroll.Size                  = UDim2.new(1,-24, 1,-394)
	descScroll.Position              = UDim2.new(0,12,0,274)
	descScroll.BackgroundTransparency = 1
	descScroll.BorderSizePixel       = 0
	descScroll.ScrollBarThickness    = 8
	descScroll.ScrollBarImageColor3  = Color3.new(1,1,1)
	descScroll.ScrollingDirection    = Enum.ScrollingDirection.Y
	descScroll.CanvasSize            = UDim2.new(0,0,0,0)
	descScroll.AutomaticCanvasSize   = Enum.AutomaticSize.Y
	descScroll.ZIndex                = 21
	descScroll.Parent                = detailPanel
	Instance.new("UICorner", descScroll).CornerRadius = UDim.new(0,6)

	-- Fixed pixel width: panel=420, padding left/right=12+12=24, scrollbar=6, inner pad=8 → 420-24-6-8=382
	-- Using a fixed width guarantees TextWrapped calculates the correct height for AutomaticCanvasSize
	local entityDesc = Instance.new("TextLabel")
	entityDesc.Size                 = UDim2.new(0,368,0,0)
	entityDesc.Position             = UDim2.new(0,5,0,6)
	entityDesc.BackgroundTransparency = 1
	entityDesc.Text                 = ""
	entityDesc.TextColor3           = C_SUB
	entityDesc.TextSize             = 12
	entityDesc.Font                 = Enum.Font.Gotham
	entityDesc.TextXAlignment       = Enum.TextXAlignment.Left
	entityDesc.TextYAlignment       = Enum.TextYAlignment.Top
	entityDesc.TextWrapped          = true
	entityDesc.AutomaticSize        = Enum.AutomaticSize.Y
	entityDesc.ZIndex               = 22
	entityDesc.Parent               = descScroll

	-- Warning label — anchored above MORPH button at bottom of panel
	local detailWarn = Instance.new("TextLabel")
	detailWarn.Size                 = UDim2.new(1,-24,0,36)
	detailWarn.Position             = UDim2.new(0,12,1,-108)
	detailWarn.BackgroundTransparency = 1
	detailWarn.Text                 = ""
	detailWarn.TextColor3           = Color3.fromRGB(255,120,30)
	detailWarn.TextSize             = 10
	detailWarn.Font                 = Enum.Font.GothamBold
	detailWarn.TextXAlignment       = Enum.TextXAlignment.Left
	detailWarn.TextWrapped          = true
	detailWarn.ZIndex               = 21
	detailWarn.Parent               = detailPanel

	-- MORPH confirm button — anchored to bottom of panel
	local morphConfirmBtn = Instance.new("TextButton")
	morphConfirmBtn.Size             = UDim2.new(1,-24,0,52)
	morphConfirmBtn.Position         = UDim2.new(0,12,1,-64)
	morphConfirmBtn.BackgroundColor3 = C_GREEN
	morphConfirmBtn.Text             = "✔  MORPH"
	morphConfirmBtn.TextColor3       = Color3.new(1,1,1)
	morphConfirmBtn.TextSize         = 15
	morphConfirmBtn.Font             = Enum.Font.GothamBold
	morphConfirmBtn.BorderSizePixel  = 0
	morphConfirmBtn.AutoButtonColor  = false
	morphConfirmBtn.ZIndex           = 21
	morphConfirmBtn.Parent           = detailPanel
	Instance.new("UICorner", morphConfirmBtn).CornerRadius = UDim.new(0,10)

	-- Track which morph the detail panel is showing
	local detailMorphName = nil
	local _currentImgId   = ""

	imgClickBtn.MouseButton1Click:Connect(function()
		openZoom(_currentImgId)
	end)

	local function openDetailPanel(name)
		detailMorphName = name
		changelog.Visible  = false
		resetPopup.Visible = false

		local imgId, desc = getMorphInfo(name)
		_currentImgId         = imgId
		entityImg.Image       = imgId
		local hasImg = (imgId ~= "" and imgId ~= DEFAULT_IMAGE)
		imgPlaceholder.Visible = not hasImg
		zoomHint.Visible       = hasImg
		entityName.Text       = name
		entityDesc.Text       = desc
		-- AutomaticCanvasSize on descScroll handles sizing automatically — no manual update needed

		local isNoRemorph = (name == "Roaring Knight") or (name == "junkyard foxy")
		local isPermanent = (name == "The Entity")     or (name == "Golden Freddy")
		if isNoRemorph then
			detailWarn.Text       = "⚠ CANNOT REMORPH AS THIS — you're stuck until you leave"
			detailWarn.TextColor3 = Color3.fromRGB(255,130,30)
		elseif isPermanent then
			detailWarn.Text       = "⚠ ONCE YOU'RE MORPHED YOU'RE FOREVER LIKE THAT, EVEN REJOINING DOESN'T FIX IT, YOU HAVE TO JOIN A NEW SERVER"
			detailWarn.TextColor3 = Color3.fromRGB(255,50,50)
		else
			detailWarn.Text = ""
		end

		-- Block clicks on the morph list behind the panel
		clickBlocker.Visible = true

		-- SPLIT-EXPAND animation:
		-- Panel starts as a thin sliver at the vertical centre of the frame,
		-- then blooms open (top half rises, bottom half drops) while fading in.
		detailPanel.ClipsDescendants = true
		detailPanel.Position         = UDim2.new(0,0,0.5,-2)
		detailPanel.Size             = UDim2.new(1,0,0,4)
		detailPanel.BackgroundTransparency = 0.8
		detailPanel.Visible          = true

		-- Phase 1: fast horizontal flash (the "crack")
		TweenService:Create(detailPanel, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(1,0,0,10),
			BackgroundTransparency = 0.4,
		}):Play()
		task.wait(0.08)

		-- Phase 2: bloom open to full size from centre
		TweenService:Create(detailPanel, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Position             = UDim2.new(0,0,0,44),
			Size                 = UDim2.new(1,0,1,-44),
			BackgroundTransparency = 0,
		}):Play()
		task.delay(0.29, function()
			if detailPanel and detailPanel.Parent then
				detailPanel.ClipsDescendants = true
			end
		end)
	end

	local function closeDetailPanel()
		clickBlocker.Visible = false
		-- Collapse back to a sliver then vanish
		TweenService:Create(detailPanel, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
			Position             = UDim2.new(0,0,0.5,-2),
			Size                 = UDim2.new(1,0,0,4),
			BackgroundTransparency = 1,
		}):Play()
		task.delay(0.19, function()
			if detailPanel and detailPanel.Parent then
				detailPanel.Visible              = false
				detailPanel.BackgroundTransparency = 0
				detailPanel.Size                 = UDim2.new(1,0,1,-44)
				detailPanel.Position             = UDim2.new(0,0,0,44)
			end
		end)
		detailMorphName = nil
		_currentImgId   = ""
	end

	backBtn.MouseButton1Click:Connect(function()
		closeDetailPanel()
	end)
	addPressEffect(backBtn, C_BTN, C_HOV)

	addPressEffect(morphConfirmBtn, C_GREEN, Color3.fromRGB(20,120,55))

	morphConfirmBtn.MouseButton1Click:Connect(function()
		if not detailMorphName then return end
		local name = detailMorphName

		morphConfirmBtn.Text             = "⟳ Morphing..."
		morphConfirmBtn.BackgroundColor3 = Color3.fromRGB(15,80,35)

		statusBar.Text       = "⟳ Morphing: "..name
		statusBar.TextColor3 = Color3.fromRGB(255,200,50)

		morphRequestEvent:FireServer(name)
		if _G.onMorphSelected then _G.onMorphSelected(name) end

		-- Show loading screen
		showLoadScreen(name)

		-- Safety fallback: hide after 15s if server never responds
		task.delay(15, function()
			if loadScreen and loadScreen.Visible then
				hideLoadScreen()
			end
		end)

		task.delay(3.5, function()
			if morphConfirmBtn and morphConfirmBtn.Parent then
				morphConfirmBtn.Text             = "✔  MORPH"
				morphConfirmBtn.BackgroundColor3 = C_GREEN
			end
			if statusBar and statusBar.Parent and statusBar.Text:find("Morphing") then
				statusBar.Text       = "✔ Applied: "..name
				statusBar.TextColor3 = Color3.fromRGB(80,200,120)
			end
		end)

		task.delay(1, function()
			closeDetailPanel()
		end)
	end)

	-- ==================== STATE ====================
	local allButtons      = {}
	local currentSelected = nil
	local activeTab       = "trevor"

	local function clearSelection()
		if currentSelected then
			pcall(function()
				if currentSelected.btn and currentSelected.btn.Parent then
					TweenService:Create(currentSelected.btn, TweenInfo.new(0.1), {BackgroundColor3 = C_BTN}):Play()
				end
				if currentSelected.stroke and currentSelected.stroke.Parent then
					TweenService:Create(currentSelected.stroke, TweenInfo.new(0.1), {Color = C_STROKE}):Play()
				end
			end)
			currentSelected = nil
		end
	end

	local function setTabVisuals(tab)
		local tabs = {
			{btn=tabTrevor,    id="trevor"},
			{btn=tabDoctor,    id="doctor"},
			{btn=tabSCP,       id="scp"},
			{btn=tabHL,        id="halflife"},
			{btn=tabCoF,       id="cof"},
			{btn=tabBackrooms, id="backrooms"},
			{btn=tabPPT,       id="ppt"},
			{btn=tabSF,        id="sf"},
			{btn=tabPillar,    id="pillarchase"},
			{btn=tabDOD,       id="dod"},
			{btn=tabFNAF,      id="fnaf"},
			{btn=tabOthers,    id="others"},
			{btn=tabFeatured,  id="featured"},
		}
		for _, t in ipairs(tabs) do
			if t.id == tab then
				if t.id == "featured" then
					TweenService:Create(t.btn, TweenInfo.new(0.1), {BackgroundColor3 = C_GOLD}):Play()
					t.btn.TextColor3 = Color3.fromRGB(20,20,30)
				else
					TweenService:Create(t.btn, TweenInfo.new(0.1), {BackgroundColor3 = C_TAB_ON}):Play()
					t.btn.TextColor3 = Color3.new(1,1,1)
				end
			else
				if t.id == "featured" then
					TweenService:Create(t.btn, TweenInfo.new(0.1), {BackgroundColor3 = C_GOLD_DK}):Play()
					t.btn.TextColor3 = Color3.fromRGB(255,255,220)
				else
					TweenService:Create(t.btn, TweenInfo.new(0.1), {BackgroundColor3 = C_TAB_OFF}):Play()
					t.btn.TextColor3 = C_SUB
				end
			end
		end
	end

	local function showMorphList()
		pwFrame.Visible    = false
		mFrame.Visible     = true
		frame.Visible      = true
		restoreBtn.Visible = false
		if minimized then
			minimized = false
			minBtn.Text = "-"
			TweenService:Create(frame, TweenInfo.new(0.18), {Size = UDim2.new(0,420,0,620)}):Play()
		end
	end

	-- ==================== FEATURED MORPH STATE ====================
	local featuredMorphName = ""
	local featuredTimeLeft  = 0

	local function formatFeaturedTime(seconds)
		seconds = math.max(0, math.floor(seconds))
		local h = math.floor(seconds / 3600)
		local m = math.floor((seconds % 3600) / 60)
		local s = seconds % 60
		return string.format("%02d:%02d:%02d", h, m, s)
	end

	-- ==================== MORPH BUTTONS ====================
	local function buildButtons(filter)
		for _, b in ipairs(allButtons) do pcall(function() b:Destroy() end) end
		allButtons      = {}
		currentSelected = nil
		closeDetailPanel()

		local count = 0
		if activeTab == "featured" then
			countLbl.Text = "⭐ Today's featured morph — click to view!"
			-- Show a single featured morph button
			if featuredMorphName ~= "" then
				local wrapper = Instance.new("Frame")
				wrapper.Size                 = UDim2.new(1,0,0,60)
				wrapper.BackgroundTransparency = 1
				wrapper.LayoutOrder          = 1
				wrapper.Parent               = scroll

				local fbtn = Instance.new("TextButton")
				fbtn.Size             = UDim2.new(1,0,1,0)
				fbtn.BackgroundColor3 = C_GOLD_DK
				fbtn.Text             = "  ⭐ " .. featuredMorphName
				fbtn.TextColor3       = Color3.new(1,1,1)
				fbtn.TextSize         = 14
				fbtn.Font             = Enum.Font.GothamBold
				fbtn.TextXAlignment   = Enum.TextXAlignment.Left
				fbtn.BorderSizePixel  = 0
				fbtn.AutoButtonColor  = false
				fbtn.Parent           = wrapper
				Instance.new("UICorner", fbtn).CornerRadius = UDim.new(0,7)
				local fStk = Instance.new("UIStroke")
				fStk.Color     = C_GOLD
				fStk.Thickness = 2
				fStk.Parent    = fbtn

				local arrow = Instance.new("TextLabel")
				arrow.Size                 = UDim2.new(0,20,1,0)
				arrow.Position             = UDim2.new(1,-24,0,0)
				arrow.BackgroundTransparency = 1
				arrow.Text                 = "›"
				arrow.TextColor3           = Color3.new(1,1,1)
				arrow.TextSize             = 18
				arrow.Font                 = Enum.Font.GothamBold
				arrow.ZIndex               = 2
				arrow.Parent               = fbtn

				local timerLbl = Instance.new("TextLabel")
				timerLbl.Size                 = UDim2.new(1,-30,0,16)
				timerLbl.Position             = UDim2.new(0,18,1,-20)
				timerLbl.BackgroundTransparency = 1
				timerLbl.Text                 = "Rotates in: " .. formatFeaturedTime(featuredTimeLeft)
				timerLbl.TextColor3           = Color3.fromRGB(255,255,200)
				timerLbl.TextSize             = 10
				timerLbl.Font                 = Enum.Font.Gotham
				timerLbl.TextXAlignment       = Enum.TextXAlignment.Left
				timerLbl.Parent               = fbtn

				addPressEffect(fbtn, C_GOLD_DK, C_GOLD)
				fbtn.MouseButton1Click:Connect(function()
					openDetailPanel(featuredMorphName)
				end)

				table.insert(allButtons, wrapper)
			end
			return
		end
		for i, name in ipairs(MORPH_NAMES) do
			if getCategory(name) ~= activeTab then continue end
			if filter ~= "" and not name:lower():find(filter:lower(), 1, true) then continue end

			local wrapper = Instance.new("Frame")
			wrapper.Size                 = UDim2.new(1,0,0,38)
			wrapper.BackgroundTransparency = 1
			wrapper.LayoutOrder          = i
			wrapper.Parent               = scroll

			local btn = Instance.new("TextButton")
			btn.Size             = UDim2.new(1,0,1,0)
			btn.BackgroundColor3 = C_BTN
			btn.Text             = "  "..name
			btn.TextColor3       = C_TEXT
			btn.TextSize         = 12
			btn.Font             = Enum.Font.Gotham
			btn.TextXAlignment   = Enum.TextXAlignment.Left
			btn.BorderSizePixel  = 0
			btn.AutoButtonColor  = false
			btn.Parent           = wrapper
			Instance.new("UICorner", btn).CornerRadius = UDim.new(0,7)

			-- Small chevron arrow on right to hint at detail panel
			local arrow = Instance.new("TextLabel")
			arrow.Size                 = UDim2.new(0,20,1,0)
			arrow.Position             = UDim2.new(1,-24,0,0)
			arrow.BackgroundTransparency = 1
			arrow.Text                 = "›"
			arrow.TextColor3           = C_SUB
			arrow.TextSize             = 18
			arrow.Font                 = Enum.Font.GothamBold
			arrow.ZIndex               = 2
			arrow.Parent               = btn

			local bStroke = Instance.new("UIStroke")
			bStroke.Color     = C_STROKE
			bStroke.Thickness = 1
			bStroke.Parent    = btn

			btn.MouseEnter:Connect(function()
				if not currentSelected or currentSelected.btn ~= btn then
					TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = C_HOV}):Play()
					arrow.TextColor3 = Color3.new(1,1,1)
				end
			end)
			btn.MouseLeave:Connect(function()
				if not currentSelected or currentSelected.btn ~= btn then
					TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = C_BTN}):Play()
					arrow.TextColor3 = C_SUB
				end
			end)
			-- Press effect (sound fires in addPressEffect's MouseButton1Down)
			do
				local pressedBg = C_BTN:Lerp(Color3.new(0,0,0), 0.32)
				btn.MouseButton1Down:Connect(function()
					playClick()
					TweenService:Create(btn, TweenInfo.new(0.07, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						BackgroundColor3 = pressedBg,
						Position = UDim2.new(0,0,0,2),
					}):Play()
				end)
				btn.MouseButton1Up:Connect(function()
					TweenService:Create(btn, TweenInfo.new(0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
						BackgroundColor3 = C_BTN,
						Position = UDim2.new(0,0,0,0),
					}):Play()
				end)
			end
			btn.MouseButton1Click:Connect(function()
				clearSelection()
				currentSelected = {btn = btn, stroke = bStroke}
				TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = C_SEL}):Play()
				TweenService:Create(bStroke, TweenInfo.new(0.1), {Color = C_ACCENT}):Play()
				openDetailPanel(name)
			end)

			table.insert(allButtons, wrapper)
			count = count + 1
		end

		local tabLabels = {
			trevor="Trevor Henderson", doctor="Doctor Nowhere", scp="SCP",
			halflife="Half-Life", cof="Cry of Fear", backrooms="Backrooms",
			ppt="Poppy Playtime", sf="Slender Fortress", pillarchase="Pillar Chase",
			dod="Die of Death", fnaf="FNAF", others="Others", featured="Featured"
		}
		countLbl.Text = count..(filter ~= "" and " results" or (" morphs in "..(tabLabels[activeTab] or activeTab)))
	end

	-- Tab click handlers
	local function fetchAndShowFeatured()
		task.spawn(function()
			local ok, name, timeLeft = pcall(function()
				return getFeaturedFunc:InvokeServer()
			end)
			if ok and name and name ~= "" then
				featuredMorphName = name
				featuredTimeLeft  = timeLeft or 0
				tabFeatured.Text  = "⭐ FEATURED: " .. name
				if activeTab == "featured" then
					buildButtons("")
					openDetailPanel(featuredMorphName)
				end
			else
				tabFeatured.Text = "⭐ FEATURED MORPH"
			end
		end)
	end

	-- Fetch featured morph on load
	fetchAndShowFeatured()

	-- Listen for rotation updates from server
	if featuredUpdatedEvt then
		table.insert(_guiConnections, featuredUpdatedEvt.OnClientEvent:Connect(function(newName, newTimeLeft)
			featuredMorphName = newName
			featuredTimeLeft  = newTimeLeft or 0
			tabFeatured.Text  = "⭐ FEATURED: " .. newName
			if activeTab == "featured" then
				buildButtons("")
				openDetailPanel(newName)
			end
		end))
	end

	-- Countdown timer for featured morph
	_countdownActive = true
	task.spawn(function()
		while _countdownActive do
			task.wait(1)
			if featuredTimeLeft > 0 then
				featuredTimeLeft = featuredTimeLeft - 1
			end
		end
	end)

	local function switchTab(id)
		if activeTab == id then return end
		activeTab = id
		setTabVisuals(id)
		searchBox.Text = ""
		if id == "featured" then
			if featuredMorphName ~= "" then
				buildButtons("")
				openDetailPanel(featuredMorphName)
			else
				fetchAndShowFeatured()
			end
		else
			buildButtons("")
		end
	end

	tabTrevor.MouseButton1Click:Connect(function()    switchTab("trevor")      end)
	tabDoctor.MouseButton1Click:Connect(function()    switchTab("doctor")      end)
	tabSCP.MouseButton1Click:Connect(function()       switchTab("scp")         end)
	tabHL.MouseButton1Click:Connect(function()        switchTab("halflife")    end)
	tabCoF.MouseButton1Click:Connect(function()       switchTab("cof")         end)
	tabBackrooms.MouseButton1Click:Connect(function() switchTab("backrooms")   end)
	tabPPT.MouseButton1Click:Connect(function()       switchTab("ppt")         end)
	tabSF.MouseButton1Click:Connect(function()        switchTab("sf")          end)
	tabPillar.MouseButton1Click:Connect(function()    switchTab("pillarchase") end)
	tabDOD.MouseButton1Click:Connect(function()       switchTab("dod")         end)
	tabFNAF.MouseButton1Click:Connect(function()      switchTab("fnaf")        end)
	tabOthers.MouseButton1Click:Connect(function()    switchTab("others")      end)
	tabFeatured.MouseButton1Click:Connect(function()  switchTab("featured")    end)

	searchBox:GetPropertyChangedSignal("Text"):Connect(function()
		buildButtons(searchBox.Text)
	end)

	-- Minimize / Close
	minBtn.MouseButton1Click:Connect(function()
		minimized = not minimized
		local h = minimized and 44 or 620
		TweenService:Create(frame, TweenInfo.new(0.18), {Size = UDim2.new(0,420,0,h)}):Play()
		minBtn.Text = minimized and "+" or "-"
	end)
	closeBtn.MouseButton1Click:Connect(function()
		frame.Visible      = false
		restoreBtn.Visible = true
	end)
	restoreBtn.MouseButton1Click:Connect(function()
		frame.Visible      = true
		restoreBtn.Visible = false
	end)

	-- Drag
	local dragging, dragStartMouse, dragStartPos = false, nil, nil
	tbar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging       = true
			dragStartMouse = input.Position
			dragStartPos   = frame.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if not dragging then return end
		if input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
		local delta = input.Position - dragStartMouse
		frame.Position = UDim2.new(
			dragStartPos.X.Scale, dragStartPos.X.Offset + delta.X,
			dragStartPos.Y.Scale, dragStartPos.Y.Offset + delta.Y
		)
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
	end)

	-- Password logic
	local function shakeBox()
		local orig = codeBox.Position
		for i = 1, 4 do
			TweenService:Create(codeBox, TweenInfo.new(0.04), {
				Position = UDim2.new(orig.X.Scale, orig.X.Offset+(i%2==0 and 8 or -8), orig.Y.Scale, orig.Y.Offset)
			}):Play()
			task.wait(0.05)
		end
		codeBox.Position = orig
	end

	local function checkCode()
		local entered = codeBox.Text:gsub("%s",""):lower()
		if entered == CORRECT_CODE then
			isUnlocked = true
			notifyUnlockEvent:FireServer()
			showMorphList()
			buildButtons("")
			print("[MorphGUI] Unlocked!")
		else
			pwStatusLbl.Text = "✘ Incorrect code."
			task.spawn(shakeBox)
			codeBox.Text = ""
		end
	end

	submitBtn.MouseButton1Click:Connect(checkCode)
	codeBox.FocusLost:Connect(function(enter) if enter then checkCode() end end)
	addPressEffect(submitBtn, C_ACCENT, C_DARK)

	if isUnlocked then
		showMorphList()
		buildButtons("")
		print("[MorphGUI] Already unlocked — skipping password")
	end

	print("[MorphGUI] GUI ready — v4.0")
end

-- ============================================
-- INITIAL BUILD
-- ============================================
buildGUI()

-- ============================================
-- JUMPSCARE — guarded by _G so re-injection is safe
-- ============================================
if not _G.tinkyJsConn then
	_G.tinkyJsConn = tinkyJumpscareEvent.OnClientEvent:Connect(function()
		local pg  = Players.LocalPlayer:WaitForChild("PlayerGui")
		local old = pg:FindFirstChild("TinkyJumpscareGui")
		if old then old:Destroy() end

		local gui = Instance.new("ScreenGui")
		gui.Name           = "TinkyJumpscareGui"
		gui.ResetOnSpawn   = false
		gui.DisplayOrder   = 999999
		gui.IgnoreGuiInset = true
		gui.Parent         = pg

		local img = Instance.new("ImageLabel")
		img.Size                   = UDim2.new(1,0,1,0)
		img.Position               = UDim2.new(0,0,0,0)
		img.BackgroundTransparency = 1
		img.Image                  = "rbxassetid://135031432973473"
		img.ImageTransparency      = 0
		img.ZIndex                 = 10
		img.Parent                 = gui

		local snd = Instance.new("Sound")
		snd.SoundId = "rbxassetid://115251316814736"
		snd.Volume  = 10
		snd.Parent  = gui
		snd:Play()

		local distortionFrames = {}
		for i = 1, 8 do
			local df = Instance.new("Frame")
			df.Size                   = UDim2.new(1, math.random(-60,60), 0, math.random(20,80))
			df.Position               = UDim2.new(0, math.random(-40,40), math.random()*0.9, 0)
			df.BackgroundColor3       = Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255))
			df.BackgroundTransparency = 0.5
			df.BorderSizePixel        = 0
			df.ZIndex                 = 11
			df.Parent                 = gui
			table.insert(distortionFrames, df)
		end

		local redStrip = Instance.new("Frame")
		redStrip.Size                   = UDim2.new(1,0,1,0)
		redStrip.BackgroundColor3       = Color3.fromRGB(255,0,0)
		redStrip.BackgroundTransparency = 0.8
		redStrip.BorderSizePixel        = 0
		redStrip.ZIndex                 = 12
		redStrip.Parent                 = gui

		local blueStrip = Instance.new("Frame")
		blueStrip.Size                   = UDim2.new(1,0,1,0)
		blueStrip.BackgroundColor3       = Color3.fromRGB(0,0,255)
		blueStrip.BackgroundTransparency = 0.8
		blueStrip.BorderSizePixel        = 0
		blueStrip.ZIndex                 = 12
		blueStrip.Parent                 = gui

		local shakeActive = true
		local t0 = tick()
		task.spawn(function()
			while shakeActive do
				game:GetService("RunService").RenderStepped:Wait()
				if not gui.Parent then shakeActive = false break end
				local e = tick() - t0
				if e > 10 then shakeActive = false break end
				local intensity = e < 2 and 1 or math.max(0, 1-(e-2)/8)
				img.Position = UDim2.new(0,(math.random()*2-1)*22*intensity,0,(math.random()*2-1)*22*intensity)
				if e < 6 then
					for _, df in ipairs(distortionFrames) do
						if math.random() < 0.35 then
							df.Position               = UDim2.new(0,math.random(-60,60),math.random()*0.85,0)
							df.BackgroundTransparency = 0.3+math.random()*0.5
							df.Size                   = UDim2.new(1,math.random(-60,60),0,math.random(15,70))
						end
					end
				end
				local aberr = math.sin(e*15)*16*intensity
				redStrip.Position  = UDim2.new(0, aberr,0,0)
				blueStrip.Position = UDim2.new(0,-aberr,0,0)
			end
		end)

		task.delay(2, function()
			if not gui.Parent then return end
			TweenService:Create(img, TweenInfo.new(2), {ImageTransparency=1}):Play()
			for _, df in ipairs(distortionFrames) do
				TweenService:Create(df, TweenInfo.new(2), {BackgroundTransparency=1}):Play()
			end
		end)
		task.delay(4, function()
			if not gui.Parent then return end
			img.Visible = false
			TweenService:Create(redStrip,  TweenInfo.new(1), {BackgroundTransparency=0.92}):Play()
			TweenService:Create(blueStrip, TweenInfo.new(1), {BackgroundTransparency=0.92}):Play()
		end)
		task.delay(8, function()
			if not gui.Parent then return end
			TweenService:Create(redStrip,  TweenInfo.new(2), {BackgroundTransparency=1}):Play()
			TweenService:Create(blueStrip, TweenInfo.new(2), {BackgroundTransparency=1}):Play()
		end)
		task.delay(10, function()
			shakeActive = false
			if gui and gui.Parent then gui:Destroy() end
		end)

		local char = Players.LocalPlayer.Character
		if char then
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then
				hum.Died:Connect(function()
					shakeActive = false
					if gui and gui.Parent then gui:Destroy() end
				end)
			end
		end
	end)
end

-- ============================================
-- REALISM DEATH ANGEL
-- ============================================
local Lighting        = game:GetService("Lighting")
local rdaActive       = false
local rdaPollThread   = nil
local rdaConnections  = {}
local rdaState        = {}
local savedFogEnd, savedFogStart, savedFogColor, savedAmbient, savedBrightness

local NORMAL_SPEED = 16

local function getDistance(target)
	local mc = player.Character
	local tc = target.Character
	if not mc or not tc then return math.huge end
	local a = mc:FindFirstChild("HumanoidRootPart")
	local b = tc:FindFirstChild("HumanoidRootPart")
	if not a or not b then return math.huge end
	return (a.Position - b.Position).Magnitude
end

local function isFast(target)
	local tc = target.Character
	if not tc then return false end
	local hrp = tc:FindFirstChild("HumanoidRootPart")
	local hum = tc:FindFirstChildOfClass("Humanoid")
	if not hrp or not hum then return false end
	return math.abs(hrp.Velocity.Y) > 2 or hum.WalkSpeed > NORMAL_SPEED
end

local function setPartsTransparency(target, t)
	local tc = target.Character
	if not tc then return end
	for _, v in ipairs(tc:GetDescendants()) do
		if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then v.Transparency = t end
		if v:IsA("Decal") or v:IsA("Texture") then v.Transparency = t end
	end
end

local function clearRDAState(userId)
	local s = rdaState[userId]
	if not s then return end
	if s.highlight and s.highlight.Parent then s.highlight:Destroy() end
	s.highlight = nil
	if s.timerThread then task.cancel(s.timerThread) end
	s.timerThread = nil
	s.tier = "none"
end

local function applyTier(target, tier, duration, depthMode, color)
	local userId = target.UserId
	if not rdaState[userId] then rdaState[userId] = {tier="none"} end
	local s = rdaState[userId]
	if s.highlight and s.highlight.Parent then s.highlight:Destroy() end
	s.highlight = nil
	if s.timerThread then task.cancel(s.timerThread) end
	s.timerThread = nil

	local hl = Instance.new("Highlight")
	hl.FillColor           = color
	hl.OutlineColor        = color
	hl.FillTransparency    = depthMode == "through" and 0.7 or 0.88
	hl.OutlineTransparency = depthMode == "through" and 0.3 or 0.7
	hl.DepthMode           = depthMode == "through"
		and Enum.HighlightDepthMode.AlwaysOnTop
		or  Enum.HighlightDepthMode.Occluded
	hl.Adornee             = target.Character
	hl.Parent              = workspace

	s.highlight   = hl
	s.timerThread = task.delay(duration, function()
		if hl and hl.Parent then hl:Destroy() end
		s.highlight = nil
		if rdaState[userId] then rdaState[userId].tier = "none" end
	end)
end

local function pollPlayers()
	while rdaActive do
		task.wait(0.3)
		for _, target in ipairs(Players:GetPlayers()) do
			if target == player then continue end
			local dist  = getDistance(target)
			local fast  = isFast(target)
			local vDist = fast and 90  or 50
			local rDist = fast and 200 or 100
			local wDist = fast and 300 or 200

			local newTier
			if      dist <= vDist then newTier = "visible"
			elseif  dist <= rDist then newTier = "red"
			elseif  dist <= wDist then newTier = "white"
			else                       newTier = "far"
			end

			local userId = target.UserId
			if not rdaState[userId] then rdaState[userId] = {tier="none"} end
			local s = rdaState[userId]

			if newTier ~= s.tier then
				s.tier = newTier
				if newTier == "visible" then
					setPartsTransparency(target, 0)
					applyTier(target, "visible", 20, "through", Color3.fromRGB(255,0,0))
				elseif newTier == "red" then
					setPartsTransparency(target, 1)
					applyTier(target, "red",     10, "through", Color3.fromRGB(255,0,0))
				elseif newTier == "white" then
					setPartsTransparency(target, 1)
					applyTier(target, "white",    5, "surface", Color3.fromRGB(255,255,255))
				else
					setPartsTransparency(target, 1)
					clearRDAState(userId)
					s.tier = "far"
				end
			end
		end
	end
end

local function startRDA()
	rdaActive       = true
	savedFogEnd     = Lighting.FogEnd
	savedFogStart   = Lighting.FogStart
	savedFogColor   = Lighting.FogColor
	savedAmbient    = Lighting.Ambient
	savedBrightness = Lighting.Brightness

	Lighting.FogColor   = Color3.new(0,0,0)
	Lighting.FogStart   = 0
	Lighting.FogEnd     = 50
	Lighting.Ambient    = Color3.new(0,0,0)
	Lighting.Brightness = 0

	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= player then setPartsTransparency(p, 1) end
	end
	rdaPollThread = task.spawn(pollPlayers)

	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= player then
			local c = p.CharacterAdded:Connect(function()
				if rdaActive then setPartsTransparency(p, 1) end
			end)
			table.insert(rdaConnections, c)
		end
	end
	local jc = Players.PlayerAdded:Connect(function(p)
		if rdaActive then setPartsTransparency(p, 1) end
	end)
	table.insert(rdaConnections, jc)
end

local function stopRDA()
	rdaActive = false
	if rdaPollThread then task.cancel(rdaPollThread); rdaPollThread = nil end
	for _, c in ipairs(rdaConnections) do pcall(function() c:Disconnect() end) end
	rdaConnections = {}
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= player then setPartsTransparency(p, 0) end
		local s = rdaState[p.UserId]
		if s then
			if s.highlight and s.highlight.Parent then s.highlight:Destroy() end
			if s.timerThread then task.cancel(s.timerThread) end
		end
	end
	rdaState = {}
	if savedFogEnd ~= nil then
		Lighting.FogEnd     = savedFogEnd
		Lighting.FogStart   = savedFogStart
		Lighting.FogColor   = savedFogColor
		Lighting.Ambient    = savedAmbient
		Lighting.Brightness = savedBrightness
		savedFogEnd = nil
	end
end

local _prevOnMorphSelected = _G.onMorphSelected
_G.onMorphSelected = function(morphName)
	if morphName == "Realism Death Angel" then
		if not rdaActive then startRDA() end
	else
		if rdaActive then stopRDA() end
	end
	if _prevOnMorphSelected then _prevOnMorphSelected(morphName) end
end

-- ============================================
-- WATCHDOG — GUI self-heals every 1s
-- ============================================
local _rebuilding = false
while task.wait(1) do
	if not screen or not screen.Parent then
		if _rebuilding then continue end
		_rebuilding = true
		print("[MorphGUI] Screen missing — rebuilding")
		task.wait(0.3)
		buildGUI()
		_rebuilding = false
	end
end

print("[MorphGUI] Running — v4.0")

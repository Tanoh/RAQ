-- pve achievements in Cataclysm.

function RAQ_Achievements_InitCataclysm()
	local exp = "cata"
	local pve = "pve"

	RAQ_AddExpansion({
		key = exp,
		name = "Cataclysm",
		sort = 40
	})
	
	-- party instances.
	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		name = "Blackrock Caverns",
		ids = { 5281, 5282, 5283, 5284 }
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		name = "Throne of the Tides",
		ids = { 5285, 5286 }
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		name = "Stonecore",
		ids = { 5287 }
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		name = "Vortex Pinnacle",
		ids = { 5288, 5289 }
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		name = "Lost City of the Tol'vir",
		ids = { 5290, 5291, 5292 }
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		name = "Halls of Origination",
		ids = { 5293, 5294, 5295, 5296 }
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		name = "Grim Batol",
		ids = { 5297, 5298 }
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		name = "Deadmines",
		ids = { 5366, 5367, 5368, 5369, 5370, 5371 }
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		name = "Shadowfang Keep",
		ids = { 5503, 5504, 5505 }
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		name = "Hour of Twilight",
		ids = { 6119, 6132 }
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		name = "End Time",
		ids = { 6117, 5995, 6130 }
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		name = "Well of Eternity",
		ids = { 6118, 6070, 6127 }
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		name = "Zul'Aman",
		ids = { 5750, 5760, 5761, 5769 }
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		name = "Zul'Gurub",
		ids = { 5743, 5744, 5759, 5762, 5765, 5768 }
	})

	-- raids
	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		subcategory = "raid",
		name = "Blackwing Descent",
		ids = {
			[5308] = "Atramedes", -- Silence is Golden
			[5109] = "Atramedes", -- Heroic: Atramedes

			[5309] = "Chimaeron", -- Full of Sound and Fury
			[5115] = "Chimaeron", -- Heroic: Chimaeron

			[5306] = "Magmaw", -- Parasite Evening
			[5094] = "Magmaw", -- Heroic: Magmaw

			[5310] = "Maloriak", -- Aberrant Behavior
			[5108] = "Maloriak", -- Heroic: Maloriak

			[4849] = "Nefarian", -- Keeping it in the Family
			[5116] = "Nefarian", -- Heroic: Nefarian

			[5307] = "Omnotron Defense System", -- Achieve-a-tron
			[5107] = "Omnotron Defense System", -- Heroic: Omnotron Defense System

			[4842] = "", -- Blackwing Descent
		}
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		subcategory = "raid",
		name = "Bastion of Twilight",
		ids = {
			[4852] = "Valiona and Theralion", -- Double Dragon
			[5117] = "Valiona and Theralion", -- Heroic: Valiona and Theralion

			[5311] = "Ascendant Council", -- Elementary
			[5119] = "Ascendant Council", -- Heroic: Ascendant Council

			[5300] = "Halfus Wyrmbreaker", -- The Only Escape
			[5118] = "Halfus Wyrmbreaker", -- Heroic: Halfus Wyrmbreaker

			[5312] = "Cho'gall", -- The Abyss Will Gaze Back Into You
			[5120] = "Cho'gall", -- Heroic: Cho'gall

			[5313] = "Sinestra", -- I Can't Hear You Over the Sound of How Awesome I Am	
			[5121] = "Sinestra", -- Heroic: Sinestra

			[4850] = "", -- The Bastion of Twilight
		}
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		subcategory = "raid",
		name = "Throne of the Four Winds",
		ids = {
			[5305] = "Al'Akir", -- Four Play
			[5123] = "Al'Akir", -- Heroic: Al'Akir

			[5304] = "Conclave of Wind", -- Stay Chill
			[5122] = "Conclave of Wind", -- Heroic: Conclave of Wind

			[4851] = "", -- Throne of the Four Winds
		}
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		subcategory = "raid",
		name = "Firelands",
		ids = {
			[5799] = "Majordomo Staghelm", -- Only the Penitent...
			[5804] = "Majordomo Staghelm", -- Heroic: Majordomo Fandral Staghelm
			[5805] = "Baleroc", -- Heroic: Baleroc
			[5830] = "Baleroc", -- Share the Pain
			[5806] = "Shannox", -- Heroic: Shannox
			[5829] = "Shannox", -- Bucket List
			[5807] = "Beth'tilac", -- Heroic: Beth'tilac
			[5821] = "Beth'tilac", -- Death from Above
			[5808] = "Lord Rhyolith", -- Heroic: Lord Rhyolith
			[5810] = "Lord Rhyolith", -- Not an Ambi-Turner
			[5809] = "Alysrazor", -- Heroic: Alysrazor
			[5813] = "Alysrazor", -- Do a Barrel Roll!
		}
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		subcategory = "raid",
		name = "Dragon Soul",
		ids = {
			[6107] = "", -- Fall of Deathwing

			[6174] = "Morchok", -- Don't Stand So Close to Me
			[6109] = "Morchok", -- Heroic: Morchok

			[6129] = "Yor'sahj the Unsleeping", -- Taste the Rainbow!
			[6111] = "Yor'sahj the Unsleeping", -- Heroic: Yor'sahj the Unsleeping

			[6128] = "Warlord Zon'ozz", -- Ping Pong Champion
			[6110] = "Warlord Zon'ozz", -- Heroic: Warlord Zon'ozz

			[6175] = "Hagara the Stormbinder", -- Holding Hands
			[6112] = "Hagara the Stormbinder", -- Heroic: Hagara the Stormbinder

			[6084] = "Ultraxio", -- Minutes to Midnight
			[6113] = "Ultraxion", -- Heroic: Ultraxion

			[6105] = "Warmaster Blackhorn", -- Deck Defender
			[6114] = "Warmaster Blackhorn", -- Heroic: Warmaster Blackhorn

			[6133] = "Spine of Deathwing", -- Maybe He'll Get Dizzy...
			[6115] = "Spine of Deathwing", -- Heroic: Spine of Deathwing

			[6180] = "Deathwing", -- Chromatic Champion
			[6116] = "Madness of Deathwing", -- Heroic: Madness of Deathwing

			[6106] = "", -- Siege of Wyrmrest Temple
			[6177] = "", -- Destroyer's End
			[6107] = "", -- Fall of Deathwing
		}
	})

	-- Meta
	RAQ_AddMeta({
		expansion = exp,
		category = pve,
		name = "Glory of the Cataclysm Hero",
		ids = {
			5281, 5282, 5283, 5284, 5285, 5286, 5287, 5288, 5289,
			5290, 5291, 5292, 5293, 5294, 5295, 5296, 5297, 5298,
			5366, 5367, 5368, 5369, 5370, 5371, 5503, 5504, 5505
		}
	})

	RAQ_AddMeta({
		expansion = exp,
		category = pve,
		name = "Glory of the Cataclysm Raider",
		ids = {
			5094, 5107, 5108, 5109, 5115, 5116, 5118, 5117, 5119,
			5120, 5122, 5123, 5306, 5307, 5308, 5309, 5310, 4849,
			5300, 4852, 5311, 5312, 5304, 5305
		}
	})

	RAQ_AddMeta({
		expansion = exp,
		category = pve,
		name = "Glory of the Firelands Raider",
		ids = {
			5821, 5810, 5813, 5829, 5830, 5799, 5807, 5808, 5806,
			5809, 5805, 5804
		}	
	})

	RAQ_AddMeta({
		expansion = exp,
		category = pve,
		name = "Glory of the Dragon Soul Raider",
		ids = {
			6174, 6129, 6128, 6175, 6084, 6105, 6133, 6180, 6110,
			6109, 6111, 6112, 6113, 6114, 6115, 6116
		}
	})

	RAQ_AddMeta({
		expansion = exp,
		category = pve,
		name = "Defender of a Shattered World",
		ids = {
			5060, 5061, 5063, 5064, 5062, 5065, 5066, 5083, 5093,
			4842, 4851, 4850
		}
	})

	RAQ_AddMeta({
		expansion = exp,
		category = pve,
		name = "Cataclysm Dungeon Hero", 
		ids = {
			5060, 5061, 5063, 5064, 5062, 5065, 5066, 5083, 5093,
			4845
		}
	})
end



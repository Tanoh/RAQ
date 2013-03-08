-- pve achievements in Mist of Pandarian.

function RAQ_Achievements_InitMoP()
	local exp = "mop"
	local pve = "pve"

	-- FIXME: Missing meta achievements as they're not in the game yet.

	RAQ_AddExpansion({
		key = exp,
		name = "Mist of Pandarian",
		sort = 50
	})

	-- Dungeons
	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		name = "Scarlet Monastery",
		ids = { 6929, 6928, 6761, 6946 },
	})
	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		name = "Scholomance",
		ids = { 6531, 6762, 6394, 6396, 6821 },
	})
	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		name = "Gate of the Setting Sun",
		ids = { 6479, 6476, 6759, 6945 },
	})
	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		name = "Temple of the Jade Serpent",
		ids = { 6475, 6758, 6460, 6671, 6757 },
	})
	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		name = "Mogu'shan Palance",
		ids = { 6478, 6756, 6755, 6736, 6713 },
	})
	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		name = "Shado-Pan Monastery",
		ids = { 6471, 6470, 6477, 6469, 6472 },
	})
	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		name = "Scarlet Halls",
		ids = { 6760, 6684, 6427 },
	})
	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		name = "Niuzao Temple",
		ids = { 6763, 6485, 6822, 6688 },
	})
	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		name = "Stormstout Brewery",
		ids = { 6456, 6420, 6400, 6089, 6402, 6457 },
	})

	-- FIXME: Not sure where to include this.
	-- 6715: Defeat bosses around Pandaria while under the effects of Polyformic Acid Potion on Heroic Difficulty.

	-- Raids
	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		subcategory = "raid",
		name = "Heart of Fear",
		ids = {
			[6936] = "Blade Lord Ta'yak",
			[6726] = "Blade Lord Ta'yak",
			
			[6729] = "Amber-Shaper Un'sok",
			[6518] = "Amber-Shaper Un'sok",

			[6727] = "Garalon",
			[6553] = "Garalon",
			
			[6730] = "Grand Empress Shek'zeer",
			[6922] = "Grand Empress Shek'zeer",
			
			[6725] = "Imperial Vizier Zok'lok",
			[6937] = "Imperial Vizier Zok'lok",
			
			[6728] = "Wind Lord Mel'jarak",
			[6683] = "Wind Lord Mel'jarak",
			
			[6845] = "",
			[6718] = "",
		},
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		subcategory = "raid",
		name = "Valley of the Four Winds",
		ids = {
			[6517] = "Salyis's Warband",
		},
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		subcategory = "raid",
		name = "Kun-Lai Summit",
		ids = {
			[6480] = "Sha of Anger",
		},
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		subcategory = "raid",
		name = "Terrace of Endless Spring",
		ids = {
			[6824] = "Lei Shi",
			[6733] = "Lei Shi",

			[6731] = "Protectors of the Endless",
			[6717] = "Protectors of the Endless",
			
			[6734] = "Sha of Fear",
			[6825] = "Sha of Fear",
			
			[6732] = "Tsulong",
			[6933] = "Tsulong",

			[6689] = "",
		},
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		subcategory = "raid",
		name = "Mogu'shan Vaults",
		ids = {
			[6458] = "",
			[6844] = "",
			[7933] = "",

			[6723] = "Elegon",
			[6686] = "Elegon",
			
			[6720] = "Feng the Accursed",
			[6674] = "Feng the Accursed",
			
			[6722] = "Four Kings",
			[6687] = "Four Kings",
			
			[6721] = "Gara'jal the Spiritbinder",
			[7056] = "Gara'jal the Spiritbinder",
			
			[6719] = "Stone Guard",
			[6823] = "Stone Guard",
			
			[6724] = "Will of the Emperor",
			[6455] = "Will of the Emperor",
		},
	})
	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		subcategory = "raid",
		name = "Throne of Thunder",
		ids = {
			[8070] = "", -- Forgotten Depths
			[8071] = "", -- Halls of Flesh-Shaping
			[8069] = "", -- Last Stand of the Zandalari
			[8072] = "", -- Pinnacle of Storms

			[8056] = "Jin'rokh the Breaker", -- Heroic: Jin'rokh the Breaker
			[8094] = "Jin'rokh the Breaker", -- Lightning Overload

			[8038] = "Horridon", -- Cretaceous Collector
			[8057] = "Horridon", -- Heroic: Horridon

			[8073] = "Council of Elders", -- Cage Match
			[8058] = "Council of Elders", -- Heroic: Council of Elders

			[8077] = "Tortos", -- One-Up
			[8059] = "Tortos", -- Heroic: Tortos

			[8060] = "Magaera", -- Heroic: Megaera
			[8082] = "Magaera", -- Head Case

			[8097] = "Ji-Kun", -- Soft Hands
			[8061] = "Ji-Kun", -- Heroic: Ji-Kun

			[8098] = "Durumu the Forgotten", -- You Said Crossing the Streams Was Bad
			[8062] = "Durumu the Forgotten", -- Heroic: Durumu the Forgotten

			[8037] = "Primordius", -- Genetically Unmodified Organism
			[8063] = "Primordius", -- Heroic: Primordius

			[8064] = "Dark Animus", -- Heroic: Dark Animus
			[8081] = "Dark Animus", -- Ritualist Who?

			[8087] = "Iron Qon", -- Can't Touch This
			[8065] = "Iron Qon", -- Heroic: Iron Qon

			[8086] = "Twin Consorts", -- From Dusk 'til Dawn
			[8066] = "Twin Consorts", -- Heroic: Twin Consorts

			[8090] = "Lei Shen", -- A Complete Circuit
			[8067] = "Lei Shen", -- Heroic: Lei Shen

			[8068] = "Ra-den", -- Heroic: Ra-den
		},
	})

	-- [8123] = "", -- Millions of Years of Evolution vs. My Fist: Defeat Oondasta on the Isle of Giants.
	-- [8028] = "", -- Praise the Sun!: Defeat Nalak, the Storm Lord, on the Isle of Thunder.

	-- Meta
	RAQ_AddMeta({
		expansion = exp,
		category = pve,
		name = "Pandaria Dungeon Hero",
		ids = {
			6456, 6761, 6759, 6763, 6760, 6756, 6762, 6470, 6758, 
		}
	})
	
	RAQ_AddMeta({
		expansion = exp,
		category = pve,
		name = "Glory of the Pandaria Hero",
		ids = {
			6925, 6475, 6394, 6715, 6396, 6479, 6457, 6757, 6472,
			6478, 6471, 6821, 6460, 6420, 6531, 6402, 6089, 6945,
			6946, 6755, 6427, 6713, 6476, 6477, 6671, 6469, 6928,
			6684, 6929, 6822, 6400, 6688, 6736, 6485,
		}
	})

	RAQ_AddMeta({
		expansion = exp,
		category = pve,
		name = "Glory of the Pandaria Raider",
		ids = {
			6823, -- Must Love Dogs
			6674, -- Anything You Can Do, I Can Do Better...
			7056, -- Sorry, Were You Looking for This?
			6687, -- Getting Hot In Here
			6686, -- Straight Six
			6455, -- Show Me Your Moves!
			6937, -- Overzealous
			6936, -- Candle in the Wind
			6553, -- Like an Arrow to the Face
			6683, -- Less Than Three
			6518, -- I Heard You Like Amber...
			6922, -- Timing is Everything
			6717, -- Power Overwhelming
			6824, -- Face Clutchers
			6933, -- Who's Got Two Green Thumbs?
			6825, -- The Mind-Killer
			6719, -- Heroic: Stone Guard
			6720, -- Heroic: Feng the Accursed
			6721, -- Heroic: Gara'jal the Spiritbinder
			6722, -- Heroic: Four Kings
			6723, -- Heroic: Elegon
			6724, -- Heroic: Will of the Emperor
			6725, -- Heroic: Imperial Vizier Zor'lok
			6726, -- Heroic: Blade Lord Ta'yak
			6727, -- Heroic: Garalon
			6728, -- Heroic: Wind Lord Mel'jarak
			6729, -- Heroic: Amber-Shaper Un'sok
			6730, -- Heroic: Grand Empress Shek'zeer
			6731, -- Heroic: Protectors of the Endless
			6732, -- Heroic: Tsulong
			6733, -- Heroic: Lei Shi
		}
	})

	RAQ_AddMeta({
		expansion = exp,
		category = pve,
		name = "Glory of the Thundering Raider",
		ids = {
			8056, -- Heroic: Jin'rokh the Breaker
			8057, -- Heroic: Horridon
			8058, -- Heroic: Council of Elders
			8059, -- Heroic: Tortos
			8060, -- Heroic: Megaera
			8061, -- Heroic: Ji-Kun
			8062, -- Heroic: Durumu the Forgotten
			8063, -- Heroic: Primordius
			8064, -- Heroic: Dark Animus
			8065, -- Heroic: Iron Qon
			8066, -- Heroic: Twin Consorts
			8094, -- Lightning Overload
			8038, -- Cretaceous Collector
			8073, -- Cage Match
			8077, -- One-Up
			8082, -- Head Case
			8097, -- Soft Hands
			8098, -- You Said Crossing the Streams Was Bad
			8037, -- Genetically Unmodified Organism
			8081, -- Ritualist Who?
			8087, -- Can't Touch This
			8086, -- From Dusk 'til Dawn
			8090, -- A Complete Circuit
		}
	})


	-- Scenarios.
	-- FIXME: If they add more scenarios this should probably be moved to a file of it's own.
	RAQ_AddAchievement({
		key = "_scenario",
		category = pve,
		expansion = exp,
		name = "Scenarios",
		ids = {
			["shared"] = {
				7252, 7271, 7273, 6931, 6923, 7522, 7257, 7276,
				7265, 7272, 7275, 7239, 7248, 7258, 7267, 7385,
				6943, 7266, 7231, 7232, 7261, 7249, 6930, 8016,
				8017
			},
			["Horde"] = {
				7529, 7530, 7509, 7524, 8013, 8009, 7987, 8015,
				8014, 7986, 7984
			},
			["Alliance"] = {
				7526, 7527, 6874, 7523, 7992, 7991, 8012, 8011,
				7988, 7993, 7990, 7989, 8010	
			},
		}
	})
end


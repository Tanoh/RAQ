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
			
			[6723] = "Elegon",
			[6686] = "Elegon",
			
			[6720] = "Feng the Accursed",
			[6674] = "Feng the Accursed",
			
			[6722] = "Four Kings",
			[6687] = "Four Kings", -- FIXME: Verify.
			
			[6721] = "Gara'jal the Spiritbinder",
			[7056] = "Gara'jal the Spiritbinder",
			
			[6719] = "Stone Guard",
			[6823] = "Stone Guard",
			
			[6724] = "Will of the Emperor",
			[6455] = "Will of the Emperor",
		},
	})


	-- Scenarios.
	-- FIXME: If they add more scenarios this should probably be moved to a file of it's own.
	RAQ_AddAchievement({
		key = "_scenario",
		category = pve,
		expansion = exp,
		name = "Scenarios",
		ids = {
			["shared"] = { 7252, 7271, 7273, 6931, 6923, 7522, 7257, 7276, 7270, 7265, 7272, 7275, 7239, 7248, 7258, 7267, 7385, 6943, 7266, 7231, 7269, 7232, 7261, 7268, 7249, 6930 },
			["Horde"] = { 7529, 7530, 7509, 7524 },
			["Alliance"] = { 7526, 7527, 6874, 7523 },
		}
	})
end



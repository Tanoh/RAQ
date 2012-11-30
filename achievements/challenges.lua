-- Challenges achievements in Mist of Pandarian.

function RAQ_Achievements_InitChallenges()
	local exp = "mop"
	local pve = "pve"

	RAQ_AddExpansion({
		key = exp,
		name = "Mist of Pandarian",
		sort = 50
	})

	-- Challenges.
	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		subcategory = "challenge",
		name = "Challenge Conqueror",
		ids = {
			6894, -- Gate of the Setting Sun 
			6892, -- Mogu'shan Palace 
			6895, -- Scarlet Halls 
			6896, -- Scarlet Monastery 
			6897, -- Scholomance 
			6893, -- Shado-Pan Monastery 
			6898, -- Siege of Niuzao Temple 
			6888, -- Stormstout Brewery 
			6884, -- Temple of the Jade Serpent 
		}
	})
	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		subcategory = "challenge",
		name = "Challenge Conqueror: Bronze",
		ids = {
			6905, -- Gate of the Setting Sun 
			6899, -- Mogu'shan Palace 
			6908, -- Scarlet Halls 
			6911, -- Scarlet Monastery 
			6914, -- Scholomance 
			6902, -- Shado-Pan Monastery 
			6917, -- Siege of Niuzao Temple 
			6889, -- Stormstout Brewery 
			6885, -- Temple of the Jade Serpent 
		}
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		subcategory = "challenge",
		name = "Challenge Conqueror: Silver",
		ids = {
			6906, -- Gate of the Setting Sun 
			6900, -- Mogu'shan Palace 
			6909, -- Scarlet Halls 
			6912, -- Scarlet Monastery 
			6915, -- Scholomance 
			6903, -- Shado-Pan Monastery 
			6918, -- Siege of Niuzao Temple 
			6890, -- Stormstout Brewery 
			6886, -- Temple of the Jade Serpent 
		}
	})
	
	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		subcategory = "challenge",
		name = "Challenge Conqueror: Gold",
		ids = {
			6907, -- Gate of the Setting Sun 
			6901, -- Mogu'shan Palace 
			6910, -- Scarlet Halls 
			6913, -- Scarlet Monastery 
			6916, -- Scholomance 
			6904, -- Shado-Pan Monastery 
			6919, -- Siege of Niuzao Temple 
			6891, -- Stormstout Brewery 
			6887, -- Temple of the Jade Serpent 
		}
	})
end



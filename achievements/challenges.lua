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
			6920, 6374, 6378, 6375
		}
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		subcategory = "challenge",
		name = "Gate of the Setting Sun",
		ids = {
			6894, 6905, 6907, 6906
		}
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		subcategory = "challenge",
		name = "Mogu'shan Palace",
		ids = {
			6892, 6899, 6901, 6900
		}
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		subcategory = "challenge",
		name = "Scarlet Halls",
		ids = {
			6895, 6908, 6910, 6909
		}
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		subcategory = "challenge",
		name = "Scarlet Monastery",
		ids = {
			6896, 6911, 6913, 6912
		}
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		subcategory = "challenge",
		name = "Scholomance",
		ids = {
			6897, 6914, 6916, 6915
		}
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		subcategory = "challenge",
		name = "Shado-Pan Monastery",
		ids = {
			6893, 6902, 6904, 6903
		}
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		subcategory = "challenge",
		name = "Siege of Niuzao Temple",
		ids = {
			6898, 6917, 6919, 6918
		}
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		subcategory = "challenge",
		name = "Stormstout Brewery",
		ids = {
			6888, 6889, 6891, 6890
		}
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		subcategory = "challenge",
		name = "Temple of the Jade Serpent",
		ids = {
			6884, 6885, 6887, 6886
		}
	})

end



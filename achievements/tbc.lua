-- pve achievements in The Burning Crusade

function RAQ_Achievements_InitTBC()
	local exp = "tbc"
	local pve = "pve"
	
	RAQ_AddExpansion({
		key = exp,
		name = "The Burning Crusade",
		sort = 20
	})

	-- Raid achievements.
	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		subcategory = "raid",
		name = "Karazhan",
		ids = { [690] = "Prince Malchezaar", },
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		subcategory = "raid",
		name = "Magtheridon's Lair",
		ids = { [693] = "Magtheridon", },
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		subcategory = "raid",
		name = "Serpentshrine Cavern",
		ids = { [694] = "Lady Vashj", },
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		subcategory = "raid",
		name = "Sunwell Plateau",
		ids = { [698] = "Kil'jaeden", },
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		subcategory = "raid",
		name = "Tempest Keep",
		ids = { [696] = "Kael'thas Sunstrider", },
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		subcategory = "raid",
		name = "The Battle for Mount Hyjal",
		ids = { [695] = "Archimonde", },
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		subcategory = "raid",
		name = "The Black Temple",
		ids = { [697] = "Illidan Stormrage", },
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		subcategory = "raid",
		name = "Gruul's Lair",
		ids = { [692] = "Gruul the Dragonkiller", },
	})

	-- Meta
	RAQ_AddMeta({
		expansion = exp,
		category = pve,
		name = "Outland Dungeon Hero",
		ids = {
			667, 668, 669, 670, 671, 673, 674, 675, 676, 677, 678,
			679, 680, 681, 682, 672
		}
	})

	RAQ_AddMeta({
		expansion = exp,
		category = pve,
		name = "Outland Dungeon Master",
		ids = {
			647, 648, 649, 650, 651, 652, 653, 654, 655, 656, 657,
			658, 659, 660, 661, 666
		}
	})

	RAQ_AddMeta({
		expansion = exp,
		category = pve,
		name = "Outland Raider",
		ids = {
			690, 692, 693, 694, 695, 696, 697, 698
		}
	})

end


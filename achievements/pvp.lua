-- Achievements used in pvp.

function RAQ_Achievements_InitPvP()
	local pvp = "pvp"
	local keyName = "_pvp"

	RAQ_AddAchievement({
		key = keyName,
		category = pvp,
		subcategory = "bg",
		name = "Warsong Gulch",
		ids = {
			["shared"] = { 199, 872, 204, 1172, 1259, 200, 207, 201, 168, 167, 166 },
			["Horde"] = { 1251, 1502, 712, 1252 },
			["Alliance"] = { 203, 202, 713, 206 },
		}
	})

	RAQ_AddAchievement({
		key = keyName,
		category = pvp,
		subcategory = "bg",
		name = "Arathi Basin",
		ids = {
			["shared"] = { 583, 584, 165, 155, 154, 73, 159, 1169, 158, 1153, 161, 156, 157, 162 },
			["Horde"] = { 710 },
			["Alliance"] = { 711 },
		}
	})

	RAQ_AddAchievement({
		key = keyName,
		category = pvp,
		subcategory = "bg",
		name = "Alterac Valley",
		ids = {
			["shared"] = { 221, 582, 219, 218, 1167, 226, 223, 1166, 222 },
			["Horde"] = { 1164, 706, 873, 708, 1151 },
			["Alliance"] = { 225, 707, 220, 709, 224 },
		}
	});	

	RAQ_AddAchievement({
		key = keyName,
		category = pvp,
		subcategory = "bg",
		name = "Eye of the Storm",
		ids = {
			233, 216, 784, 209, 208, 214, 1171, 212, 211, 213, 587, 1258,
			783
		}
	})

	RAQ_AddAchievement({
		key = keyName,
		category = pvp,
		subcategory = "bg",
		name = "Strand of the Ancients",
		ids = {
			["shared"] = { 2191, 1766, 2189, 1763, 2190, 1764, 2193, 2194, 1765, 1310, 1309, 1308, 1761 },
			["Horde"] = { 2200, 2192 },
			["Alliance"] = { 1757, 1762 },
		}
	})

	RAQ_AddAchievement({
		key = keyName,
		category = pvp,
		subcategory = "bg",
		name = "Isle of Conquest",
		ids = {
			["shared"] = { 3848, 3849, 3853, 3854, 3852, 3847, 3855, 3845, 3777, 3776, 3850 },
			["Horde"] = { 4256, 3957, 4177, 4176 },
			["Alliance"] = { 3856, 3857, 3851, 3846 },
		}
        })

	RAQ_AddAchievement({
		key = keyName,
		category = pvp,
		subcategory = "bg",
		name = "Battle of Gilneas",
		ids = {
			5256, 5257, 5247, 5246, 5245, 5248, 5252, 5262, 5253,
			5255, 5258, 5254, 5251, 5249, 5250
		}
	})

	RAQ_AddAchievement({
		key = keyName,
		category = pvp,
		subcategory = "bg",
		name = "Twin Peaks",
		ids = {
			["shared"] = { 5223, 5216, 5211, 5208, 5230, 5215, 5209, 5210 },
			["Horde"] = { 5227, 5552, 5222, 5220, 5214, 5228 },
			["Alliance"] = { 5226, 5231, 5229, 5221, 5219, 5213 },
		}
	})

	RAQ_AddAchievement({
		key = keyName,
		category = pvp,
		subcategory = "bg",
		name = "Silvershard Mines",
		ids = {
			7057, 7102, 7099, 7103, 7106, 7049, 7062, 7100, 6883,
			6739, 7039
		}
	})

	RAQ_AddAchievement({
		key = keyName,
		category = pvp,
		subcategory = "bg",
		name = "Temple of Kotmogu",
		ids = {
			6970, 6973, 6947, 6971, 6981, 6950, 6980, 6882, 6740,
			6972
		}
	})

	RAQ_AddAchievement({
		key = keyName,
		category = pvp,
		subcategory = "bg",
		name = "Wintergrasp",
		ids = {
			["shared"] = { 1722, 1721, 2080, 1751, 3136, 3137, 3836, 3837, 1727, 1752, 4585, 4586, 1723, 2199, 1718, 1717, 1755 },
			["Horde"] = { 2476 },
			["Alliance"] = { 1737 },
		}
	})

	RAQ_AddAchievement({
		key = keyName,
		category = pvp,
		subcategory = "bg",
		name = "Tol Barad",
		ids = {
			["shared"] = { 6108, 6045, 5416, 5486, 5487, 5412, 5415, 5488 },
			["Horde"] = { 5719, 5490, 5418 },
			["Alliance"] = { 5718, 5489, 5417 },
		}
	})
	
	
	
	-- Arena
	RAQ_AddAchievement({
		key = keyName,
		category = pvp,
		subcategory = "Arena",
		name = "Arena",
		ids = {
			876, 2090, 2092, 2091, 406, 407, 404, 1161, 408, 1162,
			399, 400, 401, 1159, 409, 398, 2093, 397, 402,
			403, 405, 1160, 5266, 5267, 875, 699
		}
	});

	
	-- Rated Battleground
	RAQ_AddAchievement({
		key = keyName,
		category = pvp,
		subcategory = "Rated Battleground",
		name = "Rated Battleground",
		ids = {
			["shared"] = {},
			["Horde"] = { 5351, 5338, 5353, 5349, 5355, 5346, 6941, 5356, 5324, 5323, 5269, 5352, 5354, 5345, 5348, 5347, 5350, 5325, 5824, 5326, 5342 },
			["Alliance"] = { 5340, 5331, 5357, 5343, 6942, 5268, 5327, 5322, 5335, 5337, 5359, 5336, 5339, 5341, 5333, 5330, 5332, 5334, 5328, 5823, 5329 },
		}
	});


	-- Meta
	RAQ_AddMeta({
		category = "pvp",
		name = "The Arena Master",
		ids = {
			699, 876, 1159, 1160, 1161, 408, 1162, 409, 1174
		}
	})

	-- FIXME: AddMeta doesn't support shared/Horde/Alliance... (yet?)
	local t = {}
	if( RAQ_FACTION == "Horde" ) then
		t = { 1168, 1170, 1173, 1171, 2195 }
	else
		t = { 1167, 1169, 1172, 1171, 2194 }
	end
	RAQ_AddMeta({
		category = "pvp",
		name = "Battlemaster",
		ids = t,
	})

end




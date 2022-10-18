-- pve achievements in Wrath of the Lich King.

function RAQ_Achievements_InitWotlk()
	local exp = "wotlk"
	local pve = "pve"
	
	RAQ_AddExpansion({
		key = exp,
		name = "Wrath of the Lich King",
		sort = 30
	})

	-- Dungeons
	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		name = "The Culling of Stratholme",
		ids = { 1817, 1872, 500, 479 },
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		name = "Utgarde Keep",
		ids = { 489, 1919, 477 },
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		name = "The Pit of Saron",
		ids = { 4524, 4520, 4517, 4525 },
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		name = "The Violet Hold",
		ids = { 2153, 1816, 494, 1865, 483, 2041 },
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		name = "Drak'Tharon Keep",
		ids = { 2039, 2151, 482, 493, 2057 },
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		name = "The Nexus",
		ids = { 2037, 490, 2036, 2150, 478 },
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		name = "Ahn'kahet: The Old Kingdom",
		ids = { 481, 492, 2038, 1862, 2056 },
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		name = "Gundrak",
		ids = { 484, 495, 2040, 2152, 2058, 1864 },
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		name = "The Oculus",
		ids = { 498, 2046, 2045, 1868, 2044, 487, 1871 },
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		name = "The Halls of Reflection",
		ids = { 4521, 4518, 4526 },
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		name = "Utgarde Pinnacle",
		ids = { 499, 2157, 1873, 2156, 488, 2043 },
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		name = "Trial of the Champion",
		ids = {
			["shared"] = { 3804, 3803, 3802 },
			["Horde"] = { 4297, 3778 },
			["Alliance"] = { 4298, 4296 },
		}
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		name = "Halls of Lightning",
		ids = { 486, 497, 1834, 2042, 1867 },
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		name = "Azjol-Nerub",
		ids = { 480, 1860, 1297, 491, 1296 },
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		name = "Halls of Stone",
		ids = { 2155, 2154, 1866, 485, 496 },
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		name = "The Forge of Souls",
		ids = { 4519, 4522, 4516, 4523 },
	})


	-- Raids
	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		subcategory = "raid",
		name = "Ulduar (10 player)",
		ids = {
			[2886] = "",
			[2888] = "",
			[2890] = "",
			[2894] = "",
			[2979] = "",
			[2985] = "",
			[3014] = "",
			[3097] = "",
			[3003] = "Algalon the Observer",
			[3036] = "Algalon the Observer",
			[2939] = "Assembly of Iron",
			[2940] = "Assembly of Iron",
			[2941] = "Assembly of Iron",
			[2945] = "Assembly of Iron",
			[2947] = "Assembly of Iron",
			[3006] = "Auriaya",
			[3076] = "Auriaya",
			[2905] = "Flame Leviathan",
			[2907] = "Flame Leviathan",
			[2909] = "Flame Leviathan",
			[2911] = "Flame Leviathan",
			[2913] = "Flame Leviathan",
			[2914] = "Flame Leviathan",
			[2915] = "Flame Leviathan",
			[3056] = "Flame Leviathan",
			[2980] = "Freya",
			[2982] = "Freya",
			[3177] = "Freya",
			[3178] = "Freya",
			[3179] = "Freya",
			[2996] = "General Vezax",
			[3181] = "General Vezax",
			[2961] = "Hodir",
			[2963] = "Hodir",
			[2967] = "Hodir",
			[2969] = "Hodir",
			[3182] = "Hodir",
			[2925] = "Ignis the Furnace Master",
			[2927] = "Ignis the Furnace Master",
			[2930] = "Ignis the Furnace Master",
			[2951] = "Kologarn",
			[2953] = "Kologarn",
			[2955] = "Kologarn",
			[2959] = "Kologarn",
			[2989] = "Mimiron",
			[3138] = "Mimiron",
			[3180] = "Mimiron",
			[2919] = "Razorscale",
			[2923] = "Razorscale",
			[2971] = "Thorim",
			[2973] = "Thorim",
			[2975] = "Thorim",
			[2977] = "Thorim",
			[3176] = "Thorim",
			[2931] = "XT-002 Deconstructor",
			[2933] = "XT-002 Deconstructor",
			[2934] = "XT-002 Deconstructor",
			[2937] = "XT-002 Deconstructor",
			[3058] = "XT-002 Deconstructor",
			[3008] = "Yogg-Saron",
			[3009] = "Yogg-Saron",
			[3012] = "Yogg-Saron",
			[3015] = "Yogg-Saron",
			[3141] = "Yogg-Saron",
			[3157] = "Yogg-Saron",
			[3158] = "Yogg-Saron",
			[3159] = "Yogg-Saron",
		}
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		subcategory = "raid",
		name = "Ulduar (25 player)",
		ids = {
			[2887] = "",
			[2889] = "",
			[2891] = "",
			[2895] = "",
			[2984] = "",
			[3017] = "",
			[3098] = "",
			[3118] = "",
			[3002] = "Algalon the Observer",
			[3037] = "Algalon the Observer",
			[2942] = "Assembly of Iron",
			[2943] = "Assembly of Iron",
			[2944] = "Assembly of Iron",
			[2946] = "Assembly of Iron",
			[2948] = "Assembly of Iron",
			[3007] = "Auriaya",
			[3077] = "Auriaya",
			[2906] = "Flame Leviathan",
			[2908] = "Flame Leviathan",
			[2910] = "Flame Leviathan",
			[2912] = "Flame Leviathan",
			[2916] = "Flame Leviathan",
			[2917] = "Flame Leviathan",
			[2918] = "Flame Leviathan",
			[3057] = "Flame Leviathan",
			[2981] = "Freya",
			[2983] = "Freya",
			[3185] = "Freya",
			[3186] = "Freya",
			[3187] = "Freya",
			[2997] = "General Vezax",
			[3188] = "General Vezax",
			[2962] = "Hodir",
			[2965] = "Hodir",
			[2968] = "Hodir",
			[2970] = "Hodir",
			[3184] = "Hodir",
			[2928] = "Ignis the Furnace Master",
			[2929] = "Ignis the Furnace Master",
			[2926] = "Ignis the Furnace",
			[2952] = "Kologarn",
			[2954] = "Kologarn",
			[2956] = "Kologarn",
			[2960] = "Kologarn",
			[2995] = "Mimiron",
			[3189] = "Mimiron",
			[3237] = "Mimiron",
			[2921] = "Razorscale",
			[2924] = "Razorscale",
			[2972] = "Thorim",
			[2974] = "Thorim",
			[2976] = "Thorim",
			[2978] = "Thorim",
			[3183] = "Thorim",
			[2932] = "XT-002 Deconstructor",
			[2935] = "XT-002 Deconstructor",
			[2936] = "XT-002 Deconstructor",
			[2938] = "XT-002 Deconstructor",
			[3059] = "XT-002 Deconstructor",
			[3010] = "Yogg-Saron",
			[3011] = "Yogg-Saron",
			[3013] = "Yogg-Saron",
			[3016] = "Yogg-Saron",
			[3161] = "Yogg-Saron",
			[3162] = "Yogg-Saron",
			[3163] = "Yogg-Saron",
			[3164] = "Yogg-Saron",
		}
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		subcategory = "raid",
		name = "Malygos (10 player)",
		ids = {
			[1869] = "Malygos",
			[622] = "Malygos",
			[1874] = "Malygos",
			[2148] = "",
		}
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		subcategory = "raid",
		name = "Malygos (25 player)",
		ids = {
			[1870] = "Malygos",
			[623] = "Malygos",
			[1875] = "Malygos",
			[2149] = "",
		}
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		subcategory = "raid",
		name = "Naxxramas (10 player)", 
		ids = {
			[562] = "",
			[564] = "",
			[566] = "",
			[568] = "",
			[576] = "",
			[578] = "",
			[1997] = "Grand Widow Faerlina",
			[1996] = "Heigan the Unclean",
			[2184] = "Kel'Thuzad",
			[574] = "Kel'Thuzad",
			[2182] = "Loatheb",
			[1858] = "Maexxna",
			[1856] = "Patchwerk",
			[2146] = "Sapphiron",
			[572] = "Sapphiron",
			[2178] = "Thaddius",
			[2180] = "Thaddius",
			[2176] = "The Four Horsemen",
		}
	})
	
	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		subcategory = "raid",
		name = "Naxxramas (25 player)", 
		ids = {
			[1857] = "",
			[1859] = "",
			[563] = "",
			[565] = "",
			[567] = "",
			[569] = "",
			[577] = "",
			[579] = "",
			[2140] = "Grand Widow Faerlina",
			[2139] = "Heigan the Unclean",
			[2185] = "Kel'Thuzad",
			[575] = "Kel'Thuzad",
			[2183] = "Loatheb",
			[2147] = "Sapphiron",
			[573] = "Sapphiron",
			[2179] = "Thaddius",
			[2181] = "Thaddius",
			[2177] = "The Four Horsemen",
		}
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		subcategory = "raid",
		name = "Icecrown Citadel (10 player)", 
		ids = {
			[2892] = "",
			[4527] = "",
			[4528] = "",
			[4529] = "",
			[4531] = "",
			[4532] = "",
			[4536] = "",
			[4579] = "",
			[4581] = "",
			[4628] = "",
			[4629] = "",
			[4630] = "",
			[4631] = "",
			[4636] = "",
			[4539] = "Blood-Queen Lana'thel",
			[4577] = "Festergut",
			[4535] = "Lady Deathwhisper",
			[4534] = "Lord Marrowgar",
			[4578] = "Professor Putricide",
			[4538] = "Rotface",
			[4580] = "Sindragosa",
			[4582] = "The Blood Council",
			[4537] = "The Deathbringer",
			[4530] = "The Lich King",
			[4601] = "The Lich King",
		}
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		subcategory = "raid",
		name = "Icecrown Citadel (25 player)", 
		ids = {
			[2893] = "",
			[4604] = "",
			[4605] = "",
			[4606] = "",
			[4607] = "",
			[4608] = "",
			[4612] = "",
			[4619] = "",
			[4622] = "",
			[4632] = "",
			[4633] = "",
			[4634] = "",
			[4635] = "",
			[4637] = "",
			[4618] = "Blood-Queen Lana'thel",
			[4615] = "Festergut",
			[4611] = "Lady Deathwhisper",
			[4610] = "Lord Marrowgar",
			[4616] = "Professor Putricide",
			[4614] = "Rotface",
			[4620] = "Sindragosa",
			[4617] = "The Blood Council",
			[4613] = "The Deathbringer",
			[4583] = "The Lich King",
			[4584] = "The Lich King",
			[4597] = "The Lich King",
			[4621] = "The Lich King",
		}
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		subcategory = "raid",
		name = "Trial of the Crusader (10 player)",
		ids = {
			[3917] = "",
			[3918] = "",
			[3800] = "Anub'arak",
			[3798] = "Faction Champions",
			[3797] = "Icehowl",
			[3996] = "Lord Jaraxxus",
			[3936] = "Northrend Beasts",
			[3799] = "The Twin Val'kyr",
		}
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		subcategory = "raid",
		name = "Trial of the Crusader (25 player)",
		ids = {
			[3812] = "",
			[3916] = "",
			[3816] = "Anub'arak",
			[3813] = "Icehowl",
			[3997] = "Lord Jaraxxus",
			[3937] = "Northrend Beasts",
			[3815] = "The Twin Val'kyr",
		}
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		subcategory = "raid",
		name = "The Obsidian Sanctum (10 player)", 
		ids = {
			[1876] = "Sartharion the Onyx Guardian",
			[2047] = "Sartharion the Onyx Guardian",
			[624] = "Sartharion the Onyx Guardian",
			[2051] = "Sartharion the Onyx Guardian",
			[2049] = "Sartharion the Onyx Guardian",
			[2050] = "Sartharion the Onyx Guardian",
		}
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		subcategory = "raid",
		name = "The Obsidian Sanctum (25 player)", 
		ids = {
			[625] = "Sartharion the Onyx Guardian",
			[2048] = "Sartharion the Onyx Guardian",
			[1877] = "Sartharion the Onyx Guardian",
			[2054] = "Sartharion the Onyx Guardian",
			[2052] = "Sartharion the Onyx Guardian",
			[2053] = "Sartharion the Onyx Guardian",
		}
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		subcategory = "raid",
		name = "Vault of Archavon (10 player)",
		ids = { 4016, 1722, 3136, 3836, 4585 }
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		subcategory = "raid",
		name = "Vault of Archavon (25 player)",
		ids = { 4017, 1721, 3137, 3837, 4586 }
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		subcategory = "raid",
		name = "The Ruby Sanctum (10 player)", 
		ids = {
			[4818] = "Halion",
			[4817] = "Halion",
		}
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		subcategory = "raid",
		name = "The Ruby Sanctum (25 player)", 
		ids = {
			[4816] = "Halion",
			[4815] = "Halion",
		}
	})
	
	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		subcategory = "raid",
		name = "Onyxia's Lair (10 player)",
		ids = {
			[4403] = "Onyxia",
			[4402] = "Onyxia",
			[4396] = "Onyxia",
			[4404] = "Onyxia",
		}
	})

	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		subcategory = "raid",
		name = "Onyxia's Lair (25 player)",
		ids = {
			[4406] = "Onyxia",
			[4405] = "Onyxia",
			[4397] = "Onyxia",
			[4407] = "Onyxia",
		}
	})


	-- Meta
	RAQ_AddMeta({
		expansion = exp,
		category = pve,
		name = "Glory of the Hero",
		ids = {
			1816, 1817, 2152, 2037, 1868, 1919, 1862, 2039, 1866,
			1871, 2045, 2154, 2150, 1865, 2038, 2042, 2151, 2046,
			2043, 2040, 1872, 2036, 2057, 2155, 1297, 2056, 1864,
			1834, 2044, 2153, 2157, 2156, 1873, 2041, 1867, 1860,
			2058, 1296
		}
	})
	RAQ_AddMeta({
		expansion = exp,
		category = pve,
		name = "Glory of the Icecrown Raider (10 player)",
		ids = {
			4628, 4629, 4630, 4631, 4534, 4535, 4536, 4537, 4538,
			4577, 4578, 4582, 4539, 4579, 4580, 4601
		}
	})
	
	RAQ_AddMeta({
		expansion = exp,
		category = pve,
		name = "Glory of the Icecrown Raider (25 player)",
		ids = {
			4632, 4633, 4634, 4635, 4610, 4611, 4612, 4613, 4614,
			4615, 4616, 4617, 4618, 4619, 4620, 4621, 4622
		}
	})

	RAQ_AddMeta({
		expansion = exp,
		category = pve,
		name = "Glory of the Raider (10 player)",
		ids = {
			-- 578, 1869, 2180 removed from meta 2022-10-18
			1858, 1856, 1996, 1997, 2178, 622, 1874, 2047, 2051,
			2146, 2176, 2148, 2184
		}
	})

	RAQ_AddMeta({
		expansion = exp,
		category = pve,
		name = "Glory of the Raider (25 player)",
		ids = {
			-- 579, 1870, 2181 removed from meta 2022-10-18
			1859, 1857, 2139, 2140, 2179, 2177, 623, 1875, 2048,
			2149, 2054, 2147, 2185
		}
	})

	RAQ_AddMeta({
		expansion = exp,
		category = pve,
		name = "Glory of the Ulduar Raider (10 player)",
		ids = {
			3056, 2930, 2923, 3058, 2941, 2953, 3006, 3182, 3176,
			3179, 3180, 3181, 3158
		}
	})

	RAQ_AddMeta({
		expansion = exp,
		category = pve,
		name = "Glory of the Ulduar Raider (25 player)",
		ids = {
			3057, 2929, 2924, 3059, 2944, 2954, 3007, 3184, 3183,
			3187, 3189, 3188, 3163
		}
	})

	RAQ_AddMeta({
		expansion = exp,
		category = pve,
		name = "Northrend Dungeon Hero",
		ids = {
			489, 490, 500, 491, 492, 493, 494, 495, 496, 497, 498,
			499
		}
	})

	RAQ_AddMeta({
		expansion = exp,
		category = pve,
		name = "Northrend Dungeonmaster",
		ids = {
			477, 478, 479, 480, 481, 482, 483, 484, 485, 486, 487,
			488
		}
	})
end


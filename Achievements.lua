--[[
	Achievements tracked by RAQ.
--]]


function RAQ_InitAchievements()
	RAQ_DB = {
		["_boss"] = {},
		["_meta"] = {},
		["_instance"] = {},
	}

	-- Cataclysm
	RAQ_Cataclysm_AddRaidTier1();
	RAQ_Cataclysm_AddHeroics();
	RAQ_Cataclysm_AddZandalari();
	RAQ_Cataclysm_AddRaidTier2();
	RAQ_Cataclysm_AddRaidTier3();


	-- Cataclysm Meta
	RAQ_Cataclysm_AddMetaAchievements();



	-- Create _boss structure from _instance info
	for k,v in pairs(RAQ_DB["_instance"]) do
		for k2,v2 in pairs(v) do -- instance
			if( k2 ~= "_meta" and v2 ~= "" ) then
				if( RAQ_DB["_boss"][k] == nil ) then
					RAQ_DB["_boss"][k] = {}
				end
				if( RAQ_DB["_boss"][k][v2] == nil ) then
					RAQ_DB["_boss"][k][v2] = {}
				end

				table.insert(RAQ_DB["_boss"][k][v2],k2);
			end
		end
	end


	-- Add all ids to _scan
	RAQ_DB["_scan"] = {};
	for k,v in pairs(RAQ_DB["_meta"]) do
		for k2,v2 in pairs(v) do
			RAQ_DB["_scan"][k2] = true;
		end
	end
	
	for k,v in pairs(RAQ_DB["_instance"]) do
		for k2,v2 in pairs(v) do -- instance
			if( k2 ~= "_meta" ) then
				RAQ_DB["_scan"][k2] = true;
			end
		end
	end
end

function RAQ_Cataclysm_AddZandalari()
	-- Zul'Aman
	RAQ_DB["_instance"]["Zul'Aman"] = {
		["_meta"] = { instanceType = "party" },
		[5750] = "", -- Tunnel Vision
		[5760] = "", -- Ring Out!
		[5761] = "", -- Hex Mix
		[5769] = "", -- Heroic: Zul'Aman
	}
	
	-- Zul'Gurub
	RAQ_DB["_instance"]["Zul'Gurub"] = {
		["_meta"] = { instanceType = "party" },
		[5743] = "", -- It's Not Easy Being Green
		[5744] = "", -- Gurubashi Headhunter
		[5759] = "", -- Spirit Twister
		[5762] = "", -- Ohganot So Fast!
		[5765] = "", -- Here, Kitty Kitty...
		[5768] = "", -- Heroic: Zul'Gurub
	}
end

function RAQ_Cataclysm_AddHeroics()
	RAQ_DB["_instance"]["Blackrock Caverns"] = {
		["_meta"] = { instanceType = "party" },
		[5281] = "", -- Crushing Bones and Cracking Skulls
		[5282] = "", -- Arrested Development
		[5283] = "", -- Too Hot to Handle
		[5284] = "", -- Ascendant Descending
	}

	RAQ_DB["_instance"]["Throne of the Tides"] = {
		["_meta"] = { instanceType = "party" },
		[5285] = "", -- Old Faithful
		[5286] = "", -- Prince of Tides
	}

	RAQ_DB["_instance"]["Stonecore"] = {
		["_meta"] = { instanceType = "party" },
		[5287] = "", -- Rotten to the Core
	}

	RAQ_DB["_instance"]["Vortex Pinnacle"] = {
		["_meta"] = { instanceType = "party" },
		[5288] = "", -- No Static at All
		[5289] = "", -- Extra Credit Bonus Stage
	}

	RAQ_DB["_instance"]["Lost City of the Tol'vir"] = {
		["_meta"] = { instanceType = "party" },
		[5290] = "", -- Kill It With Fire!
		[5291] = "", -- Acrocalypse Now
		[5292] = "", -- Headed South
	}

	RAQ_DB["_instance"]["Halls of Origination"] = {
		["_meta"] = { instanceType = "party" },
		[5293] = "", -- I Hate That Song
		[5294] = "", -- Straw That Broke the Camel's Back
		[5295] = "", -- Sun of a....
		[5296] = "", -- Faster Than the Speed of Light
	}

	RAQ_DB["_instance"]["Grim Batol"] = {
		["_meta"] = { instanceType = "party" },
		[5297] = "", -- Umbrage for Umbriss
		[5298] = "", -- Don't Need to Break Eggs to Make an Omelet
	}

	RAQ_DB["_instance"]["Deadmines"] = {
		["_meta"] = { instanceType = "party" },
		[5366] = "", -- Ready for Raiding
		[5367] = "", -- Rat Pack
		[5368] = "", -- Prototype Prodigy
		[5369] = "", -- It's Frost Damage
		[5370] = "", -- I'm on a Diet
		[5371] = "", -- Vigorous VanCleef Vindicator
	}

	RAQ_DB["_instance"]["Shadowfang Keep"] = {
		["_meta"] = { instanceType = "party" },
		[5503] = "", -- Pardon Denied
		[5504] = "", -- To the Ground!
		[5505] = "", -- Bullet Time
	}
	
	RAQ_DB["_instance"]["Hour of Twilight"] = {
		["_meta"] = { instanceType = "party" },
		[6119] = "", -- Heroic: Hour of Twilight
		[6132] = "", -- Eclipse
	}

	RAQ_DB["_instance"]["End Time"] = {
		["_meta"] = { instanceType = "party" },
		[6117] = "", -- Heroic: End Time
		[5995] = "", -- Moon Guard
		[6130] = "", -- Severed Ties
	}

	RAQ_DB["_instance"]["Well of Eternity"] = {
		["_meta"] = { instanceType = "party" },
		[6118] = "", -- Heroic: Well of Eternity
		[6070] = "", -- That's Not Cannon!
		[6127] = "", -- Lazy Eye
	}
end

function RAQ_Cataclysm_AddRaidTier1()
	-- Blackwing Descent
	RAQ_DB["_instance"]["Blackwing Descent"] = {
		["_meta"] = { instanceType = "raid" },
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

	-- Bastion of Twilight
	RAQ_DB["_instance"]["Bastion of Twilight"] = {
		["_meta"] = { instanceType = "raid" },
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
	
	-- Throne of the Four Winds
	RAQ_DB["_instance"]["Throne of the Four Winds"] = {
		["_meta"] = { instanceType = "raid" },
		[5305] = "Al'Akir", -- Four Play
		[5123] = "Al'Akir", -- Heroic: Al'Akir

		[5304] = "Conclave of Wind", -- Stay Chill
		[5122] = "Conclave of Wind", -- Heroic: Conclave of Wind

		[4851] = "", -- Throne of the Four Winds
	}

end

function RAQ_Cataclysm_AddRaidTier2()
	-- Firelands
	RAQ_DB["_instance"]["Firelands"] = {
		["_meta"] = { instanceType = "raid" },

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
end

function RAQ_Cataclysm_AddRaidTier3()
	-- Dragon Soul
	RAQ_DB["_instance"]["Dragon Soul"] = {
		["_meta"] = { instanceType = "raid" },

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
end


function RAQ_Cataclysm_AddMetaAchievements()
	RAQ_DB["_meta"]["Defender of a Shattered World"] = {
		[5060] = "", -- Heroic: Blackrock Caverns
		[5061] = "", -- Heroic: Throne of the Tides
		[5063] = "", -- Heroic: The Stonecore
		[5064] = "", -- Heroic: The Vortex Pinnacle
		[5062] = "", -- Heroic: Grim Batol
		[5065] = "", -- Heroic: Halls of Origination
		[5066] = "", -- Heroic: Lost City of the Tol'vir
		[5083] = "", -- Heroic: Deadmines
		[5093] = "", -- Heroic: Shadowfang Keep
		[4842] = "", -- Blackwing Descent
		[4851] = "", -- Throne of the Four Winds
		[4850] = "", -- The Bastion of Twilight
	}

	RAQ_DB["_meta"]["Glory of the Cataclysm Hero"] = {
		[5281] = "", -- Crushing Bones and Cracking Skulls
		[5282] = "", -- Arrested Development
		[5283] = "", -- Too Hot to Handle
		[5284] = "", -- Ascendant Descending
		[5285] = "", -- Old Faithful
		[5286] = "", -- Prince of Tides
		[5287] = "", -- Rotten to the Core
		[5288] = "", -- No Static at All
		[5289] = "", -- Extra Credit Bonus Stage
		[5290] = "", -- Kill It With Fire!
		[5291] = "", -- Acrocalypse Now
		[5292] = "", -- Headed South
		[5293] = "", -- I Hate That Song
		[5294] = "", -- Straw That Broke the Camel's Back
		[5295] = "", -- Sun of a....
		[5296] = "", -- Faster Than the Speed of Light
		[5297] = "", -- Umbrage for Umbriss
		[5298] = "", -- Don't Need to Break Eggs to Make an Omelet
		[5366] = "", -- Ready for Raiding
		[5367] = "", -- Rat Pack
		[5368] = "", -- Prototype Prodigy
		[5369] = "", -- It's Frost Damage
		[5370] = "", -- I'm on a Diet
		[5371] = "", -- Vigorous VanCleef Vindicator
		[5503] = "", -- Pardon Denied
		[5504] = "", -- To the Ground!
		[5505] = "", -- Bullet Time
	}

	RAQ_DB["_meta"]["Glory of the Cataclysm Raider"] = {
		[5094] = "", -- Heroic: Magmaw
		[5107] = "", -- Heroic: Omnotron Defense System
		[5108] = "", -- Heroic: Maloriak
		[5109] = "", -- Heroic: Atramedes
		[5115] = "", -- Heroic: Chimaeron
		[5116] = "", -- Heroic: Nefarian
		[5118] = "", -- Heroic: Halfus Wyrmbreaker
		[5117] = "", -- Heroic: Valiona and Theralion
		[5119] = "", -- Heroic: Ascendant Council
		[5120] = "", -- Heroic: Cho'gall
		[5122] = "", -- Heroic: Conclave of Wind
		[5123] = "", -- Heroic: Al'Akir
		[5306] = "", -- Parasite Evening
		[5307] = "", -- Achieve-a-tron
		[5308] = "", -- Silence is Golden
		[5309] = "", -- Full of Sound and Fury
		[5310] = "", -- Aberrant Behavior
		[4849] = "", -- Keeping it in the Family
		[5300] = "", -- The Only Escape
		[4852] = "", -- Double Dragon
		[5311] = "", -- Elementary
		[5312] = "", -- The Abyss Will Gaze Back Into You
		[5304] = "", -- Stay Chill
		[5305] = "", -- Four Play
	}

	RAQ_DB["_meta"]["Glory of the Firelands Raider"] = {
		[5821] = "", -- Death from Above
		[5810] = "", -- Not an Ambi-Turner
		[5813] = "", -- Do a Barrel Roll!
		[5829] = "", -- Bucket List
		[5830] = "", -- Share the Pain
		[5799] = "", -- Only the Penitent...
		[5807] = "", -- Heroic: Beth'tilac
		[5808] = "", -- Heroic: Lord Rhyolith
		[5806] = "", -- Heroic: Shannox
		[5809] = "", -- Heroic: Alysrazor
		[5805] = "", -- Heroic: Baleroc
		[5804] = "", -- Heroic: Majordomo Fandral Staghelm
	}

	RAQ_DB["_meta"]["Glory of the Dragon Soul Raider"] = {
		[6174] = "", -- Don't Stand So Close to Me 
		[6129] = "", -- Taste the Rainbow! 
		[6128] = "", -- Ping Pong Champion 
		[6175] = "", -- Holding Hands 
		[6084] = "", -- Minutes to Midnight 
		[6105] = "", -- Deck Defender 
		[6133] = "", -- Maybe He'll Get Dizzy... 
		[6180] = "", -- Chromatic Champion 
		[6110] = "", -- Heroic: Warlord Zon'ozz 
		[6109] = "", -- Heroic: Morchok 
		[6111] = "", -- Heroic: Yor'sahj the Unsleeping 
		[6112] = "", -- Heroic: Hagara the Stormbinder 
		[6113] = "", -- Heroic: Ultraxion 
		[6114] = "", -- Heroic: Warmaster Blackhorn 
		[6115] = "", -- Heroic: Spine of Deathwing 
		[6116] = "", -- Heroic: Madness of Deathwing 
	}

end



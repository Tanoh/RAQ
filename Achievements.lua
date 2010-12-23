function RAQ_InitAchievements()
	-- FIXME: Add comments to achievement IDs for easier changing if Blizzard change something.
	RAQ_DB = {
		["_boss"] = {},
		["_meta"] = {},
		["_instance"] = {},
	}

	-- Cataclysm
	RAQ_Cataclysm_AddRaidTier1();
	RAQ_Cataclysm_AddHeroics();


	-- Cataclysm Meta
	RAQ_Cataclysm_AddMetaAchievements();



	-- Add all _instance bosses to _boss
	for k,v in pairs(RAQ_DB["_instance"]) do
		for k2,v2 in pairs(v) do -- instance
			if( v2 ) then
				if( RAQ_DB["_boss"][v2] == nil ) then
					RAQ_DB["_boss"][v2] = {}
				end

				RAQ_DB["_boss"][v2][k2] = true;
			end
		end
	end


	-- Add all ids to _scan
	RAQ_DB["_scan"] = {};
	for k,v in pairs(RAQ_DB["_meta"]) do
		for k2,v2 in pairs(v) do
			RAQ_DB["_scan"][v2] = 1;
		end
	end
	
	for k,v in pairs(RAQ_DB["_instance"]) do
		for k2,v2 in pairs(v) do -- instance
			RAQ_DB["_scan"][v2] = true;
		end
	end
end

function RAQ_Cataclysm_AddHeroics()
	RAQ_DB["_instance"]["Blackrock Caverns"] = {
		5281 = nil, -- Crushing Bones and Cracking Skulls
		5282 = nil, -- Arrested Development
		5283 = nil, -- Too Hot to Handle
		5284 = nil, -- Ascendant Descending
	}

	RAQ_DB["_instance"]["Throne of the Tides"] = {
		5285 = nil, -- Old Faithful
		5286 = nil, -- Prince of Tides
	}

	RAQ_DB["_instance"]["Stonecore"] = {
		5287 = nil, -- Rotten to the Core
	}

	RAQ_DB["_instance"]["Vortex Pinnacle"] = {
		5288 = nil, -- No Static at All
		5289 = nil, -- Extra Credit Bonus Stage
	}

	RAQ_DB["_instance"]["Lost City of the Tol'vir"] = {
		5290 = nil, -- Kill It With Fire!
		5291 = nil, -- Acrocalypse Now
		5292 = nil, -- Headed South
	}

	RAQ_DB["_instance"]["Halls of Origination"] = {
		5293 = nil, -- I Hate That Song
		5294 = nil, -- Straw That Broke the Camel's Back
		5295 = nil, -- Sun of a....
		5296 = nil, -- Faster Than the Speed of Light
	}

	RAQ_DB["_instance"]["Grim Batol"] = {
		5297 = nil, -- Umbrage for Umbriss
		5298 = nil, -- Don't Need to Break Eggs to Make an Omelet
	}

	RAQ_DB["_instance"]["Deadmines"] = {
		5366 = nil, -- Ready for Raiding
		5367 = nil, -- Rat Pack
		5368 = nil, -- Prototype Prodigy
		5369 = nil, -- It's Frost Damage
		5370 = nil, -- I'm on a Diet
		5371 = nil, -- Vigorous VanCleef Vindicator
	}

	RAQ_DB["_instance"]["Shadowfang Keep"] = {
		5503 = nil, -- Pardon Denied
		5504 = nil, -- To the Ground!
		5505 = nil, -- Bullet Time
	}
end

function RAQ_Cataclysm_AddRaidTier1()
	-- Blackwing Descent
	RAQ_DB["_instance"]["Blackwing Descent"] = {
		5308 = "Atramedes", -- Silence is Golden
		5109 = "Atramedes", -- Heroic: Atramedes

		5309 = "Chimaeron", -- Full of Sound and Fury
		5115 = "Chimaeron", -- Heroic: Chimaeron

		5306 = "Magmaw", -- Parasite Evening
		5094 = "Magmaw", -- Heroic: Magmaw

		5310 = "Maloriak", -- Aberrant Behavior
		5108 = "Maloriak", -- Heroic: Maloriak

		4849 = "Nefarian", -- Keeping it in the Family
		5116 = "Nefarian", -- Heroic: Nefarian

		5307 = "Omnotron Defense System", -- Achieve-a-tron
		5107 = "Omnotron Defense System", -- Heroic: Omnotron Defense System

		4842 = nil, -- Blackwing Descent
	}

	-- Bastion of Twilight
	RAQ_DB["_instance"]["Bastion of Twilight"] = {
		4852 = "Valiona and Theralion", -- Double Dragon
		5117 = "Valiona and Theralion", -- Heroic: Valiona and Theralion

		5311 = "Ascendant Council", -- Elementary
		5119 = "Ascendant Council", -- Heroic: Ascendant Council

		5300 = "Halfus Wyrmbreaker", -- The Only Escape
		5118 = "Halfus Wyrmbreaker", -- Heroic: Halfus Wyrmbreaker

		5312 = "Cho'gall", -- The Abyss Will Gaze Back Into You
		5120 = "Cho'gall", -- Heroic: Cho'gall

		5313 = "Sinestra", -- I Can't Hear You Over the Sound of How Awesome I Am	
		5121 = "Sinestra", -- Heroic: Sinestra

		4850 = nil, -- The Bastion of Twilight
	}
	
	-- Throne of the Four Winds
	RAQ_DB["_instance"]["Throne of the Four Winds"] = {
		5305 = "Al'Akir", -- Four Play
		5123 = "Al'Akir", -- Heroic: Al'Akir

		5304 = "Conclave of Wind", -- Stay Chill
		5122 = "Conclave of Wind", -- Heroic: Conclave of Wind

		4851 = nil, -- Throne of the Four Winds
	}

end

function RAQ_Cataclysm_AddMetaAchievements()
	RAQ_DB["_meta"]["Defender of a Shattered World"] = {
		5060 = nil, -- Heroic: Blackrock Caverns
		5061 = nil, -- Heroic: Throne of the Tides
		5063 = nil, -- Heroic: The Stonecore
		5064 = nil, -- Heroic: The Vortex Pinnacle
		5062 = nil, -- Heroic: Grim Batol
		5065 = nil, -- Heroic: Halls of Origination
		5066 = nil, -- Heroic: Lost City of the Tol'vir
		5083 = nil, -- Heroic: Deadmines
		5093 = nil, -- Heroic: Shadowfang Keep
		4842 = nil, -- Blackwing Descent
		4851 = nil, -- Throne of the Four Winds
		4850 = nil, -- The Bastion of Twilight
	}

	RAQ_DB["_meta"]["Glory of the Cataclysm Hero"] = {
		5281 = nil, -- Crushing Bones and Cracking Skulls
		5282 = nil, -- Arrested Development
		5283 = nil, -- Too Hot to Handle
		5284 = nil, -- Ascendant Descending
		5285 = nil, -- Old Faithful
		5286 = nil, -- Prince of Tides
		5287 = nil, -- Rotten to the Core
		5288 = nil, -- No Static at All
		5289 = nil, -- Extra Credit Bonus Stage
		5290 = nil, -- Kill It With Fire!
		5291 = nil, -- Acrocalypse Now
		5292 = nil, -- Headed South
		5293 = nil, -- I Hate That Song
		5294 = nil, -- Straw That Broke the Camel's Back
		5295 = nil, -- Sun of a....
		5296 = nil, -- Faster Than the Speed of Light
		5297 = nil, -- Umbrage for Umbriss
		5298 = nil, -- Don't Need to Break Eggs to Make an Omelet
		5366 = nil, -- Ready for Raiding
		5367 = nil, -- Rat Pack
		5368 = nil, -- Prototype Prodigy
		5369 = nil, -- It's Frost Damage
		5370 = nil, -- I'm on a Diet
		5371 = nil, -- Vigorous VanCleef Vindicator
		5503 = nil, -- Pardon Denied
		5504 = nil, -- To the Ground!
		5505 = nil, -- Bullet Time
	}
end



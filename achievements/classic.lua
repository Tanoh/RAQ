-- pve achievements in classic.

function RAQ_Achievements_InitClassic()
	local exp = "classic";
	local pve = "pve";
	
	RAQ_AddExpansion({
		key = exp,
		name = "Classic",
		sort = 10
	})

	-- raids
	
	-- meta
--[[
	RAQ_AddMeta(pve, exp, "Classic Dungeonmaster",
		{628, 629, 630, 631, 632, 633, 634, 635, 636, 637, 638, 639,
		640, 641, 642, 643, 644, 645, 646 });
	
	RAQ_AddMeta(pve, exp, "Classic Raider",
		{ 685, 686, 687, 689 });
--]]
end



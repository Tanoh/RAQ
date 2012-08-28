
local RAQ_FACTION

function RAQ_InitAchievements()
	RAQ_FACTION = select(1, UnitFactionGroup("player"))

	local t = { "_boss", "_instance", "_meta", "_pvp", "_pve", "_scan", "_scenario", "_expansion" }
	for k,v in ipairs(t) do
		RAQ_DB[v] = {}
	end
end

function RAQ_AddExpansion(ref)
	local name = ref.name or "internal error: no name"
	local exp = ref.key or "internal error: no key"
	local sort = ref.sort or -1

	RAQ_DB["_expansion"][exp] = {
		["name"] = name,
		["sort"] = sort,
	}
end

function RAQ_AddMeta(ref)
	local key = ref.key or "_meta"
	local name = ref.name
	local category = ref.category or ""
	local exp = ref.expansion or ""

	if( RAQ_DB[key] == nil ) then
		RAQ_DB[key] = {}
	end

	RAQ_DB[key][name] = {
		["_meta"] = {
			["category"] = category,
			["subcategory"] = "meta",
			["expansion"] = exp,
		}
	}

	if( ref.ids[1] == nil ) then
		RAQ_Error("Trying to add non-array table to meta named '"..name.."'")
	else
		local idkey
		for k,v in ipairs(ref.ids) do
			if( type(v) == "table" ) then
				if( RAQ_FACTION == "Horde" ) then
					idkey = v[1]
				else
					idkey = v[2]
				end
			else
				idkey = v
			end
			RAQ_DB[key][name][idkey] = ""
		end
	end
end

function RAQ_AddAchievement(ref)
	local key = ref.key or "_instance"
	local name = ref.name
	local category = ref.category or ""
	local subcategory = ref.subcategory or "dungeon"
	local exp = ref.expansion or ""

	if( RAQ_DB[key] == nil ) then
		RAQ_DB[key] = {}
	end

	-- Init meta key.
	RAQ_DB[key][name] = {
		["_meta"] = {
			["category"] = category,
			["subcategory"] = subcategory,
			["expansion"] = exp,
		}
	}

	-- Check for faction specific ids.
	if( ref.ids["shared"] ~= nil ) then
		for k,v in pairs(ref.ids) do
			if( k == "shared" or k == RAQ_FACTION ) then
				for k2,v2 in pairs(ref.ids[k]) do
					RAQ_DB[key][name][v2] = ""
				end
			end
		end
	else
		if( ref.ids[1] == nil ) then
			-- refs are a hash
			for k,v in pairs(ref.ids) do
				RAQ_DB[key][name][k] = v
			end
		else
			-- refs are an array
			for k,v in ipairs(ref.ids) do
				RAQ_DB[key][name][v] = ""
			end
		end
	end
end

function RAQ_AddInstancePvE(exp, name, ids)
	RAQ_AddAchievement({
		category = "pve",
		expansion = exp,
		["name"] = name,
		["ids"] = ids,
	})
end

function RAQ_PostInitAchivements()
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

				table.insert(RAQ_DB["_boss"][k][v2],k2)
			end
		end
	end
end

function RAQ_UpdateScan()
	-- Add all ids to _scan
	RAQ_DB["_scan"] = {}

	-- Meta
	for k,v in pairs(RAQ_DB["_meta"]) do
		for k2,v2 in pairs(v) do
			if( k2 ~= "_meta" ) then
				RAQ_DB["_scan"][k2] = true
			end
		end
	end

	-- instance stuff.
	for k,v in pairs(RAQ_DB["_instance"]) do
		for k2,v2 in pairs(v) do -- instance
			if( k2 ~= "_meta" ) then
				RAQ_DB["_scan"][k2] = true
			end
		end
	end

	-- Add pvp stuff
	for k,v in pairs(RAQ_DB["_pvp"]) do
		for k2,v2 in pairs(v) do
			if( k2 ~= "_meta" ) then
				RAQ_DB["_scan"][k2] = true
			end
		end
	end
end


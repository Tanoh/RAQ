--[[

	[R]aid [A]chievement [Q]uery
	============================

	Usage: /raq

	Written by: Jonas Fällman <jonas@fallman.org>
		aka Tanoh at Earthen Ring(EU)

	FIXME:
		* Fix the various FIXMEs.
		* Localization on a lot of things
		* Implement ignore list.
		* Scenarios are a bit of a hack. It should probably be a mode,
		  but that doesn't make a whole lot of sense when there is only
		  one category.

--]]


RAQ_DEBUG = false
RAQ_SCAN_TIMEOUT = 3; -- Timeout in seconds for the scanner.
RAQ_REFRESH_TIMEOUT = 60*60; -- Timeout in seconds before a re-scan.
RAQ_DB = {}
RAQ_OPTION = {}
RAQ_DATA = {}

-- Internal values, should not be messed with! :>
local RAQ_NUMBER_BUTTON = 14
local RAQ_NUMBER_COLUMN = 17
local RAQ_UPDATE_INTERVAL = 1.0
local RAQ_CURRENT_PAGE = 1

local RAQ_TEXTURE = {
	["yes"] = [[Interface\AddOns\RAQ\media\true]],
	["no"] = [[Interface\AddOns\RAQ\media\false]],

	["unknown"] = [[Interface\ICONS\INV_Misc_QuestionMark.png]],
}

local RAQ_NUM_SCAN
local RAQ_SCAN_FAILED = "Scan failed"
local RAQ_queue = {}
local _RAQ_Timer = nil
local _unitID

-- Tooltips for buttons. Currently only two buttons using it, but hey you never
-- know. :> First line is header (yellow), after that every line is added in white.
RAQ_TOOLTIP = {
	RAQFrameScanButton = "Scan\nScans your group for achievements, results are cached for "..RAQ_REFRESH_TIMEOUT.." seconds.\nHold |cffffff00CTRL|r to force a rescan.",
	RAQFrameResetButton = "Reset\nClears all data collected."
}




function RAQ_SetTimer(timeout,callback)
	_RAQ_Timer = {}
	_RAQ_Timer = {
		["timeout"] = timeout,
		["callback"] = callback,
	}
end

function RAQ_KillTimer()
	_RAQ_Timer = nil
end

function RAQ_UpdateHeaderTooltip(self)
	if( self.criteriaName ~= nil ) then
		GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
		GameTooltip:AddLine(self.criteriaName)
		GameTooltip:AddLine(self.criteriaDesc, 1, 1, 1, 1)
		if( RAQ_DEBUG == true ) then
			GameTooltip:AddLine("ID: "..self.achievementID)
		end
		GameTooltip:SetMinimumWidth(100)
		GameTooltip:Show()
	else
		GameTooltip:Hide()
	end
end

function RAQ_HideTooltip(self)
	GameTooltip:Hide()
end

function RAQ_UpdateButtonTooltip(self)
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
	local temp = RAQ_TOOLTIP[self:GetName()]

	if( temp == nil ) then
		if( RAQ_DEBUG ) then
			GameTooltip:AddLine("RAQ")
			GameTooltip:AddLine("No tooltip defined for '"..self:GetName().."'", 1, 1, 1, true)
		else
			return
		end
	else
		local tbl = {}
		repeat
			nextPos = string.find(temp,"\n")
			if( nextPos ~= nil ) then
				table.insert(tbl,strsub(temp,1,nextPos-1))
				temp = strsub(temp,nextPos+1)
			end
		until( nextPos == nil )
		if( temp ~= "" ) then
			table.insert(tbl,temp)
		end

		for k,v in ipairs(tbl) do
			if( k == 1 ) then
				GameTooltip:AddLine(v)
			else
				GameTooltip:AddLine(v, 1, 1, 1, true)
			end
		end
	end
	GameTooltip:SetMinimumWidth(100)
	GameTooltip:Show()
end

function RAQ_Error(msg)
	print("|cffff0000[RAQ]|r: "..msg)
end

function RAQ_UpdateHeader()
	local i,col,last,j,texture,name,temp,desc

	local data = RAQ_GetSelectedTable()
	if( data == nil ) then
		return
	end

	-- Hide everything
	for i=1,RAQ_NUMBER_COLUMN do
		getglobal("RAQFrameDataHeaderColumn"..i):Hide()
		getglobal("RAQFrameDataNeededColumn"..i.."Caption"):SetText("")
		for j=1,RAQ_NUMBER_BUTTON do
			getglobal("RAQFrameDataLine"..j.."Column"..i):Hide()
			getglobal("RAQFrameDataLine"..j.."Status"):SetText("")
		end
	end

	getglobal("RAQFrameDataNeededPlayer"):Show()

	-- Populate header with texture and achievement info
	last = 0
	offset = (RAQ_CURRENT_PAGE-1) * RAQ_NUMBER_COLUMN

	for i=1,RAQ_NUMBER_COLUMN do
		j = i + offset
		if( j <= #data ) then
			col = getglobal("RAQFrameDataHeaderColumn"..i)
			col.achievementID = data[j]

			texture = select(10,GetAchievementInfo(col.achievementID))
			name = select(2,GetAchievementInfo(col.achievementID))
			desc = select(8,GetAchievementInfo(col.achievementID))
			
			if( texture == nil ) then
				texture = RAQ_TEXTURE["unknown"]
			end
			if( name == nil ) then
				name = "id#" .. col.achievementID
			end
			if( desc == nil ) then
				desc = "<no info available>"
			end

			col.criteriaName = name
			col.criteriaDesc = desc
			col.link = GetAchievementLink(col.achievementID)

			col:SetNormalTexture(texture)
			col:Show()
		end
	end

	-- Reanchor the next and prev buttons.
	local temp = getglobal("RAQFramePrevPage")
	temp:ClearAllPoints()
	temp:SetPoint("BOTTOMLEFT", getglobal("RAQFrameDataHeaderColumn1"), "TOPLEFT", 0, 0 )
	temp:Show()
	if( RAQ_CURRENT_PAGE > 1 ) then
		temp:Enable()
	else
		temp:Disable()
	end

	temp = getglobal("RAQFrameNextPage")
	temp:ClearAllPoints()
	temp:SetPoint("BOTTOMRIGHT", getglobal("RAQFrameDataHeaderColumn"..(RAQ_NUMBER_COLUMN)), "TOPRIGHT", 0, 0 )
	temp:Show()
	if( (offset+RAQ_NUMBER_COLUMN) >= #data ) then
		temp:Disable()
	else
		temp:Enable()
	end

	-- Set title text and anchors
	temp = getglobal("RAQFrameDataTitleText")
	temp:ClearAllPoints()
	temp:SetPoint("BOTTOMLEFT", "RAQFrameDataHeaderColumn1", "TOPLEFT", 0, 0 )
	temp:SetPoint("TOPRIGHT", getglobal("RAQFrameDataHeaderColumn"..(RAQ_NUMBER_COLUMN)), "TOPRIGHT", 0, 16 )

	local val = UIDropDownMenu_GetSelectedValue(RAQDropDown)
	temp:SetText(val[#val])
	temp:Show()

	-- Enable scan/clear buttons.
	getglobal("RAQFrameScanButton"):Enable()
	getglobal("RAQFrameResetButton"):Enable()
end

function RAQ_AddFakeUser(name)
	local completed

	if( name == nil or name == "" ) then
		-- FIXME: Should be a randomized name
		name = "Fake "..date("%H:%M:%S")
	end

	if( math.random(20) == 1 ) then
		RAQ_SetStatus(name,"TIMEOUT")
	else
		RAQ_SetStatus(name,"SUCCESS")
		RAQ_DATA[name]["_data"] = {}
		for k in pairs(RAQ_DB["_scan"]) do
			if( math.random(5) ~= 1 ) then
				completed = true
			else
				completed = false
			end
			RAQ_DATA[name]["_data"][k] = completed
		end
	end
end

-- Debug function to fake data
function RAQ_FakeData()
	local i,name

	for i=1,(25-#RAQ_queue) do
		name = "Fake#"..i
		RAQ_AddFakeUser(name)
	end
end

function RAQ_CreateScanList()
	local list = {}
	local num = GetNumGroupMembers()
	if( IsInRaid() ) then
		for i=1,num do
			table.insert(list,"raid"..i)
		end
	else
		table.insert(list,"player")
		for i=1,num-1 do
			table.insert(list,"party"..i)
		end
	end
	return list
end

function RAQ_StartScan(mode)
	local prefix,count,addThis,unitName,scanList,scanTemp

	if( mode == nil or mode == "" ) then
		mode = "refresh"
	end

	RAQ_UpdateHeader()

	RAQ_queue = {}
	scanTemp = {}
	scanList = RAQ_CreateScanList()

	for i,v in ipairs(scanList) do
		unitName = UnitName(v)
		addThis = true
		scanTemp[unitName] = 1

		if( mode == "refresh" ) then
			-- Only rescan people with incomplete or old data.
			if( RAQ_DATA[unitName] ~= nil ) then
				if( RAQ_DATA[unitName]["_status"] == "SUCCESS" and difftime(time(),RAQ_DATA[unitName]["_scanTime"]) < RAQ_REFRESH_TIMEOUT ) then
					addThis = false
				end
			end
		end

		-- "force" is not listed as the default action is to add everyone.
		if( addThis ) then
			table.insert(RAQ_queue, {
				unitid = v,
				name = unitName,
			})
		end
	end

	-- Remove people no longer in the party/raid
	for k,v in pairs(RAQ_DATA) do
		if( scanTemp[k] == nil ) then
			RAQ_DATA[k] = nil
		end
	end

	RAQ_NUM_SCAN = #RAQ_queue
	RAQ_RunQueue()
end

function RAQ_RescanPlayer(name)
	local i,v,unitName,found

	RAQ_queue = {}

	-- Various inspect thingies requires unitID, not unitName. So need to translate.
	local scanList = RAQ_CreateScanList()
	found = false
	for i,v in ipairs(scanList) do
		unitName = UnitName(v)
		if( unitName == name ) then
			table.insert(RAQ_queue, {
				unitid = v,
				name = unitName,
			})
			found = true
		end
	end
	if( found ) then
		RAQ_NUM_SCAN = #RAQ_queue
		RAQ_RunQueue()
	end
end

function RAQ_UpdateProgress()
	local header = getglobal("RAQFrameDataHeaderPlayer")
	if( #RAQ_queue > 0 ) then
		header:SetText(string.format("Scaning: %d/%d",(RAQ_NUM_SCAN-#RAQ_queue),RAQ_NUM_SCAN))
	else
		header:SetText("")
	end
end

function RAQ_SetStatus(unit, status)
	if( RAQ_DATA[unit] == nil ) then
		RAQ_DATA[unit] = {}
	end
	RAQ_DATA[unit]["_status"] = status
	RAQ_DATA[unit]["_scanTime"] = time()
end

function RAQ_RunQueue()
	local nextID = next(RAQ_queue)

	RAQ_UpdateProgress()
	if( nextID ~= nil ) then
		if( SetAchievementComparisonUnit(RAQ_queue[nextID].unitid) ) then
			_unitID = RAQ_queue[nextID].unitid
			_unitName = RAQ_queue[nextID].name
			RAQ_SetTimer(RAQ_SCAN_TIMEOUT,
				function()
					ClearAchievementComparisonUnit()
					RAQ_SetStatus(_unitName,"TIMEOUT")
					RAQ_RunQueue()
				end)
		else
			RAQ_Error("Failed to SetAchievementComparisonUnit("..RAQ_queue[nextID]..").")
		end
		table.remove(RAQ_queue,nextID)
	else
		RAQ_KillTimer()
	end
	RAQ_UpdateUIList()
end

function RAQ_UpdateUIList()
	local j,texture,xoffset,yoffset,who,needed,data
	sorted = {}

	for k,v in pairs(RAQ_DATA) do
		table.insert(sorted,k)
	end
	table.sort(sorted)

	data = RAQ_GetSelectedTable()
	if( data ~= nil ) then
		xoffset = (RAQ_CURRENT_PAGE-1) * RAQ_NUMBER_COLUMN
		FauxScrollFrame_Update(RAQFrameScrollList,#sorted,RAQ_NUMBER_BUTTON,22)
		yoffset = FauxScrollFrame_GetOffset(RAQFrameScrollList)

		for k=1,RAQ_NUMBER_BUTTON do
			if( k+yoffset <= #sorted ) then
				who = sorted[k+yoffset]
				getglobal("RAQFrameDataLine"..k.."Player"):SetText(who)
				if( RAQ_DATA[who]["_status"] == "SUCCESS" ) then
					getglobal("RAQFrameDataLine"..k.."Status"):SetText("")
					for j=1,RAQ_NUMBER_COLUMN do
						j2 = j + xoffset
						if( j2 <= #data ) then
							if( RAQ_DATA[who]["_data"][data[j2]] == true ) then
								texture = RAQ_TEXTURE["yes"]
							else
								texture = RAQ_TEXTURE["no"]
							end
							getglobal("RAQFrameDataLine"..k.."Column"..j):SetNormalTexture(texture)
							getglobal("RAQFrameDataLine"..k.."Column"..j):Show()
						else
							getglobal("RAQFrameDataLine"..k.."Column"..j):Hide()
						end
						j = j + 1
					end

					-- Count needed
					needed = 0
					for k2,v2 in pairs(data) do
						if( RAQ_DATA[who]["_data"][v2] == false ) then
							needed = needed + 1
						end
					end
					getglobal("RAQFrameDataLine"..k.."Needed"):SetText(needed)
				else
					local status = getglobal("RAQFrameDataLine"..k.."Status")
					local width

					if( #data > RAQ_NUMBER_COLUMN ) then
						width = RAQ_NUMBER_COLUMN * 22
					else
						width = #data * 22
					end
					status:SetWidth(width)
					status:SetText(RAQ_SCAN_FAILED)
					status:Show()
					for j=1,RAQ_NUMBER_COLUMN do
						getglobal("RAQFrameDataLine"..k.."Column"..j):Hide()
					end
					getglobal("RAQFrameDataLine"..k.."Needed"):SetText("")
				end
			else
				getglobal("RAQFrameDataLine"..k.."Player"):SetText("")
				getglobal("RAQFrameDataLine"..k.."Status"):SetText("")
				getglobal("RAQFrameDataLine"..k.."Needed"):SetText("")
				for j=1,RAQ_NUMBER_COLUMN do
					getglobal("RAQFrameDataLine"..k.."Column"..j):Hide()
				end
			end
		end

		-- Update needed column
		local column,needed
		for j=1,RAQ_NUMBER_COLUMN do
			column = getglobal("RAQFrameDataNeededColumn"..j.."Caption")
			j2 = j + xoffset
			if( data ~= nil and j2 <= #data ) then
				needed = 0
				for k,v in pairs(RAQ_DATA) do
					if( v["_status"] == "SUCCESS" ) then
						if( v["_data"][data[j2]] ~= true ) then
							needed = needed + 1
						end
					end
				end
				column:SetText(needed)
			else
				column:SetText("")
			end
		end
	end
end

function RAQ_ShowPlayerContextMenu(self)
	RAQPlayerContextMenu.owner = self:GetName()
	ToggleDropDownMenu(1, nil, RAQPlayerContextMenu, "cursor")
end

function RAQ_ShowHeaderContextMenu(self)
	RAQHeaderContextMenu.owner = self:GetName()
	ToggleDropDownMenu(1, nil, RAQHeaderContextMenu, "cursor")
end

function RAQ_OnLoad(self)
	local tempFrame,theFrame,tempPlayer

	self:RegisterEvent("INSPECT_ACHIEVEMENT_READY")
	self:RegisterEvent("ADDON_LOADED")
			
	RAQ_OPTION = {
		["expansion"] = {},
		["category"] = {},
		["_meta"] = {},
	}
	RAQ_OPTION["_meta"]["firstTime"] = true

	getglobal("RAQFrameTitleText"):SetText("RAQ version "..GetAddOnMetadata("RAQ", "Version"))

	-- Global achievements DB init.
	RAQ_InitAchievements()

	-- Init expansion data.
	RAQ_Achievements_InitClassic()
	RAQ_Achievements_InitTBC()
	RAQ_Achievements_InitWotlk()
	RAQ_Achievements_InitCataclysm()
	RAQ_Achievements_InitMoP()

	-- Misc achievements.
	RAQ_Achievements_InitChallenges()

	-- Init pvp data.
	RAQ_Achievements_InitPvP()

	-- Global post init.
	RAQ_PostInitAchivements()
	RAQ_UpdateScan()


	tempFrame = getglobal("RAQFrameScanButton")
	tempFrame:SetScript("OnEnter", RAQ_UpdateButtonTooltip)
	tempFrame:SetScript("OnLeave", RAQ_HideTooltip)
	tempFrame:Disable()

	tempFrame = getglobal("RAQFrameResetButton")
	tempFrame:SetScript("OnEnter", RAQ_UpdateButtonTooltip)
	tempFrame:SetScript("OnLeave", RAQ_HideTooltip)
	tempFrame:Disable()

	-- Headers
	theFrame = CreateFrame("Button","RAQFrameDataHeader", RAQFrame, "RAQFrameDataLineTemplate")
	theFrame:SetPoint("TOPLEFT", "RAQFrame", "TOPLEFT", 15, -70 )
	-- Create columns
	for j=1,RAQ_NUMBER_COLUMN do
		tempFrame = CreateFrame("Button","RAQFrameDataHeaderColumn"..j, getglobal("RAQFrameDataHeader"), "RAQFrameDataButtonTemplate")
		getglobal(tempFrame:GetName().."Caption"):SetText("")

		if( j == 1 ) then
			tempFrame:SetPoint("TOPLEFT", "RAQFrameDataHeaderNeeded", "TOPRIGHT", 0, 0 )
		else
			tempFrame:SetPoint("TOPLEFT", "RAQFrameDataHeaderColumn"..(j-1), "TOPRIGHT", 2, 0 )
		end

		-- Add tooltips and click support to header buttons
		tempFrame:SetScript("OnEnter", RAQ_UpdateHeaderTooltip)
		tempFrame:SetScript("OnLeave", RAQ_HideTooltip)
		tempFrame:RegisterForClicks("RightButtonDown")
		tempFrame:SetScript("OnClick", function(self, button, down)
			if( button == "RightButton" ) then
				RAQ_ShowHeaderContextMenu(self)
			end
		end)
	end
	getglobal("RAQFrameDataHeaderPlayer"):SetText("")

	-- "Needed by" line below the header
	theFrame = CreateFrame("Button","RAQFrameDataNeeded", RAQFrame, "RAQFrameDataLineTemplate")
	theFrame:SetPoint("TOPLEFT", "RAQFrameDataHeader", "BOTTOMLEFT", 0, 0 )
	tempPlayer = getglobal("RAQFrameDataNeededPlayer")

	tempPlayer:SetText("Needed by ")
	tempPlayer:SetJustifyH("RIGHT")
	tempPlayer:Hide()
	tempPlayer:SetWidth(tempPlayer:GetWidth() + getglobal("RAQFrameDataNeededNeeded"):GetWidth())
	getglobal("RAQFrameDataNeededNeeded"):SetWidth(0)
	getglobal("RAQFrameDataNeededNeeded"):Hide()


	-- Create columns
	for j=1,RAQ_NUMBER_COLUMN do
		local tempFrame = CreateFrame("Button","RAQFrameDataNeededColumn"..j, getglobal("RAQFrameDataHeader"), "RAQFrameDataButtonTemplate")
		getglobal(tempFrame:GetName().."Caption"):SetText("")
		getglobal(tempFrame:GetName().."Caption"):SetJustifyH("CENTER")

		if( j == 1 ) then
			tempFrame:SetPoint("TOPLEFT", "RAQFrameDataNeededPlayer", "TOPRIGHT", 0, 0 )
		else
			tempFrame:SetPoint("TOPLEFT", "RAQFrameDataNeededColumn"..(j-1), "TOPRIGHT", 2, 0 )
		end
	end

	-- The actual buttons
	for i=1,RAQ_NUMBER_BUTTON do
		theFrame = CreateFrame("Button","RAQFrameDataLine"..i, RAQFrame, "RAQFrameDataLineTemplate")
		theFrame:RegisterForClicks("RightButtonDown")
		theFrame:SetScript("OnClick", function(self, button, down)
			if( button == "RightButton" ) then
				RAQ_ShowPlayerContextMenu(self)
			end
		end)

		if( i == 1 ) then
			theFrame:SetPoint("TOPLEFT", "RAQFrameDataNeeded", "BOTTOMLEFT", 0, 0 )
		else
			theFrame:SetPoint("TOPLEFT", "RAQFrameDataLine"..(i-1), "BOTTOMLEFT", 0, 0 )
		end

		getglobal("RAQFrameDataLine"..i.."Player"):SetText("")
		-- Create columns
		for j=1,RAQ_NUMBER_COLUMN do
			local tempFrame = CreateFrame("Button","RAQFrameDataLine"..i.."Column"..j, getglobal("RAQFrameDataLine"..i), "RAQFrameDataButtonTemplate")
			getglobal(tempFrame:GetName().."Caption"):SetText("")

			if( j == 1 ) then
				tempFrame:SetPoint("TOPLEFT", "RAQFrameDataLine"..i.."Needed", "TOPRIGHT", 0, 0 )
			else
				tempFrame:SetPoint("TOPLEFT", "RAQFrameDataLine"..i.."Column"..(j-1), "TOPRIGHT", 2, 0 )
			end
		end
	end

	-- Create a FauxScrollFrame and anchor it
	tempFrame = CreateFrame('ScrollFrame', 'RAQFrameScrollList', RAQFrame, 'FauxScrollFrameTemplate')
	tempFrame:SetPoint('TOPLEFT', "RAQFrameDataLine1", 0, 0)
	tempFrame:SetWidth((RAQ_NUMBER_COLUMN * 22) + 95); 
	tempFrame:SetHeight((RAQ_NUMBER_BUTTON-1) * 22)
	tempFrame:SetScript('OnShow', RAQ_UpdateUIList)
	tempFrame:SetScript('OnVerticalScroll', function(self, offset)
		FauxScrollFrame_OnVerticalScroll(self, offset, 22, RAQ_UpdateUIList)
	end)
	tempFrame:Show()

	-- Create dropdown for achievement.
	RAQ_CreateMainDropDown()
	
	-- Create dropdown for options.
	RAQ_CreateOptionDropDown()

	-- ..and player context menu
	RAQ_CreatePlayerContext()

	-- ..and header context menu
	RAQ_CreateHeaderContext()

	SLASH_RAQ1 = "/raq"
	SlashCmdList["RAQ"] = function(msg)
		RAQFrame:Show()
	end

	SLASH_RAQFAKE1 = "/raqfake"
	SlashCmdList["RAQFAKE"] = function(msg)
		RAQ_AddFakeUser(msg)
		RAQ_UpdateUIList()
	end

	self.TimeSinceLastUpdate = 0
end

function RAQ_UpdateHandler(self, elapsed)
	if( _RAQ_Timer ~= nil and _RAQ_Timer.timeout ~= nil ) then
		self.TimeSinceLastUpdate = self.TimeSinceLastUpdate + elapsed
		if( self.TimeSinceLastUpdate > RAQ_UPDATE_INTERVAL ) then
			self.TimeSinceLastUpdate = 0
			_RAQ_Timer.timeout = _RAQ_Timer.timeout - 1
			if( _RAQ_Timer.timeout == 0 ) then
				local callback = _RAQ_Timer.callback
				RAQ_KillTimer()
				callback()
			end
		end
	end
end

function RAQ_EventHandler(event, arg1)
	if( event == "INSPECT_ACHIEVEMENT_READY" ) then
		-- Only trigger if we have a timer active, as this gets called for other stuff. Like "normal" achievement compares.
		if( _RAQ_Timer ~= nil ) then
			local k,v,i,needed,completed,month,day,year,completedOut

			RAQ_KillTimer()

			RAQ_SetStatus(_unitName,"SUCCESS")
			RAQ_DATA[_unitName]["_data"] = {}
			i = 1
			for k,v in pairs(RAQ_DB["_scan"]) do
				completed = select(1, GetAchievementComparisonInfo(k))

				-- For some reason this is needed
				if( completed == true ) then
					completedOut = true
				else
					completedOut = false
				end
				RAQ_DATA[_unitName]["_data"][k] = completedOut
			end
			ClearAchievementComparisonUnit()
			RAQ_RunQueue()
		end
	elseif( event == "ADDON_LOADED" and arg1 == "RAQ" ) then
		if( RAQ_OPTION["_meta"]["firstTime"] ) then
			-- Set all expansions.
			for k,v in pairs(RAQ_DB["_expansion"]) do
				RAQ_OPTION["expansion"][k] = true
			end

			-- Set both pve and pvp.
			RAQ_OPTION["category"]["pve"] = true
			RAQ_OPTION["category"]["pvp"] = true
	
			-- Unset first time
			RAQ_OPTION["_meta"]["firstTime"] = false
		end
	
		RAQ_OPTION["_meta"]["version"] = GetAddOnMetadata("RAQ", "Version")
	end
end

function RAQ_StatusReport(self,isPlayer,target)
	local out = {}
	local targetTwo
	local count = 0
	local isRealID = false

	if( isPlayer == nil ) then
		isPlayer = false
	end

	if( string.find(target,"CHANNEL|(%d+)") ) then
		targetTwo = tonumber(select(3,string.find(target,"CHANNEL|(%d+)")))
		target = "CHANNEL"
	elseif( string.find(target,"REALID|(%d+)") ) then
		isRealID = true
		target = tonumber(select(3,string.find(target,"REALID|(%d+)")))
	elseif( target == "WHISPER" ) then
		if( UnitName("target") == nil ) then
			RAQ_Error("No target selected.")
			return
		end
		if( UnitIsPlayer("target") ~= 1 ) then
			RAQ_Error("Target is not a player.")
			return
		end
		targetTwo = UnitName("target")
	end

	if( target == nil ) then
		RAQ_Error("You are not in a raid or party. Nothing to report to.")
		return
	end

	out["incomplete"] = {}
	out["unknown"] = {}

	if( isPlayer ) then
		local playerName = self:GetText()
		local data = RAQ_GetSelectedTable()
		if( data ~= nil ) then
			local selectedAchievement = UIDropDownMenu_GetSelectedValue(RAQDropDown)
			local header = selectedAchievement[#selectedAchievement]

			if( RAQ_DATA[playerName]["_status"] == "SUCCESS" ) then
				for k,v in ipairs(data) do
					if( RAQ_DATA[playerName]["_data"][v] == false ) then
						name = select(2,GetAchievementInfo(v))
						table.insert(out["incomplete"],name)
					end
					count = count + 1
				end

				local incomplete = table.concat(out["incomplete"],", ")
				local maxLength = 255

				if( #out["incomplete"] == 0 ) then
					RAQ_SendMessage(string.format("[RAQ] %s: %s has completed all.",header,playerName), isRealID, target, targetTwo)
				else
					local out = string.format("[RAQ] %s: %s needs %d of %d: %s",header,playerName,#out["incomplete"],count,incomplete)
					local temp = ''
					for word in out:gmatch("%S+") do
						if( string.len(temp..' '..word) >= maxLength ) then
							RAQ_SendMessage(temp, isRealID, target, targetTwo)
							temp = ''
						end
						temp = temp .. word .. ' '
					end
					if( temp ~= '' ) then
						RAQ_SendMessage(temp, isRealID, target, targetTwo)
					end
				end
			else
				RAQ_Error(string.format("%s: Scan failed for %s. Rescan before reporting again.",header,playerName))
			end
		else
			RAQ_Error("Nothing selected.")
		end
	else
		for k,v in pairs(RAQ_DATA) do
			if( v ~= nil ) then
				if( v["_status"] == "SUCCESS" ) then
					if( v["_data"][self.achievementID] == false ) then
						table.insert(out["incomplete"],k)
					end
				else
					table.insert(out["unknown"],k)
				end
			end
			count = count + 1
		end

		table.sort(out["incomplete"])
		table.sort(out["unknown"])

		local incomplete = table.concat(out["incomplete"],", ")
		local unknown = table.concat(out["unknown"],", ")

		if( incomplete == "" ) then incomplete = "No one"; end

		if( self.link == nil ) then
			self.link = "<unknown>"
		end

		RAQ_SendMessage("[RAQ] "..self.link..":", isRealID, target, targetTwo)
		RAQ_SendMessage(string.format("Needed by (%d of %d): %s",#out["incomplete"],count-#out["unknown"],incomplete), isRealID, target, targetTwo)

		if( unknown ~= "" ) then
			RAQ_SendMessage(string.format("Not scanned (%d): %s",#out["unknown"],unknown), isRealID, target, targetTwo)
		end
	end
end

function RAQ_SendMessage(temp, isRealID, target, targetTwo)
	if( isRealID ) then
		BNSendWhisper(target, temp)
	else
		SendChatMessage(temp, target, nil, targetTwo)
	end
end


function RAQ_HandleButton(self)
	local buttonID = self:GetID()

	if( buttonID == 1 ) then
		local scanMode = "refresh"
		-- Scan
		if( IsControlKeyDown() ) then
			scanMode = "force"
		end
		RAQ_StartScan(scanMode)
	elseif( buttonID == 2 ) then
		-- Clear data
		RAQ_DATA = {}
		RAQ_UpdateUIList()
	elseif( buttonID == 3 or buttonID == 4 ) then
		-- Prev/Next
		if( buttonID == 3 ) then
			RAQ_CURRENT_PAGE = RAQ_CURRENT_PAGE - 1
		else
			RAQ_CURRENT_PAGE = RAQ_CURRENT_PAGE + 1
		end
		RAQ_UpdateHeader()
		RAQ_UpdateUIList()
	else
		-- Unknown
		local buttonIDOut = buttonID
		if( buttonIDOut == nil ) then
			buttonIDOut = "(nil)"
		end
		RAQ_Error("Unknown button, name is '"..self:GetName().."' id is '"..buttonIDOut.."'")
	end
end

function RAQ_GetSelectedTable()
	local t = UIDropDownMenu_GetSelectedValue(RAQDropDown)

	if( t == nil ) then
		return nil
	end

	if( type(t) ~= "table" ) then
		RAQ_Error("Unknown type ("..type(t)..") in GetSelectedTable.")
	end

	-- pvp is stored in a special way.
	if( t[1] == "_pvp" ) then
		local temp = {}
		if( t[2] == "bg" ) then
			for k,v in pairs(RAQ_DB[t[1]][t[3]]) do
				if( k ~= "_meta" ) then
					table.insert(temp, k)
				end
			end
		elseif( t[2] == "Arena" or t[2] == "Rated Battleground" ) then
			for k,v in pairs(RAQ_DB[t[1]]) do
				if( v["_meta"].subcategory == t[2] ) then
					for k2,v2 in pairs(v) do
						if( k2 ~= "_meta" ) then
							table.insert(temp, k2)
						end
					end
				end
			end
		elseif( t[2] == "meta" ) then
			for k,v in pairs(RAQ_DB["_meta"][t[3]]) do
				if( k ~= "_meta" ) then
					table.insert(temp, k)
				end
			end
		end
		return temp
	elseif( t[1] == "_scenario" ) then
		-- As is scenario. Currently only one stored scenario.
		local temp = {}
		for k,v in pairs(RAQ_DB[t[1]][t[2]]) do
			if( k ~= "_meta" ) then
				table.insert(temp, k)
			end
		end
		return temp
	end

	if( #t == 2 ) then
		-- Small hack to fix so you can click on a boss submenu and get to instance mode.
		if( t[1] == "_boss" ) then
			t[1] = "_instance"
		end
		if( t[1] == "_dungeon" or t[1] == "_raid" ) then
			t[1] = "_instance"
		end
		if( t[1] == "_challenge" ) then
			t[1] = "_instance"
		end

		-- Strip out _meta key (so we don't have to handle it elsewhere)
		local temp = {}
		for k,v in pairs(RAQ_DB[t[1]][t[2]]) do
			if( k ~= "_meta" ) then
				table.insert(temp, k)
			end
		end
		return temp
	elseif( #t == 3 ) then
		-- Straight up boss, just return as it is.
		return RAQ_DB[t[1]][t[2]][t[3]]
	end
	RAQ_Error("Unknown length of table ("..#t..") in GetSelectedTable.")
	return nil
end

function RAQ_HideAllDropDowns()
	local i,frame
	-- Hides ALL the dropdown lists.
	-- FIXME: Investigate if this can be done properly, and not in this hackish way.
	i = 1
	repeat
		frame = getglobal("DropDownList"..i)
		if( frame ~= nil ) then
			frame:Hide()
		end
		i = i + 1
	until( frame == nil or i > 10 )
end

function RAQ_CreateMainDropDown()
	local temp = CreateFrame("Frame", "RAQDropDown", RAQFrame, "UIDropDownMenuTemplate")
	local t = {}

	temp:ClearAllPoints()
	temp:SetPoint("TOPLEFT", RAQFrame, "TOPLEFT", 0, -25)
	temp:Show()

	local function OnClick(self, arg1)
		RAQ_HideAllDropDowns()
		UIDropDownMenu_SetSelectedValue(RAQDropDown, self.value)

		-- Set the dropdown text to the last value, for looks only. :>
		if( type(self.value) == "table" ) then
			UIDropDownMenu_SetText(RAQDropDown, self.value[#self.value])
		end

		RAQ_CURRENT_PAGE = 1
		RAQ_UpdateHeader()
		RAQ_UpdateUIList()
	end

	local function includeEntry(meta, ref)
		-- Check expansion
		if( meta.expansion ~= "" and RAQ_OPTION["expansion"][meta.expansion] == nil ) then
			return false
		end
		
		-- Check category if requested.
		if( ref.category and meta.category ~= ref.category ) then
			return false
		end

		-- Check subcategory if requested.
		if( ref.subcategory and meta.subcategory ~= ref.subcategory ) then
			return false
		end

		return true
	end

	local function getCategory()
		local both
		if( RAQ_OPTION["category"]["pve"] ~= nil and RAQ_OPTION["category"]["pvp"] ~= nil ) then
			return UIDROPDOWNMENU_MENU_VALUE[1]
		else
			if( RAQ_OPTION["category"]["pve"] ~= nil ) then
				return "pve"
			elseif( RAQ_OPTION["category"]["pvp"] ~= nil ) then
				return "pvp"
			else
				return ""
			end
		end
	end

	local function initialize(self, level)
		--[[
		   Drop down menu structure:

		   RAQ
		   +- PvE
		      +- Bosses
		         +- <zones>
		            +- <bosses>
		      +- Dungeons
		         +- <dungeons>
		      +- Raids
		         +- <raids>
		      +- Meta achivements
		         +- <metas>
		      +- Scenarios
		      +- Dungeon Challenges
		   +- PvP
		      +- Arena
		      +- Battleground
		         +- <list of bgs>
		      +- Meta
		      +- Rated Battleground
		]]--
		t = {}
		level = level or 1

		local both
		if( RAQ_OPTION["category"]["pve"] ~= nil and RAQ_OPTION["category"]["pvp"] ~= nil ) then
			both = true
		else
			both = false
		end

		local elevel
		if( both == true ) then
			elevel = level
		else
			elevel = level + 1
		end

		local nothing = {
			name = "Nothing to display",
			arrow = false,
			clickable = false,
			title = true,
		}

		if( elevel == 1 ) then
			-- Categories.
			table.insert(t, {
				name = "PvE",
				value = { "pve" },
				sort = 0,
			})
			table.insert(t, {
				name = "PvP",
				value = { "pvp" },
				sort = 1,
			})
		end	

		if( elevel == 2 ) then
			if( getCategory() == "pve" ) then
				table.insert(t, {
					name = "Bosses",
					clickable = false,
					value = { "_boss" },
					sort = 0,
				})
				table.insert(t, {
					name = "Dungeons",
					clickable = false,
					value = { "_dungeon" },
					sort = 10,
				})
				table.insert(t, {
					name = "Raids",
					clickable = false,
					value = { "_raid" },
					sort = 20,
				})
				table.insert(t, {
					name = "Meta achievements",
					clickable = false,
					value = { "_meta" },
					sort = 30,
				})
				table.insert(t, {
					name = "Challenges",
					clickable = false,
					value = { "_challenge" },
					sort = 40,
				})

				-- Ugly hack.
				if( includeEntry(RAQ_DB["_scenario"]["Scenarios"]["_meta"], { category = "pve" }) ) then
					table.insert(t, {
						name = "Scenarios",
						value = { "_scenario", "Scenarios" },
						arrow = false,
						sort = 50,
					})
				end
			elseif( getCategory() == "pvp" ) then
				table.insert(t, {
					name = "Arena",
					arrow = false,
					value = { "_pvp", "Arena" },
					sort = 0,
				})
				table.insert(t, {
					name = "Battleground",
					clickable = false,
					value = { "_pvp", "bg" },
					sort = 1,
				})
				table.insert(t, {
					name = "Rated Battleground",
					arrow = false,
					value = { "_pvp", "Rated Battleground" },
					sort = 2,
				})
				table.insert(t, {
					name = "Meta",
					value = { "_pvp", "meta" },
					sort = 3,
				})
			end
			if( next(t) == nil ) then
				table.insert(t, nothing)
			end
		end

		if( elevel == 3 ) then
			if( UIDROPDOWNMENU_MENU_VALUE[1] == "_dungeon" or UIDROPDOWNMENU_MENU_VALUE[1] == "_raid" ) then
				-- Dungeon or raid for PvE.
				local subcat
				if( UIDROPDOWNMENU_MENU_VALUE[1] == "_raid" ) then
					subcat = "raid"
				else
					subcat = "dungeon"
				end
				for k,v in pairs(RAQ_DB["_instance"]) do
					if( includeEntry(v["_meta"], { category = "pve", subcategory = subcat }) ) then
						table.insert(t, {
							name = k,
							arrow = false,
							value = { UIDROPDOWNMENU_MENU_VALUE[1], k }
						})
					end
				end
			elseif( UIDROPDOWNMENU_MENU_VALUE[1] == "_challenge" ) then
				-- Dungeon challenges for PvE.
				for k,v in pairs(RAQ_DB["_instance"]) do
					if( includeEntry(v["_meta"], { category = "pve", subcategory = "challenge" }) ) then
						table.insert(t, {
							name = k,
							arrow = false,
							value = { UIDROPDOWNMENU_MENU_VALUE[1], k }
						})
					end
				end
			elseif( UIDROPDOWNMENU_MENU_VALUE[1] == "_meta" ) then
				-- Meta for PvE.
				for k,v in pairs(RAQ_DB[UIDROPDOWNMENU_MENU_VALUE[1]]) do
					if( includeEntry(v["_meta"], { category = "pve" }) ) then
						table.insert(t, {
							name = k,
							arrow = false,
							value = { UIDROPDOWNMENU_MENU_VALUE[1], k }
						})
					end
				end
			elseif( UIDROPDOWNMENU_MENU_VALUE[1] == "_boss" ) then
				-- Boss name for PvE.
				for k,v in pairs(RAQ_DB[UIDROPDOWNMENU_MENU_VALUE[1]]) do
					if( includeEntry(RAQ_DB["_instance"][k]["_meta"], { category = "pve" }) ) then
						table.insert(t, {
							name = k,
							arrow = true,
							value = { UIDROPDOWNMENU_MENU_VALUE[1], k }
						})
					end
				end
			elseif( UIDROPDOWNMENU_MENU_VALUE[1] == "_pvp" ) then
				if( UIDROPDOWNMENU_MENU_VALUE[2] == "bg" ) then
					-- Battleground.
					for k,v in pairs(RAQ_DB[UIDROPDOWNMENU_MENU_VALUE[1]]) do
						if( includeEntry(v["_meta"], { subcategory = "bg" }) ) then
							table.insert(t, {
								name = k,
								arrow = false,
								value = { UIDROPDOWNMENU_MENU_VALUE[1], "bg", k }
							})
						end
					end
				elseif( UIDROPDOWNMENU_MENU_VALUE[2] == "meta" ) then
					-- List PvP meta achievements.
					for k,v in pairs(RAQ_DB["_meta"]) do
						if( includeEntry(v["_meta"], { category = "pvp" })) then
							table.insert(t, {
								name = k,
								arrow = false,
								value = { UIDROPDOWNMENU_MENU_VALUE[1], "meta", k }
							})
						end
					end
				end
			else
				table.insert(t, {
					name = "Internal error",
					arrow = false,
					clickable = false,
					value = { "_error" },
				})
			end
			if( next(t) == nil ) then
				table.insert(t, nothing)
			end
		end

		if( elevel == 4 ) then
			if( UIDROPDOWNMENU_MENU_VALUE[1] == "_boss" ) then
				-- Achievements tied for a specific boss in PvE.
				local instance = UIDROPDOWNMENU_MENU_VALUE[2]
				for k,v in pairs(RAQ_DB["_boss"][instance]) do
					table.insert(t, {
						name = k,
						arrow = false,
						value = { "_boss", instance, k }
					})
				end
			end
		end


		if( next(t) == nil ) then
			table.insert(t, {
				name = "Internal error",
				arrow = false,
				clickable = false,
				value = { "_error" }
			})
		end

		table.sort(t, function(a,b)
			if( a.sort and b.sort ) then
				return a.sort < b.sort
			else
				return a.name < b.name
			end
		end)
		local info = UIDropDownMenu_CreateInfo()
		local temp
		for k,v in ipairs(t) do
			info = UIDropDownMenu_CreateInfo()
			if( v.clickable == nil or v.clickable ) then
				info.func = OnClick
			end
			if( v.arrow == nil or v.arrow ) then
				info.hasArrow = true
			else
				info.hasArrow = false
			end
			if( v.title ~= nil and v.title ) then
				info.isTitle = true
			end
			info.notCheckable = true
			info.text = v.name
			info.value = v.value
			UIDropDownMenu_AddButton(info, level)
		end
	end

	UIDropDownMenu_Initialize(RAQDropDown, initialize)
	UIDropDownMenu_SetWidth(RAQDropDown, 250)
	UIDropDownMenu_SetButtonWidth(RAQDropDown, 250)
	UIDropDownMenu_JustifyText(RAQDropDown, "LEFT")

end

function RAQ_CreateOptionDropDown()
	local temp = CreateFrame("Frame", "RAQOptionDropDown", RAQFrame, "UIDropDownMenuTemplate")
	local t = {}

	temp:ClearAllPoints()
	temp:SetPoint("TOPLEFT", RAQDropDown, "TOPRIGHT", -25, 0)
	temp:Show()

	local function OnClick(self, arg1, arg2, checked)
		if( arg1 ~= nil and arg1 ~= "" ) then
			if( checked ) then
				RAQ_OPTION[arg2][arg1] = nil
			else
				RAQ_OPTION[arg2][arg1] = true
			end
		end
		UIDropDownMenu_SetText(RAQOptionDropDown, "Options")
	end

	local function initialize(self, level)
		t = {}
		level = level or 1

		if( level == 1 ) then
			table.insert(t, {
				name = "Expansions:",
				title = true,
				sort = -10,
				arrow = false,
				checkable = false,
			})
			
			-- Expansions.
			for k,v in pairs(RAQ_DB["_expansion"]) do
				table.insert(t, {
					name = v.name,
					key = k,
					sort = v.sort,
					check = "expansion",
				})
			end
		
			table.insert(t, {
				blank = true,
				sort = 100,
			})

			-- Categories.
			table.insert(t, {
				name = "Categories:",
				title = true,
				sort = 101,
				arrow = false,
				checkable = false,
			})
	
			table.insert(t, {
				name = "PvE",
				key = "pve",
				check = "category",
				sort = 102,
			})
			table.insert(t, {
				name = "PvP",
				key = "pvp",
				check = "category",
				sort = 103,
			})
		end	

		if( next(t) == nil ) then
			table.insert(t, {
				name = "Internal error",
				key = "",
				clickable = false,
			})
		end

		table.sort(t, function(a,b) return a.sort < b.sort end)
		local info = UIDropDownMenu_CreateInfo()
		local temp
		for k,v in ipairs(t) do
			info = UIDropDownMenu_CreateInfo()
			
			if( v.blank ~= nil ) then
				wipe(info)
				info.disabled = true
				info.notCheckable = true
			else
				if( v.clickable == nil or v.clickable ) then
					info.func = OnClick
				end
				info.hasArrow = false
				if( v.checkable == false ) then
					info.notCheckable = true 
				end
				if( v.check and RAQ_OPTION[v.check][v.key] ~= nil ) then
					info.checked = true
				else
					info.checked = nil
				end
				info.text = v.name
				info.arg1 = v.key
				info.arg2 = v.check
				if( v.title ~= nil and v.title ) then
					info.isTitle = true
				end
			end
			UIDropDownMenu_AddButton(info, level)
			info.disabled = nil
		end
	end

	UIDropDownMenu_Initialize(RAQOptionDropDown, initialize)
	UIDropDownMenu_SetWidth(RAQOptionDropDown, 75)
	UIDropDownMenu_SetButtonWidth(RAQOptionDropDown, 75)
	UIDropDownMenu_JustifyText(RAQOptionDropDown, "LEFT")
	UIDropDownMenu_SetText(RAQOptionDropDown, "Options")
end

function RAQ_BuildChannelList(...)
	local tbl = {}
	for i=1,select('#',...), 2 do
		local id,name = select(i,...)
		table.insert(tbl, { name = id..". "..name, key = "CHANNEL|"..id })
	end
	return tbl
end

function RAQ_GetReportList()
	local tbl = {}
	local first

	-- Normal targets.
	table.insert(tbl,{ title = "Report to" })
	table.insert(tbl,{ name = "Say", key = "SAY" })

	local num = GetNumGroupMembers()
	if( num > 0 ) then
		table.insert(tbl,{ name = "Party", key = "PARTY" })
		if( IsInRaid() ) then
			table.insert(tbl,{ name = "Raid", key = "RAID" })
			table.insert(tbl,{ name = "Raid Warning", key = "RAID_WARNING" })
		end
	end

	if( UnitInBattleground("player") ~= nil ) then
		table.insert(tbl,{ name = "Battleground", key = "BATTLEGROUND" })
	end

	-- Guild.
	if( select(1,GetGuildInfo("player")) ~= nil ) then
		table.insert(tbl,{ name = "Guild", key = "GUILD" })
		table.insert(tbl,{ name = "Officer", key = "OFFICER" })
	end

	-- Whisper target.
	table.insert(tbl,{ name = "Whisper Target", key = "WHISPER" })

	-- Channels.
	first = true
	for k,v in ipairs(RAQ_BuildChannelList(GetChannelList())) do
		if( first ) then
			table.insert(tbl,{ title = "Channels" })
			first = false
		end
		table.insert(tbl,v)
	end

	-- RealID.
	first = true
	for i=1, select(2, BNGetNumFriends()) do
		local id,realName,battleTag,_,charName = BNGetFriendInfo(i)

		if( first ) then
			table.insert(tbl,{ title = "Real ID friends" })
			first = false
		end
		table.insert(tbl, { name = realName.." ("..charName..")", key = "REALID|"..id })
	end

	return tbl
end

function RAQ_CreateHeaderContext()
	local info = {}
	local temp = CreateFrame("Frame", "RAQHeaderContextMenu", RAQFrame, "UIDropDownMenuTemplate")
	temp.displayMode = "MENU"

	local function OnClick(self, arg1)
		RAQ_HideAllDropDowns()
		RAQ_StatusReport(getglobal(RAQHeaderContextMenu.owner),false,self.value)
	end

	local function initialize(self, level)
		level = level or 1
		if( RAQHeaderContextMenu.owner ~= nil ) then
			if( level == 1 ) then
				local t = RAQ_GetReportList()
				local info = UIDropDownMenu_CreateInfo()
				for i,v in ipairs(t) do
					info = UIDropDownMenu_CreateInfo()
					info.notCheckable = 1
					if( v.title ) then
						info.isTitle = true
						info.text = v.title
						info.value = nil
						info.func = nil
					else
						info.isTitle = nil
						info.func = OnClick
						info.text = v.name
						info.value = v.key
					end
					UIDropDownMenu_AddButton(info, level)
				end

				wipe(info)
				info.notCheckable = 1
				UIDropDownMenu_AddButton(info, level)

				info.text = CANCEL
				info.func = RAQ_HideAllDropDowns
				info.notCheckable = 1
				UIDropDownMenu_AddButton(info, level)
			end
		end
	end

	UIDropDownMenu_Initialize(RAQHeaderContextMenu, initialize)
end

function RAQ_CreatePlayerContext()
	local info = {}
	local temp = CreateFrame("Frame", "RAQPlayerContextMenu", RAQFrame, "UIDropDownMenuTemplate")
	temp.displayMode = "MENU"

	local function OnReportClick(self, arg1)
		RAQ_HideAllDropDowns()
		RAQ_StatusReport(getglobal(RAQPlayerContextMenu.owner.."Player"),true,self.value)
	end

	local function initialize(self, level)
		level = level or 1
		if( RAQPlayerContextMenu.owner ~= nil ) then
			if( level == 1 ) then
				wipe(info)

				-- FIXME: These should be localized.
				info.isTitle = 1
				info.notCheckable = 1
				info.text = getglobal(RAQPlayerContextMenu.owner.."Player"):GetText()
				UIDropDownMenu_AddButton(info, level)

				info.disabled = nil
				info.isTitle = nil

				info.text = "Rescan"
				info.func = function()
					RAQ_RescanPlayer(getglobal(RAQPlayerContextMenu.owner.."Player"):GetText())
				end
				UIDropDownMenu_AddButton(info, level)

--				info.text = "[NYI] Add to ignore list"
--				info.func = nil
--				UIDropDownMenu_AddButton(info, level)

				info.text = "Report"
				info.hasArrow = true
				UIDropDownMenu_AddButton(info, level)
				info.hasArrow = false

				info.text = CANCEL
				info.func = RAQ_HideAllDropDowns
				UIDropDownMenu_AddButton(info, level)
			end

			if( level == 2 ) then
				local t = RAQ_GetReportList()

				local info = UIDropDownMenu_CreateInfo()
				for i,v in ipairs(t) do
					info = UIDropDownMenu_CreateInfo()

					info.notCheckable = 1
					if( v.title ) then
						info.isTitle = true
						info.text = v.title
						info.value = nil
						info.func = nil
					else
						info.isTitle = nil
						info.func = OnReportClick
						info.text = v.name
						info.value = v.key
					end
					UIDropDownMenu_AddButton(info, level)
				end
			end
		end
	end

	UIDropDownMenu_Initialize(RAQPlayerContextMenu, initialize)
end

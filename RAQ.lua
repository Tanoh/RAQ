--[[

	[R]aid [A]chievement [Q]uery
	============================

	Useage: /raq

	Written by: Jonas Fällman <jonas@fallman.org>
		aka Tanoh at Earthen Ring(EU)

	FIXME:
		* Fix the various FIXMEs.
		* Localization on a lot of things
		* Implement ignore list.
--]]


RAQ_DEBUG = false;
RAQ_SCAN_TIMEOUT = 3; -- Timeout in seconds for the scanner.
RAQ_REFRESH_TIMEOUT = 60*60; -- Timeout in seconds before a re-scan.
RAQ_DB = {};
RAQ_DATA = {};

-- Internal values, should not be messed with! :>
local RAQ_NUMBER_BUTTON = 14;
local RAQ_NUMBER_COLUMN = 17;
local RAQ_UPDATE_INTERVAL = 1.0;
local RAQ_CURRENT_PAGE = 1;

local RAQ_TEXTURE = {
	["yes"] = [[Interface\AddOns\RAQ\media\true]],
	["no"] = [[Interface\AddOns\RAQ\media\false]],
};

local RAQ_NUM_SCAN;
local RAQ_SCAN_FAILED = "Scan failed";
local RAQ_queue = {};
local _RAQ_Timer = nil;
local _unitID;

-- Tooltips for buttons. Currently only two buttons using it, but hey you never
-- know. :> First line is header (yellow), after that every line is added in white.
RAQ_TOOLTIP = {
	RAQFrameScanButton = "Scan\nScans your group for achievements, results are cached for "..RAQ_REFRESH_TIMEOUT.." seconds.\nHold |cffffff00CTRL|r to force a rescan.";
	RAQFrameResetButton = "Reset\nClears all data collected.";
}



function RAQ_SetTimer(timeout,callback)
	_RAQ_Timer = {};
	_RAQ_Timer = {
		["timeout"] = timeout,
		["callback"] = callback,
	};
end

function RAQ_KillTimer()
	_RAQ_Timer = nil;
end

function RAQ_UpdateHeaderTooltip(self)
	if( self.criteriaName ~= nil ) then
		GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT");
		GameTooltip:AddLine(self.criteriaName);
		GameTooltip:AddLine(self.criteriaDesc, 1, 1, 1, 1);
		if( RAQ_DEBUG == true ) then
			GameTooltip:AddLine("ID: "..self.achievementID);
		end
		GameTooltip:SetMinimumWidth(100);
		GameTooltip:Show();
	else
		GameTooltip:Hide();
	end
end

function RAQ_HideTooltip(self)
	GameTooltip:Hide();
end

function RAQ_UpdateButtonTooltip(self)
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT");
	local temp = RAQ_TOOLTIP[self:GetName()];

	if( temp == nil ) then
		if( RAQ_DEBUG ) then
			GameTooltip:AddLine("RAQ");
			GameTooltip:AddLine("No tooltip defined for '"..self:GetName().."'", 1, 1, 1, true);
		else
			return;
		end
	else
		local tbl = {};
		repeat
			nextPos = string.find(temp,"\n");
			if( nextPos ~= nil ) then
				table.insert(tbl,strsub(temp,1,nextPos-1));
				temp = strsub(temp,nextPos+1);
			end
		until( nextPos == nil );
		if( temp ~= "" ) then
			table.insert(tbl,temp);
		end

		for k,v in ipairs(tbl) do
			if( k == 1 ) then
				GameTooltip:AddLine(v);
			else
				GameTooltip:AddLine(v, 1, 1, 1, true);
			end
		end
	end
	GameTooltip:SetMinimumWidth(100);
	GameTooltip:Show();
end

function RAQ_Error(msg)
	print("|cff00ff00RAQ|r: "..msg);
end

function RAQ_UpdateHeader()
	local i,col,last,j,texture,name,temp,desc;

	local data = RAQ_GetSelectedTable();
	if( data == nil ) then
		return
	end

	-- Hide everything
	for i=1,RAQ_NUMBER_COLUMN do
		getglobal("RAQFrameDataHeaderColumn"..i):Hide();
		getglobal("RAQFrameDataNeededColumn"..i.."Caption"):SetText("");
		for j=1,RAQ_NUMBER_BUTTON do
			getglobal("RAQFrameDataLine"..j.."Column"..i):Hide();
			getglobal("RAQFrameDataLine"..j.."Status"):SetText("");
		end
	end

	getglobal("RAQFrameDataNeededPlayer"):Show();

	-- Populate header with texture and achievement info
	last = 0;
	offset = (RAQ_CURRENT_PAGE-1) * RAQ_NUMBER_COLUMN;

	for i=1,RAQ_NUMBER_COLUMN do
		j = i + offset;
		if( j <= #data ) then
			col = getglobal("RAQFrameDataHeaderColumn"..i);
			col.achievementID = data[j];

			texture = select(10,GetAchievementInfo(col.achievementID));
			name = select(2,GetAchievementInfo(col.achievementID));
			desc = select(8,GetAchievementInfo(col.achievementID));

			col.criteriaName = name;
			col.criteriaDesc = desc;
			col.link = GetAchievementLink(col.achievementID);

			col:SetNormalTexture(texture);
			col:Show();
		end
	end

	-- Reanchor the next and prev buttons.
	local temp = getglobal("RAQFramePrevPage");
	temp:ClearAllPoints();
	temp:SetPoint("BOTTOMLEFT", getglobal("RAQFrameDataHeaderColumn1"), "TOPLEFT", 0, 0 );
	temp:Show();
	if( RAQ_CURRENT_PAGE > 1 ) then
		temp:Enable();
	else
		temp:Disable();
	end

	temp = getglobal("RAQFrameNextPage");
	temp:ClearAllPoints();
	temp:SetPoint("BOTTOMRIGHT", getglobal("RAQFrameDataHeaderColumn"..(RAQ_NUMBER_COLUMN)), "TOPRIGHT", 0, 0 );
	temp:Show();
	if( (offset+RAQ_NUMBER_COLUMN) >= #data ) then
		temp:Disable();
	else
		temp:Enable();
	end
	
	-- Set title text and anchors
	temp = getglobal("RAQFrameDataTitleText");
	temp:ClearAllPoints();
	temp:SetPoint("BOTTOMLEFT", "RAQFrameDataHeaderColumn1", "TOPLEFT", 0, 0 );
	temp:SetPoint("TOPRIGHT", getglobal("RAQFrameDataHeaderColumn"..(RAQ_NUMBER_COLUMN)), "TOPRIGHT", 0, 16 );
	
	local name = UIDropDownMenu_GetSelectedValue(RAQDropDown);
	temp:SetText(name[#name]);
	temp:Show();

	-- Enable scan/clear buttons.
	getglobal("RAQFrameScanButton"):Enable();
	getglobal("RAQFrameResetButton"):Enable();
end

function RAQ_AddFakeUser(name)
	local completed;

	if( name == nil or name == "" ) then
		-- FIXME: Should be a randomized name
		name = "Fake "..date("%H:%M:%S");
	end
	
	if( math.random(20) == 1 ) then
		RAQ_SetStatus(name,"TIMEOUT");
	else
		RAQ_SetStatus(name,"SUCCESS");
		RAQ_DATA[name]["_data"] = {};
		for k in pairs(RAQ_DB["_scan"]) do
			if( math.random(5) ~= 1 ) then
				completed = true;
			else
				completed = false;
			end
			RAQ_DATA[name]["_data"][k] = completed;
		end
	end
end

-- Debug function to fake data
function RAQ_FakeData()
	local i,name;

	for i=1,(25-#RAQ_queue) do
		name = "Fake#"..i;
		RAQ_AddFakeUser(name);
	end
end

function RAQ_StartScan(mode)
	local prefix,count,addThis,unitName,scanList,scanTemp;

	if( mode == nil or mode == "" ) then
		mode = "refresh";
	end

	RAQ_UpdateHeader();

	RAQ_queue = {};
	scanList = {};
	scanTemp = {};

	if( GetNumRaidMembers() <= 5 and not UnitInRaid("player") ) then
		table.insert(scanList,"player");
		for i=1,GetNumPartyMembers() do
			table.insert(scanList,"party"..i);
		end
	else
		for i=1,GetNumRaidMembers() do
			table.insert(scanList,"raid"..i);
		end
	end

	for i,v in ipairs(scanList) do
		unitName = UnitName(v);
		addThis = true;
		scanTemp[unitName] = 1;

		if( mode == "refresh" ) then
			-- Only rescan people with incomplete or old data.
			if( RAQ_DATA[unitName] ~= nil ) then
				if( RAQ_DATA[unitName]["_status"] == "SUCCESS" and difftime(time(),RAQ_DATA[unitName]["_scanTime"]) < RAQ_REFRESH_TIMEOUT ) then
					addThis = false;
				end
			end
		end

		-- "force" is not listed as the default action is to add everyone.
		if( addThis ) then
			table.insert(RAQ_queue, {
				unitid = v,
				name = unitName,
			});
		end
	end

	-- Remove people no longer in the party/raid
	for k,v in pairs(RAQ_DATA) do
		if( scanTemp[k] == nil ) then
			RAQ_DATA[k] = nil;
		end
	end

	RAQ_NUM_SCAN = #RAQ_queue;
	RAQ_RunQueue();
end

function RAQ_RescanPlayer(name)
	local i,v,unitName,found;
	local scanList = {};

	RAQ_queue = {};

	-- Various inspect thingies requires unitID, not unitName :(
	if( GetNumRaidMembers() <= 5 and not UnitInRaid("player") ) then
		table.insert(scanList,"player");
		for i=1,GetNumPartyMembers() do
			table.insert(scanList,"party"..i);
		end
	else
		for i=1,GetNumRaidMembers() do
			table.insert(scanList,"raid"..i);
		end
	end

	found = false;
	for i,v in ipairs(scanList) do
		unitName = UnitName(v);
		if( unitName == name ) then
			table.insert(RAQ_queue, {
				unitid = v,
				name = unitName,
			});
			found = true;
		end
	end
	if( found ) then
		RAQ_NUM_SCAN = #RAQ_queue;
		RAQ_RunQueue();
	end
end

function RAQ_UpdateProgress()
	local header = getglobal("RAQFrameDataHeaderPlayer");
	if( #RAQ_queue > 0 ) then
		header:SetText(string.format("Scaning: %d/%d",(RAQ_NUM_SCAN-#RAQ_queue),RAQ_NUM_SCAN));
	else
		header:SetText("");
	end
end

function RAQ_SetStatus(unit, status)
	if( RAQ_DATA[unit] == nil ) then
		RAQ_DATA[unit] = {};
	end
	RAQ_DATA[unit]["_status"] = status;
	RAQ_DATA[unit]["_scanTime"] = time();
end

function RAQ_RunQueue()
	local nextID = next(RAQ_queue);

	RAQ_UpdateProgress();
	if( nextID ~= nil ) then
		if( SetAchievementComparisonUnit(RAQ_queue[nextID].unitid) ) then
			_unitID = RAQ_queue[nextID].unitid;
			_unitName = RAQ_queue[nextID].name;
			RAQ_SetTimer(RAQ_SCAN_TIMEOUT,
				function()
					ClearAchievementComparisonUnit();
					RAQ_SetStatus(_unitName,"TIMEOUT");
					RAQ_RunQueue();
				end);
		else
			RAQ_Error("Failed to SetAchievementComparisonUnit("..RAQ_queue[nextID]..").");
		end
		table.remove(RAQ_queue,nextID);
	else
		RAQ_KillTimer();
	end
	RAQ_UpdateUIList();
end

function RAQ_UpdateUIList()
	local j,texture,xoffset,yoffset,who,needed,data;
	sorted = {};

	for k,v in pairs(RAQ_DATA) do
		table.insert(sorted,k);
	end
	table.sort(sorted);

	data = RAQ_GetSelectedTable();
	if( data ~= nil ) then
		xoffset = (RAQ_CURRENT_PAGE-1) * RAQ_NUMBER_COLUMN;
		FauxScrollFrame_Update(RAQFrameScrollList,#sorted,RAQ_NUMBER_BUTTON,22);
		yoffset = FauxScrollFrame_GetOffset(RAQFrameScrollList);

		for k=1,RAQ_NUMBER_BUTTON do
			if( k+yoffset <= #sorted ) then
				who = sorted[k+yoffset];
				getglobal("RAQFrameDataLine"..k.."Player"):SetText(who);
				if( RAQ_DATA[who]["_status"] == "SUCCESS" ) then
					getglobal("RAQFrameDataLine"..k.."Status"):SetText("");
					for j=1,RAQ_NUMBER_COLUMN do
						j2 = j + xoffset;
						if( j2 <= #data ) then
							if( RAQ_DATA[who]["_data"][data[j2]] == true ) then
								texture = RAQ_TEXTURE["yes"];
							else
								texture = RAQ_TEXTURE["no"];
							end
							getglobal("RAQFrameDataLine"..k.."Column"..j):SetNormalTexture(texture);
							getglobal("RAQFrameDataLine"..k.."Column"..j):Show();
						else
							getglobal("RAQFrameDataLine"..k.."Column"..j):Hide();
						end
						j = j + 1;
					end

					-- Count needed
					needed = 0;
					for k2,v2 in pairs(data) do
						if( RAQ_DATA[who]["_data"][v2] == false ) then
							needed = needed + 1;
						end
					end
					getglobal("RAQFrameDataLine"..k.."Needed"):SetText(needed);
				else
					local status = getglobal("RAQFrameDataLine"..k.."Status");
					local width;

					if( #data > RAQ_NUMBER_COLUMN ) then
						width = RAQ_NUMBER_COLUMN * 22;
					else
						width = #data * 22;
					end
					status:SetWidth(width);
					status:SetText(RAQ_SCAN_FAILED);
					status:Show();
					for j=1,RAQ_NUMBER_COLUMN do
						getglobal("RAQFrameDataLine"..k.."Column"..j):Hide();
					end
					getglobal("RAQFrameDataLine"..k.."Needed"):SetText("");
				end
			else
				getglobal("RAQFrameDataLine"..k.."Player"):SetText("");
				getglobal("RAQFrameDataLine"..k.."Status"):SetText("");
				getglobal("RAQFrameDataLine"..k.."Needed"):SetText("");
				for j=1,RAQ_NUMBER_COLUMN do
					getglobal("RAQFrameDataLine"..k.."Column"..j):Hide();
				end
			end
		end

		-- Update needed column
		local column,needed;
		for j=1,RAQ_NUMBER_COLUMN do
			column = getglobal("RAQFrameDataNeededColumn"..j.."Caption");
			j2 = j + xoffset;
			if( data ~= nil and j2 <= #data ) then
				needed = 0;
				for k,v in pairs(RAQ_DATA) do
					if( v["_status"] == "SUCCESS" ) then
						if( v["_data"][data[j2]] ~= true ) then
							needed = needed + 1;
						end
					end
				end
				column:SetText(needed);
			else
				column:SetText("");
			end
		end
	end
end

function RAQ_ShowPlayerContextMenu(self)
	RAQPlayerContextMenu.owner = self:GetName();
	ToggleDropDownMenu(1, nil, RAQPlayerContextMenu, "cursor");
end

function RAQ_ShowHeaderContextMenu(self)
	RAQHeaderContextMenu.owner = self:GetName();
	ToggleDropDownMenu(1, nil, RAQHeaderContextMenu, "cursor");
end

function RAQ_OnLoad(self)
	local tempFrame,theFrame,tempPlayer;

	self:RegisterEvent("INSPECT_ACHIEVEMENT_READY");

	getglobal("RAQFrameTitleText"):SetText("RAQ version "..GetAddOnMetadata("RAQ", "Version"));

	RAQ_InitAchievements();

	tempFrame = getglobal("RAQFrameScanButton");
	tempFrame:SetScript("OnEnter", RAQ_UpdateButtonTooltip);
	tempFrame:SetScript("OnLeave", RAQ_HideTooltip);
	tempFrame:Disable();

	tempFrame = getglobal("RAQFrameResetButton");
	tempFrame:SetScript("OnEnter", RAQ_UpdateButtonTooltip);
	tempFrame:SetScript("OnLeave", RAQ_HideTooltip);
	tempFrame:Disable();

	-- Headers
	theFrame = CreateFrame("Button","RAQFrameDataHeader", RAQFrame, "RAQFrameDataLineTemplate");
	theFrame:SetPoint("TOPLEFT", "RAQFrame", "TOPLEFT", 15, -70 );
	-- Create columns
	for j=1,RAQ_NUMBER_COLUMN do
		tempFrame = CreateFrame("Button","RAQFrameDataHeaderColumn"..j, getglobal("RAQFrameDataHeader"), "RAQFrameDataButtonTemplate");
		getglobal(tempFrame:GetName().."Caption"):SetText("");

		if( j == 1 ) then
			tempFrame:SetPoint("TOPLEFT", "RAQFrameDataHeaderNeeded", "TOPRIGHT", 0, 0 );
		else
			tempFrame:SetPoint("TOPLEFT", "RAQFrameDataHeaderColumn"..(j-1), "TOPRIGHT", 2, 0 );
		end

		-- Add tooltips and click support to header buttons
		tempFrame:SetScript("OnEnter", RAQ_UpdateHeaderTooltip);
		tempFrame:SetScript("OnLeave", RAQ_HideTooltip);
		tempFrame:RegisterForClicks("RightButtonDown");
		tempFrame:SetScript("OnClick", function(self, button, down)
			if( button == "RightButton" ) then
				RAQ_ShowHeaderContextMenu(self);
			end
		end);
	end
	getglobal("RAQFrameDataHeaderPlayer"):SetText("");
	
	-- "Needed by" line below the header
	theFrame = CreateFrame("Button","RAQFrameDataNeeded", RAQFrame, "RAQFrameDataLineTemplate");
	theFrame:SetPoint("TOPLEFT", "RAQFrameDataHeader", "BOTTOMLEFT", 0, 0 );
	tempPlayer = getglobal("RAQFrameDataNeededPlayer");
	
	tempPlayer:SetText("Needed by ");
	tempPlayer:SetJustifyH("RIGHT");
	tempPlayer:Hide();
	tempPlayer:SetWidth(tempPlayer:GetWidth() + getglobal("RAQFrameDataNeededNeeded"):GetWidth());
	getglobal("RAQFrameDataNeededNeeded"):SetWidth(0);
	getglobal("RAQFrameDataNeededNeeded"):Hide();


	-- Create columns
	for j=1,RAQ_NUMBER_COLUMN do
		local tempFrame = CreateFrame("Button","RAQFrameDataNeededColumn"..j, getglobal("RAQFrameDataHeader"), "RAQFrameDataButtonTemplate");
		getglobal(tempFrame:GetName().."Caption"):SetText("");
		getglobal(tempFrame:GetName().."Caption"):SetJustifyH("CENTER");

		if( j == 1 ) then
			tempFrame:SetPoint("TOPLEFT", "RAQFrameDataNeededPlayer", "TOPRIGHT", 0, 0 );
		else
			tempFrame:SetPoint("TOPLEFT", "RAQFrameDataNeededColumn"..(j-1), "TOPRIGHT", 2, 0 );
		end
	end

	-- The actual buttons
	for i=1,RAQ_NUMBER_BUTTON do
		theFrame = CreateFrame("Button","RAQFrameDataLine"..i, RAQFrame, "RAQFrameDataLineTemplate");
		theFrame:RegisterForClicks("RightButtonDown");
		theFrame:SetScript("OnClick", function(self, button, down)
			if( button == "RightButton" ) then
				RAQ_ShowPlayerContextMenu(self);
			end
		end);

		if( i == 1 ) then
			theFrame:SetPoint("TOPLEFT", "RAQFrameDataNeeded", "BOTTOMLEFT", 0, 0 );
		else
			theFrame:SetPoint("TOPLEFT", "RAQFrameDataLine"..(i-1), "BOTTOMLEFT", 0, 0 );
		end

		getglobal("RAQFrameDataLine"..i.."Player"):SetText("");
		-- Create columns
		for j=1,RAQ_NUMBER_COLUMN do
			local tempFrame = CreateFrame("Button","RAQFrameDataLine"..i.."Column"..j, getglobal("RAQFrameDataLine"..i), "RAQFrameDataButtonTemplate");
			getglobal(tempFrame:GetName().."Caption"):SetText("");

			if( j == 1 ) then
				tempFrame:SetPoint("TOPLEFT", "RAQFrameDataLine"..i.."Needed", "TOPRIGHT", 0, 0 );
			else
				tempFrame:SetPoint("TOPLEFT", "RAQFrameDataLine"..i.."Column"..(j-1), "TOPRIGHT", 2, 0 );
			end
		end
	end

	-- Create a FauxScrollFrame and anchor it
	tempFrame = CreateFrame('ScrollFrame', 'RAQFrameScrollList', RAQFrame, 'FauxScrollFrameTemplate');
	tempFrame:SetPoint('TOPLEFT', "RAQFrameDataLine1", 0, 0);
	tempFrame:SetWidth((RAQ_NUMBER_COLUMN * 22) + 95); 
	tempFrame:SetHeight((RAQ_NUMBER_BUTTON-1) * 22);
	tempFrame:SetScript('OnShow', RAQ_UpdateUIList);
	tempFrame:SetScript('OnVerticalScroll', function(self, offset)
		FauxScrollFrame_OnVerticalScroll(self, offset, 22, RAQ_UpdateUIList);
	end)
	tempFrame:Show();

	-- Create drop down selection for achievement.
	RAQ_CreateMainDropDown();

	-- ..and player context menu
	RAQ_CreatePlayerContext();

	-- ..and header context menu
	RAQ_CreateHeaderContext();

	SLASH_RAQ1 = "/raq";
	SlashCmdList["RAQ"] = function(msg)
		RAQFrame:Show();
	end

	SLASH_RAQFAKE1 = "/raqfake";
	SlashCmdList["RAQFAKE"] = function(msg)
		RAQ_AddFakeUser(msg);
		RAQ_UpdateUIList();
	end

	self.TimeSinceLastUpdate = 0;
end

function RAQ_UpdateHandler(self, elapsed)
	if( _RAQ_Timer ~= nil and _RAQ_Timer.timeout ~= nil ) then
		self.TimeSinceLastUpdate = self.TimeSinceLastUpdate + elapsed;
		if( self.TimeSinceLastUpdate > RAQ_UPDATE_INTERVAL ) then
			self.TimeSinceLastUpdate = 0;
			_RAQ_Timer.timeout = _RAQ_Timer.timeout - 1;
			if( _RAQ_Timer.timeout == 0 ) then
				local callback = _RAQ_Timer.callback;
				RAQ_KillTimer();
				callback();
			end
		end
	end
end

function RAQ_EventHandler(event)
	if( event == "INSPECT_ACHIEVEMENT_READY" ) then
		-- Only trigger if we have a timer active, as this gets called for other stuff. Like "normal" achievement compares.
		if( _RAQ_Timer ~= nil ) then
			local k,v,i,needed,completed,month,day,year,completedOut;

			RAQ_KillTimer();

			RAQ_SetStatus(_unitName,"SUCCESS");
			RAQ_DATA[_unitName]["_data"] = {};
			i = 1;
			for k,v in pairs(RAQ_DB["_scan"]) do
				completed = select(1,GetAchievementComparisonInfo(k));

				-- For some reason this is needed
				if( completed == true ) then
					completedOut = true;
				else
					completedOut = false;
				end
				RAQ_DATA[_unitName]["_data"][k] = completedOut;
			end
			ClearAchievementComparisonUnit();
			RAQ_RunQueue();
		end
	end
end

function RAQ_StatusReport(self,isPlayer,target)
	local out = {};
	local targetTwo;
	local count = 0;

	if( isPlayer == nil ) then
		isPlayer = false;
	end

	if( string.find(target,"CHANNEL|(%d+)") ) then
		targetTwo = tonumber(select(3,string.find(target,"CHANNEL|(%d+)")));
		target = "CHANNEL";
	elseif( target == "WHISPER" ) then
		if( UnitName("target") == nil ) then
			RAQ_Error("No target selected.");
			return;
		end
		if( UnitIsPlayer("target") ~= 1 ) then
			RAQ_Error("Target is not a player.");
			return;
		end
		targetTwo = UnitName("target");
	end

	if( target == nil ) then
		RAQ_Error("You are not in a raid or party. Nothing to report to.");
		return;
	end

	out["incomplete"] = {};
	out["unknown"] = {};

	if( isPlayer ) then
		local playerName = self:GetText();
		local data = RAQ_GetSelectedTable();
		if( data ~= nil ) then
			local selectedAchievement = UIDropDownMenu_GetSelectedValue(RAQDropDown);
			local header = selectedAchievement[#selectedAchievement];
			
			if( RAQ_DATA[playerName]["_status"] == "SUCCESS" ) then
				for k,v in ipairs(data) do
					if( RAQ_DATA[playerName]["_data"][v] == false ) then
						name = select(2,GetAchievementInfo(v));
						table.insert(out["incomplete"],name);
					end
					count = count + 1;
				end
		
				local incomplete = table.concat(out["incomplete"],", ");
				local maxLength = 255;

				if( #out["incomplete"] == 0 ) then
					SendChatMessage(string.format("[RAQ] %s: %s has completed all.",header,playerName),target,nil,targetTwo);
				else
					local out = string.format("[RAQ] %s: %s needs %d of %d: %s",header,playerName,#out["incomplete"],count,incomplete);
					local temp = '';
					for word in out:gmatch("%S+") do
						if( string.len(temp..' '..word) >= maxLength ) then
							SendChatMessage(temp,target,nil,targetTwo);
							temp = '';
						end
						temp = temp .. word .. ' ';
					end
					if( temp ~= '' ) then
						SendChatMessage(temp,target,nil,targetTwo);
					end
				end
			else
				RAQ_Error(string.format("%s: Scan failed for %s. Rescan before reporting again.",header,playerName));
			end
		else
			RAQ_Error("Nothing selected.");
		end
	else
		for k,v in pairs(RAQ_DATA) do
			if( v ~= nil ) then
				if( v["_status"] == "SUCCESS" ) then
					if( v["_data"][self.achievementID] == false ) then
						table.insert(out["incomplete"],k);
					end
				else
					table.insert(out["unknown"],k);
				end
			end
			count = count + 1;
		end

		table.sort(out["incomplete"]);
		table.sort(out["unknown"]);

		local incomplete = table.concat(out["incomplete"],", ");
		local unknown = table.concat(out["unknown"],", ");

		if( incomplete == "" ) then incomplete = "No one"; end

		SendChatMessage("[RAQ] "..self.link..":",target,nil,targetTwo);
		SendChatMessage(string.format("Needed by (%d of %d): %s",#out["incomplete"],count-#out["unknown"],incomplete),target,nil,targetTwo);
		if( unknown ~= "" ) then
			SendChatMessage(string.format("Not scanned (%d): %s",#out["unknown"],unknown),target,nil,targetTwo);
		end
	end
end

function RAQ_HandleButton(self)
	local buttonID = self:GetID();

	if( buttonID == 1 ) then
		local scanMode = "refresh";
		-- Scan
		if( IsControlKeyDown() ) then
			scanMode = "force";
		end
		RAQ_StartScan(scanMode);
	elseif( buttonID == 2 ) then
		-- Clear data
		RAQ_DATA = {};
		RAQ_UpdateUIList();
	elseif( buttonID == 3 or buttonID == 4 ) then
		-- Prev/Next
		if( buttonID == 3 ) then
			RAQ_CURRENT_PAGE = RAQ_CURRENT_PAGE - 1;
		else
			RAQ_CURRENT_PAGE = RAQ_CURRENT_PAGE + 1;
		end
		RAQ_UpdateHeader();
		RAQ_UpdateUIList();
	else
		-- Unknown
		local buttonIDOut = buttonID;
		if( buttonIDOut == nil ) then
			buttonIDOut = "(nil)";
		end
		RAQ_Error("Unknown button, name is '"..self:GetName().."' id is '"..buttonIDOut.."'");
	end
end

function RAQ_GetSelectedTable()
	local temp = UIDropDownMenu_GetSelectedValue(RAQDropDown);

	if( type(temp) == "table" ) then
		if( #temp == 2 ) then
			-- Instance or meta
			
			-- Small hack to fix so you can click on a boss submenu and get to instance mode.
			-- eg "_boss / Blackwing Descent" leads to "_instance / Blackwing Descent"
			if( temp[1] == "_boss" ) then
				temp[1] = "_instance";
			end

			local t = {};
			for k,v in pairs(RAQ_DB[temp[1]][temp[2]]) do
				if( k ~= "_meta" ) then
					table.insert(t,k);
				end
			end
			return t;
		end
		if( #temp == 3 ) then
			-- Straight up boss, just return as it is.
			return RAQ_DB[temp[1]][temp[2]][temp[3]];
		end
		RAQ_Error("Unknown length of table ("..#temp..") in GetSelectedTable.");
		return nil;
	elseif( type(temp) == "string" ) then
		return nil;
	elseif( type(temp) ~= "nil" ) then
		RAQ_Error("Unknown type ("..type(temp)..") in GetSelectedTable.");
	end
end

function RAQ_HideAllDropDowns()
	local i,frame;
	-- Hides ALL the dropdown lists.
	-- FIXME: Investigate if this can be done properly, and not in this hackish way.
	i = 1;
	repeat
		frame = getglobal("DropDownList"..i);
		if( frame ~= nil ) then
			frame:Hide();
		end
		i = i + 1;
	until( frame == nil or i > 10 );
end

function RAQ_CreateMainDropDown()
	local temp = CreateFrame("Frame", "RAQDropDown", RAQFrame, "UIDropDownMenuTemplate");
	local t = {};

	temp:ClearAllPoints();
	temp:SetPoint("TOPLEFT", RAQFrame, "TOPLEFT", 0, -25);
	temp:Show();

	local function OnClick(self, arg1)
		RAQ_HideAllDropDowns();
		UIDropDownMenu_SetSelectedValue(RAQDropDown, self.value);
		
		-- Set the dropdown text to the last value, for looks only. :>
		if( type(self.value) == "table" ) then
			UIDropDownMenu_SetText(RAQDropDown, self.value[#self.value]);
		end

		RAQ_CURRENT_PAGE = 1;
		RAQ_UpdateHeader();
		RAQ_UpdateUIList();
	end

	local function initialize(self, level)
		t = {};
		level = level or 1;

		if( level == 1 ) then
			table.insert(t,{ name = "Boss mode", key = "_boss" });
			table.insert(t,{ name = "Instance mode", key = "_instance" });
			table.insert(t,{ name = "Meta mode", key = "_meta" });
			table.sort(t, function(a,b) return a.name < b.name end)

			local info = UIDropDownMenu_CreateInfo();
			for i,v in ipairs(t) do
				info = UIDropDownMenu_CreateInfo();
				info.func = OnClick;
				info.hasArrow = true;
				info.notCheckable = true;
				info.text = v.name;
				info.value = v.key;
				UIDropDownMenu_AddButton(info, level);
			end
		end
		
		-- Meta/instances/boss.
		if( level == 2 ) then
			t = {};
			for k,v in pairs(RAQ_DB[UIDROPDOWNMENU_MENU_VALUE]) do
				table.insert(t,k);
			end
			table.sort(t);

			local info = UIDropDownMenu_CreateInfo();
			for i,v in ipairs(t) do
				info = UIDropDownMenu_CreateInfo();
				info.func = OnClick;
				local temp = {};
				if( UIDROPDOWNMENU_MENU_VALUE == "_boss" ) then
					info.hasArrow = true;
					info.notCheckable = true;
				else
					info.hasArrow = false;
					info.notCheckable = true;
				end
				info.text = v;
				table.insert(temp,UIDROPDOWNMENU_MENU_VALUE);
				table.insert(temp,v);
				info.value = temp;
				UIDropDownMenu_AddButton(info, level);
			end
		end
		
		-- Bosses
		if( level == 3 ) then
			t = {};
			local instance = UIDROPDOWNMENU_MENU_VALUE[2];
			for k,v in pairs(RAQ_DB[UIDROPDOWNMENU_MENU_VALUE[1]][instance]) do
				table.insert(t,k);
			end
			table.sort(t);

			local info = UIDropDownMenu_CreateInfo();
			for i,v in ipairs(t) do
				info = UIDropDownMenu_CreateInfo();
				info.func = OnClick;
				info.hasArrow = false;
				info.notCheckable = true;
				info.text = v;
				local temp = {};
				table.insert(temp,UIDROPDOWNMENU_MENU_VALUE[1]);
				table.insert(temp,instance);
				table.insert(temp,v);
				info.value = temp;
				UIDropDownMenu_AddButton(info, level);
			end
		end
	end

	UIDropDownMenu_Initialize(RAQDropDown, initialize);
	UIDropDownMenu_SetWidth(RAQDropDown, 300);
	UIDropDownMenu_SetButtonWidth(RAQDropDown, 300);
	UIDropDownMenu_JustifyText(RAQDropDown, "LEFT");

end
	
function RAQ_BuildChannelList(...)
	local tbl = {};
	for i=1,select('#',...), 2 do
		local id,name = select(i,...);
		table.insert(tbl, { name = id..". "..name, key = "CHANNEL|"..id });
	end
	return tbl;
end

function RAQ_GetReportList()
	local tbl = {};
	
	table.insert(tbl,{ name = "Say", key = "SAY" });
	if( GetNumPartyMembers() > 0 ) then
		table.insert(tbl,{ name = "Party", key = "PARTY" });
	end
	if( GetNumRaidMembers() > 0 ) then
		table.insert(tbl,{ name = "Raid", key = "RAID" });
		table.insert(tbl,{ name = "Raid Warning", key = "RAID_WARNING" });
	end
	if( UnitInBattleground("player") ~= nil ) then
		table.insert(tbl,{ name = "Battleground", key = "BATTLEGROUND" });
	end

	table.insert(tbl,{ name = "Guild", key = "GUILD" });
	table.insert(tbl,{ name = "Officer", key = "OFFICER" });
	table.insert(tbl,{ name = "Whisper Target", key = "WHISPER" });
	for k,v in ipairs(RAQ_BuildChannelList(GetChannelList())) do
		table.insert(tbl,v);
	end
	return tbl;
end

function RAQ_CreateHeaderContext()
	local info = {};
	local temp = CreateFrame("Frame", "RAQHeaderContextMenu", RAQFrame, "UIDropDownMenuTemplate");
	temp.displayMode = "MENU";

	local function OnClick(self, arg1)
		RAQ_HideAllDropDowns();
		RAQ_StatusReport(getglobal(RAQHeaderContextMenu.owner),false,self.value);
	end

	local function initialize(self, level)
		level = level or 1;
		if( RAQHeaderContextMenu.owner ~= nil ) then
			if( level == 1 ) then
				wipe(info);

				info.isTitle = 1;
				info.notCheckable = 1;
				info.text = "Report to";
				UIDropDownMenu_AddButton(info, level);

				info.disabled = nil;
				info.isTitle = nil;
				local t = RAQ_GetReportList();
				local info = UIDropDownMenu_CreateInfo();
				for i,v in ipairs(t) do
					info = UIDropDownMenu_CreateInfo();
					info.notCheckable = 1;
					info.func = OnClick;
					info.text = v.name;
					info.value = v.key;
					UIDropDownMenu_AddButton(info, level);
				end

				info.text = CANCEL;
				info.func = RAQ_HideAllDropDowns;
				UIDropDownMenu_AddButton(info, level);
			end
		end
	end

	UIDropDownMenu_Initialize(RAQHeaderContextMenu, initialize);
end

function RAQ_CreatePlayerContext()
	local info = {};
	local temp = CreateFrame("Frame", "RAQPlayerContextMenu", RAQFrame, "UIDropDownMenuTemplate");
	temp.displayMode = "MENU";

	local function OnReportClick(self, arg1)
		RAQ_HideAllDropDowns();
		RAQ_StatusReport(getglobal(RAQPlayerContextMenu.owner.."Player"),true,self.value);
	end

	local function initialize(self, level)
		level = level or 1;
		if( RAQPlayerContextMenu.owner ~= nil ) then
			if( level == 1 ) then
				wipe(info);

				-- FIXME: These should be localized.
				info.isTitle = 1;
				info.notCheckable = 1;
				info.text = getglobal(RAQPlayerContextMenu.owner.."Player"):GetText();
				UIDropDownMenu_AddButton(info, level);

				info.disabled = nil;
				info.isTitle = nil;

				info.text = "Rescan";
				info.func = function()
					RAQ_RescanPlayer(getglobal(RAQPlayerContextMenu.owner.."Player"):GetText());
				end
				UIDropDownMenu_AddButton(info, level);

--				info.text = "[NYI] Add to ignore list";
--				info.func = nil;
--				UIDropDownMenu_AddButton(info, level);
			
				info.text = "Report";
				info.hasArrow = true;
				UIDropDownMenu_AddButton(info, level);
				info.hasArrow = false;

				info.text = CANCEL;
				info.func = RAQ_HideAllDropDowns;
				UIDropDownMenu_AddButton(info, level);
			end
		
			if( level == 2 ) then
				local t = RAQ_GetReportList();

				local info = UIDropDownMenu_CreateInfo();
				for i,v in ipairs(t) do
					info = UIDropDownMenu_CreateInfo();
					info.func = OnReportClick;
					info.notCheckable = 1;
					info.text = v.name;
					info.value = v.key;
					UIDropDownMenu_AddButton(info, level);
				end
			end
		end
	end

	UIDropDownMenu_Initialize(RAQPlayerContextMenu, initialize);
end

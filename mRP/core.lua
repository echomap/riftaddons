-- mRP is an UI addon for RIFT that aims to create a toolset to enable Roleplaying and creativity.
-- Including a set or profiles that can be chosen to show your current roleplaying status and character of the instant.
-- *Social tools to find other roleplayers.
-- *Scene preparation
-- *Text preparation and storage.
--
-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
local AddonData = Inspect.Addon.Detail("mRP")

local mRP = AddonData.data
mRP.UI = {}
mRP.UI.visibleNow = false;
mRP.data = {}
mRP.settings = {}
mRP.settings.ProfileNameMaxLen = 35;
mRP.settings.SessionNameMaxLen = 35;
mRP.settings.queryforTooltips = false

mRP.cache = {}
mRP.cache.actors = {}
mRP.RpStatus = { "OOC", "In Character", "Looking for RP" }

-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
--function mRP.SaveAndClose(notesText)
	--mRP.saveText(notesText)
	--mRP.toggleMainWindow()
--end
--function mRP.CancelAndClose(notesText)
	--mRP.saveText(notesText)
	--mRP.toggleMainWindow()
--end

local function AddonSavedVariablesLoadEnd(handle, identifier)
	if identifier == addon.identifier then
		Command.Event.Detach(Event.Addon.SavedVariables.Load.End, AddonSavedVariablesLoadEnd)
		print('XXXXXXX Notes v'..addon.toc.Version..' loaded')
		print('/mrp to toggle the notes window')
		init()
	end
end
-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
-- This function runs whenever the player gives the slash command we established at the bottom
local function SlashHandler(h, args)
	mRP.debugMsg ("SlashCmd Called","h:",dump(h), "args:",dump(args) );
	if mRP.debugMode then
		--mRP.toggleMainWindow();
	end
	if ( mRP.isempty(args) ) then
		print("Usage: /mrp <sendtest/info/inspect/profile/scene/current>")
		return;
	end
	if( string.starts(args, "info") ) then
		mRP.toggleInfoWindow(args);
		return;
	end
	if( string.starts(args, "profile") ) then
		mRP.toggleProfileWindow(args);
		return;
	end
	if( string.starts(args, "btn") ) then
		mRP.toggleBtnWindow(args);
		return;
	end
	if( string.starts(args, "search") ) then
		mRP.toggleSearchWindow(args);
		return;
	end

	if( string.starts(args, "sendtest") ) then
		mRP.debugMsg( "Sending test msg " );
		--Command.Message.Send(target, identifier, data, callback)   -- string, string, string, callbackfunction
		local playerOb = Inspect.Unit.Detail("player")
		local playerName = playerOb.name -- "Doecheri"
		Command.Message.Send( playerName, "mRP", "TestMsg123", mRP.sendMsgCallback );
		-- version "..toSend[2].." "..LibVersionCheckVersions[toSend[2]].myVersion, ignoreme)
	end

	if( string.starts(args, "hide") ) then
		--mRP.hideWindows();
	end
	if( string.starts(args, "inspect") ) then
		return;
	end

	if( string.starts(args, "scene") ) then
		return;
	end
	if( string.starts(args, "current") ) then
		return;
	end

	--mRP.debugMsg ("mRP: mRP.UI.visibleNow: " .. string.format("%s", mRP.UI.visibleNow) )
end
-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
-- This function runs whenever the Addon finished loading
-- question: called more than once??
local function loadSettings()
	if AddonID == AddonData.identifier then
		print ("mRP: loading settings")
		LibVersionCheck.register(AddonData.identifier, addon.toc.Version)
	end
end

local function MySavedVarsLoad_Handler(handle, AddonID)
	if AddonID == AddonData.identifier then
		print ("mRP: Addon Saved Variables Loaded");
		if(mRP.UI == nil ) then mRP.UI = {} end;
		--if(mRP.UI.ShowUIList == nil ) then mRP.UI.ShowUIList = {} end;

		--mRP.SetupMainWindow();
		mRP.showBtnWindow();
	end
end

local function SaveSettings(handle, AddonID)
	if AddonID == AddonData.identifier then
		print ("mRP: Saving Settings");
		--
		if(mRPSetup == nil) then
			mRPSetup = {}
		end
		if(mRPSetup.btn == nil) then
			mRPSetup.btn = {}
		end
		local btnL = mRP.UI.btn.Window:GetLeft();
		local btnT = mRP.UI.btn.Window:GetTop();
		mRPSetup.btn.left = btnL;
		mRPSetup.btn.top  = btnT;
		--
		if(mRPSetup.profile == nil) then
			mRPSetup.profile = {}
		end
		if(mRP.UI.profile ~= nil ) then
			local profileL = mRP.UI.profile.Window:GetLeft();
			local profileT = mRP.UI.profile.Window:GetTop();
			mRPSetup.profile.left = profileL;
			mRPSetup.profile.top  = profileT;
		end

		if(mRPSetup.sessions == nil) then
			mRPSetup.sessions = {}
		end
		if(mRP.UI.sessions ~= nil) then
			local btnL = mRP.UI.sessions.Window:GetLeft();
			local btnT = mRP.UI.sessions.Window:GetTop();
			mRPSetup.sessions.left = btnL;
			mRPSetup.sessions.top  = btnT;
		else
			mRP.UI.sessions = {}
		end

		if(mRPSetup.search == nil) then
			mRPSetup.search = {}
		end
		if(mRP.UI.search ~= nil) then
			local btnL = mRP.UI.search.Window:GetLeft();
			local btnT = mRP.UI.search.Window:GetTop();
			mRPSetup.search.left = btnL;
			mRPSetup.search.top  = btnT;
		else
			mRP.UI.search = {}
		end

	end
end
-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
local function ZoneChange()
	print ("mRP: ZoneChange called");
	if(mRP.UI.visibleNow) then
		dump(Inspect.Unit.Detail("player"))
		--locationName, zone= GUID
	end
end
-- ---------------------------------------------------------------------------------------------------------
Command.Message.Accept(nil, "mRP");

-- Set up a function to run after the Addon saves
Command.Event.Attach(Event.Addon.Load.End, loadSettings, "mRP Load Settings")
Command.Event.Attach(Command.Slash.Register("mrp"), SlashHandler, "Slash Command")

Command.Event.Attach(Event.Addon.SavedVariables.Load.End, MySavedVarsLoad_Handler, "Saved Vars Loading")
Command.Event.Attach(Event.Addon.SavedVariables.Save.Begin, SaveSettings, "Save Settings")
--Command.Event.Attach(Event.Addon.Shutdown.Begin, SaveSettings, "Save Settings")

Command.Event.Attach(Event.Unit.Detail.Zone, ZoneChange, "Unit Detail Zone")

--moved to comms
--Command.Event.Attach(Event.Message.Receive, 	    gotMessage,         "Event.Message.Receive")
--Command.Event.Attach(Event.System.Update.Begin,   systemUpdate,       "Event.System.Update.Begin")

--Command.Event.Attach( Event.Ability.New.Target,   userTargetChanged,  "Event.Ability.New.Target")

--Command.Event.Attach(Event.Quest.Accept, AcceptQuest, "Accept Quest")
--Command.Event.Attach(Event.Quest.Abandon, AbandonQuest, "Abandon Quest")
--Command.Event.Attach(Event.Quest.Complete, CompleteQuest, "Complete Quest")
--Command.Event.Attach(Event.Unit.Availability.Full, UnitAvailable, "Unit Available Full")
--table.insert (Command.Slash.Register("mRP"), {altSlashCommand, "mRP", "altSlashCommand"})
--table.insert (Event.Addon.Load.End, {loadSettings, "mRP", "loadSettings"})
-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
-- Welcome to the mRP Addon!
-- ---------------------------------------------------------------------------------------------------------
local AddonData = Inspect.Addon.Detail("mRP")

local mRP = AddonData.data
-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
-- Called when we get a message. This can be a query or a response.
-- Do not send all info immediately
-- Process one list entry every 1/10

mRP.sendToList        = {}
mRP.lastSendProcessed = 0

function mRP.sendMsgCallback(failure, mesg)
	mRP.debugMsg("msg send callback:","failure=",failure,"mesg=",mesg);
end

local function gotMessage(handle, from, type, channel, identifier, data)
	if identifier ~= AddonData.identifier then return end

	mRP.debugMsg(" got data: ''"  ..data.. "'' from ''" ..from.. "'' id: ''" ..identifier.. "'" );

	if( string.starts(data, "queryrp") ) then
		mRP.debugMsg( "Got Query from "..from );
		local kasf = {}
		kasf.from   = from
		kasf.action = "queryrp"
		kasf.msg    = data
		table.insert(mRP.sendToList, { from, kasf })
	end

	if( string.starts(data, "queryinfo") ) then
		mRP.debugMsg( "Got Query from "..from );
		local kasf = {}
		kasf.from   = from
		kasf.action = "queryinfo"
		kasf.msg    = data
		table.insert(mRP.sendToList, { from, kasf })
	end

	if( string.starts(data, "rpstatus") ) then
		mRP.debugMsg( "Got RPstatus from "..from );
		local idx = 1;
		local words = {}
		for w in data:gmatch("%S+") do
			words[idx] = w
			idx = idx+1;
		end
		local val = words[2];
		--if( val ~= nil) then
		if(mRP.cache == nil) then
			mRP.cache = {}
		end
		if(mRP.cache.actors == nil) then
			mRP.cache.actors = {}
		end
		mRP.cache.actors[from] = {}
		mRP.cache.actors[from].rpstatus = val;
	end

	--[[
		--if not LibVersionCheckSettings.developer then
			for k, v in pairs(LibVersionCheckVersions) do
				if v.myVersion and v.myVersion ~= 0 and v.myVersion ~= "0" then
					table.insert(sendToList, { from, k })
				end
			end
	end
	--]]

	--if data:len()>=7 and data:sub(1,7) == "version" then
	--	mRP.debugMsg("got version info: ", data.," from ",from);
	--end
end

local function ignoreme()
end

-- Send information to everyone who has requested it.
local function systemUpdate(handle)
	--if #sendToList<1 then return end
	if#mRP.sendToList<1 then return end

	local now=Inspect.Time.Real()
	if now < mRP.lastSendProcessed+0.1 then return end
	mRP.lastSendProcessed=now

	local toSend=mRP.sendToList[1]
	table.remove(mRP.sendToList, 1);
	local toUser = toSend[1]
	local kasdfd = toSend[2]
	mRP.debugMsg("Sending reply to user", toUser );

	--TODO include 'inscene' 'lf RP' etc...
	if(kasdfd.action=="queryrp") then
		--Command.Message.Send(target, identifier, data, callback)
		local rval =  -1
		if( mRP.UI ~= nil and mRP.UI.profile ~= nil and mRP.UI.profile.general ~= nil) then
				--(inchar/ooc/looking for rp)
				rval = mRP.UI.profile.general.radioButtonGroup:GetSelectedIndex();
		else
			if( mRPStorageC.characterStatus ~= nil ) then
				rval = mRPStorageC.characterStatus
			end
		end
		Command.Message.Send( toUser, "mRP", "rpstatus "..rval, mRP.sendMsgCallback);
	end

	if(kasdfd.action=="queryinfo") then
		mRP.debugMsg("Sending Info to " .. toUser);
		local rval = "" ;
		local pName = nil;
		if( mRP.UI ~= nil and mRP.UI.profile ~= nil and mRP.UI.profile.general ~= nil) then
				local curr = mRP.UI.profile.general.SelectProfileCP:GetSelectedIndex();
				if( mRPStorageC.currentProfileName ~= nil ) then
					pName = mRPStorageC.currentProfileName;
					--currentProfileIndex
				end
		else
			if( mRPStorageC.currentProfileName ~= nil ) then
				pName = mRPStorageC.currentProfileName
			end
		end
		mRP.debugMsg("Got ProfileName as ",pName);
		local pVal = mRP.retrieveSelectedProfileByName(pName)
		rval = pVal;

		Command.Message.Send( toUser, "mRP", "rpinfo "..rval, mRP.sendMsgCallback);
	end
	--
end
-- ---------------------------------------------------------------------------------------------------------
-- Commands
-- ---------------------------------------------------------------------------------------------------------
--Signals the receipt of an addon message.
Command.Event.Attach(Event.Message.Receive, 	    gotMessage,         "Event.Message.Receive")
--Signals the beginning of a frame render. This is your last chance to make UI changes for this frame.
Command.Event.Attach(Event.System.Update.Begin,   systemUpdate,       "Event.System.Update.Begin")
-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------

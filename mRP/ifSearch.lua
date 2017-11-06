-- ---------------------------------------------------------------------------------------------------------
-- Welcome to the mRP Addon!
-- ---------------------------------------------------------------------------------------------------------
local AddonData = Inspect.Addon.Detail("mRP")

local mRP = AddonData.data
-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
function mRP.showSearchWindow(args)
	mRP.debugMsg ( "showSearchWindow called" );
	if( mRP.UI.search == nil) then
		mRP.createSearchWindow();
	end
	mRP.UI.search.Window:SetVisible(true )
	mRP.debugMsg ("showSearchWindow done");
	if( mRP.UI.search.Window:GetVisible() == true ) then
		mRP.populateSearchWindow(args);
	end
end

-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
function mRP.searchMsgCallback(failure, mesg)
	mRP.debugMsg("search msg callback:","failure=",failure,"mesg=",mesg);
end

function mRP.updateSearchScreen()
		--update list from mRP.cache.actors
	mRP.debugMsg("mRP.cache.actors->");
	local items = {}
	local itemIDVals = {  }
	local userData = {  }
	for k, v in pairs(mRP.cache.actors) do
		mRP.debugMsg( "k", k, "v", dump(v) );

		table.insert(userData, v.rpstatus)
		--table.insert(itemIDVals, v.id)
	 	table.insert(items, k )
	end
	mRP.UI.search.userlist:SetItems(items, userData) --itemIDVals)
	mRP.debugMsg("<-mRP.cache.actors.");
end

function mRP.doQueryRP(toUser)
	--send "queryinfo" msg
	Command.Message.Send( toUser, "mRP", "queryrp "..toUser, mRP.sendMsgCallback);
end

function mRP.doSearchFillDetails(item)
	local lUser = mRP.UI.search.userlist:GetSelectedItem()
	mRP.debugMsg("lUser:", lUser)
	--local toUser = lUser.id
	--mRP.debugMsg("toUser:", toUser)
	--mRP.doQueryRP(lUser);
	mRP.UI.search.search.LabelTX2:SetText( lUser );
	local rpstat1 = mRP.cache.actors[lUser].rpstatus;
	mRP.debugMsg("rpstat1:", rpstat1)
	if(rpstat1 == nil ) then
		rpstat1 = "Unknown";
		mRP.UI.search.search.LabelTX3:SetText( rpstat1 );
	else
		-- "OOC" "In Character" "Looking for RP"
		mRP.debugMsg( "rpstat1: '"..rpstat1.."'");
		local a = tonumber(rpstat1)
		mRP.debugMsg( "rpstat1: '"..a.."'");
		local rpstat1V = mRP.RpStatus[a];
		--for k, v in pairs(mRP.RpStatus) do
		--	mRP.debugMsg( "mRP.RpStatus:", k, v )
		--end
		--mRP.debugMsg( "rpstat1V1: '"..rpstat1V.."'");
		if(rpstat1V == nil ) then
			mRP.UI.search.search.LabelTX3:SetText( rpstat1 );
		else
			mRP.UI.search.search.LabelTX3:SetText( rpstat1V );
		end
	end

end

function mRP.clearSearchView()
	mRP.UI.search.search.LabelTX2:SetText( "" );
	mRP.UI.search.search.LabelTX3:SetText( "" );
	mRP.UI.search.userlist:ClearSelection();
	-- populate: list section
	local items = {}
	--table.insert(items, "<None>")
	--local itemVals = { {} }
	local itemVals = {  }
	table.insert(itemVals, nil)
	mRP.UI.search.userlist:SetItems(items, itemVals)

end

function mRP.doSearchRP()

	-- populate list section

	 --[[

	-- 1) Using nearby units
	local donl = false -- set to false cause this might work, but 'nearby units' is weird.
	if(donl) then
		local items = {}
		local itemIDVals = {  }
		local userData = {  }

		local nearbyList = Inspect.Unit.List() -- Map of unit ID to unit specifier
		if(nearbyList ~= nil ) then
			mRP.debugMsg("nearbyList: ", dump(nearbyList) );
			for k, v in pairs(nearbyList) do
				mRP.debugMsg( k, v )
			end
			mRP.debugMsg("<--");
		else
			mRP.debugMsg("nearbyList: is  nil")
		end

		for k,v in pairs(nearbyList) do
			mRP.debugMsg("nearbyList: k: " ..k.. " v: "..v)
			local details = Inspect.Unit.Detail(k);
			local lname = nil;
			if(details ~= nil ) then lname = details.name end;
			mRP.debugMsg("nearbyList: lname: " ..lname )
			if(lname ~= nil ) then
				local lUserData = { details.id, details.name }
				mRP.debugMsg("lUserData: ", dump(lUserData) )
				for k, v in pairs(lUserData) do
					mRP.debugMsg( k, v )
				end
				table.insert(userData, lUserData)
				table.insert(itemIDVals, details.id)
			 	table.insert(items, lname)
			end;
			--table.insert(items, "Item "..k.. " "..v)
		end
		--for i=1,5 do
		--	table.insert(items, "Item "..i)
		--end
		mRP.UI.search.userlist:SetItems(items, itemIDVals) --itemIDVals)
	end

	 --]]
	-- 2) Using broadcast message
	mRP.debugMsg("Sending Broadcast message to mRP Channel");
	--type, target, identifier, data, callback)
	Command.Message.Broadcast( "channel", "mRP", "mRP", "queryrp", mRP.searchMsgCallback );
	-- version "..toSend[2].." "..LibVersionCheckVersions[toSend[2]].myVersion, ignoreme)
end

-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
function mRP.populateSearchWindow(args)

end

function mRP.createSearchWindow()
	mRP.UI.search = {}

	if( mRP.UI.Context == nil) then
		mRP.UI.Context     = UI.CreateContext(AddonData.identifier)
	end

	mRP.UI.search.Window  = UI.CreateFrame("SimpleWindow", "mRPMainSearchWindow", mRP.UI.Context )
	mRP.UI.search.Window:SetCloseButtonVisible(true)
	mRP.UI.search.Window:SetTitle("Main Search Data")
	mRP.UI.search.Window:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 100, 200)
	mRP.UI.search.Window:SetWidth(450)
	mRP.UI.search.Window:SetHeight(350)
	mRP.UI.search.Window:SetVisible(false)


	local WLeft = 100;
	local WTop = 200;
	if( mRPSetup~= nil and mRPSetup.search ~= nil ) then
		if( mRPSetup.search.left ~= nil and mRPSetup.search.left > 0 ) then
			WLeft = mRPSetup.search.left;
		end
        if( mRPSetup.search.top ~= nil and mRPSetup.search.top > 0 ) then
            WTop = mRPSetup.search.top;
        end
	end
	mRP.UI.search.Window:SetPoint("TOPLEFT", UIParent, "TOPLEFT", WLeft, WTop)


	mRP.UI.search.Tabbed  = UI.CreateFrame("SimpleTabView", "mRPTabbedSearchWindow", mRP.UI.search.Window )
	mRP.UI.search.Tabbed:SetPoint("TOPLEFT", mRP.UI.search.Window:GetContent() , "BOTTOMLEFT")
	mRP.UI.search.Tabbed:SetWidth( mRP.UI.search.Window:GetContent():GetWidth() *0.80 )
	--mRP.UI.search.Tabbed:SetHeight(mRP.UI.search.Window:GetContent():GetHeight()*0.80)
	--mRP.UI.search.Tabbed:SetTabContentBackgroundColor(255, 255, 255, 0)

	--
	local tabWindowParent = nil;
	local screenParent1   = nil;
	local screenParent2   = nil;
	local divider         = 10 ;
	--local widthRem = tabWindowParent:GetWidth() - mRP.UI.search.listScrollView:GetWidth() - 20
	--

	-- TAB -- GENERAL Search
	mRP.UI.search.search = {}
	mRP.UI.search.search.WindowO = UI.CreateFrame("SimpleWindow", "mRPSearch "..AddonData.toc.Version, mRP.UI.search.Tabbed.tabContent)
	mRP.UI.search.search.Window  = UI.CreateFrame("Frame", "mRPSearchWindow",  mRP.UI.search.search.WindowO );
	mRP.UI.search.search.Window:SetPoint("TOPLEFT", mRP.UI.search.Window:GetContent(), "TOPLEFT")
	mRP.UI.search.search.Window:SetWidth( mRP.UI.search.Window:GetContent():GetWidth() )
	mRP.UI.search.search.Window:SetHeight(mRP.UI.search.Window:GetContent():GetHeight())
	mRP.UI.search.search.Window:SetBackgroundColor(255, 255, 124, 0.4)
	tabWindowParent = mRP.UI.search.search.Window


	-- Screen - 1 General Search
	mRP.UI.search.search.Screen1 = UI.CreateFrame("Frame", "mRPScreenSearch1", tabWindowParent  )
	mRP.UI.search.search.Screen1:SetPoint("TOPLEFT", tabWindowParent, "TOPLEFT", 0, 0)
	mRP.UI.search.search.Screen1:SetWidth( 200 )
	mRP.UI.search.search.Screen1:SetHeight(tabWindowParent:GetHeight()*0.80)
	mRP.UI.search.search.Screen1:SetBackgroundColor(255, 255, 255, 0.2)
	screenParent1 = mRP.UI.search.search.Screen1

	-- Screen - 2 Character Details
	mRP.UI.search.search.Screen2  = UI.CreateFrame("Frame", "mRPScreenSearch2", tabWindowParent  )
	mRP.UI.search.search.Screen2:SetPoint("TOPLEFT", mRP.UI.search.search.Screen1 , "TOPRIGHT", 10, 0)
	mRP.UI.search.search.Screen2:SetPoint("BOTTOMRIGHT", tabWindowParent , "BOTTOMRIGHT", 0, 0)
	mRP.UI.search.search.Screen2:SetBackgroundColor(255, 255, 255, 0.2)
	screenParent2 = mRP.UI.search.search.Screen2
	screenParent1:SetHeight(screenParent2:GetHeight())

	-- Screen Data - 1 General Search
	-- Main Search List
	mRP.UI.search.search.newSearchButton = UI.CreateFrame("RiftButton", "NPButton", screenParent1)
	mRP.UI.search.search.newSearchButton:SetText("New Search")
	mRP.UI.search.search.newSearchButton:SetPoint("TOPLEFT", screenParent1, "TOPLEFT")
	mRP.UI.search.search.newSearchButton:SetWidth(100)
	function mRP.UI.search.search.newSearchButton.Event:LeftPress()
	    mRP.debugMsg("BUTTON Search PRESSED")
		mRP.clearSearchView();
		mRP.doSearchRP();
	end

	mRP.UI.search.listScrollView = UI.CreateFrame("SimpleScrollView", "SWT_TestScrollView", screenParent1 )
	mRP.UI.search.listScrollView:SetPoint("TOPLEFT", mRP.UI.search.search.newSearchButton, "BOTTOMLEFT", 0, 20)
	mRP.UI.search.listScrollView:SetWidth( screenParent1:GetWidth() - divider );
	mRP.UI.search.listScrollView:SetHeight(100 )
	mRP.UI.search.listScrollView:SetBorder(1, 1, 1, 1, 1)
	--mRP.UI.search.listScrollView:SetMargin(1)
	--mRP.UI.search.listScrollView:SetBackgroundColor(255, 255, 255, 0.2)
	mRP.UI.search.listScrollView:SetBackgroundColor(255, 255, 100, 0.2)

	mRP.UI.search.userlist = UI.CreateFrame("SimpleList", "SWT_TestList1", mRP.UI.search.listScrollView )
	mRP.UI.search.userlist.Event.ItemSelect = function(view, item)
		print("ItemSelect("..item..")")
		-- TODO details
		mRP.doSearchFillDetails(item);
	end
	mRP.UI.search.listScrollView:SetContent( mRP.UI.search.userlist )

	-- populate: list section
	local items = {}
	--table.insert(items, "<None>")
	--local itemVals = { {} }
	local itemVals = {  }
	table.insert(itemVals, nil)
	mRP.UI.search.userlist:SetItems(items, itemVals)

	--
	mRP.UI.search.search.queryInfoButton = UI.CreateFrame("RiftButton", "NPButton", screenParent1)
	mRP.UI.search.search.queryInfoButton:SetText("Query")
	mRP.UI.search.search.queryInfoButton:SetPoint("TOPLEFT", mRP.UI.search.search.newSearchButton, "TOPRIGHT", divider, 0)
	mRP.UI.search.search.queryInfoButton:SetWidth(90)
	function mRP.UI.search.search.queryInfoButton.Event:LeftPress()
	    mRP.debugMsg("BUTTON Query PRESSED")
		local lUser = mRP.UI.search.userlist:GetSelectedItem()
		mRP.debugMsg("lUser:", lUser)
		--local toUser = lUser.id
		--mRP.debugMsg("toUser:", toUser)
		mRP.doQueryRP(lUser);
	end

	-- Screen Data - 2 Character Details
	mRP.UI.search.search.LabelCD1 = UI.CreateFrame("Text", "LabelCD", screenParent2 )
	mRP.UI.search.search.LabelCD1:SetPoint("TOPLEFT", screenParent2, "TOPLEFT", 0, 0)
	--mRP.UI.search.search.LabelCD1:SetWidth(  50 )
	mRP.UI.search.search.LabelCD1:SetHeight( 20 )
	mRP.UI.search.search.LabelCD1:SetBackgroundColor(255, 255, 124, 0.4)
	mRP.UI.search.search.LabelCD1:SetText("Selected Character Data:");
	--widthRem = widthRem- mRP.UI.search.search.LabelCD:GetWidth();
	local myLabel = mRP.UI.search.search.LabelCD1

	mRP.UI.search.search.LabelCD2 = UI.CreateFrame("Text", "LabelCD2", screenParent2 )
	mRP.UI.search.search.LabelCD2:SetPoint("TOPLEFT", myLabel, "BOTTOMLEFT", 0, 0)
	mRP.UI.search.search.LabelCD2:SetWidth(  50 )
	mRP.UI.search.search.LabelCD2:SetHeight( 20 )
	mRP.UI.search.search.LabelCD2:SetBackgroundColor(0, 153, 153, 0.3)
	mRP.UI.search.search.LabelCD2:SetText("Name:");
	myLabel = mRP.UI.search.search.LabelCD2

	mRP.UI.search.search.LabelTX2 = UI.CreateFrame("RiftTextfield", "NPText2", screenParent2 )
	mRP.UI.search.search.LabelTX2:SetPoint("TOPLEFT", myLabel, "TOPRIGHT", divider, 0 )
	mRP.UI.search.search.LabelTX2:SetWidth( 100 )
	mRP.UI.search.search.LabelTX2:SetHeight(20)
	mRP.UI.search.search.LabelTX2:SetBackgroundColor(255, 255, 255, 0.3)
	mRP.UI.search.search.LabelTX2:SetText( "ASDF1ASDF2ASDF3" );

	mRP.UI.search.search.LabelCD3 = UI.CreateFrame("Text", "LabelCD3", screenParent2 )
	mRP.UI.search.search.LabelCD3:SetPoint("TOPLEFT", myLabel, "BOTTOMLEFT", 0, 0)
	mRP.UI.search.search.LabelCD3:SetWidth(  50 )
	mRP.UI.search.search.LabelCD3:SetHeight( 20 )
	mRP.UI.search.search.LabelCD3:SetBackgroundColor(0, 153, 153, 0.3)
	mRP.UI.search.search.LabelCD3:SetText("RP:");
	myLabel = mRP.UI.search.search.LabelCD3

	mRP.UI.search.search.LabelTX3 = UI.CreateFrame("RiftTextfield", "NPText3", screenParent2 )
	mRP.UI.search.search.LabelTX3:SetPoint("TOPLEFT", myLabel, "TOPRIGHT", divider, 0 )
	mRP.UI.search.search.LabelTX3:SetWidth( 100 )
	mRP.UI.search.search.LabelTX3:SetHeight(20)
	mRP.UI.search.search.LabelTX3:SetBackgroundColor(255, 255, 255, 0.3)
	mRP.UI.search.search.LabelTX3:SetText( "ASDF1ASDF2ASDF3" );


	-- TAB END -- GENERAL Search

	--
	-- TABS --
	mRP.UI.search.Tabbed:SetTabPosition("bottom")
	mRP.UI.search.Tabbed:AddTab("Search", mRP.UI.search.search.WindowO )
	--mRP.UI.search.Tabbed:AddTab("Public",  mRP.UI.search.public.WindowO  )
	--mRP.UI.search.Tabbed:AddTab("Private", mRP.UI.search.private.WindowO )

    mRP.UI.search.loaded = true;
end

function mRP.toggleSearchWindow(args)
	if( mRP.UI.search == nil) then
		mRP.createSearchWindow();
	end
	mRP.UI.search.Window:SetVisible(not mRP.UI.search.Window:GetVisible() )
	if( mRP.UI.search.Window:GetVisible() == true ) then
		mRP.populateSearchWindow(args);
	end
end

-- ---------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------

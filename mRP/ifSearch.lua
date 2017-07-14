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

function mRP.doQueryRP(toUser)
	--send "queryinfo" msg
	Command.Message.Send( toUser, "mRP", "queryrp "..toUser, mRP.sendMsgCallback);
end

function mRP.doSearchRP()

	-- populate list section

	-- 1) Using nearby units
	local items = {}
    local itemIDVals = {  }

	local nearbyList = Inspect.Unit.List() -- Map of unit ID to unit specifier
	if(nearbyList ~= nil ) then
		mRP.debugMsg("nearbyList: ", dump(nearbyList) );
		mRP.debugMsg("<--");
	else
		mRP.debugMsg("nearbyList: is  nil")
	end
	local donl = false
	if(donl) then
		for k,v in pairs(nearbyList) do
			mRP.debugMsg("nearbyList: k: " ..k.. " v: "..v)
			local details = Inspect.Unit.Detail(k);
			local lname = nil;
			if(details ~= nil ) then lname = details.name end;
			mRP.debugMsg("nearbyList: lname: " ..lname )
			if(lname ~= nil ) then
				table.insert(itemIDVals, details.id)
			 	table.insert(items, lname)
			end;
			--table.insert(items, "Item "..k.. " "..v)
		end
		--for i=1,5 do
		--	table.insert(items, "Item "..i)
		--end
		mRP.UI.search.list:SetItems(items, itemIDVals)
	end

	-- 2) Using broadcast message
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
	mRP.UI.search.Window:SetWidth(400)
	mRP.UI.search.Window:SetHeight(350)
    mRP.UI.search.Window:SetVisible(false)

	mRP.UI.search.Tabbed  = UI.CreateFrame("SimpleTabView", "mRPTabbedSearchWindow", mRP.UI.search.Window )
    mRP.UI.search.Tabbed:SetPoint("TOPLEFT", mRP.UI.search.Window:GetContent() , "BOTTOMLEFT")
	mRP.UI.search.Tabbed:SetWidth( mRP.UI.search.Window:GetContent():GetWidth()*0.80 )
	mRP.UI.search.Tabbed:SetTabContentBackgroundColor(255, 255, 255, 0)

    -- details
	local rightParent = nil;

	-- TAB -- GENERAL
	mRP.UI.search.search = {}
	mRP.UI.search.search.WindowO = UI.CreateFrame("SimpleWindow", "mRPSearch", mRP.UI.search.Tabbed.tabContent)
	mRP.UI.search.search.Window  = UI.CreateFrame("Frame", "mRPSearchWindow", mRP.UI.search.search.WindowO );
	mRP.UI.search.search.Window:SetPoint("TOPLEFT", mRP.UI.search.Window:GetContent(), "TOPLEFT")
	mRP.UI.search.search.Window:SetWidth(mRP.UI.search.Window:GetWidth())
	mRP.UI.search.search.Window:SetHeight(mRP.UI.search.Window:GetHeight())
	rightParent = mRP.UI.search.search.Window

	--
	mRP.UI.search.search.newSearchButton = UI.CreateFrame("RiftButton", "NPButton", rightParent)
	mRP.UI.search.search.newSearchButton:SetText("New Search")
	mRP.UI.search.search.newSearchButton:SetPoint("TOPLEFT", rightParent, "TOPLEFT")
	mRP.UI.search.search.newSearchButton:SetWidth(100)
	function mRP.UI.search.search.newSearchButton.Event:LeftPress()
	    mRP.debugMsg("BUTTON Search PRESSED")
		mRP.doSearchRP();
	end

    mRP.UI.search.listScrollView = UI.CreateFrame("SimpleScrollView", "SWT_TestScrollView", rightParent )
    mRP.UI.search.listScrollView:SetPoint("TOPLEFT", mRP.UI.search.search.newSearchButton, "BOTTOMLEFT", 0, 20)
    mRP.UI.search.listScrollView:SetWidth(200) -- rightParent:GetContent():GetWidth() * 0.40 );--100)
    mRP.UI.search.listScrollView:SetHeight(100)
    mRP.UI.search.listScrollView:SetBorder(1, 1, 1, 1, 1)
    --mRP.UI.search.listScrollView:SetMargin(1)
	--mRP.UI.search.listScrollView:SetBackgroundColor(255, 255, 255, 0.2)
	mRP.UI.search.listScrollView:SetBackgroundColor(255, 255, 100, 0.2)

    mRP.UI.search.list = UI.CreateFrame("SimpleList", "SWT_TestList1", mRP.UI.search.listScrollView )
    --mRP.UI.search.list.Event.ItemSelect = function(view, item) print("ItemSelect("..item..")") end
	--mRP.UI.search.list.Event:SelectionChange()
	--    mRP.debugMsg("BUTTON list item PRESSED")
	--end
	mRP.UI.search.listScrollView:SetContent( mRP.UI.search.list )

	-- populate list section
	local items = {}
    --table.insert(items, "<None>")
    --local itemVals = { {} }
    local itemVals = {  }
	table.insert(itemVals, nil)
    mRP.UI.search.list:SetItems(items, itemVals)

	--
	mRP.UI.search.search.queryInfoButton = UI.CreateFrame("RiftButton", "NPButton", rightParent)
	mRP.UI.search.search.queryInfoButton:SetText("Query")
	mRP.UI.search.search.queryInfoButton:SetPoint("TOPLEFT", mRP.UI.search.listScrollView, "CENTERRIGHT", 20, 0)
	mRP.UI.search.search.queryInfoButton:SetWidth(100)
	function mRP.UI.search.search.queryInfoButton.Event:LeftPress()
	    mRP.debugMsg("BUTTON Query PRESSED")
		local toUser = mRP.UI.search.list:GetSelectedItem()
		mRP.doQueryRP(toUser);
	end



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

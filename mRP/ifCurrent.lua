-- Welcome to the mRP Addon!
--
-- ---------------------------------------------------------------------------------------------------------
-- https://rift.curseforge.com/addons/libsimplewidgets/pages/api-documentation/
-- ---------------------------------------------------------------------------------------------------------
local AddonData = Inspect.Addon.Detail("mRP")

local mRP = AddonData.data

-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
function mRP.showCurrentWindow(args)
	mRP.debugMsg ( "showCurrentWindow called" );
	if( mRP.UI.current == nil) then
		mRP.createCurrentWindow();
	end
	mRP.UI.current.Window:SetVisible(true )
	mRP.debugMsg ("showCurrentWindow done");
	if( mRP.UI.current.Window:GetVisible() == true ) then
		mRP.populateCurrentWindow(args);
	end
end

-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
function mRP.populateCurrentWindow(args)

end

function mRP.createCurrentWindow()
    mRP.UI.current = {}

	if( mRP.UI.Context == nil) then
		mRP.UI.Context = UI.CreateContext(AddonData.identifier)
	end


    mRP.UI.current.Window  = UI.CreateFrame("SimpleWindow", "MainMRPDataWindow", mRP.UI.Context )

    mRP.UI.current.Window:SetCloseButtonVisible(true)
    mRP.UI.current.Window:SetTitle("User Data")
    mRP.UI.current.Window:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 100, 200)
	mRP.UI.current.Window:SetWidth(500)
    mRP.UI.current.Window:SetVisible(false)

    -- details

    mRP.UI.current.loaded = true;
end


function mRP.toggleCurrentWindow(args)
	if( mRP.UI.current == nil) then
		mRP.createCurrentWindow();
	end
	mRP.UI.current.Window:SetVisible(not mRP.UI.current.Window:GetVisible() )
	if( mRP.UI.current.Window:GetVisible() == true ) then
		mRP.populateCurrentWindow(args);
	end
end

-- ---------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------

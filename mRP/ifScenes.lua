-- ---------------------------------------------------------------------------------------------------------
-- Welcome to the mRP Addon!
-- ---------------------------------------------------------------------------------------------------------
local AddonData = Inspect.Addon.Detail("mRP")

local mRP = AddonData.data
-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
function mRP.showScenesWindow(args)
	mRP.debugMsg ( "showScenesWindow called" );
	if( mRP.UI.scenes == nil) then
		mRP.createScenesWindow();
	end
	mRP.UI.scenes.Window:SetVisible(true )
	mRP.debugMsg ("showScenesWindow done");
	if( mRP.UI.scenes.Window:GetVisible() == true ) then
		mRP.populateScenesWindow(args);
	end
end

-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
function mRP.populateScenesWindow(args)

end

function mRP.createScenesWindow()
    mRP.UI.scenes = {}

	if( mRP.UI.Context == nil) then
		mRP.UI.Context     = UI.CreateContext(AddonData.identifier)
	end

    mRP.UI.scenes.Window  = UI.CreateFrame("SimpleWindow", "MainMRPDataWindow", mRP.UI.Context )

    mRP.UI.scenes.Window:SetCloseButtonVisible(true)
    mRP.UI.scenes.Window:SetTitle("User Data")
    mRP.UI.scenes.Window:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 100, 200)
	mRP.UI.scenes.Window:SetWidth(500)
    mRP.UI.scenes.Window:SetVisible(false)

    -- details

    mRP.UI.scenes.loaded = true;
end

function mRP.toggleScenesWindow(args)
	if( mRP.UI.scenes == nil) then
		mRP.createScenesWindow();
	end
	mRP.UI.scenes.Window:SetVisible(not mRP.UI.scenes.Window:GetVisible() )
	if( mRP.UI.scenes.Window:GetVisible() == true ) then
		mRP.populateScenesWindow(args);
	end
end

-- ---------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------

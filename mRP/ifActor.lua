-- ---------------------------------------------------------------------------------------------------------
-- Welcome to the mRP Addon!
-- ---------------------------------------------------------------------------------------------------------
local AddonData = Inspect.Addon.Detail("mRP")

local mRP = AddonData.data
-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
function mRP.showActorWindow(args)
	mRP.debugMsg ( "showActorWindow called" );
	if( mRP.UI.actor == nil) then
		mRP.createActorWindow();
	end
	mRP.UI.actor.Window:SetVisible(true )
	mRP.debugMsg ("showActorWindow done");
	if( mRP.UI.actor.Window:GetVisible() == true ) then
		mRP.populateActorWindow(args);
	end
end

-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
function mRP.populateActorWindow(args)

end

function mRP.createActorWindow()
    mRP.UI.actor = {}

	if( mRP.UI.Context == nil) then
		mRP.UI.Context     = UI.CreateContext(AddonData.identifier)
	end

    mRP.UI.actor.Window  = UI.CreateFrame("SimpleWindow", "MainMRPDataWindow", mRP.UI.Context )

    mRP.UI.actor.Window:SetCloseButtonVisible(true)
    mRP.UI.actor.Window:SetTitle("Actor Data")
    mRP.UI.actor.Window:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 100, 200)
	mRP.UI.actor.Window:SetWidth(500)
    mRP.UI.actor.Window:SetVisible(false)

    -- details

    mRP.UI.actor.loaded = true;
end

function mRP.toggleActorWindow(args)
	if( mRP.UI.actor == nil) then
		mRP.createActorWindow();
	end
	mRP.UI.actor.Window:SetVisible(not mRP.UI.actor.Window:GetVisible() )
	if( mRP.UI.actor.Window:GetVisible() == true ) then
		mRP.populateActorWindow(args);
	end
end

-- ---------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------

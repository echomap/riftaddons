-- ---------------------------------------------------------------------------------------------------------
-- Welcome to the mRP Addon!
-- ---------------------------------------------------------------------------------------------------------
local AddonData = Inspect.Addon.Detail("mRP")

local mRP = AddonData.data
-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
function mRP.showHelpWindow(args)
	mRP.debugMsg ( "showHelpWindow called" );
	if( mRP.UI.help == nil) then
		mRP.createHelpWindow();
	end
	mRP.UI.help.Window:SetVisible(true )
	mRP.debugMsg ("showHelpWindow done");
	if( mRP.UI.help.Window:GetVisible() == true ) then
		mRP.populateHelpWindow(args);
	end
end

-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
function mRP.populateHelpWindow(args)

end

function mRP.createHelpWindow()
    mRP.UI.help = {}

	if( mRP.UI.Context == nil) then
		mRP.UI.Context     = UI.CreateContext(AddonData.identifier)
	end

    mRP.UI.help.Window  = UI.CreateFrame("SimpleWindow", "MainMRPDataWindow", mRP.UI.Context )

    mRP.UI.help.Window:SetCloseButtonVisible(true)
    mRP.UI.help.Window:SetTitle("Help")
    mRP.UI.help.Window:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 100, 200)
	mRP.UI.help.Window:SetWidth(500)
    mRP.UI.help.Window:SetVisible(false)

    -- details
    mRP.UI.help.general = {}

	mRP.UI.help.general.LabelCD = UI.CreateFrame("Text", "LabelCD", mRP.UI.help.Window )
	mRP.UI.help.general.LabelCD:SetPoint("TOPLEFT", mRP.UI.help.Window:GetContent(), "TOPLEFT", 0, 12 )
	mRP.UI.help.general.LabelCD:SetWidth(  100 )
	mRP.UI.help.general.LabelCD:SetHeight( 20 )
	mRP.UI.help.general.LabelCD:SetBackgroundColor(0, 153, 153, 0.3)
	mRP.UI.help.general.LabelCD:SetText("HELP");

	mRP.UI.help.general.Text1 = UI.CreateFrame("Text", "NPText", mRP.UI.help.Window )
	mRP.UI.help.general.Text1:SetPoint("TOPLEFT", mRP.UI.help.general.LabelCD, "BOTTOMLEFT", 0, 12 )
	mRP.UI.help.general.Text1:SetWidth( mRP.UI.help.Window:GetContent():GetWidth() * 0.80 )
	mRP.UI.help.general.Text1:SetHeight( mRP.UI.help.Window:GetContent():GetHeight() * 0.80)
	mRP.UI.help.general.Text1:SetBackgroundColor(255, 255, 255, 0.3)
    --mRP.UI.help.general.Text1:SetBorder(1, 255, 255, 255, 1)
	mRP.UI.help.general.Text1:SetText( "mRP Help\n Currently you will need to /join mRP for the 'search' to work. \n Version: Alpha" );

    mRP.UI.help.loaded = true;
end

function mRP.toggleHelpWindow(args)
	if( mRP.UI.help == nil) then
		mRP.createHelpWindow();
	end
	mRP.UI.help.Window:SetVisible(not mRP.UI.help.Window:GetVisible() )
	if( mRP.UI.help.Window:GetVisible() == true ) then
		mRP.populateHelpWindow(args);
	end
end

-- ---------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------

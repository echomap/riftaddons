-- Welcome to the mRP Addon!
--
-- ---------------------------------------------------------------------------------------------------------
-- https://rift.curseforge.com/addons/libsimplewidgets/pages/api-documentation/
-- ---------------------------------------------------------------------------------------------------------
local AddonData = Inspect.Addon.Detail("mRP")

local mRP = AddonData.data

-- ---------------------------------------------------------------------------------------------------------
local function secureFrames()
	--if(mRP.UI.mainWindow ~= nil) then mRP.UI.mainWindow:SetSecureMode('restricted') end;
	if(mRP.UI.helperMain ~= nil) then mRP.UI.helperMain:SetSecureMode('restricted') end;
end
-- ---------------------------------------------------------------------------------------------------------
function mRP.hideWindows()
	for k,v in pairs(mRP.UI.ShowUIList) do
		mRP.debugMsg ("toggle vis: " ..v:GetTitle() );
		v:SetVisible(false)
	end
	if(mRP.UI.helperMain ~= nil) then mRP.UI.helperMain:SetVisible(false) end;
end

-- ---------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
function mRP.populateInfoWindow(args)
	local words = {}
	for word in args:gmatch("%w+") do
	 	table.insert(words, word)
	end
	mRP.debugMsg( "populateInfoWindow words:", dump(words) );
	--for k, v in ipairs(words) do
  	--	print(k, v) --[1]) --, v[2], v[3])
	--end
	local numwrds = table.getn(words)
	mRP.debugMsg("words#=" .. numwrds )
	local pTarget = nil;
	if( numwrds == 1 ) then
		mRP.debugMsg("word 1=" ..words[1] )
		pTarget = Inspect.Unit.Detail("player.target")
		mRP.debugMsg("pTarget: ", dump(pTarget) );
	end
	if( numwrds == 2 ) then
		mRP.debugMsg("word 2=" ..words[2] )
		local tName = words[2];
		pTarget = Inspect.Unit.Detail( {tName} )
		mRP.debugMsg("pTarget: ", dump(pTarget) );
		--mRP.UI.info.TextArea:SetText( dump(pTarget) ) --"Cell_1_2 \n asdfds1 \n asdfsdf2")
		local fdetail = Inspect.Social.Friend.Detail(tName)
		mRP.debugMsg("fdetail: ", dump(fdetail) );
		local unitInfo = Inspect.Unit.Lookup( {tName} )
		mRP.debugMsg("unitInfo: ", dump(unitInfo) );
	end

end

function mRP.showInfoWindow(args)
	mRP.debugMsg ( "showInfoWindow called" );
	if( mRP.UI.info == nil) then
		mRP.createInfoWindow();
	end
	mRP.UI.info.Window:SetVisible(true )
	mRP.debugMsg ("showInfoWindow done");
	if( mRP.UI.info.Window:GetVisible() == true ) then
		mRP.populateInfoWindow(args);
	end
end

function mRP.createInfoWindow()
    mRP.UI.info = {}

	if( mRP.UI.Context == nil) then
		mRP.UI.Context     = UI.CreateContext(AddonData.identifier)
	end

    mRP.UI.info.Window  = UI.CreateFrame("SimpleWindow", "MainMRPDataWindow", mRP.UI.Context )

    mRP.UI.info.Window:SetCloseButtonVisible(true)
    mRP.UI.info.Window:SetTitle("User Data")
    mRP.UI.info.Window:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 100, 200)
	mRP.UI.info.Window:SetWidth(500)
    mRP.UI.info.Window:SetVisible(false)

	-- RIGHT
	local rightParent = mRP.UI.info.Window
	mRP.UI.info.Label1 = UI.CreateFrame("Text", "Cell_SimpleText", rightParent )
	mRP.UI.info.Label1:SetPoint("TOPLEFT", rightParent:GetContent(), "TOPLEFT")
	mRP.UI.info.Label1:SetWidth( 50 )
	mRP.UI.info.Label1:SetHeight(20)
	--mRP.UI.info.Label1:SetBackgroundColor(255, 255, 255, 0.3)
	mRP.UI.info.Label1:SetText("No data");

	mRP.UI.info.TextArea = UI.CreateFrame("SimpleTextArea", "Cell_SimpleTextArea", rightParent )
	mRP.UI.info.TextArea:SetPoint("TOPLEFT", rightParent:GetContent(), "TOPLEFT", 100, 50)
	mRP.UI.info.TextArea:SetWidth( rightParent:GetContent():GetWidth() * 0.80) -- * 0.60 )
	mRP.UI.info.TextArea:SetHeight(200)
	mRP.UI.info.TextArea:SetBorder(1, 1, 1, 1, 1)
	mRP.UI.info.TextArea:SetBackgroundColor(255, 255, 255, 0.3)
	mRP.UI.info.TextArea:SetText("No data loaded \n \t... \n \t\tyet")

    mRP.UI.info.mybutton1 = UI.CreateFrame("RiftButton", "MyButton1", rightParent)
    --mRP.UI.info.mytextfield1 = UI.CreateFrame("RiftTextfield", "MyTextfield1", rightParent)
    mRP.UI.info.mybutton1.tooltip1 = UI.CreateFrame("SimpleTooltip", "MyTooltip1", rightParent)
    mRP.UI.info.mybutton1.tooltip1:InjectEvents(mRP.UI.info.mybutton1, function() return "My Button1 Tooltip" end)
    mRP.UI.info.mybutton1:SetPoint("TOPLEFT", mRP.UI.info.TextArea, "BOTTOMLEFT")
	--tooltip1:InjectEvents(mytextfield1 , function() return "My Textfield1 Tooltip" end)

	mRP.UI.info.loaded = true;
end

function mRP.toggleInfoWindow(args)
	if( mRP.UI.info == nil) then
		mRP.createInfoWindow();
	end
	mRP.UI.info.Window:SetVisible(not mRP.UI.info.Window:GetVisible() )
	if( mRP.UI.info.Window:GetVisible() == true ) then
		mRP.populateInfoWindow(args);
	end
end
-- ---------------------------------------------------------------------------------------------------------


-- ---------------------------------------------------------------------------------------------------------

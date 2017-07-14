-- ---------------------------------------------------------------------------------------------------------
-- Welcome to the mRP Addon!
-- ---------------------------------------------------------------------------------------------------------
local AddonData = Inspect.Addon.Detail("mRP")

local mRP = AddonData.data
-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
function mRP.showSessionsWindow(args)
	mRP.debugMsg ( "showSessionsWindow called" );
	if( mRP.UI.sessions == nil) then
		mRP.createSessionsWindow();
	end
	mRP.UI.sessions.Window:SetVisible(true )
	mRP.debugMsg ("showSessionsWindow done");
	if( mRP.UI.sessions.Window:GetVisible() == true ) then
		mRP.populateSessionsWindow(args);
	end
end

-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
function mRP.addSessionToList(args)
	mRP.debugMsg ("addSessionToList called w/name: ''", args.name, "'' idx: ", args.idx , " notes: ", args.notes );
	--args.name  = mRP.UI.session.general.NewSessionName:GetText(); --mRP.UI.session.name
	--args.idx   = mRP.UI.session.index
	--args.notes = mRP.UI.session.general.TextArea1:GetText();

	if( mRPStorageC.sessions == nil ) then
		mRPStorageC.sessions = {}
	end

	-- remove old entry
	if( args.oname ~= nil and string.len(args.oname) > 1 ) then
		local oData = mRPStorageC.sessions[args.oname];
		if(oData ~= nil) then
			mRPStorageC.sessions[args.oname] = nil;
		end
	end

	-- new entry
	local pData = {}
	pData.oname = args.name
	pData.name  = args.name;
	pData.notes = args.notes;
	--TODO other stuff to save
	mRPStorageC.sessions[args.name] = pData;

	mRP.populateSessionsWindow();
end


function mRP.OpenSelectedSessionWindow()
	local s1Items = mRP.UI.sessions.general.Select1:GetItems();
	local s1Idx   = mRP.UI.sessions.general.Select1:GetSelectedIndex();
	local s1Itm   = mRP.UI.sessions.general.Select1:GetSelectedItem();
	local s1Val   = mRP.UI.sessions.general.Select1:GetSelectedValue();
	--TODO show session page with this data
	local args  = {}
	args.name   = s1Itm
	args.idx    = s1Idx
	args.parent = mRP.UI.sessions.Window
	args.val    = s1Val
	mRP.showSessionWindow(args);
end

-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
function mRP.populateSessionsWindow(args)
	mRP.debugMsg ("populateSessionsWindow: Called");
	local items = {}
	local itemVals = { }

	if( mRPStorageC == nil ) then
		mRPStorageC = {}
	end
	if( mRPStorageC.sessions ~= nil ) then
		mRP.debugMsg ("populateSessionsWindow: items: ", dump(mRPStorageC.sessions) );
		for key,value in pairs(mRPStorageC.sessions) do
			--mRP.debugMsg (key,value)
			table.insert(items,    key)
			table.insert(itemVals, value)
		end
	end

	mRP.UI.sessions.general.Select1:SetItems(items, itemVals)
	--mRP.UI.sessions.general.Select1:SetSelectedIndex(1, false)

	--local pData = {}
	--pData.name  = args.name;
	--pData.notes = args.notes;
	--mRPStorageC.sessions[args.name] = pData;
end

function mRP.createSessionsWindow()
    mRP.UI.sessions = {}

	if( mRP.UI.Context == nil) then
		mRP.UI.Context     = UI.CreateContext(AddonData.identifier)
	end

    mRP.UI.sessions.Window  = UI.CreateFrame("SimpleWindow", "MainMRPDataWindow", mRP.UI.Context )

    mRP.UI.sessions.Window:SetCloseButtonVisible(true)
    mRP.UI.sessions.Window:SetTitle("Sessions")
    mRP.UI.sessions.Window:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 100, 100)
	mRP.UI.sessions.Window:SetWidth(500)
	mRP.UI.sessions.Window:SetHeight(125)
    mRP.UI.sessions.Window:SetVisible(false)

	local WLeft = 100;
    local WTop  = 200;
    if( mRPSetup ~= nil and mRPSetup.sessions ~= nil ) then
        if( mRPSetup.sessions.left ~= nil and mRPSetup.sessions.left > 0 ) then
            WLeft = mRPSetup.sessions.left;
        end
        if( mRPSetup.sessions.top ~= nil and mRPSetup.sessions.top > 0 ) then
            WTop = mRPSetup.sessions.top;
        end
    end
    mRP.UI.sessions.Window:SetPoint("TOPLEFT", UIParent, "TOPLEFT", WLeft, WTop)

    -- details
	local rightParent = mRP.UI.sessions.Window
	mRP.UI.sessions.general = {}

	-- tabs? current, saved? quick? etc?
	--session status: Public, Private, Closed
	--active/planning/archived

	--quick session -- shows current sessions, text for summary, typing, remember... notes

	--mRP.UI.sessions.general.LabelCS = UI.CreateFrame("Text", "LabelCD", rightParent )
	--mRP.UI.sessions.general.LabelCS:SetPoint("TOPLEFT", mRP.UI.sessions.Window:GetContent(), "BOTTOMLEFT", 0, 4)
	--mRP.UI.sessions.general.LabelCS:SetHeight( 20 )
	--mRP.UI.sessions.general.LabelCS:SetBackgroundColor(255, 0, 127, 0.3)
	--mRP.UI.sessions.general.LabelCS:SetText("asdf");

	mRP.UI.sessions.general.btn1 = UI.CreateFrame("RiftButton", "NPButton", rightParent)
	mRP.UI.sessions.general.btn1:SetText("Open Session")
	mRP.UI.sessions.general.btn1:SetPoint("TOPLEFT", mRP.UI.sessions.Window:GetContent() , "TOPLEFT", 0, 12  )
	mRP.UI.sessions.general.btn1:SetWidth(100)
	function mRP.UI.sessions.general.btn1.Event:LeftPress()
		mRP.debugMsg("BUTTON Open Session PRESSED")
		mRP.OpenSelectedSessionWindow();
	end

	mRP.UI.sessions.general.btn2 = UI.CreateFrame("RiftButton", "NPButton", rightParent)
	mRP.UI.sessions.general.btn2:SetText("New Session")
	mRP.UI.sessions.general.btn2:SetPoint("TOPLEFT", mRP.UI.sessions.general.btn1 , "TOPRIGHT", 12, 0  )
	mRP.UI.sessions.general.btn2:SetWidth(100)
	function mRP.UI.sessions.general.btn2.Event:LeftPress()
		mRP.debugMsg("BUTTON New Session PRESSED")
		--TODO show session page with empty data
		local args = {}
		--args.name = s1Itm
		--args.idx = s1Idx
		args.parent = mRP.UI.sessions.Window
		mRP.showSessionWindow(args);
	end

	mRP.UI.sessions.general.btn3 = UI.CreateFrame("RiftButton", "NPButton", rightParent)
	mRP.UI.sessions.general.btn3:SetText("Unk")
	mRP.UI.sessions.general.btn3:SetPoint("TOPLEFT", mRP.UI.sessions.general.btn2 , "TOPRIGHT", 12, 0  )
	mRP.UI.sessions.general.btn3:SetWidth(100)
	function mRP.UI.sessions.general.btn3.Event:LeftPress()
		mRP.debugMsg("BUTTON New3 PRESSED")
	end

	--
	mRP.UI.sessions.general.Select1 = UI.CreateFrame("SimpleSelect", "SelctProfile", rightParent )
	mRP.UI.sessions.general.Select1:SetPoint("TOPLEFT", mRP.UI.sessions.general.btn1, "BOTTOMLEFT")
	mRP.UI.sessions.general.Select1:SetWidth(  125 )
	mRP.UI.sessions.general.Select1:SetHeight( 20  )
	mRP.UI.sessions.general.Select1:SetBackgroundColor(255, 255, 255, 0.3)
	mRP.UI.sessions.general.Select1.Event.ItemSelect = function(view, item)
		print("mRP: Select Sessions: ("..item..")")
		mRP.OpenSelectedSessionWindow();
	end

	--

	--


    mRP.UI.sessions.loaded = true;
end

function mRP.toggleSessionsWindow(args)
	if( mRP.UI.sessions == nil) then
		mRP.createSessionsWindow();
	end
	mRP.UI.sessions.Window:SetVisible(not mRP.UI.sessions.Window:GetVisible() )
	if( mRP.UI.sessions.Window:GetVisible() == true ) then
		mRP.populateSessionsWindow(args);
	end
end

-- ---------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------

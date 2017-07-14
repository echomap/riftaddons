-- ---------------------------------------------------------------------------------------------------------
-- Welcome to the mRP Addon!
-- ---------------------------------------------------------------------------------------------------------
local AddonData = Inspect.Addon.Detail("mRP")

local mRP = AddonData.data
-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
function mRP.showProfileWindow(args)
	mRP.debugMsg ( "showProfileWindow called" );
	if( mRP.UI.profile == nil) then
		mRP.createProfileWindow();
	end
	mRP.UI.profile.Window:SetVisible(true )
	mRP.debugMsg ("showProfileWindow done");
	if( mRP.UI.profile.Window:GetVisible() == true ) then
		mRP.populateProfileWindow(args);
	end
end

-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
function mRP.retrieveSelectedProfileByName(profileName)

	return "testvaluetext"
end
-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
function mRP.populateProfileWindow(args)

end

function mRP.createProfileWindow()
    mRP.UI.profile = {}

	if( mRP.UI.Context == nil) then
		mRP.UI.Context     = UI.CreateContext(AddonData.identifier)
	end

	mRP.UI.profile.Window  = UI.CreateFrame("SimpleWindow", "mRPMainProfileWindow", mRP.UI.Context )
    mRP.UI.profile.Window:SetCloseButtonVisible(true)
    mRP.UI.profile.Window:SetTitle("Main Profile Data")
    mRP.UI.profile.Window:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 100, 200)
	mRP.UI.profile.Window:SetWidth(475)
	mRP.UI.profile.Window:SetHeight(340)
    mRP.UI.profile.Window:SetVisible(false)


    local WLeft = 100;
    local WTop = 200;
    if( mRPSetup~= nil and mRPSetup.profile ~= nil ) then
        if( mRPSetup.profile.left ~= nil and mRPSetup.profile.left > 0 ) then
            WLeft = mRPSetup.profile.left;
        end
        if( mRPSetup.profile.top ~= nil and mRPSetup.profile.top > 0 ) then
            WTop = mRPSetup.profile.top;
        end
    end
    mRP.UI.profile.Window:SetPoint("TOPLEFT", UIParent, "TOPLEFT", WLeft, WTop)

	mRP.UI.profile.Tabbed  = UI.CreateFrame("SimpleTabView", "mRPTabbedProfileWindow", mRP.UI.profile.Window )
    mRP.UI.profile.Tabbed:SetPoint("TOPLEFT", mRP.UI.profile.Window:GetContent() , "BOTTOMLEFT")
	mRP.UI.profile.Tabbed:SetWidth( mRP.UI.profile.Window:GetContent():GetWidth()*0.80 )
	mRP.UI.profile.Tabbed:SetTabContentBackgroundColor(255, 255, 255, 0)

    -- details
	local rightParent = nil;
	mRP.UI.profile.general = {}
	mRP.UI.profile.general.ProfileNameMaxLen = mRP.settings.ProfileNameMaxLen;

	-- TAB -- GENERAL
	mRP.UI.profile.general.WindowO = UI.CreateFrame("SimpleWindow", "mRPGeneral", mRP.UI.profile.Tabbed.tabContent)
	mRP.UI.profile.general.Window  = UI.CreateFrame("Frame", "mRPGeneralWindow", mRP.UI.profile.general.WindowO );
	mRP.UI.profile.general.Window:SetPoint("TOPLEFT", mRP.UI.profile.Window:GetContent(), "TOPLEFT")
	mRP.UI.profile.general.Window:SetWidth(mRP.UI.profile.Window:GetWidth())
	mRP.UI.profile.general.Window:SetHeight(mRP.UI.profile.Window:GetHeight())
	rightParent = mRP.UI.profile.general.Window

	mRP.UI.profile.general.Label1 = UI.CreateFrame("Text", "Label1G", rightParent )
	mRP.UI.profile.general.Label1:SetPoint("TOPLEFT", rightParent, "TOPLEFT")
	mRP.UI.profile.general.Label1:SetWidth(  100 )
	mRP.UI.profile.general.Label1:SetHeight( 20 )
	--mRP.UI.profile.general.Label1:SetBackgroundColor(255, 255, 255, 0.3)
	mRP.UI.profile.general.Label1:SetText("Select Profile to Edit");

	mRP.UI.profile.general.deleteProfileButton = UI.CreateFrame("RiftButton", "SaveButton", rightParent)
	mRP.UI.profile.general.deleteProfileButton:SetText("Delete Selected")
	mRP.UI.profile.general.deleteProfileButton:SetPoint("TOPLEFT", mRP.UI.profile.general.Label1, "TOPRIGHT", 12, -8)
	mRP.UI.profile.general.deleteProfileButton:SetWidth(100)
	function mRP.UI.profile.general.deleteProfileButton.Event:LeftPress()
		local ptIdx = mRP.UI.profile.general.SelectProfile1:GetSelectedIndex()

		local vGI = mRP.UI.profile.general.SelectProfile1:GetItems()
		table.remove( items, ptIdx )
		mRP.UI.profile.general.SelectProfile1:SetItems(items);
		mRP.UI.profile.general.SelectProfileCP:SetItems(items);
		mRPStorageC.profiles = items;
		mRP.UI.profile.general.SelectProfile1:SetSelectedIndex(1, true)
		--print("mRP: Profile Data Deleted")
	end

	-- SimpleSelect
	mRP.UI.profile.general.SelectProfile1 = UI.CreateFrame("SimpleSelect", "SelctProfile", rightParent )
	mRP.UI.profile.general.SelectProfile1:SetPoint("TOPLEFT", mRP.UI.profile.general.Label1, "BOTTOMLEFT", 0, 8 )
	mRP.UI.profile.general.SelectProfile1:SetWidth(  200 )
	mRP.UI.profile.general.SelectProfile1:SetHeight( 20  )
	mRP.UI.profile.general.SelectProfile1:SetBackgroundColor(255, 255, 255, 0.3)
	-- function added at end...

	local items = {}
	if( mRPStorageC ~= nil ) then
		if( mRPStorageC.profiles ~= nil ) then
			items = mRPStorageC.profiles
		else
			table.insert(items, "Default")
		end
	else
		mRPStorageC = {}
		table.insert(items, "Default")
	end

	--local itemVals = { }
	--table.insert(itemVals, nil)
	mRP.UI.profile.general.SelectProfile1:SetItems(items) --, itemVals)
	mRP.UI.profile.general.SelectProfile1:SetSelectedIndex(1, false)

	--
	mRP.UI.profile.general.newProfileButton = UI.CreateFrame("RiftButton", "NPButton", rightParent)
	mRP.UI.profile.general.newProfileButton:SetText("New Profile")
	mRP.UI.profile.general.newProfileButton:SetPoint("TOPLEFT", mRP.UI.profile.general.deleteProfileButton, "TOPRIGHT", 12, 0 )
	mRP.UI.profile.general.newProfileButton:SetWidth(100)
	function mRP.UI.profile.general.newProfileButton.Event:LeftPress()
		--saveSnippet()
		mRP.debugMsg("BUTTON NewProfile PRESSED")
		--TODO save and load
		local vGI = mRP.UI.profile.general.SelectProfile1:GetItems()
		local newPname = mRP.UI.profile.general.NewProfileName:GetText();

		table.insert(items, newPname );
		mRP.UI.profile.general.SelectProfile1:SetItems(items);
		mRP.UI.profile.general.SelectProfileCP:SetItems(items);
		mRPStorageC.profiles = items;
		print("mRP: added New Profile to list")
		mRP.UI.profile.general.SelectProfile1:SetSelectedIndex(1, true);
	end

	mRP.UI.profile.general.NewProfileName = UI.CreateFrame("RiftTextfield", "NPText", rightParent )
	mRP.UI.profile.general.NewProfileName:SetPoint("TOPLEFT", mRP.UI.profile.general.newProfileButton, "BOTTOMLEFT", 12, 0 )
	mRP.UI.profile.general.NewProfileName:SetWidth( 125 )
	mRP.UI.profile.general.NewProfileName:SetHeight(20)
	mRP.UI.profile.general.NewProfileName:SetBackgroundColor(255, 255, 255, 0.3)
	mRP.UI.profile.general.NewProfileName:SetText( "New Profile Name" );
	function mRP.UI.profile.general.NewProfileName.Event:KeyUp()
		local newPname = mRP.UI.profile.general.NewProfileName:GetText();
		local lenPn = string.len(newPname)
		if( lenPn > mRP.UI.profile.general.ProfileNameMaxLen ) then
			newPname = string.sub(newPname,1, lenPn-1);
			mRP.UI.profile.general.NewProfileName:SetText(newPname);
		end
	end

	--TODO divider??
	local divider = 100

	mRP.UI.profile.general.LabelCD = UI.CreateFrame("Text", "LabelCD", rightParent )
	mRP.UI.profile.general.LabelCD:SetPoint("TOPLEFT", mRP.UI.profile.general.newProfileButton, "TOPLEFT", 0, divider)
	mRP.UI.profile.general.LabelCD:SetWidth(  220 )
	mRP.UI.profile.general.LabelCD:SetHeight( 20 )
	mRP.UI.profile.general.LabelCD:SetBackgroundColor(0, 153, 153, 0.3)
	mRP.UI.profile.general.LabelCD:SetText("CURRENT");

	-- Current profile
	mRP.UI.profile.general.LabelCP = UI.CreateFrame("Text", "LabelCPG", rightParent )
	mRP.UI.profile.general.LabelCP:SetPoint("TOPLEFT", mRP.UI.profile.general.LabelCD, "BOTTOMLEFT", 0, 4)
	--mRP.UI.profile.general.LabelCP:SetWidth(  50 )
	mRP.UI.profile.general.LabelCP:SetHeight( 20 )
	--mRP.UI.profile.general.LabelCP:SetBackgroundColor(255, 255, 255, 0.3)
	mRP.UI.profile.general.LabelCP:SetText("Current Profile");

	mRP.UI.profile.general.SelectProfileCP = UI.CreateFrame("SimpleSelect", "SelctCProfile", rightParent )
	mRP.UI.profile.general.SelectProfileCP:SetPoint("TOPLEFT", mRP.UI.profile.general.LabelCP, "TOPRIGHT")
	mRP.UI.profile.general.SelectProfileCP:SetWidth(  125 )
	mRP.UI.profile.general.SelectProfileCP:SetHeight( 20  )
	mRP.UI.profile.general.SelectProfileCP:SetBackgroundColor(255, 255, 255, 0.3)
	mRP.UI.profile.general.SelectProfileCP.ItemSelect = function(view, item)
		--print("mRP Edit Profile: ("..item..")")
		--local pName = mRP.UI.profile.general.SelectProfile1:GetSelectedItem()
		--mRP.UI.profile.private.TextField0:SetText( pName );
		--mRP.UI.profile.public.TextField0:SetText( pName );
		mRPStorageC.currentProfileName = mRP.UI.profile.general.SelectProfileCP:GetSelectedValue();
		mRPStorageC.currentProfileIndex = mRP.UI.profile.general.SelectProfileCP:GetSelectedIndex();
	end

	mRP.UI.profile.general.SelectProfileCP:SetItems(items) --, itemVals)
	-- Dynamic
	if( mRPStorageC.SelectProfileCP ~= nil ) then
		mRP.UI.profile.general.SelectProfileCP:SetSelectedIndex(mRPStorageC.SelectProfileCP, true)
	else
		mRP.UI.profile.general.SelectProfileCP:SetSelectedIndex(1, true)
	end
	--mRP.UI.profile.general.SelectProfileCP:SetSelectedIndex(1, false)


--editor vs viewer
--roleplaying style (fulltime/) --in character frequency
--currently: short 'now doing' text statement or emotion
--accept character injury / accept character death / accept character romance
--relationships
--inscene/busy
--session/scene/act/campaign/Scenario

	-- character status (inchar/ooc/looking for rp)
	mRP.UI.profile.general.LabelCS = UI.CreateFrame("Text", "LabelCD", rightParent )
	mRP.UI.profile.general.LabelCS:SetPoint("TOPLEFT", mRP.UI.profile.general.LabelCP, "BOTTOMLEFT", 0, 25)
	--mRP.UI.profile.general.LabelCS:SetWidth(  100 )
	mRP.UI.profile.general.LabelCS:SetHeight( 20 )
	mRP.UI.profile.general.LabelCS:SetBackgroundColor(255, 0, 127, 0.3)
	mRP.UI.profile.general.LabelCS:SetText("Charcter Status");

	mRP.UI.profile.general.radioButtonGroup = Library.LibSimpleWidgets.RadioButtonGroup("characterStatusRBG")
	mRP.UI.profile.general.radioButtonGroup.Event.RadioButtonChange = function(self)
		print(self:GetName().." selected radio button = "..self:GetSelectedRadioButton():GetName())
	end
	mRP.UI.profile.general.radioButton1 = UI.CreateFrame("SimpleRadioButton", "characterStatusRB1", rightParent)
	mRP.UI.profile.general.radioButton1:SetText("OOC")
	mRP.UI.profile.general.radioButton1:SetPoint("TOPLEFT", mRP.UI.profile.general.LabelCS, "TOPLEFT", 0, 20)
	mRP.UI.profile.general.radioButton1.Event.RadioButtonSelect = function(self)
		--print(self:GetName().." selected")
		mRPStorageC.characterStatus = 1
	end
	mRP.UI.profile.general.radioButtonGroup:AddRadioButton(mRP.UI.profile.general.radioButton1)

	mRP.UI.profile.general.radioButton2 = UI.CreateFrame("SimpleRadioButton", "characterStatusRB2", rightParent)
	mRP.UI.profile.general.radioButton2:SetPoint("TOPLEFT", mRP.UI.profile.general.radioButton1, "BOTTOMLEFT", 0, 5)
	mRP.UI.profile.general.radioButton2:SetText("In Character")
	mRP.UI.profile.general.radioButton2.Event.RadioButtonSelect = function(self)
		--print(self:GetName().." selected")
		mRPStorageC.characterStatus = 2
	end
	mRP.UI.profile.general.radioButtonGroup:AddRadioButton(mRP.UI.profile.general.radioButton2)

	mRP.UI.profile.general.radioButton3 = UI.CreateFrame("SimpleRadioButton", "characterStatusRB3", rightParent)
	mRP.UI.profile.general.radioButton3:SetPoint("TOPLEFT", mRP.UI.profile.general.radioButton2, "BOTTOMLEFT", 0, 5)
	mRP.UI.profile.general.radioButton3:SetText("Looking for RP")
	mRP.UI.profile.general.radioButton3.Event.RadioButtonSelect = function(self)
		--print(self:GetName().." selected")
		mRPStorageC.characterStatus = 3
	end
	mRP.UI.profile.general.radioButtonGroup:AddRadioButton(mRP.UI.profile.general.radioButton3)

	-- Dynamic
	if( mRPStorageC.characterStatus ~= nil ) then
		mRP.UI.profile.general.radioButtonGroup:SetSelectedIndex(mRPStorageC.characterStatus, true)
	else
		mRP.UI.profile.general.radioButtonGroup:SetSelectedIndex(1, true)
	end

	--TODO
	mRP.UI.profile.general.rbg = Library.LibSimpleWidgets.RadioButtonGroup("MyRadioButtonGroup2")
	mRP.UI.profile.general.rbg.Event.RadioButtonChange = function(self)
		print(self:GetName().." selected radio button = "..self:GetSelectedRadioButton():GetName())
	end
	--TODO



	--TOOD: statuses and such


	--
	-- TAB -- Private
	mRP.UI.profile.private = {}
	mRP.UI.profile.private.WindowO = UI.CreateFrame("SimpleWindow", "mRPProfile", mRP.UI.profile.Tabbed.tabContent)
	mRP.UI.profile.private.Window  = UI.CreateFrame("Frame", "mRPProfileWindow", mRP.UI.profile.private.WindowO );
	mRP.UI.profile.private.Window:SetPoint("TOPLEFT", mRP.UI.profile.Window:GetContent(), "TOPLEFT")
	mRP.UI.profile.private.Window:SetWidth(mRP.UI.profile.Window:GetWidth())
	mRP.UI.profile.private.Window:SetHeight(mRP.UI.profile.Window:GetHeight())

	rightParent = mRP.UI.profile.private.Window
	mRP.UI.profile.private.Label0 = UI.CreateFrame("Text", "Label0", rightParent )
	mRP.UI.profile.private.Label0:SetPoint("TOPLEFT", rightParent, "TOPLEFT")
	--mRP.UI.profile.private.Label0:SetWidth(  100 )
	--mRP.UI.profile.private.Label0:SetHeight( 20 )
	mRP.UI.profile.private.Label0:SetBackgroundColor(255, 255, 255, 0.3)
	mRP.UI.profile.private.Label0:SetText("Profile Name");

	mRP.UI.profile.private.TextField0 = UI.CreateFrame("RiftTextfield", "SampleWindow", rightParent )
	mRP.UI.profile.private.TextField0:SetPoint("TOPLEFT", mRP.UI.profile.private.Label0, "TOPRIGHT", 12, 0 )
	mRP.UI.profile.private.TextField0:SetWidth( 150 )
	mRP.UI.profile.private.TextField0:SetHeight(20)
	--mRP.UI.profile.private.TextField0:SetBackgroundColor(255, 255, 255, 0.3)

	local pName = mRP.UI.profile.general.SelectProfile1:GetSelectedItem()
	mRP.UI.profile.private.TextField0:SetText( pName ); --TODO remember to update this when select profile changes

	mRP.UI.profile.private.Label1 = UI.CreateFrame("Text", "Label1", rightParent )
	mRP.UI.profile.private.Label1:SetPoint("TOPLEFT", mRP.UI.profile.private.Label0, "BOTTOMLEFT", 0, 12 )
	mRP.UI.profile.private.Label1:SetBackgroundColor(255, 255, 255, 0.3)
	mRP.UI.profile.private.Label1:SetText("Private Info");

	mRP.UI.profile.private.TextArea1 = UI.CreateFrame("SimpleTextArea", "Cell_SimpleTextArea", rightParent )
	mRP.UI.profile.private.TextArea1:SetPoint("TOPLEFT", mRP.UI.profile.private.Label1, "BOTTOMRIGHT", 0, 12 )
	mRP.UI.profile.private.TextArea1:SetPoint("BOTTOMRIGHT", mRP.UI.profile.Window:GetContent(), "BOTTOMRIGHT", -12, -12)
	--mRP.UI.profile.private.TextArea1:SetWidth( rightParent:GetWidth() * 0.80 )
	--mRP.UI.profile.private.TextArea1:SetHeight(200)
	mRP.UI.profile.private.TextArea1:SetBorder(1, 1, 1, 1, 1)
	--mRP.UI.profile.private.TextArea1:SetBackgroundColor(255, 255, 255, 0.3)
	mRP.UI.profile.private.TextArea1:SetText("Cell_1_2 \n asdfds1 \n asdfsdf2")

	if( mRPStorageC.private ~= nil ) then
		if( mRPStorageC.private[pName] ~= nil ) then
			mRP.UI.profile.private.TextArea1:SetText( mRPStorageC.private[pName] );
		end
	end

	mRP.UI.profile.private.saveButton = UI.CreateFrame("RiftButton", "SaveButton", rightParent)
	mRP.UI.profile.private.saveButton:SetText("Save")
	mRP.UI.profile.private.saveButton:SetPoint("TOPLEFT", mRP.UI.profile.private.Label1, "TOPRIGHT", 44, 0)
	mRP.UI.profile.private.saveButton:SetWidth(100)
	function mRP.UI.profile.private.saveButton.Event:LeftPress()
		if( mRPStorageC == nil ) then
			mRPStorageC = {}
		end
		if( mRPStorageC.private == nil ) then
			mRPStorageC.private = {}
		end
		local pName = mRP.UI.profile.general.SelectProfile1:GetSelectedItem()
		--table.insert( mRPStorageC.private, {[pName] = mRP.UI.profile.private.TextArea1:GetText(); } )
		mRPStorageC.private[pName] = mRP.UI.profile.private.TextArea1:GetText();
		print("mRP: Private Data Saved")
	end
	--mRP.UI.profile.private.saveButton:SetLayer(2)

	mRP.UI.profile.private.resetButton = UI.CreateFrame("RiftButton", "ResetButton", rightParent)
	mRP.UI.profile.private.resetButton:SetText("Reset")
	mRP.UI.profile.private.resetButton:SetPoint("TOPLEFT", mRP.UI.profile.private.saveButton, "TOPRIGHT", 12, 0)
	mRP.UI.profile.private.resetButton:SetWidth(100)
	function mRP.UI.profile.private.resetButton.Event:LeftPress()
		--saveSnippet()
		mRP.debugMsg("BUTTON Reset PRESSED")
		--TODO
	end

	--
	-- TAB -- Public
	mRP.UI.profile.public = {}
	mRP.UI.profile.public.WindowO = UI.CreateFrame("SimpleWindow", "mRPProfile", mRP.UI.profile.Tabbed.tabContent)
	mRP.UI.profile.public.Window  = UI.CreateFrame("Frame", "mRPProfileWindow", mRP.UI.profile.public.WindowO );
	mRP.UI.profile.public.Window:SetPoint("TOPLEFT", mRP.UI.profile.Window:GetContent(), "TOPLEFT")
	mRP.UI.profile.public.Window:SetWidth(mRP.UI.profile.Window:GetWidth())
	mRP.UI.profile.public.Window:SetHeight(mRP.UI.profile.Window:GetHeight())

	rightParent = mRP.UI.profile.public.Window
	mRP.UI.profile.public.Label0 = UI.CreateFrame("Text", "Label0", rightParent )
	mRP.UI.profile.public.Label0:SetPoint("TOPLEFT", rightParent, "TOPLEFT")
	--mRP.UI.profile.public.Label0:SetWidth(  100 )
	--mRP.UI.profile.public.Label0:SetHeight( 20 )
	mRP.UI.profile.public.Label0:SetBackgroundColor(255, 255, 255, 0.3)
	mRP.UI.profile.public.Label0:SetText("Profile Name");

	mRP.UI.profile.public.TextField0 = UI.CreateFrame("RiftTextfield", "SampleWindow", rightParent )
	mRP.UI.profile.public.TextField0:SetPoint("TOPLEFT", mRP.UI.profile.public.Label0, "TOPRIGHT", 12, 0 )
	mRP.UI.profile.public.TextField0:SetWidth( 150 )
	mRP.UI.profile.public.TextField0:SetHeight(20)
	--mRP.UI.profile.public.TextField0:SetBackgroundColor(255, 255, 255, 0.3)

	local pName = mRP.UI.profile.general.SelectProfile1:GetSelectedItem()
	mRP.UI.profile.public.TextField0:SetText( pName ); --TODO remember to update this when select profile changes

	mRP.UI.profile.public.Label1 = UI.CreateFrame("Text", "Label1", rightParent )
	mRP.UI.profile.public.Label1:SetPoint("TOPLEFT", mRP.UI.profile.public.Label0, "BOTTOMLEFT", 0, 12 )
	mRP.UI.profile.public.Label1:SetBackgroundColor(255, 255, 255, 0.3)
	mRP.UI.profile.public.Label1:SetText("Public Info");

	mRP.UI.profile.public.TextArea1 = UI.CreateFrame("SimpleTextArea", "Cell_SimpleTextArea", rightParent )
	mRP.UI.profile.public.TextArea1:SetPoint("TOPLEFT", mRP.UI.profile.public.Label1, "BOTTOMRIGHT", 0, 12 )
	mRP.UI.profile.public.TextArea1:SetPoint("BOTTOMRIGHT", mRP.UI.profile.Window:GetContent(), "BOTTOMRIGHT", -12, -12)
	--mRP.UI.profile.public.TextArea1:SetWidth( rightParent:GetWidth() * 0.80 )
	--mRP.UI.profile.public.TextArea1:SetHeight(200)
	mRP.UI.profile.public.TextArea1:SetBorder(1, 1, 1, 1, 1)
	--mRP.UI.profile.public.TextArea1:SetBackgroundColor(255, 255, 255, 0.3)
	mRP.UI.profile.public.TextArea1:SetText("Cell_1_2 \n asdfds1 \n asdfsdf2")

	if( mRPStorageC.public ~= nil ) then
		if( mRPStorageC.public[pName] ~= nil ) then
			mRP.UI.profile.public.TextArea1:SetText( mRPStorageC.public[pName] );
		end
	end

	mRP.UI.profile.public.saveButton = UI.CreateFrame("RiftButton", "SaveButton", rightParent)
	mRP.UI.profile.public.saveButton:SetText("Save")
	mRP.UI.profile.public.saveButton:SetPoint("TOPLEFT", mRP.UI.profile.public.Label1, "TOPRIGHT", 44, 0)
	mRP.UI.profile.public.saveButton:SetWidth(100)
	function mRP.UI.profile.public.saveButton.Event:LeftPress()
		if( mRPStorageC == nil ) then
			mRPStorageC = {}
		end
		if( mRPStorageC.public == nil ) then
			mRPStorageC.public = {}
		end
		local pName = mRP.UI.profile.general.SelectProfile1:GetSelectedItem()
		--table.insert( mRPStorageC.public, {[pName] = mRP.UI.profile.public.TextArea1:GetText(); } )
		mRPStorageC.public[pName] = mRP.UI.profile.public.TextArea1:GetText();
		print("mRP: Public Data Saved")
	end
	--mRP.UI.profile.public.saveButton:SetLayer(2)

	mRP.UI.profile.public.resetButton = UI.CreateFrame("RiftButton", "ResetButton", rightParent)
	mRP.UI.profile.public.resetButton:SetText("Reset")
	mRP.UI.profile.public.resetButton:SetPoint("TOPLEFT", mRP.UI.profile.public.saveButton, "TOPRIGHT", 12, 0)
	mRP.UI.profile.public.resetButton:SetWidth(100)
	function mRP.UI.profile.public.resetButton.Event:LeftPress()
		--saveSnippet()
		mRP.debugMsg("BUTTON Reset PRESSED")
		--TODO
	end

	--
	-- TAB -- Biography

	--
	-- TABS --
	mRP.UI.profile.Tabbed:SetTabPosition("bottom")
	mRP.UI.profile.Tabbed:AddTab("General", mRP.UI.profile.general.WindowO )
	mRP.UI.profile.Tabbed:AddTab("Public",  mRP.UI.profile.public.WindowO  )
	mRP.UI.profile.Tabbed:AddTab("Private", mRP.UI.profile.private.WindowO )

	mRP.UI.profile.general.SelectProfile1.Event.ItemSelect = function(view, item)
		print("mRP Edit Profile: ("..item..")")
		local pName = mRP.UI.profile.general.SelectProfile1:GetSelectedItem()
		mRP.UI.profile.private.TextField0:SetText( pName );
		mRP.UI.profile.public.TextField0:SetText(  pName );

		--TODO mRP.UI.profile.private.TextField0:ResizeToFit()
		--TODO mRP.UI.profile.public.TextField0:ResizeToFit()

		if( mRPStorageC.private ~= nil and mRPStorageC.private[pName] ~= nil ) then
			mRP.UI.profile.private.TextArea1:SetText( mRPStorageC.private[pName] );
		else
			mRP.UI.profile.private.TextArea1:SetText( "" );
		end
		if( mRPStorageC.public ~= nil and mRPStorageC.public[pName] ~= nil ) then
			mRP.UI.profile.public.TextArea1:SetText( mRPStorageC.public[pName] );
		else
			mRP.UI.profile.public.TextArea1:SetText( "" );
		end
	end

    mRP.UI.profile.loaded = true;
end


function mRP.toggleProfileWindow(args)
	if( mRP.UI.profile == nil) then
		mRP.createProfileWindow();
	end
	mRP.UI.profile.Window:SetVisible(not mRP.UI.profile.Window:GetVisible() )
	if( mRP.UI.profile.Window:GetVisible() == true ) then
		mRP.populateProfileWindow(args);
	end
end

-- ---------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
-- Welcome to the mRP Addon!
-- ---------------------------------------------------------------------------------------------------------
local AddonData = Inspect.Addon.Detail("mRP")

local mRP = AddonData.data
-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
function mRP.showNotesWindow(args)
	mRP.debugMsg ( "showNotesWindow called" );
	if( mRP.UI.notes == nil) then
		mRP.createNotesWindow();
	end
	mRP.UI.notes.Window:SetVisible(true )
	mRP.debugMsg ("showNotesWindow done");
	if( mRP.UI.notes.Window:GetVisible() == true ) then
		mRP.populateNotesWindow(args);
	end
end

-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
function mRP.addNoteToList(args)
	mRP.debugMsg ("addNoteToList called w/name: ''", args.name, "'' idx: ", args.idx , " notes: ", args.notes );
	--args.name  = mRP.UI.session.general.NewNoteName:GetText(); --mRP.UI.session.name
	--args.idx   = mRP.UI.session.index
	--args.notes = mRP.UI.session.general.TextArea1:GetText();

	if( mRPStorageC.notes == nil ) then
		mRPStorageC.notes = {}
	end

	-- remove old entry
	if( args.oname ~= nil and string.len(args.oname) > 1 ) then
		local oData = mRPStorageC.notes[args.oname];
		if(oData ~= nil) then
			mRPStorageC.notes[args.oname] = nil;
		end
	end

	-- new entry
	local pData = {}
	pData.oname = args.name
	pData.name  = args.name;
	pData.notes = args.notes;
	--TODO other stuff to save
	mRPStorageC.notes[args.name] = pData;

	mRP.populateNotesWindow();
end

-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
function mRP.populateNotesWindow(args)
	mRP.debugMsg ("populateNotesWindow: Called");

	local items = {}
	if( mRPStorageC ~= nil ) then
		if( mRPStorageC.notes ~= nil ) then
			items = mRPStorageC.notes
		else
			table.insert(items, "Default")
		end
	else
		mRPStorageC = {}
		table.insert(items, "Default")
	end
	mRP.UI.notes.general.Select1:SetItems(items) --, itemVals)
	mRP.UI.notes.general.Select1:SetSelectedIndex(1, false)
end

function mRP.createNotesWindow()
    mRP.UI.notes = {}

	if( mRP.UI.Context == nil) then
		mRP.UI.Context     = UI.CreateContext(AddonData.identifier)
	end

    mRP.UI.notes.Window  = UI.CreateFrame("SimpleWindow", "MRPDataWindowNotes", mRP.UI.Context )

    mRP.UI.notes.Window:SetCloseButtonVisible(true)
    mRP.UI.notes.Window:SetTitle("Notes")
    mRP.UI.notes.Window:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 100, 100)
	mRP.UI.notes.Window:SetWidth(550)
	mRP.UI.notes.Window:SetHeight(325)
    mRP.UI.notes.Window:SetVisible(false)

	local WLeft = 100;
    local WTop  = 200;
    if( mRPSetup ~= nil and mRPSetup.notes ~= nil ) then
        if( mRPSetup.notes.left ~= nil and mRPSetup.notes.left > 0 ) then
            WLeft = mRPSetup.notes.left;
        end
        if( mRPSetup.notes.top ~= nil and mRPSetup.notes.top > 0 ) then
            WTop = mRPSetup.notes.top;
        end
    end
    mRP.UI.notes.Window:SetPoint("TOPLEFT", UIParent, "TOPLEFT", WLeft, WTop)

    -- details
	local rightParent = mRP.UI.notes.Window:GetContent()
	mRP.UI.notes.general = {}
	--
	mRP.UI.notes.general.btn1 = UI.CreateFrame("RiftButton", "NPButton", rightParent)
	mRP.UI.notes.general.btn1:SetText("Search Notes")
	mRP.UI.notes.general.btn1:SetPoint("TOPLEFT", rightParent , "TOPLEFT", 0, 12  )
	mRP.UI.notes.general.btn1:SetWidth(100)
	function mRP.UI.notes.general.btn1.Event:LeftPress()
		mRP.debugMsg("BUTTON Search Notes PRESSED")
		--mRP.OpenSelectedNoteWindow();
	end

	mRP.UI.notes.general.btn2 = UI.CreateFrame("RiftButton", "NPButton", rightParent)
	mRP.UI.notes.general.btn2:SetText("New Note")
	mRP.UI.notes.general.btn2:SetPoint("TOPLEFT", mRP.UI.notes.general.btn1 , "TOPRIGHT", 12, 0  )
	mRP.UI.notes.general.btn2:SetWidth(100)
	function mRP.UI.notes.general.btn2.Event:LeftPress()
		mRP.debugMsg("BUTTON New Note PRESSED")

		local vGI      = mRP.UI.notes.general.Select1:GetItems()
		local newPname = mRP.UI.notes.general.TextField0:GetText();
		local itemsS   = mRP.UI.notes.general.Select1:GetItems()

		table.insert(itemsS, newPname );
		mRP.UI.notes.general.Select1:SetItems(itemsS);
		--mRP.UI.profile.general.SelectProfileCP:SetItems(itemsS);
		mRPStorageC.notes = itemsS;
		print("mRP: added New Note to list")
		mRP.UI.notes.general.Select1:SetSelectedIndex(1, true);
	end

	mRP.UI.notes.general.btn3 = UI.CreateFrame("RiftButton", "NPButton", rightParent)
	mRP.UI.notes.general.btn3:SetText("Delete Note")
	mRP.UI.notes.general.btn3:SetPoint("TOPLEFT", mRP.UI.notes.general.btn2 , "TOPRIGHT", 12, 0  )
	mRP.UI.notes.general.btn3:SetWidth(100)
	function mRP.UI.notes.general.btn3.Event:LeftPress()
		mRP.debugMsg("BUTTON Delete Note PRESSED")

		local ptIdx   = mRP.UI.notes.general.Select1:GetSelectedIndex()
		local itemsS  = mRP.UI.notes.general.Select1:GetItems()
		--local vGI = mRP.UI.notes.general.Select1:GetItems()

		table.remove( itemsS, ptIdx )
		mRP.UI.notes.general.Select1:SetItems(itemsS);
		--mRP.UI.profile.general.SelectProfileCP:SetItems(items);
		mRPStorageC.notes = itemsS;
		mRP.UI.notes.general.Select1:SetSelectedIndex(1, true)
		--print("mRP: Profile Data Deleted")
	end

	mRP.UI.notes.general.btn4 = UI.CreateFrame("RiftButton", "NPButton", rightParent)
	mRP.UI.notes.general.btn4:SetText("Save Note")
	mRP.UI.notes.general.btn4:SetPoint("TOPLEFT", mRP.UI.notes.general.btn3 , "TOPRIGHT", 12, 0  )
	mRP.UI.notes.general.btn4:SetWidth(100)
	function mRP.UI.notes.general.btn4.Event:LeftPress()
		mRP.debugMsg("BUTTON Save Note PRESSED")

		if( mRPStorageC == nil ) then
			mRPStorageC = {}
		end
		if( mRPStorageC.notes == nil ) then
			mRPStorageC.notes = {}
		end
		local pName = mRP.UI.notes.general.Select1:GetSelectedItem()
		--table.insert( mRPStorageC.private, {[pName] = mRP.UI.profile.private.TextArea1:GetText(); } )
		mRPStorageC.notes[pName] = mRP.UI.notes.general.TextArea1:GetText();
		mRP.UI.notes.general.TextArea1:SetBackgroundColor(255, 255, 255, 0)
		print("mRP: Note Data Saved")
	end

	--
	mRP.UI.notes.general.Select1View = UI.CreateFrame("SimpleScrollView", "SelectNoteViewPort", rightParent )
	mRP.UI.notes.general.Select1View:SetPoint("TOPLEFT", mRP.UI.notes.general.btn1, "BOTTOMLEFT")
	mRP.UI.notes.general.Select1View:SetPoint("BOTTOMRIGHT", rightParent, "BOTTOMLEFT", 125, -12)
	--mRP.UI.notes.general.Select1View:SetWidth(  125 )
	--mRP.UI.notes.general.Select1View:SetHeight( 220  )
	mRP.UI.notes.general.Select1View:SetBorder(1, 1, 1, 1, 1)
	mRP.UI.notes.general.Select1View:SetBackgroundColor(255, 255, 255, 0.3)
	mRP.UI.notes.general.Select1View:SetShowScrollbar(true)

	mRP.UI.notes.general.Select1 = UI.CreateFrame("SimpleList", "SelectNote", mRP.UI.notes.general.Select1View )
	--mRP.UI.notes.general.Select1:SetPoint("TOPLEFT", mRP.UI.notes.general.btn1, "BOTTOMLEFT")
	--mRP.UI.notes.general.Select1:SetWidth(  125 )
	--mRP.UI.notes.general.Select1:SetHeight( 20  )
	--mRP.UI.notes.general.Select1:SetBackgroundColor(255, 255, 255, 0.3)
	mRP.UI.notes.general.Select1.Event.ItemSelect = function(view, item)
		print("mRP: Select Notes: ("..item..")")
		local s1Items = mRP.UI.notes.general.Select1:GetItems();
		local s1Idx   = mRP.UI.notes.general.Select1:GetSelectedIndex();
		local s1Itm   = mRP.UI.notes.general.Select1:GetSelectedItem();
		local s1Val   = mRP.UI.notes.general.Select1:GetSelectedValue();
		local s1Text  = "xxxx ("..s1Itm..") xxxx"
		if( mRPStorageC.notes ~= nil ) then
			s1Text = mRPStorageC.notes[s1Itm];
			if( s1Text == nil) then
				s1Text = ""
			end
			mRP.UI.notes.general.TextArea1:SetText( s1Text )
			mRP.UI.notes.general.TextArea1:SetBackgroundColor(255, 255, 255, 0)
		end
	end
	mRP.UI.notes.general.Select1View:SetContent(mRP.UI.notes.general.Select1)

	--
	mRP.UI.notes.general.Label0 = UI.CreateFrame("Text", "Label0", rightParent )
	mRP.UI.notes.general.Label0:SetPoint("TOPLEFT", mRP.UI.notes.general.Select1, "TOPRIGHT", 12, 0 )
	--mRP.UI.notes.general.Label0:SetBackgroundColor(255, 255, 255, 0.3)
	mRP.UI.notes.general.Label0:SetText("Note Title: ");
	mRP.UI.notes.general.Label0:SetHeight( 20 )

	mRP.UI.notes.general.TextField0 = UI.CreateFrame("RiftTextfield", "NoteName", rightParent )
	mRP.UI.notes.general.TextField0:SetPoint("TOPLEFT", mRP.UI.notes.general.Label0, "TOPRIGHT", 8, 0 )
	mRP.UI.notes.general.TextField0:SetWidth(  150 )
	mRP.UI.notes.general.TextField0:SetHeight( 20  )
	mRP.UI.notes.general.TextField0:SetBackgroundColor(255, 255, 255, 0.3)
	mRP.UI.notes.general.TextField0:SetText( "NewNoteTitle" );
	function mRP.UI.notes.general.TextField0.Event:KeyUp()
		local newPname = mRP.UI.notes.general.TextField0:GetText();
		local lenPn = string.len(newPname)
		if( lenPn > 20 ) then --TODO mRP.UI.profile.general.ProfileNameMaxLen ) then
			newPname = string.sub(newPname,1, lenPn-1);
			mRP.UI.notes.general.TextField0:SetText(newPname);
		end
	end

	mRP.UI.notes.general.TextArea1 = UI.CreateFrame("SimpleTextArea", "Cell_SimpleTextArea", rightParent )
	mRP.UI.notes.general.TextArea1:SetPoint("TOPLEFT", mRP.UI.notes.general.Label0, "BOTTOMLEFT", 8, 12 )
	mRP.UI.notes.general.TextArea1:SetPoint("BOTTOMRIGHT", rightParent, "BOTTOMRIGHT", -12, -12)
	mRP.UI.notes.general.TextArea1:SetBorder(1, 1, 1, 1, 1)
	mRP.UI.notes.general.TextArea1:SetText("Cell_1_2 \n asdfds1 \n asdfsdf2")
	function mRP.UI.notes.general.TextArea1.Event:TextAreaChange()
		print("mRP: TextArea1 Changed... ");
		mRP.UI.notes.general.TextArea1:SetBackgroundColor(255, 255, 255, 0.2)
	end
	--
	--mRP.UI.notes.general.Select1View:SetPoint("BOTTOMRIGHT", mRP.UI.notes.general.TextArea1, "BOTTOMLEFT", 12, 0)

    mRP.UI.notes.loaded = true;
end

function mRP.toggleNotesWindow(args)
	if( mRP.UI.notes == nil) then
		mRP.createNotesWindow();
	end
	mRP.UI.notes.Window:SetVisible(not mRP.UI.notes.Window:GetVisible() )
	if( mRP.UI.notes.Window:GetVisible() == true ) then
		mRP.populateNotesWindow(args);
	end
end

-- ---------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------

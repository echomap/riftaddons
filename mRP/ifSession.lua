-- ---------------------------------------------------------------------------------------------------------
-- Welcome to the mRP Addon!
-- ---------------------------------------------------------------------------------------------------------
local AddonData = Inspect.Addon.Detail("mRP")

local mRP = AddonData.data
-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
function mRP.addUserToList()

	--UI.session.general.Select1

end

-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
function mRP.showSessionWindow(args)
	mRP.debugMsg ( "showSessionWindow called" );
	if( mRP.UI.session == nil) then
		mRP.createSessionWindow();
	end
	mRP.UI.session.Window:SetVisible(true )
	mRP.debugMsg ("showSessionWindow done");
	if( mRP.UI.session.Window:GetVisible() == true ) then
		mRP.populateSessionWindow(args);
	end
end

-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
function mRP.populateSessionWindow(args)
	--TODO check if 'dirty'?

	if( args ~= nil ) then
		--args.idx
		--args.parent

		if( args.name ~= nil ) then
			mRP.UI.session.Window:SetTitle("Session: ".. args.name )
			--mRP.UI.session.name = args.name
			mRP.UI.session.general.NewSessionName:SetText( args.name )
			mRP.UI.session.oname = args.name
		end
		if( args.idx ~= nil ) then
			mRP.UI.session.index = args.idx
		end
		if( args.val ~= nil ) then
			local notes = args.val.notes
			mRP.UI.session.general.TextAreaN1:SetText( notes );
		end

		if( args.parent ~= nil ) then
			--mRP.UI.session.Window:SetPoint("TOPLEFT", args.parent, "TOPRIGHT", 24, 0 )
			mRP.UI.session.Window:SetPoint("TOPLEFT", args.parent, "BOTTOMLEFT", 0 , 12 )
		end

	end
	--TODO load session data

end

function mRP.createSessionWindow()
    mRP.UI.session = {}

	if( mRP.UI.Context == nil) then
		mRP.UI.Context     = UI.CreateContext(AddonData.identifier)
	end

    mRP.UI.session.Window  = UI.CreateFrame("SimpleWindow", "MainMRPDataWindow", mRP.UI.Context )

    mRP.UI.session.Window:SetCloseButtonVisible(true)
    mRP.UI.session.Window:SetTitle("Session")
    mRP.UI.session.Window:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 100, 200)
	mRP.UI.session.Window:SetWidth(500)
	mRP.UI.session.Window:SetLayer(5)
    mRP.UI.session.Window:SetVisible(false)

    -- details
	local rightParent = mRP.UI.session.Window
	mRP.UI.session.general = {}

	--TODO name, save, cancel/close, summary, notes, chat
	-- tabs? current, saved? quick? etc?
	--session status: Public, Private, Closed
	--active/planning/archived
	--quick session -- shows current session, text for summary, typing, remember... notes

	-- ROW
	mRP.UI.session.general.LabelCS = UI.CreateFrame("Text", "LabelCD", rightParent )
	mRP.UI.session.general.LabelCS:SetPoint("TOPLEFT", mRP.UI.session.Window:GetContent(), "TOPLEFT", 0, 4)
	mRP.UI.session.general.LabelCS:SetHeight( 20 )
	mRP.UI.session.general.LabelCS:SetBackgroundColor(255, 0, 127, 0.3)
	mRP.UI.session.general.LabelCS:SetText("Session Name:");

	mRP.UI.session.general.NewSessionName = UI.CreateFrame("RiftTextfield", "NPText", rightParent )
	mRP.UI.session.general.NewSessionName:SetPoint("TOPLEFT", mRP.UI.session.general.LabelCS, "TOPRIGHT", 12, 0 )
	mRP.UI.session.general.NewSessionName:SetWidth( 125 )
	mRP.UI.session.general.NewSessionName:SetHeight(20)
	mRP.UI.session.general.NewSessionName:SetBackgroundColor(255, 255, 255, 0.3)
	mRP.UI.session.general.NewSessionName:SetText( "Enter Session" );
	function mRP.UI.session.general.NewSessionName.Event:KeyUp()
		local newPname = mRP.UI.session.general.NewSessionName:GetText();
		local lenPn = string.len(newPname)
		if( lenPn > mRP.settings.SessionNameMaxLen ) then -- TODO
			newPname = string.sub(newPname,1, lenPn-1);
			mRP.UI.session.general.NewSessionName:SetText(newPname);
		end
	end

	mRP.UI.session.general.btnSaveName = UI.CreateFrame("RiftButton", "NPButton", rightParent)
	mRP.UI.session.general.btnSaveName:SetText("Save")
	mRP.UI.session.general.btnSaveName:SetPoint("TOPLEFT", mRP.UI.session.general.NewSessionName, "TOPRIGHT", 24, -6 )
	mRP.UI.session.general.btnSaveName:SetWidth(75)
	function mRP.UI.session.general.btnSaveName.Event:LeftPress()
		mRP.debugMsg("BUTTON SaveSession PRESSED")
		local args = {}
		args.oname = mRP.UI.session.oname
		args.name  = mRP.UI.session.general.NewSessionName:GetText(); --mRP.UI.session.name
		args.idx   = mRP.UI.session.index
		args.notes = mRP.UI.session.general.TextAreaN1:GetText();
		mRP.addSessionToList(args);
	end

	-- start button, end button
	mRP.UI.session.general.btnStart = UI.CreateFrame("RiftButton", "NPButton", rightParent)
	mRP.UI.session.general.btnStart:SetText("Start")
	mRP.UI.session.general.btnStart:SetPoint("TOPLEFT", mRP.UI.session.general.btnSaveName, "TOPRIGHT", 4, 0)
	mRP.UI.session.general.btnStart:SetWidth(60)
	function mRP.UI.session.general.btnStart.Event:LeftPress()
		--TODO
	end

	mRP.UI.session.general.btnEnd = UI.CreateFrame("RiftButton", "NPButton", rightParent)
	mRP.UI.session.general.btnEnd:SetText("Stop")
	mRP.UI.session.general.btnEnd:SetPoint("TOPLEFT", mRP.UI.session.general.btnStart, "TOPRIGHT", 4, 0 )
	mRP.UI.session.general.btnEnd:SetWidth(60)
	function mRP.UI.session.general.btnEnd.Event:LeftPress()
		--TODO
	end

	--TODO whos taking part
	--TODO session to switch to

	--mRP.UI.session.general.LabelU = UI.CreateFrame("Text", "Label1", rightParent )
	--mRP.UI.session.general.LabelU:SetPoint("TOPLEFT", mRP.UI.session.general.LabelCS, "BOTTOMLEFT" , 0, 4)
	--mRP.UI.session.general.LabelU:SetText("Users");

	mRP.UI.session.general.SelectSSV1 = UI.CreateFrame("SimpleScrollView", "SelctProfile", rightParent )
	mRP.UI.session.general.SelectSSV1:SetPoint("TOPLEFT", mRP.UI.session.general.LabelCS, "BOTTOMLEFT" , 0, 4)
	mRP.UI.session.general.SelectSSV1:SetWidth(  125 )
	mRP.UI.session.general.SelectSSV1:SetHeight( 300  )
	mRP.UI.session.general.SelectSSV1:SetBorder(1, 1, 1, 1, 1)
	mRP.UI.session.general.SelectSSV1:SetBackgroundColor(255, 255, 255, 0.3)

	mRP.UI.session.general.Select1 = UI.CreateFrame("SimpleList", "SelectUsers", mRP.UI.session.general.SelectSSV1 )
	mRP.UI.session.general.Select1.Event.ItemSelect = function(item, value, index)--function(view, item)
		mRP.debugMsg("ItemSelect Users: (",item,")"," value=", dump(value), " idx: ", index)
		-- TODO
	end
	mRP.UI.session.general.Select1.Event.ItemClick = function(item, value, index)--function(view, item)
		mRP.debugMsg("ItemClick Users: (",item,")"," value=", dump(value), " idx: ", index)
		-- TODO
		--toggleActorWindow( item,  value, index)
	end
	--mRP.UI.session.general.Select1.Event.ItemClickR = function(item, value, index)--function(view, item)
	--	mRP.debugMsg("ItemClickRR Users: (",item,")"," value=", dump(value), " idx: ", index)
	--	-- TODO
	--end
	--local name = "mRP_Select1"
	--mRP.UI.session.general.Select1:EventAttach(Event.UI.Input.Mouse.Right.Down, function (self)
	--	mRP.debugMsg("User list right button pressed")
	--end, name .. "._RightDown")
	mRP.UI.session.general.SelectSSV1:SetContent( mRP.UI.session.general.Select1 )

	--TODO button to add target, remove, add typed name
	--
	mRP.UI.session.general.Frame1  = UI.CreateFrame("Frame", "mRPGeneralWindow", rightParent );
	mRP.UI.session.general.Frame1:SetPoint("TOPLEFT", mRP.UI.session.general.Select1, "TOPRIGHT", 4, 0 )
	mRP.UI.session.general.Frame1:SetPoint("BOTTOMRIGHT", mRP.UI.session.Window:GetContent(), "BOTTOMRIGHT", 0, 0)
	local inFrameAsParent = mRP.UI.session.general.Frame1

	mRP.UI.session.general.LabelU1 = UI.CreateFrame("Text", "Label1", inFrameAsParent )
	mRP.UI.session.general.LabelU1:SetPoint("TOPLEFT", mRP.UI.session.general.Frame1, "TOPLEFT" , 4, 0)
	mRP.UI.session.general.LabelU1:SetWidth( mRP.UI.session.general.Frame1:GetWidth() -4 )
	mRP.UI.session.general.LabelU1:SetHeight( 20 )
	mRP.UI.session.general.LabelU1:SetBackgroundColor(0.9, 0.0, 0.9, 0.3)
	mRP.UI.session.general.LabelU1:SetText("Users");

	-- ROW
	mRP.UI.session.general.userBtn1 = UI.CreateFrame("RiftButton", "UButton1", rightParent)
	mRP.UI.session.general.userBtn1:SetText("Add Target")
	mRP.UI.session.general.userBtn1:SetPoint("TOPLEFT", mRP.UI.session.general.LabelU1, "BOTTOMLEFT", 0, 4 )
	--mRP.UI.session.general.userBtn1:SetWidth(75)
	function mRP.UI.session.general.userBtn1.Event:LeftPress()
		mRP.debugMsg("BUTTON AddTarget PRESSED")
		--mRP.addUserToList()
		local detail = Inspect.Unit.Detail("player.target")
		mRP.debugMsg("Detail: ", dump(detail) );
		if( detail == nil) then
			print("mRP: no target to get details of");
			return;
		end

		if( detail.availability ~= "full") then
			print("mRP: target invalid, try again.");
			return;
		end

		local s1Items  = mRP.UI.session.general.Select1:GetItems();
		local s1Values = mRP.UI.session.general.Select1:GetValues();
		if( s1Items  == nil ) then	s1Items  = {} end
		if( s1Values == nil ) then	s1Values = {} end

		table.insert(s1Items,  detail.name)
		table.insert(s1Values, detail )

		mRP.UI.session.general.Select1:SetItems(s1Items, s1Values)

	end
	mRP.UI.session.general.userBtn2 = UI.CreateFrame("RiftButton", "UButton1", rightParent)
	mRP.UI.session.general.userBtn2:SetText("Remove")
	mRP.UI.session.general.userBtn2:SetPoint("TOPLEFT", mRP.UI.session.general.userBtn1, "TOPRIGHT", 4, 0 )
	--mRP.UI.session.general.userBtn2:SetWidth(75)
	function mRP.UI.session.general.userBtn2.Event:LeftPress()
		mRP.debugMsg("BUTTON User2 PRESSED")
		-- TODO find index, remove name/details
	end

	-- ROW
	mRP.UI.session.general.userBtn3 = UI.CreateFrame("RiftButton", "UButton1", rightParent)
	mRP.UI.session.general.userBtn3:SetText("Add Name")
	mRP.UI.session.general.userBtn3:SetPoint("TOPLEFT", mRP.UI.session.general.userBtn1, "BOTTOMLEFT", 0,  4 )
	--mRP.UI.session.general.userBtn3:SetWidth(100)
	function mRP.UI.session.general.userBtn3.Event:LeftPress()
		mRP.debugMsg("BUTTON User3 PRESSED")
		local txt = mRP.UI.session.general.userNameTxt:GetText();

		local s1Items  = mRP.UI.session.general.Select1:GetItems();
		local s1Values = mRP.UI.session.general.Select1:GetValues();

		table.insert(s1Items,  txt)
		table.insert(s1Values, {} )

		mRP.UI.session.general.Select1:SetItems(s1Items, s1Values)
	end

	mRP.UI.session.general.userNameTxt = UI.CreateFrame("RiftTextfield", "Label1", inFrameAsParent )
	mRP.UI.session.general.userNameTxt:SetPoint("TOPLEFT", mRP.UI.session.general.userBtn3, "TOPRIGHT" , 4, 2)
	mRP.UI.session.general.userNameTxt:SetWidth( mRP.UI.session.general.Frame1:GetWidth() - mRP.UI.session.general.userBtn3:GetWidth() )
	mRP.UI.session.general.userNameTxt:SetHeight( 20 )
	mRP.UI.session.general.userNameTxt:SetBackgroundColor(1.0, 1.0, 1.0, 0.3)
	mRP.UI.session.general.userNameTxt:SetText("Enter Name to Add");

	-- ROW
	mRP.UI.session.general.userBtnRn = UI.CreateFrame("RiftButton", "UButton1", rightParent)
	mRP.UI.session.general.userBtnRn:SetText("Rename To->")
	mRP.UI.session.general.userBtnRn:SetPoint("TOPLEFT", mRP.UI.session.general.userBtn3, "BOTTOMLEFT", 0,  4 )
	--mRP.UI.session.general.userBtnRn:SetWidth(100)
	function mRP.UI.session.general.userBtnRn.Event:LeftPress()
		mRP.debugMsg("BUTTON ReName PRESSED")
		local txt = mRP.UI.session.general.reNameTxt:GetText();
		local selItm   = mRP.UI.session.general.Select1:GetSelectedItem();
		local selVal   = mRP.UI.session.general.Select1:GetSelectedValue();
		local s1Items  = mRP.UI.session.general.Select1:GetItems();
		local s1Values = mRP.UI.session.general.Select1:GetValues();
		local selIdx   = mRP.UI.session.general.Select1:GetSelectedIndex();

		table.remove(s1Items,  selIdx )
		table.remove(s1Values, selIdx )

		table.insert(s1Items,  txt )
		table.insert(s1Values, selVal )

		mRP.UI.session.general.Select1:SetItems(s1Items, s1Values)
	end

	mRP.UI.session.general.reNameTxt = UI.CreateFrame("RiftTextfield", "Label1", inFrameAsParent )
	mRP.UI.session.general.reNameTxt:SetPoint("TOPLEFT", mRP.UI.session.general.userBtnRn, "TOPRIGHT" , 4, 2)
	mRP.UI.session.general.reNameTxt:SetWidth( mRP.UI.session.general.Frame1:GetWidth() - mRP.UI.session.general.userBtn3:GetWidth() )
	mRP.UI.session.general.reNameTxt:SetHeight( 20 )
	mRP.UI.session.general.reNameTxt:SetBackgroundColor(1.0, 1.0, 1.0, 0.3)
	mRP.UI.session.general.reNameTxt:SetText("Enter New Name");


	-- ROW
	--Chat text area to speak/notes in
	mRP.UI.session.general.LabelC = UI.CreateFrame("Text", "Label1", inFrameAsParent )
	--mRP.UI.session.general.LabelC:SetPoint("TOPLEFT", mRP.UI.session.general.Frame1, "TOPLEFT" , 4, 0)
	mRP.UI.session.general.LabelC:SetPoint("TOPLEFT", mRP.UI.session.general.userBtnRn, "BOTTOMLEFT" , 0, 4)
	mRP.UI.session.general.LabelC:SetWidth( mRP.UI.session.general.Frame1:GetWidth() -4 )
	mRP.UI.session.general.LabelC:SetBackgroundColor(0.9, 0.0, 0.9, 0.3)
	mRP.UI.session.general.LabelC:SetText("Chat");

	mRP.UI.session.general.TextAreaC1 = UI.CreateFrame("SimpleTextArea", "Cell_SimpleTextArea", inFrameAsParent )
	mRP.UI.session.general.TextAreaC1:SetPoint("TOPLEFT", mRP.UI.session.general.LabelC, "BOTTOMLEFT", 0, 4 )
	mRP.UI.session.general.TextAreaC1:SetWidth( mRP.UI.session.general.Frame1:GetWidth() - 4 )
	mRP.UI.session.general.TextAreaC1:SetHeight( 50 )
	mRP.UI.session.general.TextAreaC1:SetBorder(1, 1, 1, 1, 1)
	mRP.UI.session.general.TextAreaC1:SetBackgroundColor(1, 1, 1, 0.2)
	mRP.UI.session.general.TextAreaC1:SetText("Do you sparkle?")

	mRP.UI.session.general.chatButton1 = UI.CreateFrame("RiftButton", "NPButton1", rightParent)
	mRP.UI.session.general.chatButton1:SetText("Send")
	mRP.UI.session.general.chatButton1:SetPoint("TOPLEFT", mRP.UI.session.general.TextAreaC1, "BOTTOMLEFT", 0, 4 )
	--mRP.UI.session.general.chatButton1:SetWidth(100)
	function mRP.UI.session.general.chatButton1.Event:LeftPress()
		-- TOOD
	end

	mRP.UI.session.general.chatButton2 = UI.CreateFrame("RiftButton", "NPButton2", rightParent)
	mRP.UI.session.general.chatButton2:SetText("Clear")
	mRP.UI.session.general.chatButton2:SetPoint("TOPLEFT", mRP.UI.session.general.chatButton1, "TOPRIGHT", 4, 0 )
	--mRP.UI.session.general.chatButton2:SetWidth(100)
	function mRP.UI.session.general.chatButton2.Event:LeftPress()
		-- TOOD
	end

	mRP.UI.session.general.chatCb1 = UI.CreateFrame("SimpleCheckbox", "CB1", rightParent)
	mRP.UI.session.general.chatCb1:SetText("Say")
	mRP.UI.session.general.chatCb1:SetLabelPos("left")
	mRP.UI.session.general.chatCb1:SetPoint("TOPLEFT", mRP.UI.session.general.chatButton1, "BOTTOMLEFT", 0, 4 )

	mRP.UI.session.general.chatCb2 = UI.CreateFrame("SimpleCheckbox", "CB2", rightParent)
	mRP.UI.session.general.chatCb2:SetText("Tell")
	mRP.UI.session.general.chatCb2:SetLabelPos("left")
	mRP.UI.session.general.chatCb2:SetPoint("TOPLEFT", mRP.UI.session.general.chatCb1, "TOPRIGHT", 4, 0 )

	mRP.UI.session.general.chatCb3 = UI.CreateFrame("SimpleCheckbox", "CB3", rightParent)
	mRP.UI.session.general.chatCb3:SetText("Channel")
	mRP.UI.session.general.chatCb3:SetLabelPos("left")
	mRP.UI.session.general.chatCb3:SetPoint("TOPLEFT", mRP.UI.session.general.chatCb2, "TOPRIGHT", 4, 0 )

	-- send to what?

	--
	local postChatAnchor = mRP.UI.session.general.chatCb1

	--Notes
	mRP.UI.session.general.LabelN1 = UI.CreateFrame("Text", "Label1", inFrameAsParent )
	mRP.UI.session.general.LabelN1:SetPoint("TOPLEFT", postChatAnchor, "BOTTOMLEFT" , 0, 4)
	mRP.UI.session.general.LabelN1:SetBackgroundColor(0.8, 0.0, 0.9, 0.3)
	mRP.UI.session.general.LabelN1:SetWidth( mRP.UI.session.general.Frame1:GetWidth() -4 )
	mRP.UI.session.general.LabelN1:SetText("Notes");

	mRP.UI.session.general.TextAreaN1 = UI.CreateFrame("SimpleTextArea", "Cell_SimpleTextArea", inFrameAsParent )
	mRP.UI.session.general.TextAreaN1:SetPoint("TOPLEFT", mRP.UI.session.general.LabelN1, "BOTTOMLEFT", 0, 4 )
	mRP.UI.session.general.TextAreaN1:SetPoint("BOTTOMRIGHT", mRP.UI.session.Window:GetContent(), "BOTTOMRIGHT", -2, -12)
	mRP.UI.session.general.TextAreaN1:SetBorder(1, 1, 1, 1, 1)
	mRP.UI.session.general.TextAreaN1:SetBackgroundColor(1, 1, 1, 0.2)
	mRP.UI.session.general.TextAreaN1:SetText("I walked into a tavern and saw these two' roleplaying' \nwhat looks to be a dark-vampire and the girl who still \nloves him trope. \nLet's have some fun.")

	--
    mRP.UI.session.loaded = true;
end

function mRP.toggleSessionWindow(args)
	if( mRP.UI.session == nil) then
		mRP.createSessionWindow();
	end
	mRP.UI.session.Window:SetVisible(not mRP.UI.session.Window:GetVisible() )
	if( mRP.UI.session.Window:GetVisible() == true ) then
		mRP.populateSessionWindow(args);
	end
end

-- ---------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------

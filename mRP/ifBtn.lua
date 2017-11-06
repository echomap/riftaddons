-- ---------------------------------------------------------------------------------------------------------
-- Welcome to the mRP Addon!
-- ---------------------------------------------------------------------------------------------------------
local AddonData = Inspect.Addon.Detail("mRP")

local mRP = AddonData.data
-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
function mRP.showBtnWindow(args)
	mRP.debugMsg ( "showBtnWindow called" );
	if( mRP.UI.btn == nil) then
		mRP.createBtnWindow();
	end
	mRP.UI.btn.Window:SetVisible(true )
	mRP.debugMsg ("showBtnWindow done");
	if( mRP.UI.btn.Window:GetVisible() == true ) then
		mRP.populateBtnWindow(args);
	end
end

-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
function mRP.populateBtnWindow(args)

end

function mRP.createSubZButton(k,bname,bparent,bobject,buttonSize)
    --mRP.UI.btn.Window.subButton3 = UI.CreateFrame ('Frame', name .. '.SubButton ' .. k,  mRP.UI.btn.Window )
    bobject.border = UI.CreateFrame("Texture", '.SubButton' .. k .. '.border', bobject)
    bobject.border:SetTextureAsync('Rift', 'HeaderButton_Normal_Down.png.dds' )
    bobject.border:SetLayer(1)
    bobject.border:SetPoint("TOPLEFT", bobject, "TOPLEFT")
    bobject.border:SetPoint("BOTTOMRIGHT", bobject, "BOTTOMRIGHT")
    bobject.Label1 = UI.CreateFrame("Text", "Label1G", bobject )
    bobject.Label1:SetPoint("TOPLEFT", bobject, "TOPLEFT")
    bobject.Label1:SetWidth( buttonSize )
    bobject.Label1:SetHeight( 20 )
    bobject.Label1:SetText( bname );
    bobject.Label1:SetLayer(5)
    bobject:SetWidth(buttonSize-8)
    bobject:SetHeight(buttonSize-8)
    bobject:SetPoint("TOPLEFT", bparent, "BOTTOMLEFT", 0, 2)
    bobject.tooltip = UI.CreateFrame("SimpleTooltip", "MyTooltip", bparent)
    bobject.tooltip:InjectEvents(bobject, function() return bname end)
end

function mRP.createBtnWindow()
    mRP.UI.btn = {}

	if( mRP.UI.Context == nil) then
		mRP.UI.Context     = UI.CreateContext(AddonData.identifier)
		--mRP.UI.Context:SetStrata("topmost")
	end

    --mRP.UI.btn.Window  = UI.CreateFrame("SimpleWindow", "MainMRPDataWindow", mRP.UI.Context )
    ----mRP.UI.btn.Window:SetCloseButtonVisible(true)
    --mRP.UI.btn.Window:SetTitle("mRP")
    --mRP.UI.btn.Window:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 100, 200)
    --mRP.UI.btn.Window:SetWidth(50)
    --mRP.UI.btn.Window:SetHeight(200)
    --mRP.UI.btn.Window:SetVisible(false)
    ----mRP.UI.profile.Tabbed:SetTabContentBackgroundColor(255, 255, 255, 0)

    local name = "mRP"
    local scale = 100
    local buttonSize = 52 * (scale / 100) --48
	local iconSize   = 36 * (scale / 100)
	local mouseDown  = false
	local locked     = false
    local maxK       = 5 --
    local divK       = 5 --

    mRP.buttonX = 100
    mRP.buttonY = 200

	local FirstButtonOffSetX = 4
	local FirstButtonOffSetY = 40

    mRP.UI.btn.Window = UI.CreateFrame ('Frame', "mRP", mRP.UI.Context ) --uiElements.contextSecure)
    mRP.UI.btn.Window:SetVisible(false)
    mRP.UI.btn.Window:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 100, 200)

	--function mRP.UI.btn.Window:EventKeyPressed(handle,key)
	--  print("Frame " .. self:GetName() .. " key hit: '".. key.. "'")
	--end
	--mRP.UI.btn.Window:EventAttach(Event.UI.Input.Key.Up, mRP.UI.btn.Window.EventKeyPressed, "keypressed",-2)

    local WLeft = 100;
    local WTop  = 200;
    if( mRPSetup~= nil and mRPSetup.btn ~= nil ) then
        if( mRPSetup.btn.left ~= nil and mRPSetup.btn.left > 0 ) then
            WLeft = mRPSetup.btn.left;
        end
        if( mRPSetup.btn.top ~= nil and mRPSetup.btn.top > 0 ) then
            WTop = mRPSetup.btn.top;
        end
    end
    mRP.UI.btn.Window:SetPoint("TOPLEFT", UIParent, "TOPLEFT", WLeft, WTop)
    --mRP.UI.btn.Window:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 100, 200)

    mRP.UI.btn.Window.border = UI.CreateFrame ('Texture', name .. '.Border', mRP.UI.btn.Window)
    mRP.UI.btn.Window.border:SetTextureAsync("Rift", "HeaderButton_Normal_Down.png.dds")
    mRP.UI.btn.Window.border:SetPoint("TOPLEFT",     mRP.UI.btn.Window, "TOPLEFT")
    mRP.UI.btn.Window.border:SetPoint("BOTTOMRIGHT", mRP.UI.btn.Window, "BOTTOMRIGHT")
    mRP.UI.btn.Window.border:SetLayer(1)

    --if nkWSetup.border == false then
        --mRP.UI.btn.Window.border:SetVisible(false)
        --mRP.UI.btn.Window:SetBackgroundColor(0, 0, 0, 1)
        --iconSize = buttonSize
    --end
    mRP.UI.btn.Window:SetWidth(buttonSize)
    mRP.UI.btn.Window:SetHeight( (buttonSize+divK) * maxK + 12)
    --mRP.UI.btn.Window:SetPoint ("TOPRIGHT", UIParent, "TOPRIGHT", 100, 200) --nkWSetup.buttonX, nkWSetup.buttonY)

    --local icon = "CharacterSheet_I1DB.dds"
	--mRP.UI.btn.Window.icon = UI.CreateFrame ('Texture', name .. '.Icon', mRP.UI.btn.Window)
	--mRP.UI.btn.Window.icon:SetTextureAsync("Rift", icon)
	--mRP.UI.btn.Window.icon:SetWidth(iconSize)
	--mRP.UI.btn.Window.icon:SetHeight(iconSize)
	--mRP.UI.btn.Window.icon:SetPoint("CENTER", mRP.UI.btn.Window, "CENTER")
	----mRP.UI.btn.Window.icon:SetSecureMode('restricted')
	--mRP.UI.btn.Window.icon:SetLayer(2)

	mRP.UI.btn.Window:EventAttach(Event.UI.Input.Mouse.Right.Down, function (self)
		if not locked then mouseDown = true end
	end, name .. "._RightDown")
		mRP.UI.btn.Window:EventAttach(Event.UI.Input.Mouse.Cursor.Move, function (self)
		if Inspect.System.Secure() == false and mouseDown == true then
			local mouseData = Inspect.Mouse()

			local curdivX = mouseData.x - mRP.UI.btn.Window:GetLeft()
			local curdivY = mouseData.y - mRP.UI.btn.Window:GetTop()

			mRP.buttonX = mRP.buttonX + curdivX
			mRP.buttonY = mRP.buttonY + curdivY
			--mRP.debugMsg ( "Move: buttonX: " , mRP.buttonX, " mRP.buttonY: ", mRP.buttonY );
			--TODO to a saved variable..

			mRP.UI.btn.Window:SetPoint ("TOPLEFT", UIParent, "TOPLEFT", mRP.buttonX, mRP.buttonY)
		end
	end, name .. "._CursorMove")

	mRP.UI.btn.Window:EventAttach(Event.UI.Input.Mouse.Right.Up, function (self)
		mouseDown = false
	end, name .. "._RightUp")

	mRP.UI.btn.Window:EventAttach(Event.UI.Input.Mouse.Right.Upoutside , function ()
		mouseDown = false
	end, name .. "._RightUpOutside")

    --mRP.UI.btn.Window2 = UI.CreateFrame ('Frame', "mRP", mRP.UI.Context ) --uiElements.contextSecure)
    --mRP.UI.btn.Window2:SetPoint("TOPLEFT", mRP.UI.btn.Window, "TOPLEFT", 4, 4)
    --mRP.UI.btn.Window2:SetPoint("BOTTOMRIGHT", mRP.UI.btn.Window, "BOTTOMRIGHT", -4, -4 )
    --mRP.UI.btn.Window2:SetLayer(3)

    local mode = 1 -- vertical TODO
    local k = 0
	local bname   = "Profile"
    local bparent =mRP.UI.btn.Window

	k = 1
	mRP.UI.btn.Window.subButton1 = UI.CreateFrame ('Frame', name .. '.SubButton ' .. k,  mRP.UI.btn.Window )
	bparent = mRP.UI.btn.Window
	bname   = "Profile"
	mRP.createSubZButton(k,bname,bparent,mRP.UI.btn.Window.subButton1,buttonSize)
	mRP.UI.btn.Window.subButton1:EventAttach(Event.UI.Input.Mouse.Left.Click, function (self)
		if Inspect.System.Secure() == false then
            mRP.toggleProfileWindow();
		end
	end, "mRP".. k .. "LeftClick")
	--SHframeX, SHframeY)
	mRP.UI.btn.Window.subButton1:SetPoint("TOPLEFT", mRP.UI.btn.Window, "TOPLEFT", FirstButtonOffSetX, FirstButtonOffSetY) --4, 32)

	k = 2
	mRP.UI.btn.Window.subButton2 = UI.CreateFrame ('Frame', name .. '.SubButton ' .. k,  mRP.UI.btn.Window )
	bparent = mRP.UI.btn.Window.subButton1
	bname   = "Search"
	mRP.createSubZButton(k,bname,bparent,mRP.UI.btn.Window.subButton2,buttonSize)
	mRP.UI.btn.Window.subButton2:EventAttach(Event.UI.Input.Mouse.Left.Click, function (self)
		if Inspect.System.Secure() == false then
            mRP.toggleSearchWindow();
			--button.icon:SetTexture ("Rift", subIconPath)
			--button:ToggleButtons()
		end
	end, "mRP".. k .. "LeftClick")


	k = 3
	mRP.UI.btn.Window.subButton3 = UI.CreateFrame ('Frame', name .. '.SubButton ' .. k,  mRP.UI.btn.Window )
	bparent = mRP.UI.btn.Window.subButton2
	bname   = "Sessions"
	mRP.createSubZButton(k,bname,bparent,mRP.UI.btn.Window.subButton3,buttonSize)
    mRP.UI.btn.Window.subButton3:EventAttach(Event.UI.Input.Mouse.Left.Click, function (self)
		if Inspect.System.Secure() == false then
            mRP.toggleSessionsWindow();
		end
	end, "mRP".. k .. "LeftClick")

	k = 4
	mRP.UI.btn.Window.subButton4 = UI.CreateFrame ('Frame', name .. '.SubButton ' .. k,  mRP.UI.btn.Window )
	bparent = mRP.UI.btn.Window.subButton3
	bname   = "Notes"
	mRP.createSubZButton(k,bname,bparent,mRP.UI.btn.Window.subButton4,buttonSize)
    mRP.UI.btn.Window.subButton4:EventAttach(Event.UI.Input.Mouse.Left.Click, function (self)
		if Inspect.System.Secure() == false then
            mRP.toggleNotesWindow();
		end
	end, "mRP".. k .. "LeftClick")

	k = 5
	mRP.UI.btn.Window.subButton5 = UI.CreateFrame ('Frame', name .. '.SubButton ' .. k,  mRP.UI.btn.Window )
	bparent = mRP.UI.btn.Window.subButton4
	bname   = "Help"
	mRP.createSubZButton(k,bname,bparent,mRP.UI.btn.Window.subButton5,buttonSize)
    mRP.UI.btn.Window.subButton5:EventAttach(Event.UI.Input.Mouse.Left.Click, function (self)
		if Inspect.System.Secure() == false then
            mRP.toggleHelpWindow();
		end
	end, "mRP".. k .. "LeftClick")


    -- details

    mRP.UI.btn.loaded = true;
end

function mRP.toggleBtnWindow(args)
    --mRP.debugMsg ( "toggleBtnWindow called" );
	if( mRP.UI.btn == nil) then
		mRP.createBtnWindow();
	end
	mRP.UI.btn.Window:SetVisible(not mRP.UI.btn.Window:GetVisible() )
    mRP.UI.btn.Window.subButton1:SetVisible(  mRP.UI.btn.Window:GetVisible() )
	if( mRP.UI.btn.Window:GetVisible() == true ) then
		mRP.populateBtnWindow(args);
	end
end

-- ---------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------

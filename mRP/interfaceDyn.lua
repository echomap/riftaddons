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
	mRP.debugMsg ("hideWindows Called XX");
	for k,v in pairs(mRP.UI.ShowUIList) do
		mRP.debugMsg ("mRP: toglge vis: " ..v:GetTitle() );
		v:SetVisible(false)
	end
	if(mRP.UI.helperMain ~= nil) then mRP.UI.helperMain:SetVisible(false) end;
end

-- ---------------------------------------------------------------------------------------------------------
function mRP.toggleMainWindow()
	mRP.debugMsg ("toggleMainWindow Called XX");
end

--function mRP.SetupMainWindow()
--	mRP.debugMsg ("SetupMainWindow Called XX") -- inited? "..  mRP.Initialized);
--end
-- ---------------------------------------------------------------------------------------------------------
function mRP.selectItem1(item, value, index) -- view, item)
	print( "ItemSelect("..value..")" )

end

function mRP.windowClosed1()
	print("Window closed XX")
	mRP.UI.visibleNow = false
end

function mRP.selectionChange1()
    print("selectionChange1 called XX")
end

-- ---------------------------------------------------------------------------------------------------------
local function userTargetChanged(abilities)
	print("userTargetChanged called XX")
	--if( not mRP.UI.visibleNow) then
	--	return
	--end
    --mRP.debugMsg("userTargetChanged called");
end
-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------


-- ---------------------------------------------------------------------------------------------------------

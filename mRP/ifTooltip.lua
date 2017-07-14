-- ---------------------------------------------------------------------------------------------------------
-- Welcome to the mRP Addon!
-- ---------------------------------------------------------------------------------------------------------
local AddonData = Inspect.Addon.Detail("mRP")

local mRP = AddonData.data
-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
-- Acknowledgement: The basic framework for this functionality was borrowed
-- from the ImhoBags AddOn and ItemRarity

function mRP.createTooltipWindow()
	if( mRP.UI.Context == nil) then
		mRP.UI.Context     = UI.CreateContext(AddonData.identifier)
	end
	if( mRP.tooltip == nil ) then
		mRP.tooltip = {}
	end
	if( mRP.tooltip.init) then
		return
	end
	mRP.tooltip.window = UI.CreateFrame("Text", "mRP_Tooltip", mRP.UI.Context )
	--mRP.tooltip.window:SetStrata("topmost")
	mRP.tooltip.window:SetLayer(99)
	mRP.tooltip.window:SetVisible(false)
	mRP.tooltip.window:SetBackgroundColor(0.8, 0.0, 0.0, 0.8)
	--mRP.tooltip.window:SetBorder(1, 1, 1, 1, 1)
	--Texture?

	--local stratas = mRP.tooltip.window:GetStrataList()
	--mRP.debugMsg("stratas: ", stratas, " dump:", dump(stratas) )

	mRP.tooltip.padding = 10
	mRP.tooltip.verticalOffset = 0
	mRP.tooltip.init = true;
end

function mRP.displayTooltip(tooltipText)
	mRP.createTooltipWindow();

	local left, top, right, bottom = UI.Native.Tooltip:GetBounds()
	local screenHeight = UIParent:GetHeight()
	local height       = mRP.tooltip.window:GetHeight()

	mRP.tooltip.window:SetText(tooltipText)
	mRP.tooltip.window:SetVisible(true)
	mRP.tooltip.window:ClearAll()
	mRP.tooltip.window:SetPoint("TOPLEFT",  UI.Native.Tooltip, "BOTTOMLEFT",   mRP.tooltip.padding, mRP.tooltip.verticalOffset)
	mRP.tooltip.window:SetPoint("TOPRIGHT", UI.Native.Tooltip, "BOTTOMRIGHT", -mRP.tooltip.padding, mRP.tooltip.verticalOffset)
end

function mRP.mRPTooltip(ttype, shown, buff)
	--mRP.debugMsg("mRPTooltip Called. ttype:", dump(ttype), " shown: ", shown, " buff:" , buff)
	mRP.createTooltipWindow();
	mRP.tooltip.window:SetVisible(false)
	if(not (ttype and shown)) then
		return
	end
	--mRP.debugMsg("mRPTooltip ttype: ", dump(ttype) , " shown:'", shown, "' buff: '" , buff, ",")
	if(not (ttype == "unit" or ttype == "unittype" or shown == "unit") ) then
		return
	end
	local detail = Inspect.Unit.Detail(ttype)
	--local next = next
	if next(detail) == nil then
	   -- Table is empty
	   detail = Inspect.Unit.Detail(buff)
	end

	if( detail == nil) then
		return;
	end
	if next(detail) == nil then
	   -- Table is empty
		return
	end
	--mRP.debugMsg("mRPTooltip got detail as ", dump(detail) )

	local ttText = "Querying..."

	if(mRP.settings.queryforTooltips == true) then
		-- Check cache
		local cdata = mRP.cache.actors[id]
		if(cdata ~= nil) then
			local rps = cdata.rpstatus
			if(rps == nil) then
				ttText = "None"
			elseif rps > 0 then
				ttText = "has mRP"
			end
			--elseif rps == 1 thenttText = "OOC"
			--elseif rps == 2 then ttText = "In Character"
			--elseif rps == 3 then ttText = "Looking for RP"
			--else ttText = "None"
			--end
			mRP.displayTooltip("RP:" ..ttText)
		else
			--ifSearch
			--TODO check that aren't already asking them about themselves
			mRP.debugMsg("mRPTooltip doQueryRP to " ..(detail.name) )
			mRP.doQueryRP(detail.name)
		end
		--
		mRP.displayTooltip("RP:" ..ttText)
	end
end

-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
--Signals that the tooltip has changed
Command.Event.Attach(Event.Tooltip, mRP.mRPTooltip, "mRP Tooltip Info")
--table.insert(Event.Tooltip, {mRP.mRPTooltip, "ItemRarity", "mrpTooltip"})
-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------

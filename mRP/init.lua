-- Welcome to the mRP Addon!
--
-- ---------------------------------------------------------------------------------------------------------
-- BOOTSTRAP FUNCTIONS AND CALLS
-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
local AddonData = Inspect.Addon.Detail("mRP")
local mRP = AddonData.data
mRP.debugMode = true

function string.starts(String,Start)
	if ( String == nil ) then  return false end
	return string.sub(String,1,string.len(Start))==Start
end
function mRP.isempty(s)
  return s == nil or s == ''
end
-- ---------------------------------------------------------------------------------------------------------
--http://stackoverflow.com/questions/22123970/in-lua-how-to-get-all-arguments-including-nil-for-variable-number-of-arguments
-- ---------------------------------------------------------------------------------------------------------
function table.pack(...)
    return { n = select("#", ...); ... }
end

function show(...)
    local stringL = ""
    local args = table.pack(...)
    for i = 1, args.n do
        stringL = stringL .. tostring(args[i]) .. "\t"
    end
	--if( string.len(stringL)> 1 ) then
    --	return stringL .. "\n"
	--else
	--	return "";
	--end
	return stringL
end
-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
function mRP.debugMsg(...)
	if mRP.debugMode then
		local vshow = "mRP: "..show(...)
		if( string.len(vshow) > 2 ) then
			print(vshow) --show(...))
		end
	end
end
-- ---------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------

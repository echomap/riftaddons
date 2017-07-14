if not LibSlashCmd then
    LibSlashCmd = { storage = {} }
end

-- Returns successfully registered command name. If registration was unsuccessful, it will return nil.
function LibSlashCmd.Register(commandName, addonName, dbg)
    dbg = dbg or false
    local finalCommandName = commandName
    
    if LibSlashCmd.storage[commandName] then -- commandName already registered - let's try to find a replacement
        local i = 0
        for i = 2, 9999 do -- Attempting to see if commandName2-9999 are available.
            newCommandName = commandName .. i
            if not LibSlashCmd.storage[newCommandName] then -- newCommandName was available. Using that instead of commandName.
                finalCommandName = newCommandName
                break
            end
        end
        if finalCommandName == commandName then -- commandName is not available and no replacement was found. Thus, we are unable to register the commandName
            finalCommandName = nil
        end
    end
    
    if finalCommandName ~= nil then
        local next = next
        if next(Command.Slash.Register(finalCommandName)) ~= nil then -- Command exists outside of LibSlashCmd.
            LibSlashCmd.storage[finalCommandName] = {} -- Make LibSlashCmd aware of the non-LibSlashCmd command so we can handle clashing.
            return LibSlashCmd.Register(commandName, addonName, dbg)
        end
        LibSlashCmd.storage[finalCommandName] = {}
        LibSlashCmd.storage[finalCommandName]['funcs'] = {}
        LibSlashCmd.storage[finalCommandName]['config'] = {}
        table.insert(Command.Slash.Register(finalCommandName), {
                                                                function(args) -- This is the function for handling commands. It has to be a function here or else we can not access finalCommandName
                                                                    local commandName = finalCommandName
                                                                    if commandName == nil or not LibSlashCmd.storage[commandName] then -- If it's a nil commandName(i.e. Register failed) or it doesn't exist in our storage, then we won't do anything. Return an error message only if we are told to debug.
                                                                        return
                                                                    end
                                                                    
                                                                    local func = LibSlashCmd.storage[commandName]['funcs'][args]
                                                                    local fallbackFunc = LibSlashCmd.storage[commandName]['funcs']['_fallback']
                                                                    local userInput = {}
                                                                    
                                                                    if not func then -- Args don't exist OR there is user input.
                                                                        local funcFound = false
                                                                        local keyLength = 0
                                                                        for key,value in pairs(LibSlashCmd.storage[commandName]['funcs']) do -- Let's see if we can find a valid command amongst the arguments
                                                                            keyLength = string.len(key)
                                                                            if string.len(args) > keyLength then
                                                                                local tmpString = string.sub(args, 1, keyLength)
                                                                                
                                                                                if tmpString == key then -- Set func to valid function if possible
                                                                                    func = LibSlashCmd.storage[commandName]['funcs'][key]
                                                                                    funcFound = true
                                                                                    break
                                                                                end
                                                                            end
                                                                        end
                                                                        
                                                                        local userInputTmp = {} -- Now we'll get all other (non function) user input and store it in an array
                                                                        if not funcFound then
                                                                            userInputTmp = string.sub(args, 1)
                                                                        else
                                                                            userInputTmp = string.sub(args, keyLength + 2)
                                                                        end
                                                                        
                                                                        local token = nil
                                                                        local numArgs = 0
                                                                        for token in string.gmatch(userInputTmp, "[^%s]+") do -- User input is split into an array via spaces
                                                                            userInput[numArgs] = token
                                                                            numArgs = numArgs + 1
                                                                        end
                                                                    end
                                                                        
                                                                    if not func then -- Function doesn't exist, fallback/die...
                                                                        if not fallbackFunc then -- No fallback, return false, and if desired, debug message.
                                                                            if LibSlashCmd.storage[commandName]['config']['debug'] then
                                                                                print("[Debug] Error. Function not found for: /" .. commandName .. " " .. args)
                                                                            end
                                                                            return
                                                                        else -- Set func as fallback.
                                                                            func = fallbackFunc
                                                                        end
                                                                    end
                                                                    
                                                                    -- userInput is sent to the function always, even if there is none.
                                                                    -- userInput is an array with keys that start at 0 and go up by 1 per user input.
                                                                    func(userInput)
                                                                end
                                                                ,addonName
                                                                ,'Slash Command'})
        if dbg then
            LibSlashCmd.storage[finalCommandName]['config']['debug'] = true
        end
    end
    
    if finalCommandName == nil then
        print("Fatal Error! Slash Command: /" .. commandName .. " already taken and no replacement could be found.")
    elseif finalCommandName ~= commandName then
        print("Error! Slash Command: /" .. commandName .. " already taken. Using Slash Command: /" .. finalCommandName .. " instead.")
    end
    
    return finalCommandName
end

-- Returns true/false for success/fail.
function LibSlashCmd.RegisterFunc(commandName, arg, func)
    if commandName == nil or not LibSlashCmd.storage[commandName] then -- If it's a nil commandName(i.e. Register failed) or it doesn't exist in our storage, then we won't do anything. Return an error message only if we are told to debug.
        return false
    end
    LibSlashCmd.storage[commandName]['funcs'][arg] = func
    if LibSlashCmd.storage[commandName]['config']['debug'] then
        print("[Debug] Specified function successfully registered for /" .. commandName .. " " .. arg)
    end
    return true
end

function LibSlashCmd.InvokeFunc(commandName, funcName, input)
    if commandName == nil or not LibSlashCmd.storage[commandName] then -- If it's a nil commandName(i.e. Register failed) or it doesn't exist in our storage, then we won't do anything. Return an error message only if we are told to debug.
        return false
    end
    
    input = input or ""
    
    local func = LibSlashCmd.storage[commandName]['funcs'][funcName]
    
    if not func then
        if LibSlashCmd.storage[commandName]['config']['debug'] then
            print("[Debug] Unable to invoke function name: " .. funcName .. ". Function not found.")
        end
        return false
    end
    
    local userInput = {}
    local token = nil
    local numArgs = 0
    for token in string.gmatch(input, "[^%s]+") do -- The input is split into an array via spaces
        userInput[numArgs] = token
        numArgs = numArgs + 1
    end
    
    func(userInput)
    return true
end
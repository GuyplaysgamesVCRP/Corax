local Commands = require "Corax/ClientCommands"

local function handleServerCommand(module, command, args)
    if module ~= "Corax" then return end

    if Commands[command] then
        local results = Commands[command](args)

        if results then
            sendClientCommand(module, command, results) 
        end
    end

end

Events.OnServerCommand.Add(handleServerCommand)
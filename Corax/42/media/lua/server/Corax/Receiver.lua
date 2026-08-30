local json = require "Corax/json"

local Receiver = {}

Receiver.counter = 0

---@param username string
---@return IsoPlayer?
function Receiver.GetPlayerByUsername(username)
    local players = getOnlinePlayers()

    if players == nil then
        return
    end

    for i = 0, players:size() - 1 do
        local player = players:get(i)

        if player and player:getUsername() == username then
            return player
        end
    end

    return
end

function Receiver.OnTick()

    local fileName = "c" .. tostring(Receiver.counter)
    local filePath = "Corax\\Calls\\" .. fileName .. ".json"

    local fileReader = getFileReader(filePath, false)
  
    if not fileReader then return end
  
    local jsonString = fileReader:readLine()
    fileReader:close()

    if not jsonString then return end

    local Data = json.parse(jsonString)

    local player = Receiver.GetPlayerByUsername(Data.username)

    if not player then return end

    Data.id = Receiver.counter

    sendServerCommand(player, "Corax", Data.command, Data)

    Receiver.counter = Receiver.counter + 1

end

local function handleClientCommand(module, _command, _player, args)

    if module ~= "Corax" then return end

    local fileName = "r" .. tostring(args.id)
    local filePath = "Corax\\Responses\\" .. fileName .. ".json"

    local fileWriter = getFileWriter(filePath, true, false)

    if not fileWriter then return end

    local jsonString = json.stringify(args)

    fileWriter:write(jsonString)
    fileWriter:close()

end

Events.OnClientCommand.Add(handleClientCommand)

Events.OnTick.Add(Receiver.OnTick)
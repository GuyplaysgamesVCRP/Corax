local Commands = {}

function Commands.foo(args)
    print("[Foo]: " .. args.message)

    local results = {
        id = args.id, 
        result = "Successfully sent message "..args.message,
    }

    return results
end

return Commands
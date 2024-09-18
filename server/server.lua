-- Register the server event 't_weed:giveWeed'
RegisterNetEvent('t_weed:giveWeed')
AddEventHandler('t_weed:giveWeed', function()
    local src = source  -- Get the player's server ID
    print('Attempting to give weed to player ID:', src)  -- Debugging print
    
    -- Add the item to the player's inventory using ox_inventory
    local success = exports.ox_inventory:AddItem(src, 'weed_purple-haze', 1)
    print('AddItem success:', success)  -- Debugging print

    if success then
        -- Notify the player that they received the item
        TriggerClientEvent('ox_lib:notify', src, {type = 'success', text = 'You received Purple Haze weed!'})
    else
        -- Notify the player that they couldn't receive the item
        TriggerClientEvent('ox_lib:notify', src, {type = 'error', text = 'Unable to give weed. Check your inventory space.'})
    end
end)


RegisterCommand('testserver', function(source, args, rawCommand)
    print("Server received test command from player ID:", source)
    TriggerClientEvent('ox_lib:notify', source, {type = 'success', text = 'Test command received on server!'})
end)
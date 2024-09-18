RegisterNetEvent('t_weed:giveWeed')
AddEventHandler('t_weed:giveWeed', function()
    local src = source
    print('Attempting to give weed to player ID:', src)

    local success = exports.ox_inventory:AddItem(src, 'weed_purple-haze', 1)
    print('AddItem success:', success)

    if success then
        TriggerClientEvent('ox_lib:notify', src, {type = 'success', text = 'You received Purple Haze weed!'})
    else
        TriggerClientEvent('ox_lib:notify', src, {type = 'error', text = 'Unable to give weed. Check your inventory space.'})
    end
end)

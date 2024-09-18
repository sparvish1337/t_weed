local weedPlants = {}
local maxPlants = 5
local radius = 25.0
local weedZone

function createWeedZone()
    local center = vector3(106.6880, -580.4558, 43.7973)

    weedZone = lib.zones.sphere({
        coords = center,
        radius = radius,
        debug = true,
    })

    spawnWeedPlants(weedZone)
end

function spawnWeedPlants(weedZone)
    local spawnedPlants = 0

    while spawnedPlants < maxPlants do
        local randomPos = getRandomPointInSphere(weedZone.coords, weedZone.radius)

        -- Find ground position
        local found, groundZ = GetGroundZFor_3dCoord(randomPos.x, randomPos.y, randomPos.z + 100.0, true)
        if found then
            randomPos = vector3(randomPos.x, randomPos.y, groundZ)

            local model = GetHashKey('prop_weed_02')
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(10)
            end

            local weedPlant = CreateObject(model, randomPos.x, randomPos.y, randomPos.z, false, false, false)
            PlaceObjectOnGroundProperly(weedPlant)
            FreezeEntityPosition(weedPlant, true)

            table.insert(weedPlants, weedPlant)

            exports.ox_target:addLocalEntity(weedPlant, {
                {
                    name = 'pick_weed',
                    label = 'Plocka',
                    icon = 'fas fa-leaf',
                    onSelect = function()
                        pickWeedPlant(weedPlant)
                    end
                }
            })

            spawnedPlants = spawnedPlants + 1
        end

        Wait(500)
    end
end

function getRandomPointInSphere(center, radius)
    local angle = math.random() * 2 * math.pi
    local distance = math.sqrt(math.random()) * radius
    local xOffset = math.cos(angle) * distance
    local yOffset = math.sin(angle) * distance
    return vector3(center.x + xOffset, center.y + yOffset, center.z)
end

function pickWeedPlant(plantEntity)
    local playerPed = PlayerPedId()

    TaskStartScenarioInPlace(playerPed, 'world_human_gardener_plant', 0, true)

    local success = lib.progressCircle({
        duration = 5000,
        position = 'bottom',
        useWhileDead = false,
        canCancel = false,
        label = 'Plockar...',
        disable = {
            car = true,
            move = true,
            combat = true,
            mouse = false
        }
    })

    ClearPedTasks(playerPed)

    if success then
        --ClearPedTasks(playerPed)

        SetEntityAsMissionEntity(plantEntity, true, true)
        DeleteObject(plantEntity)

        exports.qbx_core:Notify('You picked some weed!', 'success')

        print("Triggering the giveWeed event")

        TriggerServerEvent('t_weed:giveWeed')
    else
        print("Progress failed or canceled")
    end
end

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        for _, plant in pairs(weedPlants) do
            if DoesEntityExist(plant) then
                DeleteObject(plant)
            end
        end
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    spawnWeedPlants()
end)

RegisterCommand('spawnweedplants', function()
    createWeedZone()
end, false)

CreateThread(function()
    createWeedZone()
end)

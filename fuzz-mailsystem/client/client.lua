
local QBCore = exports["qb-core"]:GetCoreObject()
isBusy = false


if Config.StealMinigame == 'memorygame' then
    function MiniGame()
        local success = false
        local holdResult = true

        exports["memorygame"]:thermiteminigame(5, 3, 3, 15, function()
            success = true
            holdResult = false
        end, function()
            success = false
            holdResult = false
        end)

        while holdResult do Wait(100) end
        return success
    end
elseif Config.StealMinigame == 'qb-lock' then
    function MiniGame()
        local success = exports['qb-lock']:StartLockPickCircle(3, 10)
        return success or false
    end
elseif Config.StealMinigame == 'ps-ui' then
    function MiniGame()
        local success = false
        exports['ps-ui']:Circle(function(result)
            success = result
        end, 3, 10)
        return success
    end
elseif Config.StealMinigame and Config.StealMinigame ~= 'none' then
    print('[fuzz-mailsystem] Invalid minigame specified in config.lua')
end

function PoliceAlert()
    if Config.IsIllegal then
        if math.random(1,100) >= Config.StealAlertChance then return end
        if Config.DispatchType == 'ps-dispatch' then
            exports["ps-dispatch"]:CustomAlert({
                coords = GetEntityCoords(PlayerPedId()),
                message = Lang:t('police.message'),
                dispatchCode = Lang:t('police.code'),
                description = Lang:t('police.bliptitle'),
                radius = 0,
                sprite = 318,
                color = 1,
                scale = 0.5,
                length = 3,
            })
        elseif Config.DispatchType == 'qb-core' then
            TriggerServerEvent('police:server:policeAlert', Lang:t('police.bliptitle'))
        else
            print('[fuzz-mailsystem] Config.DispatchType does not have a valid argument')
        end
    end
end

function ProgressBar(ent)
    QBCore.Functions.Progressbar('diving_in_dumpster', Lang:t('progress.diving'), Config.ProgressBarTime * 1000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = 'anim@gangops@facility@servers@',
        anim = 'hotwire',
        flags = 1,
    }, {}, {}, function()
        if not NetworkGetEntityIsNetworked(ent) then NetworkRegisterEntityAsNetworked(ent) end
        TriggerServerEvent('fuzz-mailsystem:server:SetEntity', ObjToNet(ent), true)
        if not Config.ResetOnStorm then TriggerServerEvent('fuzz-mailsystem:server:ResetEntity', ObjToNet(ent)) end
        isBusy = false
        ClearPedTasks(PlayerPedId())
    end, function()
        isBusy = false
        ClearPedTasks(PlayerPedId())
    end)
end




-----------
----BIN----
-----------
CreateThread(function()
    exports['qb-target']:AddTargetModel(Config.MailBoxes, {
        options = {
            {
                label = Lang:t('target.label'),
                icon = 'fas fa-dumpster',
                action = function(ent)
                    QBCore.Functions.TriggerCallback('fuzz-mailsystem:server:getEntityState', function(wasMailStolen)
                        if not wasMailStolen then
                            isBusy = true
                            PoliceAlert()
                            if not Config.StealMinigame then
                                ProgressBar(ent)
                            else
                                local success = MiniGame()
                                if success then
                                    ProgressBar(ent)
                                else
                                    QBCore.Functions.Notify(Lang:t('notifies.failed_minigame'))
                                    isBusy = false
                                end
                            end
                        else
                            QBCore.Functions.Notify(Lang:t('notifies.already_dived'), 'error', 5000)
                        end
                    end, ObjToNet(ent))
                end,
                canInteract = function(ent)
                    return not isBusy
                end
            }
        },
        distance = 1.5
    })
end)

RegisterNetEvent('fuzz-mailsystem:client:ResetEntity', function(netId)
    if NetworkGetEntityIsNetworked(netId) then NetworkUnregisterNetworkedEntity(netId) end
end)

--PACKAGE OPENING EVENT
RegisterNetEvent('fuzz-mailsystem:Client:OpenStolenPackage', function(source)
    local boxcutter = Config.unboxitem
    local hasItem = QBCore.Functions.HasItem(boxcutter)
    if hasItem then
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "Stash", 0.25)
    QBCore.Functions.Progressbar('opening_packagebox', 'Opening Box', Config.ProgressBarInteger, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
    animDict = 'anim@gangops@facility@servers@',
        anim = 'hotwire',
        flags = 17,
    }, {}, {}, function() -- Play when Done
        ClearPedTasks(PlayerPedId())
        TriggerServerEvent('fuzz-mailsystem:Server:stolenpackagereward')
    end, function() -- Play When Cancel
        ClearPedTasks(PlayerPedId())
        end)
    else
     QBCore.Functions.Notify("You ruined the box, you didnt have a box cutter.", "error")
    end
end)

--SELLING SHIT HERE

CreateThread(function()
    local hash = Config.PedProps['hash']
    local coords = Config.PedProps['location']
    QBCore.Functions.LoadModel(hash)
    local buyerPed = CreatePed(0, hash, coords.x, coords.y, coords.z-1.0, coords.w, false, false)
	TaskStartScenarioInPlace(buyerPed, 'WORLD_HUMAN_CLIPBOARD', true)
	FreezeEntityPosition(buyerPed, true)
	SetEntityInvincible(buyerPed, true)
	SetBlockingOfNonTemporaryEvents(buyerPed, true)

    exports['qb-target']:AddTargetEntity(buyerPed, {
        options = {
            {
                icon = 'fas fa-circle',
                label = 'Check Items',
                action = function()
                    local pedPos = GetEntityCoords(PlayerPedId())
                    local dist = #(pedPos - vector3(coords))
                    if dist <= 5.0 then
                        ShowMenu()
                    end
                end,
            },
        },
        distance = 2.0
    })
end)

function ShowMenu()
    local resgisteredMenu = {
        id = 'item-menu',
        title = 'Sellable Items',
        options = {}
    }
    local options = {}
    for _, v in pairs(Config.Items) do
        local item = QBCore.Functions.HasItem(_)
        if item then
            options[#options+1] = {
                title = QBCore.Shared.Items[_]["label"],
                description = 'Cost: $'..v.price..' per',
                event = 'fuzz-mailsystem:giveinput',
                args = {
                    item = QBCore.Shared.Items[_]['name'],
                    price = v.price
                }
            }
        end
    end
    resgisteredMenu["options"] = options
    lib.registerContext(resgisteredMenu)
    lib.showContext('item-menu')
end

RegisterNetEvent('fuzz-mailsystem:giveinput', function (data)
    local header = 'Item: '..data.item
    local input = lib.inputDialog(header, {
        { type = 'input', label = 'Sell Amount', placeholder = '1' },
        { type = 'select', label = 'Payment Method', options = {
            { value = 'cash', label = 'Cash', icon = 'fas fa-wallet'},
            { value = 'bank', label = 'Bank', icon = 'fas fa-landmark'},
        }},
    })
    if input == nil then return end
    if input[1] ~= nil then
        if input[2] ~= nil then
            TriggerServerEvent('fuzz-mailsystem:sellitem',data.item, data.price, input[1], input[2])
        else
            QBCore.Functions.Notify('No selected payment method..', 'error', 4500)
        end
    else
        QBCore.Functions.Notify('No amount was given.', 'error', 4500)
    end
end)

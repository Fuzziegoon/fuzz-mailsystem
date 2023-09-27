local QBCore = exports['qb-core']:GetCoreObject()
local IsHired = false
local HasMail = false
local DeliveredCount = 0
local SentMail = false
local MailDelivered = false
local ownsMailTruck = false
local activeRoute = false


CreateThread(function()
    local mailjobBlip = AddBlipForCoord(vector3(Config.PMCoords.x, Config.PMCoords.y, Config.PMCoords.z)) 
    SetBlipSprite(mailjobBlip, 78)
    SetBlipAsShortRange(mailjobBlip, true)
    SetBlipScale(mailjobBlip, 0.6)
    SetBlipColour(mailjobBlip, 62)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Mail Office")
    EndTextCommandSetBlipName(mailjobBlip)
end)

function ClockInPed()

    if not DoesEntityExist(mailBoss) then

        RequestModel(Config.PMModel) while not HasModelLoaded(Config.PMModel) do Wait(0) end

        mailBoss = CreatePed(0, Config.PMModel, Config.PMCoords, false, false)
        
        SetEntityAsMissionEntity(mailBoss)
        SetPedFleeAttributes(mailBoss, 0, 0)
        SetBlockingOfNonTemporaryEvents(mailBoss, true)
        SetEntityInvincible(mailBoss, true)
        FreezeEntityPosition(mailBoss, true)
        loadAnimDict("amb@world_human_leaning@female@wall@back@holding_elbow@idle_a")        
        TaskPlayAnim(mailBoss, "amb@world_human_leaning@female@wall@back@holding_elbow@idle_a", "idle_a", 8.0, 1.0, -1, 01, 0, 0, 0, 0)

        exports['qb-target']:AddTargetEntity(mailBoss, { 
            options = {
                { 
                    type = "client",
                    event = "fuzz-mailsystem:mailboy:startRoute",
                    icon = "fa-solid fa-list",
                    label = "Start Route",
                    canInteract = function()
                        return not IsHired
                    end,
                },
                { 
                    type = "client",
                    event = "fuzz-mailsystem:mailboy:finishRoute",
                    icon = "fa-solid fa-list",
                    label = "Finish Route",
                    canInteract = function()
                        return IsHired
                    end,
                },
            }, 
            distance = 1.5, 
        })
    end
end

AddEventHandler('onResourceStart', function(resource)
    if GetCurrentResourceName() == resource then
        PlayerJob = QBCore.Functions.GetPlayerData().job
        ClockInPed()
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    ClockInPed()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    exports['qb-target']:RemoveZone("packageZone")
    RemoveBlip(JobBlip)
    IsHired = false
    HasMail = false
    DeliveredCount = 0
    SentMail = false
    MailDelivered = false
    ownsMailTruck = false
    activeRoute = false  
    DeletePed(mailBoss)
end)

AddEventHandler('onResourceStop', function(resourceName) 
	if GetCurrentResourceName() == resourceName then
        exports['qb-target']:RemoveZone("packageZone")
        RemoveBlip(JobBlip)
        IsHired = false
        HasMail = false
        DeliveredCount = 0
        SentMail = false
        MailDelivered = false
        ownsMailTruck = false
        activeRoute = false
        DeletePed(mailBoss)  
	end 
end)

CreateThread(function()
    DecorRegister("mail_job", 1)
end)

function PullOutVehicle()
    if ownsMailTruck then
        QBCore.Functions.Notify("You already have a mail vehicle! Go and collect it or end your job.", "error")
    else
        local coords = Config.MailVehicleSpawn
        QBCore.Functions.SpawnVehicle(Config.MailVehicle, function(mailTruck)
            SetVehicleNumberPlateText(mailTruck, "PIZZA"..tostring(math.random(1000, 9999)))
            SetVehicleColours(mailTruck, 111, 111)
            SetVehicleDirtLevel(mailTruck, 1)
            DecorSetFloat(mailTruck, "mail_job", 1)
            TaskWarpPedIntoVehicle(PlayerPedId(), mailTruck, -1)
            TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(mailTruck))
            SetVehicleEngineOn(mailTruck, true, true)
            exports[Config.FuelScript]:SetFuel(mailTruck, 100.0)
            exports['qb-target']:AddTargetEntity(mailTruck, {
                options = {
                    {
                        icon = "fa-solid fa-list",
                        label = "Take Package Out",
                        action = function(entity) TakeMailPackage() end,
                        canInteract = function() 
                            return IsHired and activeRoute and not HasMail
                        end,
                        
                    },
                },
                distance = 2.5
            })
        end, coords, true)
        IsHired = true
        ownsMailTruck = true
        NextMailRoute()
    end
end


RegisterNetEvent('fuzz-mailsystem:mailboy:startRoute', function()
    if not IsHired then
        PullOutVehicle()
    end
end)


RegisterNetEvent('fuzz-mailsystem:mailboy:deliverMail', function()
    if HasMail and IsHired and not MailDelivered then
        TriggerEvent('animations:client:EmoteCommandStart', {"knock"})
        MailDelivered = true
        QBCore.Functions.Progressbar("knock", "Delivering Package To Door", 7000, false, false, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function()
            DeliveredCount = DeliveredCount + 1
            RemoveBlip(JobBlip)
            exports['qb-target']:RemoveZone("packageZone")
            HasMail = false
            activeRoute = false
            MailDelivered = false
            DetachEntity(prop, 1, 1)
            DeleteObject(prop)
            Wait(1000)
            ClearPedSecondaryTask(PlayerPedId())
            QBCore.Functions.Notify("Package Delivered. Please wait for your next Route!", "success") 
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
            SetTimeout(5000, function()    
                NextMailRoute()
            end)
        end)
    else
        QBCore.Functions.Notify("You need the package from the car my dewd.", "error") 
    end
end)


function loadAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Wait(0)
	end
end

function TakeMailPackage()
    local player = PlayerPedId()
    local pos = GetEntityCoords(player)
    if not IsPedInAnyVehicle(player, false) then
        local ad = "anim@heists@box_carry@"
        local prop_name = 'prop_cs_cardbox_01'
        if DoesEntityExist(player) and not IsEntityDead(player) then
            if not HasMail then
                if #(pos - vector3(newRoute.x, newRoute.y, newRoute.z)) < 30.0 then
                    loadAnimDict(ad)
                    local x,y,z = table.unpack(GetEntityCoords(player))
                    prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
                    AttachEntityToEntity(prop, player, GetPedBoneIndex(player, 60309), 0.2, 0.08, 0.2, -45.0, 290.0, 0.0, true, true, false, true, 1, true)
                    TaskPlayAnim(player, ad, "idle", 3.0, -8, -1, 63, 0, 0, 0, 0 )
                    HasMail = true
                else
                    QBCore.Functions.Notify("You're not close enough to the front door", "error")
                end
            end
        end
    end
end


function NextMailRoute()
    if not activeRoute then
        newRoute = Config.JobRoutes [math.random(1, #Config.JobRoutes )]

        JobBlip = AddBlipForCoord(newRoute.x, newRoute.y, newRoute.z)
        SetBlipSprite(JobBlip, 1)
        SetBlipDisplay(JobBlip, 4)
        SetBlipScale(JobBlip, 0.8)
        SetBlipFlashes(JobBlip, true)
        SetBlipAsShortRange(JobBlip, true)
        SetBlipColour(JobBlip, 2)
        SetBlipRoute(JobBlip, true)
        SetBlipRouteColour(JobBlip, 2)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Next House")
        EndTextCommandSetBlipName(JobBlip)
        exports['qb-target']:AddCircleZone("packageZone", vector3(newRoute.x, newRoute.y, newRoute.z), 1.3,{ name = "packageZone", debugPoly = false, useZ=true, }, { options = { { type = "client", event = "fuzz-mailsystem:mailboy:deliverMail", icon = "fa-solid fa-list", label = "Deliver Package"}, }, distance = 1.5 })
        activeRoute = true
        QBCore.Functions.Notify("You have a new stop!", "success")
    end
end

RegisterNetEvent('fuzz-mailsystem:mailboy:finishRoute', function()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local veh = QBCore.Functions.GetClosestVehicle()
    local finishspot = vector3(Config.PMCoords.x, Config.PMCoords.y, Config.PMCoords.z)
    if #(pos - finishspot) < 10.0 then
        if IsHired then
            if DecorExistOn((veh), "mail_job") then
                QBCore.Functions.DeleteVehicle(veh)
                RemoveBlip(JobBlip)
                IsHired = false
                HasMail = false
                ownsMailTruck = false
                activeRoute = false
                if DeliveredCount > 0 then
                    TriggerServerEvent('fuzz-mailsystem:server:deliveritem', DeliveredCount)
                else
                    QBCore.Functions.Notify("You didn't complete any deliveries so you weren't paid.", "error")
                end
                DeliveredCount = 0
            else
                QBCore.Functions.Notify("You must return your mail truck to get paid.", "error")
                return
            end
        end
    end
end)


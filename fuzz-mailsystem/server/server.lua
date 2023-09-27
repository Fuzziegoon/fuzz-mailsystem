local entities = {}
QBCore = exports['qb-core']:GetCoreObject()

-----------
----BIN----
-----------
RegisterNetEvent('fuzz-mailsystem:server:ResetEntity', function(entity)
    entities[entity] = 0
end)

function EntityRespawn()
    if entities ~= nil or entities ~= {} then
        for _,t in pairs(entities) do
            entities[_] = t + 1
            if t >= 0 and t >= Config.ResetStormTime then
                entities[_] = -1
            end
        end
    end
    SetTimeout(60000, EntityRespawn)
end

if not Config.ResetOnStorm then
    EntityRespawn()
end

RegisterNetEvent('fuzz-mailsystem:server:SetEntity', function(netId, isFinished)
    entities[netId] = 0
    DropItem(isFinished, netId, source)
end)

local function pGive(playerId, item, amount)
    local Player = QBCore.Functions.GetPlayer(playerId)
    if not Player then return end
    if type(item) == 'string' then
        Player.Functions.AddItem(item, amount)
        TriggerClientEvent('inventory:client:ItemBox', source, item, 'add', amount)
        if QBCore.Shared.Items[i.item].label then
            local itemString = amount .. 'x ' .. QBCore.Shared.Items[i.item].label
            TriggerClientEvent('QBCore:Notify', playerId, Lang:t('notifies.you_got', {items = itemString}))
        else
            TriggerClientEvent('QBCore:Notify', playerId, Lang:t('notifies.you_got', {items = item}))
        end
    elseif type(item) == 'table' and amount == 10000 then
        local itemString = ''
        if #item <= 0 then TriggerClientEvent('QBCore:Notify', playerId, Lang:t('notifies.got_nothing')) return end
        for _,i in pairs(item) do
            Player.Functions.AddItem(i.item, i.amount)
            itemString = i.amount .. 'x ' .. QBCore.Shared.Items[i.item].label .. ', ' .. itemString
        end

        if itemString ~= '' then
            TriggerClientEvent('QBCore:Notify', playerId, Lang:t('notifies.you_got', {items = itemString}))
        else
            TriggerClientEvent('QBCore:Notify', playerId, Lang:t('notifies.got_nothing'))
        end
    end
end

function DropItem(finished, netId, playerId)
    local Player = QBCore.Functions.GetPlayer(playerId)
    if not Player then return end
    if not netId then return end
    if not finished then return end

    local totalChances = 0
    for _, tierData in pairs(Config.BoxLootTiers) do
        totalChances = totalChances + tierData.chances
    end

    local tierRoll = math.random(1, totalChances)
    local selectedTier = nil
    for tierName, tierData in pairs(Config.BoxLootTiers) do
        if tierRoll <= tierData.chances then
            selectedTier = tierData
            --print("Selected Tier:", tierName, "with roll:", tierRoll)
            break
        else
            tierRoll = tierRoll - tierData.chances
        end
    end

    if not selectedTier then
        --print("ERROR: No tier selected for loot drop")
        return
    end

    if Config.LootMultipleItems then
        local itemTable = {}
        local itemAmount = math.random(1, Config.MaxItemsLooted)

        for i = 1, itemAmount do
            local item = selectedTier.loottable[math.random(1, #selectedTier.loottable)]
            itemTable[#itemTable+1] = {item = item.item, amount = math.floor(math.random(item.min, item.max))}
        end

        return pGive(playerId, itemTable, 10000)
    else
        local item = selectedTier.loottable[math.random(1, #selectedTier.loottable)]
        return pGive(playerId, item.item, math.random(item.min, item.max))
    end
end

QBCore.Functions.CreateCallback('fuzz-mailsystem:server:getEntityState', function(source, cb, netId)
    if entities[netId] == -1 or entities[netId] == nil then cb(false) else cb(true) end
end)


QBCore.Functions.CreateCallback('server:checkItem', function(source, cb)
    local src = source
    local player = QBCore.Functions.GetPlayer(source)
    if player.Functions.GetItemByName('mailmancredentials') and player.Functions.GetItemByName('mailmancredentials').amount >= 1 then
      cb(true)
    else
      cb(false)
    end
  end)

AddEventHandler('onResourceStop', function(resName)
    if resName ~= GetCurrentResourceName() then return end
    for _,v in pairs(entities) do
        if v == -1 then
            TriggerClientEvent('fuzz-mailsystem:client:ResetEntity', -1, _)
        end
    end
end)



-- OPEN STOLEN PACKAGE EVENT--
QBCore.Functions.CreateUseableItem("stolenpackage", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    --if not Player.Functions.RemoveItem('stolenpackage') then return end
        TriggerClientEvent('fuzz-mailsystem:Client:OpenStolenPackage', src, item)
        Player.Functions.RemoveItem('stolenpackage')
        if Config.RemoveCutter then 
            local cutter = Config.unboxitem
            Player.Functions.RemoveItem(Config.unboxitem)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[cutter], "remove", 1)
        end
end)

-- PACKAGE REWARD EVENT --
RegisterNetEvent('fuzz-mailsystem:Server:stolenpackagereward', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local MaxRewards = Config.MaxRewards
    local RewardsTable = {}
    local TrackRewards = {}

    while #RewardsTable < MaxRewards do
        local Reward = Config.Rewards[math.random(#Config.Rewards)]
        if not TrackRewards[Reward.Name] then
            TrackRewards[Reward.Name] = true
            RewardsTable[#RewardsTable + 1] = { Name = Reward.Name, Amount = Reward.Amount }
        end
    end

    for _, Reward in ipairs(RewardsTable) do
        Player.Functions.AddItem(Reward.Name, Reward.Amount)
        local RewardData = QBCore.Shared.Items[Reward.Name]
        TriggerClientEvent('inventory:client:ItemBox', src, RewardData, 'add', 1)
    end
end)

--SELL ITEMS 
RegisterNetEvent('fuzz-mailsystem:sellitem', function(item, price, itemAmount, payMethod)
    local PlayerId = source
    local Player = QBCore.Functions.GetPlayer(PlayerId)
    if not item then return end
    if Player.Functions.RemoveItem(item, itemAmount, false) then
        local pay = itemAmount * price
        TriggerClientEvent('inventory:client:ItemBox', PlayerId, QBCore.Shared.Items[item], "remove", itemAmount)
        Player.Functions.AddMoney(payMethod, pay, 'Items Sold')
    end
end)

--DELIVERY JOB
RegisterServerEvent('fuzz-mailsystem:server:deliveritem', function(packagesDone)
	local src = source
    local payment = math.random(Config.PaymentLow,Config.PaymentHigh) * packagesDone
	local Player = QBCore.Functions.GetPlayer(source)
    local chance = math.random(1,100)
    packagesDone = tonumber(packagesDone)
    if packagesDone > 0 then
        Player.Functions.AddMoney("bank", payment)
        TriggerClientEvent("QBCore:Notify", source, "You received $"..payment, "success")
    end
    if chance >= Config.BonusItemChance then
        Player.Functions.AddItem(Config.BonusItem, 1)
		TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[Config.BonusItem], "add")
    end
end) 


AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  	return
	end
end)

AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  	return
	end
end)



--STEALING PACKAGE HERE



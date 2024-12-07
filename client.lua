local QBCore = exports['qb-core']:GetCoreObject()

RegisterCommand(Config.Command, function()
    QBCore.Functions.Notify('Checking your Discord role, please wait...', 'info')
    TriggerServerEvent('sb-boostreward:checkRole')
end, false)

RegisterNetEvent('sb-boostreward:client:rewardSuccess', function()
    QBCore.Functions.Notify(Config.Messages.RewardSuccess, 'success')
end)

RegisterNetEvent('sb-boostreward:client:noRole', function()
    QBCore.Functions.Notify(Config.Messages.NoRole, 'error')
end)

RegisterNetEvent('sb-boostreward:client:error', function()
    QBCore.Functions.Notify(Config.Messages.Error, 'error')
end)
